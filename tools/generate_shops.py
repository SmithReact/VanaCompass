#!/usr/bin/env python3
"""Generate VanaCompass's standard LandSandBoat shop catalog."""

from __future__ import annotations

import argparse
import json
import re
import time
import urllib.parse
import urllib.request
from collections import defaultdict
from pathlib import Path


def lua_quote(value: str) -> str:
    return "'" + value.replace('\\', '\\\\').replace("'", "\\'") + "'"


def name_key(value: str) -> str:
    return re.sub(r'[^a-z0-9]', '', value.lower())


def wiki_zone(value: str) -> str:
    value = value.replace('[S]', '(S)').strip()
    aliases = {
        'Batok Markets': 'Bastok Markets',
        'Southern San dOria': "Southern San d'Oria",
        'Southern SandOria (S)': "Southern San d'Oria (S)",
        'Tavnasian Safehold': 'Tavnazian Safehold',
        'Fort Karugo-Narugo': 'Fort Karugo-Narugo (S)',
    }
    return aliases.get(value, value)


def parse_constants(path: Path) -> tuple[dict[str, int], dict[int, str]]:
    values: dict[str, int] = {}
    reverse: dict[int, str] = {}
    for name, raw_id in re.findall(r'^\s*([A-Z][A-Z0-9_]*)\s*=\s*(\d+),', path.read_text(encoding='utf-8'), re.M):
        item_id = int(raw_id)
        values[name] = item_id
        reverse.setdefault(item_id, name)
    return values, reverse


def parse_sql_ids(path: Path, table: str) -> set[int]:
    pattern = re.compile(rf'^INSERT INTO `{re.escape(table)}` VALUES \((\d+),', re.M)
    return {int(value) for value in pattern.findall(path.read_text(encoding='utf-8'))}


def parse_zone_ids(path: Path) -> dict[str, int]:
    result: dict[str, int] = {}
    pattern = re.compile(
        r"^INSERT INTO `zone_settings` VALUES \((\d+),\d+,'[^']*',\d+,'([^']+)'",
        re.M,
    )
    for raw_id, internal in pattern.findall(path.read_text(encoding='utf-8')):
        result[name_key(internal)] = int(raw_id)
    return result


def parse_npcs(path: Path) -> dict[tuple[int, str], tuple[float, float, float]]:
    result: dict[tuple[int, str], tuple[float, float, float]] = {}
    pattern = re.compile(
        r"^INSERT INTO `npc_list` VALUES \((\d+),'((?:\\.|[^'])*)','((?:\\.|[^'])*)',"
        r"-?\d+,(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)",
        re.M,
    )
    for raw_id, internal, display, raw_x, raw_y, raw_z in pattern.findall(path.read_text(encoding='utf-8')):
        npc_id = int(raw_id)
        zone_id = (npc_id >> 12) & 0xFFF
        coords = (float(raw_x), float(raw_y), float(raw_z))
        result.setdefault((zone_id, name_key(internal.replace('\\\'', "'"))), coords)
        result.setdefault((zone_id, name_key(display.replace('\\\'', "'"))), coords)
    return result


def fetch_zone_npcs(zone: str, cache_dir: Path) -> dict[str, str]:
    cache_dir.mkdir(parents=True, exist_ok=True)
    cache_path = cache_dir / (re.sub(r'[^A-Za-z0-9._-]+', '_', zone) + '.txt')
    if cache_path.exists():
        text = cache_path.read_text(encoding='utf-8')
    else:
        query = urllib.parse.urlencode({
            'action': 'parse', 'page': wiki_zone(zone), 'prop': 'wikitext',
            'format': 'json', 'formatversion': 2,
        })
        request = urllib.request.Request(
            'https://www.bg-wiki.com/api.php?' + query,
            headers={'User-Agent': 'VanaCompass/0.1 personal addon generator'},
        )
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                payload = json.load(response)
            text = payload['parse']['wikitext']
            cache_path.write_text(text, encoding='utf-8')
            time.sleep(0.10)
        except Exception as exc:
            print(f'warning: could not fetch {zone}: {exc}')
            return {}

    result: dict[str, str] = {}
    current: str | None = None
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if line.startswith('|NPC.Name='):
            current = line.split('=', 1)[1].strip()
            current = re.sub(r'\[\[(?:[^]|]+\|)?([^]]+)\]\]', r'\1', current)
            current = re.sub(r'<[^>]+>', '', current).strip()
        elif current and line.startswith('|NPC.Position='):
            value = line.split('=', 1)[1].strip()
            match = re.search(r'([A-P](?:/[A-P])?-\d+)', value, re.I)
            if match:
                result[name_key(current)] = match.group(1).upper()
            current = None
    return result


def grid_xy(value: str | None) -> tuple[int | None, int | None]:
    if not value:
        return None, None
    match = re.match(r'([A-P])(?:/[A-P])?-(\d+)', value, re.I)
    if not match:
        return None, None
    return ord(match.group(1).upper()) - 64, int(match.group(2))


