#!/usr/bin/env python3
"""Generate compact drop and synthesis indexes for VanaCompass.

The output uses compact positional rows for non-vendor equipment and alternate
purchase sources so it can be searched in game without duplicating field names.
"""

from __future__ import annotations

import argparse
import re
from collections import defaultdict
from pathlib import Path


CRAFTS = (
    'Woodworking', 'Smithing', 'Goldsmithing', 'Clothcraft',
    'Leathercraft', 'Bonecraft', 'Alchemy', 'Cooking',
)

def lua_quote(value: str) -> str:
    return "'" + value.replace('\\', '\\\\').replace("'", "\\'") + "'"


def name_key(value: str) -> str:
    return re.sub(r'[^a-z0-9]', '', value.lower())


def split_sql_values(value: str) -> list[str]:
    result: list[str] = []
    current: list[str] = []
    quoted = False
    escaped = False
    for char in value:
        if escaped:
            current.append(char)
            escaped = False
        elif char == '\\' and quoted:
            current.append(char)
            escaped = True
        elif char == "'":
            current.append(char)
            quoted = not quoted
        elif char == ',' and not quoted:
            result.append(''.join(current).strip())
            current = []
        else:
            current.append(char)
    result.append(''.join(current).strip())
    return result


def sql_value(value: str) -> str | int | None:
    if value == 'NULL':
        return None
    if len(value) >= 2 and value[0] == "'" and value[-1] == "'":
        return value[1:-1].replace("\\'", "'").replace('\\\\', '\\')
    try:
        return int(value)
    except ValueError:
        return value


def sql_rows(path: Path, table: str) -> list[list[str | int | None]]:
    prefix = f'INSERT INTO `{table}` VALUES ('
    rows: list[list[str | int | None]] = []
    for line in path.read_text(encoding='utf-8').splitlines():
        if not line.startswith(prefix):
            continue
        end = line.find(');', len(prefix))
        if end >= 0:
            raw = line[len(prefix):end]
            rows.append([sql_value(value) for value in split_sql_values(raw)])
    return rows


def display_name(value: object) -> str:
    return str(value or '').replace('_', ' ').strip()


def parse_spell_items(vendors: Path, items: dict[int, tuple[str, str]]) -> dict[str, int]:
    vendor_text = vendors.read_text(encoding='utf-8')
    spell_names = {
        name_key(value.replace("\\'", "'"))
        for value in re.findall(r"^\s*\['((?:\\.|[^'])+)'\]\s*=\s*\{", vendor_text, re.M)
    }
    item_names: dict[str, int] = {}
    for item_id, (internal, sort_name) in items.items():
        item_names.setdefault(name_key(sort_name), item_id)
        if internal.startswith('scroll_of_'):
            item_names.setdefault(name_key(internal.removeprefix('scroll_of_')), item_id)
    spell_items = {key: item_names[key] for key in spell_names if key in item_names}
    return spell_items


def parse_vendor_items(shops: Path) -> set[int]:
    return {
        int(value)
        for value in re.findall(r'^\s*\[(\d+)\]\s*=\s*\{', shops.read_text(encoding='utf-8'), re.M)
    }


