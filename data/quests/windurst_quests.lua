-- dwtracker data -- Windurst quests. Names generated Phase 0
-- (tools/dwtracker_names.py); steps hand-authored in Phase 4 from
-- scripts/quests/windurst/ as ground truth. Entries that stay name-only are
-- ids the enum lists but no script implements on this server: they cannot be
-- accepted, so they can never render a step. Step text describes the state
-- machine the script encodes and nothing else -- where an item comes from a
-- drop table, a shop or gardening rather than from the quest itself, the
-- step names the item and stops there, because those sources are outside
-- what the scripts prove. Pure data: numeric ids and display strings only,
-- no xi.*, no functions (DWTRACKER_FORMAT.md decisions T2/§3-4). Loaded
-- byte-identically by the server module and the dwtracker addon; both hash
-- these bytes, so an edit that reaches only one side makes the addon refuse
-- step rendering for this area until the copies agree again.
-- tools/dwtracker_lint.py must pass before edits ship.
return {
    kind = 'quests',
    log = 2,
    area = 'windurst_quests',
    label = "Windurst",
    entries = {
        [0] = { name = "Hat in Hand" }, -- HAT_IN_HAND (name from enum; no script header found)
        [1] = { name = "A Feather in Ones Cap" }, -- A_FEATHER_IN_ONES_CAP (name from enum; no script header found)
        [2] = { name = "A Crisis in the Making" }, -- A_CRISIS_IN_THE_MAKING (name from enum; no script header found)
        [3] = { -- MAKING_AMENDS
            name = "Making Amends",
            steps = {
                {
                    text = "Hear out Hakkuru-Rinkuru in Port Windurst: the repair job he has taken on is stuck until someone brings him glue.",
                    pos  = "Port Windurst (!pos -111 -4 101)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 2 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Get hold of a Block of Animal Glue. Kuroido-Moido, standing with him, will talk about the job while you are away.",
                    done = { item = 937 }, -- BLOCK_OF_ANIMAL_GLUE
                },
                {
                    text = "Trade the Block of Animal Glue to Hakkuru-Rinkuru for your pay.",
                    pos  = "Port Windurst (!pos -111 -4 101)",
                },
            },
        },
        -- The script header on Mihgos_Amigo.lua claims this id; its Quest:new
        -- says otherwise, so the name here comes from the code (see [25]).
        [4] = { -- MAKING_THE_GRADE
            name = "Making the Grade",
            steps = {
                {
                    text = "Take the marking job from Fuepepe in Windurst Waters. He only offers it once Teacher's Pet is behind you.",
                    pos  = "Windurst Waters (!pos 161 -2 161)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 3 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Bring Fuepepe the Pile of Answer Sheets he wants marked and show them to him.",
                    pos  = "Windurst Waters (!pos 161 -2 161)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade the answer sheets to Koru-Moru in Windurst Walls; he marks them and hands back a Tattered Test Sheet.",
                    pos  = "Windurst Walls (!pos -120 -6 124)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Report back to Fuepepe. Chomoro-Kyotoro, the student, will take the marked sheet off your hands if you show it to him first.",
                    pos  = "Fuepepe: Windurst Waters (!pos 161 -2 161)",
                },
            },
        },
        [5] = { name = "In a Pickle" }, -- IN_A_PICKLE (name from enum; no script header found)
        [6] = { name = "Wondering Minstrel" }, -- WONDERING_MINSTREL (name from enum; no script header found)
        [7] = { -- A_POSE_BY_ANY_OTHER_NAME
            name = "A Pose By Any Other Name",
            steps = {
                {
                    text = "Agree to model for Angelica in Windurst Waters.",
                    pos  = "Windurst Waters (!pos -64 -9 -9)",
                    done = { status = 1 },
                },
                {
                    text = "Speak to Angelica again to hear which piece of body gear she wants you posing in. Her patience runs out one hour later.",
                    pos  = "Windurst Waters (!pos -64 -9 -9)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Equip the body piece she named and go back to her inside the hour. Turn up late and she drops you from the shoot.",
                    pos  = "Windurst Waters (!pos -64 -9 -9)",
                },
            },
        },
        [8] = { name = "Making Amens" }, -- MAKING_AMENS (name from enum; no script header found)
        [9] = { name = "The Moonlit Path" }, -- THE_MOONLIT_PATH (name from enum; no script header found)
        [10] = { -- STAR_STRUCK
            name = "Star Struck",
            steps = {
                {
                    text = "Show Koru-Moru in Windurst Walls the Torn Epistle you are carrying -- he will not raise the subject without it.",
                    pos  = "Windurst Walls (!pos -120 -6 124)",
                    done = { status = 1 },
                },
                {
                    text = "Get hold of a Meteorite. Koru-Moru will also buy the Torn Epistle itself off you for 50 gil if you trade it to him.",
                    done = { item = 582 }, -- METEORITE
                },
                {
                    text = "Trade the Meteorite to Koru-Moru.",
                    pos  = "Windurst Walls (!pos -120 -6 124)",
                },
            },
        },
        [11] = { -- BLAST_FROM_THE_PAST
            name = "Blast from the Past",
            steps = {
                {
                    text = "Take the errand from Koru-Moru in Windurst Walls. He raises it only once Star Struck is behind you.",
                    pos  = "Windurst Walls (!pos -120 -6 124)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 3 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Ask Tokaka in Port Windurst about the fossil Koru-Moru described.",
                    pos  = "Port Windurst",
                    done = { var = 'Option', gte = 1 },
                },
                {
                    text = "Take what Tokaka told you to Yoran-Oran in Windurst Walls.",
                    pos  = "Windurst Walls",
                    done = { var = 'Option', gte = 2 },
                },
                {
                    text = "Search the fossil rocks in the Maze of Shakhrami. The one that answers wakes the Ichorous Ire, and the Burnite Shell Stone is behind it.",
                    pos  = "Maze of Shakhrami",
                    done = {
                        allOf = {
                            { var = 'Option', gte = 2 },
                            { item = 16511 }, -- BURNITE_SHELL_STONE
                        },
                    },
                },
                {
                    text = "Trade the Burnite Shell Stone to Koru-Moru.",
                    pos  = "Windurst Walls (!pos -120 -6 124)",
                },
            },
        },
        [12] = { -- A_SMUDGE_ON_ONES_RECORD
            name = "A Smudge on One's Record",
            steps = {
                {
                    text = "Take the job from Hariga-Origa in Windurst Waters. He raises it only once Chasing Tales is behind you.",
                    pos  = "Windurst Waters (!pos -62 -6 105)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 4 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Round up a Vial of Slime Oil and a Frost Turnip. Serukoko, standing nearby, will explain what they are for.",
                    done = {
                        allOf = {
                            { item = 637 },  -- VIAL_OF_SLIME_OIL
                            { item = 4382 }, -- FROST_TURNIP
                        },
                    },
                },
                {
                    text = "Trade the Vial of Slime Oil and the Frost Turnip together to Hariga-Origa.",
                    pos  = "Windurst Waters (!pos -62 -6 105)",
                },
            },
        },
        [13] = { -- CHASING_TALES
            name = "Chasing Tales",
            steps = {
                {
                    text = "Take the errand from Tosuka-Porika in Windurst Waters. She raises it only once Early Bird Catches the Bookworm is behind you.",
                    pos  = "Windurst Waters (!pos -26 -6 103)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 3 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Get the overdue notice from Furakku-Norakku at the library desk, then work the Mithra of Windurst Woods until Hae Jakkya gives up where the book went.",
                    pos  = "Hae Jakkya: Windurst Woods (!pos 57 -2 -140)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "The trail leads abroad: find Hae Jakhya in Southern San d'Oria and get A Song of Love back off her.",
                    pos  = "Southern San d'Oria (!pos -75 -7 -23)",
                    done = {
                        allOf = {
                            { var = 'Prog', gte = 1 },
                            { ki = 126 }, -- A_SONG_OF_LOVE
                        },
                    },
                },
                {
                    text = "Carry the book back to Furakku-Norakku.",
                    pos  = "Windurst Waters (!pos -19 -5 101)",
                },
            },
        },
        [14] = { -- FOOD_FOR_THOUGHT
            name = "Food for Thought",
            steps = {
                {
                    text = "Ask Ohbiru-Dohbiru about the researchers going hungry, then take the errand from Kerutoto.",
                    pos  = "Windurst Waters (Ohbiru-Dohbiru !pos 23 -5 -193, Kerutoto !pos 13 -5 -157)",
                    done = { status = 1 },
                },
                {
                    text = "Three deliveries, any order. Trade a Hard-Boiled Egg to Kenapa-Keppa.",
                    pos  = "Windurst Waters (!pos 27 -6 -199)",
                    done = { var = 'kenapaProg', gte = 4 },
                },
                {
                    text = "Trade a Slice of Grilled Hare to Kerutoto.",
                    pos  = "Windurst Waters (!pos 13 -5 -157)",
                    done = {
                        allOf = {
                            { var = 'kenapaProg', gte = 4 },
                            { var = 'kerutotoProg', gte = 2 },
                        },
                    },
                },
                {
                    text = "Trade a Cup of Windurstian Tea, a Tortilla and a Clump of Pamtam Kelp to Ohbiru-Dohbiru -- all three in one trade. The last delivery closes the errand.",
                    pos  = "Windurst Waters (!pos 23 -5 -193)",
                },
            },
        },
        [15] = { -- OVERNIGHT_DELIVERY
            name = "Overnight Delivery",
            steps = {
                {
                    text = "Let Kenapa-Keppa talk you into the run. He only brings it up between 7:00 and midnight, and it takes a few rounds of talk to get to the offer.",
                    pos  = "Windurst Waters (!pos 27 -6 -199)",
                    done = { status = 1 },
                },
                {
                    text = "Cross to Mhaura and see Kotan-Purutan between 18:00 and 6:00 -- he hands the Small Bag over after dark and not before.",
                    pos  = "Mhaura (!pos 40 -9 44)",
                    done = { ki = 99 }, -- SMALL_BAG
                },
                {
                    text = "Carry the Small Bag back to Kenapa-Keppa before dawn of the day after you collected it. Miss the deadline and he takes the quest back off you.",
                    pos  = "Windurst Waters (!pos 27 -6 -199)",
                },
            },
        },
        [16] = { -- WATER_WAY_TO_GO
            name = "Water Way to Go",
            steps = {
                {
                    text = "Take the empty Rhinostery Canteen from Ohbiru-Dohbiru in Windurst Waters.",
                    pos  = "Windurst Waters (!pos 23 -5 -193)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the canteen to the spring in Giddeus to fill it. Lose the canteen and Ohbiru-Dohbiru will hand you another.",
                    pos  = "Giddeus (!pos -258 -2 -249)",
                    done = { item = 4351 }, -- CANTEEN_OF_GIDDEUS_WATER
                },
                {
                    text = "Trade the Canteen of Giddeus Water back to Ohbiru-Dohbiru.",
                    pos  = "Windurst Waters (!pos 23 -5 -193)",
                },
            },
        },
        [17] = { -- BLUE_RIBBON_BLUES
            name = "Blue Ribbon Blues",
            steps = {
                {
                    text = "Roberta in Windurst Woods will give you her Purple Ribbon. Trade it to Kerutoto in Windurst Waters and hear what he means to do with it.",
                    pos  = "Roberta: Windurst Woods (!pos 21 -4 -157), Kerutoto: Windurst Waters (!pos 13 -5 -157)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 5 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Give Kerutoto a minute to work, then take the ribbon back off him.",
                    pos  = "Windurst Waters (!pos 13 -5 -157)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade the Purple Ribbon to the Hume Bones in the Eldieme Necropolis, put down the Lich C. Magnus it wakes, then search the bones again for the Blue Ribbon.",
                    pos  = "The Eldieme Necropolis (!pos 299 0 19)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Bring the Blue Ribbon back to Kerutoto.",
                    pos  = "Windurst Waters (!pos 13 -5 -157)",
                },
            },
        },
        [18] = { name = "The All New C 3000" }, -- THE_ALL_NEW_C_3000 (name from enum; no script header found)
        [19] = { name = "The Postman Always Kos Twice" }, -- THE_POSTMAN_ALWAYS_KOS_TWICE (name from enum; no script header found)
        [20] = { -- EARLY_BIRD_CATCHES_THE_BOOKWORM
            name = "Early Bird Catches the Bookworm",
            steps = {
                {
                    text = "Take the errand from Tosuka-Porika in Windurst Waters. She raises it only once Glyph Hanger is behind you.",
                    pos  = "Windurst Waters (!pos -26 -6 103)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 2 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Collect the overdue-book notice from Furakku-Norakku, then take it to Orn -- he knows where the book ended up.",
                    pos  = "Windurst Waters (Furakku-Norakku !pos -19 -5 101, Orn !pos -68 -9 30)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Buy the book back from Quu Bokye in Giddeus. He wants a Silver Beastcoin for it.",
                    pos  = "Giddeus (!pos -159 16 181)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Return Art for Everyone to Furakku-Norakku. Orn will want to hear how it went if you can spare the walk.",
                    pos  = "Windurst Waters (!pos -19 -5 101)",
                },
            },
        },
        [21] = { name = "Catch It If You Can" }, -- CATCH_IT_IF_YOU_CAN (name from enum; no script header found)
        [23] = { -- ALL_AT_SEA
            name = "All at Sea",
            steps = {
                {
                    text = "Trade a Ripped Cap to Paytah on the Port Windurst waterfront; he wants it made good again.",
                    pos  = "Port Windurst (!pos 77 -5 119)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 3 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Take a Ripped Cap to the leatherworker Baren-Moren in Windurst Waters and leave it with him.",
                    pos  = "Windurst Waters (!pos -66 -2 -148)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Bring Baren-Moren four Dhalmel Hides and he works them into a Sailor's Cap.",
                    pos  = "Windurst Waters (!pos -66 -2 -148)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade the Sailor's Cap to Paytah.",
                    pos  = "Port Windurst (!pos 77 -5 119)",
                },
            },
        },
        [24] = { name = "The All New C 2000" }, -- THE_ALL_NEW_C_2000 (name from enum; no script header found)
        -- Mihgos_Amigo.lua's header claims id 4; its Quest:new says 25.
        [25] = { -- MIHGOS_AMIGO
            name = "Mihgo's Amigo",
            repeatable = true,
            steps = {
                {
                    text = "Take the job from Nanaa Mihgo in Windurst Woods. She will not raise it while The Tenshodo Showdown or As Thick as Thieves is open.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = { status = 1 },
                },
                {
                    text = "Collect four Yagudo Bead Necklaces. Cha Lebagta, loitering nearby, has plenty to say about where they come from.",
                    done = { item = 498, qty = 4 }, -- YAGUDO_BEAD_NECKLACE
                },
                {
                    text = "Trade all four necklaces to Nanaa Mihgo. She will take another four any time you bring them.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                },
            },
        },
        [26] = { -- ROCK_RACKETEER
            name = "Rock Racketeer",
            steps = {
                {
                    text = "Take the errand from Nanaa Mihgo; she hands over a Sharp Gray Stone to shift.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 3 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Carry the stone to the appraiser Ardea in Bastok Markets and let her make her offer.",
                    pos  = "Bastok Markets (!pos -198 -6 -71)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report what Ardea paid back to Nanaa Mihgo.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Dig a Sharp Stone out of the Mythril Seam in Palborough Mines.",
                    pos  = "Palborough Mines (!pos 210 -32 -63)",
                    done = {
                        allOf = {
                            { var = 'Prog', gte = 2 },
                            { item = 598 }, -- SHARP_STONE
                        },
                    },
                },
                {
                    text = "Trade the Sharp Stone to Varun in Windurst Woods.",
                    pos  = "Windurst Woods (!pos 9 -2 -7)",
                },
            },
        },
        [27] = { name = "Chocobilious" }, -- CHOCOBILIOUS (name from enum; no script header found)
        [28] = { -- TEACHERS_PET
            name = "Teacher's Pet",
            repeatable = true,
            steps = {
                {
                    text = "Talk to Moreno-Toeno in Windurst Waters twice -- the first pass is preamble, the second is the actual request.",
                    pos  = "Windurst Waters (!pos 169 -1 159)",
                    done = { status = 1 },
                },
                {
                    text = "Collect a Bird Feather and a Two-Leaf Mandragora Bud.",
                    done = {
                        allOf = {
                            { item = 847 },  -- BIRD_FEATHER
                            { item = 4368 }, -- TWO_LEAF_MANDRAGORA_BUD
                        },
                    },
                },
                {
                    text = "Trade both specimens together to Moreno-Toeno. He will take another pair whenever you have them.",
                    pos  = "Windurst Waters (!pos 169 -1 159)",
                },
            },
        },
        [29] = { name = "Reap What You Sow" }, -- REAP_WHAT_YOU_SOW (name from enum; no script header found)
        [30] = { -- GLYPH_HANGER
            name = "Glyph Hanger",
            steps = {
                {
                    text = "Take the note from Hariga-Origa in Windurst Waters.",
                    pos  = "Windurst Waters (!pos -62 -6 105)",
                    done = { status = 1 },
                },
                {
                    text = "Carry the note out to Ipupu in West Sarutabaruta; he reads it and writes his answer back.",
                    pos  = "West Sarutabaruta (!pos 251 -5 35)",
                    done = { ki = 26 }, -- NOTE_FROM_IPUPU
                },
                {
                    text = "Bring Ipupu's note back to Hariga-Origa.",
                    pos  = "Windurst Waters (!pos -62 -6 105)",
                },
            },
        },
        [31] = { -- THE_FANGED_ONE
            name = "The Fanged One",
            steps = {
                {
                    text = "Ask Perih Vashai in Windurst Woods about the ranger's path. She only takes the question seriously once you have the levels for an advanced job.",
                    pos  = "Windurst Woods (!pos 117 -3 92)",
                    done = { status = 1 },
                },
                {
                    text = "Find the Tiger Bones in Sauromugue Champaign. Disturbing them wakes Old Sabertooth; put it down and search the bones again for the Old Tiger's Fang.",
                    pos  = "Sauromugue Champaign (!pos 666 -8 -379)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Bring the fang back to Perih Vashai and she unlocks Ranger.",
                    pos  = "Windurst Woods (!pos 117 -3 92)",
                },
            },
        },
        [32] = { -- CURSES_FOILED_AGAIN_1
            name = "Curses, Foiled Again! (1)",
            steps = {
                {
                    text = "Let Shantotto in Windurst Walls talk you into fetching for her hex.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                    done = { status = 1 },
                },
                {
                    text = "Collect a Pinch of Bomb Ash and two Bone Chips.",
                    done = {
                        allOf = {
                            { item = 928 }, -- PINCH_OF_BOMB_ASH
                            { item = 880, qty = 2 }, -- BONE_CHIP
                        },
                    },
                },
                {
                    text = "Trade all three to Shantotto in one go.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                },
            },
        },
        [33] = { -- CURSES_FOILED_AGAIN_2
            name = "Curses, Foiled Again!? (2)",
            steps = {
                {
                    text = "Take the second hex job from Shantotto. She raises it only a day after the first one, and only once you have heard Hiwon-Biwon out and been back to her.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 2 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Ask Hiwon-Biwon for a Lock of Hiwon's Hair, and gather two Bomb Arms and a Revival Tree Root.",
                    pos  = "Hiwon-Biwon: Windurst Walls",
                    done = {
                        allOf = {
                            { item = 552 }, -- LOCK_OF_HIWONS_HAIR
                            { item = 17316, qty = 2 }, -- BOMB_ARM
                            { item = 940 }, -- REVIVAL_TREE_ROOT
                        },
                    },
                },
                {
                    text = "Trade all four items to Shantotto in one go.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                },
            },
        },
        [34] = { name = "Mandragora Mad" }, -- MANDRAGORA_MAD (name from enum; no script header found)
        [35] = { name = "To Bee Or Not to Bee" }, -- TO_BEE_OR_NOT_TO_BEE (name from enum; no script header found)
        [36] = { -- TRUTH_JUSTICE_AND_THE_ONION_WAY
            name = "Truth, Justice, and the Onion Way",
            steps = {
                {
                    text = "Let Kohlo-Lakolo swear you into the Star Onion Brigade.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = { status = 1 },
                },
                {
                    text = "Get hold of a Rarab Tail. The rest of the brigade will offer opinions on this while you are about it.",
                    done = { item = 4444 }, -- RARAB_TAIL
                },
                {
                    text = "Trade the Rarab Tail to Kohlo-Lakolo.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                },
            },
        },
        [37] = { name = "Making Headlines" }, -- MAKING_HEADLINES (name from enum; no script header found)
        [38] = { -- SCOOPED
            name = "Scooped!",
            steps = {
                {
                    text = "Take the story from Naiko-Paneiko in Windurst Waters.",
                    pos  = "Windurst Waters",
                    done = { status = 1 },
                },
                {
                    text = "Get hold of a Bronze Box. Chyuk-Kochak has something to say about it while you are looking.",
                    done = { item = 580 }, -- BRONZE_BOX
                },
                {
                    text = "Trade the Bronze Box to Naiko-Paneiko.",
                    pos  = "Windurst Waters",
                },
            },
        },
        [39] = { name = "Creepy Crawlies" }, -- CREEPY_CRAWLIES (name from enum; no script header found)
        -- The brigade's own flow splits on the player's Windurst rank, which
        -- the DSL cannot read (its rank atom is the player's OWN nation, and
        -- this script asks for Windurst's specifically). So the last step
        -- names both endings rather than sending an outgrown brigadier to an
        -- NPC who has nothing left to say -- FORMAT §6.8's rule, applied by
        -- collapsing the branch into one honest step instead of guessing.
        [40] = { -- KNOW_ONES_ONIONS
            name = "Know One's Onions",
            steps = {
                {
                    text = "Take the next case from Kohlo-Lakolo. He wants you at level 5 or better before he will hand it over.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Kohlo-Lakolo four Wild Onions at once.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Report back to Kohlo-Lakolo. While the brigade still holds you he sends you to their lookout in Windurst Walls first; once you have outgrown them he closes it on the spot.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                },
            },
        },
        [41] = { -- INSPECTORS_GADGET
            name = "Inspector's Gadget!",
            steps = {
                {
                    text = "Take the stakeout from Kohlo-Lakolo. Level 5 or better.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 2 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Hear Pichichi out about the disguise, then take the idea to Chamama in Windurst Waters.",
                    pos  = "Pichichi: Port Windurst, Chamama: Windurst Waters",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade Chamama four Balls of Saruta Cotton and she runs up the Fake Moustache.",
                    pos  = "Windurst Waters",
                    done = {
                        allOf = {
                            { var = 'Prog', gte = 2 },
                            { ki = 95 }, -- FAKE_MOUSTACHE
                        },
                    },
                },
                {
                    text = "Report to Kohlo-Lakolo wearing the moustache.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                },
            },
        },
        [42] = { -- ONION_RINGS
            name = "Onion Rings",
            steps = {
                {
                    text = "Take the case from Kohlo-Lakolo. Mentioning the Old Ring starts a one-day clock, and he only signs you on once you are actually carrying the ring.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 3 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Reach the brigade's lookout in Windurst Walls while the day still holds. Let the clock run out and Kohlo-Lakolo closes the case himself when you report back to him.",
                    pos  = "Windurst Walls",
                },
            },
        },
        [43] = { name = "A Greeting Cardian" }, -- A_GREETING_CARDIAN (name from enum; no script header found)
        [44] = { name = "Legendary Plan B" }, -- LEGENDARY_PLAN_B (name from enum; no script header found)
        [45] = { -- IN_A_STEW
            name = "In a Stew",
            repeatable = true,
            steps = {
                {
                    text = "Take the errand from Kuoh Rhel in Windurst Woods. It comes round again after each conquest tally.",
                    pos  = "Windurst Woods (!pos 131 -6 -102)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 2 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Trade three Woozyshrooms to Ranpi-Monpi in Windurst Waters and she cooks them into her special stew.",
                    pos  = "Windurst Waters (!pos -116 -3 52)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Carry the stew back to Kuoh Rhel.",
                    pos  = "Windurst Woods (!pos 131 -6 -102)",
                },
            },
        },
        [46] = { -- LET_SLEEPING_DOGS_LIE
            name = "Let Sleeping Dogs Lie",
            steps = {
                {
                    text = "Take the problem off Paku-Nakku's hands in Windurst Waters.",
                    pos  = "Windurst Waters (!pos 127 -5 164)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 4 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Ask Maabu-Sonbu in Port Windurst what would rouse a sleeper.",
                    pos  = "Port Windurst (!pos -107 -3 108)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade Paku-Nakku one of the two remedies Maabu-Sonbu named: Blazing Peppers, or an actual Remedy.",
                    pos  = "Windurst Waters (!pos 127 -5 164)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Tell Pechiru-Mashiru what happened.",
                    pos  = "Windurst Waters (!pos 163 -1 157)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Go back to Paku-Nakku; she wants you to make the call for her.",
                    pos  = "Windurst Waters (!pos 127 -5 164)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Return to Pechiru-Mashiru to close it out.",
                    pos  = "Windurst Waters (!pos 163 -1 157)",
                },
            },
        },
        [47] = { name = "Can Cardians Cry" }, -- CAN_CARDIANS_CRY (name from enum; no script header found)
        [48] = { name = "Wonder Wands" }, -- WONDER_WANDS (name from enum; no script header found)
        [49] = { name = "Heaven Cent" }, -- HEAVEN_CENT (name from enum; no script header found)
        [50] = { -- SAY_IT_WITH_FLOWERS
            name = "Say it with Flowers",
            repeatable = true,
            steps = {
                {
                    text = "Take the flower run from Moari-Kaaori in Windurst Waters.",
                    pos  = "Windurst Waters (!pos -252 -5 -230)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 2 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Bring her a flower. Ohbiru-Dohbiru sells six kinds for gil; the Tahrongi Cactus is free off the cacti in Tahrongi Canyon and pays best of all -- an Iron Sword the first time.",
                    pos  = "Moari-Kaaori: Windurst Waters (!pos -252 -5 -230)",
                },
            },
        },
        [51] = { name = "Hoist the Jelly Roger" }, -- HOIST_THE_JELLY_ROGER (name from enum; no script header found)
        [52] = { name = "Something Fishy" }, -- SOMETHING_FISHY (name from enum; no script header found)
        [53] = { name = "To Catch a Falling Star" }, -- TO_CATCH_A_FALLING_STAR (name from enum; no script header found)
        [60] = { name = "Paying Lip Service" }, -- PAYING_LIP_SERVICE (name from enum; no script header found)
        [61] = { name = "The Amazin Scorpio" }, -- THE_AMAZIN_SCORPIO (name from enum; no script header found)
        [62] = { name = "Twinstone Bonding" }, -- TWINSTONE_BONDING (name from enum; no script header found)
        [63] = { -- CURSES_FOILED_A_GOLEM
            name = "Curses, Foiled A-Golem!?",
            steps = {
                {
                    text = "Take the third hex job from Shantotto. Level 10 or better, and the second one behind you.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 4 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Find Torino-Samarino in Beaucedine Glacier and take Shantotto's New Spell off him.",
                    pos  = "Beaucedine Glacier (!pos 105 -20 140)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Carry the spell to the Cermet Door in Feiyin. Kill anything in Feiyin on the way and the spell curdles -- Torino-Samarino will only replace it a day later.",
                    pos  = "Feiyin (!pos -183 0 190)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Report back to Shantotto.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                },
            },
        },
        [64] = { -- ACTING_IN_GOOD_FAITH
            name = "Acting in Good Faith",
            steps = {
                {
                    text = "Take the Spirit Incense from Gantineux in Windurst Waters. Level 10 or better.",
                    pos  = "Windurst Waters (!pos -83 -9 3)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 4 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Burn the incense at the marker inside the Eldieme Necropolis, then go back to Gantineux -- he writes a letter for you to carry on.",
                    pos  = "The Eldieme Necropolis",
                    done = { ki = 176 }, -- GANTINEUXS_LETTER
                },
                {
                    text = "Deliver Gantineux's letter to Eperdur in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos 129 -6 96)",
                },
            },
        },
        [65] = { -- FLOWER_CHILD
            name = "Flower Child",
            steps = {
                {
                    text = "Trade Ojha Rhawash in Windurst Walls any flower and he starts explaining what he actually wants.",
                    pos  = "Windurst Walls (!pos -209 0 -134)",
                    done = { status = 1 },
                },
                {
                    text = "Bring him a Lilac. Nothing else in the flower bed will do.",
                    pos  = "Windurst Walls (!pos -209 0 -134)",
                },
            },
        },
        [66] = { name = "The Three Magi" }, -- THE_THREE_MAGI (name from enum; no script header found)
        [67] = { name = "Recollections" }, -- RECOLLECTIONS (name from enum; no script header found)
        [68] = { name = "The Root of the Problem" }, -- THE_ROOT_OF_THE_PROBLEM (name from enum; no script header found)
        [69] = { -- THE_TENSHODO_SHOWDOWN
            name = "The Tenshodo Showdown",
            steps = {
                {
                    text = "Ask Nanaa Mihgo in Windurst Woods for thief's work. Thief as main job, at the level this server sets for artifact quests.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = { status = 1 },
                },
                {
                    text = "Carry her letter to Harnek in Lower Jeuno; he trades it for a Tenshodo Envelope.",
                    pos  = "Lower Jeuno (!pos 44 0 -19)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take the envelope to Elfriede in Selbina and hear her price for signing it.",
                    pos  = "Selbina (!pos 61 -15 10)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade Elfriede a Bowl of Quadav Stew and she signs.",
                    pos  = "Selbina (!pos 61 -15 10)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Take the signed envelope back to Harnek.",
                    pos  = "Lower Jeuno (!pos 44 0 -19)",
                },
            },
        },
        [70] = { -- AS_THICK_AS_THIEVES
            name = "As Thick as Thieves",
            steps = {
                {
                    text = "Take the next job from Nanaa Mihgo; she hands you a note and two forged envelopes to get signed.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = { status = 1 },
                },
                {
                    text = "Find Sniggnix in Lower Jeuno and let him draw you into the gambling.",
                    pos  = "Lower Jeuno (!pos -45 4 -135)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Beat all three goblins in Dangruf Wadi at dice: Saltvix stakes a Chunk of Rock Salt, Grasswix a Clump of Gausebit Wildgrass, Eggblix a Lizard Egg.",
                    pos  = "Dangruf Wadi",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Draw Gambilox Wanderling out at the marker in North Gustaberg, put it down, and take the Regal Die.",
                    pos  = "North Gustaberg",
                    done = { var = 'Prog', gte = 6 },
                },
                {
                    text = "Trade the Regal Die to Sniggnix; he signs the second forged envelope.",
                    pos  = "Lower Jeuno (!pos -45 4 -135)",
                    done = { var = 'Prog', gte = 7 },
                },
                {
                    text = "Climb the right tower in Sauromugue Champaign with a Grapnel to get the first envelope signed. Cha Lebagta in Windurst Woods knows which tower.",
                    pos  = "Sauromugue Champaign",
                    done = {
                        allOf = {
                            { var = 'Prog', gte = 7 },
                            { ki = 189 }, -- FIRST_SIGNED_FORGED_ENVELOPE
                        },
                    },
                },
                {
                    text = "Take both signed envelopes back to Nanaa Mihgo.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                },
            },
        },
        -- Two errands run in parallel here, and reporting them resets both
        -- counters (event 516 zeroes hagainProg and yatnielProg). So the
        -- errand steps ride anyOf{ their own threshold, nanaaProg } -- the
        -- survivor -- and stack cumulatively so the bright line always lands
        -- on an errand that is genuinely still outstanding.
        [71] = { -- HITTING_THE_MARQUISATE
            name = "Hitting the Marquisate",
            steps = {
                {
                    text = "Take the last of Nanaa Mihgo's jobs; she hands over the Cat Burglar's Note.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Yatniel in Lower Jeuno about the explosives, then bring him four Quake Grenades.",
                    pos  = "Lower Jeuno (!pos -66 -7 -126)",
                    done = {
                        anyOf = {
                            { var = 'yatnielProg', gte = 2 },
                            { var = 'nanaaProg', gte = 1 },
                        },
                    },
                },
                {
                    text = "See Hagain in Mhaura for the Bomb Incense, then work the six markers in Garlaige Citadel in the order he gives you.",
                    pos  = "Hagain: Mhaura (!pos 12 -16 81)",
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { var = 'yatnielProg', gte = 2 },
                                    { var = 'hagainProg', gte = 7 },
                                },
                            },
                            { var = 'nanaaProg', gte = 1 },
                        },
                    },
                },
                {
                    text = "Draw out the Chandelier at the last Garlaige marker, take a Lump of Chandelier Coal off it, and trade that to Hagain.",
                    pos  = "Garlaige Citadel",
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { var = 'yatnielProg', gte = 2 },
                                    { var = 'hagainProg', gte = 8 },
                                },
                            },
                            { var = 'nanaaProg', gte = 1 },
                        },
                    },
                },
                {
                    text = "Report both halves to Nanaa Mihgo.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = { var = 'nanaaProg', gte = 1 },
                },
                {
                    text = "Trade a Pickaxe at the marker on La Theine Plateau.",
                    pos  = "La Theine Plateau (!pos -72 54 -443)",
                },
            },
        },
        [72] = { name = "Sin Hunting" }, -- SIN_HUNTING (name from enum; no script header found)
        [73] = { name = "Fire and Brimstone" }, -- FIRE_AND_BRIMSTONE (name from enum; no script header found)
        [74] = { name = "Unbridled Passion" }, -- UNBRIDLED_PASSION (name from enum; no script header found)
        [75] = { -- I_CAN_HEAR_A_RAINBOW
            name = "I Can Hear a Rainbow",
            steps = {
                {
                    text = "Bring a Carbuncle's Ruby to the House of the Hero in Windurst Walls. You need the levels for an advanced job and the ruby actually in your inventory.",
                    pos  = "Windurst Walls (!pos -26 -13 260)",
                    done = { status = 1 },
                },
                {
                    text = "Carry the ruby to the markers standing in the open zones across the three continents. Each one feeds it a different element's light, and the stone wants the full set.",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade the charged Carbuncle's Ruby at the marker on La Theine Plateau.",
                    pos  = "La Theine Plateau",
                },
            },
        },
        [76] = { -- CRYING_OVER_ONIONS
            name = "Crying Over Onions",
            steps = {
                {
                    text = "Collect the Bouncer Club Kohlo-Lakolo still owes you for the last case, zone once, then come back and he opens this one. Level 5 or better.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 5 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Hear Honoi-Gomoi out in Windurst Waters.",
                    pos  = "Windurst Waters (!pos -195 -11 -120)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade Honoi-Gomoi a Star Spinel and he sets it into a Star Necklace. Nanaa Mihgo has her own word on the matter if you look her up first.",
                    pos  = "Windurst Waters (!pos -195 -11 -120)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Show the necklace to Kohlo-Lakolo.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Go back to Honoi-Gomoi.",
                    pos  = "Windurst Waters (!pos -195 -11 -120)",
                },
            },
        },
        [77] = { -- WILD_CARD
            name = "Wild Card",
            steps = {
                {
                    text = "Take the case from Honoi-Gomoi in Windurst Waters. Level 5 or better.",
                    pos  = "Windurst Waters (!pos -195 -11 -120)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 5 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Report to Kohlo-Lakolo in Port Windurst.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Go up to the House of the Hero in Windurst Walls and meet whoever is waiting there.",
                    pos  = "Windurst Walls",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Open a Treasure Coffer in Toraimarai Canal for the Joker Card.",
                    pos  = "Toraimarai Canal",
                    -- The card is spent when it is handed over, so the branch
                    -- that survives that (Prog 4) rides alongside it.
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { var = 'Prog', gte = 2 },
                                    { ki = 264 }, -- JOKER_CARD
                                },
                            },
                            { var = 'Prog', gte = 4 },
                        },
                    },
                },
                {
                    text = "Take the card back to whoever sent you for it: the House of the Hero, or Apururu in Windurst Woods.",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Report to Honoi-Gomoi.",
                    pos  = "Windurst Waters (!pos -195 -11 -120)",
                },
            },
        },
        [78] = { -- THE_PROMISE
            name = "The Promise",
            steps = {
                {
                    text = "Take the last case from Kohlo-Lakolo in Port Windurst. Level 5 or better.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 5 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Ask Chamama in Windurst Waters what she can run off for the brigade.",
                    pos  = "Windurst Waters",
                    done = { var = 'Chamama', gte = 1 },
                },
                {
                    text = "Trade Chamama a Shoalweed and she makes the Invisible Man Sticker.",
                    pos  = "Windurst Waters",
                    done = {
                        allOf = {
                            { var = 'Chamama', gte = 1 },
                            { ki = 271 }, -- INVISIBLE_MAN_STICKER
                        },
                    },
                },
                {
                    text = "Take the sticker to Kohlo-Lakolo.",
                    pos  = "Port Windurst (!pos -26 -6 190)",
                },
            },
        },
        [79] = { name = "Nothing Matters" }, -- NOTHING_MATTERS (name from enum; no script header found)
        [80] = { -- TORAIMARAI_TURMOIL
            name = "Toraimarai Turmoil",
            repeatable = true,
            steps = {
                {
                    text = "Take the collecting job from Ohbiru-Dohbiru; he issues a Rhinostery Certificate with it.",
                    pos  = "Windurst Waters (!pos 23 -5 -193)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 6 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Collect three Starmite Shells.",
                    done = { item = 906, qty = 3 }, -- STARMITE_SHELL
                },
                {
                    text = "Trade all three to Ohbiru-Dohbiru. He will take another three whenever you have them.",
                    pos  = "Windurst Waters (!pos 23 -5 -193)",
                },
            },
        },
        [81] = { -- THE_PUPPET_MASTER
            name = "The Puppet Master",
            steps = {
                {
                    text = "Ask at the House of the Hero in Windurst Walls about summoner's work. Summoner as main job, at the level this server sets for artifact quests.",
                    pos  = "Windurst Walls (!pos -26 -13 260)",
                    done = { status = 1 },
                },
                {
                    text = "Find Juroro in Port Bastok; he hands over an Earth Pendulum.",
                    pos  = "Port Bastok (!pos 32 7 -41)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Carry the pendulum into the Cloister of Tremors and face what answers it.",
                    pos  = "Cloister of Tremors",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Go back to Juroro with the news.",
                    pos  = "Port Bastok (!pos 32 7 -41)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Report to Koru-Moru in Windurst Walls.",
                    pos  = "Windurst Walls (!pos -120 -6 124)",
                },
            },
        },
        [82] = { name = "Class Reunion" }, -- CLASS_REUNION (name from enum; no script header found)
        [83] = { name = "Carbuncle Debacle" }, -- CARBUNCLE_DEBACLE (name from enum; no script header found)
        [84] = { name = "Eco Warrior" }, -- ECO_WARRIOR (name from enum; no script header found)
        [85] = { -- FROM_SAPLINGS_GROW
            name = "From Saplings Grow",
            steps = {
                {
                    text = "Take the weapon trial from Perih Vashai: archery skill 250, a body that can wield the Bow of Trials, and no training guide already in hand.",
                    pos  = "Windurst Woods (!pos 117 -3 92)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Bow of Trials until Perih Vashai will take it back, then follow her map to Cape Teriggan: the ??? there draws out Stolas, and it gives up the Annals of Truth.",
                    pos  = "Cape Teriggan (!pos -157 -8 198)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Perih Vashai to learn Empyreal Arrow.",
                    pos  = "Windurst Woods (!pos 117 -3 92)",
                },
            },
        },
        [86] = { -- ORASTERY_WOES
            name = "Orastery Woes",
            steps = {
                {
                    text = "Take the weapon trial from Kuroido-Moido: club skill 230, a body that can wield the Club of Trials, and no training guide already in hand.",
                    pos  = "Port Windurst (!pos -112 -4 102)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Club of Trials until Kuroido-Moido will take it back, then follow his map to Ro'Maeve: the ??? there draws out Eldhrimnir, and it gives up the Annals of Truth.",
                    pos  = "Ro'Maeve (!pos 197 -8 -27)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Kuroido-Moido to learn Black Halo.",
                    pos  = "Port Windurst (!pos -112 -4 102)",
                },
            },
        },
        [87] = { -- BLOOD_AND_GLORY
            name = "Blood and Glory",
            steps = {
                {
                    text = "Take the weapon trial from Shantotto: staff skill 230, a body that can wield the Pole of Trials, and no training guide already in hand.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Pole of Trials until Shantotto will take it back, then follow her map to Ifrit's Cauldron: the ??? there draws out Cailleach Bheur, and it gives up the Annals of Truth.",
                    pos  = "Ifrit's Cauldron (!pos 119 20 144)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Shantotto to learn Retribution.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                },
            },
        },
        [88] = { name = "Escort for Hire" }, -- ESCORT_FOR_HIRE (name from enum; no script header found)
        [89] = { name = "A Discerning Eye" }, -- A_DISCERNING_EYE (name from enum; no script header found)
        [90] = { name = "Tuning in" }, -- TUNING_IN (name from enum; no script header found)
        [91] = { name = "Tuning Out" }, -- TUNING_OUT (name from enum; no script header found)
        -- Gated: its whole middle leg is in Bibiki Bay and Boneyard Gully,
        -- both in content_gate's ENABLE_COP bucket. Authored and parked.
        [92] = { -- ONE_GOOD_DEED
            name = "One Good Deed?",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the errand from Chipmy-Popmy in Port Windurst.",
                    pos  = "Port Windurst (!pos -181 -2 73)",
                    done = {
                        allOf = {
                            { status = 1 },
                            { fame = { area = 2, level = 5 } }, -- WINDURST
                        },
                    },
                },
                {
                    text = "Cross to Bibiki Bay, clear the Peerifool at the marker there, and take the Deed to Purgonorgo Isle.",
                    pos  = "Bibiki Bay (!pos -321 -2 -738)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Show the deed to Chipmy-Popmy.",
                    pos  = "Port Windurst (!pos -181 -2 73)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Go down into Boneyard Gully and see what the deed is really worth.",
                    pos  = "Boneyard Gully",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Report back to Chipmy-Popmy.",
                    pos  = "Port Windurst (!pos -181 -2 73)",
                },
            },
        },
        -- Gated: the accept check demands a completed CoP mission (Darkness
        -- Named) and the fight is in The Shrouded Maw. Authored and parked.
        [93] = { -- WAKING_DREAMS
            name = "Waking Dreams",
            gated = 'ENABLE_COP',
            repeatable = true,
            steps = {
                {
                    text = "Take the Vial of Dream Incense from Kerutoto in Windurst Waters.",
                    pos  = "Windurst Waters (!pos 13 -5 -157)",
                    done = { status = 1 },
                },
                {
                    text = "Burn the incense in The Shrouded Maw and beat what comes out of the dream; it leaves the Whisper of Dreams behind.",
                    pos  = "The Shrouded Maw",
                    done = { ki = 327 }, -- WHISPER_OF_DREAMS
                },
                {
                    text = "Take the Whisper of Dreams back to Kerutoto and pick your reward.",
                    pos  = "Windurst Waters (!pos 13 -5 -157)",
                },
            },
        },
        -- Gated: the accept check reads ENABLE_TOAU directly. Authored and
        -- parked, same as San d'Oria's and Bastok's in Phase 3.
        [94] = { -- LURE_OF_THE_WILDCAT
            name = "Lure of the Wildcat (Windurst)",
            gated = 'ENABLE_TOAU',
            steps = {
                {
                    text = "Take the Green Sentinel Badge from Ibwam.",
                    pos  = "Windurst Woods (!pos -25 1 -60)",
                    done = { status = 1 },
                },
                {
                    text = "Show the badge to all twenty on the list: five each in Windurst Woods, Windurst Walls, Windurst Waters and Port Windurst.",
                    done = { var = 'Prog', gte = 1048575 },
                },
                {
                    text = "Report back to Ibwam.",
                    pos  = "Windurst Woods (!pos -25 1 -60)",
                },
            },
        },
        [95] = { name = "Babban Ny Mheillea" }, -- BABBAN_NY_MHEILLEA (name from enum; no script header found)
        [96] = { name = "Trust Windurst" }, -- TRUST_WINDURST (name from enum; no script header found)
    },
}
