-- dwtracker data -- Other Areas quests. Names generated Phase 0
-- (tools/dwtracker_names.py); steps hand-authored in Phase 5 from
-- scripts/quests/otherAreas/ as ground truth. Entries that stay name-only
-- are ids the enum lists but no script implements on this server: they
-- cannot be accepted, so they can never render a step. Step text describes
-- the state machine the script encodes and nothing else -- where an item
-- comes from a drop table, a shop or a craft rather than from the quest
-- itself, the step names the item and stops there, because those sources
-- are outside what the scripts prove. Pure data: numeric ids and display
-- strings only, no xi.*, no functions (DWTRACKER_FORMAT.md decisions
-- T2/§3-4). Loaded byte-identically by the server module and the dwtracker
-- addon; both hash these bytes, so an edit that reaches only one side makes
-- the addon refuse step rendering for this area until the copies agree
-- again. tools/dwtracker_lint.py must pass before edits ship.
return {
    kind = 'quests',
    log = 4,
    area = 'otherareas_quests',
    label = "Other Areas",
    entries = {
        -- Rycharde's seven-part chain. Each part waits a fixed number of
        -- Vana'diel days after the last one finished, tracked in the PREVIOUS
        -- quest's DayCompleted var and cleared when the next is accepted --
        -- so the wait belongs to the accept step's wording, not a predicate.
        [0] = { -- RYCHARDE_THE_CHEF
            name = "Rycharde the Chef",
            steps = {
                {
                    text = "Talk your way into the job in Mhaura: ask Rycharde for work, hear Take out about him, then take the errand when Rycharde offers it.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Rycharde two Slices of Dhalmel Meat in one go. One at a time is not enough.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                },
            },
        },
        [1] = { -- WAY_OF_THE_COOK
            name = "Way of the Cook",
            steps = {
                {
                    text = "Take the next job from Rycharde in Mhaura. He waits eight Vana'diel days after Rycharde the Chef, and asks Windurst fame 3.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 3 } }, -- WINDURST
                    } },
                },
                {
                    text = "Trade Rycharde a Slice of Dhalmel Meat and a Beehive Chip together. Inside three Vana'diel days pays 1,500 gil; later still finishes it, for 1,000.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                },
            },
        },
        [2] = { -- UNENDING_CHASE
            name = "Unending Chase",
            steps = {
                {
                    text = "Take the next job from Rycharde in Mhaura. He waits seven Vana'diel days after Way of the Cook, and asks Windurst fame 3.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 3 } }, -- WINDURST
                    } },
                },
                {
                    text = "Trade Rycharde a Puffball. Nothing is timed on this one.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                },
            },
        },
        [3] = { -- HIS_NAME_IS_VALGEIR
            name = "His Name is Valgeir",
            steps = {
                {
                    text = "Take the delivery from Rycharde in Mhaura -- two Vana'diel days after Unending Chase, at Windurst fame 3. He hands over an Aragoneu Pizza.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 3 } }, -- WINDURST
                    } },
                },
                {
                    text = "Carry the pizza to Valgeir in Selbina, then report back to Rycharde. Felisa on the Mhaura dock will ferry you across free once while you are still holding it.",
                    pos  = "Selbina (!pos 57 -15 20)",
                },
            },
        },
        [4] = { -- EXPERTISE
            name = "Expertise",
            steps = {
                {
                    text = "Take this one from Take rather than Rycharde -- eight Vana'diel days after His Name is Valgeir, at Windurst fame 3.",
                    pos  = "Mhaura (!pos 20 -8 69)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 3 } }, -- WINDURST
                    } },
                },
                {
                    text = "Ask Valgeir in Selbina what he needs for it.",
                    pos  = "Selbina (!pos 57 -15 20)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade Valgeir a Scream Fungus and a Slice of Land Crab Meat together.",
                    pos  = "Selbina (!pos 57 -15 20)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Give him a Vana'diel day to cook, then collect the Land Crab Bisque from Valgeir.",
                    pos  = "Selbina (!pos 57 -15 20)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Bring the bisque back to Take in Mhaura.",
                    pos  = "Mhaura (!pos 20 -8 69)",
                },
            },
        },
        [5] = { -- THE_CLUE
            name = "The Clue",
            steps = {
                {
                    text = "Take the next job from Rycharde in Mhaura. He waits seven Vana'diel days after Expertise, and this one asks Windurst fame 5.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 5 } }, -- WINDURST
                    } },
                },
                {
                    text = "Trade Rycharde four Crawler Eggs in one go. Fewer than four he will hand straight back.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                },
            },
        },
        [6] = { -- THE_BASICS
            name = "The Basics",
            steps = {
                {
                    text = "Take the last of Rycharde's jobs in Mhaura -- seven Vana'diel days after The Clue, at Windurst fame 5. He hands over a Mhauran Couscous.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 5 } }, -- WINDURST
                    } },
                },
                {
                    text = "Deliver the couscous to Valgeir in Selbina; he sends you back with a Baked Popoto.",
                    pos  = "Selbina (!pos 57 -15 20)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Trade the Baked Popoto to Rycharde in Mhaura.",
                    pos  = "Mhaura (!pos 17 -16 88)",
                },
            },
        },
        [7] = { name = "Orlandos Antiques" }, -- ORLANDOS_ANTIQUES (name from enum; no script header found)
        [8] = { -- THE_SAND_CHARM
            name = "The Sand Charm",
            steps = {
                {
                    text = "Work the story out in Mhaura before it becomes a quest: hear Blandine out, ask Zexu about the pirates, go back to Blandine, then take the job from Celestina. Windurst fame 2.",
                    pos  = "Mhaura (!pos -37 -16 75)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 2, level = 2 } }, -- WINDURST
                    } },
                },
                {
                    text = "Trade a Sand Charm to Celestina in Mhaura.",
                    pos  = "Mhaura (!pos -37 -16 75)",
                },
            },
        },
        [9] = { name = "A Potters Preference" }, -- A_POTTERS_PREFERENCE (name from enum; no script header found)
        [10] = { name = "The Old Lady" }, -- THE_OLD_LADY (name from enum; no script header found)
        [11] = { name = "Fishermans Heart" }, -- FISHERMANS_HEART (name from enum; no script header found)
        [16] = { name = "Donate to Recycling" }, -- DONATE_TO_RECYCLING (name from enum; no script header found)
        [17] = { -- UNDER_THE_SEA
            name = "Under the Sea",
            steps = {
                {
                    text = "Hear Yaya out in Selbina. She only brings it up at Selbina/Rabao fame 2.",
                    pos  = "Selbina (!pos -18 -2 -14)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 4, level = 2 } }, -- SELBINA_RABAO
                    } },
                },
                {
                    text = "Ask Oswald in Selbina what he lost.",
                    pos  = "Selbina (!pos 47 -15 7)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Ask Jimaida in Selbina about it.",
                    pos  = "Selbina (!pos -17 -2 -18)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Take the question to Zaldon, Selbina's fishmonger.",
                    pos  = "Selbina (!pos -11 -7 -6)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Trade Zaldon a Fat Greedie so he can cut it open. The ring is inside about one fish in five, so bring more than one.",
                    pos  = "Selbina (!pos -11 -7 -6)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Return the Etched Ring to Oswald in Selbina.",
                    pos  = "Selbina (!pos 47 -15 7)",
                },
            },
        },
        [18] = { name = "Only the Best" }, -- ONLY_THE_BEST (name from enum; no script header found)
        -- The tally of monuments already handed in lives in an UNPREFIXED
        -- charVar ([EF]MonumentBitmask / [EF]MonumentCount), and the quest's
        -- own vars are bracket-named, so neither is readable by the DSL's var
        -- atom. The count therefore rides the step wording -- FORMAT §6.8.1's
        -- shape, for a different reason.
        [19] = { -- AN_EXPLORERS_FOOTSTEPS
            name = "An Explorer's Footsteps",
            steps = {
                {
                    text = "Take a Lump of Selbina Clay from Abelard in Selbina. He names one of the seventeen stone monuments he would like a rubbing from.",
                    pos  = "Selbina (!pos -52 -11 -12)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the clay to a stone monument in the field, then bring the Clay Tablet back to Abelard for another lump. He takes the seventeen in any order, remembers the ones already in, and finishes when all are.",
                    pos  = "Selbina (!pos -52 -11 -12)",
                },
            },
        },
        [20] = { name = "Cargo" }, -- CARGO (name from enum; no script header found)
        [21] = { -- THE_GIFT
            name = "The Gift",
            steps = {
                {
                    text = "Hear Oswald out in Selbina. He asks once Under the Sea is finished and The Sand Charm is at least accepted.",
                    pos  = "Selbina (!pos 47 -15 7)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Danceshroom to Oswald in Selbina.",
                    pos  = "Selbina (!pos 47 -15 7)",
                },
            },
        },
        [22] = { -- THE_REAL_GIFT
            name = "The Real Gift",
            steps = {
                {
                    text = "Hear Oswald out again in Selbina. This one waits for The Sand Charm to be finished too.",
                    pos  = "Selbina (!pos 47 -15 7)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Shall Shell to Oswald in Selbina.",
                    pos  = "Selbina (!pos 47 -15 7)",
                },
            },
        },
        [23] = { -- THE_RESCUE
            name = "The Rescue",
            steps = {
                {
                    text = "Take the job from Thunder Hawk in Selbina. Selbina/Rabao fame 1.",
                    pos  = "Selbina (!pos -58 -10 6)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 4, level = 1 } }, -- SELBINA_RABAO
                    } },
                },
                {
                    text = "The cell in Beadeaux is locked and a Quadav holds the key. Trade a Quadav Charm to the door for the Trader's Sack.",
                    pos  = "Beadeaux (!pos 56 0 -23)",
                    done = { ki = 94 }, -- TRADERS_SACK
                },
                {
                    text = "Carry the sack back to Thunder Hawk in Selbina.",
                    pos  = "Selbina (!pos -58 -10 6)",
                },
            },
        },
        [24] = { name = "Elder Memories" }, -- ELDER_MEMORIES (name from enum; no script header found)
        [25] = { -- TEST_MY_METTLE
            name = "Test My Mettle",
            repeatable = true,
            steps = {
                {
                    text = "Take Devean's wager in Selbina -- level 10, rank 2 at home, Selbina/Rabao fame 2, one attempt a day. You pick the stake and the deadline; a tighter deadline pays more.",
                    pos  = "Selbina (!pos 39 -14 40)",
                    done = { allOf = {
                        { status = 1 },
                        { fame = { area = 4, level = 2 } }, -- SELBINA_RABAO
                    } },
                },
                {
                    text = "Find the Jar in Davoi and take the Power Sandals from it. The jar moves somewhere else in the zone each time it is emptied.",
                    pos  = "Davoi",
                    done = { item = 13012 }, -- POWER_SANDALS
                },
                {
                    text = "Trade the Power Sandals back to Devean in Selbina before the deadline. Miss it and the stake is gone.",
                    pos  = "Selbina (!pos 39 -14 40)",
                },
            },
        },
        [26] = { -- INSIDE_THE_BELLY
            name = "Inside the Belly",
            repeatable = true,
            steps = {
                {
                    text = "Take Zaldon's standing offer in Selbina -- The Real Gift finished and fishing skill 30 or better.",
                    pos  = "Selbina (!pos -11 -7 -6)",
                    done = { status = 1 },
                },
                {
                    text = "Trade Zaldon one of the fish he is after. Ask him first: the list he reads out depends on your fishing skill and grows with it.",
                    pos  = "Selbina (!pos -11 -7 -6)",
                },
            },
        },
        [27] = { name = "Trial by Lightning" }, -- TRIAL_BY_LIGHTNING (name from enum; no script header found)
        [28] = { name = "Trial Size Trial by Lightning" }, -- TRIAL_SIZE_TRIAL_BY_LIGHTNING (name from enum; no script header found)
        [29] = { -- ITS_RAINING_MANNEQUINS
            name = "It's Raining Mannequins!",
            steps = {
                {
                    text = "Hear Fyi Chalmwoh out in Mhaura's goldsmithing shop.",
                    pos  = "Mhaura (!pos -39 -16 70)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Ramona in Selbina's weaving shop for Ye Olde Mannequin Catalogue.",
                    pos  = "Selbina (!pos 12 -7 2)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Ask Cheupirudaux, outside the woodworking guild in Northern San d'Oria, for the Mannequin Joint Diagrams.",
                    pos  = "Northern San d'Oria (!pos -138 11 250)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade Fyi Chalmwoh all five mannequin pieces in one go: head, body, hands, legs and feet.",
                    pos  = "Mhaura (!pos -39 -16 70)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Give the assembly a minute, then speak to Fyi Chalmwoh again with a free inventory slot open.",
                    pos  = "Mhaura (!pos -39 -16 70)",
                },
            },
        },
        [30] = { -- RECYCLING_RODS
            name = "Recycling Rods",
            steps = {
                {
                    text = "Hear Keshab-Menjab out in Mhaura.",
                    pos  = "Mhaura (!pos -15 -8 52)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Clean Snap Rod to Keshab-Menjab.",
                    pos  = "Mhaura (!pos -15 -8 52)",
                },
            },
        },
        [31] = { name = "Picture Perfect" }, -- PICTURE_PERFECT (name from enum; no script header found)
        [32] = { -- WAKING_THE_BEAST
            name = "Waking the Beast",
            repeatable = true,
            steps = {
                {
                    text = "Touch the ??? in La Theine Plateau with Ifrit, Shiva, Garuda, Ramuh, Leviathan and Titan all learned. It hands over the Rainbow Resonator.",
                    pos  = "La Theine Plateau (!pos -179 8 254)",
                    done = { status = 1 },
                },
                {
                    text = "Win the six protocrystal fights -- Flames, Frost, Gales, Storms, Tides and Tremors -- for their six Eyes, then take the Eyes and the Resonator into Full Moon Fountain and win there for the Faded Ruby.",
                    pos  = "Full Moon Fountain",
                    done = { ki = 364 }, -- FADED_RUBY
                },
                {
                    text = "Bring the Faded Ruby back to the ??? in La Theine Plateau. The quest can be run again once a conquest tally has passed.",
                    pos  = "La Theine Plateau (!pos -179 8 254)",
                },
            },
        },
        [33] = { name = "Survival of the Wisest" }, -- SURVIVAL_OF_THE_WISEST (name from enum; no script header found)
        -- NOT gated, deliberately. The script demands ENABLE_MONSTROSITY, but
        -- that is a feature flag, not one of content_gate's expansion buckets,
        -- so xi.dw.contentFlagOpen would answer false for it forever (Phase
        -- 3's Trust: Bastok reasoning). With the setting at 0 the quest simply
        -- cannot be accepted, and the tracker only ever renders held state.
        [34] = { -- MONSTROSITY
            name = "Monstrosity",
            steps = {
                {
                    text = "Speak to the Suspicious Hume in Pashhow Marshlands. Nothing happens here unless the server has Monstrosity switched on.",
                    pos  = "Pashhow Marshlands (!pos -491 24 -618)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Lizard Tail, a Rabbit Hide or a Two-leaf Mandragora Bud to the suspicious figure in Northern San d'Oria, Port Bastok or Port Windurst; whichever you hand over decides your starting species.",
                    done = { ki = 2350 }, -- RING_OF_SUPERNAL_DISJUNCTION
                },
                {
                    text = "Use an Odyssean Passage -- one stands beside each of those figures -- to cross into the Feretory.",
                },
            },
        },
        -- Ids 64-83 are the Tavnazia block: every one of them lives in, or
        -- runs through, a zone in content_gate's ENABLE_COP bucket (Tavnazian
        -- Safehold, Lufaise Meadows, Misareaux Coast, the Sacrarium, the
        -- Phomiuna Aqueducts, Riverne, Monarch Linn, Boneyard Gully,
        -- Carpenters' Landing). Authored and parked until the flag opens.
        [64] = { -- A_HARD_DAYS_KNIGHT
            name = "A Hard Day's Knight",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the job from Quelveuiat in the Tavnazian Safehold.",
                    pos  = "Tavnazian Safehold (!pos -3 -22 -25)",
                    done = { status = 1 },
                },
                {
                    text = "Draw out Splinterspine Grukjuk at the ??? in Lufaise Meadows and defeat it.",
                    pos  = "Lufaise Meadows (!pos -38 -9 -290)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report back to Quelveuiat in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos -3 -22 -25)",
                },
            },
        },
        [65] = { -- X_MARKS_THE_SPOT
            name = "X Marks the Spot",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the job from Despachiaire in the Tavnazian Safehold. He waits for the Chapter to reach Ancient Vows.",
                    pos  = "Tavnazian Safehold (!pos 111 -40 -85)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Parelbriaux in the Safehold about it.",
                    pos  = "Tavnazian Safehold (!pos 113 -41 42)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take what he says to Odeya in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 83 -34 -70)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Trade Odeya a Tavnazian Liver.",
                    pos  = "Tavnazian Safehold (!pos 83 -34 -70)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Find the hidden second gate in the Phomiuna Aqueducts.",
                    pos  = "Phomiuna Aqueducts (!pos 138 -24 60)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Report back to Odeya in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 83 -34 -70)",
                },
            },
        },
        [66] = { -- A_BITTER_PAST
            name = "A Bitter Past",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Hear Frescheque out in the Tavnazian Safehold.",
                    pos  = "Tavnazian Safehold (!pos 18 -36 12)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Raminey in the Safehold what he remembers.",
                    pos  = "Tavnazian Safehold (!pos 82 -35 50)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Then ask Equette, also in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 3 -22 -17)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "At the ??? in Lufaise Meadows, draw out the pair of orcs, defeat both, and check the ??? again for the Tiny Wristlet.",
                    pos  = "Lufaise Meadows (!pos 58 -7 27)",
                    done = { allOf = {
                        { var = 'Prog', gte = 2 },
                        { ki = 602 }, -- TINY_WRISTLET
                    } },
                },
                {
                    text = "Take the wristlet to Frescheque in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 18 -36 12)",
                },
            },
        },
        [67] = { -- THE_CALL_OF_THE_SEA
            name = "The Call of the Sea",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Hear Equette out in the Tavnazian Safehold, then carry it to Anteurephiaux, who turns it into a job. Leporaitceau has a scene of his own that is easy to miss.",
                    pos  = "Tavnazian Safehold (!pos 81 -24 -2)",
                    done = { status = 1 },
                },
                {
                    text = "Draw out the Bloody Coffin at the ??? on Misareaux Coast, defeat it, and check the ??? again for the Whispering Conch.",
                    pos  = "Misareaux Coast (!pos 641 0 -516)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Take the conch to Anteurephiaux in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 81 -24 -2)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Report back to Equette in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 1 -22 -18)",
                },
            },
        },
        [68] = { -- PARADISE_SALVATION_AND_MAPS
            name = "Paradise Salvation and Maps",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the job from Nivorajean in the Tavnazian Safehold. The Chapter's The Savage must be finished.",
                    pos  = "Tavnazian Safehold (!pos 16 -22 12)",
                    done = { status = 1 },
                },
                {
                    text = "Open a treasure chest in the Sacrarium for a Piece of Ripped Floorplans. Which chest it was is what Nivorajean cares about.",
                    pos  = "Sacrarium",
                    done = { anyOf = {
                        { var = 'Option', gte = 1 },
                        { var = 'Prog', gte = 1 },
                    } },
                },
                {
                    text = "Bring the floorplans to Nivorajean and point out the chest's position on his map.",
                    pos  = "Tavnazian Safehold (!pos 16 -22 12)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Come back a Vana'diel day later. Right chest and he finishes the job; wrong one and he sends you to find another.",
                    pos  = "Tavnazian Safehold (!pos 16 -22 12)",
                },
            },
        },
        [69] = { -- GO_GO_GOBMUFFIN
            name = "Go! Go! Gobmuffin!",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the job from Epinolle in the Tavnazian Safehold. The Chapter's Sheltering Doubt must be finished.",
                    pos  = "Tavnazian Safehold (!pos 81 -33 66)",
                    done = { status = 1 },
                },
                {
                    text = "In Riverne - Site #B01, call out the three goblins at the spatial displacement and defeat all three in one visit -- zoning resets the tally.",
                    pos  = "Riverne - Site #B01 (!pos 386 52 692)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report back to Epinolle in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 81 -33 66)",
                },
            },
        },
        [70] = { name = "The Big One" }, -- THE_BIG_ONE (name from enum; no script header found)
        [71] = { name = "Fly High" }, -- FLY_HIGH (name from enum; no script header found)
        [72] = { -- UNFORGIVEN
            name = "Unforgiven",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Hear Elysia out in the Tavnazian Safehold. She asks once the Chapter has reached An Invitation West.",
                    pos  = "Tavnazian Safehold (!pos -50 -22 -41)",
                    done = { status = 1 },
                },
                {
                    text = "Search the ??? in the Safehold for the Alabaster Hairpin, and take it back to Elysia.",
                    pos  = "Tavnazian Safehold (!pos 110 -40 -53)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Speak to Pradiulot in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos -20 -22 8)",
                },
            },
        },
        -- This script's header carries San d'Oria's Spice Gals -- the quest
        -- it requires, not the quest it is. Phase 0's generator trusted the
        -- header; the enum and the code say SECRETS_OF_OVENS_LOST
        -- (FORMAT §6.11).
        [73] = { -- SECRETS_OF_OVENS_LOST
            name = "Secrets of Ovens Lost",
            gated = 'ENABLE_COP',
            repeatable = true,
            steps = {
                {
                    text = "Hear Despachiaire out in the Tavnazian Safehold, then take the job from Jonette. San d'Oria's Spice Gals must already be finished.",
                    pos  = "Tavnazian Safehold (!pos -70 -11 9)",
                    done = { status = 1 },
                },
                {
                    text = "Take the Tavnazian Cookbook from the ??? in the Sacrarium or the one in the Phomiuna Aqueducts.",
                    pos  = "Sacrarium / Phomiuna Aqueducts",
                    done = { ki = 622 }, -- TAVNAZIAN_COOKBOOK
                },
                {
                    text = "Bring the cookbook back to Jonette in the Safehold. She will ask again after the next conquest tally.",
                    pos  = "Tavnazian Safehold (!pos -70 -11 9)",
                },
            },
        },
        [74] = { -- PETALS_FOR_PARELBRIAUX
            name = "Petals for Parelbriaux",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Work it out in the Safehold before it becomes a quest: Chemioue, then Parelbriaux, then Ondieulix. The Chapter's Darkness Named must be finished.",
                    pos  = "Tavnazian Safehold (!pos 3 -21 65)",
                    done = { status = 1 },
                },
                {
                    text = "Wait for fog over Lufaise Meadows, draw Baumesel out at the ???, defeat it, and check the ??? again for the petal.",
                    pos  = "Lufaise Meadows (!pos -211 -16 287)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Take the petal to Ondieulix in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 3 -21 65)",
                },
            },
        },
        [75] = { -- ELDERLY_PURSUITS
            name = "Elderly Pursuits",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the Antique Amulet from Despachiaire in the Tavnazian Safehold. Secrets of Ovens Lost must already be finished.",
                    pos  = "Tavnazian Safehold (!pos 111 -40 -85)",
                    done = { status = 1 },
                },
                {
                    text = "Show the amulet to Rouva in Southern San d'Oria.",
                    pos  = "Southern San d'Oria (!pos -16 2 10)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "At the ??? in Carpenters' Landing, draw out Para and defeat it, then check the ??? again before you zone -- the amulet is polished into the Cathedral Medallion there.",
                    pos  = "Carpenters' Landing (!pos -414 0 -362)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Take the medallion back to Rouva in Southern San d'Oria.",
                    pos  = "Southern San d'Oria (!pos -16 2 10)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Report to Despachiaire in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 111 -40 -85)",
                },
            },
        },
        [76] = { name = "In the Name of Science" }, -- IN_THE_NAME_OF_SCIENCE (name from enum; no script header found)
        [77] = { -- BEHIND_THE_SMILE
            name = "Behind the Smile",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the job from Enaremand in the Tavnazian Safehold. It's Raining Mannequins! must already be finished.",
                    pos  = "Tavnazian Safehold (!pos 96 -41 51)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Fyi Chalmwoh in Mhaura what the doll needs.",
                    pos  = "Mhaura (!pos -39 -16 70)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "At the ??? in Carpenters' Landing, draw out Bullheaded Grosvez, defeat it, then check the ??? again for the Red Oil.",
                    pos  = "Carpenters' Landing",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Take the oil back to Enaremand in the Safehold.",
                    pos  = "Tavnazian Safehold (!pos 96 -41 51)",
                },
            },
        },
        [78] = { -- KNOCKING_ON_FORBIDDEN_DOORS
            name = "Knocking on Forbidden Doors",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the job from Enaremand in the Tavnazian Safehold. Behind the Smile must already be finished.",
                    pos  = "Tavnazian Safehold (!pos 96 -41 51)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Chemioue in the Safehold about it.",
                    pos  = "Tavnazian Safehold (!pos 82 -33 67)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Climb the wooden ladder in the Phomiuna Aqueducts that she points you to.",
                    pos  = "Phomiuna Aqueducts",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "On Misareaux Coast, take the Mire Incense from the ??? at the river's end, then burn it at the other ???.",
                    pos  = "Misareaux Coast",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Check that ??? again to draw Alsha out, and defeat her.",
                    pos  = "Misareaux Coast",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Check the ??? once more for Better Humes and Mannequins.",
                    pos  = "Misareaux Coast",
                    done = { var = 'Prog', gte = 5 },
                },
                {
                    text = "Take the book to Fyi Chalmwoh in Mhaura.",
                    pos  = "Mhaura (!pos -39 -16 70)",
                },
            },
        },
        [79] = { -- CONFESSIONS_OF_A_BELLMAKER
            name = "Confessions of a Bellmaker",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Read the stone monument in Riverne - Site #A01. It hands over the Ornamented Scroll.",
                    pos  = "Riverne - Site #A01 (!pos -733 -46 -300)",
                    done = { status = 1 },
                },
                {
                    text = "Ask Reinberta in Bastok Markets about the scroll.",
                    pos  = "Bastok Markets (!pos -190 -7 -59)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Take what she says to Mevreauche in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos -193 11 148)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Return to the monument in Riverne - Site #A01.",
                    pos  = "Riverne - Site #A01 (!pos -733 -46 -300)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Touch the monument again to call up the Arcane Phantasm, and defeat it.",
                    pos  = "Riverne - Site #A01 (!pos -733 -46 -300)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Read the monument one last time.",
                    pos  = "Riverne - Site #A01 (!pos -733 -46 -300)",
                },
            },
        },
        [80] = { -- IN_SEARCH_OF_THE_TRUTH
            name = "In Search of the Truth",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the job from Tressia in the Tavnazian Safehold. She waits for the Chapter to pass Darkness Named.",
                    pos  = "Tavnazian Safehold (!pos 87 -33 70)",
                    done = { status = 1 },
                },
                {
                    text = "Hear all four of them out in the Safehold -- Raminey, Zadant, Fouagine and Noam -- then take what you have back to Tressia.",
                    pos  = "Tavnazian Safehold (!pos 87 -33 70)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Speak to Tressia again.",
                    pos  = "Tavnazian Safehold (!pos 87 -33 70)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Follow the water trail through the Safehold: five ???s, checked in order, starting with the one holding the Shaded Cruse. Tressia and then Ondieulix hand over the reward afterwards.",
                    pos  = "Tavnazian Safehold (!pos -73 -11 11)",
                },
            },
        },
        [81] = { -- UNINVITED_GUESTS
            name = "Uninvited Guests",
            gated = 'ENABLE_COP',
            repeatable = true,
            steps = {
                {
                    text = "Take the patrol from Justinius in the Tavnazian Safehold. The Chapter's The Savage must be finished. He hands over the Monarch Linn Patrol Permit.",
                    pos  = "Tavnazian Safehold (!pos 76 -34 68)",
                    done = { status = 1 },
                },
                {
                    text = "Take the permit into Monarch Linn and win the fight there.",
                    pos  = "Monarch Linn",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Report the victory to Justinius. He issues a fresh permit after the next conquest tally, win or lose.",
                    pos  = "Tavnazian Safehold (!pos 76 -34 68)",
                },
            },
        },
        [82] = { -- TANGO_WITH_A_TRACKER
            name = "Tango With a Tracker",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the Letter from Shikaree X from Despachiaire in the Safehold, then step into the Boneyard Gully fight -- this one only enters the log once you are inside.",
                    pos  = "Tavnazian Safehold (!pos 111 -40 -85)",
                    done = { status = 1 },
                },
                {
                    text = "Win the fight in Boneyard Gully. If you need another attempt, Despachiaire issues a fresh letter once a conquest tally has passed.",
                    pos  = "Boneyard Gully",
                },
            },
        },
        [83] = { -- REQUIEM_OF_SIN
            name = "Requiem of Sin",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the Letter from Shikaree Y from Despachiaire -- Tango With a Tracker must be finished -- then step into the Boneyard Gully fight, which is what enters this in the log.",
                    pos  = "Tavnazian Safehold (!pos 111 -40 -85)",
                    done = { status = 1 },
                },
                {
                    text = "Win the fight in Boneyard Gully. Despachiaire issues a fresh letter once a conquest tally has passed if you need another attempt.",
                    pos  = "Boneyard Gully",
                },
            },
        },
        [84] = { name = "Vw Op 026 Tavnazian Terrors" }, -- VW_OP_026_TAVNAZIAN_TERRORS (name from enum; no script header found)
        [85] = { name = "Vw Op 004 Bibiki Bombardment" }, -- VW_OP_004_BIBIKI_BOMBARDMENT (name from enum; no script header found)
        [96] = { -- BOMBS_AWAY
            name = "Bombs Away!",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Agree to climb the mountain for Buffalostalker Dodzbraz in the Uleguerand Range.",
                    pos  = "Uleguerand Range (!pos -380 -24 -180)",
                    done = { status = 1 },
                },
                {
                    text = "Trade him two Cluster Cores.",
                    pos  = "Uleguerand Range (!pos -380 -24 -180)",
                },
            },
        },
        [97] = { name = "Mithran Delicacies" }, -- MITHRAN_DELICACIES (name from enum; no script header found)
        -- The three Moogle quests gate on fame in the player's OWN nation,
        -- which the DSL's fame atom cannot express (it names a fixed area),
        -- so the requirement rides the accept step's wording -- Phase 4's
        -- Know One's Onions shape.
        [100] = { -- GIVE_A_MOOGLE_A_BREAK
            name = "Give a Moogle a Break",
            steps = {
                {
                    text = "Let your Moogle ask, in your home nation's Mog House. He brings it up at home-nation fame 3, and only once a bed has stood in the room for a minute.",
                    pos  = "Mog House (home nation)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Moogle a Power Bow and a Beetle Ring together.",
                    pos  = "Mog House (home nation)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Give him a minute, then speak to him again. The reward is ten more slots in each Mog Safe.",
                    pos  = "Mog House (home nation)",
                },
            },
        },
        [101] = { -- THE_MOOGLE_PICNIC
            name = "The Moogle's Picnic!",
            steps = {
                {
                    text = "Let your Moogle ask again, at home-nation fame 5 and with Give a Moogle a Break finished. A bed must have stood in the room for a minute.",
                    pos  = "Mog House (home nation)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Moogle a Shrimp Lure and a Stick of Selbina Butter together.",
                    pos  = "Mog House (home nation)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Give him a minute, then speak to him again for another ten slots in each Mog Safe.",
                    pos  = "Mog House (home nation)",
                },
            },
        },
        [102] = { -- MOOGLES_IN_THE_WILD
            name = "Moogles in the Wild",
            steps = {
                {
                    text = "Let your Moogle ask a third time, at home-nation fame 7 and with The Moogle's Picnic! finished. A bed must have stood in the room for a minute.",
                    pos  = "Mog House (home nation)",
                    done = { status = 1 },
                },
                {
                    text = "Trade the Moogle a Raptor Mantle and a Wool Hat together.",
                    pos  = "Mog House (home nation)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Give him a minute, then speak to him again for the last ten slots in each Mog Safe.",
                    pos  = "Mog House (home nation)",
                },
            },
        },
        -- Name corrected from the enum: the script header misspells it
        -- "Missionery", and Phase 0's generator copied the header.
        [103] = { -- MISSIONARY_MOBLIN
            name = "Missionary Moblin",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Hear Koblakiq out in Oldton Movalpolos and agree to help.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                    done = { status = 1 },
                },
                {
                    text = "Trade him a Soiled Letter.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                },
            },
        },
        [104] = { -- FOR_THE_BIRDS
            name = "For the Birds",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the next job from Koblakiq in Oldton Movalpolos. Missionary Moblin must be finished and zoned past.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                    done = { status = 1 },
                },
                {
                    text = "Trade an Arnica Root to Daa Bola the Seer in Castle Oztroja, then leave the zone.",
                    pos  = "Castle Oztroja (!pos -159 -16 191)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Report to Koblakiq for the Glittering Fragment.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "Show the fragment to GeFhu Yagudoeye in Beadeaux and beat all four Quadav he calls down without leaving the zone -- zoning resets the count.",
                    pos  = "Beadeaux (!pos -91 -3 -127)",
                    done = { var = 'Prog', gte = 4 },
                },
                {
                    text = "Return to Koblakiq in Oldton Movalpolos.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                },
            },
        },
        [105] = { -- BETTER_THE_DEMON_YOU_KNOW
            name = "Better The Demon You Know",
            gated = 'ENABLE_COP',
            steps = {
                {
                    text = "Take the last of Koblakiq's jobs in Oldton Movalpolos. For the Birds must be finished and zoned past.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                    done = { status = 1 },
                },
                {
                    text = "Trade a Demon Pen to Koblakiq.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                    done = { var = 'Prog', gte = 1 },
                },
                {
                    text = "Give him a minute to write, then speak to him again.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                    done = { var = 'Prog', gte = 2 },
                },
                {
                    text = "At the ??? in Castle Zvahl Baileys, beat the Marquis Andrealphus that swarm out, then check the ??? again for Zeelozok's Earplug. Zoning first means fighting them over.",
                    pos  = "Castle Zvahl Baileys (!pos 19 -24 19)",
                    done = { var = 'Prog', gte = 3 },
                },
                {
                    text = "Take the earplug back to Koblakiq.",
                    pos  = "Oldton Movalpolos (!pos -64 21 -117)",
                },
            },
        },
        [106] = { name = "An Understanding Overlord" }, -- AN_UNDERSTANDING_OVERLORD (name from enum; no script header found)
        [107] = { name = "An Affable Adamantking" }, -- AN_AFFABLE_ADAMANTKING (name from enum; no script header found)
        [108] = { name = "A Moral Manifest" }, -- A_MORAL_MANIFEST (name from enum; no script header found)
        [109] = { name = "A Generous General" }, -- A_GENEROUS_GENERAL (name from enum; no script header found)
        [110] = { name = "Records of Eminence" }, -- RECORDS_OF_EMINENCE (name from enum; no script header found)
        [111] = { name = "Unity Concord" }, -- UNITY_CONCORD (name from enum; no script header found)
    },
}
