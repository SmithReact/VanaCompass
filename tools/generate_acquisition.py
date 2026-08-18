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


def sql_value(value: str) -> str | int | float | None:
    if value == 'NULL':
        return None
    if len(value) >= 2 and value[0] == "'" and value[-1] == "'":
        return value[1:-1].replace("\\'", "'").replace('\\\\', '\\')
    try:
        return int(value)
    except ValueError:
        try:
            return float(value)
        except ValueError:
            return value


def sql_rows(path: Path, table: str) -> list[list[str | int | float | None]]:
    prefix = f'INSERT INTO `{table}` VALUES ('
    rows: list[list[str | int | float | None]] = []
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


def lua_number(value: float) -> str:
    result = f'{value:.3f}'.rstrip('0').rstrip('.')
    return '0' if result == '-0' else result


def coordinate_value(value: object) -> float | None:
    if isinstance(value, (int, float)):
        return float(value)
    text = str(value).replace(' ', '')
    # Some LandSandBoat spawn rows intentionally use simple arithmetic such
    # as -464.527-320. Accept only a sequence of signed decimal terms.
    if re.fullmatch(r'[+-]?\d+(?:\.\d+)?(?:[+-]\d+(?:\.\d+)?)*', text) is None:
        return None
    return sum(float(term) for term in re.findall(r'[+-]?\d+(?:\.\d+)?', text))


def split_lua_args(value: str) -> list[str]:
    result: list[str] = []
    current: list[str] = []
    depth = 0
    quote: str | None = None
    escaped = False
    for char in value:
        if escaped:
            current.append(char)
            escaped = False
        elif quote is not None and char == '\\':
            current.append(char)
            escaped = True
        elif char in {"'", '"'}:
            current.append(char)
            if quote == char:
                quote = None
            elif quote is None:
                quote = char
        elif quote is None and char in '({[':
            depth += 1
            current.append(char)
        elif quote is None and char in ')}]':
            depth -= 1
            current.append(char)
        elif quote is None and char == ',' and depth == 0:
            result.append(''.join(current).strip())
            current = []
        else:
            current.append(char)
    result.append(''.join(current).strip())
    return result


def lua_call_arguments(text: str, call_name: str) -> list[list[str]]:
    result: list[list[str]] = []
    pattern = re.compile(re.escape(call_name) + r'\s*\(')
    for match in pattern.finditer(text):
        start = match.end() - 1
        depth = 0
        quote: str | None = None
        escaped = False
        for index in range(start, len(text)):
            char = text[index]
            if escaped:
                escaped = False
            elif quote is not None and char == '\\':
                escaped = True
            elif char in {"'", '"'}:
                if quote == char:
                    quote = None
                elif quote is None:
                    quote = char
            elif quote is None and char == '(':
                depth += 1
            elif quote is None and char == ')':
                depth -= 1
                if depth == 0:
                    result.append(split_lua_args(text[start + 1:index]))
                    break
    return result


def lua_table_body(text: str, assignment: str) -> str | None:
    match = re.search(re.escape(assignment) + r'\s*=\s*\{', text)
    if match is None:
        return None
    start = match.end() - 1
    depth = 0
    quote: str | None = None
    escaped = False
    for index in range(start, len(text)):
        char = text[index]
        if escaped:
            escaped = False
        elif quote is not None and char == '\\':
            escaped = True
        elif char in {"'", '"'}:
            if quote == char:
                quote = None
            elif quote is None:
                quote = char
        elif quote is None and char == '{':
            depth += 1
        elif quote is None and char == '}':
            depth -= 1
            if depth == 0:
                return text[start + 1:index]
    return None


def duration_range(value: str) -> tuple[int, int] | None:
    text = value.strip()
    random_match = re.fullmatch(
        r'math\.randomInt\(\s*(\d+)\s*,\s*(\d+)\s*\)(?:\s*\*\s*(\d+(?:\s*\*\s*\d+)*))?',
        text,
    )
    if random_match:
        factor = 1
        if random_match.group(3):
            for part in random_match.group(3).split('*'):
                factor *= int(part.strip())
        return int(random_match.group(1)) * factor, int(random_match.group(2)) * factor
    hours_match = re.fullmatch(r'utils\.hours\(\s*(\d+)\s*\)', text)
    if hours_match:
        seconds = int(hours_match.group(1)) * 3600
        return seconds, seconds
    if re.fullmatch(r'\d+(?:\s*\*\s*\d+)*', text):
        seconds = 1
        for part in text.split('*'):
            seconds *= int(part.strip())
        return seconds, seconds
    return None


