<p align="center">
  <img src="assets/vanacompass-banner.png" alt="VanaCompass adventuring party planning a journey around a map" width="100%">
</p>

# VanaCompass

An in-game discovery guide for **DriftwoodXI** running on **Ashita 4**.
VanaCompass helps new and returning players find spell scrolls, ordinary shop
equipment, quest starters, story missions, job unlocks, teleports, and their
current map position without leaving the game.

> Community project. Not affiliated with or endorsed by Square Enix, Ashita,
> or the DriftwoodXI team. FINAL FANTASY XI is a trademark of Square Enix.

## Highlights

- Purchasable spell scrolls filtered by job, level, learned state, and magic type
- Weapons and armor filtered by equipment type, job, and level
- Standard vendor supplies with NPC, location, price, and nearest teleport
- Quest and main-story guides with START NPCs, map grids, exact `!pos`, and ports
- Server-synced active, completed, and current-step quest status
- Artifact and advanced-job unlock filtering, including prerequisite chains
- Live zone, map grid, and `!pos` display with multi-map safeguards
- Collapsible results browser, responsive layout, and scrollable guide panes
- Driftwood launcher palette integration through the bundled theme adapter
- New-player Signet, Conquest Point, and EXP-ring walkthrough

## Installation

1. Download the latest release archive.
2. Extract the folder as:

   ```text
   Ashita/addons/vanacompass/
   ```

3. In game, run:

   ```text
   /addon load vanacompass
   /vana
   ```

No separate libraries are required. Ashita 4 supplies `common`, `chat`, and
`imgui`; all VanaCompass-specific Lua and data files are bundled here.

## Commands

| Command | Action |
| --- | --- |
| `/vana` | Toggle the VanaCompass window |
| `/vanacompass` or `/vc` | Alternate toggle commands |
| `/vana <text>` | Open VanaCompass and search purchase tabs |
| `/vana refresh` | Refresh character, catalog, and tracker state |
| `/vana help` | Print the command summary |

## DriftwoodXI integration

VanaCompass is designed for DriftwoodXI and uses its server interfaces:

- `!port` powers destination buttons.
- `!signet` powers the Welcome-page Signet button.
- `!dwt sync` supplies active/completed quests and current objectives.
- `/tracker` opens DWTracker when its optional client addon is installed.

The window may load on another Ashita 4 server, but these integrations require
compatible server commands and data.

## New-player essentials

Keep Signet active while fighting eligible enemies in conquest regions so you
earn Conquest Points. On DriftwoodXI, `!signet` casts the buff anywhere.

Return to a Conquest guard in your home nation, choose the option to spend
Conquest Points, open **Common rewards**, and look for a Chariot Band, Empress
Band, or Emperor Band. Equip and use the ring to activate its EXP bonus.

## Data accuracy

VanaCompass deliberately reports `Grid: unavailable` when a map cannot be
identified safely. Split maps and floors are not guessed. Vendor inventory and
prices may also vary with nation rank, conquest standing, fame, era, or custom
server rules.

If a vendor, teleport, quest step, or grid is wrong, please open a bug report
with the zone, entry name, expected result, and a screenshot or exact `!pos`.

## Related projects

- [Nameplate for Ashita 4.30](https://github.com/SmithReact/Nameplate) restores
  Shirk/BunnyBox Productions' GPL-3.0 nameplate rendering fix for the current
  Ashita plugin interface.

## License and attribution

The project is prepared under GPL-3.0 because its generated shop dataset is
derived from LandSandBoat. BSD attribution for FFXIMissingSpells is retained in
[`THIRD_PARTY_LICENSE.txt`](THIRD_PARTY_LICENSE.txt). Detailed provenance is in
[`DATA_SOURCES.md`](DATA_SOURCES.md) and [`NOTICE.md`](NOTICE.md).

DriftwoodXI-derived teleport identifiers, theme integration, and guide data
are included with permission. Full source and license details are recorded in
[`DATA_SOURCES.md`](DATA_SOURCES.md), [`NOTICE.md`](NOTICE.md), and
[`THIRD_PARTY_LICENSE.txt`](THIRD_PARTY_LICENSE.txt).

## Contributing

Bug reports, verified coordinate corrections, and focused pull requests are
welcome. Read [`CONTRIBUTING.md`](CONTRIBUTING.md) before changing generated
data or server-specific behavior.
