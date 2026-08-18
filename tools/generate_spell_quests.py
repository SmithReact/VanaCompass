#!/usr/bin/env python3
"""Generate spell-scroll quest reward links for VanaCompass."""

from __future__ import annotations

import argparse
import re
from collections import defaultdict
from pathlib import Path


GUIDES = (
    ('sandoria_quests.lua', 0, "San d'Oria"),
    ('bastok_quests.lua', 1, 'Bastok'),
    ('windurst_quests.lua', 2, 'Windurst'),
    ('jeuno_quests.lua', 3, 'Jeuno'),
    ('otherareas_quests.lua', 4, 'Other Areas'),
    ('outlands_quests.lua', 5, 'Outlands'),
)


def lua_quote(value: str) -> str:
    return "'" + value.replace('\\', '\\\\').replace("'", "\\'") + "'"


def parse_items(path: Path) -> dict[str, int]:
    text = path.read_text(encoding='utf-8')
    return {
        name: int(item_id)
        for name, item_id in re.findall(r'^\s*(SCROLL_OF_[A-Z0-9_]+)\s*=\s*(\d+),', text, re.M)
    }


def parse_guides(path: Path) -> dict[str, dict[str, object]]:
    guides: dict[str, dict[str, object]] = {}
    entry_pattern = re.compile(r'^\s*\[(\d+)\]\s*=\s*\{\s*--\s*([A-Z0-9_]+)', re.M)
    for filename, log_id, area in GUIDES:
        text = (path / filename).read_text(encoding='utf-8')
        matches = list(entry_pattern.finditer(text))
        for index, match in enumerate(matches):
            end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
            block = text[match.start():end]
            name_match = re.search(r'^\s*name\s*=\s*(["\'])(.*?)\1,', block, re.M)
            if name_match is None or re.search(r'^\s*steps\s*=\s*\{', block, re.M) is None:
                continue
            guides[match.group(2)] = {
                'log': log_id,
                'id': int(match.group(1)),
                'name': name_match.group(2),
                'area': area,
            }
    return guides


def parse_rewards(path: Path, item_ids: dict[str, int],
                  guides: dict[str, dict[str, object]]) -> dict[int, list[dict[str, object]]]:
    rewards: dict[int, list[dict[str, object]]] = defaultdict(list)
    seen: set[tuple[int, int, int]] = set()
    for script in path.rglob('*.lua'):
        text = script.read_text(encoding='utf-8')
        quest_match = re.search(
            r'Quest:new\(xi\.questLog\.[A-Z0-9_]+,\s*xi\.quest\.id\.[a-zA-Z0-9_]+\.([A-Z0-9_]+)\)',
            text,
        )
        reward_match = re.search(r'quest\.reward\s*=\s*\{(.*?)\n\}', text, re.S)
        if quest_match is None or reward_match is None:
            continue
        guide = guides.get(quest_match.group(1))
        if guide is None:
            continue
        for item_name in re.findall(r'xi\.item\.(SCROLL_OF_[A-Z0-9_]+)', reward_match.group(1)):
            item_id = item_ids.get(item_name)
            if item_id is None:
                continue
            key = (item_id, int(guide['log']), int(guide['id']))
            if key in seen:
                continue
            seen.add(key)
            rewards[item_id].append(guide)
    for rows in rewards.values():
        rows.sort(key=lambda row: (str(row['area']).lower(), str(row['name']).lower()))
    return dict(rewards)


def write_output(path: Path, rewards: dict[int, list[dict[str, object]]]) -> None:
    lines = [
        '-- Generated from LandSandBoat quest rewards by tools/generate_spell_quests.py; do not hand-edit.',
        'return {',
    ]
    for item_id in sorted(rewards):
        lines.append(f'    [{item_id}] = {{')
        for row in rewards[item_id]:
            lines.append('        { ' + ', '.join((
                f"log = {row['log']}",
                f"id = {row['id']}",
                f"name = {lua_quote(str(row['name']))}",
                f"area = {lua_quote(str(row['area']))}",
            )) + ' },')
        lines.append('    },')
    lines.extend(['}', ''])
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text('\n'.join(lines), encoding='utf-8')


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--server', type=Path, required=True)
    parser.add_argument('--quests', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()

    item_ids = parse_items(args.server / 'scripts/enum/item.lua')
    guides = parse_guides(args.quests)
    rewards = parse_rewards(args.server / 'scripts/quests', item_ids, guides)
    write_output(args.output, rewards)
    print(f'Generated {sum(len(rows) for rows in rewards.values())} quest links for {len(rewards)} spell scrolls.')


if __name__ == '__main__':
    main()
