-- dwtracker data -- San d'Oria missions. Names generated Phase 0
-- (tools/dwtracker_names.py); steps 1-1 through 2-3 HAND-AUTHORED Phase 1
-- from the mission scripts (scripts/missions/sandoria/) as ground truth.
-- Pure data: numeric ids and display strings only, no xi.*, no functions
-- (DWTRACKER_FORMAT.md decisions T2/§3-4). Loaded byte-identically by the
-- server module and the dwtracker addon; both hash these bytes, so an edit
-- that reaches only one side makes the addon refuse step rendering for
-- this area until the copies agree again. tools/dwtracker_lint.py must
-- pass before any edit here ships.
--
-- Authoring conventions (Phase 1, proven here first):
--   * The final step omits `done`: a turn-in completes by leaving the
--     Active list, so no predicate can be true while it renders.
--   * missionStatus thresholds are the values the script's own
--     setMissionStatus calls write; the chain must be non-decreasing.
--   * Gather steps ride allOf{ missionStatus, item } so an item obtained
--     early can never skip the tracker past unvisited NPC steps.
return {
    kind = 'missions',
    log = 0,
    area = 'sandoria_missions',
    label = "San d'Oria",
    entries = {
        [0] = { -- SMASH_THE_ORCISH_SCOUTS (M1-1)
            name = "Smash the Orcish Scouts",
            repeatable = true,
            steps = {
                {
                    text = "Claim an Orcish Axe from the Orc scouts prowling beyond the gates -- the Ghelsba hills are their ground.",
                    done = { item = 16656 }, -- ORCISH_AXE
                },
                {
                    text = "Trade the axe to a gate guard: Ambrotien or Endracion in Southern San d'Oria, or Grilau in Northern San d'Oria.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                },
            },
        },
        [1] = { -- BAT_HUNT (M1-2)
            name = "Bat Hunt",
            repeatable = true,
            steps = {
                {
                    text = "Read the tombstone deep inside King Ranperre's Tomb.",
                    pos  = "King Ranperre's Tomb (!pos 1 0 -101)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Trade an Orcish Scale Mail to a gate guard. Repeating the hunt? They ask for a Bat Fang instead.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                },
            },
        },
        [2] = { -- SAVE_THE_CHILDREN (M1-3)
            name = "Save the Children",
            repeatable = true,
            steps = {
                {
                    text = "Hear Arnau's plea in Northern San d'Oria. (Repeating rescuers already know the plan and may head straight out.)",
                    pos  = "Northern San d'Oria (!pos 148 0 139)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Storm the hut in Ghelsba Outpost and defeat the kidnappers within.",
                    pos  = "Ghelsba Outpost (hut at !pos -165 -12 78)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Open the hut door with the Orcish Hut Key and see the children out.",
                    pos  = "Ghelsba Outpost (!pos -165 -12 78)",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Report your success to a gate guard.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                },
            },
        },
        [3] = { -- THE_RESCUE_DRILL (M2-1)
            name = "The Rescue Drill",
            repeatable = true,
            steps = {
                {
                    text = "Start the drill with Galaihaurat, the trainee posted on La Theine Plateau's southern ridge.",
                    pos  = "La Theine Plateau (!pos -482 -7 222)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Carry the drill order to Equesobillot.",
                    pos  = "La Theine Plateau (!pos -287 9 284)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Pass the word to Deaufrain.",
                    pos  = "La Theine Plateau (!pos -304 28 339)",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Relay it on to Vicorpasse.",
                    pos  = "La Theine Plateau (!pos -344 37 266)",
                    done = { missionStatus = { 0, gte = 5 } },
                },
                {
                    text = "Alert Laurisse.",
                    pos  = "La Theine Plateau (!pos -292 28 143)",
                    done = { missionStatus = { 0, gte = 6 } },
                },
                {
                    text = "Finish the relay with Narvecaint.",
                    pos  = "La Theine Plateau (!pos -263 22 129)",
                    done = { missionStatus = { 0, gte = 7 } },
                },
                {
                    text = "Find Ruillont, the knight awaiting rescue inside Ordelle's Caves.",
                    pos  = "Ordelle's Caves (!pos -70 1 607)",
                    done = { missionStatus = { 0, gte = 8 } },
                },
                {
                    text = "One trainee on the plateau keeps a spare Bronze Sword for the rescue -- ask Equesobillot, Deaufrain and Galaihaurat.",
                    done = { missionStatus = { 0, gte = 9 } },
                },
                {
                    text = "Take the Bronze Sword down to Ruillont.",
                    pos  = "Ordelle's Caves (!pos -70 1 607)",
                    done = { missionStatus = { 0, gte = 10 } },
                },
                {
                    text = "Tell Vicorpasse the drill is done and collect the Rescue Training Certificate.",
                    pos  = "La Theine Plateau (!pos -344 37 266)",
                    done = { missionStatus = { 0, gte = 11 } },
                },
                {
                    text = "Present the certificate to a gate guard.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                },
            },
        },
        [4] = { -- THE_DAVOI_REPORT (M2-2)
            name = "The Davoi Report",
            repeatable = true,
            steps = {
                {
                    text = "Seek out Zantaviat, the scout lying low in Davoi.",
                    pos  = "Davoi (!pos 215 0 -10)",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Search the marked spot nearby for the lost document.",
                    pos  = "Davoi (!pos 211 2 -104)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Bring the document back to Zantaviat and take his report in exchange.",
                    pos  = "Davoi (!pos 215 0 -10)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Deliver the Temple Knights' report: first time, to the Papal Chambers in Northern San d'Oria; on a repeat, any gate guard takes it.",
                    pos  = "Northern San d'Oria (!pos 131 -11 122)",
                },
            },
        },
        [5] = { -- JOURNEY_ABROAD (M2-3)
            name = "Journey Abroad",
            steps = {
                {
                    text = "Call on Halver in Chateau d'Oraguille for your commission and the letter to the consuls.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Choose your first stop and hand the letter to the consulate there: Savae E Paleade in Bastok's Metalworks, or Mourices in Windurst Woods.",
                    pos  = "Metalworks (!pos 24 -17 -43) / Windurst Woods (!pos -51 -1 -28)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "See the first errand through -- your journal carries it as Journey to Bastok or Journey to Windurst.",
                    done = { missionStatus = { 0, gte = 6 } },
                },
                {
                    text = "Cross to the remaining nation and report to its consulate to take up the second errand.",
                    pos  = "Metalworks (!pos 24 -17 -43) / Windurst Woods (!pos -51 -1 -28)",
                    done = { missionStatus = { 0, gte = 8 } },
                },
                {
                    text = "Return to Halver with both consulates' regards -- Rank 3 and your Adventurer's Certificate await.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                },
            },
        },
        [6] = { -- JOURNEY_TO_BASTOK (M2-3, first errand)
            name = "Journey to Bastok",
            steps = {
                {
                    text = "Introduce yourself to Pius, the consulate clerk in Bastok's Metalworks.",
                    pos  = "Metalworks (!pos 99 -21 -12)",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Collect three pickaxes from Grohm.",
                    pos  = "Metalworks (!pos -18 -11 -27)",
                    done = { missionStatus = { 0, gte = 5 } },
                },
                {
                    text = "Work the refinery in the Palborough Mines until an Onz of Mythril Sand comes out, and carry it back.",
                    pos  = "Palborough Mines (refiner lever at !pos 180 -32 167)",
                    done = {
                        allOf = {
                            { missionStatus = { 0, gte = 5 } },
                            { item = 599 }, -- ONZ_OF_MYTHRIL_SAND
                        },
                    },
                },
                {
                    text = "Trade the Onz of Mythril Sand to Savae E Paleade.",
                    pos  = "Metalworks (!pos 24 -17 -43)",
                },
            },
        },
        [7] = { -- JOURNEY_TO_WINDURST (M2-3, first errand)
            name = "Journey to Windurst",
            steps = {
                {
                    text = "Enter Heavens Tower, the great tree at the heart of Windurst.",
                    pos  = "Windurst Walls",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Speak with Kupipi and accept the Shield Offering.",
                    pos  = "Heavens Tower (!pos 2 0 30)",
                    done = { missionStatus = { 0, gte = 5 } },
                },
                {
                    text = "Bear the offering to Uu Zhoumo in Giddeus.",
                    pos  = "Giddeus (!pos -179 16 155)",
                    done = { missionStatus = { 0, gte = 6 } },
                },
                {
                    text = "Claim two Parana Shields from Zhuu Buxu the Silent, a Yagudo that stalks Giddeus -- each defeat yields one.",
                    pos  = "Giddeus",
                    done = {
                        allOf = {
                            { missionStatus = { 0, gte = 6 } },
                            { item = 12298, qty = 2 }, -- PARANA_SHIELD x2
                        },
                    },
                },
                {
                    text = "Trade the two shields to Mourices in Windurst Woods.",
                    pos  = "Windurst Woods (!pos -51 -1 -28)",
                },
            },
        },
        [8] = { -- JOURNEY_TO_BASTOK2 (M2-3, second errand)
            name = "Journey to Bastok",
            steps = {
                {
                    text = "Report to Pius at the Bastok consulate to take up the second errand.",
                    pos  = "Metalworks (!pos 99 -21 -12)",
                    done = { missionStatus = { 0, gte = 9 } },
                },
                {
                    text = "Speak with Grohm; he readies you for a trial at Waughroon Shrine.",
                    pos  = "Metalworks (!pos -18 -11 -27)",
                    done = { missionStatus = { 0, gte = 10 } },
                },
                {
                    text = "Prevail in the battle at Waughroon Shrine, within the Palborough Mines, and claim the Kindred Crest.",
                    done = { missionStatus = { 0, gte = 11 } },
                },
                {
                    text = "Show the Kindred Crest to Savae E Paleade to finish the errand.",
                    pos  = "Metalworks (!pos 24 -17 -43)",
                },
            },
        },
        [9] = { -- JOURNEY_TO_WINDURST2 (M2-3, second errand)
            name = "Journey to Windurst",
            steps = {
                {
                    text = "Speak with Kupipi in Heavens Tower; she entrusts you with the Dark Key.",
                    pos  = "Heavens Tower (!pos 2 0 30)",
                    done = { missionStatus = { 0, gte = 8 } },
                },
                {
                    text = "Overcome the battle at Balga's Dais, within the Horutoto Ruins, and secure the Kindred Crest.",
                    done = { missionStatus = { 0, gte = 9 } },
                },
                {
                    text = "Bring the Kindred Crest to Mourices in Windurst Woods.",
                    pos  = "Windurst Woods (!pos -51 -1 -28)",
                },
            },
        },
        [10] = { -- INFILTRATE_DAVOI (M3-1)
            name = "Infiltrate Davoi",
            repeatable = true,
            -- The one launch mission whose repeat run is a DIFFERENT errand on a
            -- disjoint status range (first 0-4, repeat 0/6-10). Steps 1-4 ride
            -- anyOf{ threshold, completedMission } so a repeater reads them as
            -- already done; steps 5-7 ride allOf{ completedMission, threshold }
            -- so a first-timer can never be sent down the code hunt. Both halves
            -- also keep the chain provable -- see DWTRACKER_FORMAT.md 6.8.
            steps = {
                {
                    text = "Take your orders. First run: the Prince Royal's Chamber door in Chateau d'Oraguille. Repeating: Zantaviat, lying low in Davoi.",
                    pos  = "Chateau d'Oraguille (!pos -38 -3 73) / Davoi (!pos 215 0 -10)",
                    done = {
                        anyOf = {
                            { missionStatus = { 0, gte = 2 } },
                            { completedMission = { 0, 10 } },
                        },
                    },
                },
                {
                    text = "Cross into Davoi -- the Royal Knights' man there finds you as you arrive.",
                    pos  = "Davoi",
                    done = {
                        anyOf = {
                            { missionStatus = { 0, gte = 3 } },
                            { completedMission = { 0, 10 } },
                        },
                    },
                },
                {
                    text = "Track down Quemaricond in Davoi and take the Royal Knights' Davoi Report from him.",
                    pos  = "Davoi (!pos 23 0 -23)",
                    done = {
                        anyOf = {
                            { missionStatus = { 0, gte = 4 } },
                            { completedMission = { 0, 10 } },
                        },
                    },
                },
                {
                    text = "Carry the report back to the Prince Royal's Chamber door.",
                    pos  = "Chateau d'Oraguille (!pos -38 -3 73)",
                    done = { completedMission = { 0, 10 } },
                },
                {
                    text = "Repeat run: report in to Zantaviat in Davoi -- this time the Knights want the Orcs' block codes.",
                    pos  = "Davoi (!pos 215 0 -10)",
                    done = {
                        allOf = {
                            { completedMission = { 0, 10 } },
                            { missionStatus = { 0, gte = 6 } },
                        },
                    },
                },
                {
                    text = "Read all three code markers scattered through Davoi -- east, south and north.",
                    pos  = "Davoi (!pos 294 0 -28 / 335 0 -136 / 163 0 -18)",
                    done = {
                        allOf = {
                            { completedMission = { 0, 10 } },
                            { missionStatus = { 0, gte = 9 } },
                        },
                    },
                },
                {
                    text = "Bring all three codes back to Zantaviat.",
                    pos  = "Davoi (!pos 215 0 -10)",
                    done = {
                        allOf = {
                            { completedMission = { 0, 10 } },
                            { missionStatus = { 0, gte = 10 } },
                        },
                    },
                },
                {
                    text = "Close the repeat run with a gate guard back home.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                },
            },
        },
        [11] = { -- THE_CRYSTAL_SPRING (M3-2)
            name = "The Crystal Spring",
            repeatable = true,
            steps = {
                {
                    text = "Obtain a Crystal Bass and trade it to a gate guard. On a repeat run that trade alone finishes the mission.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Enter Chateau d'Oraguille by the Northern San d'Oria gate to be received.",
                    pos  = "Chateau d'Oraguille",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Speak with Chalvatot inside the Chateau to close the matter.",
                    pos  = "Chateau d'Oraguille (!pos -105 0 72)",
                },
            },
        },
        [12] = { -- APPOINTMENT_TO_JEUNO (M3-3)
            name = "Appointment to Jeuno",
            steps = {
                {
                    text = "Report to Halver in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Attend the king at the Great Hall door and take the Letter to the Ambassador.",
                    pos  = "Chateau d'Oraguille (!pos 0 -1 13)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Deliver the letter to Nelcabrit at the San d'Orian embassy in Ru'Lude Gardens.",
                    pos  = "Ru'Lude Gardens (!pos -32 9 -49)",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Open a Cermet Door in Lower Delkfutt's Tower -- a Delkfutt Key traded to the door does it.",
                    pos  = "Lower Delkfutt's Tower (!pos 636 16 20)",
                    done = { missionStatus = { 0, gte = 5 } },
                },
                {
                    text = "Return to Nelcabrit in Ru'Lude Gardens -- Rank 4 waits there.",
                    pos  = "Ru'Lude Gardens (!pos -32 9 -49)",
                },
            },
        },
        [13] = { -- MAGICITE (M4-1)
            name = "Magicite",
            steps = {
                {
                    text = "Call at the San d'Orian embassy door in Ru'Lude Gardens for the Archducal Audience Permit.",
                    pos  = "Ru'Lude Gardens (!pos -31 7 -65)",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Present the permit at the Audience Chamber door and take the letter meant for Aldo.",
                    pos  = "Ru'Lude Gardens (!pos 0 -5 66)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Carry the letter down to Aldo in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos 20 3 -58)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Recover three Magicite: the Orastone in Castle Oztroja's Altar Room, the Optistone in Davoi's Monastic Cavern, the Aurastone in Beadeaux's Qulun Dome.",
                    pos  = "Altar Room (!pos -344 25 43) / Monastic Cavern (!pos -160 -8 8) / Qulun Dome (!pos 11 25 -81)",
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { missionStatus = { 0, gte = 3 } },
                                    { ki = 16 }, -- MAGICITE_ORASTONE
                                    { ki = 14 }, -- MAGICITE_OPTISTONE
                                    { ki = 15 }, -- MAGICITE_AURASTONE
                                },
                            },
                            { missionStatus = { 0, gte = 4 } },
                        },
                    },
                },
                {
                    text = "Hand all three stones over at the Audience Chamber door. Muckvix in Lower Jeuno lends the Yagudo Torch if Castle Oztroja is still barring your way.",
                    pos  = "Ru'Lude Gardens (!pos 0 -5 66)",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Report back to Nelcabrit at the embassy -- Rank 5 and the road to Fei'Yin follow.",
                    pos  = "Ru'Lude Gardens (!pos -32 9 -49)",
                },
            },
        },
        [14] = { -- THE_RUINS_OF_FEI_YIN (M5-1)
            name = "The Ruins of Fei'Yin",
            steps = {
                {
                    text = "See Halver in Chateau d'Oraguille and take the new Fei'Yin seal from him.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 0, gte = 10 } },
                },
                {
                    text = "Make your way north-east to Fei'Yin; something meets you at the gate.",
                    pos  = "Fei'Yin",
                    done = { missionStatus = { 0, gte = 11 } },
                },
                {
                    text = "Win the fight waiting in Qu'Bia Arena -- the seal is your entry -- and take the Burnt Seal from it.",
                    pos  = "Qu'Bia Arena",
                    done = { missionStatus = { 0, gte = 12 } },
                },
                {
                    text = "Bring the Burnt Seal back to Halver.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                },
            },
        },
        [15] = { -- THE_SHADOW_LORD (M5-2)
            name = "The Shadow Lord",
            steps = {
                {
                    text = "Speak with Halver in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Attend Prince Trion at the Prince Royal's Chamber door.",
                    pos  = "Chateau d'Oraguille (!pos -38 -3 73)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Climb Castle Zvahl and present yourself at the Throne Room door.",
                    pos  = "Throne Room",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Bring down the Shadow Lord and take the Shadow Fragment left behind.",
                    pos  = "Throne Room",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Carry the Shadow Fragment to Halver -- Rank 6, and the Zilart road opens.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                },
            },
        },
        [16] = { -- LEAUTES_LAST_WISHES (M6-1)
            name = "Leaute's Last Wishes",
            steps = {
                {
                    text = "Speak with Halver in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Ask at the Great Hall door what the queen wishes for.",
                    pos  = "Chateau d'Oraguille (!pos 0 -1 13)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Reach for the Dreamrose in Western Altepa Desert: a Sabotender Enamorado rises the first time you touch it. Kill it, then take the flower.",
                    pos  = "Western Altepa Desert (!pos -262 -10 49)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Tell Halver you have it.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Take the Dreamrose in to the queen's chambers in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille",
                },
            },
        },
        [17] = { -- RANPERRES_FINAL_REST (M6-2)
            name = "Ranperre's Final Rest",
            steps = {
                {
                    text = "Take the assignment at the Prince Royal's Chamber door in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos -38 -3 73)",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Disturb the Heavy Stone Door in King Ranperre's Tomb and put down all three corrupted knights it wakes.",
                    pos  = "King Ranperre's Tomb (!pos -39 4 20)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Work the Heavy Stone Door again and pass through into the inner tomb.",
                    pos  = "King Ranperre's Tomb (!pos -39 4 20)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Read the tombstone beyond the door to recover the Ancient San d'Orian Book.",
                    pos  = "King Ranperre's Tomb (!pos -73 7 20)",
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { missionStatus = { 0, gte = 3 } },
                                    { ki = 269 }, -- ANCIENT_SAN_DORIAN_BOOK
                                },
                            },
                            { missionStatus = { 0, gte = 4 } },
                        },
                    },
                },
                {
                    text = "Show the book to a gate guard and leave it with them.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Give the scholars time with it: leave the city, come back, and ask the same guard again.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                    done = { missionStatus = { 0, gte = 5 } },
                },
                {
                    text = "Report what they found at the Prince Royal's Chamber door.",
                    pos  = "Chateau d'Oraguille (!pos -38 -3 73)",
                    done = { missionStatus = { 0, gte = 6 } },
                },
                {
                    text = "Go back to the Heavy Stone Door in King Ranperre's Tomb.",
                    pos  = "King Ranperre's Tomb (!pos -39 4 20)",
                    done = { missionStatus = { 0, gte = 7 } },
                },
                {
                    text = "Close the matter with a gate guard -- Rank 7 waits.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                },
            },
        },
        [18] = { -- PRESTIGE_OF_THE_PAPSQUE (M7-1)
            name = "Prestige of the Papsque",
            steps = {
                {
                    text = "Call at the Papal Chambers door in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos 131 -11 122)",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Search the marked ground in West Ronfaure: Marauder Dvogzog answers the first search. Beat him, then search again for the Ancient San d'Orian Tablet.",
                    pos  = "West Ronfaure (!pos -695 -40 21)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Take the tablet back to the Papal Chambers door.",
                    pos  = "Northern San d'Oria (!pos 131 -11 122)",
                },
            },
        },
        [19] = { -- THE_SECRET_WEAPON (M7-2)
            name = "The Secret Weapon",
            steps = {
                {
                    text = "Hear the summons out: ask a gate guard, then walk into Chateau d'Oraguille for the briefing.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Chateau d'Oraguille",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Win the battle set at Horlais Peak in Ronfaure and claim the Crystal Dowser.",
                    pos  = "Horlais Peak",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Bring the dowser to a gate guard -- Rank 8 follows.",
                    pos  = "Southern San d'Oria (!pos 93 0 -57) / Northern San d'Oria (!pos -242 7 58)",
                },
            },
        },
        [20] = { -- COMING_OF_AGE (M8-1)
            name = "Coming of Age",
            steps = {
                {
                    text = "Walk into Chateau d'Oraguille; the summons finds you at the door.",
                    pos  = "Chateau d'Oraguille",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Speak with Halver for the details.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Touch the Fountain of Kings in the Quicksand Caves: Honor and Valor rise together. Put both down.",
                    pos  = "Quicksand Caves (!pos 567 18 -939)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Touch the fountain again to gather the Drops of Amnio.",
                    pos  = "Quicksand Caves (!pos 567 18 -939)",
                    done = {
                        allOf = {
                            { missionStatus = { 0, gte = 3 } },
                            { ki = 288 }, -- DROPS_OF_AMNIO
                        },
                    },
                },
                {
                    text = "Bring the Drops of Amnio to Halver.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                },
            },
        },
        [21] = { -- LIGHTBRINGER (M8-2)
            name = "Lightbringer",
            steps = {
                {
                    text = "Take the assignment at the Great Hall door in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 0 -1 13)",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Speak with Rahal; he hands over the Crystal Dowser.",
                    pos  = "Chateau d'Oraguille (!pos -28 0 -6)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Search all three marked spots in the Temple of Uggalepih for the pieces of a broken key.",
                    pos  = "Temple of Uggalepih (!pos -13 -17 -151 / -32 -17 -153 / -68 -17 -153)",
                    done = { missionStatus = { 0, gte = 5 } },
                },
                {
                    text = "Try the Granite Door with the three pieces: the Nio guardians answer. Beat both, then work the door again.",
                    pos  = "Temple of Uggalepih (!pos -50 -17 -154)",
                    done = { missionStatus = { 0, gte = 6 } },
                },
                {
                    text = "Report back at the Great Hall door -- Rank 9 waits.",
                    pos  = "Chateau d'Oraguille (!pos 0 -1 13)",
                },
            },
        },
        [22] = { -- BREAKING_BARRIERS (M9-1)
            name = "Breaking Barriers",
            steps = {
                {
                    text = "Take the errand at the Great Hall door in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 0 -1 13)",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Dig up the Figure of Titan at the marked spot in the Valley of Sorrows.",
                    pos  = "Valley of Sorrows (!pos 91 -3 -16)",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Dig up the Figure of Garuda at the marked spot in Xarcabard.",
                    pos  = "Xarcabard (!pos 179 -33 82)",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "The Batallia Downs spot wakes Suparna and its fledgling. Beat both, then dig again for the Figure of Leviathan.",
                    pos  = "Batallia Downs (!pos 210 17 -615)",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Carry all three figures back to the Great Hall door.",
                    pos  = "Chateau d'Oraguille (!pos 0 -1 13)",
                },
            },
        },
        [23] = { -- THE_HEIR_TO_THE_LIGHT (M9-2)
            name = "The Heir to the Light",
            steps = {
                {
                    text = "Go to Northern San d'Oria -- the cathedral is readying the Rites of Succession.",
                    pos  = "Northern San d'Oria",
                    done = { missionStatus = { 0, gte = 1 } },
                },
                {
                    text = "Enter Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille",
                    done = { missionStatus = { 0, gte = 2 } },
                },
                {
                    text = "Travel to Fei'Yin.",
                    pos  = "Fei'Yin",
                    done = { missionStatus = { 0, gte = 3 } },
                },
                {
                    text = "Win the battle waiting in Qu'Bia Arena.",
                    pos  = "Qu'Bia Arena",
                    done = { missionStatus = { 0, gte = 4 } },
                },
                {
                    text = "Return to Northern San d'Oria.",
                    pos  = "Northern San d'Oria",
                    done = { missionStatus = { 0, gte = 5 } },
                },
                {
                    text = "Present yourself at the Great Hall door in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 0 -1 13)",
                    done = { missionStatus = { 0, gte = 6 } },
                },
                {
                    text = "Go down to the Heavy Stone Door in King Ranperre's Tomb.",
                    pos  = "King Ranperre's Tomb (!pos -39 4 20)",
                    done = { missionStatus = { 0, gte = 7 } },
                },
                {
                    text = "Return to Halver -- Rank 10 and the San d'Orian Flag are yours.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                },
            },
        },
    },
}
