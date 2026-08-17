-- dwtracker data -- Bastok quests. Names generated Phase 0
-- (tools/dwtracker_names.py); steps hand-authored in Phase 3 from
-- scripts/quests/bastok/ as ground truth. Entries still name-only are
-- enum ids no script implements on this server: they cannot be accepted,
-- so they can never render a step.
-- Pure data: numeric ids and display strings only, no xi.*, no functions
-- (DWTRACKER_PLAN.md decision T2). Loaded byte-identically by the server
-- module and the dwtracker addon; both hash these bytes, so an edit that
-- reaches only one side makes the addon refuse step rendering for this
-- area until the copies agree again. tools/dwtracker_lint.py must pass
-- before edits ship.
return {
    kind = 'quests',
    log = 1,
    area = 'bastok_quests',
    label = "Bastok",
    entries = {
        [0] = { -- THE_SIRENS_TEAR
            name = "The Siren's Tear",
            steps = {
                {
                    text = "Take the errand from Wahid.",
                    pos  = "Bastok Mines (!pos 26 -1 -66)",
                    done = { status = 1 },
                },
                {
                    text = "Ask after the tear down in Port Bastok: Otto first, then Carmelo.",
                    pos  = "Otto !pos -145 -7 13, Carmelo !pos -146 -7 -10 (Port Bastok)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Find the Siren's Tear itself. The ??? holding it wanders Konschtat Highlands.",
                    pos  = "Konschtat Highlands (!pos 309 2 324, moves)",
                    done = { allOf = { { var = 'Prog', gte = 1 }, { item = 576 } } }, -- SIRENS_TEAR
                },
                {
                    text = "Trade the Siren's Tear to Wahid.",
                    pos  = "Bastok Mines (!pos 26 -1 -66)",
                },
            },
        },
        [1] = { -- BEAUTY_AND_THE_GALKA
            name = "Beauty and the Galka",
            steps = {
                {
                    text = "Hear Talib out about Cornelia. Turn him down and Parraggoh in the Mines will ask you himself.",
                    pos  = "Port Bastok (!pos -101 4 28)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Talib a Chunk of Zinc Ore; he parts with the Palborough Mines Logs.",
                    pos  = "Port Bastok (!pos -101 4 28)",
                    done = { ki = 2 }, -- PALBOROUGH_MINES_LOGS
                },
                {
                    text = "Take the logs to Parraggoh.",
                    pos  = "Bastok Mines",
                },
            },
        },
        [2] = { -- WELCOME_TO_BASTOK
            name = "Welcome to Bastok",
            steps = {
                {
                    text = "Take the welcome from Powhatan.",
                    pos  = "Port Bastok (!pos -152 -7 19)",
                    done = { status = 1 },
                },
                {
                    text = "Equip a Shell Shield and let Bartolomeo see you wearing it.",
                    pos  = "Port Bastok (!pos -84 1 -18)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report back to Powhatan.",
                    pos  = "Port Bastok (!pos -152 -7 19)",
                },
            },
        },
        [3] = { -- GUEST_OF_HAUTEUR
            -- Named from the enum: the script header carries a copy-pasted
            -- "Welcome to Bastok" title that belongs to quest 2.
            name = "Guest of Hauteur",
            steps = {
                {
                    text = "Take the next errand from Powhatan. He asks for level 31, a finished Welcome to Bastok, and Bastok fame level 3.",
                    pos  = "Port Bastok (!pos -152 -7 19)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Wield a Maul -- the replica counts -- and show it to Steel Bones for the Letter from Domien.",
                    pos  = "Port Bastok (!pos -185 1 -57)",
                    done = { ki = 11 }, -- LETTER_FROM_DOMIEN
                },
                {
                    text = "Take the letter back to Powhatan.",
                    pos  = "Port Bastok (!pos -152 -7 19)",
                },
            },
        },
        [4] = { -- THE_QUADAVS_CURSE
            name = "The Quadav's Curse",
            steps = {
                {
                    text = "Take the errand from Corann.",
                    pos  = "Port Bastok (!pos 90 -8 32)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a Quadav Backplate.",
                    done = { item = 596 }, -- QUADAV_BACKPLATE
                },
                {
                    text = "Trade the backplate to Corann.",
                    pos  = "Port Bastok (!pos 90 -8 32)",
                },
            },
        },
        [5] = { -- OUT_OF_ONES_SHELL
            name = "Out of One's Shell",
            steps = {
                {
                    text = "Hear Ronan out. He asks for a finished The Quadav's Curse and Bastok fame level 2.",
                    pos  = "Port Bastok (!pos 84 -8 20)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Trade Ronan three Shell Bugs.",
                    pos  = "Port Bastok (!pos 84 -8 20)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Leave the zone and come back, then speak to Ronan again.",
                    pos  = "Port Bastok (!pos 84 -8 20)",
                },
            },
        },
        [6] = { -- HEARTS_OF_MYTHRIL
            name = "Hearts of Mythril",
            steps = {
                {
                    text = "Take the errand from Elki, and the Bouquet for the Pioneers with it.",
                    pos  = "Bastok Mines (!pos -17 0 52)",
                    done = { status = 1 },
                },
                {
                    text = "Lay the bouquet at the monument out in North Gustaberg.",
                    pos  = "North Gustaberg (!pos 300 -62 498)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report back to Elki.",
                    pos  = "Bastok Mines (!pos -17 0 52)",
                },
            },
        },
        [7] = { -- THE_ELEVENTHS_HOUR
            name = "The Eleventh's Hour",
            steps = {
                {
                    text = "Take the next errand from Elki. She asks for a finished Hearts of Mythril, Bastok fame level 3, and that you have zoned since that quest ended.",
                    pos  = "Bastok Mines (!pos -17 0 52)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Find the old toolbox lying in Palborough Mines, take it, and show it to Elki.",
                    pos  = "Palborough Mines (!pos 113 -32 79)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take what Elki made of it to Babenn.",
                    pos  = "Bastok Mines (!pos 73 -1 34)",
                },
            },
        },
        [8] = { -- SHADY_BUSINESS
            name = "Shady Business",
            steps = {
                {
                    text = "Ask Talib for work -- he takes you on the moment you ask, once Beauty and the Galka is behind you.",
                    pos  = "Port Bastok (!pos -101 4 28)",
                    done = { status = 1 },
                },
                {
                    text = "Gather four Chunks of Zinc Ore.",
                    done = { item = 642, qty = 4 }, -- CHUNK_OF_ZINC_ORE x4
                },
                {
                    text = "Trade the four chunks to Talib.",
                    pos  = "Port Bastok (!pos -101 4 28)",
                },
            },
        },
        [9] = { -- A_FOREMANS_BEST_FRIEND
            name = "A Foreman's Best Friend",
            steps = {
                {
                    text = "Hear Gudav out about his dog.",
                    pos  = "Port Bastok (!pos -3 1 50)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a Dog Collar.",
                    done = { item = 13096 }, -- DOG_COLLAR
                },
                {
                    text = "Trade the collar to Gudav.",
                    pos  = "Port Bastok (!pos -3 1 50)",
                },
            },
        },
        [10] = { -- BREAKING_STONES
            name = "Breaking Stones",
            repeatable = true,
            steps = {
                {
                    text = "Take the order from Horatius. He will not ask below Bastok fame level 2.",
                    pos  = "Bastok Markets (!pos -158 -6 -117)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Fetch a Dangruf Stone from the ??? in Dangruf Wadi.",
                    pos  = "Dangruf Wadi (!pos -120 2 415)",
                    done = { item = 553 }, -- DANGRUF_STONE
                },
                {
                    text = "Trade the stone to Horatius.",
                    pos  = "Bastok Markets (!pos -158 -6 -117)",
                },
            },
        },
        [11] = { -- THE_COLD_LIGHT_OF_DAY
            name = "The Cold Light of Day",
            repeatable = true,
            steps = {
                {
                    text = "Hear Malene out. Gwill nearby will tell you more about what she wants.",
                    pos  = "Bastok Markets (!pos -173 -5 64)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a Steam Clock.",
                    done = { item = 550 }, -- STEAM_CLOCK
                },
                {
                    text = "Trade the clock to Malene.",
                    pos  = "Bastok Markets (!pos -173 -5 64)",
                },
            },
        },
        [12] = { -- GOURMET
            name = "Gourmet",
            repeatable = true,
            steps = {
                {
                    text = "Take the shopping list from Salimah.",
                    pos  = "Bastok Markets (!pos -31 -6 -73)",
                    done = { status = 1 },
                },
                {
                    text = "Bring her one of the three, and time it: a Treant Bulb in the morning, a Wild Onion in the afternoon, a Sleepshroom after dark. The wrong hour still feeds her, for less.",
                    pos  = "Bastok Markets (!pos -31 -6 -73)",
                },
            },
        },
        [13] = { -- THE_ELVAAN_GOLDSMITH
            name = "The Elvaan Goldsmith",
            repeatable = true, -- but only while Bastok fame is still exactly 1
            steps = {
                {
                    text = "Take the order from Michea.",
                    pos  = "Bastok Markets (!pos -298 -16 -157)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a Copper Ingot.",
                    done = { item = 648 }, -- COPPER_INGOT
                },
                {
                    text = "Trade the ingot to Michea.",
                    pos  = "Bastok Markets (!pos -298 -16 -157)",
                },
            },
        },
        [14] = { -- A_FLASH_IN_THE_PAN
            name = "A Flash in the Pan",
            repeatable = true,
            steps = {
                {
                    text = "Take the order from Aquillina.",
                    pos  = "Bastok Markets (!pos -97 -5 -81)",
                    done = { status = 1 },
                },
                {
                    text = "Gather four Flint Stones.",
                    done = { item = 768, qty = 4 }, -- FLINT_STONE x4
                },
                {
                    text = "Trade the four stones to Aquillina. She takes a batch only once every fifteen minutes.",
                    pos  = "Bastok Markets (!pos -97 -5 -81)",
                },
            },
        },
        [15] = { -- SMOKE_ON_THE_MOUNTAIN
            -- Named from the enum: the script header carries a copy-pasted
            -- "Shady Business" title that belongs to quest 8.
            name = "Smoke on the Mountain",
            repeatable = true,
            steps = {
                {
                    text = "Hear Hungry Wolf out in the Metalworks.",
                    pos  = "Metalworks (!pos -25 -11 -30)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Slice of Giant Sheep Meat to the campfire ??? in South Gustaberg, give it a minute to cook, then take the Galkan Sausage off the fire.",
                    pos  = "South Gustaberg (!pos 461 -20 -578)",
                    done = { item = 4395 }, -- GALKAN_SAUSAGE
                },
                {
                    text = "Trade the sausage to Hungry Wolf.",
                    pos  = "Metalworks (!pos -25 -11 -30)",
                },
            },
        },
        [16] = { -- STAMP_HUNT
            name = "Stamp Hunt",
            steps = {
                {
                    text = "Take the Stamp Sheet from Arawn.",
                    pos  = "Bastok Markets (!pos -121 -4 -123)",
                    done = { status = 1 },
                },
                {
                    text = "Collect all seven stamps: Pavel in the Markets, Deadly Spider and Tall Mountain in the Mines, Elayne and Romualdo in the Metalworks, Ehrhard and Latifah in Port Bastok.",
                    done = { var = 'Prog', gte = 127 },
                },
                {
                    text = "Take the full sheet back to Arawn.",
                    pos  = "Bastok Markets (!pos -121 -4 -123)",
                },
            },
        },
        [17] = { -- FOREVER_TO_HOLD
            name = "Forever to Hold",
            steps = {
                {
                    text = "Hear Qiji out. He will not ask below Bastok fame level 2.",
                    pos  = "Port Bastok (!pos 4 4 -18)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Trade the Brass Hairpin to Romilda beside him -- Qiji cannot bring himself to hand it over.",
                    pos  = "Port Bastok (!pos 5 4 -18)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Go back to Qiji.",
                    pos  = "Port Bastok (!pos 4 4 -18)",
                },
            },
        },
        [18] = { -- TILL_DEATH_DO_US_PART
            name = "Till Death Do Us Part",
            steps = {
                {
                    text = "Hear Romilda out. She asks for a finished Forever to Hold and Bastok fame level 3.",
                    pos  = "Port Bastok (!pos 5 4 -18)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a pair of Cotton Gloves.",
                    done = { item = 12721 }, -- COTTON_GLOVES
                },
                {
                    text = "Trade the gloves to Romilda.",
                    pos  = "Port Bastok (!pos 5 4 -18)",
                },
            },
        },
        [19] = { -- FALLEN_COMRADES
            name = "Fallen Comrades",
            repeatable = true,
            steps = {
                {
                    text = "Hear Pavvke out. He will not ask below Bastok fame level 2.",
                    pos  = "Bastok Mines (!pos 16 6 -14)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Silver Name Tag.",
                    done = { item = 13116 }, -- SILVER_NAME_TAG
                },
                {
                    text = "Trade the tag to Pavvke.",
                    pos  = "Bastok Mines (!pos 16 6 -14)",
                },
            },
        },
        [20] = { -- RIVALS
            name = "Rivals",
            steps = {
                {
                    text = "Hear Detzo out. He will not ask below Bastok fame level 3.",
                    pos  = "Bastok Mines (!pos 5 6 9)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Mythril Sallet.",
                    done = { item = 12417 }, -- MYTHRIL_SALLET
                },
                {
                    text = "Trade the sallet to Detzo.",
                    pos  = "Bastok Mines (!pos 5 6 9)",
                },
            },
        },
        [21] = { -- MOM_THE_ADVENTURER
            name = "Mom, the Adventurer?",
            repeatable = true,
            steps = {
                {
                    text = "Hear Nbu Latteh out; she sends you off with a Fire Crystal.",
                    pos  = "Bastok Markets (!pos -114 -4 -113)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Copper Ring to Roh Latteh in the Mines; he writes back.",
                    pos  = "Bastok Mines (!pos -11 6 -9)",
                    done = { ki = 107 }, -- LETTER_FROM_ROH_LATTEH
                },
                {
                    text = "Take the Letter from Roh Latteh to Nbu Latteh -- read it on the way and she pays better.",
                    pos  = "Bastok Markets (!pos -114 -4 -113)",
                },
            },
        },
        [22] = { -- THE_SIGNPOST_MARKS_THE_SPOT
            name = "The Signpost Marks the Spot",
            steps = {
                {
                    text = "Hear Nbu Latteh out again. She asks for a finished Mom, the Adventurer?, Bastok fame level 2, and that you have zoned since that quest ended.",
                    pos  = "Bastok Markets (!pos -114 -4 -113)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Examine the signpost out in Konschtat Highlands for the Painting of a Windmill.",
                    pos  = "Konschtat Highlands (!pos -183 65 599)",
                    done = { ki = 108 }, -- PAINTING_OF_A_WINDMILL
                },
                {
                    text = "Take the painting to Roh Latteh in the Mines.",
                    pos  = "Bastok Mines (!pos -11 6 -9)",
                },
            },
        },
        [23] = { -- PAST_PERFECT
            name = "Past Perfect",
            steps = {
                {
                    text = "Hear Evi out -- twice: the first telling only gets her started. She will not ask below Bastok fame level 2.",
                    pos  = "Port Bastok (!pos -4 -2 1)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Pick up the Tattered Mission Orders at the ??? in Konschtat Highlands.",
                    pos  = "Konschtat Highlands (!pos -201 16 80)",
                    done = { ki = 109 }, -- TATTERED_MISSION_ORDERS
                },
                {
                    text = "Take the orders back to Evi.",
                    pos  = "Port Bastok (!pos -4 -2 1)",
                },
            },
        },
        [24] = { -- STARDUST
            name = "Stardust",
            repeatable = true,
            steps = {
                {
                    text = "Hear Baldric out. He will not ask below Bastok fame level 2.",
                    pos  = "Metalworks (!pos -50 1 -31)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Pinch of Valkurm Sunsand.",
                    done = { item = 503 }, -- PINCH_OF_VALKURM_SUNSAND
                },
                {
                    text = "Trade the sunsand to Baldric.",
                    pos  = "Metalworks (!pos -50 1 -31)",
                },
            },
        },
        [25] = { -- MEAN_MACHINE
            name = "Mean Machine",
            steps = {
                {
                    text = "Hear Unlucky Rat out in the Metalworks. He will not ask below Bastok fame level 2.",
                    pos  = "Metalworks",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Vial of Slime Oil.",
                    done = { item = 637 }, -- VIAL_OF_SLIME_OIL
                },
                {
                    text = "Trade the oil to Unlucky Rat.",
                    pos  = "Metalworks",
                },
            },
        },
        [26] = { -- CIDS_SECRET
            name = "Cid's Secret",
            steps = {
                {
                    text = "Hear Cid out. He will not confide below Bastok fame level 4.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 4 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Ask Hilda about it behind the bar in Port Bastok.",
                    pos  = "Port Bastok (!pos -163 -8 13)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade Hilda a Rolanberry 874 C.E.; she parts with the Unfinished Letter.",
                    pos  = "Port Bastok (!pos -163 -8 13)",
                    done = { allOf = { { var = 'Prog', gte = 1 }, { ki = 114 } } }, -- UNFINISHED_LETTER
                },
                {
                    text = "Take the letter back to Cid.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                },
            },
        },
        [27] = { -- THE_USUAL
            name = "The Usual",
            steps = {
                {
                    text = "Hear Hilda out. She asks for a finished Cid's Secret and Bastok fame level 5.",
                    pos  = "Port Bastok (!pos -163 -8 13)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 5 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Trade Hilda a King Truffle for the Steaming Sheep Invitation, then carry it to Raibaht in the Metalworks.",
                    pos  = "Raibaht: Metalworks (!pos -27 -10 -1)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Go back to Hilda.",
                    pos  = "Port Bastok (!pos -163 -8 13)",
                },
            },
        },
        [28] = { -- BLADE_OF_DARKNESS
            name = "Blade of Darkness",
            steps = {
                {
                    text = "Hear Gumbah out. He tells this story only to the advanced-job level and above.",
                    pos  = "Bastok Mines (!pos 52 0 -36)",
                    done = { status = 1 },
                },
                {
                    text = "Walk into Zeruhn Mines from the Palborough Mines side; the Chaosbringer is waiting there.",
                    pos  = "Zeruhn Mines, entering from Palborough Mines",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Wield the Chaosbringer and take a hundred kills with it, then walk into Beadeaux from Pashhow Marshlands.",
                    pos  = "Beadeaux, entering from Pashhow Marshlands",
                },
            },
        },
        [29] = { -- FATHER_FIGURE
            name = "Father Figure",
            steps = {
                {
                    text = "Hear Michea out. He asks for a finished The Elvaan Goldsmith and Bastok fame level 2.",
                    pos  = "Bastok Markets (!pos -298 -16 -157)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Silver Ingot.",
                    done = { item = 744 }, -- SILVER_INGOT
                },
                {
                    text = "Trade the ingot to Michea.",
                    pos  = "Bastok Markets (!pos -298 -16 -157)",
                },
            },
        },
        [30] = { -- THE_RETURN_OF_THE_ADVENTURER
            name = "The Return of the Adventurer",
            steps = {
                {
                    text = "Hear Gwill out. He asks for a finished Father Figure and Bastok fame level 3.",
                    pos  = "Bastok Markets (!pos -317 -15 -177)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Stick of Cinnamon.",
                    done = { item = 628 }, -- STICK_OF_CINNAMON
                },
                {
                    text = "Trade the cinnamon to Gwill.",
                    pos  = "Bastok Markets (!pos -317 -15 -177)",
                },
            },
        },
        [31] = { -- DRACHENFALL
            name = "Drachenfall",
            steps = {
                {
                    text = "Hear Black Mud out, and take the Brass Canteen with you. He will not ask below Bastok fame level 2.",
                    pos  = "Bastok Mines (!pos 63 7 0)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Trade the canteen to the foot of the waterfall in North Gustaberg to fill it. Lost it? Black Mud will hand you another.",
                    pos  = "North Gustaberg (!pos -217 98 464)",
                    done = { item = 492 }, -- CANTEEN_OF_DRACHENFALL_WATER
                },
                {
                    text = "Trade the Canteen of Drachenfall Water to Black Mud.",
                    pos  = "Bastok Mines (!pos 63 7 0)",
                },
            },
        },
        [32] = { -- VENGEFUL_WRATH
            name = "Vengeful Wrath",
            repeatable = true,
            steps = {
                {
                    text = "Hear Goraow out. He will not ask below Bastok fame level 3.",
                    pos  = "Bastok Mines (!pos 38 0 14)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Quadav Helm.",
                    done = { item = 501 }, -- QUADAV_HELM
                },
                {
                    text = "Trade the helm to Goraow.",
                    pos  = "Bastok Mines (!pos 38 0 14)",
                },
            },
        },
        [33] = { -- BEADEAUX_SMOG
            name = "Beadeaux Smog",
            steps = {
                {
                    text = "Hear High Bear out in the Metalworks. He will not ask below Bastok fame level 4.",
                    pos  = "Metalworks (!pos 25 -14 4)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 4 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Scoop up the Corrupted Dirt at the ??? inside Beadeaux.",
                    pos  = "Beadeaux (!pos -58 1 -116)",
                    done = { ki = 140 }, -- CORRUPTED_DIRT
                },
                {
                    text = "Take the dirt back to High Bear.",
                    pos  = "Metalworks (!pos 25 -14 4)",
                },
            },
        },
        [34] = { -- THE_CURSE_COLLECTOR
            name = "The Curse Collector",
            steps = {
                {
                    text = "Take the Cursepaper from Zon-Fobun. He will not ask below Bastok fame level 4.",
                    pos  = "Bastok Markets (!pos -241 -3 63)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 4 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Carry the Cursepaper into Beadeaux: touch the Mute, and walk where the afflicted gather -- part of that ground is up on the higher terraces.",
                    pos  = "Beadeaux (the Mute !pos -166 -1 -73)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Take the Cursepaper back to Zon-Fobun.",
                    pos  = "Bastok Markets (!pos -241 -3 63)",
                },
            },
        },
        [35] = { -- FEAR_OF_FLYING
            name = "Fear of Flying",
            steps = {
                {
                    text = "Hear Kurando out. He will not ask below Bastok fame level 3.",
                    pos  = "Port Bastok (!pos -23 3 0)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Silkworm Egg.",
                    done = { item = 4526 }, -- SILKWORM_EGG
                },
                {
                    text = "Trade the egg to Kurando.",
                    pos  = "Port Bastok (!pos -23 3 0)",
                },
            },
        },
        [36] = { -- THE_WISDOM_OF_ELDERS
            name = "The Wisdom of Elders",
            steps = {
                {
                    text = "Hear Benita out.",
                    pos  = "Port Bastok (!pos 49 -4 36)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a Pinch of Bomb Ash. Tete, a few steps away, will tell you where to look.",
                    done = { item = 928 }, -- PINCH_OF_BOMB_ASH
                },
                {
                    text = "Trade the ash to Benita.",
                    pos  = "Port Bastok (!pos 49 -4 36)",
                },
            },
        },
        [37] = { -- GROCERIES
            name = "Groceries",
            steps = {
                {
                    text = "Take Tami's Note from her.",
                    pos  = "Bastok Mines (!pos 62 0 -68)",
                    done = { status = 1 },
                },
                {
                    text = "Read the note yourself -- open it in your key items -- before showing it to Zelman in Zeruhn Mines. Hand it over unread and Tami starts you over.",
                    pos  = "Zeruhn Mines (!pos 17 7 -52)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Trade Tami a Strip of Meat Jerky.",
                    pos  = "Bastok Mines (!pos 62 0 -68)",
                },
            },
        },
        [38] = { -- THE_BARE_BONES
            name = "The Bare Bones",
            steps = {
                {
                    text = "Hear Degenhard out. Biggorf beside him has more to say about it.",
                    pos  = "Bastok Markets (!pos -175 2 -135)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a Bone Chip.",
                    done = { item = 880 }, -- BONE_CHIP
                },
                {
                    text = "Trade the chip to Degenhard.",
                    pos  = "Bastok Markets (!pos -175 2 -135)",
                },
            },
        },
        [39] = { -- MINESWEEPER
            name = "Minesweeper",
            repeatable = true,
            steps = {
                {
                    text = "Take Gerbaum's order for soot.",
                    pos  = "Bastok Mines (!pos -119 -3 -74)",
                    done = { status = 1 },
                },
                {
                    text = "Gather three Pinches of Zeruhn Soot.",
                    done = { item = 560, qty = 3 }, -- PINCH_OF_ZERUHN_SOOT x3
                },
                {
                    text = "Trade the three pinches to Gerbaum.",
                    pos  = "Bastok Mines (!pos -119 -3 -74)",
                },
            },
        },
        [40] = { -- THE_DARKSMITH
            name = "The Darksmith",
            repeatable = true,
            steps = {
                {
                    text = "Take Mighty Fist's order for ore. He will not ask below Bastok fame level 3.",
                    pos  = "Metalworks (!pos -47 2 -30)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Gather two Chunks of Darksteel Ore.",
                    done = { item = 645, qty = 2 }, -- CHUNK_OF_DARKSTEEL_ORE x2
                },
                {
                    text = "Trade the two chunks to Mighty Fist.",
                    pos  = "Metalworks (!pos -47 2 -30)",
                },
            },
        },
        [41] = { -- BUCKETS_OF_GOLD
            name = "Buckets of Gold",
            repeatable = true,
            steps = {
                {
                    text = "Take Foss's order for buckets.",
                    pos  = "Bastok Markets (!pos -283 -12 -37)",
                    done = { status = 1 },
                },
                {
                    text = "Fish up five Rusty Buckets.",
                    done = { item = 90, qty = 5 }, -- RUSTY_BUCKET x5
                },
                {
                    text = "Trade the five buckets to Foss.",
                    pos  = "Bastok Markets (!pos -283 -12 -37)",
                },
            },
        },
        [42] = { -- THE_STARS_OF_IFRIT
            name = "The Stars of Ifrit",
            steps = {
                {
                    text = "Hear Agapito out. He asks for the Airship Pass in your key items and Bastok fame level 3.",
                    pos  = "Port Bastok (!pos -72 -3 9)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Ride the San d'Oria-Jeuno airship at night under a full moon and examine the ??? on deck for the Carrier Pigeon Letter.",
                    pos  = "San d'Oria-Jeuno Airship (!pos -9 -5 -13)",
                    done = { ki = 162 }, -- CARRIER_PIGEON_LETTER
                },
                {
                    text = "Take the letter back to Agapito.",
                    pos  = "Port Bastok (!pos -72 -3 9)",
                },
            },
        },
        [43] = { -- LOVE_AND_ICE
            name = "Love and Ice",
            steps = {
                {
                    text = "Hear Carmelo out. He asks for a finished The Siren's Tear, Bastok fame level 5, and that you have read the Carrier Pigeon Letter.",
                    pos  = "Port Bastok (!pos -146 -7 -10)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 5 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Carry Carmelo's Song Sheet to the mirror pond in Beaucedine Glacier, then go back and tell him what came of it.",
                    pos  = "Beaucedine Glacier (!pos -96 1 -392)",
                },
            },
        },
        [44] = { -- BRYGID_THE_STYLIST
            name = "Brygid the Stylist",
            steps = {
                {
                    text = "Hear Brygid out on the subject of your wardrobe.",
                    pos  = "Bastok Markets (!pos -90 -4 -108)",
                    done = { status = 1 },
                },
                {
                    text = "Come back to her wearing a Robe and a Bronze Subligar at the same time.",
                    pos  = "Bastok Markets (!pos -90 -4 -108)",
                },
            },
        },
        [45] = { -- THE_GUSTABERG_TOUR
            name = "The Gustaberg Tour",
            steps = {
                {
                    text = "Take the tour from Izabele in the Metalworks.",
                    pos  = "Metalworks (!pos -43 -10 -2)",
                    done = { status = 1 },
                },
                {
                    text = "Find Hunting Bear out in North Gustaberg, then report back to Izabele.",
                    pos  = "North Gustaberg (!pos -235 40 424)",
                },
            },
        },
        [46] = { -- BITE_THE_DUST
            name = "Bite the Dust",
            repeatable = true,
            steps = {
                {
                    text = "Take Yazan's order for fangs. He will not ask below Bastok fame level 2.",
                    pos  = "Port Bastok (!pos -20 -3 24)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a Sand Bat Fang.",
                    done = { item = 1015 }, -- SAND_BAT_FANG
                },
                {
                    text = "Trade the fang to Yazan.",
                    pos  = "Port Bastok (!pos -20 -3 24)",
                },
            },
        },
        [47] = { -- BLADE_OF_DEATH
            name = "Blade of Death",
            steps = {
                {
                    text = "Hear Gumbah out, and take the Letter from Zeid with it. He asks for a finished Blade of Darkness and Bastok fame level 3.",
                    pos  = "Bastok Mines (!pos 52 0 -36)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Take 200 kills with the Chaosbringer -- Zeruhn Mines hands you another from the Palborough side if yours is gone -- then trade the blade to the ??? in Gusgen Mines.",
                    pos  = "Gusgen Mines (!pos 206 -60 -101)",
                },
            },
        },
        [48] = { -- SILENCE_OF_THE_RAMS
            name = "Silence of the Rams",
            steps = {
                {
                    text = "Hear Paujean out. He will not ask below Norg fame level 2.",
                    pos  = "Port Bastok (!pos -93 4 34)",
                    done = { allOf = { { status = 1 }, { fame = { area = 5, level = 2 } } } }, -- fameArea.NORG
                },
                {
                    text = "Come by both horns: a Lumbering Horn and a Rampaging Horn.",
                    done = {
                        allOf = {
                            { item = 910 }, -- LUMBERING_HORN
                            { item = 911 }, -- RAMPAGING_HORN
                        },
                    },
                },
                {
                    text = "Trade both horns to Paujean in a single trade.",
                    pos  = "Port Bastok (!pos -93 4 34)",
                },
            },
        },
        [49] = { -- ALTANAS_SORROW
            name = "Altana's Sorrow",
            steps = {
                {
                    text = "Hear Virnage out. He asks for level 10 and Bastok fame level 4.",
                    pos  = "Bastok Mines (!pos 0 0 51)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 4 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Take the Bucket of Divine Paint from the ??? in Garlaige Citadel back to Virnage; he swaps it for a letter.",
                    pos  = "Garlaige Citadel (!pos -282 0 261)",
                    done = { ki = 174 }, -- LETTER_FROM_VIRNAGE
                },
                {
                    text = "Carry the Letter from Virnage to Eperdur in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos 129 -6 96)",
                },
            },
        },
        [50] = { -- A_LADYS_HEART
            name = "A Lady's Heart",
            steps = {
                {
                    text = "Trade Valah Molkot a flower -- any flower -- or just speak to him, and he takes you on.",
                    pos  = "Port Bastok (!pos 59 8 -221)",
                    done = { status = 1 },
                },
                {
                    text = "Bring him the one flower he is really after: an Amaryllis.",
                    pos  = "Port Bastok (!pos 59 8 -221)",
                },
            },
        },
        [51] = { -- GHOSTS_OF_THE_PAST
            name = "Ghosts of the Past",
            steps = {
                {
                    text = "Hear Oggbi out. Monk has to be your main job, at the artifact level or better.",
                    pos  = "Port Bastok (!pos -159 -7 5)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Pickaxe to the ??? in Gusgen Mines to raise the Wandering Ghost, and take the Miner's Pendant off it.",
                    pos  = "Gusgen Mines (!pos -174 0 369)",
                    done = { item = 13122 }, -- MINERS_PENDANT
                },
                {
                    text = "Trade the pendant to Oggbi.",
                    pos  = "Port Bastok (!pos -159 -7 5)",
                },
            },
        },
        [52] = { -- THE_FIRST_MEETING
            name = "The First Meeting",
            steps = {
                {
                    text = "Hear Oggbi out again. Monk main job at the artifact level, with Ghosts of the Past behind you and a zone since.",
                    pos  = "Port Bastok (!pos -159 -7 5)",
                    done = { status = 1 },
                },
                {
                    text = "Walk into Fei'Yin from Qu'Bia Arena for the Letter from Dalzakk, then search the hide flap in Davoi from right up close: it wakes Bilopdop and Deloknok. Beat both and search again.",
                    pos  = "Davoi (!pos -124 3 -43)",
                    done = { ki = 192 }, -- SAN_DORIAN_MARTIAL_ARTS_SCROLL
                },
                {
                    text = "Take both back to Oggbi.",
                    pos  = "Port Bastok (!pos -159 -7 5)",
                },
            },
        },
        [53] = { -- TRUE_STRENGTH
            name = "True Strength",
            steps = {
                {
                    text = "Hear Ayame out in the Metalworks. Monk main job at the artifact level, with The First Meeting behind you.",
                    pos  = "Metalworks (!pos 133 -19 34)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Bottle of Yagudo Drink to the ??? in Castle Oztroja to draw out Huu Xalmo the Savage, and take the Xalmo Feather off it.",
                    pos  = "Castle Oztroja (!pos -100 -71 -132)",
                    done = { item = 1100 }, -- XALMO_FEATHER
                },
                {
                    text = "Trade the feather to Ayame.",
                    pos  = "Metalworks (!pos 133 -19 34)",
                },
            },
        },
        [54] = { -- THE_DOORMAN
            name = "The Doorman",
            steps = {
                {
                    text = "Hear Phara out. Warrior has to be your main job, at the artifact level or better.",
                    pos  = "Bastok Mines (!pos 75 0 -80)",
                    done = { status = 1 },
                },
                {
                    text = "Search the hide flap in Davoi from right up close: it wakes Gavotvut and Barakbok. Beat both, search again for the Sword Grip Material, and take it to Phara.",
                    pos  = "Davoi (!pos 293 3 -213)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Come back to Phara a day later for Yasin's Sword.",
                    pos  = "Bastok Mines (!pos 75 0 -80)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Carry the sword to Naji in the Metalworks.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                },
            },
        },
        [55] = { -- THE_TALEKEEPERS_TRUTH
            name = "The Talekeeper's Truth",
            steps = {
                {
                    text = "Hear Phara out, then Deidogg twice -- the second telling is where he takes you on. Warrior main job at the artifact level, with The Doorman behind you.",
                    pos  = "Bastok Mines (Phara !pos 75 0 -80, Deidogg !pos -13 7 29)",
                    done = { status = 1 },
                },
                {
                    text = "Draw out Ni'Ghu Nestfender at the ??? in Palborough Mines for a Mottled Quadav Egg, and trade the egg to Deidogg.",
                    pos  = "Palborough Mines (!pos 15 -31 -94)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade Deidogg a Parasite Skin.",
                    pos  = "Bastok Mines (!pos -13 7 29)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Come back to Deidogg a day later.",
                    pos  = "Bastok Mines (!pos -13 7 29)",
                },
            },
        },
        [56] = { -- THE_TALEKEEPERS_GIFT
            name = "The Talekeeper's Gift",
            steps = {
                {
                    text = "Talk to Deidogg, then Detzo, then trade Deidogg a Ginger Cookie. Warrior main job at the artifact level, with The Talekeeper's Truth behind you and a day since.",
                    pos  = "Bastok Mines (Deidogg !pos -13 7 29, Detzo !pos 5 6 9)",
                    done = { status = 1 },
                },
                {
                    text = "Examine the ??? in Behemoth's Dominion and put down all three it calls: Picklix Longindex, Moxnix Nightgoggle and Doglix Muttsnout.",
                    pos  = "Behemoth's Dominion",
                    done = { var = 'Prog', gte = 7 },
                },
                {
                    text = "Walk from Behemoth's Dominion into Qufim Island.",
                    pos  = "Qufim Island, entering from Behemoth's Dominion",
                },
            },
        },
        [57] = { -- DARK_LEGACY
            name = "Dark Legacy",
            steps = {
                {
                    text = "Hear Raibaht out in the Metalworks. Dark knight has to be your main job, at the artifact level or better.",
                    pos  = "Metalworks (!pos -27 -10 -1)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Mighty Fist a few steps away; he writes the Letter from the Darksteel Forge.",
                    pos  = "Metalworks (!pos -47 2 -30)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Carry the letter to Cochal-Monchal in Windurst Waters.",
                    pos  = "Windurst Waters (!pos -52 -6 110)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "In Giddeus, trade a Yagudo Cherry to the ??? to draw out Vaa Huja the Erudite, and put it down.",
                    pos  = "Giddeus (!pos -58 0 -449)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Examine that ??? again for the Darksteel Formula, then take it to Raibaht.",
                    pos  = "Giddeus (!pos -58 0 -449), then Metalworks (!pos -27 -10 -1)",
                },
            },
        },
        [58] = { -- DARK_PUPPET
            name = "Dark Puppet",
            steps = {
                {
                    text = "Hear Cid out in the Metalworks. Dark knight main job at the artifact level, with Dark Legacy behind you.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                    done = { status = 1 },
                },
                {
                    text = "Walk into Ordelle's Caves for the vision that starts the hunt.",
                    pos  = "Ordelle's Caves",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Work the three ??? in turn -- a Darksteel Ingot at the first, Gerwitz's Axe at the second, Gerwitz's Sword at the third. Each fight leaves the next offering. Gerwitz's Soul comes last.",
                    pos  = "Ordelle's Caves (!pos -52 27 -85 / -92 -28 -70 / -132 -27 -245)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Leave for La Theine Plateau.",
                    pos  = "La Theine Plateau",
                },
            },
        },
        [59] = { -- BLADE_OF_EVIL
            name = "Blade of Evil",
            steps = {
                {
                    text = "Walk into Beadeaux from Pashhow Marshlands. Dark knight main job at the artifact level, with Dark Puppet behind you.",
                    pos  = "Beadeaux, entering from Pashhow Marshlands",
                    done = { status = 1 },
                },
                {
                    text = "In Middle Delkfutt's Tower, trade a Vial of Quadav Mage Blood to the ??? and put down what answers -- Gerwitz's Scythe among them.",
                    pos  = "Middle Delkfutt's Tower (!pos 84 -79 77)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Walk deeper into the tower until the scythe finds you.",
                    pos  = "Middle Delkfutt's Tower",
                },
            },
        },
        [60] = { -- AYAME_AND_KAEDE
            name = "Ayame and Kaede",
            steps = {
                {
                    text = "Hear Kaede out at the advanced-job level or better.",
                    pos  = "Port Bastok (!pos 48 -6 67)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Kagetora about the two of them.",
                    pos  = "Port Bastok (!pos -96 -2 29)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take what he said to Ensetsu.",
                    pos  = "Port Bastok (!pos 33 -6 67)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "At the ??? in Korroloka Tunnel, put down the three Korroloka Leeches it calls, then examine it again for the Strangely Shaped Coral.",
                    pos  = "Korroloka Tunnel (!pos -208 -9 176)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Show the coral to Ensetsu.",
                    pos  = "Port Bastok (!pos 33 -6 67)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Carry it to Ryoma in Norg; he seals it into a dagger.",
                    pos  = "Norg (!pos -23 0 -9)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Take the Sealed Dagger back to Ensetsu to be made a ninja.",
                    pos  = "Port Bastok (!pos 33 -6 67)",
                },
            },
        },
        [61] = { -- TRIAL_BY_EARTH
            name = "Trial by Earth",
            steps = {
                {
                    text = "Take the Tuning Fork of Earth from Juroro. He will not ask below Bastok fame level 6.",
                    pos  = "Port Bastok (!pos 32 7 -41)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 6 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Carry the fork into the Cloister of Tremors and best Titan there; the Whisper of Tremors is your proof.",
                    pos  = "Cloister of Tremors",
                    done = { ki = 321 }, -- WHISPER_OF_TREMORS
                },
                {
                    text = "Take the whisper back to Juroro.",
                    pos  = "Port Bastok (!pos 32 7 -41)",
                },
            },
        },
        [62] = { -- A_TEST_OF_TRUE_LOVE
            name = "A Test of True Love",
            steps = {
                {
                    text = "Hear Carmelo out. He asks for a finished Love and Ice, Bastok fame level 6, and that you have zoned since that quest ended.",
                    pos  = "Port Bastok (!pos -146 -7 -10)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 6 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "His search runs through Castle Zvahl, the Labyrinth of Onzozo and Sea Serpent Grotto. Come back to him when it is done.",
                    pos  = "Port Bastok (!pos -146 -7 -10)",
                },
            },
        },
        [63] = { -- LOVERS_IN_THE_DUSK
            name = "Lovers in the Dusk",
            steps = {
                {
                    text = "Hear Carmelo out one last time. He asks for a finished A Test of True Love, Bastok fame level 6, and a zone since.",
                    pos  = "Port Bastok (!pos -146 -7 -10)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 6 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Carry the Chanson de Liberte to the ??? in the Sanctuary of Zi'Tah, then go back to Carmelo.",
                    pos  = "The Sanctuary of Zi'Tah",
                },
            },
        },
        [64] = { -- WISH_UPON_A_STAR
            name = "Wish Upon a Star",
            steps = {
                {
                    text = "Hear the star-watchers out in Bastok Markets -- Zacc, Enu and Malene between them. They will not ask below Bastok fame level 5.",
                    pos  = "Bastok Markets (Zacc !pos -255 -13 -91, Enu !pos -253 -13 -92)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 5 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Trade a Hatchet to a logging point in Yuhtunga or Yhoator Jungle until a Fallen Star turns up.",
                    pos  = "Yuhtunga Jungle / Yhoator Jungle logging points",
                    done = { item = 1192 }, -- FALLEN_STAR
                },
                {
                    text = "Trade the Fallen Star to Enu.",
                    pos  = "Bastok Markets (!pos -253 -13 -92)",
                },
            },
        },
        [65] = { name = "Eco Warrior" }, -- ECO_WARRIOR (name from enum; no script header found)
        [66] = { -- THE_WEIGHT_OF_YOUR_LIMITS
            name = "The Weight of Your Limits",
            steps = {
                {
                    text = "Take the weapon trial from Iron Eater: great axe skill 240, a body that can wield the Axe of Trials, and no training guide already in hand.",
                    pos  = "Metalworks (!pos 92 -19 2)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Axe of Trials until Iron Eater will take it back, then follow his map to the Sanctuary of Zi'Tah: the ??? there draws out Greenman, and it gives up the Annals of Truth.",
                    pos  = "The Sanctuary of Zi'Tah (!pos -324 1 474)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Iron Eater to learn Steel Cyclone.",
                    pos  = "Metalworks (!pos 92 -19 2)",
                },
            },
        },
        [67] = { -- SHOOT_FIRST_ASK_QUESTIONS_LATER
            name = "Shoot First, Ask Questions Later",
            steps = {
                {
                    text = "Take the weapon trial from Cid: marksmanship skill 250, a body that can wield the Gun of Trials, and no training guide already in hand.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Gun of Trials until Cid will take it back, then follow his map to the Boyahda Tree: the ??? there draws out the Beet Leafhopper, and it gives up the Annals of Truth.",
                    pos  = "The Boyahda Tree (!pos -11 -19 -177)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Cid to learn Detonator.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                },
            },
        },
        [68] = { -- INHERITANCE
            name = "Inheritance",
            steps = {
                {
                    text = "Take the weapon trial from Gumbah: great sword skill 250, a body that can wield the Sword of Trials, and no training guide already in hand.",
                    pos  = "Bastok Mines (!pos 52 0 -36)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Sword of Trials until Gumbah will take it back, then follow his map to the Western Altepa Desert: the ??? there draws out Maharaja, and it gives up the Annals of Truth.",
                    pos  = "Western Altepa Desert (!pos -660 0 -338)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Gumbah to learn Ground Strike.",
                    pos  = "Bastok Mines (!pos 52 0 -36)",
                },
            },
        },
        [69] = { -- THE_WALLS_OF_YOUR_MIND
            name = "The Walls of Your Mind",
            steps = {
                {
                    text = "Take the weapon trial from Oggbi: hand-to-hand skill 250, a body that can wield the Knuckles of Trials, and no training guide already in hand.",
                    pos  = "Port Bastok (!pos -159 -7 5)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Knuckles of Trials until Oggbi will take them back, then follow his map to the Bostaunieux Oubliette: the ??? there draws out Bodach, and it gives up the Annals of Truth.",
                    pos  = "Bostaunieux Oubliette (!pos 20 17 -140)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Oggbi to learn Asuran Fists.",
                    pos  = "Port Bastok (!pos -159 -7 5)",
                },
            },
        },
        [70] = { name = "Escort for Hire" }, -- ESCORT_FOR_HIRE (name from enum; no script header found)
        [71] = { name = "A Discerning Eye" }, -- A_DISCERNING_EYE (name from enum; no script header found)
        [72] = { -- TRIAL_SIZE_TRIAL_BY_EARTH
            name = "Trial-Size Trial by Earth",
            steps = {
                {
                    text = "Take the Mini Tuning Fork of Earth from Ferrol. Summoner main job at level 20 or better, and Bastok fame level 2.",
                    pos  = "Port Bastok (!pos 33 6 -39)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 2 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Carry the fork into the Cloister of Tremors, beat what waits there, and report back to Ferrol.",
                    pos  = "Cloister of Tremors",
                },
            },
        },
        [73] = { -- FADED_PROMISES
            name = "Faded Promises",
            steps = {
                {
                    text = "Hear Romualdo out in the Metalworks. Ninja main job at level 20 or better, and Bastok fame level 4.",
                    pos  = "Metalworks (!pos 133 -19 -36)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 4 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Hear Ayame out, a few steps away.",
                    pos  = "Metalworks (!pos 133 -19 34)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Open a treasure chest in Palborough Mines for the Diary of Mukunda, then show it to Kagetora in Port Bastok.",
                    pos  = "Palborough Mines, then Port Bastok (!pos -96 -2 29)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Take the diary back to Ayame.",
                    pos  = "Metalworks (!pos 133 -19 34)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Then see Alois, a few steps from her.",
                    pos  = "Metalworks (!pos 96 -20 14)",
                },
            },
        },
        [74] = { -- BRYGID_THE_STYLIST_RETURNS
            name = "Brygid the Stylist Returns",
            steps = {
                {
                    text = "Show Brygid your artifact armor -- she has opinions. Needs a finished Brygid the Stylist.",
                    pos  = "Bastok Markets (!pos -90 -4 -108)",
                    done = { status = 1 },
                },
                {
                    text = "Come back to her wearing the two pieces she named, body and legs together.",
                    pos  = "Bastok Markets (!pos -90 -4 -108)",
                },
            },
        },
        [75] = { -- OUT_OF_THE_DEPTHS
            name = "Out of the Depths",
            steps = {
                {
                    text = "Hear Ayame out in the Metalworks. She will not ask below Bastok fame level 3.",
                    pos  = "Metalworks (!pos 132 -18 34)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Ask Ravorara in Port Bastok what he buys.",
                    pos  = "Port Bastok (!pos -150 -6 -8)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Find Brakobrik down in Oldton Movalpolos and hear his offer out.",
                    pos  = "Oldton Movalpolos (!pos 165 12 -89)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade Brakobrik Pinches of Hoary Bomb Ash one to four at a time -- the count decides which piece of junk he digs out -- and sell all four on to Ravorara.",
                    pos  = "Oldton Movalpolos, then Port Bastok (!pos -150 -6 -8)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Sell Ravorara the Old Nametag too.",
                    pos  = "Port Bastok (!pos -150 -6 -8)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Take the story to Pavvke in the Mines.",
                    pos  = "Bastok Mines (!pos 15 6 -14)",
                },
            },
        },
        [76] = { name = "All by Myself" }, -- ALL_BY_MYSELF (name from enum; no script header found)
        [77] = { -- A_QUESTION_OF_FAITH
            name = "A Question of Faith",
            steps = {
                {
                    text = "Hear Ayame out again. She asks for a finished Out of the Depths and Bastok fame level 4.",
                    pos  = "Metalworks (!pos 132 -18 33)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 4 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Take the Dawn Talisman from Virnage in the Mines, then show it to Rakorok in Oldton Movalpolos: it calls up Bugallug. Put it down.",
                    pos  = "Virnage: Bastok Mines (!pos 0 0 49); Rakorok: Oldton Movalpolos",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Hand Rakorok the talisman, then report back to Virnage.",
                    pos  = "Oldton Movalpolos, then Bastok Mines (!pos 0 0 49)",
                },
            },
        },
        [78] = { -- RETURN_TO_THE_DEPTHS
            name = "Return to the Depths",
            steps = {
                {
                    text = "Hear Ayame out once more. She asks for a finished A Question of Faith and Bastok fame level 5.",
                    pos  = "Metalworks (!pos 132 -18 33)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 5 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Pick the errand back up down in Oldton Movalpolos.",
                    pos  = "Oldton Movalpolos",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade a Misareaux Garlic to Muckvix in Lower Jeuno for his letter.",
                    pos  = "Lower Jeuno",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Carry that letter to Magriffon in Kazham and see him through to the Providence Pot.",
                    pos  = "Kazham",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Take the pot back to Muckvix, who returns it a good deal more pungent.",
                    pos  = "Lower Jeuno",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Work the rest through with Tarnotik in Oldton Movalpolos; he wants a Bottle of Ahriman Tears before he is finished.",
                    pos  = "Oldton Movalpolos",
                    done = { var = 'Prog', gte = 8 },
                },
                {
                    text = "Finish it at the ??? in Mine Shaft 2716, then report to Ayame.",
                    pos  = "Mine Shaft 2716, then Metalworks (!pos 132 -18 33)",
                },
            },
        },
        [79] = { -- TEAK_ME_TO_THE_STARS
            name = "Teak Me to the Stars",
            steps = {
                {
                    text = "Take Raibaht's order for lumber. He will not ask below Bastok fame level 3.",
                    pos  = "Metalworks (!pos -27 -10 -1)",
                    done = { allOf = { { status = 1 }, { fame = { area = 1, level = 3 } } } }, -- fameArea.BASTOK
                },
                {
                    text = "Come by a piece of Garhada Teak Lumber.",
                    done = { item = 1727 }, -- GARHADA_TEAK_LUMBER
                },
                {
                    text = "Trade the lumber to Raibaht.",
                    pos  = "Metalworks (!pos -27 -10 -1)",
                },
            },
        },
        [80] = { name = "Hyper Active" }, -- HYPER_ACTIVE (name from enum; no script header found)
        [81] = { name = "The Naming Game" }, -- THE_NAMING_GAME (name from enum; no script header found)
        [82] = { -- CHIPS
            name = "Chips",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Hear Ghebi Damomohe out in Lower Jeuno. She only talks to someone who has been through One to Be Feared.",
                    pos  = "Lower Jeuno (!pos 15 0 -7)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a Carmine Chip.",
                    done = { item = 1692 }, -- CARMINE_CHIP
                },
                {
                    text = "Trade the chip to Cid in the Metalworks.",
                    pos  = "Metalworks (!pos -12 -12 1)",
                },
            },
        },
        [83] = { name = "Bait and Switch" }, -- BAIT_AND_SWITCH (name from enum; no script header found)
        [84] = { -- LURE_OF_THE_WILDCAT
            name = "Lure of the Wildcat (Bastok)",
            gated = 'ENABLE_TOAU',
            steps = {
                {
                    text = "Take the Blue Sentinel Badge from Alib-Mufalib.",
                    pos  = "Port Bastok (!pos 116 7 -31)",
                    done = { status = 1 },
                },
                {
                    text = "Show the badge to all twenty on his list, spread across Port Bastok, Bastok Mines, Bastok Markets and the Metalworks.",
                    done = { var = 'Prog', gte = 1048575 },
                },
                {
                    text = "Report back to Alib-Mufalib.",
                    pos  = "Port Bastok (!pos 116 7 -31)",
                },
            },
        },
        [85] = { -- ACHIEVING_TRUE_POWER
            name = "Achieving True Power",
            gated = 'ENABLE_TOAU',
            steps = {
                {
                    text = "Hear Shamarhaan out. Puppetmaster main job at level 66 or better, with Puppetmaster Blues behind you.",
                    pos  = "Bastok Markets",
                    done = { status = 1 },
                },
                {
                    text = "Take the fight in the Navukgo Execution Chamber, then report back to Shamarhaan.",
                    pos  = "Navukgo Execution Chamber",
                },
            },
        },
        [86] = { name = "Too Many Chefs" }, -- TOO_MANY_CHEFS (name from enum; no script header found)
        [87] = { name = "A Proper Burial" }, -- A_PROPER_BURIAL (name from enum; no script header found)
        [88] = { name = "Fully Mental Alchemist" }, -- FULLY_MENTAL_ALCHEMIST (name from enum; no script header found)
        [89] = { name = "Synergustic Pursuits" }, -- SYNERGUSTIC_PURSUITS (name from enum; no script header found)
        [90] = { name = "The Wondrous Whatchamacallit" }, -- THE_WONDROUS_WHATCHAMACALLIT (name from enum; no script header found)
        [91] = { name = "Synergistic Support" }, -- SYNERGISTIC_SUPPORT (name from enum; no script header found)
        [92] = { -- TRUST_BASTOK
            name = "Trust: Bastok",
            steps = {
                {
                    text = "Hear Clarion Star out; she needs you at level 5 or better.",
                    pos  = "Port Bastok (!pos 81 7 -24)",
                    done = { status = 1 },
                },
                {
                    text = "Carry the Blue Institute Card she gives you to Naji in the Metalworks. Which alter egos he can set up for you depends on how much of Bastok's story you have seen.",
                    pos  = "Metalworks (!pos 64 -14 -4)",
                },
            },
        },
    },
}
