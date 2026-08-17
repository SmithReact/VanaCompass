-- dwtracker data -- San d'Oria quests. Names generated Phase 0
-- (tools/dwtracker_names.py); steps hand-authored from
-- scripts/quests/sandoria/ as ground truth -- The Pickpocket (3),
-- A Squire's Test (10) and Lizard Skins (15) in Phase 1's proof batch, the
-- other 54 in Phase 3. The 25 entries still name-only are ids the enum
-- lists but no script implements on this server: they cannot be accepted,
-- so they can never render a step. Pure data: numeric
-- ids and display strings only, no xi.*, no functions (DWTRACKER_FORMAT.md
-- decisions T2/§3-4). Loaded byte-identically by the server module and the
-- dwtracker addon; both hash these bytes, so an edit that reaches only one
-- side makes the addon refuse step rendering for this area until the
-- copies agree again. tools/dwtracker_lint.py must pass before edits ship.
return {
    kind = 'quests',
    log = 0,
    area = 'sandoria_quests',
    label = "San d'Oria",
    entries = {
        [0] = { -- A_SENTRYS_PERIL
            name = "A Sentry's Peril",
            steps = {
                {
                    text = "Hear out Glenne, who is fretting over her husband on patrol, and take the Dose of Ointment she presses on you.",
                    pos  = "Southern San d'Oria (!pos -122 -2 15)",
                    done = { status = 1 },
                },
                {
                    text = "Find the guard Aaveleon on the Ghelsba road in West Ronfaure and trade him the ointment; he sends the Ointment Case back with you.",
                    pos  = "West Ronfaure (!pos -431 -45 343)",
                    done = { var = 'TradedAaveleon', gte = 1 },
                },
                {
                    text = "Trade the Ointment Case to Glenne.",
                    pos  = "Southern San d'Oria (!pos -122 -2 15)",
                },
            },
        },
        [1] = { -- WATERS_OF_THE_CHEVAL
            name = "Waters of the Cheval",
            steps = {
                {
                    text = "Take the errand from Miageau, just past the cathedral entrance.",
                    pos  = "Northern San d'Oria (!pos 115 0 108)",
                    done = { status = 1 },
                },
                {
                    text = "Buy a Blessed Waterskin from Nouveil beside her for 10 gil, then trade it to the Cheval River at the head of the water in East Ronfaure.",
                    pos  = "East Ronfaure (!pos 223 -58 426)",
                    done = { item = 603 }, -- SKIN_OF_CHEVAL_RIVER_WATER
                },
                {
                    text = "Trade the Skin of Cheval River Water to Miageau.",
                    pos  = "Northern San d'Oria (!pos 115 0 108)",
                },
            },
        },
        [2] = { -- ROSEL_THE_ARMORER
            name = "Rosel the Armorer",
            steps = {
                {
                    text = "Take the delivery from Rosel the armorer; he hands over a Receipt for the Prince.",
                    pos  = "Southern San d'Oria (!pos 69 0 41)",
                    done = { status = 1 },
                },
                {
                    text = "Carry the receipt to Guilerme at the palace gate and name the prince Rosel meant it for, then report back to Rosel for your pay.",
                    pos  = "Guilerme: Northern San d'Oria (!pos -4 0 99)",
                },
            },
        },
        [3] = { -- THE_PICKPOCKET
            name = "The Pickpocket",
            steps = {
                {
                    text = "Talk to little Miene by the fountain and witness the theft, then hear out Altiret, the guard who was robbed.",
                    pos  = "Port San d'Oria (Miene !pos 0 -4 -81, Altiret !pos 21 -4 -65)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Miene for the proof she is holding: a button torn from the thief's coat.",
                    pos  = "Port San d'Oria (!pos 0 -4 -81)",
                    done = { var = 'Stage', gte = 1 },
                },
                {
                    text = "Find Esca in the tower at (F-6) of West Ronfaure and trade her the Eagle Button; confronted, she gives up the Gilt Glasses.",
                    pos  = "West Ronfaure (!pos -624 -51 278)",
                    done = {
                        allOf = {
                            { var = 'Stage', gte = 1 },
                            { item = 579 }, -- GILT_GLASSES
                        },
                    },
                },
                {
                    text = "Trade the Gilt Glasses to Altiret for your reward.",
                    pos  = "Port San d'Oria (!pos 21 -4 -65)",
                },
            },
        },
        [4] = { -- FATHER_AND_SON
            name = "Father and Son",
            steps = {
                {
                    text = "Hear Ailbeche out: his son has not come home.",
                    pos  = "Northern San d'Oria (!pos 4 -1 24)",
                    done = { status = 1 },
                },
                {
                    text = "Find the boy Exoroche loitering in Southern San d'Oria and get him talking.",
                    pos  = "Southern San d'Oria (!pos 72 -1 60)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Go back to Ailbeche with what the boy told you.",
                    pos  = "Northern San d'Oria (!pos 4 -1 24)",
                },
            },
        },
        [5] = { -- THE_SEAMSTRESS
            name = "The Seamstress",
            repeatable = true,
            steps = {
                {
                    text = "Agree to bring Hanaa Punaa the skins her order calls for.",
                    pos  = "Southern San d'Oria (!pos -179 -8 27)",
                    done = { status = 1 },
                },
                {
                    text = "Gather three Sheepskins.",
                    done = { item = 505, qty = 3 }, -- SHEEPSKIN x3
                },
                {
                    text = "Trade the three skins to Hanaa Punaa; the Leather Gloves are your thanks.",
                    pos  = "Southern San d'Oria (!pos -179 -8 27)",
                },
            },
        },
        [6] = { -- THE_DISMAYED_CUSTOMER
            name = "The Dismayed Customer",
            steps = {
                {
                    text = "Take the search job from Gulemont. He only asks once you have finished A Taste for Meat.",
                    pos  = "Port San d'Oria (!pos -69 -5 -38)",
                    done = { status = 1 },
                },
                {
                    text = "Comb the three ??? spots out in West Ronfaure until one gives up Gulemont's Document -- which of the three holds it is decided when you accept.",
                    pos  = "West Ronfaure (!pos -453 -20 -230 / -550 0 -542 / -399 -10 -438)",
                    done = { ki = 129 }, -- GULEMONTS_DOCUMENT
                },
                {
                    text = "Take the document back to Gulemont.",
                    pos  = "Port San d'Oria (!pos -69 -5 -38)",
                },
            },
        },
        [7] = { -- THE_TRADER_IN_THE_FOREST
            name = "The Trader in the Forest",
            steps = {
                {
                    text = "Take the Supplies Order from Abeaule.",
                    pos  = "Northern San d'Oria (!pos -136 -2 56)",
                    done = { status = 1 },
                },
                {
                    text = "Find Phairet trading out in West Ronfaure and hand him the order; he settles it with a Clump of Batagreens.",
                    pos  = "West Ronfaure (!pos -57 -2 -502)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade the batagreens to Abeaule.",
                    pos  = "Northern San d'Oria (!pos -136 -2 56)",
                },
            },
        },
        [8] = { -- THE_SWEETEST_THINGS
            name = "The Sweetest Things",
            repeatable = true,
            steps = {
                {
                    text = "Take Raimbroy's order for honey. He will not talk business below San d'Oria fame level 2.",
                    pos  = "Southern San d'Oria (!pos -141 -3 34)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 2 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Gather five Pots of Honey.",
                    done = { item = 4370, qty = 5 }, -- POT_OF_HONEY x5
                },
                {
                    text = "Trade the five pots to Raimbroy.",
                    pos  = "Southern San d'Oria (!pos -141 -3 34)",
                },
            },
        },
        [9] = { -- THE_VICASQUES_SERMON
            name = "The Vicasque's Sermon",
            steps = {
                {
                    text = "Hear Abioleget's sermon. He takes almsgivers on only once you have finished Waters of the Cheval.",
                    pos  = "Northern San d'Oria (!pos 128 0 118)",
                    done = { status = 1 },
                },
                {
                    text = "Give Abioleget 70 gil for a Pod of Blue Peas, then carry it out to Andelain, who lives rough in East Ronfaure.",
                    pos  = "East Ronfaure (!pos 664 -12 -539)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Return to Abioleget.",
                    pos  = "Northern San d'Oria (!pos 128 0 118)",
                },
            },
        },
        [10] = { -- A_SQUIRES_TEST
            name = "A Squire's Test",
            steps = {
                {
                    text = "Take up Balasiel's test of squirehood.",
                    pos  = "Southern San d'Oria (!pos -136 -11 64)",
                    done = { status = 1 },
                },
                {
                    text = "Fetch a Revival Tree Root from the depths of King Ranperre's Tomb.",
                    done = { item = 940 }, -- REVIVAL_TREE_ROOT
                },
                {
                    text = "Trade the root to Balasiel.",
                    pos  = "Southern San d'Oria (!pos -136 -11 64)",
                },
            },
        },
        [11] = { -- GRAVE_CONCERNS
            name = "Grave Concerns",
            steps = {
                {
                    text = "Take Andecia's errand, and the Skin of Well Water with it. She will not ask below San d'Oria fame level 1.",
                    pos  = "Southern San d'Oria (!pos 167 0 45)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 1 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Trade the well water to the upper tombstone in King Ranperre's Tomb and take away the stale Tomb Guard's Waterskin. Lost the water? Refill at the well in Southern San d'Oria.",
                    pos  = "King Ranperre's Tomb (!pos 1 0 -101)",
                    done = { var = 'OfferingWaterOK', gte = 1 },
                },
                {
                    text = "Trade the Tomb Guard's Waterskin to Andecia.",
                    pos  = "Southern San d'Oria (!pos 167 0 45)",
                },
            },
        },
        [12] = { -- THE_BRUGAIRE_CONSORTIUM
            name = "The Brugaire Consortium",
            steps = {
                {
                    text = "Take the courier work from Fontoumant; the first parcel is for the magic shop.",
                    pos  = "Port San d'Oria (!pos -10 -10 -122)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Parcel for the Magic Shop to Regine, then see Fontoumant for the next one.",
                    pos  = "Regine: Port San d'Oria (!pos 68 -9 -74)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade the Parcel for the Auction House to Apstaule, then see Fontoumant again.",
                    pos  = "Apstaule: Port San d'Oria (!pos -6 -13 -157)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade the Parcel for the Pub to Thierride.",
                    pos  = "Thierride: Port San d'Oria (!pos -67 -5 -28)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Report back to Fontoumant.",
                    pos  = "Port San d'Oria (!pos -10 -10 -122)",
                },
            },
        },
        [15] = { -- LIZARD_SKINS
            name = "Lizard Skins",
            repeatable = true,
            steps = {
                {
                    text = "Agree to help Hanaa Punaa fill her order of lizard skins. She asks for a finished The Seamstress and San d'Oria fame level 2.",
                    pos  = "Southern San d'Oria (!pos -180 -9 28)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 2 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Round up three Lizard Skins.",
                    done = { item = 852, qty = 3 }, -- LIZARD_SKIN x3
                },
                {
                    text = "Trade the three skins to Hanaa Punaa; the Lizard Gloves are your thanks.",
                    pos  = "Southern San d'Oria (!pos -180 -9 28)",
                },
            },
        },
        [16] = { name = "Flyers for Regine" }, -- FLYERS_FOR_REGINE (name from enum; no script header found)
        [18] = { name = "Gates to Paradise" }, -- GATES_TO_PARADISE (name from enum; no script header found)
        [19] = { -- A_SQUIRES_TEST_II
            name = "A Squire's Test II",
            steps = {
                {
                    text = "Take Balasiel's second test. He asks for level 10 and a finished A Squire's Test first.",
                    pos  = "Southern San d'Oria (!pos -136 -11 64)",
                    done = { status = 1 },
                },
                {
                    text = "In Ordelle's Caves, touch the ??? at the pool and reach the second ??? within half a minute -- any slower and the Stalactite Dew runs through your fingers.",
                    pos  = "Ordelle's Caves (!pos -94 1 273, then !pos -139 0 264)",
                    done = { ki = 141 }, -- STALACTITE_DEW
                },
                {
                    text = "Carry the dew back to Balasiel.",
                    pos  = "Southern San d'Oria (!pos -136 -11 64)",
                },
            },
        },
        [20] = { name = "To Cure a Cough" }, -- TO_CURE_A_COUGH (name from enum; no script header found)
        [23] = { -- TIGERS_TEETH
            name = "Tigers Teeth",
            repeatable = true,
            steps = {
                {
                    text = "Take Taumila's order for fangs. She will not ask below San d'Oria fame level 3.",
                    pos  = "Southern San d'Oria (!pos -140 -6 -8)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Collect three Black Tiger Fangs from tigers.",
                    done = { item = 884, qty = 3 }, -- BLACK_TIGER_FANG x3
                },
                {
                    text = "Trade the three fangs to Taumila.",
                    pos  = "Southern San d'Oria (!pos -140 -6 -8)",
                },
            },
        },
        [26] = { name = "Undying Flames" }, -- UNDYING_FLAMES (name from enum; no script header found)
        [27] = { -- A_PURCHASE_OF_ARMS
            name = "A Purchase of Arms",
            steps = {
                {
                    text = "Take the Weapons Order from Helbort. He asks for a finished Father and Son and San d'Oria fame level 2.",
                    pos  = "Southern San d'Oria (!pos 71 -1 65)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 2 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Carry the order to Alexius, camped in Jugner Forest, and take the Weapons Receipt he writes out.",
                    pos  = "Jugner Forest (!pos 105 1 382)",
                    done = { ki = 98 }, -- WEAPONS_RECEIPT
                },
                {
                    text = "Bring the receipt back to Helbort.",
                    pos  = "Southern San d'Oria (!pos 71 -1 65)",
                },
            },
        },
        [29] = { -- A_KNIGHTS_TEST
            name = "A Knight's Test",
            steps = {
                {
                    text = "Take the knight's trial from Balasiel, and the Book of Tasks with it. He asks for a finished A Squire's Test II.",
                    pos  = "Southern San d'Oria (!pos -136 -11 64)",
                    done = { status = 1 },
                },
                {
                    text = "Get the Book of the East from Cahaurme and the Book of the West from Baunise, then search the disused well in Davoi with both in hand for the Knight's Soul.",
                    pos  = "Cahaurme !pos 55 -8 -29, Baunise !pos -55 -8 -32; well: Davoi !pos -221 2 -293",
                    done = { ki = 146 }, -- KNIGHTS_SOUL
                },
                {
                    text = "Carry the Knight's Soul back to Balasiel to be made a paladin.",
                    pos  = "Southern San d'Oria (!pos -136 -11 64)",
                },
            },
        },
        [30] = { -- THE_MEDICINE_WOMAN
            name = "The Medicine Woman",
            steps = {
                {
                    text = "Take the delivery from Abeaule. He asks for a finished The Trader in the Forest and San d'Oria fame level 3.",
                    pos  = "Northern San d'Oria (!pos -136 -2 56)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Ask Amaura for her formula, then bring her a Malboro Vine, a Chunk of Zinc Ore and an Insect Wing in one trade to have the Cold Medicine mixed.",
                    pos  = "Southern San d'Oria (!pos -85 -6 89)",
                    done = { ki = 147 }, -- COLD_MEDICINE
                },
                {
                    text = "Deliver the Cold Medicine to Abeaule.",
                    pos  = "Northern San d'Oria (!pos -136 -2 56)",
                },
            },
        },
        [31] = { -- BLACK_TIGER_SKINS
            name = "Black Tiger Skins",
            steps = {
                {
                    text = "Take Hanaa Punaa's next order. She asks for a finished Lizard Skins and San d'Oria fame level 3.",
                    pos  = "Southern San d'Oria (!pos -179 -8 27)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Gather three Tiger Hides.",
                    done = { item = 861, qty = 3 }, -- TIGER_HIDE x3
                },
                {
                    text = "Trade the three hides to Hanaa Punaa.",
                    pos  = "Southern San d'Oria (!pos -179 -8 27)",
                },
            },
        },
        [58] = { -- GROWING_FLOWERS
            name = "Growing Flowers",
            steps = {
                {
                    text = "Kuu Mohzolhi is after a flower. Trade her one -- any one -- or just speak to her, and she takes you on.",
                    pos  = "Northern San d'Oria (!pos -123 0 80)",
                    done = { status = 1 },
                },
                {
                    text = "Trade her the one flower she actually wants: a Marguerite.",
                    pos  = "Northern San d'Oria (!pos -123 0 80)",
                },
            },
        },
        [59] = { name = "Trial by Ice" }, -- TRIAL_BY_ICE (name from enum; no script header found)
        [60] = { -- THE_GENERALS_SECRET
            -- Named from the enum: the script header carries a copy-pasted
            -- "A Sentry's Peril" title that belongs to quest 0.
            name = "The General's Secret",
            steps = {
                {
                    text = "Hear Curilla out in the palace and take her empty bottle. She will not raise it below San d'Oria fame level 2.",
                    pos  = "Chateau d'Oraguille (!pos 27 0 0)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 2 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Fill the bottle at the hot spring in Horlais Peak.",
                    pos  = "Horlais Peak (!pos 444 -37 -18)",
                    done = { ki = 165 }, -- CURILLAS_BOTTLE_FULL
                },
                {
                    text = "Take the full bottle back to Curilla.",
                    pos  = "Chateau d'Oraguille (!pos 27 0 0)",
                },
            },
        },
        [61] = { -- THE_RUMOR
            name = "The Rumor",
            steps = {
                {
                    text = "Ask Novalmauge about the rumor. He wants level 10 and San d'Oria fame level 3 before he will say anything useful.",
                    pos  = "Bostaunieux Oubliette (!pos 70 -24 21)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Come by a Vial of Beastman Blood.",
                    done = { item = 930 }, -- VIAL_OF_BEASTMAN_BLOOD
                },
                {
                    text = "Trade the vial to Novalmauge.",
                    pos  = "Bostaunieux Oubliette (!pos 70 -24 21)",
                },
            },
        },
        [62] = { -- HER_MAJESTYS_GARDEN
            name = "Her Majesty's Garden",
            steps = {
                {
                    text = "Take the gardener's request from Chalvatot. He will not ask below San d'Oria fame level 4.",
                    pos  = "Chateau d'Oraguille (!pos -105 0 72)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 4 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Come by a Chunk of Derfland Humus.",
                    done = { item = 533 }, -- CHUNK_OF_DERFLAND_HUMUS
                },
                {
                    text = "Trade the humus to Chalvatot.",
                    pos  = "Chateau d'Oraguille (!pos -105 0 72)",
                },
            },
        },
        [63] = { -- INTRODUCTION_TO_TEAMWORK
            name = "Introduction to Teamwork",
            steps = {
                {
                    text = "Take the first lesson from Vilatroire, out on the road in West Ronfaure. He asks for level 10 and San d'Oria fame level 2.",
                    pos  = "West Ronfaure (!pos -260 -70 423)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 2 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Bring him a party: at least two of you, all within shouting distance of him, and at least two sharing your nation.",
                    pos  = "West Ronfaure (!pos -260 -70 423)",
                },
            },
        },
        [64] = { -- INTERMEDIATE_TEAMWORK
            name = "Intermediate Teamwork",
            steps = {
                {
                    text = "Take the second lesson from Vilatroire. He asks for a finished Introduction to Teamwork, level 10 and San d'Oria fame level 3.",
                    pos  = "West Ronfaure (!pos -260 -70 423)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Show him a party again: at least two of you, all within shouting distance, at least two sharing your nation.",
                    pos  = "West Ronfaure (!pos -260 -70 423)",
                },
            },
        },
        [65] = { -- ADVANCED_TEAMWORK
            name = "Advanced Teamwork",
            steps = {
                {
                    text = "Take the last lesson from Vilatroire. He asks for a finished Intermediate Teamwork, level 10 and San d'Oria fame level 4.",
                    pos  = "West Ronfaure (!pos -260 -70 423)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 4 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Show him a party one more time: at least two of you, all within shouting distance, at least two sharing your nation.",
                    pos  = "West Ronfaure (!pos -260 -70 423)",
                },
            },
        },
        [66] = { -- GRIMY_SIGNPOSTS
            name = "Grimy Signposts",
            steps = {
                {
                    text = "Take the cleaning job from Maugie. She will not ask below San d'Oria fame level 2.",
                    pos  = "Southern San d'Oria (!pos 105 2 -16)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 2 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Scrub down all four signposts scattered through Jugner Forest. Any order will do -- this step clears only when the last of the four is done.",
                    pos  = "Jugner Forest (!pos 301 0 419 / -457 2 -416 / -260 0 -23 / -73 2 100)",
                    done = { var = 'Prog', gte = 15 },
                },
                {
                    text = "Report back to Maugie.",
                    pos  = "Southern San d'Oria (!pos 105 2 -16)",
                },
            },
        },
        [67] = { -- A_JOB_FOR_THE_CONSORTIUM
            name = "A Job for the Consortium",
            steps = {
                {
                    text = "Take the run from Portaure. He needs the Tenshodo Members Card in your hands, San d'Oria fame level 5 and Norg fame level 1.",
                    pos  = "Port San d'Oria (!pos -22 -4 -106)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 0, level = 5 } }, -- fameArea.SANDORIA
                            { fame = { area = 5, level = 1 } }, -- fameArea.NORG
                        },
                    },
                },
                {
                    text = "Carry the Brugaire Goods to Yin Pocanakhu in Lower Jeuno -- customs inspects daylight arrivals at Port Jeuno -- then tell Portaure how the run went.",
                    pos  = "Yin Pocanakhu: Lower Jeuno (!pos 35 4 -46)",
                },
            },
        },
        [68] = { -- TROUBLE_AT_THE_SLUICE
            name = "Trouble at the Sluice",
            steps = {
                {
                    text = "Take the job from Belgidiveau. He asks for a finished The Rumor and San d'Oria fame level 3.",
                    pos  = "Northern San d'Oria (!pos -98 0 69)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Ask Novalmauge down in the Bostaunieux Oubliette what would settle the sluice.",
                    pos  = "Bostaunieux Oubliette (!pos 70 -24 21)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade Novalmauge a Dahlia; he mixes it into the Neutralizer.",
                    pos  = "Bostaunieux Oubliette (!pos 70 -24 21)",
                    done = { allOf = { { var = 'Prog', gte = 1 }, { ki = 166 } } }, -- NEUTRALIZER
                },
                {
                    text = "Take the Neutralizer back to Belgidiveau.",
                    pos  = "Northern San d'Oria (!pos -98 0 69)",
                },
            },
        },
        [69] = { -- THE_MERCHANTS_BIDDING
            name = "The Merchants Bidding",
            repeatable = true,
            steps = {
                {
                    text = "Take Parvipon's order for hides.",
                    pos  = "Southern San d'Oria (!pos -169 -1 13)",
                    done = { status = 1 },
                },
                {
                    text = "Gather three Rabbit Hides.",
                    done = { item = 856, qty = 3 }, -- RABBIT_HIDE x3
                },
                {
                    text = "Trade the three hides to Parvipon.",
                    pos  = "Southern San d'Oria (!pos -169 -1 13)",
                },
            },
        },
        [70] = { name = "Unexpected Treasure" }, -- UNEXPECTED_TREASURE (name from enum; no script header found)
        [71] = { -- BLACKMAIL
            name = "Blackmail",
            repeatable = true,
            steps = {
                {
                    text = "Hear Dauperiat's proposition. He needs San d'Oria fame level 3 and rank 3, and he will not say a word until you have zoned since first meeting him.",
                    pos  = "Northern San d'Oria (!pos -20 0 -26)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Deliver the Suspicious Envelope to Halver in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Go back to Dauperiat and hear his price.",
                    pos  = "Northern San d'Oria (!pos -20 0 -26)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade Dauperiat a Copy of the Castle Floor Plans.",
                    pos  = "Northern San d'Oria (!pos -20 0 -26)",
                },
            },
        },
        [72] = { -- THE_SETTING_SUN
            name = "The Setting Sun",
            steps = {
                {
                    text = "Hear Vamorcote out. He asks for a finished Blackmail and San d'Oria fame level 5.",
                    pos  = "Northern San d'Oria (!pos -137 10 161)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 5 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Come by the Engraved Key he is after.",
                    done = { item = 535 }, -- ENGRAVED_KEY
                },
                {
                    text = "Trade the Engraved Key to Vamorcote.",
                    pos  = "Northern San d'Oria (!pos -137 10 161)",
                },
            },
        },
        [74] = { -- DISTANT_LOYALTIES
            name = "Distant Loyalties",
            steps = {
                {
                    text = "Take the Goldsmithing Order from Femitte. She will not ask below San d'Oria fame level 4.",
                    pos  = "Southern San d'Oria (!pos -17 2 10)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 4 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Carry the order all the way to Michea in Bastok Markets.",
                    pos  = "Bastok Markets (!pos -299 -15 -156)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade Michea a Mythril Ingot so he can do the work.",
                    pos  = "Bastok Markets (!pos -299 -15 -156)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Leave the zone and come back, then collect the finished Mythril Hearts from Michea.",
                    pos  = "Bastok Markets (!pos -299 -15 -156)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Carry the Mythril Hearts back to Femitte.",
                    pos  = "Southern San d'Oria (!pos -17 2 10)",
                },
            },
        },
        [75] = { -- THE_RIVALRY
            name = "The Rivalry",
            steps = {
                {
                    text = "Back Gallijaux in the brothers' contest. You can only side with one of them, so The Competition must still be untouched.",
                    pos  = "Port San d'Oria (!pos -18 -2 -45)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Moat Carp and Forest Carp to Gallijaux until your lifetime tally reaches 10,000 fish. He pays per carp the whole way.",
                    pos  = "Port San d'Oria (!pos -18 -2 -45)",
                },
            },
        },
        [76] = { -- THE_COMPETITION
            name = "The Competition",
            steps = {
                {
                    text = "Back Joulet in the brothers' contest. You can only side with one of them, so The Rivalry must still be untouched.",
                    pos  = "Port San d'Oria (!pos -18 -2 -45)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Moat Carp and Forest Carp to Joulet until your lifetime tally reaches 10,000 fish. He pays per carp the whole way.",
                    pos  = "Port San d'Oria (!pos -18 -2 -45)",
                },
            },
        },
        [77] = { -- STARTING_A_FLAME
            name = "Starting a Flame",
            repeatable = true,
            steps = {
                {
                    text = "Take Legata's order for firestones.",
                    pos  = "Southern San d'Oria (!pos 82 0 116)",
                    done = { status = 1 },
                },
                {
                    text = "Gather four Flint Stones.",
                    done = { item = 768, qty = 4 }, -- FLINT_STONE x4
                },
                {
                    text = "Trade the four stones to Legata.",
                    pos  = "Southern San d'Oria (!pos 82 0 116)",
                },
            },
        },
        [78] = { -- FEAR_OF_THE_DARK
            name = "Fear of the Dark",
            repeatable = true,
            steps = {
                {
                    text = "Take Secodiand's order for bat wings.",
                    pos  = "Northern San d'Oria (!pos -160 0 137)",
                    done = { status = 1 },
                },
                {
                    text = "Gather two Bat Wings.",
                    done = { item = 922, qty = 2 }, -- BAT_WING x2
                },
                {
                    text = "Trade the two wings to Secodiand.",
                    pos  = "Northern San d'Oria (!pos -160 0 137)",
                },
            },
        },
        [79] = { -- WARDING_VAMPIRES
            name = "Warding Vampires",
            repeatable = true,
            steps = {
                {
                    text = "Take Maloquedil's order for garlic. He will not ask below San d'Oria fame level 3.",
                    pos  = "Northern San d'Oria (!pos 35 0 60)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Gather two Bulbs of Shaman Garlic.",
                    done = { item = 1018, qty = 2 }, -- BULB_OF_SHAMAN_GARLIC x2
                },
                {
                    text = "Trade the two bulbs to Maloquedil.",
                    pos  = "Northern San d'Oria (!pos 35 0 60)",
                },
            },
        },
        [80] = { -- SLEEPLESS_NIGHTS
            name = "Sleepless Nights",
            steps = {
                {
                    text = "Hear Paouala out. She will not ask below San d'Oria fame level 2.",
                    pos  = "Southern San d'Oria (!pos 158 -6 17)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 2 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Come by a Jug of Mary's Milk.",
                    done = { item = 4527 }, -- JUG_OF_MARYS_MILK
                },
                {
                    text = "Trade the jug to Paouala.",
                    pos  = "Southern San d'Oria (!pos 158 -6 17)",
                },
            },
        },
        [81] = { -- LUFETS_LAKE_SALT
            name = "Lufets Lake Salt",
            steps = {
                {
                    text = "Take Nogelle's order for salt.",
                    pos  = "Port San d'Oria (!pos -70 -5 -33)",
                    done = { status = 1 },
                },
                {
                    text = "Gather three Chunks of Lufet Salt.",
                    done = { item = 1019, qty = 3 }, -- CHUNK_OF_LUFET_SALT x3
                },
                {
                    text = "Trade the three chunks to Nogelle.",
                    pos  = "Port San d'Oria (!pos -70 -5 -33)",
                },
            },
        },
        [82] = { name = "Healing the Land" }, -- HEALING_THE_LAND (name from enum; no script header found)
        [83] = { name = "Sorcery of the North" }, -- SORCERY_OF_THE_NORTH (name from enum; no script header found)
        [84] = { -- THE_CRIMSON_TRIAL
            name = "The Crimson Trial",
            steps = {
                {
                    text = "Take the trial from Sharzalion. Red mage has to be your main job, at the artifact level or better.",
                    pos  = "Southern San d'Oria (!pos 95 0 111)",
                    done = { status = 1 },
                },
                {
                    text = "Purpleflash Brukdok stirs in Davoi the moment you set foot there. Put him down for the Davoi Storage Key and trade it to the orcish storage hole for the Orcish Dried Food.",
                    pos  = "Davoi",
                    done = { ki = 196 }, -- ORCISH_DRIED_FOOD
                },
                {
                    text = "Carry the dried food back to Sharzalion.",
                    pos  = "Southern San d'Oria (!pos 95 0 111)",
                },
            },
        },
        [85] = { -- ENVELOPED_IN_DARKNESS
            name = "Enveloped in Darkness",
            steps = {
                {
                    text = "Take the next trial from Curilla, and the Old Pocket Watch with it. Red mage main job at the artifact level, with The Crimson Trial behind you.",
                    pos  = "Chateau d'Oraguille (!pos 27 0 0)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Square of Velvet Cloth to Pagisalis; the watch goes and the Old Boots come back.",
                    pos  = "Northern San d'Oria (!pos 97 0 113)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Come by Crawler Blood, then bury it with the boots at the ??? in Crawler's Nest.",
                    pos  = "Crawler's Nest",
                    done = { allOf = { { var = 'Prog', gte = 2 }, { var = 'Time', gte = 1 } } },
                },
                {
                    text = "Give the burial half a minute to work, then examine the ??? again.",
                    pos  = "Crawler's Nest",
                },
            },
        },
        [86] = { name = "Peace for the Spirit" }, -- PEACE_FOR_THE_SPIRIT (name from enum; no script header found)
        [87] = { -- MESSENGER_FROM_BEYOND
            name = "Messenger From Beyond",
            steps = {
                {
                    text = "Take the trial from Narcheral. White mage has to be your main job, at the artifact level or better.",
                    pos  = "Northern San d'Oria (!pos 129 -11 126)",
                    done = { status = 1 },
                },
                {
                    text = "Draw Marchelute out of the ??? in Valkurm Dunes and take the Tavnazia Pass from it.",
                    pos  = "Valkurm Dunes (!pos -716 -10 66)",
                    done = { item = 1096 }, -- TAVNAZIA_PASS
                },
                {
                    text = "Trade the pass to Narcheral.",
                    pos  = "Northern San d'Oria (!pos 129 -11 126)",
                },
            },
        },
        [88] = { -- PRELUDE_OF_BLACK_AND_WHITE
            name = "Prelude of Black and White",
            steps = {
                {
                    text = "Take the next trial in Chateau d'Oraguille. White mage main job at the artifact level, with Messenger From Beyond behind you.",
                    pos  = "Chateau d'Oraguille (!pos -37 -3 31)",
                    done = { status = 1 },
                },
                {
                    text = "Come by a Canteen of Yagudo Holy Water and a pair of Moccasins.",
                    done = {
                        allOf = {
                            { item = 1097 }, -- CANTEEN_OF_YAGUDO_HOLY_WATER
                            { item = 12995 }, -- MOCCASINS
                        },
                    },
                },
                {
                    text = "Trade both to Narcheral in a single trade.",
                    pos  = "Northern San d'Oria (!pos 129 -11 126)",
                },
            },
        },
        [89] = { name = "Pieujes Decision" }, -- PIEUJES_DECISION (name from enum; no script header found)
        [90] = { -- SHARPENING_THE_SWORD
            name = "Sharpening the Sword",
            steps = {
                {
                    text = "Take the trial from Ailbeche. Paladin main job at the artifact level, and he only asks of a Family Counselor.",
                    pos  = "Northern San d'Oria (!pos 4 -1 24)",
                    done = { status = 1 },
                },
                {
                    text = "Examine the stalagmite in Ordelle's Caves to draw out Polevik; beat it and examine the stalagmite again for the Ordelle Whetstone.",
                    pos  = "Ordelle's Caves (!pos -51 0 3)",
                    done = { ki = 233 }, -- ORDELLE_WHETSTONE
                },
                {
                    text = "Take the whetstone back to Ailbeche.",
                    pos  = "Northern San d'Oria (!pos 4 -1 24)",
                },
            },
        },
        [91] = { name = "A Boys Dream" }, -- A_BOYS_DREAM (name from enum; no script header found)
        [92] = { name = "Under Oath" }, -- UNDER_OATH (name from enum; no script header found)
        [93] = { name = "The Holy Crest" }, -- THE_HOLY_CREST (name from enum; no script header found)
        [94] = { name = "A Craftsmans Work" }, -- A_CRAFTSMANS_WORK (name from enum; no script header found)
        [95] = { name = "Chasing Quotas" }, -- CHASING_QUOTAS (name from enum; no script header found)
        [96] = { name = "Knight Stalker" }, -- KNIGHT_STALKER (name from enum; no script header found)
        [97] = { name = "Eco Warrior" }, -- ECO_WARRIOR (name from enum; no script header found)
        [98] = { -- METHODS_CREATE_MADNESS
            name = "Methods Create Madness",
            steps = {
                {
                    text = "Take the weapon trial from Balasiel: polearm skill 240, a body that can wield the Spear of Trials, and no training guide already in hand.",
                    pos  = "Southern San d'Oria (!pos -136 -11 64)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Spear of Trials until Balasiel will take it back, then follow his map to Sea Serpent Grotto: the ??? there draws out the Water Leaper, and it gives up the Annals of Truth.",
                    pos  = "Sea Serpent Grotto (!pos 107 0 -125)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Balasiel to learn Impulse Drive.",
                    pos  = "Southern San d'Oria (!pos -136 -11 64)",
                },
            },
        },
        [99] = { -- SOULS_IN_SHADOW
            name = "Souls in Shadow",
            steps = {
                {
                    text = "Take the weapon trial from Novalmauge: scythe skill 240, a body that can wield the Scythe of Trials, and no training guide already in hand.",
                    pos  = "Bostaunieux Oubliette (!pos 70 -24 21)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Scythe of Trials until Novalmauge will take it back, then follow his map to the Den of Rancor: the ??? there draws out Mokumokuren, and it gives up the Annals of Truth.",
                    pos  = "Den of Rancor (!pos 118 36 -281)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Novalmauge to learn Spiral Hell.",
                    pos  = "Bostaunieux Oubliette (!pos 70 -24 21)",
                },
            },
        },
        [100] = { -- A_TASTE_FOR_MEAT
            -- The script accepts and completes this in the same event, so it
            -- never renders in the Active tab; the steps are here for the
            -- Completed entry and for the day that changes.
            name = "A Taste for Meat",
            steps = {
                {
                    text = "Ask Antreneau what has him grumbling about food.",
                    pos  = "Port San d'Oria (!pos -71 -5 -39)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Gather five Slices of Hare Meat.",
                    done = {
                        allOf = {
                            { var = 'Prog', gte = 1 },
                            { item = 4358, qty = 5 }, -- SLICE_OF_HARE_MEAT x5
                        },
                    },
                },
                {
                    text = "Trade all five slices to Thierride in one go, then see Antreneau for your share of the cooking.",
                    pos  = "Thierride: Port San d'Oria (!pos -67 -5 -28)",
                },
            },
        },
        [101] = { -- EXIT_THE_GAMBLER
            -- Like A Taste for Meat, this one completes without ever being
            -- accepted, so the Active tab never shows it.
            name = "Exit the Gambler",
            steps = {
                {
                    text = "Hear out Aurege and Guilberdrier on the walkway in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos -156 11 253)",
                    done = { var = 'Stage', gte = 1 },
                },
                {
                    text = "Find Varchet in Southern San d'Oria and see for yourself how the gambling goes.",
                    pos  = "Southern San d'Oria (!pos 116 -1 91)",
                    done = { allOf = { { var = 'Stage', gte = 1 }, { var = 'Prog', gte = 1 } } },
                },
                {
                    text = "Go back and tell Aurege or Guilberdrier what you saw.",
                    pos  = "Northern San d'Oria (!pos -156 11 253)",
                },
            },
        },
        [102] = { -- OLD_WOUNDS
            name = "Old Wounds",
            steps = {
                {
                    text = "Take the weapon trial from Curilla: sword skill 240, a body that can wield the Sapara of Trials, and no training guide already in hand.",
                    pos  = "Chateau d'Oraguille (!pos 27 0 0)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Sapara of Trials until Curilla will take it back, then follow her map to the Quicksand Caves: the ??? there draws out Girtablulu, and it gives up the Annals of Truth.",
                    pos  = "Quicksand Caves (!pos -145 2 446)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Curilla to learn Savage Blade.",
                    pos  = "Chateau d'Oraguille (!pos 27 0 0)",
                },
            },
        },
        [103] = { name = "Escort for Hire" }, -- ESCORT_FOR_HIRE (name from enum; no script header found)
        [104] = { name = "A Discerning Eye" }, -- A_DISCERNING_EYE (name from enum; no script header found)
        [105] = { -- A_TIMELY_VISIT
            name = "A Timely Visit",
            steps = {
                {
                    text = "Hear Deraquien out. He will not ask below San d'Oria fame level 4.",
                    pos  = "Southern San d'Oria (!pos -98 -2 32)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 4 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Put the question to Narvecaint, out on La Theine Plateau.",
                    pos  = "La Theine Plateau (!pos -261 23 127)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take what she said back to Deraquien.",
                    pos  = "Southern San d'Oria (!pos -98 -2 32)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Ask Halver about it in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Carry Halver's answer back to Deraquien.",
                    pos  = "Southern San d'Oria (!pos -98 -2 32)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Speak with Phillone in Southern San d'Oria.",
                    pos  = "Southern San d'Oria (!pos -208 -2 67)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Tell Deraquien what Phillone said; he sends you out to Jugner Forest.",
                    pos  = "Southern San d'Oria (!pos -98 -2 32)",
                    done = { allOf = { { var = 'Prog', gte = 5 }, { var = 'Stage', gte = 1 } } },
                },
                {
                    text = "Examine the ??? in Jugner Forest after dark -- daylight tells you nothing. Giollemitte b Feroun and a skeleton rise together; put either one down and examine the spot again.",
                    pos  = "Jugner Forest (!pos -310 0 407)",
                    -- Stage rides along from here down: Prog alone cannot prove
                    -- the Stage step below it, and the two only ever rise.
                    done = { allOf = { { var = 'Prog', gte = 6 }, { var = 'Stage', gte = 1 } } },
                },
                {
                    text = "Report to Phillone.",
                    pos  = "Southern San d'Oria (!pos -208 -2 67)",
                    done = { allOf = { { var = 'Prog', gte = 7 }, { var = 'Stage', gte = 1 } } },
                },
                {
                    text = "Tell Narvecaint on La Theine Plateau how it ended.",
                    pos  = "La Theine Plateau (!pos -261 23 127)",
                    done = { allOf = { { var = 'Prog', gte = 8 }, { var = 'Stage', gte = 1 } } },
                },
                {
                    text = "Go back to Phillone one last time.",
                    pos  = "Southern San d'Oria (!pos -208 -2 67)",
                },
            },
        },
        [106] = { name = "Fit for a Prince" }, -- FIT_FOR_A_PRINCE (name from enum; no script header found)
        [107] = { name = "Trial Size Trial by Ice" }, -- TRIAL_SIZE_TRIAL_BY_ICE (name from enum; no script header found)
        [108] = { -- SIGNED_IN_BLOOD
            name = "Signed in Blood",
            steps = {
                {
                    text = "Hear Sobane out. She will not talk below San d'Oria fame level 3.",
                    pos  = "Southern San d'Oria (!pos -190 -3 97)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 3 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Bring Sobane a Cathedral Tapestry.",
                    pos  = "Southern San d'Oria (!pos -190 -3 97)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take ship to Selbina and hear Abelard's story about the diary he found.",
                    pos  = "Selbina (!pos -52 -11 -13)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Find an Ordelle Chest Key in Ordelle's Caves, open a treasure chest with it for the Torn-out Pages, and take them to Abelard.",
                    pos  = "Ordelle's Caves, then Selbina (!pos -52 -11 -13)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Carry what Abelard read back to Sobane.",
                    pos  = "Southern San d'Oria (!pos -190 -3 97)",
                },
            },
        },
        [109] = { -- TEA_WITH_A_TONBERRY
            name = "Tea with a Tonberry?",
            steps = {
                {
                    text = "Hear Sobane out again. She asks for a finished Signed in Blood, San d'Oria fame level 4, and that you have zoned since that quest ended.",
                    pos  = "Southern San d'Oria (!pos -190 -3 97)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 4 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Find Anguenet on the docks at Carpenters' Landing and hear what the tonberries will want.",
                    pos  = "Carpenters' Landing (!pos 214 -3 -527)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade Anguenet a Piece of Attohwa Ginseng; he parts with the Tonberry Blackboard.",
                    pos  = "Carpenters' Landing (!pos 214 -3 -527)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Ride the barge through Phanauet Channel and put every question on the blackboard to Riche before the trip ends -- about seven minutes.",
                    pos  = "Phanauet Channel (!pos 5 -3 13)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Trade an Ingot of Royal Treasury Gold to the ??? in Davoi and put down the Hematic Cyst it wakes.",
                    pos  = "Davoi (!pos 189 1 -383)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Examine the ??? in Davoi again.",
                    pos  = "Davoi (!pos 189 1 -383)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Take it all back to Sobane.",
                    pos  = "Southern San d'Oria (!pos -190 -3 97)",
                },
            },
        },
        [110] = { -- SPICE_GALS
            name = "Spice Gals",
            gated = 'ENABLE_COP',
            repeatable = true,
            steps = {
                {
                    text = "Take the errand from Rouva. She only asks of someone who has seen Ancient Vows through, and only once per conquest tally.",
                    pos  = "Southern San d'Oria (!pos -16 2 11)",
                    done = { status = 1 },
                },
                {
                    text = "Pull a Rivernewort from the ??? at Riverne Site #A01 or Site #B01.",
                    pos  = "Riverne A01 (!pos -514 -6 -407) / B01 (!pos -517 0 689)",
                    done = { ki = 621 }, -- RIVERNEWORT
                },
                {
                    text = "Take the Rivernewort back to Rouva.",
                    pos  = "Southern San d'Oria (!pos -16 2 11)",
                },
            },
        },
        [112] = { name = "Over the Hills and Far Away" }, -- OVER_THE_HILLS_AND_FAR_AWAY (name from enum; no script header found)
        [113] = { -- LURE_OF_THE_WILDCAT
            name = "Lure of the Wildcat (San d'Oria)",
            gated = 'ENABLE_TOAU',
            steps = {
                {
                    text = "Take the Red Sentinel Badge from Amutiyaal.",
                    pos  = "Southern San d'Oria (!pos 116 0 84)",
                    done = { status = 1 },
                },
                {
                    text = "Show the badge to all twenty on his list: five each in Southern, Northern and Port San d'Oria, and five inside Chateau d'Oraguille.",
                    done = { var = 'Prog', gte = 1048575 },
                },
                {
                    text = "Report back to Amutiyaal.",
                    pos  = "Southern San d'Oria (!pos 116 0 84)",
                },
            },
        },
        [114] = { -- ATELLOUNES_LAMENT
            name = "Atelloune's Lament",
            gated = 'ENABLE_WOTG',
            steps = {
                {
                    text = "Hear Atelloune out. She asks for San d'Oria fame level 2 and a finished Seeing Spots.",
                    pos  = "Southern San d'Oria (!pos 122 0 82)",
                    done = { allOf = { { status = 1 }, { fame = { area = 0, level = 2 } } } }, -- fameArea.SANDORIA
                },
                {
                    text = "Trade Atelloune a Ladybug Wing.",
                    pos  = "Southern San d'Oria (!pos 122 0 82)",
                },
            },
        },
        [117] = { name = "Thick Shells" }, -- THICK_SHELLS (name from enum; no script header found)
        [118] = { name = "Forest for the Trees" }, -- FOREST_FOR_THE_TREES (name from enum; no script header found)
        [119] = { name = "Trust Sandoria" }, -- TRUST_SANDORIA (name from enum; no script header found)
    },
}
