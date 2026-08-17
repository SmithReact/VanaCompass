-- Explicit mission acceptance contacts. Nation missions use one convenient
-- mission guard; Zilart entries name their actual NPC, door, object, or zone
-- trigger. Coordinates follow the server scripts and Driftwood guide data.
return {
    [0] = {
        default = {
            contact = 'Ambrotien (recommended mission giver)',
            kind = 'NPC',
            location = 'Southern San d\'Oria (!pos 93 1 -57)',
        },
    },
    [1] = {
        default = {
            contact = 'Rashid (recommended mission giver)',
            kind = 'NPC',
            location = 'Bastok Mines (!pos -8 -1 -124)',
        },
    },
    [2] = {
        default = {
            contact = 'Mokyokyo (recommended mission giver)',
            kind = 'NPC',
            location = 'Windurst Waters (!pos -56 -5 230)',
        },
    },
    [3] = {
        entries = {
            [0] = { contact = 'Enter Norg at Rank 6 or higher', kind = 'Zone trigger', location = 'Norg' },
            [4] = { contact = 'Oaken Door', kind = 'Door trigger', location = 'Norg (!pos 97 -7 -12)' },
            [6] = { contact = 'Gilgamesh', kind = 'NPC', location = 'Norg (!pos 122 -9 -12)' },
            [8] = { contact = 'Mahogany Door', kind = 'Door trigger', location = 'Temple of Uggalepih (!pos 299 0 349)' },
            [10] = { contact = 'Cermet Headstones', kind = 'Object triggers', location = 'La Theine Plateau / Western Altepa Desert / Yuhtunga Jungle / Cloister of Frost' },
            [12] = { contact = 'Gilgamesh', kind = 'NPC', location = 'Norg (!pos 122 -9 -12)' },
            [14] = { contact = 'Elemental pedestals', kind = 'Object triggers', location = 'Chamber of Oracles (!pos 200 -2 37)' },
            [16] = { contact = 'Aldo and Gilgamesh', kind = 'NPCs', location = 'Lower Jeuno (!pos 20 3 -58) / Norg (!pos 122 -9 -12)' },
            [18] = { contact = 'Aldo', kind = 'NPC', location = 'Lower Jeuno (!pos 20 3 -58)' },
            [20] = { contact = 'Gilgamesh and Kamui', kind = 'NPCs', location = 'Norg (!pos 120 -8 -7)' },
            [22] = { contact = 'Oaken Door', kind = 'Door trigger', location = 'Norg (!pos 97 -7 -12)' },
            [23] = { contact = 'Maryoh Comyujah', kind = 'NPC', location = 'Rabao (!pos 0 8 73)' },
            [24] = { contact = 'Shimmering Circle', kind = 'Object trigger', location = 'Hall of the Gods (!pos 0 -20 147)' },
            [26] = { contact = 'Gilgamesh', kind = 'NPC', location = 'Norg (!pos 122 -9 -12)' },
            [27] = { contact = 'Oaken Door', kind = 'Door trigger', location = 'Norg (!pos 97 -7 -12)' },
            [28] = { contact = 'Gilgamesh', kind = 'NPC', location = 'Norg (!pos 122 -9 -12)' },
            [30] = { contact = 'Enter Norg or visit Aldo', kind = 'Zone / NPC trigger', location = 'Norg / Lower Jeuno (!pos 20 3 -58)' },
        },
    },
}
