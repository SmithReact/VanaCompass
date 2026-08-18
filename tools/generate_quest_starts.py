"""Generate explicit quest starter contacts from Driftwood's guide prose.

The source files are pure Lua tables.  Most first steps use a deliberately
regular verb phrase ("Hear X out", "Take ... from X", etc.).  Overrides cover
multi-NPC introductions and quests started by doors, objects, or zone entry.
The generator refuses to emit a vague row so new guide wording cannot silently
degrade the in-game START card.
"""

from pathlib import Path
import re

from luaparser import ast
from luaparser import astnodes as nodes


ROOT = Path(__file__).resolve().parents[1]
QUEST_DIR = ROOT / "data" / "quests"
OUTPUT = ROOT / "data" / "quest_starts.lua"


def lua_value(node):
    if isinstance(node, nodes.String):
        return node.s.decode("utf-8") if isinstance(node.s, bytes) else node.s
    if isinstance(node, nodes.Number):
        return node.n
    if isinstance(node, nodes.TrueExpr):
        return True
    if isinstance(node, nodes.FalseExpr):
        return False
    if isinstance(node, nodes.Nil):
        return None
    if isinstance(node, nodes.Table):
        result, sequence = {}, 1
        for field in node.fields:
            if field.key is None:
                key, sequence = sequence, sequence + 1
            elif isinstance(field.key, nodes.Name):
                key = field.key.id
            else:
                key = lua_value(field.key)
            result[key] = lua_value(field.value)
        return result
    raise TypeError(f"Unsupported Lua node: {type(node).__name__}")


# (quest log, quest id): (display contact, type)
OVERRIDES = {
    (0, 3): ("Miene, then Altiret", "NPCs"),
    (0, 2): ("Rosel", "NPC"),
    (0, 5): ("Hanaa Punaa", "NPC"),
    (0, 15): ("Hanaa Punaa", "NPC"),
    (1, 22): ("Nbu Latteh", "NPC"),
    (1, 44): ("Brygid", "NPC"),
    (1, 52): ("Oggbi", "NPC"),
    (1, 59): ("Enter Beadeaux from Pashhow Marshlands", "Zone trigger"),
    (1, 63): ("Carmelo", "NPC"),
    (1, 64): ("Zacc, Enu, and Malene", "NPCs"),
    (1, 77): ("Ayame", "NPC"),
    (1, 78): ("Ayame", "NPC"),
    (3, 5): ("Merchant's House door", "Door trigger"),
    (3, 12): ("Song Runes", "Object trigger"),
    (3, 20): ("Song Runes", "Object trigger"),
    (3, 21): ("Clock tower door", "Door trigger"),
    (3, 86): ("Enter Ru'Lude Gardens", "Zone trigger"),
    (3, 88): ("Enter Ru'Lude Gardens", "Zone trigger"),
    (3, 89): ("Enter Ru'Lude Gardens", "Zone trigger"),
    (3, 133): ("Nomad Moogle", "NPC"),
    (3, 134): ("Nomad Moogle", "NPC"),
    (3, 135): ("Nomad Moogle", "NPC"),
    (3, 136): ("Nomad Moogle", "NPC"),
    (3, 137): ("Nomad Moogle", "NPC"),
    (3, 167): ("Nomad Moogle", "NPC"),
    (3, 170): ("Nomad Moogle", "NPC"),
    (4, 0): ("Rycharde", "NPC"),
    (4, 6): ("Rycharde", "NPC"),
    (4, 22): ("Oswald", "NPC"),
    (4, 32): ("???", "Object trigger"),
    (4, 34): ("Suspicious Hume", "NPC"),
    (4, 74): ("Chemioue, Parelbriaux, then Ondieulix", "Conversation chain"),
    (4, 79): ("Stone monument", "Object trigger"),
    (4, 100): ("Your Moogle", "NPC"),
    (4, 101): ("Your Moogle", "NPC"),
    (4, 102): ("Your Moogle", "NPC"),
    (4, 105): ("Koblakiq", "NPC"),
    (5, 160): ("Cermet headstone", "Object trigger"),
    (5, 161): ("Cermet headstone", "Object trigger"),
    (5, 162): ("Cermet headstone", "Object trigger"),
    (5, 163): ("???", "Object trigger"),
    (5, 164): ("???", "Object trigger"),
    (0, 88): ("Chateau d'Oraguille quest trigger", "Area trigger"),
    (0, 109): ("Sobane", "NPC"),
    (0, 100): ("Antreneau", "NPC"),
    (1, 50): ("Valah Molkot", "NPC"),
    (1, 74): ("Brygid", "NPC"),
    (2, 32): ("Shantotto", "NPC"),
    (2, 46): ("Paku-Nakku", "NPC"),
    (2, 71): ("Nanaa Mihgo", "NPC"),
    (2, 75): ("House of the Hero", "Building trigger"),
    (2, 76): ("Kohlo-Lakolo", "NPC"),
    (2, 81): ("House of the Hero", "Building trigger"),
    (2, 23): ("Paytah", "NPC"),
    (4, 4): ("Take", "NPC"),
    (4, 82): ("Despachiaire", "NPC"),
    (4, 83): ("Despachiaire", "NPC"),
}

