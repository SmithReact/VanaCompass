-- dwtracker data -- Rise of the Zilart missions. Names generated Phase 0
-- (tools/dwtracker_names.py); steps for ZM1-ZM17 HAND-AUTHORED Phase 2 from
-- the mission scripts (scripts/missions/rotz/) as ground truth.
-- Pure data: numeric ids and display strings only, no xi.*, no functions
-- (DWTRACKER_FORMAT.md decisions T2/§3-4). Loaded byte-identically by the
-- server module and the dwtracker addon; both hash these bytes, so an edit
-- that reaches only one side makes the addon refuse step rendering for
-- this area until the copies agree again. tools/dwtracker_lint.py must
-- pass before any edit here ships.
--
-- THE LAUNCH GATE STOPS HERE. Zilart ends at ZM17 (id 30) on this server;
-- id 31 "The Last Verse" is the CoP hinge and stays gated with NO steps --
-- a step list on a gated entry is a promise the gate would break. The
-- linter pins that gate (GATED_PINS) so no later batch can quietly author
-- past it.
--
-- Zilart's shape differs from the nation lines: most of these missions
-- carry no missionStatus at all, and their whole progression is "go to the
-- next place and watch what happens". Those entries get one honest
-- done-less step rather than invented sub-states.
return {
    kind = 'missions',
    log = 3,
    area = 'zilart_missions',
    label = "Rise of the Zilart",
    entries = {
        [0] = { -- THE_NEW_FRONTIER (ZM1)
            name = "The New Frontier",
            steps = {
                {
                    text = "Reach Norg, the pirate town hidden in Yuhtunga Jungle's south-eastern caves. Rank 6 is the price of admission.",
                    pos  = "Norg",
                },
            },
        },
        [4] = { -- WELCOME_TNORG (ZM2)
            name = "Welcome t'Norg",
            steps = {
                {
                    text = "Present yourself at the Oaken Door in Norg.",
                    pos  = "Norg (!pos 97 -7 -12)",
                },
            },
        },
        [6] = { -- KAZHAMS_CHIEFTAINESS (ZM3)
            name = "Kazham's Chieftainess",
            steps = {
                {
                    text = "Hear Gilgamesh out in Norg, then take his word to Jakoh Wahcondalo, the chieftainess in Kazham. She parts with the Sacrificial Chamber Key.",
                    pos  = "Norg (!pos 122 -9 -12) / Kazham (!pos 101 -16 -115)",
                },
            },
        },
        [8] = { -- THE_TEMPLE_OF_UGGALEPIH (ZM4)
            name = "The Temple of Uggalepih",
            steps = {
                {
                    text = "Open the Mahogany Door deep in the Temple of Uggalepih with the Sacrificial Chamber Key and win the fight beyond it.",
                    pos  = "Temple of Uggalepih (!pos 299 0 349)",
                    done = { missionStatus = { 3, gte = 1 } },
                },
                {
                    text = "Step back into the Sacrificial Chamber for what follows.",
                    pos  = "Sacrificial Chamber",
                    done = { missionStatus = { 3, gte = 2 } },
                },
                {
                    text = "Enter the chamber once more; the Dark Fragment is yours at the end of it.",
                    pos  = "Sacrificial Chamber",
                },
            },
        },
        [10] = { -- HEADSTONE_PILGRIMAGE (ZM5)
            name = "Headstone Pilgrimage",
            steps = {
                {
                    text = "Touch the Cermet Headstone in four of its seven places -- La Theine Plateau, Western Altepa Desert, Yuhtunga Jungle and the Cloister of Frost -- for their elemental fragments.",
                    pos  = "!pos -170 39 -504 / -108 10 -216 / 491 20 301 / 566 0 606",
                    done = {
                        allOf = {
                            { ki = 240 }, -- WATER_FRAGMENT (La Theine Plateau)
                            { ki = 241 }, -- EARTH_FRAGMENT (Western Altepa Desert)
                            { ki = 239 }, -- FIRE_FRAGMENT (Yuhtunga Jungle)
                            { ki = 244 }, -- ICE_FRAGMENT (Cloister of Frost)
                        },
                    },
                },
                {
                    text = "Three headstones left: Behemoth's Dominion, Cape Teriggan and the Sanctuary of Zi'Tah. The last one you touch ends the pilgrimage.",
                    pos  = "!pos -74 -4 -87 / -107 -8 450 / 235 0 280",
                },
            },
        },
        [12] = { -- THROUGH_THE_QUICKSAND_CAVES (ZM6)
            name = "Through the Quicksand Caves",
            steps = {
                {
                    text = "Take the Shimmering Circle in the Quicksand Caves through to the Chamber of Oracles and win the fight waiting there. Gilgamesh in Norg points the way first.",
                    pos  = "Quicksand Caves (!pos -220 0 12)",
                },
            },
        },
        [14] = { -- THE_CHAMBER_OF_ORACLES (ZM7)
            name = "The Chamber of Oracles",
            steps = {
                {
                    text = "Set each fragment you carry into its matching pedestal in the Chamber of Oracles -- eight of them, seven elements and darkness.",
                    pos  = "Chamber of Oracles (!pos 200 -2 37)",
                    done = { missionStatus = { 3, gte = 255 } },
                },
                {
                    text = "Touch a pedestal once more to close the ritual and take the Prismatic Fragment.",
                    pos  = "Chamber of Oracles (!pos 200 -2 37)",
                },
            },
        },
        [16] = { -- RETURN_TO_DELKFUTTS_TOWER (ZM8)
            name = "Return to Delkfutt's Tower",
            steps = {
                {
                    text = "Climb Delkfutt's Tower to the Stellar Fulcrum at its head. Aldo in Lower Jeuno and Gilgamesh in Norg will set you on the road.",
                    pos  = "Stellar Fulcrum / Lower Jeuno (!pos 20 3 -58)",
                    done = { missionStatus = { 3, gte = 1 } },
                },
                {
                    text = "Win the fight behind the Qe'Lov Gate in the Stellar Fulcrum.",
                    pos  = "Stellar Fulcrum (!pos -520 -4 17)",
                    done = { missionStatus = { 3, gte = 2 } },
                },
                {
                    text = "Return to the Stellar Fulcrum for what comes after.",
                    pos  = "Stellar Fulcrum",
                },
            },
        },
        [18] = { -- ROMAEVE (ZM9)
            name = "Ro'Maeve",
            steps = {
                {
                    text = "Hear Aldo out in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos 20 3 -58)",
                    done = { var = 'Option', gte = 1 },
                },
                {
                    text = "Report back at the Oaken Door in Norg.",
                    pos  = "Norg (!pos 97 -7 -12)",
                },
            },
        },
        [20] = { -- THE_TEMPLE_OF_DESOLATION (ZM10)
            name = "The Temple of Desolation",
            steps = {
                {
                    text = "Hear Gilgamesh and Kamui out in Norg, then go to the Hall of the Gods and approach the seal at its heart.",
                    pos  = "Norg (!pos 120 -8 -7) / Hall of the Gods (!pos 0 -12 48)",
                },
            },
        },
        [22] = { -- THE_HALL_OF_THE_GODS (ZM11)
            name = "The Hall of the Gods",
            steps = {
                {
                    text = "Take what you found in the Hall of the Gods back to the Oaken Door in Norg.",
                    pos  = "Norg (!pos 97 -7 -12)",
                },
            },
        },
        [23] = { -- THE_MITHRA_AND_THE_CRYSTAL (ZM12)
            name = "The Mithra and the Crystal",
            steps = {
                {
                    text = "Speak with Maryoh Comyujah in Rabao and take her request.",
                    pos  = "Rabao (!pos 0 8 73)",
                    done = { missionStatus = { 3, gte = 1 } },
                },
                {
                    text = "Search the ancient vessel at the marked spot in the Quicksand Caves for the Scrap of Papyrus.",
                    pos  = "Quicksand Caves (!pos -504 20 -419)",
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { missionStatus = { 3, gte = 1 } },
                                    { ki = 451 }, -- SCRAP_OF_PAPYRUS
                                },
                            },
                            { missionStatus = { 3, gte = 2 } },
                        },
                    },
                },
                {
                    text = "Take the scrap back to Maryoh Comyujah; she reads it and gives you the Cerulean Crystal.",
                    pos  = "Rabao (!pos 0 8 73)",
                    done = { missionStatus = { 3, gte = 2 } },
                },
                {
                    text = "Carry the crystal to the Hall of the Gods and use it at the Shimmering Circle there.",
                    pos  = "Hall of the Gods (!pos 0 -12 48)",
                },
            },
        },
        [24] = { -- THE_GATE_OF_THE_GODS (ZM13)
            name = "The Gate of the Gods",
            steps = {
                {
                    text = "Take the Shimmering Circle in the Hall of the Gods through to Ru'Aun Gardens.",
                    pos  = "Hall of the Gods (!pos 0 -20 147)",
                },
            },
        },
        [26] = { -- ARK_ANGELS (ZM14)
            name = "Ark Angels",
            steps = {
                {
                    text = "Hear Gilgamesh out in Norg, then approach the Divine Might in the Shrine of Ru'Avitau.",
                    pos  = "The Shrine of Ru'Avitau (!pos -40 0 -151)",
                    done = { missionStatus = { 3, gte = 1 } },
                },
                {
                    text = "Beat all five Ark Angels in the La'Loff Amphitheater -- five separate ways in, one shard from each.",
                    pos  = "La'Loff Amphitheater (!pos -605 -22 483 / -264 -137 374 / 14 -224 488)",
                },
            },
        },
        [27] = { -- THE_SEALED_SHRINE (ZM15)
            name = "The Sealed Shrine",
            steps = {
                {
                    text = "Present yourself at the Oaken Door in Norg.",
                    pos  = "Norg (!pos 97 -7 -12)",
                    done = { missionStatus = { 3, gte = 1 } },
                },
                {
                    text = "Get into the Shrine of Ru'Avitau. Aldo in Lower Jeuno has what you need to know about the way in.",
                    pos  = "Lower Jeuno (!pos 20 3 -58) / The Shrine of Ru'Avitau",
                },
            },
        },
        [28] = { -- THE_CELESTIAL_NEXUS (ZM16)
            name = "The Celestial Nexus",
            steps = {
                {
                    text = "Hear Gilgamesh out in Norg, then win the fight at the Celestial Nexus, entered from the far west of Ru'Aun Gardens.",
                    pos  = "The Celestial Nexus (!pos -665 -5 -32)",
                },
            },
        },
        [30] = { -- AWAKENING (ZM17)
            name = "Awakening",
            steps = {
                {
                    text = "Two scenes are waiting: one as you walk into Norg, one from the figure in Lower Jeuno. Either order will do.",
                    pos  = "Norg / Lower Jeuno",
                    done = { missionStatus = { 3, gte = 3 } },
                },
                {
                    text = "Return to Norg and take the choice put to you.",
                    pos  = "Norg",
                },
            },
        },
        [31] = { name = "The Last Verse", gated = 'ENABLE_COP' }, -- THE_LAST_VERSE (CoP hinge; gated, no steps -- see the header)
    },
}
