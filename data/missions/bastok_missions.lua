-- dwtracker data -- Bastok missions. Names generated Phase 0
-- (tools/dwtracker_names.py); steps HAND-AUTHORED Phase 2 from the mission
-- scripts (scripts/missions/bastok/) as ground truth.
-- Pure data: numeric ids and display strings only, no xi.*, no functions
-- (DWTRACKER_FORMAT.md decisions T2/§3-4). Loaded byte-identically by the
-- server module and the dwtracker addon; both hash these bytes, so an edit
-- that reaches only one side makes the addon refuse step rendering for
-- this area until the copies agree again. tools/dwtracker_lint.py must
-- pass before any edit here ships.
--
-- Authoring conventions (established Phase 1, see sandoria_missions.lua):
--   * The final step omits `done`: a turn-in completes by leaving the
--     Active list, so no predicate can be true while it renders.
--   * missionStatus thresholds are the values the script's own
--     setMissionStatus calls write; the chain must be non-decreasing.
--   * Gather steps ride allOf{ missionStatus, item } so an item obtained
--     early can never skip the tracker past unvisited NPC steps.
--
-- Bastok note: several early missions carry NO missionStatus at all --
-- their whole state is a key item or a traded item. Those entries are two
-- steps (obtain, hand over), the shape §6.4 allows a bare consumable in.
return {
    kind = 'missions',
    log = 1,
    area = 'bastok_missions',
    label = "Bastok",
    entries = {
        [0] = { -- THE_ZERUHN_REPORT (M1-1)
            name = "The Zeruhn Report",
            steps = {
                {
                    text = "Go down into the Zeruhn Mines, below Bastok Mines, and get the report from Makarim.",
                    pos  = "Zeruhn Mines (!pos -58 8 -333)",
                    done = { ki = 1 }, -- ZERUHN_REPORT
                },
                {
                    text = "Carry the Zeruhn Report up to Naji in the Metalworks.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                },
            },
        },
        [1] = { -- GEOLOGICAL_SURVEY (M1-2)
            name = "A Geological Survey",
            repeatable = true,
            steps = {
                {
                    text = "Take an acidity tester from Cid in the Metalworks, then dip it in one of the hot springs down in Dangruf Wadi until it reads red.",
                    pos  = "Metalworks (!pos -12 -12 1) / Dangruf Wadi",
                    done = { ki = 4 }, -- RED_ACIDITY_TESTER
                },
                {
                    text = "Bring the red tester back to Cid.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                },
            },
        },
        [2] = { -- FETICHISM (M1-3)
            name = "Fetichism",
            repeatable = true,
            steps = {
                {
                    text = "Collect all four pieces of a Quadav fetich -- head, torso, arms and legs -- off the Quadav themselves.",
                    done = {
                        allOf = {
                            { item = 606 }, -- QUADAV_FETICH_HEAD
                            { item = 607 }, -- QUADAV_FETICH_TORSO
                            { item = 608 }, -- QUADAV_FETICH_ARMS
                            { item = 609 }, -- QUADAV_FETICH_LEGS
                        },
                    },
                },
                {
                    text = "Trade all four pieces at once to a gate guard.",
                    pos  = "Bastok Markets (!pos -358 -10 -168) / Bastok Mines (!pos -8 -2 -123)",
                },
            },
        },
        [3] = { -- THE_CRYSTAL_LINE (M2-1)
            name = "The Crystal Line",
            repeatable = true,
            steps = {
                {
                    text = "Ask Cid in the Metalworks for the job; he hands you an elemental crystal.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Trade that crystal to any outdoor Telepoint to get a Faded Crystal back, then trade the Faded Crystal to Cid for his report.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                    done = {
                        allOf = {
                            { missionStatus = { 1, gte = 1 } },
                            { ki = 12 }, -- C_L_REPORT
                        },
                    },
                },
                {
                    text = "Take Cid's report to Ayame in the Metalworks.",
                    pos  = "Metalworks (!pos 133 -19 34)",
                },
            },
        },
        [4] = { -- WADING_BEASTS (M2-2)
            name = "Wading Beasts",
            repeatable = true,
            steps = {
                {
                    text = "Get hold of a Lizard Egg -- the lizards that carry them are what the mission is about.",
                    done = { item = 4362 }, -- LIZARD_EGG
                },
                {
                    text = "Trade the egg to Alois in the Metalworks.",
                    pos  = "Metalworks (!pos 96 -20 14)",
                },
            },
        },
        [5] = { -- THE_EMISSARY (M2-3)
            name = "The Emissary",
            steps = {
                {
                    text = "Take the Letter to the Consuls from Naji in the Metalworks.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Pick a consulate and present the letter there: Baraka in Northern San d'Oria, or Melek in Port Windurst.",
                    pos  = "Northern San d'Oria (!pos 36 -2 -2) / Port Windurst (!pos -80 -5 158)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "See that errand through -- your journal carries it as The Emissary San d'Oria or The Emissary Windurst.",
                    done = { missionStatus = { 1, gte = 6 } },
                },
                {
                    text = "Cross to the other nation's consulate to take up the second errand: Melek in Port Windurst, or Helaku in Northern San d'Oria.",
                    pos  = "Port Windurst (!pos -80 -5 158) / Northern San d'Oria (!pos 49 -2 -12)",
                    done = { missionStatus = { 1, gte = 8 } },
                },
                {
                    text = "Finish the second errand; it appears in the journal under the other nation's name and ends with the Kindred Report in your hands.",
                    done = { missionStatus = { 1, gte = 10 } },
                },
                {
                    text = "Take the Kindred Report back to Naji in the Metalworks.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                },
            },
        },
        [6] = { -- THE_EMISSARY_SANDORIA (M2-3, first errand)
            name = "The Emissary San d'Oria",
            steps = {
                {
                    text = "Report to Helaku at the Bastokan consulate in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos 49 -2 -12)",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Carry the request on to Halver in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 1, gte = 4 } },
                },
                {
                    text = "Hunt down Warchief Vatgit in Ghelsba Outpost.",
                    pos  = "Ghelsba Outpost",
                    done = { missionStatus = { 1, gte = 5 } },
                },
                {
                    text = "Report the kill to Helaku.",
                    pos  = "Northern San d'Oria (!pos 49 -2 -12)",
                },
            },
        },
        [7] = { -- THE_EMISSARY_WINDURST (M2-3, first errand)
            name = "The Emissary Windurst",
            steps = {
                {
                    text = "Enter Heavens Tower, the great tree at the heart of Windurst.",
                    pos  = "Windurst Walls",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Speak with Kupipi; she entrusts you with the Sword Offering.",
                    pos  = "Heavens Tower (!pos 2 0 30)",
                    done = { missionStatus = { 1, gte = 4 } },
                },
                {
                    text = "Bear the offering to Uu Zhoumo in Giddeus. He refuses it and demands an Aspir Knife instead. Gold Skull in Port Windurst will swap the real sword for a fake first.",
                    pos  = "Giddeus (!pos -179 16 155)",
                    done = { missionStatus = { 1, gte = 5 } },
                },
                {
                    text = "Trade an Aspir Knife to Uu Zhoumo.",
                    pos  = "Giddeus (!pos -179 16 155)",
                    done = { missionStatus = { 1, gte = 6 } },
                },
                {
                    text = "Report back to Melek in Port Windurst.",
                    pos  = "Port Windurst (!pos -80 -5 158)",
                },
            },
        },
        [8] = { -- THE_EMISSARY_SANDORIA2 (M2-3, second errand)
            name = "The Emissary San d'Oria",
            steps = {
                {
                    text = "Report to Halver in Chateau d'Oraguille; he sets you a trial.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 1, gte = 9 } },
                },
                {
                    text = "Prevail in the battle at Horlais Peak, in Ronfaure, and claim the Kindred Crest.",
                    pos  = "Horlais Peak",
                    done = { missionStatus = { 1, gte = 10 } },
                },
                {
                    text = "Bring the crest to Helaku in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos 49 -2 -12)",
                },
            },
        },
        [9] = { -- THE_EMISSARY_WINDURST2 (M2-3, second errand)
            name = "The Emissary Windurst",
            steps = {
                {
                    text = "See Kupipi in Heavens Tower; she entrusts you with the Dark Key.",
                    pos  = "Heavens Tower (!pos 2 0 30)",
                    done = { missionStatus = { 1, gte = 8 } },
                },
                {
                    text = "Overcome the battle at Balga's Dais, within the Horutoto Ruins, and secure the Kindred Crest.",
                    pos  = "Balga's Dais",
                    done = { missionStatus = { 1, gte = 9 } },
                },
                {
                    text = "Bring the crest to Melek in Port Windurst.",
                    pos  = "Port Windurst (!pos -80 -5 158)",
                },
            },
        },
        [10] = { -- THE_FOUR_MUSKETEERS (M3-1)
            name = "The Four Musketeers",
            steps = {
                {
                    text = "Hear Iron Eater out in the Metalworks and take his terms.",
                    pos  = "Metalworks (!pos 92 -19 1)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Walk into Beadeaux -- the Quadav take you as you arrive.",
                    pos  = "Beadeaux",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Cut your own way out: twenty Copper Quadav inside Beadeaux.",
                    pos  = "Beadeaux",
                    done = { missionStatus = { 1, gte = 22 } },
                },
                {
                    text = "Leave Beadeaux for Pashhow Marshlands to close the mission.",
                    pos  = "Beadeaux",
                },
            },
        },
        [11] = { -- TO_THE_FORSAKEN_MINES (M3-2)
            name = "To the Forsaken Mines",
            repeatable = true,
            steps = {
                {
                    text = "Put a Slice of Hare Meat down at the marked spot in Gusgen Mines to draw out Blind Moby, and take the Glocolite it leaves.",
                    pos  = "Gusgen Mines (!pos 206 -60 -101)",
                    done = { item = 563 }, -- GLOCOLITE
                },
                {
                    text = "Trade the Glocolite to a gate guard.",
                    pos  = "Bastok Markets (!pos -358 -10 -168) / Bastok Mines (!pos -8 -2 -123)",
                },
            },
        },
        [12] = { -- JEUNO (M3-3)
            name = "Jeuno",
            steps = {
                {
                    text = "Report to Lucius in the Metalworks and take the Letter to the Ambassador.",
                    pos  = "Metalworks (!pos 59 -17 -42)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Deliver the letter to Goggehn at the Bastokan embassy in Ru'Lude Gardens.",
                    pos  = "Ru'Lude Gardens (!pos 3 9 -76)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Open a Cermet Door in Lower Delkfutt's Tower -- a Delkfutt Key traded to the door does it.",
                    pos  = "Lower Delkfutt's Tower (!pos 596 16 -19)",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Return to the embassy door in Ru'Lude Gardens -- Rank 4 waits there.",
                    pos  = "Ru'Lude Gardens (!pos -31 7 -65)",
                },
            },
        },
        [13] = { -- MAGICITE (M4-1)
            name = "Magicite",
            steps = {
                {
                    text = "Present the Archducal Audience Permit at the Audience Chamber door in Ru'Lude Gardens and take the letter meant for Aldo.",
                    pos  = "Ru'Lude Gardens (!pos 0 -5 66)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Carry the letter down to Aldo in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos 20 3 -58)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Recover three Magicite: the Orastone in Castle Oztroja's Altar Room, the Optistone in Davoi's Monastic Cavern, the Aurastone in Beadeaux's Qulun Dome.",
                    pos  = "Altar Room (!pos -344 25 43) / Monastic Cavern (!pos -160 -8 8) / Qulun Dome (!pos 11 25 -81)",
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { missionStatus = { 1, gte = 2 } },
                                    { ki = 16 }, -- MAGICITE_ORASTONE
                                    { ki = 14 }, -- MAGICITE_OPTISTONE
                                    { ki = 15 }, -- MAGICITE_AURASTONE
                                },
                            },
                            { missionStatus = { 1, gte = 3 } },
                        },
                    },
                },
                {
                    text = "Hand all three stones over at the Audience Chamber door. Muckvix in Lower Jeuno lends the Yagudo Torch if Castle Oztroja is still barring your way.",
                    pos  = "Ru'Lude Gardens (!pos 0 -5 66)",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Report to Goggehn at the embassy in Ru'Lude Gardens -- Rank 5 and the road to Fei'Yin follow.",
                    pos  = "Ru'Lude Gardens (!pos -32 9 -49)",
                },
            },
        },
        [14] = { -- DARKNESS_RISING (M5-1)
            name = "Darkness Rising",
            steps = {
                {
                    text = "See Naji in the Metalworks and take the new Fei'Yin seal from him.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                    done = { missionStatus = { 1, gte = 10 } },
                },
                {
                    text = "Make your way north-east to Fei'Yin; something meets you at the gate.",
                    pos  = "Fei'Yin",
                    done = { missionStatus = { 1, gte = 11 } },
                },
                {
                    text = "Win the fight waiting in Qu'Bia Arena -- the seal is your entry -- and take the Burnt Seal from it.",
                    pos  = "Qu'Bia Arena",
                    done = { missionStatus = { 1, gte = 12 } },
                },
                {
                    text = "Bring the Burnt Seal back to Naji.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                },
            },
        },
        [15] = { -- XARCABARD_LAND_OF_TRUTHS (M5-2)
            name = "Xarcabard, Land of Truths",
            steps = {
                {
                    text = "Speak with Karst in the Metalworks.",
                    pos  = "Metalworks (!pos 106 -21 0)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Climb Castle Zvahl and present yourself at the Throne Room door.",
                    pos  = "Throne Room",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Bring down the Shadow Lord and take the Shadow Fragment left behind.",
                    pos  = "Throne Room",
                    done = { missionStatus = { 1, gte = 4 } },
                },
                {
                    text = "Carry the fragment to the council chamber door in the Metalworks -- Rank 6, and the Zilart road opens.",
                    pos  = "Metalworks (!pos 92 -19 0)",
                },
            },
        },
        [16] = { -- RETURN_OF_THE_TALEKEEPER (M6-1)
            name = "Return of the Talekeeper",
            steps = {
                {
                    text = "Speak with Medicine Eagle in Bastok Mines.",
                    pos  = "Bastok Mines (!pos -40 0 38)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Find Drake Fang down in the Zeruhn Mines.",
                    pos  = "Zeruhn Mines (!pos -74 0 58)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Search the marked spot in Western Altepa Desert: the Eastern and Western Sphinx rise together. Put both down, then search again for the Altepa Moonpebble.",
                    pos  = "Western Altepa Desert (!pos -325 0 -111)",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Take the moonpebble to Tall Mountain in Bastok Mines.",
                    pos  = "Bastok Mines (!pos 71 7 -7)",
                },
            },
        },
        [17] = { -- THE_PIRATES_COVE (M6-2)
            name = "The Pirate's Cove",
            steps = {
                {
                    text = "Speak with Naji in the Metalworks.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Make your way to Norg and see Gilgamesh.",
                    pos  = "Norg (!pos 122 -9 -12)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Trade a Chunk of Adaman Ore at the marked spot in Ifrit's Cauldron to draw out what guards it, and take the Frag Rock.",
                    pos  = "Ifrit's Cauldron (!pos 171 0 -25)",
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { missionStatus = { 1, gte = 2 } },
                                    { item = 1160 }, -- FRAG_ROCK
                                },
                            },
                            { missionStatus = { 1, gte = 3 } },
                        },
                    },
                },
                {
                    text = "Trade the Frag Rock to Gilgamesh in Norg.",
                    pos  = "Norg (!pos 122 -9 -12)",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Report back to Naji in the Metalworks -- Rank 7 follows.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                },
            },
        },
        [18] = { -- THE_FINAL_IMAGE (M7-1)
            name = "The Final Image",
            steps = {
                {
                    text = "Speak with Cid in the Metalworks.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Search the marked spot in Ro'Maeve: Mokkurkalfi answers. Put it down, then search again for the Reinforced Cermet.",
                    pos  = "Ro'Maeve (!pos 102 -4 -114)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Take the cermet back to Cid.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                },
            },
        },
        [19] = { -- ON_MY_WAY (M7-2)
            name = "On My Way",
            steps = {
                {
                    text = "Speak with Karst in the Metalworks.",
                    pos  = "Metalworks (!pos 106 -21 0)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Find Hilda in Port Bastok.",
                    pos  = "Port Bastok (!pos -163 -8 13)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Win the battle set at Waughroon Shrine, within the Palborough Mines, and take the letter it leaves you.",
                    pos  = "Waughroon Shrine",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Report back to Karst -- Rank 8 follows. The letter still wants delivering: Gumbah in Bastok Mines is the one waiting for it.",
                    pos  = "Metalworks (!pos 106 -21 0) / Bastok Mines (!pos 52 0 -36)",
                },
            },
        },
        [20] = { -- THE_CHAINS_THAT_BIND_US (M8-1)
            name = "The Chains That Bind Us",
            steps = {
                {
                    text = "Take the job from Iron Eater in the Metalworks.",
                    pos  = "Metalworks (!pos 92 -19 1)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Search the marked spot in the Quicksand Caves: three Antican officers answer. Put all three down.",
                    pos  = "Quicksand Caves (!pos -469 0 620)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Search that same spot again.",
                    pos  = "Quicksand Caves (!pos -469 0 620)",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Go on to the second marked spot, deeper in the caves.",
                    pos  = "Quicksand Caves (!pos -533 0 -415)",
                    done = { missionStatus = { 1, gte = 4 } },
                },
                {
                    text = "Report back to Iron Eater in the Metalworks.",
                    pos  = "Metalworks (!pos 92 -19 1)",
                },
            },
        },
        [21] = { -- ENTER_THE_TALEKEEPER (M8-2)
            name = "Enter the Talekeeper",
            steps = {
                {
                    text = "Speak with Drake Fang down in the Zeruhn Mines.",
                    pos  = "Zeruhn Mines (!pos -74 0 58)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Find the first marked spot in Kuftal Tunnel and look it over.",
                    pos  = "Kuftal Tunnel (!pos -29 -22 -183)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "The second marked spot wakes three ghosts. Put all three down.",
                    pos  = "Kuftal Tunnel (!pos -27 -10 -185)",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Search that spot again for the Old Piece of Wood.",
                    pos  = "Kuftal Tunnel (!pos -27 -10 -185)",
                    done = { missionStatus = { 1, gte = 4 } },
                },
                {
                    text = "Take it back to Drake Fang in the Zeruhn Mines.",
                    pos  = "Zeruhn Mines (!pos -74 0 58)",
                    done = { missionStatus = { 1, gte = 5 } },
                },
                {
                    text = "Follow him up into Bastok Mines -- Rank 9 waits at the top.",
                    pos  = "Bastok Mines",
                },
            },
        },
        [22] = { -- THE_SALT_OF_THE_EARTH (M9-1)
            name = "The Salt of the Earth",
            steps = {
                {
                    text = "Speak with Alois in the Metalworks.",
                    pos  = "Metalworks (!pos 96 -20 14)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Find Dancing Wolf in Rabao.",
                    pos  = "Rabao (!pos 7 7 81)",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Search the marked spot in Gustav Tunnel: Gigaplasm and its brood answer. Put them all down.",
                    pos  = "Gustav Tunnel (!pos -130 1 252)",
                    done = { missionStatus = { 1, gte = 3 } },
                },
                {
                    text = "Search the spot again for the Miraclesalt, then carry it back to Dancing Wolf.",
                    pos  = "Gustav Tunnel (!pos -130 1 252) / Rabao (!pos 7 7 81)",
                    done = { missionStatus = { 1, gte = 4 } },
                },
                {
                    text = "Report to Alois in the Metalworks.",
                    pos  = "Metalworks (!pos 96 -20 14)",
                },
            },
        },
        [23] = { -- WHERE_TWO_PATHS_CONVERGE (M9-2)
            name = "Where Two Paths Converge",
            steps = {
                {
                    text = "Speak with Iron Eater in the Metalworks.",
                    pos  = "Metalworks (!pos 92 -19 1)",
                    done = { missionStatus = { 1, gte = 1 } },
                },
                {
                    text = "Win the battle waiting in Castle Zvahl's Throne Room.",
                    pos  = "Throne Room",
                    done = { missionStatus = { 1, gte = 2 } },
                },
                {
                    text = "Return to Iron Eater -- Rank 10 and the Bastokan Flag are yours.",
                    pos  = "Metalworks (!pos 92 -19 1)",
                },
            },
        },
    },
}