def build_catalog(server: Path, shops: Path, vendors: Path) -> tuple[dict[str, int], dict[int, int], dict[int, str], dict[int, list[dict[str, object]]], dict[int, list[dict[str, object]]]]:
    item_rows = sql_rows(server / 'sql/item_basic.sql', 'item_basic')
    items = {int(row[0]): (str(row[2]), str(row[3])) for row in item_rows}
    item_rows_by_id = {int(row[0]): row for row in item_rows}
    spell_items = parse_spell_items(vendors, items)
    vendor_ids = parse_vendor_items(shops)
    weapon_ids = {int(row[0]) for row in sql_rows(server / 'sql/item_weapon.sql', 'item_weapon')}
    armor_ids = {int(row[0]) for row in sql_rows(server / 'sql/item_equipment.sql', 'item_equipment')}
    notorious_pools = {
        int(row[0]) for row in sql_rows(server / 'sql/mob_pools.sql', 'mob_pools')
        if int(row[14]) & 0x02
    }

    zones = {
        int(row[0]): display_name(row[4])
        for row in sql_rows(server / 'sql/zone_settings.sql', 'zone_settings')
    }
    spawn_groups: dict[tuple[int, int], dict[str, object]] = {}
    for row in sql_rows(server / 'sql/mob_spawn_points.sql', 'mob_spawn_points'):
        mob_id, group_id = int(row[0]), int(row[4])
        zone_id = (mob_id >> 12) & 0xFFF
        key = (zone_id, group_id)
        group = spawn_groups.setdefault(key, {'names': set(), 'min': 0, 'max': 0})
        name = display_name(row[3] or row[2])
        if name:
            group['names'].add(name)
        minimum, maximum = int(row[5]), int(row[6])
        if minimum > 0 and (group['min'] == 0 or minimum < group['min']):
            group['min'] = minimum
        if maximum > group['max']:
            group['max'] = maximum

    drops_by_list: dict[int, set[int]] = defaultdict(set)
    for row in sql_rows(server / 'sql/mob_droplist.sql', 'mob_droplist'):
        drop_id, drop_type, item_id = int(row[0]), int(row[1]), int(row[4])
        if drop_type == 0 and item_id in items and item_id > 0:
            drops_by_list[drop_id].add(item_id)

    drops: dict[int, list[dict[str, object]]] = defaultdict(list)
    drop_seen: dict[int, set[tuple[str, int, int, int, bool]]] = defaultdict(set)
    for row in sql_rows(server / 'sql/mob_groups.sql', 'mob_groups'):
        group_id, pool_id, zone_id = int(row[0]), int(row[1]), int(row[2])
        group_name, drop_id = display_name(row[3]), int(row[6])
        if drop_id not in drops_by_list:
            continue
        spawn = spawn_groups.get((zone_id, group_id))
        names = sorted(spawn['names']) if spawn and spawn['names'] else [group_name]
        minimum = int(spawn['min']) if spawn else 0
        maximum = int(spawn['max']) if spawn else 0
        for item_id in drops_by_list[drop_id]:
            for monster in names:
                key = (monster, zone_id, minimum, maximum, pool_id in notorious_pools)
                if key in drop_seen[item_id]:
                    continue
                drop_seen[item_id].add(key)
                drops[item_id].append({
                    'monster': monster,
                    'zoneId': zone_id,
                    'zone': zones.get(zone_id, f'Zone {zone_id}'),
                    'min': minimum,
                    'max': maximum,
                    'isNm': pool_id in notorious_pools,
                })
    for rows in drops.values():
        rows.sort(key=lambda row: (str(row['zone']).lower(), str(row['monster']).lower(), int(row['min'])))

    magic_categories = {'@WHITE_MAGIC', '@BLACK_MAGIC', '@SUMMONING', '@NINJUTSU', '@SONGS'}

    def item_category(item_id: int) -> int:
        item_row = item_rows_by_id[item_id]
        if item_id in weapon_ids:
            return 2
        if item_id in armor_ids:
            return 3
        if str(item_row[8]) in magic_categories or '@FLAG_SCROLL' in str(item_row[7]):
            return 1
        return 4

    # The dedicated browser intentionally contains only equipment that has a
    # monster source and is absent from VanaCompass's generated vendor catalog.
    drop_items = {
        item_id: item_category(item_id)
        for item_id in drops
        if item_id not in vendor_ids and item_category(item_id) in (2, 3)
    }

    # Preserve alternate monster sources on existing purchase detail pages,
    # without shipping unrelated materials or quest-objective item drops.
    source_item_ids = set(drop_items)
    source_item_ids.update(vendor_ids.intersection(drops))
    source_item_ids.update(set(spell_items.values()).intersection(drops))
    drops = {item_id: drops[item_id] for item_id in source_item_ids}

    recipes: dict[int, list[dict[str, object]]] = defaultdict(list)
    for row in sql_rows(server / 'sql/synth_recipes.sql', 'synth_recipes'):
        if int(row[1]) != 0:
            continue
        result_id = int(row[21])
        if result_id not in items:
            continue
        skills = [
            f'{craft} {int(row[index + 3])}'
            for index, craft in enumerate(CRAFTS) if int(row[index + 3]) > 0
        ]
        ingredient_counts: dict[int, int] = defaultdict(int)
        for raw_id in row[13:21]:
            ingredient_id = int(raw_id)
            if ingredient_id > 0:
                ingredient_counts[ingredient_id] += 1
        recipes[result_id].append({
            'craft': ' / '.join(skills) if skills else 'Unskilled synthesis',
            'crystal': int(row[11]),
            'ingredients': sorted(ingredient_counts.items()),
            'resultQty': int(row[25]),
            'keyItem': int(row[2]),
        })
    used_zones = {int(row['zoneId']) for rows in drops.values() for row in rows}
    return spell_items, drop_items, {zone_id: zones[zone_id] for zone_id in used_zones}, dict(drops), dict(recipes)


