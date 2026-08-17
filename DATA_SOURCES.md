# Data source record

This file records the inputs used to generate the local VanaCompass evaluation
build. It is not a substitute for the upstream projects' license files.

## LandSandBoat

- Repository: https://github.com/LandSandBoat/server
- Commit: `baf0b36e1d2405467ef5ef82d52b8026d2aca7ae`
- License: GPL-3.0
- Inputs: `scripts/zones/**`, `scripts/enum/item.lua`, `sql/item_weapon.sql`,
  `sql/item_equipment.sql`, `sql/npc_list.sql`, and `sql/zone_settings.sql`
- Generated output: `data/shops.lua`

## DriftwoodXI local addons

- `dwport/catalog.lua` supplies Driftwood's public teleport type and ID mapping.
- `dwtracker/data/*_quests.lua` and its supported nation/Zilart mission files
  supply the guide text copied into `data/quests/` and `data/missions/`.
- `data/quest_starts.lua` is generated from each quest guide's introduction.
  Explicit overrides distinguish NPCs from doors, objects, buildings,
  conversation chains, and zone-entry triggers; two missing coordinates were
  completed from the corresponding LandSandBoat quest/NPC scripts.
- `data/mission_starts.lua` recommends Ambrotien, Rashid, and Mokyokyo as
  precisely located nation mission guards, using their LandSandBoat NPC
  scripts. Zilart starter contacts are taken from the Driftwood mission guide
  introductions and corresponding standard mission scripts.
- Permission from the Driftwood authors is required before redistribution.

## FFXIMissingSpells

- Repository: https://github.com/mullerdane85-hash/FFXIMissingSpells
- License: BSD 3-Clause; reproduced in `THIRD_PARTY_LICENSE.txt`
- Generated output: `data/vendors.lua`

## BG-Wiki

- Site: https://www.bg-wiki.com/ffxi/
- Inputs: map-grid coordinates from relevant zone and Home Point pages
- Generated outputs: map coordinates in `data/shops.lua` and
  `data/teleports.lua`
