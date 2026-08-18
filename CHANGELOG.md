# Changelog

## 0.11.2

- Made the Spells filter toolbar responsive so the Show all jobs / levels
  control and its label wrap cleanly when the window is narrowed.
- Added multi-map grid calibration for Crawler's Nest, including its 80-unit
  cells and separate entrance, north, and south/apparatus coordinate regions.
- Virtualized the spell browser so the complete catalog only renders visible
  rows instead of submitting hundreds of wrapped controls every frame.
- Added a 74-zone, 103-map-page calibration catalog, enabling safe single-map
  coverage while retaining safeguards for unverified internal dungeon pages.

## 0.11.1

- Corrected Ashita spell-resource type mappings so Black Magic, Summoning,
  Ninjutsu, Bard Song, Blue Magic, and Geomancy filter into the proper groups.
- Added responsive wrapping to vendor tables, ports, equipment requirements,
  guide headings, status explanations, and other long detail text.
- Added a filter-aware missing-scroll Gil total using each spell's cheapest
  listed Gil vendor.

## 0.11.0

- Added a scrollable new-player Signet, Conquest Point, and EXP-ring guide.
- Added an in-game `Cast Signet now` button.
- Added server-reported current-step highlighting for quests and missions.
- Audited vendor-backed map calibration and added verified overrides for
  Lower Jeuno, Port Jeuno, Rabao, Norg, Bastok Markets [S], and both versions
  of Windurst Waters.
- Added collapsible result panes, responsive layouts, and detail scrollbars.

## Earlier development

- Added spells, weapons, armor, supplies, quests, main story, artifact quests,
  job unlock chains, completion sync, ports, launcher palette integration, and
  live location display during the initial private development cycle.
