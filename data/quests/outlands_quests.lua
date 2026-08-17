-- dwtracker data -- Outlands quests. Names generated Phase 0
-- (tools/dwtracker_names.py); steps hand-authored in Phase 5 from
-- scripts/quests/outlands/ as ground truth. Entries that stay name-only are
-- ids the enum lists but no script implements on this server: they cannot be
-- accepted, so they can never render a step. Step text describes the state
-- machine the script encodes and nothing else -- where an item comes from a
-- drop table, a shop or a craft rather than from the quest itself, the step
-- names the item and stops there, because those sources are outside what the
-- scripts prove. Pure data: numeric ids and display strings only, no xi.*,
-- no functions (DWTRACKER_FORMAT.md decisions T2/§3-4). Loaded
-- byte-identically by the server module and the dwtracker addon; both hash
-- these bytes, so an edit that reaches only one side makes the addon refuse
-- step rendering for this area until the copies agree again.
-- tools/dwtracker_lint.py must pass before edits ship.
return {
    kind = 'quests',
    log = 5,
    area = 'outlands_quests',
    label = "Outlands",
    entries = {
        [1] = { name = "The Firebloom Tree" }, -- THE_FIREBLOOM_TREE (name from enum; no script header found)
        [2] = { name = "Greetings to the Guardian" }, -- GREETINGS_TO_THE_GUARDIAN (name from enum; no script header found)
        [3] = { -- A_QUESTION_OF_TASTE
            name = "A Question of Taste",
            repeatable = true,
            steps = {
                {
                    text = "Take the errand from Etteh Sulaej in Kazham. He hands over the letter at Windurst fame 6.",
                    pos  = "Kazham (!pos 98 -15 -113)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 6 } }, -- WINDURST
                    } },
                },
                {
                    text = "Carry the letter to Angelica in Windurst Waters. She only answers someone who has finished A Pose by Any Other Name and zoned since.",
                    pos  = "Windurst Waters (!pos -64 -9 -9)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Bring Angelica's reply back to Etteh Sulaej in Kazham.",
                    pos  = "Kazham (!pos 98 -15 -113)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Offer the painting at the stone picture frame in the Temple of Uggalepih and defeat the Trompe l'Oeil it calls out. The frame will not do it again for fifteen minutes.",
                    pos  = "Temple of Uggalepih (!pos 79 0 -36)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Check the stone picture frame again to take down what is left of the painting.",
                    pos  = "Temple of Uggalepih (!pos 79 0 -36)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Show the ruined painting to Etteh Sulaej in Kazham.",
                    pos  = "Kazham (!pos 98 -15 -113)",
                },
            },
        },
        [4] = { -- EVERYONES_GRUDGING
            name = "Everyone's Grudging",
            steps = {
                {
                    text = "Take the job from Jakoh Wahcondalo in Kazham. He offers it only at Windurst fame 7, to someone who has finished A Question of Taste and is carrying the Den of Rancor's curse.",
                    pos  = "Kazham (!pos 98 -15 -113)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 7 } }, -- WINDURST
                    } },
                },
                {
                    text = "Go down into the Den of Rancor and destroy a Rancor Torch -- putting one out is what lifts the curse.",
                    pos  = "Den of Rancor",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report back to Jakoh Wahcondalo in Kazham.",
                    pos  = "Kazham (!pos 98 -15 -113)",
                },
            },
        },
        [6] = { -- YOU_CALL_THAT_A_KNIFE
            name = "You Call That a Knife",
            steps = {
                {
                    text = "Trade a Sandfish to Mhebi Juhbily in Kazham at Windurst fame 6, then agree to fetch her a knife worth the name.",
                    pos  = "Kazham (!pos 40 -11 -159)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 6 } }, -- WINDURST
                    } },
                },
                {
                    text = "Ask Vah Keshura in Kazham where a knife like that comes from.",
                    pos  = "Kazham (!pos 30 -8 -105)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade a Tonberry Board to Chef Nonberry in the Temple of Uggalepih for Nonberry's Knife. Trading him anything else draws the temple's cooks out instead.",
                    pos  = "Temple of Uggalepih (!pos -136 0 -91)",
                    done = { allOf = {
                        { var = 'Prog', gte = 2 },
                        { ki = 253 }, -- NONBERRYS_KNIFE
                    } },
                },
                {
                    text = "Take Nonberry's Knife back to Mhebi Juhbily in Kazham.",
                    pos  = "Kazham (!pos 40 -11 -159)",
                },
            },
        },
        [7] = { name = "Missionary Man" }, -- MISSIONARY_MAN (name from enum; no script header found)
        [8] = { name = "Gullibles Travels" }, -- GULLIBLES_TRAVELS (name from enum; no script header found)
        [9] = { name = "Even More Gullibles Travels" }, -- EVEN_MORE_GULLIBLES_TRAVELS (name from enum; no script header found)
        [10] = { name = "Personal Hygiene" }, -- PERSONAL_HYGIENE (name from enum; no script header found)
        [11] = { name = "The Opo Opo and I" }, -- THE_OPO_OPO_AND_I (name from enum; no script header found)
        [12] = { name = "Trial by Fire" }, -- TRIAL_BY_FIRE (name from enum; no script header found)
        [13] = { -- CLOAK_AND_DAGGER
            name = "Cloak and Dagger",
            steps = {
                {
                    text = "Take the weapon trial from Jakoh Wahcondalo: dagger skill 230, a body that can wield the Dagger of Trials, and no training guide already in hand.",
                    pos  = "Kazham (!pos 101 -16 -115)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Dagger of Trials until Jakoh Wahcondalo will take it back, then follow his map to Gustav Tunnel: the ??? there draws out the Baronial Bat, and it gives up the Annals of Truth.",
                    pos  = "Gustav Tunnel (!pos 52 -1 19)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Jakoh Wahcondalo to learn Evisceration.",
                    pos  = "Kazham (!pos 101 -16 -115)",
                },
            },
        },
        [14] = { name = "A Discerning Eye" }, -- A_DISCERNING_EYE (name from enum; no script header found)
        [15] = { name = "Trial Size Trial by Fire" }, -- TRIAL_SIZE_TRIAL_BY_FIRE (name from enum; no script header found)
        [100] = { name = "Voidwatch Ops Border Crossing" }, -- VOIDWATCH_OPS_BORDER_CROSSING (name from enum; no script header found)
        [101] = { name = "Vw Op 054 Elshimo List" }, -- VW_OP_054_ELSHIMO_LIST (name from enum; no script header found)
        [102] = { name = "Vw Op 101 Detour to Zepwell" }, -- VW_OP_101_DETOUR_TO_ZEPWELL (name from enum; no script header found)
        [103] = { name = "Vw Op 115 Li Telor Variant" }, -- VW_OP_115_LI_TELOR_VARIANT (name from enum; no script header found)
        [104] = { name = "Skyward Ho Voidwatcher" }, -- SKYWARD_HO_VOIDWATCHER (name from enum; no script header found)
        [128] = { name = "The Sahagins Key" }, -- THE_SAHAGINS_KEY (name from enum; no script header found)
        [129] = { -- FORGE_YOUR_DESTINY
            name = "Forge Your Destiny",
            steps = {
                {
                    text = "Ask Jaucribaix in Norg about taking up the samurai's blade. He wants a Lump of Bomb Steel and a Sacred Branch, and will not begin below the advanced-job level.",
                    pos  = "Norg (!pos 91 -7 -8)",
                    done = { status = 1 },
                },
                {
                    text = "Take a Sacred Sprig from Ranemaud in Norg, then trade a Hatchet at the ??? in the Sanctuary of Zi'Tah while carrying the sprig to draw out the Guardian Treant, and defeat it.",
                    pos  = "The Sanctuary of Zi'Tah (!pos 642 -5 -150)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade the Sacred Sprig at that same ??? for the Sacred Branch.",
                    pos  = "The Sanctuary of Zi'Tah (!pos 642 -5 -150)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Take a Lump of Oriental Steel from Aeka in Norg and trade it at the blackened spot in Konschtat Highlands to draw out the Forger; its Bomb Steel and the Sacred Branch go to Jaucribaix together.",
                    pos  = "Konschtat Highlands (!pos -709 2 102)",
                    done = { allOf = {
                        { var = 'Prog', gte = 2 },
                        { var = 'waitTime', gte = 1 },
                    } },
                },
                {
                    text = "Give the forging three Vana'diel days, then speak to Jaucribaix again.",
                    pos  = "Norg (!pos 91 -7 -8)",
                },
            },
        },
        [130] = { name = "Black Market" }, -- BLACK_MARKET (name from enum; no script header found)
        [131] = { name = "Mama Mia" }, -- MAMA_MIA (name from enum; no script header found)
        [132] = { -- STOP_YOUR_WHINING
            name = "Stop Your Whining",
            steps = {
                {
                    text = "Take Washu's empty barrel in Norg. He parts with it at Norg fame 4, and not below level 10.",
                    pos  = "Norg (!pos 49 -6 15)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 5, level = 4 } }, -- NORG
                    } },
                },
                {
                    text = "Fill the barrel at the opo-opo brewing tree in Yhoator Jungle.",
                    pos  = "Yhoator Jungle (!pos -94 -1 22)",
                    done = { ki = 261 }, -- BARREL_OF_OPO_OPO_BREW
                },
                {
                    text = "Carry the full barrel back to Washu in Norg.",
                    pos  = "Norg (!pos 49 -6 15)",
                },
            },
        },
        [133] = { name = "Trial by Water" }, -- TRIAL_BY_WATER (name from enum; no script header found)
        [134] = { name = "Everyones Grudge" }, -- EVERYONES_GRUDGE (name from enum; no script header found)
        -- The script header here claims quest id 135 for BOTH this quest and
        -- The Sahagin's Stash; the code says otherwise, and the code is what
        -- runs (FORMAT §6.11). Phase 0's generator trusted the header and gave
        -- 135 its neighbour's name -- corrected from the enum.
        [135] = { -- SECRET_OF_THE_DAMP_SCROLL
            name = "Secret of the Damp Scroll",
            steps = {
                {
                    text = "Show Shivivi in Norg a Damp Scroll. She will look at it at Norg fame 3, and not below level 10.",
                    pos  = "Norg (!pos 68 -6 -6)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 5, level = 3 } }, -- NORG
                    } },
                },
                {
                    text = "Trade the Damp Scroll to the hot springs in Horlais Peak to bring the writing out.",
                    pos  = "Horlais Peak (!pos 444 -37 -18)",
                },
            },
        },
        [136] = { -- THE_SAHAGINS_STASH
            name = "The Sahagin's Stash",
            steps = {
                {
                    text = "Hear Laisrean out in Norg. He offers the job at Norg fame 4, and not below level 5.",
                    pos  = "Norg (!pos -2 -1 21)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 5, level = 4 } }, -- NORG
                    } },
                },
                {
                    text = "Find the ??? in Sea Serpent Grotto and take the Sea Serpent Statue from it.",
                    pos  = "Sea Serpent Grotto (!pos 295 27 213)",
                    done = { ki = 296 }, -- SEA_SERPENT_STATUE
                },
                {
                    text = "Bring the statue back to Laisrean in Norg.",
                    pos  = "Norg (!pos -2 -1 21)",
                },
            },
        },
        [137] = { name = "Its Not Your Vault" }, -- ITS_NOT_YOUR_VAULT (name from enum; no script header found)
        [138] = { -- LIKE_A_SHINING_SUBLIGAR
            name = "Like Shining Subligars",
            steps = {
                {
                    text = "Hear Heiji out in Norg. He collects Rusty Subligars, and starts talking at Norg fame 3.",
                    pos  = "Norg (!pos -1 -5 25)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 5, level = 3 } }, -- NORG
                    } },
                },
                {
                    text = "Trade Heiji ten Rusty Subligars. He banks part-loads and will tell you the running count whenever you ask.",
                    pos  = "Norg (!pos -1 -5 25)",
                },
            },
        },
        [139] = { -- LIKE_SHINING_LEGGINGS
            name = "Like Shining Leggings",
            steps = {
                {
                    text = "Hear Heizo out in Norg. He collects Rusty Leggings, and starts talking at Norg fame 3.",
                    pos  = "Norg (!pos -1 -5 25)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 5, level = 3 } }, -- NORG
                    } },
                },
                {
                    text = "Trade Heizo ten Rusty Leggings. He banks part-loads and will tell you the running count whenever you ask.",
                    pos  = "Norg (!pos -1 -5 25)",
                },
            },
        },
        [140] = { -- THE_SACRED_KATANA
            name = "The Sacred Katana",
            steps = {
                {
                    text = "Ask Jaucribaix in Norg for a samurai's first commission -- samurai as your main job, Forge Your Destiny finished, and the artifact level reached.",
                    pos  = "Norg (!pos 91 -7 -8)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Sack of Fish Bait at the ??? in the Sanctuary of Zi'Tah to draw out Isonade, defeat it, then check the ??? again for the Handful of Crystal Scales.",
                    pos  = "The Sanctuary of Zi'Tah (!pos -416 0 46)",
                    done = { ki = 453 }, -- HANDFUL_OF_CRYSTAL_SCALES
                },
                {
                    text = "Trade your Mumeito to Jaucribaix with the scales in hand. If the blade is gone, Ranemaud in Norg will part with another for 30,000 gil.",
                    pos  = "Norg (!pos 91 -7 -8)",
                },
            },
        },
        [141] = { -- YOMI_OKURI
            name = "Yomi Okuri",
            steps = {
                {
                    text = "Take the next commission from Jaucribaix in Norg -- samurai as your main job, The Sacred Katana finished, and the second artifact level reached.",
                    pos  = "Norg (!pos 91 -7 -8)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Washu in Norg what the rite needs.",
                    pos  = "Norg (!pos 49 -6 15)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Bring Washu a Hecteyes Eye, a Bastore Sardine, a Slice of Giant Sheep Meat and a Frost Turnip in one trade for his tasty wurst.",
                    pos  = "Norg (!pos 49 -6 15)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Offer the wurst at the ??? in the Labyrinth of Onzozo to draw out Ubume, defeat it, check the ??? again for the Yomotsu Feather, and take the feather to Jaucribaix.",
                    pos  = "Labyrinth of Onzozo (!pos -176 10 -60)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Zone out and back, then speak to Jaucribaix again for the Yomotsu Hirasaka.",
                    pos  = "Norg (!pos 91 -7 -8)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Between 18:00 and 05:00, raise the Hirasaka at the ??? in Valkurm Dunes to call up Doman and Onryo, defeat both, check the ??? again, then return to Jaucribaix.",
                    pos  = "Valkurm Dunes (!pos -767 -4 192)",
                },
            },
        },
        -- Phase 0's generator read this script's header comment, which is a
        -- copy of Yomi Okuri's; the code names A_THIEF_IN_NORG (FORMAT §6.11).
        [142] = { -- A_THIEF_IN_NORG
            name = "A Thief in Norg",
            steps = {
                {
                    text = "Take the last commission from Jaucribaix in Norg -- samurai as your main job, Yomi Okuri finished, and the third artifact level reached.",
                    pos  = "Norg (!pos 91 -7 -8)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Sanosuke in Port Jeuno about the stolen helm.",
                    pos  = "Port Jeuno (!pos -63 7 0)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Follow the trail to Phoochuchu in Mhaura.",
                    pos  = "Mhaura (!pos -4 -4 69)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Examine the door Phoochuchu described in Bastok Mines.",
                    pos  = "Bastok Mines (!pos 70 7 2)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Enter Waughroon Shrine and watch what plays out there.",
                    pos  = "Waughroon Shrine",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Report to Jaucribaix in Norg; he supplies the Banishing Charm.",
                    pos  = "Norg (!pos 91 -7 -8)",
                    done = { var = 'Prog', gte = 6 },
                },
                {
                    text = "Take the charm into the burning circle in Waughroon Shrine and win the fight for the Charred Helm.",
                    pos  = "Waughroon Shrine",
                    done = { var = 'Prog', gte = 7 },
                },
                {
                    text = "Show the Charred Helm to Jaucribaix in Norg.",
                    pos  = "Norg (!pos 91 -7 -8)",
                    done = { var = 'Prog', gte = 8 },
                },
                {
                    text = "Trade Jaucribaix a Spool of Gold Thread with the Charred Helm still in hand, then zone out and back and speak to him once more.",
                    pos  = "Norg (!pos 91 -7 -8)",
                },
            },
        },
        [143] = { name = "Twenty in Pirate Years" }, -- TWENTY_IN_PIRATE_YEARS (name from enum; no script header found)
        [144] = { name = "I Ll Take the Big Box" }, -- I_LL_TAKE_THE_BIG_BOX (name from enum; no script header found)
        [145] = { name = "True Will" }, -- TRUE_WILL (name from enum; no script header found)
        [146] = { -- THE_POTENTIAL_WITHIN
            name = "The Potential Within",
            steps = {
                {
                    text = "Take the weapon trial from Jaucribaix: great katana skill 250, a body that can wield the Tachi of Trials, and no training guide already in hand.",
                    pos  = "Norg (!pos 91 -7 -8)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Tachi of Trials until Jaucribaix will take it back, then follow his map to Kuftal Tunnel: the ??? there draws out Kettenkaefer, and it gives up the Annals of Truth.",
                    pos  = "Kuftal Tunnel (!pos 200 11 99)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Jaucribaix to learn Tachi: Kasha.",
                    pos  = "Norg (!pos 91 -7 -8)",
                },
            },
        },
        [147] = { -- BUGI_SODEN
            name = "Bugi Soden",
            steps = {
                {
                    text = "Take the weapon trial from Ryoma: katana skill 250, a body that can wield the Kodachi of Trials, and no training guide already in hand.",
                    pos  = "Norg (!pos -23 0 -9)",
                    done = { status = 1 },
                },
                {
                    text = "Land weapon skills with the Kodachi of Trials until Ryoma will take it back, then follow his map to the Labyrinth of Onzozo: the ??? there draws out Megapod Megalops, which gives up the Annals of Truth.",
                    pos  = "Labyrinth of Onzozo (!pos 110 15 162)",
                    done = { ki = 345 }, -- ANNALS_OF_TRUTH
                },
                {
                    text = "Carry the Annals of Truth back to Ryoma to learn Blade: Ku.",
                    pos  = "Norg (!pos -23 0 -9)",
                },
            },
        },
        [148] = { name = "Trial Size Trial by Water" }, -- TRIAL_SIZE_TRIAL_BY_WATER (name from enum; no script header found)
        [149] = { name = "An Undying Pledge" }, -- AN_UNDYING_PLEDGE (name from enum; no script header found)
        -- The three headstone quests have no accept section of their own: the
        -- Zilart mission Headstone Pilgrimage force-accepts them at the
        -- headstone (missions/rotz/05, player:addQuest). Their first step
        -- therefore says how the player got here rather than naming an NPC.
        [160] = { -- WRATH_OF_THE_OPO_OPOS
            name = "Wrath of the Opo-Opos",
            steps = {
                {
                    text = "Nobody offers this one. The cermet headstone in Yuhtunga Jungle opens it during the Zilart mission Headstone Pilgrimage, on the visit that hands over the Fire Fragment.",
                    pos  = "Yuhtunga Jungle (!pos 491 20 301)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Garnet to that same cermet headstone.",
                    pos  = "Yuhtunga Jungle (!pos 491 20 301)",
                },
            },
        },
        [161] = { -- WANDERING_SOULS
            name = "Wandering Souls",
            steps = {
                {
                    text = "Nobody offers this one. The cermet headstone in Cape Teriggan opens it during the Zilart mission Headstone Pilgrimage, on the visit that hands over the Wind Fragment.",
                    pos  = "Cape Teriggan (!pos -107 -8 450)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Rain Lily to that same cermet headstone.",
                    pos  = "Cape Teriggan (!pos -107 -8 450)",
                },
            },
        },
        [162] = { -- SOUL_SEARCHING
            name = "Soul Searching",
            steps = {
                {
                    text = "Nobody offers this one. The cermet headstone in the Sanctuary of Zi'Tah opens it during the Zilart mission Headstone Pilgrimage, on the visit that hands over the Light Fragment.",
                    pos  = "The Sanctuary of Zi'Tah (!pos 235 0 280)",
                    done = { status = 1 },
                },
                {
                    text = "Return to that headstone carrying the Prismatic Fragment -- the Zilart mission The Chamber of Oracles is what awards it.",
                    pos  = "The Sanctuary of Zi'Tah (!pos 235 0 280)",
                },
            },
        },
        [163] = { -- DIVINE_MIGHT
            name = "Divine Might",
            steps = {
                {
                    text = "Read the ??? in the Shrine of Ru'Avitau while the Zilart mission Ark Angels is underway, or with one of its Shard key items already in hand.",
                    pos  = "The Shrine of Ru'Avitau (!pos -40 0 -151)",
                    done = { status = 1 },
                },
                {
                    text = "On a full moon between 18:00 and 06:00, trade a Bottle of Illuminink and a Sheet of Parchment to Qu'Hau Spring in Ro'Maeve for an Ark Pentasphere, then win the fight it opens in the Laloff Amphitheater.",
                    pos  = "Ro'Maeve (!pos 0 -29 64)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Return to the ??? in the Shrine of Ru'Avitau and choose your earring.",
                    pos  = "The Shrine of Ru'Avitau (!pos -40 0 -151)",
                },
            },
        },
        [164] = { -- DIVINE_MIGHT_REPEAT
            name = "Divine Might (Repeat)",
            repeatable = true,
            steps = {
                {
                    text = "Read the ??? in the Shrine of Ru'Avitau again. It offers a second run only to someone who has finished Divine Might and holds fewer of its earrings than this server allows.",
                    pos  = "The Shrine of Ru'Avitau (!pos -40 0 -151)",
                    done = { status = 1 },
                },
                {
                    text = "On a full moon between 18:00 and 06:00, trade a Chunk of Light Ore to Qu'Hau Spring in Ro'Maeve for the Moonlight Ore.",
                    pos  = "Ro'Maeve (!pos 0 -29 64)",
                    done = { anyOf = {
                        { ki = 761 }, -- MOONLIGHT_ORE
                        { var = 'Prog', gte = 1 },
                    } },
                },
                {
                    text = "Trade the same spring a Bottle of Illuminink and a Sheet of Parchment for an Ark Pentasphere, then win the Laloff Amphitheater fight with the Moonlight Ore in hand.",
                    pos  = "Ro'Maeve (!pos 0 -29 64)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Return to the ??? in the Shrine of Ru'Avitau and choose another earring.",
                    pos  = "The Shrine of Ru'Avitau (!pos -40 0 -151)",
                },
            },
        },
        [165] = { -- OPEN_SESAME
            name = "Open Sesame",
            steps = {
                {
                    text = "Hear Lokpix out in the Eastern Altepa Desert and agree to help.",
                    pos  = "Eastern Altepa Desert (!pos -61 3 224)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Lokpix a Tremorstone together with either a Meteorite, a Soil Gem, or twelve Soil Geodes.",
                    pos  = "Eastern Altepa Desert (!pos -61 3 224)",
                },
            },
        },
        [192] = { name = "Dont Forget the Antidote" }, -- DONT_FORGET_THE_ANTIDOTE (name from enum; no script header found)
        [193] = { -- THE_MISSING_PIECE
            name = "The Missing Piece",
            steps = {
                {
                    text = "Take the job from Alfesar in Rabao. He asks at Selbina/Rabao fame 4, and not below level 10.",
                    pos  = "Rabao (!pos 23 8 38)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 4, level = 4 } }, -- SELBINA_RABAO
                    } },
                },
                {
                    text = "Find the ??? in the Quicksand Caves for the Ancient Tablet Fragment. It moves to one of five spots each time it is used.",
                    pos  = "Quicksand Caves",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take the fragment back to Alfesar in Rabao; he trades it for the Tablet of Ancient Magic and a letter.",
                    pos  = "Rabao (!pos 23 8 38)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Carry the tablet and the letter to Charlaimagnat in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos 124 6 111)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Give him a minute to work through it, then speak to Charlaimagnat again.",
                    pos  = "Northern San d'Oria (!pos 124 6 111)",
                },
            },
        },
        [194] = { name = "Trial by Wind" }, -- TRIAL_BY_WIND (name from enum; no script header found)
        [195] = { -- THE_KUFTAL_TOUR
            name = "The Kuftal Tour",
            steps = {
                {
                    text = "Take the tour job from Datta in Rabao. He asks at Selbina/Rabao fame 3, and only of someone who has finished The Gustaberg Tour.",
                    pos  = "Rabao (!pos -43 -10 -2)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 4, level = 3 } }, -- SELBINA_RABAO
                    } },
                },
                {
                    text = "Bring a party to the ??? deep in Kuftal Tunnel: at least one other member, every one of them level 40 or under, and all within fifteen yalms of you.",
                    pos  = "Kuftal Tunnel (!pos -29 -22 -183)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report back to Datta in Rabao.",
                    pos  = "Rabao (!pos -43 -10 -2)",
                },
            },
        },
        [196] = { name = "The Immortal Lu Shang" }, -- THE_IMMORTAL_LU_SHANG (name from enum; no script header found)
        [197] = { name = "Trial Size Trial by Wind" }, -- TRIAL_SIZE_TRIAL_BY_WIND (name from enum; no script header found)
        -- Gated: the leg from Abelard runs through Lufaise Meadows, which is
        -- in content_gate's ENABLE_COP bucket. Authored now, parked until the
        -- flag opens (Phase 4's gate rule).
        [199] = { -- CHASING_DREAMS
            name = "Chasing Dreams",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Hear Rudolfo out in Rabao.",
                    pos  = "Rabao (!pos 119 8 52)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Zoriboh in Rabao what he makes of it.",
                    pos  = "Rabao (!pos -43 8 82)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take the question to Sohyon in Norg.",
                    pos  = "Norg (!pos 49 -6 14)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Ask Washu in Norg for his flask.",
                    pos  = "Norg (!pos 49 -6 14)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Fill the flask at all four giant clams in Korroloka Tunnel. Each one pours only once, and the flask is not full until every one of them has.",
                    pos  = "Korroloka Tunnel",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Take the clam water to Sohyon in Norg for the storeroom key, then open the storeroom for Gimb.",
                    pos  = "Norg (!pos -6 -1 -43)",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Carry what came out of the storeroom to Kagetora in Port Bastok.",
                    pos  = "Port Bastok (!pos -95 -2 29)",
                    done = { var = 'Prog', gte = 6 },
                },
                {
                    text = "Trade five Eastern Gems to the patient wheel in Port Bastok.",
                    pos  = "Port Bastok (!pos -106 5 51)",
                    done = { var = 'Prog', gte = 7 },
                },
                {
                    text = "Speak to Abelard in Selbina.",
                    pos  = "Selbina (!pos -52 -11 -12)",
                    done = { var = 'Prog', gte = 8 },
                },
                {
                    text = "Cross into Lufaise Meadows.",
                    pos  = "Lufaise Meadows",
                    done = { var = 'Prog', gte = 9 },
                },
                {
                    text = "Return to Zoriboh in Rabao.",
                    pos  = "Rabao (!pos -43 8 82)",
                },
            },
        },
        [200] = { name = "The Search for Goldmane" }, -- THE_SEARCH_FOR_GOLDMANE (name from enum; no script header found)
        [201] = { name = "Indomitable Spirit" }, -- INDOMITABLE_SPIRIT (name from enum; no script header found)
    },
}
