# Contributing

Thanks for helping make VanaCompass more useful and accurate.

## Good contributions

- Reproducible vendor or price corrections from the current DriftwoodXI era
- Exact NPC positions accompanied by zone and map-grid information
- Quest-step corrections confirmed against current server behavior
- Ashita 4 compatibility and layout fixes
- Focused documentation improvements

## Bug reports

Please include:

1. VanaCompass version
2. Zone and character context
3. The affected spell, item, quest, mission, vendor, or teleport
4. Expected and actual behavior
5. Exact `!pos`, grid, screenshot, or Ashita log excerpt when relevant

## Generated data

Do not hand-edit generated catalogs without also updating their source or
generator. See `DATA_SOURCES.md` and the scripts under `tools/`.

## Pull requests

- Keep changes narrowly scoped.
- Preserve server-side authority for travel and tracker state.
- Never guess a map grid when the current map or floor is ambiguous.
- Validate Lua syntax and test the addon in Ashita 4.
- Do not add copyrighted guide data without documented permission.
