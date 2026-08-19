#!/usr/bin/env python3
"""Generate VanaCompass's compact vendor and Driftwood teleport catalogs."""

from __future__ import annotations

import argparse
import json
import re
import urllib.request
from pathlib import Path


LUA_STRING = r"'((?:\\.|[^'])*)'"

# Outposts are regional rather than zone-specific. Use them only as fallbacks
# for the outdoor zones in their region; an existing Home Point or Survival
# Guide in the requested zone remains preferable.
OUTPOST_ZONES = {
    'Ronfaure': ('East Ronfaure', 'West Ronfaure'),
    'Zulkheim': ('La Theine Plateau', 'Valkurm Dunes', 'Konschtat Highlands'),
    'Norvallen': ('Jugner Forest', 'Batallia Downs'),
    'Gustaberg': ('North Gustaberg', 'South Gustaberg'),
    'Derfland': ('Pashhow Marshlands', 'Rolanberry Fields'),
    'Sarutabaruta': ('East Sarutabaruta', 'West Sarutabaruta'),
    'Kolshushu': ('Tahrongi Canyon', 'Buburimu Peninsula'),
    'Aragoneu': ('Meriphataud Mountains', 'Sauromugue Champaign'),
    'Fauregandi': ('Beaucedine Glacier',),
    'Valdeaunia': ('Xarcabard',),
    'Qufim Island': ('Qufim Island',),
    "Li'Telor": ("The Sanctuary of Zi'Tah",),
    'Kuzotz': ('Eastern Altepa Desert', 'Western Altepa Desert'),
    'Vollbow': ('Cape Teriggan', 'Valley of Sorrows'),
    'Elshimo Lowlands': ('Yuhtunga Jungle',),
    'Elshimo Uplands': ('Yhoator Jungle',),
    "Tu'Lia": ("Ru'Aun Gardens",),
    'Tavnazian Archipelago': ('Lufaise Meadows', 'Misareaux Coast'),
}


def lua_unescape(value: str) -> str:
    return re.sub(r"\\([\\'])", lambda m: m.group(1), value)


def lua_quote(value: str) -> str:
    return "'" + value.replace("\\", "\\\\").replace("'", "\\'") + "'"


def normalize_zone(value: str) -> str:
    value = value.strip().replace('[S]', '(S)')
    value = value.replace('Riverne - Site #A01', 'Riverne - Site A01')
    value = value.replace('Riverne - Site #B01', 'Riverne - Site B01')
    return re.sub(r'\s+', ' ', value)


def split_vendor_zone(raw: str) -> tuple[str, str, int | None, int | None]:
    matches = list(re.finditer(r'\(([A-P])(?:/[A-P])?-(\d+)\)', raw, re.I))
    if not matches:
        return normalize_zone(raw), '', None, None

    match = matches[0]
    zone = raw[:match.start()].rstrip(' -(')
    location = raw[match.start():].strip()
    while location.count(')') > location.count('(') and location.endswith(')'):
        location = location[:-1]
    return normalize_zone(zone), location, ord(match.group(1).upper()) - 64, int(match.group(2))


def parse_vendors(path: Path) -> dict[str, list[dict[str, object]]]:
    spell_re = re.compile(r"^    \[" + LUA_STRING + r"\] = \{$")
    field_re = re.compile(r"^          (npc|zone|notes) = " + LUA_STRING + r",?$")
    result: dict[str, list[dict[str, object]]] = {}
    current_spell: str | None = None
    in_purchases = False
    current_vendor: dict[str, str] | None = None

    for line in path.read_text(encoding='utf-8').splitlines():
        spell_match = spell_re.match(line)
        if spell_match:
            current_spell = lua_unescape(spell_match.group(1))
            in_purchases = False
            current_vendor = None
            continue

        if current_spell is None:
            continue
        if line == '      purchased_from = {':
            in_purchases = True
            continue
        if not in_purchases:
            continue
        if line == '        {':
            current_vendor = {}
            continue
        if line == '        },' and current_vendor is not None:
            raw_zone = current_vendor.get('zone', '')
            zone, location, x, y = split_vendor_zone(raw_zone)
            result.setdefault(current_spell, []).append({
                'npc': current_vendor.get('npc', 'Unknown vendor'),
                'zone': zone,
                'location': location,
                'x': x,
                'y': y,
                'notes': current_vendor.get('notes', ''),
            })
            current_vendor = None
            continue
        if line == '      },':
            in_purchases = False
            continue

        field_match = field_re.match(line)
        if field_match and current_vendor is not None:
            current_vendor[field_match.group(1)] = lua_unescape(field_match.group(2))

    return result


def fetch_homepoint_coordinates(url: str) -> dict[tuple[str, int], tuple[int, int]]:
    request = urllib.request.Request(url, headers={'User-Agent': 'ScrollFinder/0.1 personal addon generator'})
    with urllib.request.urlopen(request, timeout=30) as response:
        payload = json.load(response)
    text = payload['parse']['wikitext']
    result: dict[tuple[str, int], tuple[int, int]] = {}
    zone: str | None = None

    for raw_line in text.splitlines():
        zone_match = re.match(r'^\*\[\[([^]|]+)', raw_line)
        if zone_match:
            zone = normalize_zone(zone_match.group(1))
            continue
        hp_match = re.match(r'^\*\*Home Point #(\d+)', raw_line)
        if not hp_match or zone is None:
            continue
        grids = re.findall(r'\(([A-P])(?:/[A-P])?-(\d+)\)', raw_line, re.I)
        if grids:
            letter, number = grids[-1]
            result[(zone, int(hp_match.group(1)))] = (ord(letter.upper()) - 64, int(number))

    return result