# The twenty level-75 weapon-skill unlock entries all begin with Zalsuhm;
# the guide names the equipped vigil weapon immediately after his name.
for quest_id in range(102, 122):
    OVERRIDES[(3, quest_id)] = ("Zalsuhm", "NPC")

LOCATION_OVERRIDES = {
    (3, 167): "Ru'Lude Gardens (!pos 10 1 122)",
}
for quest_id in range(102, 122):
    LOCATION_OVERRIDES[(3, quest_id)] = "Lower Jeuno (!pos -33 6 -117)"

# Verified map-grid labels for starts whose zones have multiple map layers and
# therefore cannot be resolved safely from coordinates alone.
GRID_OVERRIDES = {
    (0, 61): "G-8",  # The Rumor: Novalmauge, Bostaunieux Oubliette map 1.
}


NAME = r"([A-Z][A-Za-z'\- ]+?)"
STOP = r"(?:,|;|:| and | with | in | at | for | about | to | --|$)"
PATTERNS = [
    rf"^Hear out {NAME}{STOP}",
    rf"^Hear {NAME} out{STOP}",
    rf"^Hear {NAME}'s ",
    rf"^Take .+? from {NAME}{STOP}",
    rf"^Take .+? off {NAME}{STOP}",
    rf"^Take up {NAME}'s ",
    rf"^Take {NAME}'s ",
    rf"^Ask {NAME}{STOP}",
    rf"^Show {NAME}{STOP}",
    rf"^Trade {NAME}{STOP}",
    rf"^Trade .+? to {NAME}{STOP}",
    rf"^Talk to {NAME}{STOP}",
    rf"^Speak to {NAME}{STOP}",
    rf"^Let {NAME}(?: talk| ask| swear| send| know| --|,|$)",
    rf"^Sign on with {NAME}{STOP}",
    rf"^Agree .+? (?:for|with) {NAME}{STOP}",
    rf"^Back {NAME}{STOP}",
    rf"^Bring .+? to {NAME}{STOP}",
    rf"^Go back to {NAME}{STOP}",
    rf"speak to {NAME}{STOP}",
    rf"job from {NAME}{STOP}",
    r"^([A-Z][A-Za-z'\- ]+?) (?:opens|is after|in .+? will give)",
]


def derive_contact(text):
    first_sentence = text.split(".", 1)[0]
    for pattern in PATTERNS:
        match = re.search(pattern, first_sentence)
        if match:
            return match.group(1).strip(), "NPC"
    return None


def quote(value):
    return "'" + value.replace("\\", "\\\\").replace("'", "\\'") + "'"


rows = {}
for source in sorted(QUEST_DIR.glob("*.lua")):
    tree = ast.parse(source.read_text(encoding="utf-8"))
    area = lua_value(tree.body.body[0].values[0])
    log = int(area["log"])
    rows.setdefault(log, {})
    for quest_id, quest in area["entries"].items():
        if not isinstance(quest, dict) or "steps" not in quest:
            continue
        first = quest["steps"][1]
        contact = OVERRIDES.get((log, int(quest_id))) or derive_contact(first.get("text", ""))
        if contact is None:
            raise RuntimeError(f"No explicit starter for log={log}, id={quest_id}, {quest['name']!r}")
        rows[log][int(quest_id)] = {
            "contact": contact[0],
            "kind": contact[1],
            "location": LOCATION_OVERRIDES.get((log, int(quest_id)))
            or first.get("pos", "")
            or "Not identified by the installed guide",
            "grid": GRID_OVERRIDES.get((log, int(quest_id))),
        }

lines = ["-- Generated from Driftwood quest guide introductions; do not hand-edit.", "return {"]
for log in sorted(rows):
    lines.append(f"    [{log}] = {{")
    for quest_id in sorted(rows[log]):
        row = rows[log][quest_id]
        grid = f", grid = {quote(row['grid'])}" if row["grid"] else ""
        lines.append(
            f"        [{quest_id}] = {{ contact = {quote(row['contact'])}, "
            f"kind = {quote(row['kind'])}, location = {quote(row['location'])}{grid} }},"
        )
    lines.append("    },")
lines.append("}")
OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"Generated {sum(len(group) for group in rows.values())} explicit quest starters: {OUTPUT}")