def parse_script_spawn_positions(
    server: Path,
    zone_folders: dict[str, int],
) -> dict[tuple[int, str], set[tuple[float, float, float]]]:
    result: dict[tuple[int, str], set[tuple[float, float, float]]] = defaultdict(set)
    position_pattern = re.compile(
        r'\{\s*x\s*=\s*([^,}]+),\s*y\s*=\s*([^,}]+),\s*z\s*=\s*([^,}]+)',
        re.S,
    )
    for folder, zone_id in zone_folders.items():
        mobs_dir = server / 'scripts/zones' / folder / 'mobs'
        if not mobs_dir.is_dir():
            continue
        for path in mobs_dir.glob('*.lua'):
            text = path.read_text(encoding='utf-8')
            body = lua_table_body(text, 'entity.spawnPoints')
            if body is None:
                continue
            key = (zone_id, name_key(path.stem))
            for match in position_pattern.finditer(body):
                position = tuple(coordinate_value(match.group(index)) for index in (1, 2, 3))
                if all(value is not None for value in position):
                    result[key].add(position)
    return dict(result)


def parse_spawn_methods(
    server: Path,
    zone_folders: dict[str, int],
    canonical_mobs: dict[tuple[int, str], str],
    retained_nms: dict[tuple[int, str], str],
) -> dict[int, dict[str, list[dict[str, object]]]]:
    methods: dict[int, dict[str, list[dict[str, object]]]] = defaultdict(lambda: defaultdict(list))
    seen: set[tuple[int, str, str, int, int, int]] = set()
    for folder, zone_id in zone_folders.items():
        mobs_dir = server / 'scripts/zones' / folder / 'mobs'
        if not mobs_dir.is_dir():
            continue
        for path in mobs_dir.glob('*.lua'):
            placeholder_key = name_key(path.stem)
            placeholder = canonical_mobs.get((zone_id, placeholder_key), display_name(path.stem))
            text = path.read_text(encoding='utf-8')
            for args in lua_call_arguments(text, 'xi.mob.phOnDespawn'):
                if len(args) < 4:
                    continue
                target_match = re.search(r'\.mob\.([A-Z0-9_]+)', args[1])
                if target_match is None:
                    continue
                target_key = name_key(target_match.group(1))
                target = retained_nms.get((zone_id, target_key))
                if target is None and target_key.endswith('ph'):
                    target = retained_nms.get((zone_id, target_key[:-2]))
                chance_value = coordinate_value(args[2])
                cooldown = duration_range(args[3])
                if target is None or chance_value is None:
                    continue
                chance = int(chance_value)
                minimum, maximum = cooldown or (0, 0)
                key = (zone_id, target, placeholder, chance, minimum, maximum)
                if key in seen:
                    continue
                seen.add(key)
                methods[zone_id][target].append({
                    'placeholder': placeholder,
                    'chance': chance,
                    'minimum': minimum,
                    'maximum': maximum,
                })
    for zone_methods in methods.values():
        for rows in zone_methods.values():
            rows.sort(key=lambda row: str(row['placeholder']).lower())
    return {zone_id: dict(rows) for zone_id, rows in methods.items()}


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


