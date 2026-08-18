# Changelog

## 0.12.5

- Added a prominent Tenshodo membership requirement to every Amalasanda and
  Jabbar vendor row. The note points players to the Tenshodo Membership quest
  in Lower Jeuno while leaving unrestricted alternate vendors distinct.

## 0.12.4

- Changed the fresh-install tab layout to Welcome and Spells only. Existing
  saved tab visibility choices remain unchanged, and Show all tabs restores
  the complete interface at any time.
- Added Category and Type dropdown filters to Drops. Type choices adapt to the
  selected category and include weapon classes and armor equipment slots.
- Combined the separate Weapons and Armor tabs into Vendor Gear with its own
  category selector. Existing visibility settings migrate automatically.

## 0.12.3

- Turned the Welcome tab into the addon's settings page with persistent
  visibility toggles for Spells, Weapons, Armor, Supplies, Drops, Quests, and
  Main Story. Welcome always remains visible so hidden tabs can be restored.
- Added Show all tabs and Spells only presets for quick layout changes.
- Moved the Signet, Conquest Point, and EXP ring guide into a NEW PLAYER bar
  that is collapsed by default.

## 0.12.2

- Added verified map grids and exact `!pos` values to NM monster sources when
  LandSandBoat provides a fixed spawn position.
- Multi-spawn and lottery NMs show a rough multi-grid area and expose up to
  eight exact known positions in a hover tooltip.
- Added script-derived lottery instructions for supported NMs, including the
  specific placeholder family, chance per qualifying despawn, and minimum
  respawn window. Guidance explicitly warns that clearing every monster of
  that family is unnecessary.
- Retained `Grid unavailable` for spawn records on ambiguous multi-map pages
  instead of guessing the wrong dungeon floor.

## 0.12.1

- Added regional Outposts from Driftwood's `dwport` catalog as fallbacks when
  a field zone has no direct Home Point or Survival Guide destination.
- South Gustaberg drop sources now offer Gustaberg Outpost instead of showing
  `No direct port`; East Ronfaure and East Sarutabaruta receive their regional
  outposts as well.

## 0.12.0

- Added a searchable Drops tab containing monster-dropped weapons and armor
  that are absent from VanaCompass's standard vendor catalog. Spells,
  materials, and quest-objective items are intentionally excluded.
- Added each item's lowest known monster level to every Drops category, with
  Name and Level sorting.
- Added collapsible monster locations to existing purchase details, with
  monster levels and nearest safe ports. Large source lists are paged to keep
  rendering cost bounded.
- Added collapsible synthesis recipes with craft levels, crystals,
  ingredients, yields, and key-item requirement warnings.
- Extended purchase-tab searches so a monster or drop zone can locate the
  relevant items and spell scrolls.
- Added a reproducible, normalized LandSandBoat acquisition-data generator;
  drop rates are intentionally omitted and server customizations are clearly
  identified.

## 0.11.2

- Made the Spells filter toolbar responsive so the Show all jobs / levels
  control and its label wrap cleanly when the window is narrowed.
- Added multi-map grid calibration for Crawler's Nest, including its 80-unit
  cells and separate entrance, north, and south/apparatus coordinate regions.
- Virtualized the spell browser so the complete catalog only renders visible
  rows instead of submitting hundreds of wrapped controls every frame.
- Cached the filtered spell view and missing-scroll bill so the complete
  catalog is no longer scanned, allocated, and sorted every rendered frame.
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