def parse_shops(
    zones_dir: Path,
    constants: dict[str, int],
    reverse_constants: dict[int, str],
    weapons: set[int],
    equipment: set[int],
    zone_ids: dict[str, int],
    npcs: dict[tuple[int, str], tuple[float, float, float]],
    cache_dir: Path,
) -> dict[int, dict[str, object]]:
    item_pattern = re.compile(
        r'\{\s*(?:(?:xi\.item\.([A-Z0-9_]+))|(\d+))\s*,\s*(\d+)(?:\s*,\s*(\d+))?'
    )
    catalog: dict[int, dict[str, object]] = {}
    coordinate_cache: dict[str, dict[str, str]] = {}

    shop_files: list[tuple[Path, str, str, int, list[tuple[int, int, int | None]]]] = []
    for path in zones_dir.glob('*/npcs/*.lua'):
        text = path.read_text(encoding='utf-8')
        if not re.search(r'xi\.shop\.(?:general|nation)\s*\(', text):
            continue
        area_match = re.search(r'^-- Area:\s*(.+?)\s*$', text, re.M)
        npc_match = re.search(r'^--\s+NPC:\s*(.+?)\s*$', text, re.M)
        area = area_match.group(1).strip() if area_match else path.parents[1].name.replace('_', ' ')
        npc_name = npc_match.group(1).strip() if npc_match else path.stem.replace('_', ' ')
        pos_match = re.search(r'^--\s*!pos\s+[-.\d]+\s+[-.\d]+\s+[-.\d]+\s+(\d+)\s*$', text, re.M)
        zone_id = int(pos_match.group(1)) if pos_match else zone_ids.get(name_key(path.parents[1].name), -1)

        rows: list[tuple[int, int, int | None]] = []
        for match in item_pattern.finditer(text):
            item_id = constants.get(match.group(1)) if match.group(1) else int(match.group(2))
            if item_id is not None:
                rows.append((item_id, int(match.group(3)), int(match.group(4)) if match.group(4) else None))
        if rows:
            shop_files.append((path, area, npc_name, zone_id, rows))

    for _, area, _, _, _ in shop_files:
        if area not in coordinate_cache:
            coordinate_cache[area] = fetch_zone_npcs(area, cache_dir)

    seen: set[tuple[int, str, int, int]] = set()
    for _, area, npc_name, zone_id, rows in shop_files:
        grid = coordinate_cache.get(area, {}).get(name_key(npc_name))
        gx, gy = grid_xy(grid)
        world = npcs.get((zone_id, name_key(npc_name)))

        for item_id, price, tier in rows:
            key = (item_id, name_key(npc_name), zone_id, price)
            if key in seen:
                continue
            seen.add(key)

            constant = reverse_constants.get(item_id, '')
            if constant.startswith('SCROLL_OF_'):
                category = 'scroll'
            elif item_id in weapons:
                category = 'weapon'
            elif item_id in equipment:
                category = 'armor'
            else:
                category = 'supply'

            item = catalog.setdefault(item_id, {'category': category, 'vendors': []})
            vendor: dict[str, object] = {
                'npc': npc_name,
                'zone': wiki_zone(area),
                'zoneId': zone_id,
                'price': price,
            }
            if grid:
                vendor['location'] = grid
                vendor['x'], vendor['y'] = gx, gy
            if world:
                vendor['wx'], vendor['wy'], vendor['wz'] = world
            if tier is not None:
                vendor['tier'] = tier
            item['vendors'].append(vendor)

    return catalog


def write_catalog(path: Path, catalog: dict[int, dict[str, object]]) -> None:
    lines = [
        '-- Generated from LandSandBoat shop scripts; do not hand-edit.',
        'return {',
    ]
    for item_id in sorted(catalog):
        item = catalog[item_id]
        lines.append(f"    [{item_id}] = {{ category = {lua_quote(str(item['category']))}, vendors = {{")
        for vendor in item['vendors']:
            values = [
                f"npc = {lua_quote(str(vendor['npc']))}",
                f"zone = {lua_quote(str(vendor['zone']))}",
                f"zoneId = {vendor['zoneId']}",
                f"price = {vendor['price']}",
            ]
            for key in ('location', 'x', 'y', 'wx', 'wy', 'wz', 'tier'):
                if key in vendor:
                    value = vendor[key]
                    values.append(f'{key} = {lua_quote(value) if isinstance(value, str) else value}')
            lines.append('        { ' + ', '.join(values) + ' },')
        lines.append('    } },')
    lines.extend(['}', ''])
    path.write_text('\n'.join(lines), encoding='utf-8')


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--server', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--cache', type=Path, required=True)
    args = parser.parse_args()

    constants, reverse = parse_constants(args.server / 'scripts/enum/item.lua')
    weapons = parse_sql_ids(args.server / 'sql/item_weapon.sql', 'item_weapon')
    equipment = parse_sql_ids(args.server / 'sql/item_equipment.sql', 'item_equipment')
    zone_ids = parse_zone_ids(args.server / 'sql/zone_settings.sql')
    npcs = parse_npcs(args.server / 'sql/npc_list.sql')
    catalog = parse_shops(
        args.server / 'scripts/zones', constants, reverse, weapons, equipment,
        zone_ids, npcs, args.cache,
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    write_catalog(args.output, catalog)

    counts: dict[str, int] = defaultdict(int)
    for item in catalog.values():
        counts[str(item['category'])] += 1
    print(f'Generated {len(catalog)} items and {sum(len(i["vendors"]) for i in catalog.values())} vendor rows: {dict(counts)}')


if __name__ == '__main__':
    main()