def write_catalog(path: Path, spell_items: dict[str, int], drop_items: dict[int, int], zones: dict[int, str], drops: dict[int, list[dict[str, object]]], recipes: dict[int, list[dict[str, object]]]) -> None:
    lines = [
        '-- Generated from LandSandBoat SQL by tools/generate_acquisition.py; do not hand-edit.',
        'return {',
        '    spellItems = {',
    ]
    for name in sorted(spell_items):
        lines.append(f'        [{lua_quote(name)}] = {spell_items[name]},')
    lines.extend(['    },', '    dropItems = {'])
    for item_id in sorted(drop_items):
        lines.append(f'        [{item_id}] = {drop_items[item_id]},')
    lines.extend(['    },', '    zones = {'])
    for zone_id in sorted(zones):
        lines.append(f'        [{zone_id}] = {lua_quote(zones[zone_id])},')
    lines.extend(['    },', '    drops = {'])
    for item_id in sorted(drops):
        lines.append(f'        [{item_id}] = {{')
        for row in drops[item_id]:
            values = [lua_quote(str(row['monster'])), str(row['zoneId'])]
            if row['min']:
                values.extend([str(row['min']), str(row['max'])])
            if row['isNm']:
                while len(values) < 4:
                    values.append('0')
                values.append('1')
            lines.append('            { ' + ', '.join(values) + ' },')
        lines.append('        },')
    lines.extend(['    },', '    recipes = {'])
    for item_id in sorted(recipes):
        lines.append(f'        [{item_id}] = {{')
        for recipe in recipes[item_id]:
            ingredients = ', '.join(f'{{ {item_id}, {count} }}' for item_id, count in recipe['ingredients'])
            values = [
                f"craft = {lua_quote(str(recipe['craft']))}",
                f"crystal = {recipe['crystal']}",
                f'ingredients = {{ {ingredients} }}',
                f"resultQty = {recipe['resultQty']}",
            ]
            if recipe['keyItem']:
                values.append(f"keyItem = {recipe['keyItem']}")
            lines.append('            { ' + ', '.join(values) + ' },')
        lines.append('        },')
    lines.extend(['    },', '}', ''])
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text('\n'.join(lines), encoding='utf-8')


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--server', type=Path, required=True)
    parser.add_argument('--shops', type=Path, required=True)
    parser.add_argument('--vendors', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()

    spell_items, drop_items, zones, drops, recipes = build_catalog(args.server, args.shops, args.vendors)
    write_catalog(args.output, spell_items, drop_items, zones, drops, recipes)
    print(
        f'Generated {len(spell_items)} spell-item links, '
        f'{sum(len(rows) for rows in drops.values())} retained monster sources, '
        f'{len(drop_items)} non-vendor equipment items, and '
        f'{sum(len(rows) for rows in recipes.values())} recipes for {len(recipes)} items.'
    )


if __name__ == '__main__':
    main()
