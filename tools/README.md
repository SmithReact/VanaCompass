# Data-generation tools

These scripts maintain VanaCompass's generated Lua catalogs. They are not
required to install or run the addon.

## Requirements

- Python 3.10 or newer
- [`luaparser`](https://pypi.org/project/luaparser/) for
  `generate_quest_starts.py`
- A local LandSandBoat source tree for `generate_shops.py`
- The source files named by each script's command-line options

Run a script with `--help` before use. Generated data must be reviewed for the
target server's era and rules before release.

## Scripts

- `generate_catalog.py` builds spell-vendor and teleport catalogs.
- `generate_quest_starts.py` derives quest start records from the bundled
  quest guide data.
- `generate_shops.py` builds the general vendor inventory from a local
  LandSandBoat checkout.

The generated catalogs retain the licensing and attribution requirements of
their source data. See [`../DATA_SOURCES.md`](../DATA_SOURCES.md),
[`../NOTICE.md`](../NOTICE.md), and
[`../THIRD_PARTY_LICENSE.txt`](../THIRD_PARTY_LICENSE.txt).