def build_catalog(server: Path, shops: Path, vendors: Path) -> tuple[dict[str, int], dict[int, int], dict[int, str], dict[int, dict[str, list[dict[str, object]]]], dict[int, list[dict[str, object]]], dict[int, list[dict[str, object]]]]:
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

    zone_rows = sql_rows(server / 'sql/zone_settings.sql', 'zone_settings')
    zones = {int(row[0]): display_name(row[4]) for row in zone_rows}
    zone_folders = {str(row[4]): int(row[0]) for row in zone_rows}
    spawn_groups: dict[tuple[int, int], dict[str, object]] = {}
    canonical_mobs: dict[tuple[int, str], str] = {}
    for row in sql_rows(server / 'sql/mob_spawn_points.sql', 'mob_spawn_points'):
        mob_id, group_id = int(row[0]), int(row[4])
        zone_id = (mob_id >> 12) & 0xFFF
        key = (zone_id, group_id)
        group = spawn_groups.setdefault(key, {
            'names': set(), 'min': 0, 'max': 0, 'positions': defaultdict(set),
        })
        name = display_name(row[3] or row[2])
        if name:
            group['names'].add(name)
            canonical_mobs.setdefault((zone_id, name_key(name)), name)
            x, height, ground_y = (coordinate_value(row[index]) for index in (7, 8, 9))
            # (0/1, 0/1, 0/1) is LandSandBoat's sentinel for monsters whose
            # position is selected dynamically (fishing, battlefield logic,
            # and similar scripts), not a useful map location.
            if x is not None and height is not None and ground_y is not None and not (
                abs(x) <= 1 and abs(height) <= 1 and abs(ground_y) <= 1
            ):
                group['positions'][name].add((x, height, ground_y))
        minimum, maximum = int(row[5]), int(row[6])
        if minimum > 0 and (group['min'] == 0 or minimum < group['min']):
            group['min'] = minimum
        if maximum > group['max']:
            group['max'] = maximum
    script_spawn_positions = parse_script_spawn_positions(server, zone_folders)

    drops_by_list: dict[int, set[int]] = defaultdict(set)
    for row in sql_rows(server / 'sql/mob_droplist.sql', 'mob_droplist'):
        drop_id, drop_type, item_id = int(row[0]), int(row[1]), int(row[4])
        if drop_type == 0 and item_id in items and item_id > 0:
            drops_by_list[drop_id].add(item_id)

    drops: dict[int, list[dict[str, object]]] = defaultdict(list)
    drop_seen: dict[int, dict[tuple[str, int, int, int, bool], dict[str, object]]] = defaultdict(dict)
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
                is_nm = pool_id in notorious_pools
                key = (monster, zone_id, minimum, maximum, is_nm)
                source = drop_seen[item_id].get(key)
                if source is None:
                    source = {
                        'monster': monster,
                        'zoneId': zone_id,
                        'zone': zones.get(zone_id, f'Zone {zone_id}'),
                        'min': minimum,
                        'max': maximum,
                        'isNm': is_nm,
                        'positions': set(),
                    }
                    drop_seen[item_id][key] = source
                    drops[item_id].append(source)
                if is_nm and spawn:
                    source['positions'].update(spawn['positions'].get(monster, set()))
                if is_nm:
                    source['positions'].update(
                        script_spawn_positions.get((zone_id, name_key(monster)), set())
                    )
    for rows in drops.values():
        for row in rows:
            row['positions'] = sorted(row['positions'])
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
    retained_nms = {
        (int(row['zoneId']), name_key(str(row['monster']))): str(row['monster'])
        for rows in drops.values() for row in rows if row['isNm']
    }
    spawn_methods = parse_spawn_methods(server, zone_folders, canonical_mobs, retained_nms)

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
    return spell_items, drop_items, {zone_id: zones[zone_id] for zone_id in used_zones}, spawn_methods, dict(drops), dict(recipes)


def write_catalog(path: Path, spell_items: dict[str, int], drop_items: dict[int, int], zones: dict[int, str], spawn_methods: dict[int, dict[str, list[dict[str, object]]]], drops: dict[int, list[dict[str, object]]], recipes: dict[int, list[dict[str, object]]]) -> None:
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
    lines.extend(['    },', '    spawnMethods = {'])
    for zone_id in sorted(spawn_methods):
        lines.append(f'        [{zone_id}] = {{')
        for monster in sorted(spawn_methods[zone_id], key=str.lower):
            lines.append(f'            [{lua_quote(monster)}] = {{')
            for method in spawn_methods[zone_id][monster]:
                lines.append(
                    '                { ' + ', '.join((
                        lua_quote(str(method['placeholder'])),
                        str(method['chance']),
                        str(method['minimum']),
                        str(method['maximum']),
                    )) + ' },'
                )
            lines.append('            },')
        lines.append('        },')
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
                if row['positions']:
                    positions = ', '.join(
                        '{ ' + ', '.join(lua_number(value) for value in position) + ' }'
                        for position in row['positions']
                    )
                    values.append('{ ' + positions + ' }')
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

    spell_items, drop_items, zones, spawn_methods, drops, recipes = build_catalog(
        args.server, args.shops, args.vendors
    )
    write_catalog(args.output, spell_items, drop_items, zones, spawn_methods, drops, recipes)
    print(
        f'Generated {len(spell_items)} spell-item links, '
        f'{sum(len(rows) for rows in drops.values())} retained monster sources, '
        f'{sum(len(rows) for rows in spawn_methods.values())} NM spawn guides, '
        f'{len(drop_items)} non-vendor equipment items, and '
        f'{sum(len(rows) for rows in recipes.values())} recipes for {len(recipes)} items.'
    )


if __name__ == '__main__':
    main()
