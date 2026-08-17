-- dwtracker data -- Jeuno quests. Names generated Phase 0
-- (tools/dwtracker_names.py); steps hand-authored in Phase 4 from
-- scripts/quests/jeuno/ as ground truth. Jeuno's folder mixes eras, so
-- entries whose progression needs a zone or a mission behind an expansion
-- gate carry `gated` and stay invisible until that flag opens; they are
-- authored and lint-proven all the same. Entries that stay name-only are
-- ids the enum lists but no script implements here. Step text describes
-- the state machine the script encodes and nothing else -- where an item
-- comes from a drop table, a shop or a craft rather than from the quest
-- itself, the step names the item and stops there. Pure data: numeric ids
-- and display strings only, no xi.*, no functions (DWTRACKER_FORMAT.md
-- decisions T2/§3-4). Loaded byte-identically by the server module and the
-- dwtracker addon; both hash these bytes, so an edit that reaches only one
-- side makes the addon refuse step rendering for this area until the
-- copies agree again. tools/dwtracker_lint.py must pass before edits ship.
return {
    kind = 'quests',
    log = 3,
    area = 'jeuno_quests',
    label = "Jeuno",
    entries = {
        [0] = { -- CREST_OF_DAVOI
            name = "Crest of Davoi",
            steps = {
                {
                    text = "Show Baudin in Upper Jeuno the Silver Bell you are carrying; the crest on it interests him.",
                    pos  = "Upper Jeuno (!pos -75 0 80)",
                    done = { status = 1 },
                },
                {
                    text = "Get hold of a Slice of Coeurl Meat.",
                    done = { item = 4377 }, -- SLICE_OF_COEURL_MEAT
                },
                {
                    text = "Trade the meat to Baudin.",
                    pos  = "Upper Jeuno (!pos -75 0 80)",
                },
            },
        },
        -- Never renders in the Active tab: the script has no quest:begin at
        -- all, so the journal only learns about this one when it completes.
        -- The steps are here for the Completed entry and for the day that
        -- changes -- which is also why step 1 carries no status atom.
        [1] = { -- SAVE_MY_SISTER
            name = "Save My Sister",
            steps = {
                {
                    text = "Hear Baudin out about his sister, then ask Mailloquetat in Upper Jeuno what he knows.",
                    pos  = "Upper Jeuno (Baudin !pos -75 0 80, Mailloquetat !pos -31 -1 8)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take what Mailloquetat told you back to Baudin.",
                    pos  = "Upper Jeuno (!pos -75 0 80)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Ask Neraf-Najiruf in Ru'Lude Gardens for the Ducal Guard's Lantern.",
                    pos  = "Ru'Lude Gardens (!pos -36 2 60)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Light the four braziers in the Eldieme Necropolis in the right order. A wrong one puts the lantern out and the round starts over.",
                    pos  = "The Eldieme Necropolis",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Go back to Baudin.",
                    pos  = "Upper Jeuno (!pos -75 0 80)",
                },
            },
        },
        [2] = { -- A_CLOCK_MOST_DELICATE
            name = "A Clock Most Delicate",
            steps = {
                {
                    text = "Hear Collet out about the clock, then look the clock tower door over yourself.",
                    pos  = "Upper Jeuno (Collet !pos -44 0 107, tower !pos -80 0 104)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 3, level = 2 } }, -- JEUNO
                        },
                    },
                },
                {
                    text = "Get hold of Clock Tower Oil. Deal with Tenshodo pays out in exactly that.",
                    done = { ki = 19 }, -- CLOCK_TOWER_OIL
                },
                {
                    text = "Take the oil to the clock tower door in Upper Jeuno.",
                    pos  = "Upper Jeuno (!pos -80 0 104)",
                },
            },
        },
        [3] = { -- SAVE_THE_CLOCK_TOWER
            name = "Save the Clock Tower",
            steps = {
                {
                    text = "Take the Clock Tower Petition from Derrick in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos -32 -1 -7)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 3, level = 5 } }, -- JEUNO
                        },
                    },
                },
                {
                    text = "Collect all ten signatures: Pitantimand in Port Jeuno, Teigero-Bangero and Zauko in Lower Jeuno, six around Upper Jeuno, and Radeivepart in Ru'Lude Gardens.",
                    done = { var = 'Prog', gte = 1023 },
                },
                {
                    text = "Trade the signed petition back to Derrick.",
                    pos  = "Lower Jeuno (!pos -32 -1 -7)",
                },
            },
        },
        [4] = { -- CHOCOBOS_WOUNDS
            name = "Chocobo's Wounds",
            steps = {
                {
                    text = "Take the job from Brutus at the Chocobo Stables in Upper Jeuno. Level 20 or better.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                    done = { status = 1 },
                },
                {
                    text = "Feed the hurt chocobo Clumps of Gausebit Wildgrass, one at a time with a pause between each, until it starts to come round. Osker will say how it is going.",
                    pos  = "Upper Jeuno (!pos -61 8 93)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Report at the Merchant's House door in Lower Jeuno -- or keep feeding until the bird itself sees you off.",
                    pos  = "Lower Jeuno (!pos -88 -7 -168)",
                },
            },
        },
        [5] = { -- SAVE_MY_SON
            name = "Save My Son",
            steps = {
                {
                    text = "Take the errand at the Merchant's House door in Lower Jeuno. Chocobo's Wounds behind you, and the levels for an advanced job.",
                    pos  = "Lower Jeuno (!pos -82 -7 -168)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Shalott in Upper Jeuno where the nightflowers grow, then find them on Qufim Island.",
                    pos  = "Qufim Island (!pos -264 -3 28)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Bring word back to the Merchant's House door.",
                    pos  = "Lower Jeuno (!pos -82 -7 -168)",
                },
            },
        },
        -- The script header calls this Candle Making, which is quest 22's
        -- name; the enum's is the one that matches the id it declares.
        [6] = { -- A_CANDLELIGHT_VIGIL
            name = "A Candlelight Vigil",
            steps = {
                {
                    text = "Hear Ilumida out in Upper Jeuno.",
                    pos  = "Upper Jeuno (!pos -75 -1 58)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 3, level = 4 } }, -- JEUNO
                        },
                    },
                },
                {
                    text = "Get hold of a Holy Candle. Candle Making, over with Rouliette, is the quest that produces one.",
                    done = { ki = 50 }, -- HOLY_CANDLE
                },
                {
                    text = "Bring the Holy Candle to Ilumida.",
                    pos  = "Upper Jeuno (!pos -75 -1 58)",
                },
            },
        },
        [7] = { name = "The Wonder Magic Set" }, -- THE_WONDER_MAGIC_SET (name from enum; no script header found)
        [8] = { name = "The Kind Cardian" }, -- THE_KIND_CARDIAN (name from enum; no script header found)
        [9] = { -- YOUR_CRYSTAL_BALL
            name = "Your Crystal Ball",
            steps = {
                {
                    text = "Take the commission from Kurou-Morou in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos -4 -6 -28)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 3, level = 2 } }, -- JEUNO
                        },
                    },
                },
                {
                    text = "Trade an Ahriman Lens to Rockwell in the Maze of Shakhrami and leave him a minute to work.",
                    pos  = "Maze of Shakhrami (!pos -18 -13 181)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Go back to Rockwell for the finished Divination Sphere.",
                    pos  = "Maze of Shakhrami (!pos -18 -13 181)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade the Divination Sphere to Kurou-Morou.",
                    pos  = "Lower Jeuno (!pos -4 -6 -28)",
                },
            },
        },
        [10] = { name = "Collect Tarut Cards" }, -- COLLECT_TARUT_CARDS (name from enum; no script header found)
        -- No quest:begin anywhere in the script: never renders in Active.
        [11] = { -- THE_OLD_MONUMENT
            name = "The Old Monument",
            steps = {
                {
                    text = "Ask Mertaire in Lower Jeuno about the monument. Advanced-job levels or better.",
                    pos  = "Lower Jeuno (!pos -17 0 -61)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Find the Song Runes on the Buburimu Peninsula and read what is cut into them.",
                    pos  = "Buburimu Peninsula (!pos -244 16 -280)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade a Sheet of Parchment to the Song Runes to take a rubbing.",
                    pos  = "Buburimu Peninsula (!pos -244 16 -280)",
                },
            },
        },
        -- No quest:begin anywhere in the script: never renders in Active.
        [12] = { -- A_MINSTREL_IN_DESPAIR
            name = "A Minstrel in Despair",
            steps = {
                {
                    text = "Trade a Sheet of Parchment to the Song Runes on the Buburimu Peninsula; you come away with Poetic Parchment.",
                    pos  = "Buburimu Peninsula (!pos -244 16 -280)",
                    done = { item = 634 }, -- POETIC_PARCHMENT
                },
                {
                    text = "Trade the Poetic Parchment to Mertaire in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos -17 0 -61)",
                },
            },
        },
        [13] = { name = "Rubbish Day" }, -- RUBBISH_DAY (name from enum; no script header found)
        [14] = { name = "Never to Return" }, -- NEVER_TO_RETURN (name from enum; no script header found)
        [15] = { -- COMMUNITY_SERVICE
            name = "Community Service",
            repeatable = true,
            steps = {
                {
                    text = "Sign on with Zauko in Lower Jeuno for the evening lamp round. He takes people on once a Vana'diel day.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Light all twelve street lamps around Lower Jeuno before the round times out.",
                    pos  = "Lower Jeuno",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Report back to Zauko. Finish it once and he issues the Lamp Lighter's Membership Card.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [16] = { name = "Cooks Pride" }, -- COOKS_PRIDE (name from enum; no script header found)
        -- The script's own note: this never shows in the log until it is
        -- completed, and a player can skip it entirely by handing the invite
        -- straight over. No quest:begin, so no accept step.
        [17] = { -- TENSHODO_MEMBERSHIP
            name = "Tenshodo Membership",
            steps = {
                {
                    text = "Trade a Tenshodo Invite to Ghebi Damomohe in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos 16 0 -5)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Get the application countersigned in Port Bastok -- Jabbar or the Silver Owl will do it.",
                    pos  = "Port Bastok (!pos -101 -2 23)",
                    done = {
                        allOf = {
                            { var = 'Prog', gte = 1 },
                            { ki = 121 }, -- TENSHODO_APPLICATION_FORM
                        },
                    },
                },
                {
                    text = "Take the signed form back to Ghebi Damomohe.",
                    pos  = "Lower Jeuno (!pos 16 0 -5)",
                },
            },
        },
        [18] = { name = "The Lost Cardian" }, -- THE_LOST_CARDIAN (name from enum; no script header found)
        -- Accepted and completed in a single trigger: never renders Active.
        [19] = { -- PATH_OF_THE_BEASTMASTER
            name = "Path of the Beastmaster",
            steps = {
                {
                    text = "Go back to Brutus at the Chocobo Stables once Save My Son is behind you; he unlocks Beastmaster on the spot. Advanced-job levels or better.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                },
            },
        },
        -- Accepted and completed in a single cutscene: never renders Active.
        [20] = { -- PATH_OF_THE_BARD
            name = "Path of the Bard",
            steps = {
                {
                    text = "With A Minstrel in Despair finished, go to the Song Runes in the Valkurm Dunes; the cutscene there unlocks Bard. The Jeuno dialogue leading up to it is all optional.",
                    pos  = "Valkurm Dunes (!pos -721 -7 102)",
                },
            },
        },
        -- Completed in a single trigger: never renders Active.
        [21] = { -- THE_CLOCKMASTER
            name = "The Clockmaster",
            steps = {
                {
                    text = "With Save the Clock Tower finished, look in on the clock tower door in Upper Jeuno again.",
                    pos  = "Upper Jeuno (!pos -80 0 104)",
                },
            },
        },
        [22] = { -- CANDLE_MAKING
            name = "Candle Making",
            steps = {
                {
                    text = "Ask Rouliette in Upper Jeuno about candles. She only takes the job while A Candlelight Vigil is open.",
                    pos  = "Upper Jeuno (!pos -24 -2 11)",
                    done = { status = 1 },
                },
                {
                    text = "Get hold of a Lanolin Cube.",
                    done = { item = 531 }, -- LANOLIN_CUBE
                },
                {
                    text = "Trade the Lanolin Cube to Rouliette and she makes the Holy Candle.",
                    pos  = "Upper Jeuno (!pos -24 -2 11)",
                },
            },
        },
        [23] = { -- CHILDS_PLAY
            name = "Child's Play",
            steps = {
                {
                    text = "Hear Karl out in Port Jeuno. He only asks while The Wonder Magic Set is open.",
                    pos  = "Port Jeuno (!pos -60 0 -8)",
                    done = { status = 1 },
                },
                {
                    text = "Get hold of a White Rock.",
                    done = { item = 776 }, -- WHITE_ROCK
                },
                {
                    text = "Trade the White Rock to Karl.",
                    pos  = "Port Jeuno (!pos -60 0 -8)",
                },
            },
        },
        [24] = { -- NORTHWARD
            name = "Northward",
            steps = {
                {
                    text = "Hear Radeivepart out in Ru'Lude Gardens.",
                    pos  = "Ru'Lude Gardens (!pos 5 9 -39)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 3, level = 4 } }, -- JEUNO
                        },
                    },
                },
                {
                    text = "Get hold of a Flame Degen.",
                    done = { item = 16522 }, -- FLAME_DEGEN
                },
                {
                    text = "Trade the Flame Degen to Radeivepart.",
                    pos  = "Ru'Lude Gardens (!pos 5 9 -39)",
                },
            },
        },
        [25] = { -- THE_ANTIQUE_COLLECTOR
            name = "The Antique Collector",
            steps = {
                {
                    text = "Hear Imasuke out in Port Jeuno.",
                    pos  = "Port Jeuno (!pos -165 11 94)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 3, level = 2 } }, -- JEUNO
                        },
                    },
                },
                {
                    text = "Get hold of a Kaiser Sword.",
                    done = { item = 16631 }, -- KAISER_SWORD
                },
                {
                    text = "Trade the Kaiser Sword to Imasuke.",
                    pos  = "Port Jeuno (!pos -165 11 94)",
                },
            },
        },
        [26] = { -- DEAL_WITH_TENSHODO
            name = "Deal with Tenshodo",
            steps = {
                {
                    text = "Take the job from Garnev in Lower Jeuno. The fame he cares about is Norg's, not Jeuno's.",
                    pos  = "Lower Jeuno (!pos 30 4 -36)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 5, level = 2 } }, -- NORG
                        },
                    },
                },
                {
                    text = "Get hold of a Gold Orcmask.",
                    done = { item = 554 }, -- GOLD_ORCMASK
                },
                {
                    text = "Trade the Gold Orcmask to Garnev; he pays in Clock Tower Oil.",
                    pos  = "Lower Jeuno (!pos 30 4 -36)",
                },
            },
        },
        -- The ten bag quests share one state machine in
        -- scripts/quests/jeuno/helpers.lua: Bluffnix checks Jeuno fame, an
        -- exact current inventory size and the previous part, then takes
        -- the four materials (or a Bowl of Goblin Stew) in a single trade.
        -- The fame check sits in a closure outside every section, so there
        -- is no accept-gate axiom to prove a fame atom against (FORMAT
        -- 6.10) -- the requirement rides the step text instead. Phase 0's
        -- names came from the copy-pasted script headers; these come from
        -- the enum.
        [27] = { -- THE_GOBBIEBAG_PART_I
            name = "The Gobbiebag Part I",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 1, an inventory of exactly 30 slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Square of Dhalmel Leather, a Steel Ingot, a Square of Linen Cloth and a Peridot in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        [28] = { -- THE_GOBBIEBAG_PART_II
            name = "The Gobbiebag Part II",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 1, an inventory of exactly 35 slots and Part I finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Square of Ram Leather, a Mythril Ingot, a Square of Wool Cloth and a Turquoise in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        [29] = { -- THE_GOBBIEBAG_PART_III
            name = "The Gobbiebag Part III",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 1, an inventory of exactly 40 slots and Part II finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Square of Black Tiger Leather, a Gold Ingot, a Square of Velvet Cloth and a Painite in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        [30] = { -- THE_GOBBIEBAG_PART_IV
            name = "The Gobbiebag Part IV",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 1, an inventory of exactly 45 slots and Part III finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Cermet Chunk, a Darksteel Ingot, a Square of Silk Cloth and a Goshenite in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        [31] = { -- MYSTERIES_OF_BEADEAUX_I
            name = "Mysteries of Beadeaux I",
            steps = {
                {
                    text = "Show Sattal-Mansal in Lower Jeuno the Silver Bell you are carrying.",
                    pos  = "Lower Jeuno (!pos 40 3 -53)",
                    done = { status = 1 },
                },
                {
                    text = "Get hold of a Quadav Charm.",
                    done = { item = 495 }, -- QUADAV_CHARM
                },
                {
                    text = "Trade the charm to Sattal-Mansal.",
                    pos  = "Lower Jeuno (!pos 40 3 -53)",
                },
            },
        },
        -- Part I hands this one straight over (player:addQuest at
        -- Mysteries_of_Beadeaux_I.lua:39), which is why the script has no
        -- accept section of its own.
        [32] = { -- MYSTERIES_OF_BEADEAUX_II
            name = "Mysteries of Beadeaux II",
            steps = {
                {
                    text = "Sattal-Mansal opens this one himself the moment Mysteries of Beadeaux I is done.",
                    pos  = "Lower Jeuno (!pos 40 3 -53)",
                    done = { status = 1 },
                },
                {
                    text = "Get hold of a Quadav Augury Shell.",
                    done = { item = 494 }, -- QUADAV_AUGURY_SHELL
                },
                {
                    text = "Trade the shell to Sattal-Mansal.",
                    pos  = "Lower Jeuno (!pos 40 3 -53)",
                },
            },
        },
        [33] = { name = "Mystery of Fire" }, -- MYSTERY_OF_FIRE (name from enum; no script header found)
        [34] = { name = "Mystery of Water" }, -- MYSTERY_OF_WATER (name from enum; no script header found)
        [35] = { name = "Mystery of Earth" }, -- MYSTERY_OF_EARTH (name from enum; no script header found)
        [36] = { name = "Mystery of Wind" }, -- MYSTERY_OF_WIND (name from enum; no script header found)
        [37] = { name = "Mystery of Ice" }, -- MYSTERY_OF_ICE (name from enum; no script header found)
        [38] = { name = "Mystery of Lightning" }, -- MYSTERY_OF_LIGHTNING (name from enum; no script header found)
        [39] = { name = "Mystery of Light" }, -- MYSTERY_OF_LIGHT (name from enum; no script header found)
        [40] = { name = "Mystery of Darkness" }, -- MYSTERY_OF_DARKNESS (name from enum; no script header found)
        [41] = { name = "Fistful of Fury" }, -- FISTFUL_OF_FURY (name from enum; no script header found)
        [42] = { -- THE_GOBLIN_TAILOR
            name = "The Goblin Tailor",
            steps = {
                {
                    text = "Take the offer from Guttrix in Lower Jeuno. Level 10 or better.",
                    pos  = "Lower Jeuno (!pos -36 4 -139)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 3, level = 3 } }, -- JEUNO
                        },
                    },
                },
                {
                    text = "Open a Treasure Coffer in Gusgen Mines, the Maze of Shakhrami or Ordelle's Caves for the Magical Pattern.",
                    done = { ki = 178 }, -- MAGICAL_PATTERN
                },
                {
                    text = "Take the pattern to Guttrix and pick which piece of your race's gear he runs up.",
                    pos  = "Lower Jeuno (!pos -36 4 -139)",
                },
            },
        },
        [43] = { -- PRETTY_LITTLE_THINGS
            name = "Pretty Little Things",
            repeatable = true,
            steps = {
                {
                    text = "Trade Zona Shodhun in Port Jeuno any of the pretty things she collects -- a coloured rock or a flower -- and she starts asking for more.",
                    pos  = "Port Jeuno (!pos -175 -5 -4)",
                    done = { status = 1 },
                },
                {
                    text = "Bring her a Yellow Rock. That is the one that closes it, and she will take another any time.",
                    pos  = "Port Jeuno (!pos -175 -5 -4)",
                },
            },
        },
        -- The fifteen artifact-glove quests share one state machine in
        -- scripts/quests/jeuno/helpers.lua and differ only in job, the
        -- artifact quest that must already be under way, which dungeon's
        -- coffer holds the Old Gauntlets, and the gloves at the end. The
        -- gauntlets ride an anyOf with the progress var that survives the
        -- turn-in, per FORMAT 6.4. On a second and later run Guslam skips
        -- the two intermediaries and sets Prog straight to 3, which is why
        -- step 3 tests for 3 rather than 1.
        [44] = { -- BORGHERTZS_WARRING_HANDS
            name = "Borghertz's Warring Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Warrior as main job, level 50 or better, The Talekeeper's Truth already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in The Eldieme Necropolis for the Old Gauntlets.",
                    pos  = "The Eldieme Necropolis",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Fighter's Mufflers.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [45] = { -- BORGHERTZS_STRIKING_HANDS
            name = "Borghertz's Striking Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Monk as main job, level 50 or better, The First Meeting already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Crawlers' Nest for the Old Gauntlets.",
                    pos  = "Crawlers' Nest",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Temple Gloves.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [46] = { -- BORGHERTZS_HEALING_HANDS
            name = "Borghertz's Healing Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. White Mage as main job, level 50 or better, Prelude of Black and White already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Beadeaux for the Old Gauntlets.",
                    pos  = "Beadeaux",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Healer's Mitts.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [47] = { -- BORGHERTZS_SORCEROUS_HANDS
            name = "Borghertz's Sorcerous Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Black Mage as main job, level 50 or better, Recollections already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Garlaige Citadel for the Old Gauntlets.",
                    pos  = "Garlaige Citadel",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Wizard's Gloves.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [48] = { -- BORGHERTZS_VERMILLION_HANDS
            name = "Borghertz's Vermillion Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Red Mage as main job, level 50 or better, Enveloped in Darkness already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in The Eldieme Necropolis for the Old Gauntlets.",
                    pos  = "The Eldieme Necropolis",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Warlock's Gloves.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [49] = { -- BORGHERTZS_SNEAKY_HANDS
            name = "Borghertz's Sneaky Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Thief as main job, level 50 or better, As Thick as Thieves already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Monastic Cavern for the Old Gauntlets.",
                    pos  = "Monastic Cavern",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Rogue's Armlets.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [50] = { -- BORGHERTZS_STALWART_HANDS
            name = "Borghertz's Stalwart Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Paladin as main job, level 50 or better, A Boy's Dream already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in The Eldieme Necropolis for the Old Gauntlets.",
                    pos  = "The Eldieme Necropolis",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Gallant Gauntlets.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [51] = { -- BORGHERTZS_SHADOWY_HANDS
            name = "Borghertz's Shadowy Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Dark Knight as main job, level 50 or better, Dark Puppet already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in The Eldieme Necropolis for the Old Gauntlets.",
                    pos  = "The Eldieme Necropolis",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Chaos Gauntlets.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [52] = { -- BORGHERTZS_WILD_HANDS
            name = "Borghertz's Wild Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Beastmaster as main job, level 50 or better, Scattered into the Shadow already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Crawlers' Nest for the Old Gauntlets.",
                    pos  = "Crawlers' Nest",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Beast Gloves.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [53] = { -- BORGHERTZS_HARMONIOUS_HANDS
            name = "Borghertz's Harmonious Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Bard as main job, level 50 or better, The Requiem already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Castle Zvahl Baileys for the Old Gauntlets.",
                    pos  = "Castle Zvahl Baileys",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Choral Cuffs.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [54] = { -- BORGHERTZS_CHASING_HANDS
            name = "Borghertz's Chasing Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Ranger as main job, level 50 or better, Fire and Brimstone already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Garlaige Citadel for the Old Gauntlets.",
                    pos  = "Garlaige Citadel",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Hunter's Bracers.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [55] = { -- BORGHERTZS_LOYAL_HANDS
            name = "Borghertz's Loyal Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Samurai as main job, level 50 or better, Yomi Okuri already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Kuftal Tunnel for the Old Gauntlets.",
                    pos  = "Kuftal Tunnel",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Myochin Kote.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [56] = { -- BORGHERTZS_LURKING_HANDS
            name = "Borghertz's Lurking Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Ninja as main job, level 50 or better, I'll Take the Big Box already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Ifrit's Cauldron for the Old Gauntlets.",
                    pos  = "Ifrit's Cauldron",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Ninja Tekko.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [57] = { -- BORGHERTZS_DRAGON_HANDS
            name = "Borghertz's Dragon Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Dragoon as main job, level 50 or better, Chasing Quotas already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in The Boyahda Tree for the Old Gauntlets.",
                    pos  = "The Boyahda Tree",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Drachen Finger Gauntlets.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [58] = { -- BORGHERTZS_CALLING_HANDS
            name = "Borghertz's Calling Hands",
            steps = {
                {
                    text = "Ask Guslam in Upper Jeuno about the gauntlets. Summoner as main job, level 50 or better, Class Reunion already begun, and no other Borghertz quest open.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { status = 1 },
                },
                {
                    text = "Open the Treasure Coffer in Sea Serpent Grotto for the Old Gauntlets.",
                    pos  = "Sea Serpent Grotto",
                    done = {
                        anyOf = {
                            { ki = 210 }, -- OLD_GAUNTLETS
                            { var = 'Prog', gte = 1 },
                        },
                    },
                },
                {
                    text = "Take the gauntlets to Guslam. First time round he sends you via the Deadly Minnow in Upper Jeuno and Yin Pocanakhu in Lower Jeuno, who wants 1000 gil.",
                    pos  = "Upper Jeuno (!pos -5 1 48)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Ask at Borghertz's marker in Port Jeuno, then light the Torch in Castle Zvahl Baileys, put down the Dark Spark it wakes and take the Shadow Flames.",
                    pos  = "Port Jeuno (!pos -51 8 -4), Castle Zvahl Baileys (!pos 63 -24 21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the Shadow Flames back to the marker in Port Jeuno for the Evoker's Bracers.",
                    pos  = "Port Jeuno (!pos -51 8 -4)",
                },
            },
        },
        [59] = { -- AXE_THE_COMPETITION
            name = "Axe the Competition",
            steps = {
                {
                    text = "Take the weapon trial from Brutus: axe skill 240, a body that can wield the Pick of Trials, and no training guide already in hand.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Pick of Trials until Brutus will take it back, then follow his map to the Temple of Uggalepih: the ??? there draws out Yallery Brown, and it gives up the Annals of Truth.",
                    pos  = "Temple of Uggalepih (!pos 218 -8 206)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Brutus to learn Decimation.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                },
            },
        },
        [60] = { -- WINGS_OF_GOLD
            name = "Wings of Gold",
            steps = {
                {
                    text = "Ask Brutus in Upper Jeuno for beastmaster's work. Beastmaster as main job, Path of the Beastmaster behind you, at artifact-quest level.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                    done = { status = 1 },
                },
                {
                    text = "Open a Treasure Coffer in Middle or Upper Delkfutt's Tower for the Guiding Bell.",
                    pos  = "Middle or Upper Delkfutt's Tower",
                    done = { ki = 232 }, -- GUIDING_BELL
                },
                {
                    text = "Take the bell back to Brutus.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                },
            },
        },
        [61] = { -- SCATTERED_INTO_SHADOW
            name = "Scattered into the Shadow",
            steps = {
                {
                    text = "Take the next job from Brutus; he hands over three sprigs of aquaflora. Beastmaster as main job, Wings of Gold behind you.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                    done = { status = 1 },
                },
                {
                    text = "Feed all three sprigs to the Underground Pools in Feiyin. One of the pools wakes Dabotz's Ghost -- put it down before the last sprig goes in.",
                    pos  = "Feiyin",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Report back to Brutus.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Open the Treasure Chest in Castle Oztroja for a Beast Collar.",
                    pos  = "Castle Oztroja (!pos 7 -16 -193)",
                    -- The collar is spent on Tebhi, so Prog 5 rides alongside it.
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { var = 'Prog', gte = 4 },
                                    { item = 13121 }, -- BEAST_COLLAR
                                },
                            },
                            { var = 'Prog', gte = 5 },
                        },
                    },
                },
                {
                    text = "Trade the Beast Collar to Tebhi in Castle Oztroja.",
                    pos  = "Castle Oztroja (!pos -136 24 -21)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Go back to Brutus.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                },
            },
        },
        [62] = { name = "A New Dawn" }, -- A_NEW_DAWN (name from enum; no script header found)
        [63] = { -- PAINFUL_MEMORY
            name = "Painful Memory",
            steps = {
                {
                    text = "Ask Mertaire in Lower Jeuno for bard's work; he lends you his bracelet. Bard as main job, Path of the Bard behind you.",
                    pos  = "Lower Jeuno (!pos -17 0 -61)",
                    done = { status = 1 },
                },
                {
                    text = "Take the bracelet to the Waters of Oblivion in Ranguemont Pass. Disturbing them wakes Tros -- put it down.",
                    pos  = "Ranguemont Pass (!pos -289 -45 212)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Look into the waters again.",
                    pos  = "Ranguemont Pass (!pos -289 -45 212)",
                },
            },
        },
        [64] = { name = "The Requiem" }, -- THE_REQUIEM (name from enum; no script header found)
        [65] = { name = "The Circle of Time" }, -- THE_CIRCLE_OF_TIME (name from enum; no script header found)
        [66] = { name = "Searching for the Right Words" }, -- SEARCHING_FOR_THE_RIGHT_WORDS (name from enum; no script header found)
        [67] = { name = "Beat Around the Bushin" }, -- BEAT_AROUND_THE_BUSHIN (name from enum; no script header found)
        -- Gated: the accept check demands a completed CoP mission.
        [68] = { -- DUCAL_HOSPITALITY
            name = "Ducal Hospitality",
            gated = 'ENABLE_COP',
            repeatable = true,
            steps = {
                {
                    text = "Take the catering order from Taillegeas in Ru'Lude Gardens. He picks one of five ingredient lists at random and tells you which.",
                    pos  = "Ru'Lude Gardens",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 3, level = 4 } }, -- JEUNO
                        },
                    },
                },
                {
                    text = "Trade Taillegeas the exact set he named, all in one go. He will start another list any time you ask.",
                    pos  = "Ru'Lude Gardens",
                },
            },
        },
        -- Gated: the accept check demands CoP mission progress.
        [69] = { -- IN_THE_MOOD_FOR_LOVE
            name = "In the Mood for Love",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Hear Odasel out in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos -58 -6 -111)",
                    done = { status = 1 }, -- CHAMELEON_DIAMOND
                },
                {
                    text = "Get hold of a Chameleon Diamond.",
                    done = { item = 1666 }, -- CHAMELEON_DIAMOND
                },
                {
                    text = "Trade the diamond to Odasel.",
                    pos  = "Lower Jeuno (!pos -58 -6 -111)",
                },
            },
        },
        -- Gated: the accept check reads CoP mission state.
        [70] = { -- EMPTY_MEMORIES
            name = "Empty Memories",
            gated = 'ENABLE_COP',
            repeatable = true,
            steps = {
                {
                    text = "Hear Harith out in Ru'Lude Gardens.",
                    pos  = "Ru'Lude Gardens (!pos -4 1 134)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Harith a Recollection -- of Pain, Fear or Guilt with 2000 gil, or of Suffering, Anxiety or Animosity on its own -- and he trades back in kind, any number of times.",
                    pos  = "Ru'Lude Gardens (!pos -4 1 134)",
                },
            },
        },
        -- Gated: the accept check demands CoP mission progress.
        [71] = { -- HOOK_LINE_AND_SINKER
            name = "Hook, Line, and Sinker",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the errand from Omer in Lower Jeuno.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 }, -- EGRET_FISHING_ROD
                },
                {
                    text = "Get hold of an Egret Fishing Rod. The script's own note says Sea Bishops and Krakens fished up off Qufim Island carry them, and no fishing skill is needed to hook those.",
                    done = { item = 1726 }, -- EGRET_FISHING_ROD
                },
                {
                    text = "Trade the rod to Omer.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        -- Gated: the accept check demands a completed CoP mission.
        [72] = { -- A_CHOCOBOS_TALE
            name = "A Chocobo's Tale",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Hear Nevela out in Upper Jeuno.",
                    pos  = "Upper Jeuno (!pos -60 0 81)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Wobke in Bastok Mines about the bird.",
                    pos  = "Bastok Mines (!pos 29 0 -111)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Look in at the Outpost Gate in Pashhow Marshlands, then trade three Bottles of Warding Oil there.",
                    pos  = "Pashhow Marshlands (!pos 473 23 413)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Report back to Wobke.",
                    pos  = "Bastok Mines (!pos 29 0 -111)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Follow the trail to the marker in Batallia Downs; Badshah is waiting there, and the Silver Comet's Collar is behind it.",
                    pos  = "Batallia Downs",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Bring the collar to Nevela.",
                    pos  = "Upper Jeuno (!pos -60 0 81)",
                },
            },
        },
        [73] = { name = "A Reputation in Ruins" }, -- A_REPUTATION_IN_RUINS (name from enum; no script header found)
        [74] = { -- THE_GOBBIEBAG_PART_V
            name = "The Gobbiebag Part V",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 3, an inventory of exactly 50 slots and Part IV finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Rhodonite, a Paktong Ingot, a Square of Moblinweave and a Square of Bugard Leather in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        [75] = { -- THE_GOBBIEBAG_PART_VI
            name = "The Gobbiebag Part VI",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 3, an inventory of exactly 55 slots and Part V finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Shakudo Ingot, a Square of Ballon Cloth, an Iolite and a H.Q. Eft Skin in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        -- Accepted and completed in one trigger: never renders Active.
        [76] = { -- BEYOND_THE_SUN
            name = "Beyond the Sun",
            steps = {
                {
                    text = "With Shattering Stars behind you, speak to Maat in Ru'Lude Gardens again on a job at level 66 or better. He closes this out on the spot, so it never reaches the Active tab.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                },
            },
        },
        -- Not gated -- nothing in it needs an expansion -- but see the last
        -- step: upstream has the completion handler commented out.
        [77] = { -- UNLISTED_QUALITIES
            name = "Unlisted Qualities",
            steps = {
                {
                    text = "Hear Luto Mewrilah out in Upper Jeuno; she starts sketching your adventuring fellow.",
                    pos  = "Upper Jeuno (!pos -52 0 46)",
                    done = { status = 1 },
                },
                {
                    text = "Settle the other three details: Akta in Ru'Lude Gardens on size, Kuah Dakonsa in Lower Jeuno on face, and the Red Ghost in Port Jeuno on temperament.",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take the finished picture to Bheem in Upper Jeuno.",
                    pos  = "Upper Jeuno (!pos -89 0 168)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Go back to Luto Mewrilah. Upstream has this last handler commented out pending core support for saving fellows, so it cannot close on this server yet.",
                    pos  = "Upper Jeuno (!pos -52 0 46)",
                },
            },
        },
        [78] = { name = "Girl in the Looking Glass" }, -- GIRL_IN_THE_LOOKING_GLASS (name from enum; no script header found)
        [79] = { name = "Mirror Mirror" }, -- MIRROR_MIRROR (name from enum; no script header found)
        [80] = { name = "Past Reflections" }, -- PAST_REFLECTIONS (name from enum; no script header found)
        [81] = { name = "Blighted Gloom" }, -- BLIGHTED_GLOOM (name from enum; no script header found)
        [82] = { name = "Blessed Radiance" }, -- BLESSED_RADIANCE (name from enum; no script header found)
        [83] = { name = "Mirror Images" }, -- MIRROR_IMAGES (name from enum; no script header found)
        [84] = { name = "Chameleon Capers" }, -- CHAMELEON_CAPERS (name from enum; no script header found)
        [85] = { name = "Regaining Trust" }, -- REGAINING_TRUST (name from enum; no script header found)
        -- Gated: driven entirely by CoP mission state and CoP zones.
        [86] = { -- STORMS_OF_FATE
            name = "Storms of Fate",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Walk into Ru'Lude Gardens while Dawn sits at its last stage; the scene there opens this.",
                    pos  = "Ru'Lude Gardens",
                    done = { status = 1 },
                },
                {
                    text = "Look into the marker on the Misareaux Coast.",
                    pos  = "Misareaux Coast (!pos -259 -30 276)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take what you saw to the Unstable Displacement on Riverne - Site #B01.",
                    pos  = "Riverne - Site #B01 (!pos -612 1 693)",
                },
            },
        },
        [87] = { name = "Mixed Signals" }, -- MIXED_SIGNALS (name from enum; no script header found)
        -- Gated: the three slivers are in the Promyvion zones.
        [88] = { -- SHADOWS_OF_THE_DEPARTED
            name = "Shadows of the Departed",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Walk into Ru'Lude Gardens once Storms of Fate is behind you; the scene hands over Eshantarl's note.",
                    pos  = "Ru'Lude Gardens",
                    done = { status = 1 },
                },
                {
                    text = "Collect all three slivers: one each from the depths of Promyvion-Holla, Promyvion-Dem and Promyvion-Mea.",
                    done = {
                        allOf = {
                            { ki = 358 }, -- PROMYVION_HOLLA_SLIVER
                            { ki = 359 }, -- PROMYVION_DEM_SLIVER
                            { ki = 360 }, -- PROMYVION_MEA_SLIVER
                        },
                    },
                },
                {
                    text = "Walk back into Ru'Lude Gardens.",
                    pos  = "Ru'Lude Gardens",
                },
            },
        },
        -- Gated: Sealion's Den, Grand Palace of Hu'Xzoi, Empyreal Paradox.
        [89] = { -- APOCALYPSE_NIGH
            name = "Apocalypse Nigh",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Walk into Ru'Lude Gardens once Shadows of the Departed is behind you.",
                    pos  = "Ru'Lude Gardens",
                    done = { status = 1 },
                },
                {
                    text = "See it through the Sealion's Den, the Grand Palace of Hu'Xzoi and the Empyreal Paradox.",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Report to Aldo in Lower Jeuno. He wants rank 5 or better in your own nation.",
                    pos  = "Lower Jeuno (!pos 20 3 -58)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Wait a day, then see Gilgamesh in Norg for your reward.",
                    pos  = "Norg (!pos 122 -9 -12)",
                },
            },
        },
        -- Gated: the accept check reads ENABLE_TOAU itself.
        [90] = { -- LURE_OF_THE_WILDCAT
            name = "Lure of the Wildcat (Jeuno)",
            gated = 'ENABLE_TOAU',
            steps = {
                {
                    text = "Take the White Sentinel Badge from Ajithaam in Upper Jeuno.",
                    pos  = "Upper Jeuno (!pos -82 0 160)",
                    done = { status = 1 },
                },
                {
                    text = "Show the badge to all twenty on the list: five each in Lower Jeuno, Port Jeuno, Ru'Lude Gardens and Upper Jeuno.",
                    done = { var = 'Prog', gte = 1048575 },
                },
                {
                    text = "Report back to Ajithaam.",
                    pos  = "Upper Jeuno (!pos -82 0 160)",
                },
            },
        },
        -- Gated: reads ENABLE_TOAU, and it ends in Wajaom Woodlands.
        [91] = { -- THE_ROAD_TO_AHT_URHGAN
            name = "The Road to Aht Urhgan",
            gated = 'ENABLE_TOAU',
            steps = {
                {
                    text = "Hear Faursel out in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos 37 3 -45)",
                    done = { status = 1 },
                },
                {
                    text = "Take his shipping order and trade him the full list of goods he settles on, in one go.",
                    pos  = "Lower Jeuno (!pos 37 3 -45)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "See it out with Faursel. The Boarding Permit is what you are after, and he will point you at Wajaom Woodlands to collect it there if you would rather.",
                    pos  = "Lower Jeuno (!pos 37 3 -45)",
                },
            },
        },
        -- Gated: the accept check reads ENABLE_TOAU itself.
        [92] = { -- CHOCOBO_ON_THE_LOOSE
            name = "Chocobo on the Loose",
            gated = 'ENABLE_TOAU',
            steps = {
                {
                    text = "Take the search off Brutus in Upper Jeuno. Level 20 or better.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                    done = { status = 1 },
                },
                {
                    text = "Read the Chocobo Tracks on La Theine Plateau.",
                    pos  = "La Theine Plateau (!pos -556 0 523)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report to Brutus, then take it up with Hantileon in Southern San d'Oria.",
                    pos  = "Southern San d'Oria (!pos -2 -1 -105)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Go back to Brutus.",
                    pos  = "Upper Jeuno (!pos -55 8 95)",
                },
            },
        },
        [93] = { -- THE_GOBBIEBAG_PART_VII
            name = "The Gobbiebag Part VII",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 4, an inventory of exactly 60 slots and Part VI finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Square of Lynx Leather, an Adaman Ingot, a Square of Rainbow Cloth and a Deathstone in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        [94] = { -- THE_GOBBIEBAG_PART_VIII
            name = "The Gobbiebag Part VIII",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 4, an inventory of exactly 65 slots and Part VII finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Square of Smilodon Leather, an Electrum Ingot, a Square of Cilice and an Angelstone in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        -- Gated: reads ENABLE_WOTG, and the pebbles are in Jugner Forest [S].
        [95] = { -- LAKESIDE_MINUET
            name = "Lakeside Minuet",
            gated = 'ENABLE_WOTG',
            steps = {
                {
                    text = "Hear Laila out in Upper Jeuno. Advanced-job levels or better.",
                    pos  = "Upper Jeuno (!pos -54 -1 100)",
                    done = { status = 1 }, -- STARDUST_PEBBLE
                },
                {
                    text = "Follow the errand round Rhea Myuliah beside her and out to the Glowing Pebbles in Jugner Forest [S]; the Stardust Pebble is what you are after.",
                    pos  = "Jugner Forest [S] (!pos 104 4 443)",
                    done = { ki = 911 }, -- STARDUST_PEBBLE
                },
                {
                    text = "Bring the Stardust Pebble back to Laila.",
                    pos  = "Upper Jeuno (!pos -54 -1 100)",
                },
            },
        },
        -- Gated: the marker is in Grauberg [S].
        [96] = { -- THE_UNFINISHED_WALTZ
            name = "The Unfinished Waltz",
            gated = 'ENABLE_WOTG',
            steps = {
                {
                    text = "Ask Laila in Upper Jeuno for dancer's work.",
                    pos  = "Upper Jeuno (!pos -54 -1 100)",
                    done = { status = 1 },
                },
                {
                    text = "Talk it through with her until she sends you out.",
                    pos  = "Upper Jeuno (!pos -54 -1 100)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Find the marker in Grauberg [S] and take The Essence of Dance from it.",
                    pos  = "Grauberg [S] (!pos -157 -8 596)",
                    done = {
                        allOf = {
                            { var = 'Prog', gte = 1 },
                            { ki = 962 }, -- THE_ESSENCE_OF_DANCE
                        },
                    },
                },
                {
                    text = "Bring it back to Laila.",
                    pos  = "Upper Jeuno (!pos -54 -1 100)",
                },
            },
        },
        -- Gated: the errand runs through Jugner Forest [S].
        [97] = { -- THE_ROAD_TO_DIVADOM
            name = "The Road to Divadom",
            gated = 'ENABLE_WOTG',
            steps = {
                {
                    text = "Take the next job from Laila in Upper Jeuno.",
                    pos  = "Upper Jeuno (!pos -54 -1 100)",
                    done = { status = 1 },
                },
                {
                    text = "Follow Laila and Rhea Myuliah's directions out to Jugner Forest [S] and back; Laila closes it when you return.",
                    pos  = "Jugner Forest [S] (!pos 104 4 443)",
                },
            },
        },
        -- Gated: no gated zone of its own, but it is reachable only through
        -- The Unfinished Waltz and The Road to Divadom, which both are.
        [98] = { -- COMEBACK_QUEEN
            name = "Comeback Queen",
            gated = 'ENABLE_WOTG',
            steps = {
                {
                    text = "Take Wyatt's Proposal from Laila in Upper Jeuno.",
                    pos  = "Upper Jeuno (!pos -54 -1 100)",
                    done = { status = 1 },
                },
                {
                    text = "Carry the proposal to Harmodios in Bastok Markets.",
                    pos  = "Bastok Markets (!pos -79 -4 -135)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take his answer back to Laila and see the rest of it through.",
                    pos  = "Upper Jeuno (!pos -54 -1 100)",
                },
            },
        },
        [99] = { name = "A Furious Finale" }, -- A_FURIOUS_FINALE (name from enum; no script header found)
        [100] = { name = "The Miraculous Dale" }, -- THE_MIRACULOUS_DALE (name from enum; no script header found)
        [101] = { name = "Clash of the Comrades" }, -- CLASH_OF_THE_COMRADES (name from enum; no script header found)
        -- The twenty myth quests share one state machine in
        -- scripts/quests/jeuno/helpers.lua; the id is derived there as
        -- UNLOCKING_A_MYTH_WARRIOR - 1 + jobId (helpers.lua:248), which is
        -- how the linter resolves them -- their own files name no id at
        -- all. Not gated: no expansion flag, no gated zone. Whether the
        -- vigil weapons are obtainable on this server is a content
        -- question, and either way the tracker only ever shows an entry a
        -- player already holds.
        [102] = { -- UNLOCKING_A_MYTH_WARRIOR
            name = "Unlocking a Myth: Warrior",
            steps = {
                {
                    text = "Show Zalsuhm the Sturdy Axe -- the Warrior vigil weapon -- equipped in your main or ranged slot, on Warrior as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Sturdy Axe until it has enough, then trade it to Zalsuhm to learn King's Justice. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [103] = { -- UNLOCKING_A_MYTH_MONK
            name = "Unlocking a Myth: Monk",
            steps = {
                {
                    text = "Show Zalsuhm the Burning Fists -- the Monk vigil weapon -- equipped in your main or ranged slot, on Monk as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Burning Fists until it has enough, then trade it to Zalsuhm to learn Ascetic's Fury. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [104] = { -- UNLOCKING_A_MYTH_WHITE_MAGE
            name = "Unlocking a Myth: White Mage",
            steps = {
                {
                    text = "Show Zalsuhm the Werebuster -- the White Mage vigil weapon -- equipped in your main or ranged slot, on White Mage as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Werebuster until it has enough, then trade it to Zalsuhm to learn Mystic Boon. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [105] = { -- UNLOCKING_A_MYTH_BLACK_MAGE
            name = "Unlocking a Myth: Black Mage",
            steps = {
                {
                    text = "Show Zalsuhm the Mage's Staff -- the Black Mage vigil weapon -- equipped in your main or ranged slot, on Black Mage as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Mage's Staff until it has enough, then trade it to Zalsuhm to learn Vidohunir. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [106] = { -- UNLOCKING_A_MYTH_RED_MAGE
            name = "Unlocking a Myth: Red Mage",
            steps = {
                {
                    text = "Show Zalsuhm the Vorpal Sword -- the Red Mage vigil weapon -- equipped in your main or ranged slot, on Red Mage as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Vorpal Sword until it has enough, then trade it to Zalsuhm to learn Death Blossom. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [107] = { -- UNLOCKING_A_MYTH_THIEF
            name = "Unlocking a Myth: Thief",
            steps = {
                {
                    text = "Show Zalsuhm the Swordbreaker -- the Thief vigil weapon -- equipped in your main or ranged slot, on Thief as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Swordbreaker until it has enough, then trade it to Zalsuhm to learn Mandalic Stab. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [108] = { -- UNLOCKING_A_MYTH_PALADIN
            name = "Unlocking a Myth: Paladin",
            steps = {
                {
                    text = "Show Zalsuhm the Brave Blade -- the Paladin vigil weapon -- equipped in your main or ranged slot, on Paladin as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Brave Blade until it has enough, then trade it to Zalsuhm to learn Atonement. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [109] = { -- UNLOCKING_A_MYTH_DARK_KNIGHT
            name = "Unlocking a Myth: Dark Knight",
            steps = {
                {
                    text = "Show Zalsuhm the Death Sickle -- the Dark Knight vigil weapon -- equipped in your main or ranged slot, on Dark Knight as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Death Sickle until it has enough, then trade it to Zalsuhm to learn Insurgency. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [110] = { -- UNLOCKING_A_MYTH_BEASTMASTER
            name = "Unlocking a Myth: Beastmaster",
            steps = {
                {
                    text = "Show Zalsuhm the Double Axe -- the Beastmaster vigil weapon -- equipped in your main or ranged slot, on Beastmaster as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Double Axe until it has enough, then trade it to Zalsuhm to learn Primal Rend. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [111] = { -- UNLOCKING_A_MYTH_BARD
            name = "Unlocking a Myth: Bard",
            steps = {
                {
                    text = "Show Zalsuhm the Dancing Dagger -- the Bard vigil weapon -- equipped in your main or ranged slot, on Bard as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Dancing Dagger until it has enough, then trade it to Zalsuhm to learn Mordant Rime. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [112] = { -- UNLOCKING_A_MYTH_RANGER
            name = "Unlocking a Myth: Ranger",
            steps = {
                {
                    text = "Show Zalsuhm the Killer Bow -- the Ranger vigil weapon -- equipped in your main or ranged slot, on Ranger as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Killer Bow until it has enough, then trade it to Zalsuhm to learn Trueflight. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [113] = { -- UNLOCKING_A_MYTH_SAMURAI
            name = "Unlocking a Myth: Samurai",
            steps = {
                {
                    text = "Show Zalsuhm the Windslicer -- the Samurai vigil weapon -- equipped in your main or ranged slot, on Samurai as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Windslicer until it has enough, then trade it to Zalsuhm to learn Tachi: Rana. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [114] = { -- UNLOCKING_A_MYTH_NINJA
            name = "Unlocking a Myth: Ninja",
            steps = {
                {
                    text = "Show Zalsuhm the Sasuke Katana -- the Ninja vigil weapon -- equipped in your main or ranged slot, on Ninja as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Sasuke Katana until it has enough, then trade it to Zalsuhm to learn Blade: Kamu. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [115] = { -- UNLOCKING_A_MYTH_DRAGOON
            name = "Unlocking a Myth: Dragoon",
            steps = {
                {
                    text = "Show Zalsuhm the Radiant Lance -- the Dragoon vigil weapon -- equipped in your main or ranged slot, on Dragoon as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Radiant Lance until it has enough, then trade it to Zalsuhm to learn Drakesbane. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [116] = { -- UNLOCKING_A_MYTH_SUMMONER
            name = "Unlocking a Myth: Summoner",
            steps = {
                {
                    text = "Show Zalsuhm the Scepter Staff -- the Summoner vigil weapon -- equipped in your main or ranged slot, on Summoner as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Scepter Staff until it has enough, then trade it to Zalsuhm to learn Garland of Bliss. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [117] = { -- UNLOCKING_A_MYTH_BLUE_MAGE
            name = "Unlocking a Myth: Blue Mage",
            steps = {
                {
                    text = "Show Zalsuhm the Wightslayer -- the Blue Mage vigil weapon -- equipped in your main or ranged slot, on Blue Mage as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Wightslayer until it has enough, then trade it to Zalsuhm to learn Expiacion. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [118] = { -- UNLOCKING_A_MYTH_CORSAIR
            name = "Unlocking a Myth: Corsair",
            steps = {
                {
                    text = "Show Zalsuhm the Quicksilver -- the Corsair vigil weapon -- equipped in your main or ranged slot, on Corsair as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Quicksilver until it has enough, then trade it to Zalsuhm to learn Leaden Salute. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [119] = { -- UNLOCKING_A_MYTH_PUPPETMASTER
            name = "Unlocking a Myth: Puppetmaster",
            steps = {
                {
                    text = "Show Zalsuhm the Inferno Claws -- the Puppetmaster vigil weapon -- equipped in your main or ranged slot, on Puppetmaster as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Inferno Claws until it has enough, then trade it to Zalsuhm to learn Stringing Pummel. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [120] = { -- UNLOCKING_A_MYTH_DANCER
            name = "Unlocking a Myth: Dancer",
            steps = {
                {
                    text = "Show Zalsuhm the Main Gauche -- the Dancer vigil weapon -- equipped in your main or ranged slot, on Dancer as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Main Gauche until it has enough, then trade it to Zalsuhm to learn Pyrrhic Kleos. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [121] = { -- UNLOCKING_A_MYTH_SCHOLAR
            name = "Unlocking a Myth: Scholar",
            steps = {
                {
                    text = "Show Zalsuhm the Elder Staff -- the Scholar vigil weapon -- equipped in your main or ranged slot, on Scholar as main job. Turn him down and he sulks until you zone.",
                    pos  = "Lower Jeuno",
                    done = { status = 1 },
                },
                {
                    text = "Put weapon skill points into that same Elder Staff until it has enough, then trade it to Zalsuhm to learn Omniscience. He hands the weapon back.",
                    pos  = "Lower Jeuno",
                },
            },
        },
        [123] = { -- THE_GOBBIEBAG_PART_IX
            name = "The Gobbiebag Part IX",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 5, an inventory of exactly 70 slots and Part VIII finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix an Orichalcum Ingot, a Square of Peiste Leather, a Square of Oil-Soaked Cloth and an Oxblood Orb in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        [124] = { -- THE_GOBBIEBAG_PART_X
            name = "The Gobbiebag Part X",
            steps = {
                {
                    text = "Ask Bluffnix in Lower Jeuno for the next bag. He wants Jeuno fame level 5, an inventory of exactly 75 slots and Part IX finished.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Bluffnix a Molybdenum Ingot, a Square of Griffon Leather, a Square of Foulard and an Angel Skin Orb in one go -- or a single Bowl of Goblin Stew instead -- and the bag grows by five slots.",
                    pos  = "Lower Jeuno (!pos -43 6 -115)",
                },
            },
        },
        -- Maat's five caps and the Nomad Moogle's five that follow. None is
        -- gated: no expansion flag in any accept path and no gated zone in
        -- any progression. Whether the later caps are wanted at all on
        -- this server is a settings question, not a gate one.
        [128] = { -- IN_DEFIANT_CHALLENGE
            name = "In Defiant Challenge",
            steps = {
                {
                    text = "Ask Maat in Ru'Lude Gardens to lift your cap. He starts this one at exactly level 50 and no higher.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                    done = { status = 1 },
                },
                {
                    text = "Three markers per dungeon, three shreds each: a Clump of Exoray Mold in Crawlers' Nest, a Chunk of Bomb Coal in Garlaige Citadel, a Piece of Ancient Papyrus in the Eldieme Necropolis.",
                    done = {
                        allOf = {
                            { item = 1089 }, -- CLUMP_OF_EXORAY_MOLD
                            { item = 1090 }, -- CHUNK_OF_BOMB_COAL
                            { item = 1088 }, -- PIECE_OF_ANCIENT_PAPYRUS
                        },
                    },
                },
                {
                    text = "Trade all three to Maat in one go.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                },
            },
        },
        [129] = { -- ATOP_THE_HIGHEST_MOUNTAINS
            name = "Atop the Highest Mountains",
            steps = {
                {
                    text = "Ask Maat for the next cap. Level 51 or better.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                    done = { status = 1 },
                },
                {
                    text = "Take all three frigicite off the markers in Xarcabard: the Boreal Tiger's round one, the Boreal Coeurl's square one, the Boreal Hound's triangular one.",
                    pos  = "Xarcabard",
                    done = {
                        allOf = {
                            { ki = 222 }, -- ROUND_FRIGICITE
                            { ki = 223 }, -- SQUARE_FRIGICITE
                            { ki = 224 }, -- TRIANGULAR_FRIGICITE
                        },
                    },
                },
                {
                    text = "Show all three to Maat.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                },
            },
        },
        [130] = { -- WHENCE_BLOWS_THE_WIND
            name = "Whence Blows the Wind",
            steps = {
                {
                    text = "Ask Maat for the next cap. Level 56 or better.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                    done = { status = 1 },
                },
                {
                    text = "Take the three beastman crests: the Orcish one in the Monastic Cavern, the Quadav one in Qulun Dome, the Yagudo one in Castle Oztroja.",
                    done = {
                        allOf = {
                            { ki = 336 }, -- ORCISH_CREST
                            { ki = 337 }, -- QUADAV_CREST
                            { ki = 338 }, -- YAGUDO_CREST
                        },
                    },
                },
                {
                    text = "Show all three to Maat.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                },
            },
        },
        [131] = { -- RIDING_ON_THE_CLOUDS
            name = "Riding on the Clouds",
            steps = {
                {
                    text = "Ask Maat for the next cap. Level 61 or better.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Kindred's Seal at each of the four markers to draw out its keeper, and take the Smiling, Scowling, Somber and Spirited stones.",
                    done = {
                        allOf = {
                            { ki = 466 }, -- SMILING_STONE
                            { ki = 467 }, -- SCOWLING_STONE
                            { ki = 468 }, -- SOMBER_STONE
                            { ki = 469 }, -- SPIRITED_STONE
                        },
                    },
                },
                {
                    text = "Show all four to Maat.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                },
            },
        },
        [132] = { -- SHATTERING_STARS
            name = "Shattering Stars",
            steps = {
                {
                    text = "Ask Maat for the last of his caps. Level 66 or better.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                    done = { status = 1 },
                },
                {
                    text = "Face Maat yourself, alone, on the job you came to him on. Win it and report back.",
                    pos  = "Ru'Lude Gardens (!pos 8 3 118)",
                },
            },
        },
        [133] = { -- NEW_WORLDS_AWAIT
            name = "New Worlds Await",
            steps = {
                {
                    text = "Ask the Nomad Moogle in Ru'Lude Gardens to take the cap past Maat's.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Nomad Moogle five Kindred's Seals in one go.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                },
            },
        },
        [134] = { -- EXPANDING_HORIZONS
            name = "Expanding Horizons",
            steps = {
                {
                    text = "Ask the Nomad Moogle for the next cap, with New Worlds Await behind you.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Nomad Moogle five Kindred's Crests in one go.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                },
            },
        },
        [135] = { -- BEYOND_THE_STARS
            name = "Beyond the Stars",
            steps = {
                {
                    text = "Ask the Nomad Moogle for the next cap, with Expanding Horizons behind you.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Nomad Moogle ten Kindred's Crests in one go, then see off the challenge he sets.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                },
            },
        },
        [136] = { -- DORMANT_POWERS_DISLODGED
            name = "Dormant Powers Dislodged",
            steps = {
                {
                    text = "Ask the Nomad Moogle for the next cap, with Beyond the Stars behind you.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Nomad Moogle a Kindred's Crest together with the item he names, then see off the challenge. The Soul Gem is the reward.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                },
            },
        },
        [137] = { -- BEYOND_INFINITY
            name = "Beyond Infinity",
            steps = {
                {
                    text = "Ask the Nomad Moogle for the last cap, with Prelude to Puissance behind you and the Soul Gem Clasp in hand.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Nomad Moogle five High Kindred's Crests and see it through. At 99 he issues the Job Breaker afterwards.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                },
            },
        },
        [160] = { name = "A Trial in Tandem" }, -- A_TRIAL_IN_TANDEM (name from enum; no script header found)
        [161] = { name = "A Trial in Tandem Redux" }, -- A_TRIAL_IN_TANDEM_REDUX (name from enum; no script header found)
        [162] = { name = "Yet Another Trial in Tandem" }, -- YET_ANOTHER_TRIAL_IN_TANDEM (name from enum; no script header found)
        [163] = { name = "A Quaternary Trial in Tandem" }, -- A_QUATERNARY_TRIAL_IN_TANDEM (name from enum; no script header found)
        [164] = { name = "A Trial in Tandem Revisited" }, -- A_TRIAL_IN_TANDEM_REVISITED (name from enum; no script header found)
        [166] = { name = "All in the Cards" }, -- ALL_IN_THE_CARDS (name from enum; no script header found)
        [167] = { -- MARTIAL_MASTERY
            name = "Martial Mastery",
            steps = {
                {
                    text = "Take the trial on. Level 96 or better.",
                    done = { status = 1 },
                },
                {
                    text = "See it through for the Heart of the Bushin.",
                },
            },
        },
        [168] = { name = "Vw Op 115 Valkurm Duster" }, -- VW_OP_115_VALKURM_DUSTER (name from enum; no script header found)
        [169] = { name = "Vw Op 118 Buburimu Squall" }, -- VW_OP_118_BUBURIMU_SQUALL (name from enum; no script header found)
        [170] = { -- PRELUDE_TO_PUISSANCE
            name = "Prelude to Puissance",
            steps = {
                {
                    text = "Ask the Nomad Moogle to go on, with Dormant Powers Dislodged behind you.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Nomad Moogle a Seasoning Stone and see off the challenge. The Soul Gem Clasp is the reward.",
                    pos  = "Ru'Lude Gardens (!pos 10 1 121)",
                },
            },
        },
        [179] = { name = "Full Speed Ahead" }, -- FULL_SPEED_AHEAD (name from enum; no script header found)
    },
}