def parse_dwport(path: Path, hp_coords: dict[tuple[str, int], tuple[int, int]]) -> dict[str, list[dict[str, object]]]:
    section: str | None = None
    result: dict[str, list[dict[str, object]]] = {}
    entry_re = re.compile(
        r"^    \{ id =\s*(\d+),.*?(?:zone =\s*\d+, )?name = " + LUA_STRING + r".*?\},$"
    )

    for line in path.read_text(encoding='utf-8').splitlines():
        section_match = re.match(r'^catalog\.(hp|sg|op)\s*=', line)
        if section_match:
            section = section_match.group(1)
            continue
        if section and line == '}':
            section = None
            continue
        if section not in {'hp', 'sg', 'op'}:
            continue
        match = entry_re.match(line)
        if not match:
            continue

        entry_id = int(match.group(1))
        name = lua_unescape(match.group(2))
        if section == 'op':
            for zone in OUTPOST_ZONES.get(name, ()):
                # Outposts are fallbacks, not competitors for a direct
                # destination already present in the target zone.
                if zone not in result:
                    result[zone] = [{
                        'kind': 'op',
                        'id': entry_id,
                        'name': f'{name} Outpost',
                        'x': None,
                        'y': None,
                    }]
            continue
        if section == 'hp':
            hp_match = re.match(r'^(.*) #(\d+)$', name)
            if not hp_match:
                continue
            zone = normalize_zone(hp_match.group(1))
            number = int(hp_match.group(2))
            x, y = hp_coords.get((zone, number), (None, None))
        else:
            zone = normalize_zone(name)
            x, y = None, None

        result.setdefault(zone, []).append({
            'kind': section,
            'id': entry_id,
            'name': name,
            'x': x,
            'y': y,
            'group': (int(re.search(r'group =\s*(\d+)', line).group(1))
                      if section == 'sg' and re.search(r'group =\s*(\d+)', line) else None),
            'bit': (int(re.search(r'bit =\s*(\d+)', line).group(1))
                    if section == 'sg' and re.search(r'bit =\s*(\d+)', line) else None),
        })

    return result


def write_vendor_catalog(path: Path, vendors: dict[str, list[dict[str, object]]]) -> None:
    lines = ['-- Generated by tools/generate_catalog.py; do not hand-edit.', 'return {']
    for spell in sorted(vendors, key=str.lower):
        lines.append(f'    [{lua_quote(spell)}] = {{')
        for vendor in vendors[spell]:
            values = [
                f"npc = {lua_quote(str(vendor['npc']))}",
                f"zone = {lua_quote(str(vendor['zone']))}",
                f"location = {lua_quote(str(vendor['location']))}",
                f"notes = {lua_quote(str(vendor['notes']))}",
            ]
            if vendor['x'] is not None:
                values.extend([f"x = {vendor['x']}", f"y = {vendor['y']}"])
            lines.append('        { ' + ', '.join(values) + ' },')
        lines.append('    },')
    lines.extend(['}', ''])
    path.write_text('\n'.join(lines), encoding='utf-8')


def write_teleport_catalog(path: Path, teleports: dict[str, list[dict[str, object]]]) -> None:
    lines = ['-- Generated from DriftwoodXI dwport/catalog.lua and BG-Wiki Home Point coordinates.', 'return {']
    for zone in sorted(teleports, key=str.lower):
        lines.append(f'    [{lua_quote(zone)}] = {{')
        for entry in teleports[zone]:
            values = [
                f"kind = {lua_quote(str(entry['kind']))}",
                f"id = {entry['id']}",
                f"name = {lua_quote(str(entry['name']))}",
            ]
            if entry['x'] is not None:
                values.extend([f"x = {entry['x']}", f"y = {entry['y']}"])
            if entry.get('group') is not None:
                values.extend([f"group = {entry['group']}", f"bit = {entry['bit']}"])
            lines.append('        { ' + ', '.join(values) + ' },')
        lines.append('    },')
    lines.extend(['}', ''])
    path.write_text('\n'.join(lines), encoding='utf-8')


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--spell-info', type=Path, required=True)
    parser.add_argument('--dwport-catalog', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--homepoint-api', default=(
        'https://www.bg-wiki.com/api.php?action=parse&page=Home_Point&prop=wikitext&format=json&formatversion=2'
    ))
    args = parser.parse_args()

    args.output.mkdir(parents=True, exist_ok=True)
    vendors = parse_vendors(args.spell_info)
    hp_coords = fetch_homepoint_coordinates(args.homepoint_api)
    teleports = parse_dwport(args.dwport_catalog, hp_coords)
    write_vendor_catalog(args.output / 'vendors.lua', vendors)
    write_teleport_catalog(args.output / 'teleports.lua', teleports)
    print(f'Generated {len(vendors)} purchasable spells and {sum(map(len, vendors.values()))} vendor rows.')
    print(f'Generated {sum(map(len, teleports.values()))} Driftwood teleport destinations.')


if __name__ == '__main__':
    main()
