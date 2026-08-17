-- dwtracker data -- Windurst missions. Names generated Phase 0
-- (tools/dwtracker_names.py); steps HAND-AUTHORED Phase 2 from the mission
-- scripts (scripts/missions/windurst/) as ground truth.
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
--   * A repeat run on a DISJOINT status range gets the split-flow idiom
--     (FORMAT 6.8): first-run steps ride anyOf{ threshold,
--     completedMission }, repeat steps ride allOf{ completedMission,
--     threshold }. Windurst M3-2 is this line's only case.
return {
    kind = 'missions',
    log = 2,
    area = 'windurst_missions',
    label = "Windurst",
    entries = {
        [0] = { -- THE_HORUTOTO_RUINS_EXPERIMENT (M1-1)
            name = "The Horutoto Ruins Experiment",
            steps = {
                {
                    text = "Speak with Hakkuru-Rinkuru in the Orastery in Port Windurst.",
                    pos  = "Port Windurst (!pos -111 -4 101)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Examine the Gate: Magical Gizmo inside the Inner Horutoto Ruins.",
                    pos  = "Inner Horutoto Ruins (!pos 419 0 -27)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Six Magical Gizmos stand further in and one of them is broken. Examine them until you find it and take the Cracked Mana Orb.",
                    pos  = "Inner Horutoto Ruins (!pos 464 -3 100 / 406 -3 59 / 464 -3 20 / 295 -3 19)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Carry the orb back to Hakkuru-Rinkuru.",
                    pos  = "Port Windurst (!pos -111 -4 101)",
                },
            },
        },
        [1] = { -- THE_HEART_OF_THE_MATTER (M1-2)
            name = "The Heart of the Matter",
            steps = {
                {
                    text = "Speak with Apururu in Windurst Woods; she hands you six mana orbs.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Find Pore-Ohre out in East Sarutabaruta for the Southeastern Star Charm.",
                    pos  = "East Sarutabaruta (!pos 261 -17 -458)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Set all six orbs into the gizmos inside the Outer Horutoto Ruins, then work the gate they power.",
                    pos  = "Outer Horutoto Ruins (!pos 466 0 -660), gate at !pos 584 0 -660",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Gather all six orbs back out of the gizmos.",
                    pos  = "Outer Horutoto Ruins (!pos 466 0 -660)",
                    done = { missionStatus = { 2, gte = 5 } },
                },
                {
                    text = "Report to Apururu in Windurst Woods. Something may happen to the orbs on the way home -- go and tell her anyway.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                },
            },
        },
        [2] = { -- THE_PRICE_OF_PEACE (M1-3)
            name = "The Price of Peace",
            steps = {
                {
                    text = "Speak with Leepe-Hoppe in Windurst Waters and take the two offerings.",
                    pos  = "Windurst Waters (!pos 13 -9 -197)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Carry both into Giddeus: the food offering to Laa Mozi, the drink offering to Ghoo Pakya.",
                    pos  = "Giddeus (!pos -22 0 148 / -139 0 147)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Report to Ohbiru-Dohbiru in Windurst Waters.",
                    pos  = "Windurst Waters (!pos 23 -5 -193)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Close the mission with a gate guard.",
                    pos  = "Windurst Woods (!pos 106 -5 -23) / Windurst Waters (!pos -55 -8 227)",
                },
            },
        },
        [3] = { -- LOST_FOR_WORDS (M2-1)
            name = "Lost for Words",
            steps = {
                {
                    text = "Speak with Tosuka-Porika in Windurst Waters.",
                    pos  = "Windurst Waters (!pos -26 -6 103)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Find Nanaa Mihgo in Windurst Woods; she lends you the Lapis Monocle.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Search the fossil rocks in the Maze of Shakhrami until the monocle picks out the right one.",
                    pos  = "Maze of Shakhrami (!pos 17 18 184)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Report back to Nanaa Mihgo and take the Hideout Key.",
                    pos  = "Windurst Woods (!pos 62 -4 240)",
                    done = { missionStatus = { 2, gte = 5 } },
                },
                {
                    text = "Open the door the key fits, inside the Inner Horutoto Ruins.",
                    pos  = "Inner Horutoto Ruins (!pos -11 0 20)",
                    done = { missionStatus = { 2, gte = 6 } },
                },
                {
                    text = "Go to the House of the Hero in Windurst Walls.",
                    pos  = "Windurst Walls (!pos -26 -13 260)",
                    done = { missionStatus = { 2, gte = 7 } },
                },
                {
                    text = "Report to Tosuka-Porika in Windurst Waters.",
                    pos  = "Windurst Waters (!pos -26 -6 103)",
                },
            },
        },
        [4] = { -- A_TESTING_TIME (M2-2)
            name = "A Testing Time",
            repeatable = true,
            -- The doll's tally lives in a var the script does NOT clear on a
            -- successful run, so a repeat starts with the old count still on
            -- it. Reading that var here would send a repeater straight to the
            -- turn-in, so the hunt is described rather than tracked.
            steps = {
                {
                    text = "Speak with Moreno-Toeno in Windurst Waters and take the Creature Counter magic doll.",
                    pos  = "Windurst Waters (!pos 169 -1 159)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Hunt with the doll -- Tahrongi Canyon on a first run, the Buburimu Peninsula when repeating -- then take it back. Around thirty kills, and reporting in too early counts as a failure.",
                    pos  = "Windurst Waters (!pos 169 -1 159)",
                },
            },
        },
        [5] = { -- THE_THREE_KINGDOMS (M2-3)
            name = "The Three Kingdoms",
            steps = {
                {
                    text = "Take the Letter to the Consuls from Kupipi in Heavens Tower.",
                    pos  = "Heavens Tower (!pos 2 0 30)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Pick a consulate and present the letter there: Patt-Pott in Bastok's Metalworks, or Heruze-Moruze and then Kasaroro in Northern San d'Oria.",
                    pos  = "Metalworks (!pos 23 -17 42) / Northern San d'Oria (!pos -72 -3 34)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "See that errand through -- the journal carries it under the nation you chose.",
                    done = { missionStatus = { 2, gte = 6 } },
                },
                {
                    text = "Cross to the other nation's consulate for the second errand: Patt-Pott in the Metalworks, or Kasaroro in Northern San d'Oria.",
                    pos  = "Metalworks (!pos 23 -17 42) / Northern San d'Oria (!pos -72 -3 34)",
                    done = { missionStatus = { 2, gte = 8 } },
                },
                {
                    text = "Finish the second errand; it ends with the Kindred Report in your hands.",
                    done = { missionStatus = { 2, gte = 11 } },
                },
                {
                    text = "Take the report back to Kupipi -- Rank 3 and your Adventurer's Certificate.",
                    pos  = "Heavens Tower (!pos 2 0 30)",
                },
            },
        },
        [6] = { -- THE_THREE_KINGDOMS_SANDORIA (M2-3, first errand)
            name = "The Three Kingdoms San d'Oria",
            steps = {
                {
                    text = "Carry the request to Halver in Chateau d'Oraguille.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Hunt down Warchief Vatgit in Ghelsba Outpost.",
                    pos  = "Ghelsba Outpost",
                    done = { missionStatus = { 2, gte = 5 } },
                },
                {
                    text = "Report the kill to Kasaroro in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos -72 -3 34)",
                },
            },
        },
        [7] = { -- THE_THREE_KINGDOMS_BASTOK (M2-3, first errand)
            name = "The Three Kingdoms Bastok",
            steps = {
                {
                    text = "Introduce yourself to Pius at the consulate in Bastok's Metalworks.",
                    pos  = "Metalworks (!pos 99 -21 -12)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Collect three pickaxes from Grohm.",
                    pos  = "Metalworks (!pos -18 -11 -27)",
                    done = { missionStatus = { 2, gte = 5 } },
                },
                {
                    text = "Work the refinery in the Palborough Mines until an Onz of Mythril Sand comes out.",
                    pos  = "Palborough Mines (refiner lever at !pos 180 -32 167)",
                    done = {
                        allOf = {
                            { missionStatus = { 2, gte = 5 } },
                            { item = 599 }, -- ONZ_OF_MYTHRIL_SAND
                        },
                    },
                },
                {
                    text = "Trade the Onz of Mythril Sand to Patt-Pott in the Metalworks.",
                    pos  = "Metalworks (!pos 23 -17 42)",
                },
            },
        },
        [8] = { -- THE_THREE_KINGDOMS_SANDORIA2 (M2-3, second errand)
            name = "The Three Kingdoms San d'Oria",
            steps = {
                {
                    text = "Report to Halver in Chateau d'Oraguille; he sets you a trial.",
                    pos  = "Chateau d'Oraguille (!pos 2 0 0)",
                    done = { missionStatus = { 2, gte = 9 } },
                },
                {
                    text = "Prevail in the battle at Horlais Peak, in Ronfaure, and claim the Kindred Crest.",
                    pos  = "Horlais Peak",
                    done = { missionStatus = { 2, gte = 10 } },
                },
                {
                    text = "Bring the crest to Kasaroro in Northern San d'Oria.",
                    pos  = "Northern San d'Oria (!pos -72 -3 34)",
                },
            },
        },
        [9] = { -- THE_THREE_KINGDOMS_BASTOK2 (M2-3, second errand)
            name = "The Three Kingdoms Bastok",
            steps = {
                {
                    text = "Report to Pius at the Bastok consulate.",
                    pos  = "Metalworks (!pos 99 -21 -12)",
                    done = { missionStatus = { 2, gte = 9 } },
                },
                {
                    text = "Speak with Grohm; he readies you for a trial.",
                    pos  = "Metalworks (!pos -18 -11 -27)",
                    done = { missionStatus = { 2, gte = 10 } },
                },
                {
                    text = "Prevail in the battle at Waughroon Shrine, within the Palborough Mines, and claim the Kindred Crest.",
                    pos  = "Waughroon Shrine",
                    done = { missionStatus = { 2, gte = 11 } },
                },
                {
                    text = "Show the crest to Patt-Pott in the Metalworks.",
                    pos  = "Metalworks (!pos 23 -17 42)",
                },
            },
        },
        [10] = { -- TO_EACH_HIS_OWN_RIGHT (M3-1)
            name = "To Each His Own Right",
            steps = {
                {
                    text = "Speak with Kupipi in Heavens Tower and take the Starway Stairway bauble.",
                    pos  = "Heavens Tower (!pos 2 0 30)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Carry it down to Rhy Epocan in the Vestal Chambers.",
                    pos  = "Heavens Tower (!pos 2 -48 14)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Report to Hakkuru-Rinkuru in the Orastery in Port Windurst.",
                    pos  = "Port Windurst (!pos -111 -4 101)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Get through the trap door in Castle Oztroja.",
                    pos  = "Castle Oztroja (!pos 22 -1 -14)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Return to Rhy Epocan in the Vestal Chambers.",
                    pos  = "Heavens Tower (!pos 2 -48 14)",
                },
            },
        },
        [11] = { -- WRITTEN_IN_THE_STARS (M3-2)
            name = "Written in the Stars",
            repeatable = true,
            -- Windurst's divergent-repeat case: the first run walks statuses
            -- 1-2 (charm, then the Gate of Light), the repeat walks status 3
            -- alone (three Rusty Daggers). The script switches on "completed
            -- M3-2 OR completed M3-3", so both completions ride the
            -- disjunction. FORMAT 6.8 has the idiom.
            steps = {
                {
                    text = "Speak with Zubaba in Heavens Tower and take the Charm of Light.",
                    pos  = "Heavens Tower (!pos 15 -27 18)",
                    done = {
                        anyOf = {
                            { missionStatus = { 2, gte = 1 } },
                            { completedMission = { 2, 11 } },
                            { completedMission = { 2, 12 } },
                        },
                    },
                },
                {
                    text = "Carry the charm to the Gate of Light in the Inner Horutoto Ruins.",
                    pos  = "Inner Horutoto Ruins (!pos -331 0 139)",
                    done = {
                        anyOf = {
                            { missionStatus = { 2, gte = 2 } },
                            { completedMission = { 2, 11 } },
                            { completedMission = { 2, 12 } },
                        },
                    },
                },
                {
                    text = "Report back to Zubaba.",
                    pos  = "Heavens Tower (!pos 15 -27 18)",
                    done = {
                        anyOf = {
                            { completedMission = { 2, 11 } },
                            { completedMission = { 2, 12 } },
                        },
                    },
                },
                {
                    text = "Repeat run: ask Zubaba what she wants this time.",
                    pos  = "Heavens Tower (!pos 15 -27 18)",
                    done = {
                        allOf = {
                            {
                                anyOf = {
                                    { completedMission = { 2, 11 } },
                                    { completedMission = { 2, 12 } },
                                },
                            },
                            { missionStatus = { 2, gte = 3 } },
                        },
                    },
                },
                {
                    text = "Trade three Rusty Daggers to Zubaba.",
                    pos  = "Heavens Tower (!pos 15 -27 18)",
                },
            },
        },
        [12] = { -- A_NEW_JOURNEY (M3-3)
            name = "A New Journey",
            steps = {
                {
                    text = "Answer the Star-Crested Summons at the Vestal Chambers door in Heavens Tower.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Deliver the Letter to the Ambassador to Pakh Jatalfih in Ru'Lude Gardens.",
                    pos  = "Ru'Lude Gardens (!pos 34 8 -35)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Open a Cermet Door in Lower Delkfutt's Tower -- a Delkfutt Key traded to the door does it.",
                    pos  = "Lower Delkfutt's Tower (!pos 636 16 59)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Report back to Pakh Jatalfih.",
                    pos  = "Ru'Lude Gardens (!pos 34 8 -35)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Present yourself at the Windurstian embassy door in Ru'Lude Gardens -- Rank 4 waits.",
                    pos  = "Ru'Lude Gardens (!pos 31 9 -22)",
                },
            },
        },
        [13] = { -- MAGICITE (M4-1)
            name = "Magicite",
            steps = {
                {
                    text = "Call at the Windurstian embassy door in Ru'Lude Gardens for the Archducal Audience Permit.",
                    pos  = "Ru'Lude Gardens (!pos -31 7 -65)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Present the permit at the Audience Chamber door and take the letter meant for Aldo.",
                    pos  = "Ru'Lude Gardens (!pos 0 -5 66)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Carry the letter down to Aldo in Lower Jeuno.",
                    pos  = "Lower Jeuno (!pos 20 3 -58)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Recover three Magicite: the Orastone in Castle Oztroja's Altar Room, the Optistone in Davoi's Monastic Cavern, the Aurastone in Beadeaux's Qulun Dome.",
                    pos  = "Altar Room (!pos -344 25 43) / Monastic Cavern (!pos -160 -8 8) / Qulun Dome (!pos 11 25 -81)",
                    done = {
                        anyOf = {
                            {
                                allOf = {
                                    { missionStatus = { 2, gte = 3 } },
                                    { ki = 16 }, -- MAGICITE_ORASTONE
                                    { ki = 14 }, -- MAGICITE_OPTISTONE
                                    { ki = 15 }, -- MAGICITE_AURASTONE
                                },
                            },
                            { missionStatus = { 2, gte = 4 } },
                        },
                    },
                },
                {
                    text = "Hand all three stones over at the Audience Chamber door. Muckvix in Lower Jeuno lends the Yagudo Torch if Castle Oztroja is still barring your way.",
                    pos  = "Ru'Lude Gardens (!pos 0 -5 66)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Report back to Pakh Jatalfih at the embassy -- Rank 5 and the road to Fei'Yin follow.",
                    pos  = "Ru'Lude Gardens (!pos -32 9 -49)",
                },
            },
        },
        [14] = { -- THE_FINAL_SEAL (M5-1)
            name = "The Final Seal",
            steps = {
                {
                    text = "Take the new Fei'Yin seal at the Vestal Chambers door in Heavens Tower.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                    done = { missionStatus = { 2, gte = 10 } },
                },
                {
                    text = "Make your way north-east to Fei'Yin; something meets you at the gate.",
                    pos  = "Fei'Yin",
                    done = { missionStatus = { 2, gte = 11 } },
                },
                {
                    text = "Win the fight waiting in Qu'Bia Arena -- the seal is your entry -- and take the Burnt Seal from it.",
                    pos  = "Qu'Bia Arena",
                    done = { missionStatus = { 2, gte = 12 } },
                },
                {
                    text = "Bring the Burnt Seal back to the Vestal Chambers door.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                },
            },
        },
        [15] = { -- THE_SHADOW_AWAITS (M5-2)
            name = "The Shadow Awaits",
            steps = {
                {
                    text = "Answer the Star-Crested Summons at the Vestal Chambers door in Heavens Tower.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Climb Castle Zvahl and present yourself at the Throne Room door.",
                    pos  = "Throne Room (!pos -111 -6 0)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Bring down the Shadow Lord; the Shadow Fragment is waiting for you on the way out.",
                    pos  = "Throne Room",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Carry the fragment back to the Vestal Chambers door -- Rank 6, and the Zilart road opens.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                },
            },
        },
        [16] = { -- FULL_MOON_FOUNTAIN (M6-1)
            name = "Full Moon Fountain",
            steps = {
                {
                    text = "Speak with Hakkuru-Rinkuru in the Orastery and take the Southwestern Star Charm.",
                    pos  = "Port Windurst (!pos -111 -4 101)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Work the Gate: Magical Gizmo in the Outer Horutoto Ruins -- four Jacks answer. Put all four down.",
                    pos  = "Outer Horutoto Ruins (!pos -291 0 -659)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Work the gate again to open the way through.",
                    pos  = "Outer Horutoto Ruins (!pos -291 0 -659)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Step into the Full Moon Fountain.",
                    pos  = "Full Moon Fountain",
                },
            },
        },
        [17] = { -- SAINTLY_INVITATION (M6-2)
            name = "Saintly Invitation",
            steps = {
                {
                    text = "Answer the summons at the Vestal Chambers door and take the Holy One's Invitation.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Win the battle at Balga's Dais, within the Horutoto Ruins, and claim the champion's certificate.",
                    pos  = "Balga's Dais",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Carry the invitation to Kaa Toru the Just, deep inside Castle Oztroja.",
                    pos  = "Castle Oztroja (!pos -100 -62 145)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Bring the Holy One's Oath back to the Vestal Chambers door -- Rank 7 follows.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                },
            },
        },
        [18] = { -- THE_SIXTH_MINISTRY (M7-1)
            name = "The Sixth Ministry",
            steps = {
                {
                    text = "Speak with Tosuka-Porika in Windurst Waters and take the Optistery Ring.",
                    pos  = "Windurst Waters (!pos -26 -6 103)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Find the Tome of Magic down in the Toraimarai Canal, under Windurst.",
                    pos  = "Toraimarai Canal (!pos 132 12 -19)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Report back to Tosuka-Porika.",
                    pos  = "Windurst Waters (!pos -26 -6 103)",
                },
            },
        },
        [19] = { -- AWAKENING_OF_THE_GODS (M7-2)
            name = "Awakening of the Gods",
            steps = {
                {
                    text = "Hear Leepe-Hoppe and Kerutoto out in Windurst Waters -- they have more than one thing to say.",
                    pos  = "Windurst Waters (!pos 13 -9 -197 / 13 -5 -157)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Cross to Kazham and speak with Romaa Mihgo.",
                    pos  = "Kazham (!pos 29 -13 -176)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Speak with Vanono, also in Kazham.",
                    pos  = "Kazham (!pos -23 -5 -23)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Trade a Cursed Key at the Granite Door in the Temple of Uggalepih to have the blank book written.",
                    pos  = "Temple of Uggalepih (!pos 340 0 329)",
                    done = { missionStatus = { 2, gte = 5 } },
                },
                {
                    text = "Bring the Book of the Gods back to Leepe-Hoppe in Windurst Waters.",
                    pos  = "Windurst Waters (!pos 13 -9 -197)",
                },
            },
        },
        [20] = { -- VAIN (M8-1)
            name = "Vain",
            steps = {
                {
                    text = "Speak with Moreno-Toeno in Windurst Waters and take the Star Seeker.",
                    pos  = "Windurst Waters (!pos 169 -1 159)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Follow where the Star Seeker leads. It stirs across the outlands and settles on the Qu'Hau Spring in Ro'Maeve.",
                    pos  = "Ro'Maeve (!pos 0 -29 64)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Take the drained seeker to Sedal-Godjal, hiding out in Davoi.",
                    pos  = "Davoi (!pos 185 -3 -116)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Trade a Curse Wand to Sedal-Godjal.",
                    pos  = "Davoi (!pos 185 -3 -116)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Report back to Moreno-Toeno in Windurst Waters.",
                    pos  = "Windurst Waters (!pos 169 -1 159)",
                },
            },
        },
        [21] = { -- THE_JESTER_WHOD_BE_KING (M8-2)
            name = "The Jester Who'd be King",
            steps = {
                {
                    text = "Speak with Apururu in Windurst Woods; she gives you the Manustery Ring.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Collect the other three ministry rings: Tosuka-Porika in Windurst Waters, Sedal-Godjal in Davoi, and the marked spot in Fei'Yin.",
                    pos  = "Windurst Waters (!pos -26 -6 103) / Davoi (!pos 185 -3 -116) / Fei'Yin",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Show all four rings to Apururu.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Speak with Kupipi in Heavens Tower.",
                    pos  = "Heavens Tower (!pos 2 0 30)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Work the cracked wall in the Outer Horutoto Ruins -- two Queens answer. Put both down.",
                    pos  = "Outer Horutoto Ruins (!pos -423 0 619)",
                    done = { missionStatus = { 2, gte = 5 } },
                },
                {
                    text = "Work the wall again for the Orastery Ring.",
                    pos  = "Outer Horutoto Ruins (!pos -423 0 619)",
                    done = { missionStatus = { 2, gte = 6 } },
                },
                {
                    text = "Report to Apururu with the fifth ring.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                    done = { missionStatus = { 2, gte = 7 } },
                },
                {
                    text = "See Shantotto in Windurst Walls for the Glove of Perpetual Twilight.",
                    pos  = "Windurst Walls (!pos 122 -2 112)",
                    done = { missionStatus = { 2, gte = 8 } },
                },
                {
                    text = "Take the glove to Apururu.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                    done = { missionStatus = { 2, gte = 9 } },
                },
                {
                    text = "Open the Gate of the Dark in the Inner Horutoto Ruins.",
                    pos  = "Inner Horutoto Ruins (!pos -228 0 99)",
                    done = { missionStatus = { 2, gte = 10 } },
                },
                {
                    text = "Report to Apururu -- Rank 9 waits.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                },
            },
        },
        [22] = { -- DOLL_OF_THE_DEAD (M9-1)
            name = "Doll of the Dead",
            steps = {
                {
                    text = "Speak with Apururu in Windurst Woods.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Go up into Heavens Tower.",
                    pos  = "Heavens Tower",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Present yourself at the Vestal Chambers door.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Report back to Apururu.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "See Yoran-Oran in Windurst Walls; he turns a Jug of Humus into a Clump of Goobbue Humus.",
                    pos  = "Windurst Walls (!pos -109 -14 203)",
                    done = { missionStatus = { 2, gte = 5 } },
                },
                {
                    text = "Trade the humus to the Mandragora Warden in the Boyahda Tree and take the letter it leaves you.",
                    pos  = "The Boyahda Tree (!pos 81 7 139)",
                    done = { missionStatus = { 2, gte = 6 } },
                },
                {
                    text = "Carry the letter to Apururu.",
                    pos  = "Windurst Woods (!pos -11 -2 13)",
                    done = { missionStatus = { 2, gte = 7 } },
                },
                {
                    text = "Step into the Full Moon Fountain.",
                    pos  = "Full Moon Fountain",
                },
            },
        },
        [23] = { -- MOON_READING (M9-2)
            name = "Moon Reading",
            steps = {
                {
                    text = "Answer the summons at the Vestal Chambers door in Heavens Tower.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                    done = { missionStatus = { 2, gte = 1 } },
                },
                {
                    text = "Recover three Ancient Verses -- the Qu'Hau Spring in Ro'Maeve, the Chamber of Oracles, and a marked spot in the Temple of Uggalepih -- then report back.",
                    pos  = "Ro'Maeve (!pos 0 -29 64) / Temple of Uggalepih (!pos -239 -1 -18)",
                    done = { missionStatus = { 2, gte = 2 } },
                },
                {
                    text = "Return to the Full Moon Fountain.",
                    pos  = "Full Moon Fountain",
                    done = { missionStatus = { 2, gte = 3 } },
                },
                {
                    text = "Report again at the Vestal Chambers door.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                    done = { missionStatus = { 2, gte = 4 } },
                },
                {
                    text = "Hear the last of it out at the Vestal Chambers door, then step into Windurst Walls -- Rank 10 and the Windurstian Flag.",
                    pos  = "Heavens Tower (!pos 0 -49 37)",
                },
            },
        },
    },
}
