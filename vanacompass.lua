-- VanaCompass: an in-game discovery guide for DriftwoodXI and Ashita 4.

addon.name    = 'vanacompass';
addon.author  = 'Elcatrin (Spacedandy)';
addon.version = '0.14.1';
addon.desc    = 'Find spells, crafting materials, gear, NMs, quests, missions, and ports.';

require('common');

local chat       = require('chat');
local imgui      = require('imgui');
local settings   = require('settings');
local theme      = require('dwtheme');
local spellShops = require('data.vendors');
local shops      = require('data.shops');
local guildShops = require('data.guild_shops');
local teleports  = require('data.teleports');
local questStarts = require('data.quest_starts');
local missionStarts = require('data.mission_starts');
local gridPages = require('data.grid_calibrations');
local acquisition = require('data.acquisition');
local spellQuestSources = require('data.spell_quests');

-- Welcome is intentionally omitted: it is the permanent settings surface
-- used to restore any optional tab that a player has hidden.
local TAB_DEFINITIONS = {
    { key = 'spells', label = 'Spells' },
    { key = 'vendorGear', label = 'Vendor Gear' },
    { key = 'supplies', label = 'Supplies' },
    { key = 'materials', label = 'Materials' },
    { key = 'drops', label = 'Drops' },
    { key = 'nms', label = 'NMs' },
    { key = 'quests', label = 'Quests' },
    { key = 'mainStory', label = 'Main Story' },
};

local defaultConfig = T{
    tabs = T{
        spells = true,
        vendorGear = false,
        supplies = false,
        materials = false,
        drops = false,
        nms = false,
        quests = false,
        mainStory = false,
    },
};

local config = defaultConfig;
local okSettings, loadedSettings = pcall(settings.load, defaultConfig);
if okSettings and loadedSettings ~= nil then
    config = loadedSettings;
end

-- v0.12.3 stored Weapons and Armor separately. Migrate either visible choice
-- into Vendor Gear, then remove the legacy keys so the migration runs once.
local function migrateLegacyGearTabs()
    if type(config.tabs) ~= 'table' or
        (type(config.tabs.weapons) ~= 'boolean' and type(config.tabs.armor) ~= 'boolean') then
        return false;
    end
    config.tabs.vendorGear = config.tabs.weapons == true or config.tabs.armor == true;
    config.tabs.weapons = nil;
    config.tabs.armor = nil;
    return true;
end
local migratedLegacyGearTabs = migrateLegacyGearTabs();

local function normalizeConfig()
    if type(config.tabs) ~= 'table' then config.tabs = T{}; end
    for _, tab in ipairs(TAB_DEFINITIONS) do
        if type(config.tabs[tab.key]) ~= 'boolean' then
            config.tabs[tab.key] = defaultConfig.tabs[tab.key];
        end
    end
end

normalizeConfig();

local QUEST_AREAS = {
    require('data.quests.sandoria_quests'),
    require('data.quests.bastok_quests'),
    require('data.quests.windurst_quests'),
    require('data.quests.jeuno_quests'),
    require('data.quests.otherareas_quests'),
    require('data.quests.outlands_quests'),
};

local MISSION_AREAS = {
    require('data.missions.sandoria_missions'),
    require('data.missions.bastok_missions'),
    require('data.missions.windurst_missions'),
    require('data.missions.zilart_missions'),
};

-- Ordered prerequisite chains for the advanced jobs supported by the current
-- Driftwood quest data. References use the server's real quest log and id so
-- active/completed tracker state remains authoritative.
local JOB_UNLOCK_CHAINS = {
    { jobId = 7, jobName = 'Paladin', quests = {
        { 0, 10, grid = 'F-7' }, { 0, 19, grid = 'F-7' }, { 0, 29, grid = 'F-7' },
    } },
    { jobId = 8, jobName = 'Dark Knight', quests = { { 1, 28, grid = 'J-7' } } },
    { jobId = 9, jobName = 'Beastmaster', quests = {
        { 3, 4, grid = 'G-7' }, { 3, 5, grid = 'G-11' }, { 3, 19, grid = 'G-7' },
    } },
    { jobId = 10, jobName = 'Bard', quests = {
        { 3, 11, grid = 'I-8' }, { 3, 12, grid = 'G-9' }, { 3, 20, grid = 'B-7' },
    } },
    { jobId = 11, jobName = 'Ranger', quests = { { 2, 31, grid = 'K-7' } } },
    { jobId = 12, jobName = 'Samurai', quests = { { 5, 129, grid = 'K-8' } } },
    { jobId = 13, jobName = 'Ninja', quests = { { 1, 60, grid = 'J-5' } } },
    {
        jobId = 14,
        jobName = 'Dragoon',
        quests = {
            {
                0,
                93,
                grid = 'I-9',
                start = { contact = 'Ceraulian', kind = 'NPC', location = "Port San d'Oria (!pos 0 -8 -122)" },
                steps = {
                    { text = 'Speak with Ceraulian in Cargo Room A to hear about the wyvern egg, then find Novalmauge.', pos = "Port San d'Oria (!pos 0 -8 -122)" },
                    { text = 'Speak with Novalmauge for the history behind the egg.', pos = 'Bostaunieux Oubliette (!pos 30 -24 20)' },
                    { text = 'Speak with Morjean in the Cathedral manuscript room to formally begin The Holy Crest.', pos = "Northern San d'Oria (!pos 99 0 114)" },
                    { text = 'Bring Pickaxes to the Maze of Shakhrami and trade one to an Excavation Point until you receive a Wyvern Egg.', pos = 'Maze of Shakhrami' },
                    { text = 'Return to Morjean with the Wyvern Egg.', pos = "Northern San d'Oria (!pos 99 0 114)" },
                    { text = "Trade the Wyvern Egg to the ??? at the base of Drogaroga's Spine.", pos = 'Meriphataud Mountains (K-8)' },
                    { text = 'Speak with Rahal to receive the Dragon Curse Remedy.', pos = "Chateau d'Oraguille (!pos -28 0 -6)" },
                    { text = 'Examine the Hut Door and defeat Cyranuce M Cutauleon in the battlefield to unlock Dragoon.', pos = 'Ghelsba Outpost (F-10/G-10)' },
                },
            },
        },
    },
    { jobId = 15, jobName = 'Summoner', quests = { { 2, 75, grid = 'G-3' } } },
};

local JOB_UNLOCK_BY_KEY = {};
for jobOrder, chain in ipairs(JOB_UNLOCK_CHAINS) do
    for chainStep, reference in ipairs(chain.quests) do
        reference.jobId = chain.jobId;
        reference.jobName = chain.jobName;
        reference.jobOrder = jobOrder;
        reference.chainStep = chainStep;
        reference.chainCount = #chain.quests;
        JOB_UNLOCK_BY_KEY[reference[1] .. ':' .. reference[2]] = reference;
    end
end

local PORT_ZONE_ALIASES = {
    ['Al Zahbi'] = 'Aht Urhgan Whitegate',
    ['Windurst Waters North'] = 'Windurst Waters',
    ['Windurst Waters South'] = 'Windurst Waters',
};

local SLOT_NAMES = {
    [1] = 'Main', [2] = 'Sub', [3] = 'Ranged', [4] = 'Ammo',
    [5] = 'Head', [6] = 'Body', [7] = 'Hands', [8] = 'Legs', [9] = 'Feet',
    [10] = 'Neck', [11] = 'Waist', [12] = 'Ear', [13] = 'Ear',
    [14] = 'Ring', [15] = 'Ring', [16] = 'Back',
};

local WEAPON_TYPES = {
    [1] = 'Hand-to-Hand', [2] = 'Dagger', [3] = 'Sword', [4] = 'Great Sword',
    [5] = 'Axe', [6] = 'Great Axe', [7] = 'Scythe', [8] = 'Polearm',
    [9] = 'Katana', [10] = 'Great Katana', [11] = 'Club', [12] = 'Staff',
    [25] = 'Archery', [26] = 'Marksmanship', [27] = 'Throwing',
};

local SPELL_TYPES = {
    -- ISpell.Type values used by FFXI's spell resources. Type 8 is Trust
    -- magic, which has no vendor scrolls and therefore remains unlisted.
    [1] = 'White Magic', [2] = 'Black Magic', [3] = 'Summoning',
    [4] = 'Ninjutsu', [5] = 'Bard Song', [6] = 'Blue Magic',
    [7] = 'Geomancy',
};

local DROP_CATEGORY_NAMES = {
    [2] = 'Weapons',
    [3] = 'Armor',
};

-- These shops explicitly reject players who lack the key item. Keep the
-- warning on the vendor row because many scrolls have an unrestricted
-- alternate source.
local VENDOR_ACCESS_REQUIREMENTS = {
    Amalasanda = 'Requires Tenshodo membership. Complete Tenshodo Membership in Lower Jeuno.',
    Jabbar = 'Requires Tenshodo membership. Complete Tenshodo Membership in Lower Jeuno.',
};

-- FFXI's labeled town-map cells are usually 40 world units wide. Vendor
-- records pair verified grid cells with exact world positions, letting us
-- solve each map's origin without hard-coding offsets. A calibration is
-- accepted only when at least two independent anchors agree on both axes;
-- split/multi-map zones fail that test and need a verified override below.
local GRID_CELL_SIZE = 40;

local function buildGridCalibrations()
    local candidates, seen = {}, {};

    local function collect(catalog)
        for _, product in pairs(catalog) do
            for _, vendor in ipairs(product.vendors or {}) do
                if vendor.zoneId ~= nil and vendor.x ~= nil and vendor.y ~= nil and
                    vendor.wx ~= nil and vendor.wz ~= nil then
                    local key = string.format('%d:%.3f:%.3f:%d:%d',
                        vendor.zoneId, vendor.wx, vendor.wz, vendor.x, vendor.y);
                    if not seen[key] then
                        seen[key] = true;
                        local row = candidates[vendor.zoneId] or {
                            count = 0,
                            xLow = -math.huge,
                            xHigh = math.huge,
                            zLow = -math.huge,
                            zHigh = math.huge,
                        };
                        row.count = row.count + 1;
                        row.xLow = math.max(row.xLow, vendor.wx - vendor.x * GRID_CELL_SIZE);
                        row.xHigh = math.min(row.xHigh, vendor.wx - (vendor.x - 1) * GRID_CELL_SIZE);
                        row.zLow = math.max(row.zLow, vendor.wz + (vendor.y - 1) * GRID_CELL_SIZE);
                        row.zHigh = math.min(row.zHigh, vendor.wz + vendor.y * GRID_CELL_SIZE);
                        candidates[vendor.zoneId] = row;
                    end
                end
            end
        end
    end

    collect(spellShops);
    collect(shops);

    local result = {};
    for zoneId, row in pairs(candidates) do
        if row.count >= 2 and row.xLow < row.xHigh and row.zLow < row.zHigh then
            result[zoneId] = {
                originX = (row.xLow + row.xHigh) / 2,
                originZ = (row.zLow + row.zHigh) / 2,
                anchors = row.count,
            };
        end
    end
    return result;
end

local GRID_CALIBRATIONS = buildGridCalibrations();

-- Windurst Waters uses two different map images inside zone 238.  Their grid
-- labels overlap, so one zone-wide transform can never be correct.  The maps
-- occupy separate world-coordinate bands and use these clean 40-unit origins,
-- verified against all four Home Points and the shop NPC anchors.
local WINDURST_WATERS_GRIDS = {
    north = { originX = -280, originZ = 400 },
    south = { originX = -360, originZ = 120 },
};

-- Crawler's Nest (zone 197) has separate entrance, north, and
-- south/apparatus map images. Unlike the town maps, their labeled cells are
-- 80 world units wide. Floor height separates the entrance map; the two
-- deeper maps occupy distinct coordinate regions around their connections.
-- These transforms are cross-checked against the Survival Guide, both
-- Grounds Tomes, Awd Goggie, Queen Crawler, and the Strange Apparatus.
local CRAWLERS_NEST_GRIDS = {
    entrance = { originX = -600, originZ = 600, cellSize = 80 },
    north = { originX = -600, originZ = 800, cellSize = 80 },
    south = { originX = -600, originZ = 280, cellSize = 80 },
};

local function crawlersNestGrid(x, groundY, height)
    if height < -15 then
        return CRAWLERS_NEST_GRIDS.entrance;
    end
    if groundY < -100 or (groundY <= 180 and x < -100) then
        return CRAWLERS_NEST_GRIDS.south;
    end
    return CRAWLERS_NEST_GRIDS.north;
end

-- Explicit single-map origins for zones whose published NPC grid labels land
-- on opposite sides of a sub-unit boundary.  Lower Jeuno's shop anchors miss
-- intersection by less than one world unit; both Home Points independently
-- confirm this clean origin (#1 G-11 and #2 I-5).
local GRID_OVERRIDES = {
    [87]  = { originX = -520, originZ = 240 }, -- Bastok Markets [S]
    [245] = { originX = -340, originZ = 240 }, -- Lower Jeuno
    [246] = { originX = -380, originZ = 300 }, -- Port Jeuno
    [247] = { originX = -260, originZ = 320 }, -- Rabao
    [252] = { originX = -320, originZ = 300 }, -- Norg
};

local state = {
    open = { false },
    spellSearch = { '' },
    itemSearch = { '' },
    materialSearch = { '' },
    dropSearch = { '' },
    nmSearch = { '' },
    questSearch = { '' },
    missionSearch = { '' },
    spellMode = 1,
    spellSort = 1,
    spellTypeFilter = '',
    showAllSpells = { false },
    spellCatalogVersion = 0,
    spellTypeNames = {},
    spellViewCache = nil,
    itemMode = 'weapon',
    vendorGearCategory = 'weapon',
    dropCategory = 0,
    dropTypeFilter = '',
    dropTypeNames = { [0] = {}, [2] = {}, [3] = {} },
    dropSort = 1,
    dropItems = {},
    dropViewCache = nil,
    selectedDropItem = nil,
    nmSort = 1,
    nms = {},
    nmViewCache = nil,
    selectedNm = nil,
    itemSorts = { weapon = 2, armor = 2, supply = 1 },
    itemTypeFilters = { weapon = '', armor = '' },
    myLevel = { false },
    spells = {},
    items = { weapon = {}, armor = {}, supply = {} },
    materials = {},
    materialViewCache = nil,
    selectedMaterial = nil,
    quests = {},
    missions = {},
    questMode = 1,
    storyMode = 0,
    showAboveLevel = { false },
    showOtherArtifactJobs = { false },
    showCompletedQuests = { true },
    questCompletionKnown = false,
    completedQuestChunks = {},
    activeQuestIds = {},
    activeQuestSteps = {},
    showCompletedMissions = { true },
    missionCompletionKnown = false,
    completedMissionChunks = {},
    activeMissionIds = {},
    activeMissionSteps = {},
    missionSyncInbound = false,
    missionSyncStatus = 'Completion status not synced.',
    selectedSpell = nil,
    selectedItems = { weapon = nil, armor = nil, supply = nil },
    selectedQuest = nil,
    selectedMission = nil,
    currentLocation = nil,
    locationUpdatedAt = -1,
    showBrowserList = { true },
    sourcePages = {},
    errorReported = false,
    visibleTabs = {},
};

for _, tab in ipairs(TAB_DEFINITIONS) do
    state.visibleTabs[tab.key] = { config.tabs[tab.key] };
end

local function applyConfiguredTabs()
    normalizeConfig();
    for _, tab in ipairs(TAB_DEFINITIONS) do
        state.visibleTabs[tab.key][1] = config.tabs[tab.key];
    end
end

local function saveVisibleTabs()
    normalizeConfig();
    for _, tab in ipairs(TAB_DEFINITIONS) do
        config.tabs[tab.key] = state.visibleTabs[tab.key][1];
    end
    pcall(settings.save);
end

pcall(settings.register, 'settings', 'vanacompass_settings_update', function(s)
    if s ~= nil then
        config = s;
        local migrated = migrateLegacyGearTabs();
        applyConfiguredTabs();
        if migrated then pcall(settings.save); end
    end
end);
if migratedLegacyGearTabs then pcall(settings.save); end

local lower;

local function entryMinimumLevel(entry)
    local first = entry.steps and entry.steps[1];
    local text = lower(first and first.text or '');
    local level = text:match('level%s+(%d+)')
        or text:match('level%s+of%s+(%d+)')
        or text:match('at%s+level%s+(%d+)');
    return tonumber(level);
end

local function isArtifactQuest(entry)
    if lower(entry.name):find('borghertz', 1, true) then return true; end
    for _, step in ipairs(entry.steps or {}) do
        local text = lower(step.text);
        if (text:find('artifact', 1, true) and
            (text:find('main job', 1, true) or text:find('gauntlet', 1, true))) then
            return true;
        end
        if (text:find('borghertz', 1, true) and text:find('main job', 1, true)) then
            return true;
        end
    end
    return false;
end

lower = function (value)
    return string.lower(value or '');
end;

local function pushSelectedButton(selected)
    if not selected then return false; end
    local color = theme.colors.hint;
    imgui.PushStyleColor(ImGuiCol_Button, { color[1], color[2], color[3], 0.52 });
    return true;
end

local function textColoredWrapped(color, value)
    imgui.PushStyleColor(ImGuiCol_Text, color);
    imgui.TextWrapped(value);
    imgui.PopStyleColor();
end

local function textDisabledWrapped(value)
    textColoredWrapped(theme.colors.dim, value);
end

local function pageGridCalibration(zoneId, subMapNum)
    local pages = gridPages[zoneId];
    if pages == nil then return nil; end
    if #pages == 1 then return pages[1]; end
    -- Ashita exposes the client's internal map-DAT key here, not a sequential
    -- page number. Multi-page zones must provide an explicit key mapping; an
    -- ordered page list is not enough to select a floor safely.
    return nil;
end

local function currentGrid(zoneId, x, groundY, height, subMapNum)
    local calibration;
    if zoneId == 238 or zoneId == 94 then
        calibration = groundY < -80 and WINDURST_WATERS_GRIDS.south or WINDURST_WATERS_GRIDS.north;
    elseif zoneId == 197 then
        -- Keep the independently verified positional selector as a fallback
        -- for private servers that do not populate the client sub-map field.
        calibration = crawlersNestGrid(x, groundY, height);
    else
        calibration = GRID_OVERRIDES[zoneId] or pageGridCalibration(zoneId, subMapNum) or
            GRID_CALIBRATIONS[zoneId];
    end
    if calibration == nil then return nil; end
    local cellSize = calibration.cellSize or GRID_CELL_SIZE;
    local column = math.floor((x - calibration.originX) / cellSize) + 1;
    local row = math.floor((calibration.originZ - groundY) / cellSize) + 1;
    if column < 1 or column > 26 or row < 1 or row > 99 then return nil; end
    return string.char(64 + column) .. '-' .. tostring(row);
end

local function refreshCurrentLocation()
    local now = os.clock();
    if state.locationUpdatedAt >= 0 and now - state.locationUpdatedAt < 0.20 then return; end
    state.locationUpdatedAt = now;

    local ok, location = pcall(function ()
        local memory = AshitaCore:GetMemoryManager();
        local player = memory:GetPlayer();
        local party = memory:GetParty();
        if player == nil or party == nil or player:GetLoginStatus() ~= 2 or player:GetIsZoning() ~= 0 then
            return nil;
        end
        local index = party:GetMemberTargetIndex(0);
        if index == nil or index <= 0 then return nil; end
        local entity = memory:GetEntity();
        local zoneId = party:GetMemberZone(0);
        -- Ashita names X/Y as the ground plane and Z as height. FFXI's !pos
        -- convention prints those in X, height, ground-Y order.
        local x = entity:GetLocalPositionX(index);
        local groundY = entity:GetLocalPositionY(index);
        local height = entity:GetLocalPositionZ(index);
        local subMapNum = player:GetSubMapNum();
        local zone = AshitaCore:GetResourceManager():GetString('zones.names', zoneId) or
            ('Zone ' .. tostring(zoneId));
        return {
            zoneId = zoneId,
            zone = zone,
            grid = currentGrid(zoneId, x, groundY, height, subMapNum),
            subMap = subMapNum,
            pos = string.format('!pos %.1f %.1f %.1f', x, height, groundY),
        };
    end);
    state.currentLocation = ok and location or nil;
end

local function renderCurrentLocation()
    refreshCurrentLocation();
    imgui.TextColored(theme.colors.hint, 'Current location:'); imgui.SameLine();
    local location = state.currentLocation;
    if location == nil then
        imgui.TextDisabled('Unavailable while logging in or zoning.');
        return;
    end
    imgui.Text(location.zone);
    -- Keep navigation data readable when the window is narrowed.  A single
    -- long line was clipped by ImGui, which made grid and !pos appear to
    -- vanish even though the values were still updating.
    if imgui.GetWindowWidth() >= 760 then imgui.SameLine(); end
    imgui.TextDisabled('Grid:'); imgui.SameLine();
    if location.grid ~= nil then
        imgui.Text(location.grid);
        if imgui.IsItemHovered() then
            imgui.SetTooltip('Ashita client sub-map index: ' .. tostring(location.subMap or 'unavailable'));
        end
    else
        imgui.TextDisabled('unavailable');
        if imgui.IsItemHovered() then
            imgui.SetTooltip('This zone has no unambiguous single-map calibration yet.');
        end
    end
    if imgui.GetWindowWidth() >= 540 then imgui.SameLine(); end
    imgui.TextDisabled(location.pos);
end

local QUEST_JOB_NAMES = {
    [1] = 'warrior', [2] = 'monk', [3] = 'white mage', [4] = 'black mage',
    [5] = 'red mage', [6] = 'thief', [7] = 'paladin', [8] = 'dark knight',
    [9] = 'beastmaster', [10] = 'bard', [11] = 'ranger', [12] = 'samurai',
    [13] = 'ninja', [14] = 'dragoon', [15] = 'summoner', [16] = 'blue mage',
    [17] = 'corsair', [18] = 'puppetmaster', [19] = 'dancer', [20] = 'scholar',
    [21] = 'geomancer', [22] = 'rune fencer',
};

local function entryJob(entry)
    for _, step in ipairs(entry.steps or {}) do
        local text = lower(step.text);
        if text:find('main job', 1, true) then
            for jobId, jobName in pairs(QUEST_JOB_NAMES) do
                if text:find(jobName, 1, true) then return jobId; end
            end
        end
    end
    return nil;
end

local function splitFields(value, separator)
    local parts = {};
    for piece in string.gmatch((value or '') .. separator, '([^' .. separator .. ']*)' .. separator) do
        parts[#parts + 1] = piece;
    end
    return parts;
end

local function completedMission(log, id)
    local chunks = state.completedMissionChunks[log];
    if chunks == nil then return false; end
    local chunk = chunks[math.floor(id / 32)];
    return chunk ~= nil and bit.band(chunk, bit.lshift(1, id % 32)) ~= 0;
end

local function completedQuest(log, id)
    local chunks = state.completedQuestChunks[log];
    if chunks == nil then return false; end
    local chunk = chunks[math.floor(id / 32)];
    return chunk ~= nil and bit.band(chunk, bit.lshift(1, id % 32)) ~= 0;
end

local function activeQuest(log, id)
    return state.activeQuestIds[log] ~= nil and state.activeQuestIds[log][id] == true;
end

local function activeMission(log, id)
    return state.activeMissionIds[log] == id;
end

local function questProgress(log, id)
    return state.activeQuestSteps[log] ~= nil and state.activeQuestSteps[log][id] or nil;
end

local function missionProgress(log, id)
    local row = state.activeMissionSteps[log];
    return row ~= nil and row.id == id and row or nil;
end

local function requestMissionSync()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    if player == nil or player:GetLoginStatus() ~= 2 then
        state.missionSyncStatus = 'Log in before syncing completion status.';
        return;
    end
    state.missionSyncStatus = 'Syncing completion status...';
    AshitaCore:GetChatManager():QueueCommand(1, '!dwt sync');
end

local function normalizeName(value)
    return lower(value):gsub('[^%w]', '');
end

local function normalizeZone(value)
    local zone = (value or ''):gsub('%[S%]', '(S)'):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '');
    return PORT_ZONE_ALIASES[zone] or zone;
end

local spellVendorsByName = {};
for name, rows in pairs(spellShops) do
    spellVendorsByName[normalizeName(name)] = rows;
end

local teleportZoneNames = {};
for zone in pairs(teleports) do
    teleportZoneNames[#teleportZoneNames + 1] = zone;
end
table.sort(teleportZoneNames, function (a, b) return #a > #b; end);

local function jobsText(mask)
    local names = {};
    local resources = AshitaCore:GetResourceManager();
    for job = 1, 22 do
        if bit.band(mask or 0, math.pow(2, job)) ~= 0 then
            names[#names + 1] = resources:GetString('jobs.names_abbr', job) or tostring(job);
        end
    end
    return table.concat(names, ' ');
end

local function slotsText(mask)
    local names = {};
    local added = {};
    for slot = 1, 16 do
        if bit.band(mask or 0, math.pow(2, slot - 1)) ~= 0 then
            local name = SLOT_NAMES[slot] or tostring(slot);
            if not added[name] then
                names[#names + 1] = name;
                added[name] = true;
            end
        end
    end
    return table.concat(names, ', ');
end

local function spellLevels(resource)
    local parts = {};
    local resources = AshitaCore:GetResourceManager();
    for job = 1, 22 do
        local level = resource.LevelRequired[job + 1];
        if level ~= nil and level > 0 and level < 100 then
            parts[#parts + 1] = string.format('%s %d', resources:GetString('jobs.names_abbr', job) or job, level);
        end
    end
    return table.concat(parts, ', ');
end

local function vendorGilPrice(vendor)
    if vendor.buyMax ~= nil and vendor.buyMax > 0 then return vendor.buyMax; end
    if vendor.price ~= nil and vendor.price > 0 then return vendor.price; end
    local notes = vendor.notes or '';
    -- Variable-price shops are written as "450-515 Gil". The shopping bill
    -- is explicitly a cheapest-vendor estimate, so use the low end.
    local amount = notes:match('([%d,]+)%s*%-%s*[%d,]+%s*[Gg][Ii][Ll]') or
        notes:match('([%d,]+)%s*[Gg][Ii][Ll]');
    if amount == nil then return nil; end
    return tonumber((amount:gsub(',', '')));
end

local function cheapestVendorGil(rows)
    local cheapest = nil;
    for _, vendor in ipairs(rows) do
        local price = vendorGilPrice(vendor);
        if price ~= nil and (cheapest == nil or price < cheapest) then cheapest = price; end
    end
    return cheapest;
end

local function rebuildCatalogs()
    local resources = AshitaCore:GetResourceManager();
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local selectedSpellId = state.selectedSpell and state.selectedSpell.id or nil;
    local selectedItemIds = {};
    for category, selected in pairs(state.selectedItems) do
        selectedItemIds[category] = selected and selected.id or nil;
    end
    local selectedMaterialId = state.selectedMaterial and state.selectedMaterial.id or nil;
    local selectedNmKey = state.selectedNm and state.selectedNm.key or nil;

    state.spells = {};
    state.items = { weapon = {}, armor = {}, supply = {} };
    state.selectedSpell = nil;
    state.selectedItems = { weapon = nil, armor = nil, supply = nil };
    state.materials = {};
    state.selectedMaterial = nil;
    state.materialViewCache = nil;

    for id = 1, 1299 do
        local resource = resources:GetSpellById(id);
        if resource ~= nil and resource.Name ~= nil and resource.Name[1] ~= nil and resource.Name[1] ~= '' then
            local normalizedName = normalizeName(resource.Name[1]);
            local rows = spellVendorsByName[normalizedName] or {};
            local itemId = acquisition.spellItems[normalizedName];
            local dropRows = itemId ~= nil and acquisition.drops[itemId] or nil;
            local questRows = itemId ~= nil and spellQuestSources[itemId] or nil;
            if #rows > 0 or (dropRows ~= nil and #dropRows > 0) or
                (questRows ~= nil and #questRows > 0) then
                local entry = {
                    id = id,
                    itemId = itemId,
                    name = resource.Name[1],
                    description = resource.Description and resource.Description[1] or '',
                    vendors = rows,
                    questSources = questRows or {},
                    learned = player ~= nil and player:HasSpell(id) or false,
                    levels = spellLevels(resource),
                    jobLevels = resource.LevelRequired,
                    typeName = SPELL_TYPES[resource.Type] or 'Other magic',
                    manaCost = resource.ManaCost or 0,
                    castTime = resource.CastTime or 0,
                    recastDelay = resource.RecastDelay or 0,
                    cheapestGil = cheapestVendorGil(rows),
                };
                state.spells[#state.spells + 1] = entry;
                if selectedSpellId == id then state.selectedSpell = entry; end
            end
        end
    end

    for id, shop in pairs(shops) do
        if state.items[shop.category] ~= nil then
            local resource = resources:GetItemById(id);
            if resource ~= nil and resource.Name ~= nil and resource.Name[1] ~= nil and resource.Name[1] ~= '' then
                local entry = {
                    id = id,
                    name = resource.Name[1],
                    description = resource.Description and resource.Description[1] or '',
                    level = resource.Level or 0,
                    jobs = resource.Jobs or 0,
                    slots = resource.Slots or 0,
                    skill = resource.Skill or 0,
                    damage = resource.Damage or 0,
                    delay = resource.Delay or 0,
                    vendors = shop.vendors,
                };
                state.items[shop.category][#state.items[shop.category] + 1] = entry;
                if selectedItemIds[shop.category] == id then state.selectedItems[shop.category] = entry; end
            end
        end
    end

    -- Materials are every synthesis result, ingredient, crystal, and guild or
    -- standard supply item. Names come from Ashita resources at runtime, which
    -- keeps the generated source catalog compact.
    local materialIds = {};
    for resultId, recipes in pairs(acquisition.recipes or {}) do
        materialIds[resultId] = true;
        for _, recipe in ipairs(recipes) do
            if recipe.crystal ~= nil then materialIds[recipe.crystal] = true; end
            for _, ingredient in ipairs(recipe.ingredients or {}) do
                materialIds[ingredient[1]] = true;
            end
        end
    end
    for id, shop in pairs(shops) do
        if shop.category == 'supply' then materialIds[id] = true; end
    end
    for id in pairs(guildShops) do materialIds[id] = true; end

    for id in pairs(materialIds) do
        local resource = resources:GetItemById(id);
        if resource ~= nil and resource.Name ~= nil and resource.Name[1] ~= nil and resource.Name[1] ~= '' then
            local vendors = {};
            for _, vendor in ipairs((shops[id] and shops[id].vendors) or {}) do vendors[#vendors + 1] = vendor; end
            for _, vendor in ipairs((guildShops[id] and guildShops[id].vendors) or {}) do vendors[#vendors + 1] = vendor; end
            local entry = {
                id = id,
                name = resource.Name[1],
                description = resource.Description and resource.Description[1] or '',
                vendors = vendors,
                recipes = acquisition.recipes[id] or {},
            };
            state.materials[#state.materials + 1] = entry;
            if selectedMaterialId == id then state.selectedMaterial = entry; end
        end
    end
    table.sort(state.materials, function (a, b) return lower(a.name) < lower(b.name); end);

    table.sort(state.spells, function (a, b) return lower(a.name) < lower(b.name); end);
    local seenSpellTypes = {};
    state.spellTypeNames = {};
    for _, spell in ipairs(state.spells) do
        if not seenSpellTypes[spell.typeName] then
            seenSpellTypes[spell.typeName] = true;
            state.spellTypeNames[#state.spellTypeNames + 1] = spell.typeName;
        end
    end
    table.sort(state.spellTypeNames, function (a, b) return lower(a) < lower(b); end);
    state.spellCatalogVersion = state.spellCatalogVersion + 1;
    state.spellViewCache = nil;
    for category, rows in pairs(state.items) do
        table.sort(rows, function (a, b)
            if a.level ~= b.level then return a.level < b.level; end
            return lower(a.name) < lower(b.name);
        end);
        if state.selectedItems[category] == nil then state.selectedItems[category] = rows[1]; end
    end
    if state.selectedSpell == nil then state.selectedSpell = state.spells[1]; end

    if #state.dropItems == 0 then
        local seenDropTypes = { [0] = {}, [2] = {}, [3] = {} };
        for itemId, category in pairs(acquisition.dropItems) do
            local resource = resources:GetItemById(itemId);
            if resource ~= nil and resource.Name ~= nil and resource.Name[1] ~= nil and resource.Name[1] ~= '' then
                local sources = acquisition.drops[itemId] or {};
                local minimumDropLevel = math.huge;
                for _, source in ipairs(sources) do
                    local level = source.minLevel or source[3];
                    if level ~= nil and level > 0 and level < minimumDropLevel then minimumDropLevel = level; end
                end
                local typeName;
                if category == 2 then
                    typeName = WEAPON_TYPES[resource.Skill or 0] or 'Other weapon';
                else
                    local slotNames = slotsText(resource.Slots or 0);
                    typeName = slotNames ~= '' and slotNames or 'Other armor';
                end
                state.dropItems[#state.dropItems + 1] = {
                    id = itemId,
                    name = resource.Name[1],
                    description = resource.Description and resource.Description[1] or '',
                    category = category,
                    typeName = typeName,
                    sources = sources,
                    minimumDropLevel = minimumDropLevel,
                };
                for _, typeCategory in ipairs({ 0, category }) do
                    if not seenDropTypes[typeCategory][typeName] then
                        seenDropTypes[typeCategory][typeName] = true;
                        state.dropTypeNames[typeCategory][#state.dropTypeNames[typeCategory] + 1] = typeName;
                    end
                end
            end
        end
        for _, typeCategory in ipairs({ 0, 2, 3 }) do
            table.sort(state.dropTypeNames[typeCategory], function(a, b) return lower(a) < lower(b); end);
        end
        table.sort(state.dropItems, function (a, b) return lower(a.name) < lower(b.name); end);
        state.selectedDropItem = state.dropItems[1];
        state.dropViewCache = nil;
    end

    if #state.nms == 0 then
        local nmsByKey = {};
        for _, row in ipairs(acquisition.nms or {}) do
            local zoneId = row.zoneId or row[2];
            local name = row.monster or row[1];
            local key = tostring(zoneId) .. ':' .. normalizeName(name);
            local entry = {
                key = key,
                monster = name,
                zoneId = zoneId,
                zone = acquisition.zones[zoneId] or ('Zone #' .. tostring(zoneId)),
                minLevel = row.minLevel or row[3] or 0,
                maxLevel = row.maxLevel or row[4] or 0,
                positions = row.positions or row[5],
                isNm = true,
                drops = {},
                dropIds = {},
            };
            state.nms[#state.nms + 1] = entry;
            nmsByKey[key] = entry;
        end

        -- Reuse the addon's retained spell and equipment acquisition sources
        -- instead of duplicating a second drop catalog for the NM browser.
        for itemId, sources in pairs(acquisition.drops or {}) do
            for _, source in ipairs(sources) do
                if source.isNm == true or source[5] == 1 then
                    local zoneId = source.zoneId or source[2];
                    local name = source.monster or source[1];
                    local nm = nmsByKey[tostring(zoneId) .. ':' .. normalizeName(name)];
                    if nm ~= nil and not nm.dropIds[itemId] then
                        nm.dropIds[itemId] = true;
                        local item = resources:GetItemById(itemId);
                        local itemName = item ~= nil and item.Name ~= nil and item.Name[1] or nil;
                        local equipmentCategory = acquisition.dropItems[itemId];
                        if equipmentCategory == nil and shops[itemId] ~= nil then
                            if shops[itemId].category == 'weapon' then equipmentCategory = 2;
                            elseif shops[itemId].category == 'armor' then equipmentCategory = 3; end
                        end
                        local drop = {
                            id = itemId,
                            name = itemName ~= nil and itemName ~= '' and itemName or ('Item #' .. tostring(itemId)),
                        };
                        if item ~= nil and (equipmentCategory == 2 or equipmentCategory == 3) then
                            drop.equipmentCategory = equipmentCategory;
                            drop.description = item.Description and item.Description[1] or '';
                            drop.level = item.Level or 0;
                            drop.jobs = item.Jobs or 0;
                            drop.slots = item.Slots or 0;
                            drop.skill = item.Skill or 0;
                            drop.damage = item.Damage or 0;
                            drop.delay = item.Delay or 0;
                        end
                        nm.drops[#nm.drops + 1] = drop;
                    end
                end
            end
        end
        for _, nm in ipairs(state.nms) do
            nm.dropIds = nil;
            table.sort(nm.drops, function (a, b) return lower(a.name) < lower(b.name); end);
            if selectedNmKey == nm.key then state.selectedNm = nm; end
        end
        table.sort(state.nms, function (a, b)
            if lower(a.zone) ~= lower(b.zone) then return lower(a.zone) < lower(b.zone); end
            return lower(a.monster) < lower(b.monster);
        end);
        if state.selectedNm == nil then state.selectedNm = state.nms[1]; end
        state.nmViewCache = nil;
    end
end

local function rebuildQuests()
    state.quests = {};
    for _, area in ipairs(QUEST_AREAS) do
        for id, quest in pairs(area.entries) do
            local unlock = JOB_UNLOCK_BY_KEY[area.log .. ':' .. id];
            local steps = unlock ~= nil and unlock.steps or quest.steps;
            if steps ~= nil and #steps > 0 then
                local sourceStart = (unlock ~= nil and unlock.start) or
                    (questStarts[area.log] and questStarts[area.log][id] or nil);
                local start = sourceStart;
                if sourceStart ~= nil and unlock ~= nil and unlock.grid ~= nil then
                    start = {
                        contact = sourceStart.contact,
                        kind = sourceStart.kind,
                        location = sourceStart.location,
                        grid = unlock.grid,
                    };
                end
                state.quests[#state.quests + 1] = {
                    id = id,
                    log = area.log,
                    area = area.label,
                    name = quest.name,
                    steps = steps,
                    start = start,
                    minLevel = entryMinimumLevel({ steps = steps }),
                    artifact = isArtifactQuest(quest),
                    jobUnlock = unlock ~= nil,
                    jobId = unlock ~= nil and unlock.jobId or entryJob(quest),
                    jobName = unlock ~= nil and unlock.jobName or nil,
                    jobOrder = unlock ~= nil and unlock.jobOrder or nil,
                    chainStep = unlock ~= nil and unlock.chainStep or nil,
                    chainCount = unlock ~= nil and unlock.chainCount or nil,
                };
            end
        end
    end
    table.sort(state.quests, function (a, b)
        if a.area ~= b.area then return a.area < b.area; end
        return lower(a.name) < lower(b.name);
    end);
    if state.selectedQuest == nil then state.selectedQuest = state.quests[1]; end
end

local function rebuildMissions()
    state.missions = {};
    for areaIndex, area in ipairs(MISSION_AREAS) do
        for id, mission in pairs(area.entries) do
            if mission.steps ~= nil and #mission.steps > 0 then
                state.missions[#state.missions + 1] = {
                    id = id,
                    log = area.log,
                    area = area.label,
                    areaIndex = areaIndex,
                    name = mission.name,
                    steps = mission.steps,
                    repeatable = mission.repeatable == true,
                    start = missionStarts[area.log] and
                        ((missionStarts[area.log].entries and missionStarts[area.log].entries[id])
                            or missionStarts[area.log].default) or nil,
                };
            end
        end
    end
    table.sort(state.missions, function (a, b)
        if a.areaIndex ~= b.areaIndex then return a.areaIndex < b.areaIndex; end
        return a.id < b.id;
    end);
    if state.selectedMission == nil then state.selectedMission = state.missions[1]; end
end

local function closestTeleport(zone, x, y)
    local requestedZone = (zone or ''):gsub('%[S%]', '(S)'):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '');
    local choices = teleports[normalizeZone(requestedZone)];
    if choices == nil then return nil; end

    -- North and South share grid labels, so grid distance incorrectly treats
    -- Windurst Waters #1 (North G-7) as adjacent to South-map vendors at G-7.
    -- Home Point #3 is the only Home Point on the South map.
    if requestedZone == 'Windurst Waters South' then
        for _, destination in ipairs(choices) do
            if destination.kind == 'hp' and destination.id == 103 then return destination; end
        end
    end

    local best, bestDistance = nil, math.huge;
    for _, destination in ipairs(choices) do
        local distance;
        if x ~= nil and y ~= nil and destination.x ~= nil and destination.y ~= nil then
            local dx, dy = x - destination.x, y - destination.y;
            distance = dx * dx + dy * dy;
        elseif destination.kind == 'hp' then
            distance = 1000000 + destination.id;
        else
            distance = 2000000 + destination.id;
        end
        if distance < bestDistance then best, bestDistance = destination, distance; end
    end
    return best;
end

local function zoneFromText(value)
    local normalized = normalizeZone(value or '');
    for _, zone in ipairs(teleportZoneNames) do
        if normalized:find(normalizeZone(zone), 1, true) ~= nil then return zone; end
    end
    return nil;
end

local guideZoneNames = nil;

local function guideZoneIdFromText(value)
    if guideZoneNames == nil then
        guideZoneNames = {};
        local resources = AshitaCore:GetResourceManager();
        for zoneId = 0, 299 do
            local name = resources:GetString('zones.names', zoneId);
            if name ~= nil and name ~= '' then
                guideZoneNames[#guideZoneNames + 1] = {
                    id = zoneId,
                    search = lower(normalizeZone(name)),
                };
            end
        end
        table.sort(guideZoneNames, function (a, b) return #a.search > #b.search; end);
    end

    local normalized = lower(normalizeZone(value or ''));
    local matched = {};
    local matchedId = nil;
    local matchedSearch = nil;
    for _, zone in ipairs(guideZoneNames) do
        if normalized:find(zone.search, 1, true) ~= nil and not matched[zone.id] then
            matched[zone.id] = true;
            if matchedId == nil then
                matchedId = zone.id;
                matchedSearch = zone.search;
            elseif matchedId ~= zone.id and
                matchedSearch:find(zone.search, 1, true) == nil and
                zone.search:find(matchedSearch, 1, true) == nil then
                return nil;
            end
        end
    end
    return matchedId;
end

local function guidePositionGrid(value)
    local coordinates = {};
    local number = '([%+%-]?%d+%.?%d*)';
    for x, height, groundY in (value or ''):gmatch(
        '!pos%s+' .. number .. '%s+' .. number .. '%s+' .. number) do
        coordinates[#coordinates + 1] = { tonumber(x), tonumber(height), tonumber(groundY) };
    end
    if #coordinates == 0 then return nil, false; end

    local zoneId = guideZoneIdFromText(value);
    if zoneId == nil then return nil, true; end
    local grids, seen = {}, {};
    for _, coordinate in ipairs(coordinates) do
        local grid = currentGrid(zoneId, coordinate[1], coordinate[3], coordinate[2], nil);
        if grid ~= nil and not seen[grid] then
            seen[grid] = true;
            grids[#grids + 1] = grid;
        end
    end
    if #grids == 0 then return nil, true; end
    return table.concat(grids, ' / '), true;
end

local function issuePort(destination)
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    if player == nil or player:GetLoginStatus() ~= 2 then
        print(chat.header('vanacompass'):append(chat.error('You must be logged in to use Port.')));
        return;
    end
    if player:GetIsZoning() ~= 0 then
        print(chat.header('vanacompass'):append(chat.error('Wait until zoning has finished.')));
        return;
    end
    AshitaCore:GetChatManager():QueueCommand(1, string.format('!port go %s %d', destination.kind, destination.id));
    print(chat.header('vanacompass'):append(chat.message('Port requested: ' .. destination.name .. '.')));
end

local function portButton(destination, id)
    if destination == nil then
        textDisabledWrapped('No direct port');
        return;
    end
    if imgui.SmallButton('Port##' .. id) then issuePort(destination); end
    if imgui.IsItemHovered() then imgui.SetTooltip('Travel to ' .. destination.name .. ' using !port.'); end
    imgui.SameLine();
    imgui.PushStyleColor(ImGuiCol_Text, theme.colors.dim);
    imgui.TextWrapped(destination.name);
    imgui.PopStyleColor();
end

local function renderGuideLocation(location, id)
    local grid, hasPosition = guidePositionGrid(location);
    local zone = zoneFromText(location);
    local destination = zone and closestTeleport(zone) or nil;
    local narrow = imgui.GetWindowWidth() < 620;

    if grid ~= nil then
        imgui.TextDisabled('Grid: ' .. grid); imgui.SameLine();
    elseif hasPosition then
        imgui.TextDisabled('Grid: unavailable'); imgui.SameLine();
    end

    if narrow then
        textDisabledWrapped(location);
        imgui.TextDisabled('Closest port:'); imgui.SameLine();
        portButton(destination, id);
        return;
    end

    imgui.TextDisabled(location); imgui.SameLine();
    portButton(destination, id);
end

local function renderVendorPriceAndRequirements(vendor)
    if vendor.shopType == 'Guild shop' then
        imgui.TextWrapped(string.format('Guild shop, variable stock and price; up to %d gil.', vendor.buyMax or 0));
        if vendor.openHour ~= nil and vendor.closeHour ~= nil then
            imgui.TextWrapped(string.format('Open %02d:00-%02d:00%s.', vendor.openHour, vendor.closeHour,
                vendor.holiday and ('; closed ' .. vendor.holiday) or ''));
        end
        if (vendor.initial or 0) == 0 and (vendor.restockRate or 0) == 0 then
            textColoredWrapped(theme.colors.warn, 'May be unavailable until players sell stock to the guild.');
        end
    elseif vendor.notes ~= nil then
        imgui.TextWrapped(vendor.notes ~= '' and vendor.notes or '-');
    else
        imgui.TextWrapped(string.format('%d gil%s', vendor.price or 0,
            vendor.tier and string.format(' (shop tier %d)', vendor.tier) or ''));
    end
    local requirement = VENDOR_ACCESS_REQUIREMENTS[vendor.npc];
    if requirement ~= nil then
        imgui.PushStyleColor(ImGuiCol_Text, theme.colors.warn);
        imgui.TextWrapped(requirement);
        imgui.PopStyleColor();
    end
end

local function vendorTable(rows, idPrefix)
    if imgui.GetWindowWidth() < 620 then
        for index, vendor in ipairs(rows) do
            imgui.TextWrapped(vendor.npc);
            local location = vendor.location or '';
            imgui.TextWrapped(vendor.zone .. (location ~= '' and
                (' (' .. location:gsub('^%(', ''):gsub('%)$', '') .. ')') or ''));
            renderVendorPriceAndRequirements(vendor);
            portButton(closestTeleport(vendor.zone, vendor.x, vendor.y), idPrefix .. '_' .. index);
            if index < #rows then imgui.Separator(); end
        end
        return;
    end
    if not imgui.BeginTable('##vendors_' .. idPrefix, 4,
        bit.bor(ImGuiTableFlags_Borders, ImGuiTableFlags_RowBg, ImGuiTableFlags_SizingStretchProp)) then return; end
    imgui.TableSetupColumn('Vendor', ImGuiTableColumnFlags_WidthStretch, 1.0);
    imgui.TableSetupColumn('Location', ImGuiTableColumnFlags_WidthStretch, 1.35);
    imgui.TableSetupColumn('Price / requirements', ImGuiTableColumnFlags_WidthStretch, 1.25);
    imgui.TableSetupColumn('Closest port', ImGuiTableColumnFlags_WidthStretch, 1.35);
    imgui.TableHeadersRow();
    for index, vendor in ipairs(rows) do
        imgui.TableNextRow();
        imgui.TableNextColumn(); imgui.TextWrapped(vendor.npc);
        imgui.TableNextColumn();
        local location = vendor.location or '';
        imgui.TextWrapped(vendor.zone .. (location ~= '' and (' (' .. location:gsub('^%(', ''):gsub('%)$', '') .. ')') or ''));
        imgui.TableNextColumn();
        renderVendorPriceAndRequirements(vendor);
        imgui.TableNextColumn();
        portButton(closestTeleport(vendor.zone, vendor.x, vendor.y), idPrefix .. '_' .. index);
    end
    imgui.EndTable();
end

local function sourceZoneName(source)
    local zoneId = source.zoneId or source[2];
    return AshitaCore:GetResourceManager():GetString('zones.names', zoneId) or
        acquisition.zones[zoneId] or string.format('Zone #%d', zoneId);
end

local function sourceMonsterName(source)
    return source.monster or source[1];
end

local function sourceIsNm(source)
    return source.isNm == true or source[5] == 1;
end

local function sourceZoneSearchName(source)
    local zoneId = source.zoneId or source[2];
    return source.zone or acquisition.zones[zoneId] or '';
end

local function itemResourceName(itemId)
    local resource = AshitaCore:GetResourceManager():GetItemById(itemId);
    if resource ~= nil and resource.Name ~= nil and resource.Name[1] ~= nil and resource.Name[1] ~= '' then
        return resource.Name[1];
    end
    return string.format('Item #%d', itemId);
end

local function sourceLevelText(source)
    local minimum, maximum = source.minLevel or source[3], source.maxLevel or source[4];
    if minimum == nil or minimum <= 0 then return 'Level unknown'; end
    if maximum == nil or maximum == minimum then
        return string.format('Lv.%d', minimum);
    end
    return string.format('Lv.%d-%d', minimum, maximum);
end

local function sourcePositionText(source)
    local positions = source.positions or source[6];
    if positions == nil or #positions == 0 then return nil, nil; end
    local zoneId = source.zoneId or source[2];
    local grids, seenGrids = {}, {};
    local exact = {};
    for _, position in ipairs(positions) do
        local x = position.x or position[1];
        local height = position.height or position[2];
        local groundY = position.groundY or position[3];
        exact[#exact + 1] = string.format('!pos %.1f %.1f %.1f', x, height, groundY);
        local grid = currentGrid(zoneId, x, groundY, height, nil);
        if grid ~= nil and not seenGrids[grid] then
            seenGrids[grid] = true;
            grids[#grids + 1] = grid;
        end
    end
    table.sort(grids, function (a, b)
        local aColumn, aRow = a:match('^(%a)%-(%d+)$');
        local bColumn, bRow = b:match('^(%a)%-(%d+)$');
        if aColumn ~= bColumn then return aColumn < bColumn; end
        return tonumber(aRow) < tonumber(bRow);
    end);

    local label;
    if #positions == 1 then
        label = (#grids == 1 and ('Grid: ' .. grids[1]) or 'Grid unavailable') .. '   ' .. exact[1];
    elseif #grids > 0 then
        label = string.format('Area: %s (%d known points)', table.concat(grids, ' / '), #positions);
    else
        label = string.format('Grid unavailable (%d known points)', #positions);
    end

    local tooltip = {};
    for index = 1, math.min(#exact, 8) do tooltip[#tooltip + 1] = exact[index]; end
    if #exact > 8 then tooltip[#tooltip + 1] = string.format('+ %d more points', #exact - 8); end
    return label, table.concat(tooltip, '\n');
end

local function renderSourcePosition(source)
    local label, tooltip = sourcePositionText(source);
    if label == nil then
        if sourceIsNm(source) then textDisabledWrapped('NM area unavailable'); end
        return;
    end
    imgui.PushStyleColor(ImGuiCol_Text, theme.colors.hint);
    imgui.TextWrapped(label);
    imgui.PopStyleColor();
    if tooltip ~= '' and imgui.IsItemHovered() then imgui.SetTooltip(tooltip); end
end

local function spawnDuration(seconds)
    if seconds % 3600 == 0 then
        local hours = seconds / 3600;
        return string.format('%d hour%s', hours, hours == 1 and '' or 's');
    end
    if seconds % 60 == 0 then
        local minutes = seconds / 60;
        return string.format('%d minute%s', minutes, minutes == 1 and '' or 's');
    end
    return string.format('%d second%s', seconds, seconds == 1 and '' or 's');
end

local function renderSpawnMethod(source)
    if not sourceIsNm(source) or acquisition.spawnMethods == nil then return; end
    local zoneMethods = acquisition.spawnMethods[source.zoneId or source[2]];
    local methods = zoneMethods and zoneMethods[sourceMonsterName(source)] or nil;
    if methods == nil or #methods == 0 then return; end
    for _, method in ipairs(methods) do
        local placeholder = method.placeholder or method[1];
        local chance = method.chance or method[2];
        local minimum = method.minimum or method[3] or 0;
        local maximum = method.maximum or method[4] or minimum;
        textColoredWrapped(theme.colors.warn, 'Spawn: defeat the specific ' .. placeholder ..
            ' placeholder(s), not every ' .. placeholder .. '.');
        -- ImGui TextWrapped treats its string as a printf format. Produce two
        -- percent signs here so its formatter displays one literal percent.
        local details = string.format('%d%%%% chance per qualifying placeholder despawn', chance);
        if minimum <= 1 and maximum <= 1 then
            details = details .. '; no minimum respawn window.';
        elseif minimum > 0 then
            local window = spawnDuration(minimum);
            if maximum > minimum then window = window .. ' to ' .. spawnDuration(maximum); end
            details = details .. '; window opens ' .. window .. ' after the NM\'s last death.';
        else
            details = details .. '.';
        end
        imgui.TextWrapped(details);
    end
end

local function renderDropSources(rows, idPrefix)
    if rows == nil or #rows == 0 then return; end
    if not imgui.CollapsingHeader(string.format('Monster sources (%d)###drops_%s', #rows, idPrefix)) then return; end
    imgui.TextWrapped('Standard LandSandBoat locations and script-exposed lottery rules; Driftwood customizations may differ. NM areas use known spawn points; hover a rough area for exact !pos values.');
    local pageSize = 25;
    local pageCount = math.max(1, math.ceil(#rows / pageSize));
    local page = math.max(1, math.min(state.sourcePages[idPrefix] or 1, pageCount));
    state.sourcePages[idPrefix] = page;
    if pageCount > 1 then
        if imgui.SmallButton('< Previous##drop_page_prev_' .. idPrefix) and page > 1 then
            page = page - 1;
        end
        imgui.SameLine();
        imgui.Text(string.format('Page %d / %d', page, pageCount));
        imgui.SameLine();
        if imgui.SmallButton('Next >##drop_page_next_' .. idPrefix) and page < pageCount then
            page = page + 1;
        end
        state.sourcePages[idPrefix] = page;
    end
    local first = (page - 1) * pageSize + 1;
    local last = math.min(#rows, first + pageSize - 1);
    if imgui.GetWindowWidth() < 620 then
        for index = first, last do
            local source = rows[index];
            local zone = sourceZoneName(source);
            imgui.TextWrapped((sourceIsNm(source) and '[NM] ' or '') ..
                sourceMonsterName(source) .. '   ' .. sourceLevelText(source));
            renderSpawnMethod(source);
            imgui.TextWrapped(zone);
            renderSourcePosition(source);
            portButton(closestTeleport(zone), 'drop_' .. idPrefix .. '_' .. index);
            if index < last then imgui.Separator(); end
        end
        return;
    end
    if not imgui.BeginTable('##drops_' .. idPrefix, 3,
        bit.bor(ImGuiTableFlags_Borders, ImGuiTableFlags_RowBg, ImGuiTableFlags_SizingStretchProp)) then return; end
    imgui.TableSetupColumn('Monster / spawn', ImGuiTableColumnFlags_WidthStretch, 1.5);
    imgui.TableSetupColumn('Zone / level / NM area', ImGuiTableColumnFlags_WidthStretch, 1.5);
    imgui.TableSetupColumn('Closest port', ImGuiTableColumnFlags_WidthStretch, 1.1);
    imgui.TableHeadersRow();
    for index = first, last do
        local source = rows[index];
        local zone = sourceZoneName(source);
        imgui.TableNextRow();
        imgui.TableNextColumn();
        imgui.TextWrapped((sourceIsNm(source) and '[NM] ' or '') .. sourceMonsterName(source));
        renderSpawnMethod(source);
        imgui.TableNextColumn();
        imgui.TextWrapped(zone .. '   ' .. sourceLevelText(source));
        renderSourcePosition(source);
        imgui.TableNextColumn(); portButton(closestTeleport(zone), 'drop_' .. idPrefix .. '_' .. index);
    end
    imgui.EndTable();
end

local function recipeIngredientsText(recipe)
    local parts = {};
    for _, ingredient in ipairs(recipe.ingredients or {}) do
        local count = ingredient[2] or 1;
        parts[#parts + 1] = itemResourceName(ingredient[1]) .. (count > 1 and (' x' .. count) or '');
    end
    return table.concat(parts, ', ');
end

local function renderCraftingSources(rows, idPrefix)
    if rows == nil or #rows == 0 then return; end
    if not imgui.CollapsingHeader(string.format('Crafting recipes (%d)###recipes_%s', #rows, idPrefix)) then return; end
    for index, recipe in ipairs(rows) do
        textColoredWrapped(theme.colors.hint, recipe.craft);
        imgui.TextWrapped(string.format('%s   Yield: %d', itemResourceName(recipe.crystal), recipe.resultQty or 1));
        imgui.TextDisabled('Ingredients:'); imgui.SameLine();
        imgui.TextWrapped(recipeIngredientsText(recipe));
        if recipe.keyItem ~= nil then
            textColoredWrapped(theme.colors.warn, 'A synthesis key item is required.');
        end
        if index < #rows then imgui.Separator(); end
    end
end

local function renderSpellQuestSources(rows, idPrefix)
    if rows == nil or #rows == 0 then return; end
    imgui.Separator();
    if not imgui.CollapsingHeader(string.format('Quest rewards (%d)###spell_quests_%s', #rows, idPrefix),
        ImGuiTreeNodeFlags_DefaultOpen) then return; end

    for index, quest in ipairs(rows) do
        local start = questStarts[quest.log] and questStarts[quest.log][quest.id] or nil;
        imgui.TextWrapped(quest.name .. '  ' .. quest.area);
        if activeQuest(quest.log, quest.id) then
            imgui.SameLine(); imgui.TextColored(theme.colors.info, 'Active');
        elseif completedQuest(quest.log, quest.id) then
            imgui.SameLine(); imgui.TextColored(theme.colors.ok, 'Completed');
        elseif state.questCompletionKnown then
            imgui.SameLine(); imgui.TextDisabled('Not completed');
        end
        if start ~= nil then
            imgui.TextDisabled('START ' .. start.kind .. ':'); imgui.SameLine(); imgui.TextWrapped(start.contact);
            local grid, hasPosition = guidePositionGrid(start.location);
            if start.grid ~= nil and start.grid ~= '' then grid = start.grid; end
            if grid ~= nil then
                imgui.TextDisabled('Grid: ' .. grid); imgui.SameLine();
            elseif hasPosition then
                imgui.TextDisabled('Grid: unavailable'); imgui.SameLine();
            end
            imgui.TextWrapped(start.location);
            local zone = zoneFromText(start.location);
            portButton(zone and closestTeleport(zone) or nil,
                'spell_quest_' .. idPrefix .. '_' .. tostring(index));
        else
            imgui.TextDisabled('Quest start information is unavailable.');
        end
        if index < #rows then imgui.Separator(); end
    end
end

local function renderAcquisitionSources(itemId, idPrefix)
    if itemId == nil then return; end
    local drops = acquisition.drops[itemId];
    local recipes = acquisition.recipes[itemId];
    if (drops == nil or #drops == 0) and (recipes == nil or #recipes == 0) then return; end
    imgui.Separator();
    renderDropSources(drops, idPrefix);
    renderCraftingSources(recipes, idPrefix);
end

local function browserListToggle()
    local label = state.showBrowserList[1] and 'Hide list' or 'Show list';
    if imgui.SmallButton(label .. '##browser_list') then
        state.showBrowserList[1] = not state.showBrowserList[1];
    end
    if imgui.IsItemHovered() then
        imgui.SetTooltip(state.showBrowserList[1]
            and 'Collapse the results list and give the selected guide the full window.'
            or 'Restore the searchable results list.');
    end
end

local function searchHeader(buffer, hint)
    imgui.PushItemWidth(300);
    imgui.InputTextWithHint('##search_' .. hint, hint, buffer, 64);
    imgui.PopItemWidth();
end

local function spellRequiredLevel(spell, jobId)
    if spell.jobLevels == nil then return nil; end
    if jobId == nil then
        local player = AshitaCore:GetMemoryManager():GetPlayer();
        if player == nil then return nil; end
        jobId = player:GetMainJob();
    end
    return spell.jobLevels[jobId + 1];
end

local function spellMinimumLevel(spell)
    local minimum = math.huge;
    for job = 1, 22 do
        local required = spell.jobLevels and spell.jobLevels[job + 1] or nil;
        if required ~= nil and required > 0 and required < 100 and required < minimum then minimum = required; end
    end
    return minimum;
end

local function spellSortLevel(spell, jobId)
    if state.showAllSpells[1] then return spellMinimumLevel(spell); end
    local required = spellRequiredLevel(spell, jobId);
    return required ~= nil and required > 0 and required < 100 and required or math.huge;
end

local function spellVisible(spell, ignoreLearnedState, jobId, jobLevel)
    if not ignoreLearnedState and state.spellMode == 2 and spell.learned then return false; end
    if not ignoreLearnedState and state.spellMode == 3 and not spell.learned then return false; end
    if state.spellTypeFilter ~= '' and spell.typeName ~= state.spellTypeFilter then return false; end
    if not state.showAllSpells[1] then
        if jobId == nil or jobLevel == nil then
            local player = AshitaCore:GetMemoryManager():GetPlayer();
            if player ~= nil then
                jobId, jobLevel = player:GetMainJob(), player:GetMainJobLevel();
            end
        end
        if jobId ~= nil and jobLevel ~= nil then
            local required = spellRequiredLevel(spell, jobId);
            if required == nil or required <= 0 or required >= 100 or required > jobLevel then return false; end
        end
    end
    local query = lower(state.spellSearch[1]);
    if query == '' or lower(spell.name):find(query, 1, true) or lower(spell.typeName):find(query, 1, true) then return true; end
    for _, vendor in ipairs(spell.vendors) do
        if lower(vendor.npc):find(query, 1, true) or lower(vendor.zone):find(query, 1, true) then return true; end
    end
    for _, quest in ipairs(spell.questSources) do
        if lower(quest.name):find(query, 1, true) or lower(quest.area):find(query, 1, true) then return true; end
        local start = questStarts[quest.log] and questStarts[quest.log][quest.id] or nil;
        if start ~= nil and (lower(start.contact):find(query, 1, true) or
            lower(start.location):find(query, 1, true)) then return true; end
    end
    for _, source in ipairs(spell.itemId ~= nil and acquisition.drops[spell.itemId] or {}) do
        if lower(sourceMonsterName(source)):find(query, 1, true) or
            lower(sourceZoneSearchName(source)):find(query, 1, true) then return true; end
    end
    return false;
end

-- Filtering and sorting the complete spell catalog every present frame creates
-- short-lived tables and eventually visible garbage-collection hitches. Cache
-- one view for both responsive layouts and rebuild it only when an input changes.
local function getSpellView()
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    local jobId = player ~= nil and player:GetMainJob() or nil;
    local jobLevel = player ~= nil and player:GetMainJobLevel() or nil;
    local cached = state.spellViewCache;
    if cached ~= nil and
        cached.catalogVersion == state.spellCatalogVersion and
        cached.query == state.spellSearch[1] and
        cached.typeFilter == state.spellTypeFilter and
        cached.mode == state.spellMode and
        cached.sort == state.spellSort and
        cached.showAll == state.showAllSpells[1] and
        cached.jobId == jobId and cached.jobLevel == jobLevel then
        return cached;
    end

    local view = {
        catalogVersion = state.spellCatalogVersion,
        query = state.spellSearch[1],
        typeFilter = state.spellTypeFilter,
        mode = state.spellMode,
        sort = state.spellSort,
        showAll = state.showAllSpells[1],
        jobId = jobId,
        jobLevel = jobLevel,
        spells = {},
        visibleIds = {},
        billTotal = 0,
        billMissing = 0,
        billPriced = 0,
    };
    for _, spell in ipairs(state.spells) do
        if spellVisible(spell, false, jobId, jobLevel) then
            view.spells[#view.spells + 1] = spell;
            view.visibleIds[spell.id] = true;
        end
        -- The shopping bill covers spells that can actually be purchased.
        -- Drop-only scrolls remain visible but do not inflate the Gil estimate.
        if not spell.learned and #spell.vendors > 0 and spellVisible(spell, true, jobId, jobLevel) then
            view.billMissing = view.billMissing + 1;
            if spell.cheapestGil ~= nil then
                view.billTotal = view.billTotal + spell.cheapestGil;
                view.billPriced = view.billPriced + 1;
            end
        end
    end
    table.sort(view.spells, function (a, b)
        if state.spellSort == 2 then
            local aLevel, bLevel = spellSortLevel(a, jobId), spellSortLevel(b, jobId);
            if aLevel ~= bLevel then return aLevel < bLevel; end
        end
        return lower(a.name) < lower(b.name);
    end);
    state.spellViewCache = view;
    return view;
end

local function formatNumber(value)
    local reversed = tostring(math.floor(value or 0)):reverse():gsub('(%d%d%d)', '%1,');
    local formatted = reversed:reverse():gsub('^,', '');
    return formatted;
end

local function renderMissingSpellBill(view)
    local suffix = view.billPriced < view.billMissing and
        string.format(' + %d without a Gil price', view.billMissing - view.billPriced) or '';
    imgui.PushStyleColor(ImGuiCol_Text, theme.colors.warn);
    imgui.TextWrapped(string.format("Moogle's missing-scroll bill: %s Gil for %d spell%s%s.",
        formatNumber(view.billTotal), view.billMissing, view.billMissing == 1 and '' or 's', suffix));
    imgui.PopStyleColor();
    if imgui.IsItemHovered() then
        imgui.SetTooltip('Uses the cheapest listed Gil vendor once per missing spell. Search, magic type, job, and level filters apply; non-Gil currencies are excluded.');
    end
end

local function spellTooltip(spell)
    local lines = { spell.name };
    if spell.description ~= nil and spell.description ~= '' then
        lines[#lines + 1] = spell.description;
    end
    lines[#lines + 1] = '';
    lines[#lines + 1] = 'Type: ' .. spell.typeName;
    lines[#lines + 1] = 'Requirements: ' ..
        (spell.levels ~= '' and spell.levels or 'No valid job requirements');
    lines[#lines + 1] = 'Status: ' .. (spell.learned and 'Learned' or 'Missing');
    lines[#lines + 1] = string.format('MP: %d   Cast: %.2fs   Recast: %.2fs',
        spell.manaCost, spell.castTime / 4.0, spell.recastDelay / 4.0);
    lines[#lines + 1] = string.format('Known vendors: %d', #spell.vendors);
    lines[#lines + 1] = string.format('Known monster sources: %d',
        #(spell.itemId ~= nil and acquisition.drops[spell.itemId] or {}));
    lines[#lines + 1] = string.format('Known quest rewards: %d', #spell.questSources);
    if spell.cheapestGil ~= nil then
        lines[#lines + 1] = 'Cheapest listed price: ' .. formatNumber(spell.cheapestGil) .. ' Gil';
    end
    -- ImGui tooltip strings are printf-style format strings.
    return (table.concat(lines, '\n'):gsub('%%', '%%%%'));
end

-- Ashita's Lua ImGui binding does not expose ImGuiListClipper.  Keep a fixed
-- row height and perform the same viewport calculation here so opening the
-- complete catalog does not submit hundreds of Selectable/Text commands on
-- every frame.  The final Dummy preserves the full scrollable content height.
local function renderVirtualSpellRows(spells, idPrefix, showRequirements)
    if #spells == 0 then return; end
    local rowHeight = imgui.GetFrameHeightWithSpacing();
    if showRequirements then
        rowHeight = rowHeight + imgui.GetTextLineHeightWithSpacing();
    end

    local originY = imgui.GetCursorPosY();
    local scrollY = imgui.GetScrollY();
    local viewportHeight = imgui.GetWindowHeight();
    local first = math.max(1, math.floor(scrollY / rowHeight) + 1);
    local last = math.min(#spells, math.ceil((scrollY + viewportHeight) / rowHeight) + 2);
    imgui.SetCursorPosY(originY + (first - 1) * rowHeight);

    for index = first, last do
        local spell = spells[index];
        local rowY = imgui.GetCursorPosY();
        if imgui.Selectable((spell.learned and '[+] ' or '[-] ') .. spell.name ..
            '##' .. idPrefix .. spell.id, state.selectedSpell == spell) then
            state.selectedSpell = spell;
        end
        local hovered = imgui.IsItemHovered();
        if showRequirements then
            imgui.Indent(12);
            imgui.PushStyleColor(ImGuiCol_Text, theme.colors.dim);
            imgui.Text(spell.typeName .. '  |  ' ..
                (spell.levels ~= '' and spell.levels or 'No valid job requirements'));
            imgui.PopStyleColor();
            imgui.Unindent(12);
        end
        if hovered then imgui.SetTooltip(spellTooltip(spell)); end
        imgui.SetCursorPosY(rowY + rowHeight);
    end

    imgui.SetCursorPosY(originY + #spells * rowHeight);
    imgui.Dummy({ 1, 1 });
end

local function renderSpells()
    local toolbarWidth = imgui.GetWindowWidth();
    searchHeader(state.spellSearch, 'spell, vendor, quest, monster, or zone');
    if toolbarWidth >= 720 then imgui.SameLine(); end
    for index, label in ipairs({ 'All states', 'Missing', 'Learned' }) do
        if index > 1 then imgui.SameLine(); end
        local selected = pushSelectedButton(state.spellMode == index);
        if imgui.Button(label .. '##spellmode_' .. index) then state.spellMode = index; end
        if selected then imgui.PopStyleColor(); end
    end
    if toolbarWidth >= 900 then imgui.SameLine(); end
    imgui.Checkbox('##show_all_spells', state.showAllSpells);
    imgui.SameLine(); imgui.TextWrapped('Show all jobs / levels');
    if imgui.IsItemClicked() then state.showAllSpells[1] = not state.showAllSpells[1]; end
    if toolbarWidth >= 1080 then imgui.SameLine(); end
    imgui.TextDisabled('Sort:');
    for index, label in ipairs({ 'Name', 'Level' }) do
        imgui.SameLine();
        local selected = pushSelectedButton(state.spellSort == index);
        if imgui.SmallButton(label .. '##spell_sort_' .. index) then state.spellSort = index; end
        if selected then imgui.PopStyleColor(); end
    end
    imgui.TextDisabled('Magic type:'); imgui.SameLine();
    imgui.PushItemWidth(170);
    if imgui.BeginCombo('##spell_type_filter', state.spellTypeFilter ~= '' and state.spellTypeFilter or 'All magic types') then
        if imgui.Selectable('All magic types', state.spellTypeFilter == '') then state.spellTypeFilter = ''; end
        for _, typeName in ipairs(state.spellTypeNames) do
            if imgui.Selectable(typeName, state.spellTypeFilter == typeName) then state.spellTypeFilter = typeName; end
        end
        imgui.EndCombo();
    end
    imgui.PopItemWidth();
    browserListToggle();
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    if state.showAllSpells[1] then
        imgui.TextWrapped('Showing vendor, quest-reward, and monster-dropped spells for every job and level.');
    elseif player ~= nil then
        local jobName = AshitaCore:GetResourceManager():GetString('jobs.names_abbr', player:GetMainJob()) or '?';
        imgui.TextWrapped(string.format('Showing vendor, quest-reward, and monster-dropped spells usable by %s %d.', jobName, player:GetMainJobLevel()));
    else
        imgui.TextWrapped('Character job is unavailable; showing the known spell-acquisition catalog.');
    end
    local spellView = getSpellView();
    renderMissingSpellBill(spellView);
    imgui.Separator();
    if state.showBrowserList[1] and imgui.GetWindowWidth() >= 760 and
        imgui.BeginTable('##spell_layout', 2, ImGuiTableFlags_SizingStretchProp) then
        imgui.TableSetupColumn('Spells', ImGuiTableColumnFlags_WidthStretch, 0.75);
        imgui.TableSetupColumn('Details', ImGuiTableColumnFlags_WidthStretch, 2.25);
        imgui.TableNextRow(); imgui.TableNextColumn();
        imgui.BeginChild('##spell_list', { 0, 0 }, ImGuiChildFlags_Borders);
        local visibleSpells = spellView.spells;
        renderVirtualSpellRows(visibleSpells, 's', true);
        if #visibleSpells == 0 then
            imgui.TextDisabled('No matching spells. Change the magic type, job/level, learned state, or search filter.');
            state.selectedSpell = nil;
        elseif state.selectedSpell == nil or not spellView.visibleIds[state.selectedSpell.id] then
            state.selectedSpell = visibleSpells[1];
        end
        imgui.EndChild();
        imgui.TableNextColumn();
        imgui.BeginChild('##spell_details', { 0, 0 }, ImGuiChildFlags_Borders);
        local spell = state.selectedSpell;
        if spell then
            imgui.Text(spell.name); imgui.SameLine();
            imgui.TextColored(spell.learned and theme.colors.ok or theme.colors.warn, spell.learned and 'Learned' or 'Missing');
            imgui.TextDisabled('Magic type:'); imgui.SameLine(); imgui.Text(spell.typeName);
            imgui.TextDisabled('Job requirements:');
            imgui.TextWrapped(spell.levels ~= '' and spell.levels or 'No valid job requirements');
            imgui.Separator();
            if #spell.vendors > 0 then
                vendorTable(spell.vendors, 'spell_' .. spell.id);
            else
                imgui.TextDisabled('No known vendor. See the quest and monster sources below.');
            end
            renderSpellQuestSources(spell.questSources, 'spell_' .. spell.id);
            renderAcquisitionSources(spell.itemId, 'spell_' .. spell.id);
        end
        imgui.EndChild();
        imgui.EndTable();
    else
        if state.showBrowserList[1] then
            imgui.BeginChild('##spell_list_stacked', { 0, 180 }, ImGuiChildFlags_Borders);
            local visibleSpells = spellView.spells;
            renderVirtualSpellRows(visibleSpells, 'ss', false);
            if #visibleSpells == 0 then state.selectedSpell = nil;
            elseif state.selectedSpell == nil or not spellView.visibleIds[state.selectedSpell.id] then state.selectedSpell = visibleSpells[1]; end
            imgui.EndChild();
        end
        imgui.BeginChild('##spell_details_full', { 0, 0 }, ImGuiChildFlags_Borders);
        local spell = state.selectedSpell;
        if spell then
            imgui.Text(spell.name); imgui.SameLine();
            imgui.TextColored(spell.learned and theme.colors.ok or theme.colors.warn, spell.learned and 'Learned' or 'Missing');
            imgui.TextDisabled('Magic type:'); imgui.SameLine(); imgui.Text(spell.typeName);
            imgui.TextDisabled('Job requirements:'); imgui.TextWrapped(spell.levels ~= '' and spell.levels or 'No valid job requirements');
            imgui.Separator();
            if #spell.vendors > 0 then
                vendorTable(spell.vendors, 'spell_full_' .. spell.id);
            else
                imgui.TextDisabled('No known vendor. See the quest and monster sources below.');
            end
            renderSpellQuestSources(spell.questSources, 'spell_full_' .. spell.id);
            renderAcquisitionSources(spell.itemId, 'spell_full_' .. spell.id);
        else imgui.TextDisabled('Select a spell from the list.'); end
        imgui.EndChild();
    end
end

local function itemUsableNow(item)
    if not state.myLevel[1] then return true; end
    local player = AshitaCore:GetMemoryManager():GetPlayer();
    if player == nil then return true; end
    if state.itemMode == 'supply' then return true; end
    return bit.band(item.jobs, math.pow(2, player:GetMainJob())) ~= 0 and item.level <= player:GetMainJobLevel();
end

local function itemTypeName(item, category)
    if category == 'weapon' then
        return WEAPON_TYPES[item.skill] or 'Other weapon';
    end
    if category == 'armor' then
        local slots = slotsText(item.slots);
        return slots ~= '' and slots or 'Other armor';
    end
    return 'Supply';
end

local function itemVisible(item)
    if not itemUsableNow(item) then return false; end
    local typeFilter = state.itemTypeFilters[state.itemMode];
    if typeFilter ~= nil and typeFilter ~= '' and itemTypeName(item, state.itemMode) ~= typeFilter then return false; end
    local query = lower(state.itemSearch[1]);
    if query == '' or lower(item.name):find(query, 1, true) or lower(item.description):find(query, 1, true) or
        lower(itemTypeName(item, state.itemMode)):find(query, 1, true) then return true; end
    for _, vendor in ipairs(item.vendors) do
        if lower(vendor.npc):find(query, 1, true) or lower(vendor.zone):find(query, 1, true) then return true; end
    end
    for _, source in ipairs(acquisition.drops[item.id] or {}) do
        if lower(sourceMonsterName(source)):find(query, 1, true) or
            lower(sourceZoneSearchName(source)):find(query, 1, true) then return true; end
    end
    return false;
end

local function renderItems(category)
    state.itemMode = category;
    searchHeader(state.itemSearch, 'item, description, vendor, or zone');
    if category ~= 'supply' then
        imgui.SameLine(); imgui.Checkbox('Usable by my current job and level', state.myLevel);
    end
    imgui.SameLine(); imgui.TextDisabled('Sort:');
    local sortLabels = category == 'supply' and { 'Name' } or { 'Name', 'Level', 'Type' };
    for index, label in ipairs(sortLabels) do
        imgui.SameLine();
        local selected = pushSelectedButton(state.itemSorts[category] == index);
        if imgui.SmallButton(label .. '##item_sort_' .. category .. '_' .. index) then state.itemSorts[category] = index; end
        if selected then imgui.PopStyleColor(); end
    end
    if category ~= 'supply' then
        local currentType = state.itemTypeFilters[category] or '';
        local typeNames, seenTypes = {}, {};
        for _, item in ipairs(state.items[category]) do
            local typeName = itemTypeName(item, category);
            if not seenTypes[typeName] then
                seenTypes[typeName] = true;
                typeNames[#typeNames + 1] = typeName;
            end
        end
        table.sort(typeNames, function (a, b) return lower(a) < lower(b); end);
        imgui.SameLine(); imgui.TextDisabled('Filter:'); imgui.SameLine();
        imgui.PushItemWidth(160);
        if imgui.BeginCombo('##item_type_filter_' .. category, currentType ~= '' and currentType or 'All types') then
            if imgui.Selectable('All types', currentType == '') then state.itemTypeFilters[category] = ''; end
            for _, typeName in ipairs(typeNames) do
                if imgui.Selectable(typeName, currentType == typeName) then state.itemTypeFilters[category] = typeName; end
            end
            imgui.EndCombo();
        end
        imgui.PopItemWidth();
    end
    browserListToggle();
    imgui.Separator();
    local itemStacked = imgui.GetWindowWidth() < 760;
    if state.showBrowserList[1] and imgui.BeginTable('##item_layout_' .. category,
        itemStacked and 1 or 2, ImGuiTableFlags_SizingStretchProp) then
        imgui.TableSetupColumn('Items', ImGuiTableColumnFlags_WidthStretch, itemStacked and 1.0 or 1.0);
        if not itemStacked then imgui.TableSetupColumn('Details', ImGuiTableColumnFlags_WidthStretch, 2.0); end
        imgui.TableNextRow(); imgui.TableNextColumn();
        imgui.BeginChild('##item_list_' .. category, { 0, itemStacked and 180 or 0 }, ImGuiChildFlags_Borders);
        local visibleItems = {};
        for _, item in ipairs(state.items[category]) do
            if itemVisible(item) then visibleItems[#visibleItems + 1] = item; end
        end
        table.sort(visibleItems, function (a, b)
            local sortMode = state.itemSorts[category];
            if sortMode == 1 then return lower(a.name) < lower(b.name); end
            if sortMode == 3 then
                local aType, bType = lower(itemTypeName(a, category)), lower(itemTypeName(b, category));
                if aType ~= bType then return aType < bType; end
            end
            if a.level ~= b.level then return a.level < b.level; end
            return lower(a.name) < lower(b.name);
        end);
        local firstVisible = nil;
        local lastType = nil;
        for _, item in ipairs(visibleItems) do
            firstVisible = firstVisible or item;
            local typeName = itemTypeName(item, category);
            if state.itemSorts[category] == 3 and typeName ~= lastType then
                imgui.TextDisabled(typeName);
                lastType = typeName;
            end
            local label;
            if category == 'supply' then
                label = item.name;
            elseif state.itemSorts[category] == 3 then
                label = string.format('Lv.%d  %s', item.level, item.name);
            else
                label = string.format('Lv.%d  [%s]  %s', item.level, typeName, item.name);
            end
            if imgui.Selectable(label .. '##i' .. item.id, state.selectedItems[category] == item) then
                state.selectedItems[category] = item;
            end
        end
        if firstVisible == nil then
            imgui.TextDisabled('No matching items. Change the job, level, or search filter.');
            state.selectedItems[category] = nil;
        elseif state.selectedItems[category] == nil or not itemVisible(state.selectedItems[category]) then
            state.selectedItems[category] = firstVisible;
        end
        imgui.EndChild();
        if itemStacked then imgui.TableNextRow(); end
        imgui.TableNextColumn();
        imgui.BeginChild('##item_details_' .. category, { 0, 0 }, ImGuiChildFlags_Borders);
        local item = state.selectedItems[category];
        if item then
            imgui.Text(item.name);
            if category ~= 'supply' then
                imgui.SameLine(); imgui.TextDisabled(string.format('Level %d', item.level));
                imgui.TextWrapped(slotsText(item.slots) .. '   ' .. jobsText(item.jobs));
                if category == 'weapon' then
                    local skill = itemTypeName(item, category);
                    imgui.TextDisabled(string.format('%s   DMG %d   Delay %d', skill, item.damage, item.delay));
                end
            end
            if item.description ~= '' then imgui.TextWrapped(item.description); end
            imgui.Separator(); vendorTable(item.vendors, category .. '_' .. item.id);
            renderAcquisitionSources(item.id, category .. '_' .. item.id);
        end
        imgui.EndChild();
        imgui.EndTable();
    elseif not state.showBrowserList[1] then
        imgui.BeginChild('##item_details_full_' .. category, { 0, 0 }, ImGuiChildFlags_Borders);
        local item = state.selectedItems[category];
        if item then
            imgui.Text(item.name);
            if category ~= 'supply' then
                imgui.SameLine(); imgui.TextDisabled(string.format('Level %d', item.level));
                imgui.TextWrapped(slotsText(item.slots) .. '   ' .. jobsText(item.jobs));
                if category == 'weapon' then
                    imgui.TextDisabled(string.format('%s   DMG %d   Delay %d', itemTypeName(item, category), item.damage, item.delay));
                end
            end
            if item.description ~= '' then imgui.TextWrapped(item.description); end
            imgui.Separator(); vendorTable(item.vendors, category .. '_full_' .. item.id);
            renderAcquisitionSources(item.id, category .. '_full_' .. item.id);
        else imgui.TextDisabled('Show the list and select an item.'); end
        imgui.EndChild();
    end
end

local function renderVendorGear()
    imgui.TextDisabled('Gear category:'); imgui.SameLine();
    imgui.PushItemWidth(130);
    local currentLabel = state.vendorGearCategory == 'armor' and 'Armor' or 'Weapons';
    if imgui.BeginCombo('##vendor_gear_category', currentLabel) then
        if imgui.Selectable('Weapons', state.vendorGearCategory == 'weapon') then
            state.vendorGearCategory = 'weapon';
        end
        if imgui.Selectable('Armor', state.vendorGearCategory == 'armor') then
            state.vendorGearCategory = 'armor';
        end
        imgui.EndCombo();
    end
    imgui.PopItemWidth();
    imgui.Separator();
    renderItems(state.vendorGearCategory);
end

local function getMaterialView()
    local query = lower(state.materialSearch[1]);
    local cached = state.materialViewCache;
    if cached ~= nil and cached.query == query then return cached; end
    local view = { query = query, items = {}, visibleIds = {} };
    if #query >= 2 then
        for _, item in ipairs(state.materials) do
            local visible = lower(item.name):find(query, 1, true) ~= nil or
                lower(item.description):find(query, 1, true) ~= nil;
            if not visible then
                for _, vendor in ipairs(item.vendors) do
                    if lower(vendor.npc):find(query, 1, true) or
                        lower(vendor.zone):find(query, 1, true) then
                        visible = true;
                        break
                    end
                end
            end
            if visible then
                view.items[#view.items + 1] = item;
                view.visibleIds[item.id] = true;
            end
        end
    end
    state.materialViewCache = view;
    return view;
end

local function renderVirtualMaterialRows(items)
    if #items == 0 then return; end
    local rowHeight = imgui.GetFrameHeightWithSpacing();
    local originY = imgui.GetCursorPosY();
    local scrollY = imgui.GetScrollY();
    local viewportHeight = imgui.GetWindowHeight();
    local first = math.max(1, math.floor(scrollY / rowHeight) + 1);
    local last = math.min(#items, math.ceil((scrollY + viewportHeight) / rowHeight) + 2);
    imgui.SetCursorPosY(originY + (first - 1) * rowHeight);
    for index = first, last do
        local item = items[index];
        local rowY = imgui.GetCursorPosY();
        local vendorMark = #item.vendors > 0 and '[NPC] ' or '';
        if imgui.Selectable(vendorMark .. item.name .. '##material_' .. item.id,
            state.selectedMaterial == item) then
            state.selectedMaterial = item;
        end
        imgui.SetCursorPosY(rowY + rowHeight);
    end
    imgui.SetCursorPosY(originY + #items * rowHeight);
    imgui.Dummy({ 1, 1 });
end

local function renderMaterialDetails(item, idPrefix)
    if item == nil then
        imgui.TextDisabled('Search for a material and select it from the list.');
        return;
    end
    imgui.Text(item.name);
    if item.description ~= '' then imgui.TextWrapped(item.description); end
    imgui.Separator();
    if #item.vendors > 0 then
        textColoredWrapped(theme.colors.hint, string.format('NPC vendors (%d)', #item.vendors));
        vendorTable(item.vendors, 'material_' .. idPrefix .. '_' .. item.id);
    else
        textColoredWrapped(theme.colors.warn, 'No NPC vendor was found in the server shop data.');
        imgui.TextWrapped('The item may need to be crafted, obtained from another source, or purchased from the Auction House.');
    end
    renderCraftingSources(item.recipes, 'material_' .. idPrefix .. '_' .. item.id);
end

local function renderMaterials()
    searchHeader(state.materialSearch, 'material, vendor, or zone');
    browserListToggle();
    local view = getMaterialView();
    if #state.materialSearch[1] < 2 then
        imgui.TextDisabled('Enter at least two characters. Example: Bronze Ingot');
    else
        imgui.TextDisabled(string.format('%d crafting-related item%s match. [NPC] means at least one vendor is known.',
            #view.items, #view.items == 1 and '' or 's'));
    end
    imgui.Separator();

    local stacked = imgui.GetWindowWidth() < 760;
    if state.showBrowserList[1] and not stacked and
        imgui.BeginTable('##material_layout', 2, ImGuiTableFlags_SizingStretchProp) then
        imgui.TableSetupColumn('Materials', ImGuiTableColumnFlags_WidthStretch, 1.0);
        imgui.TableSetupColumn('Sources', ImGuiTableColumnFlags_WidthStretch, 2.0);
        imgui.TableNextRow(); imgui.TableNextColumn();
        imgui.BeginChild('##material_list', { 0, 0 }, ImGuiChildFlags_Borders);
        renderVirtualMaterialRows(view.items);
        if #view.items == 0 then state.selectedMaterial = nil;
        elseif state.selectedMaterial == nil or not view.visibleIds[state.selectedMaterial.id] then
            state.selectedMaterial = view.items[1];
        end
        imgui.EndChild();
        imgui.TableNextColumn();
        imgui.BeginChild('##material_details', { 0, 0 }, ImGuiChildFlags_Borders);
        renderMaterialDetails(state.selectedMaterial, 'wide');
        imgui.EndChild();
        imgui.EndTable();
    else
        if state.showBrowserList[1] then
            imgui.BeginChild('##material_list_stacked', { 0, 180 }, ImGuiChildFlags_Borders);
            renderVirtualMaterialRows(view.items);
            if #view.items == 0 then state.selectedMaterial = nil;
            elseif state.selectedMaterial == nil or not view.visibleIds[state.selectedMaterial.id] then
                state.selectedMaterial = view.items[1];
            end
            imgui.EndChild();
        end
        imgui.BeginChild('##material_details_stacked', { 0, 0 }, ImGuiChildFlags_Borders);
        renderMaterialDetails(state.selectedMaterial, 'stacked');
        imgui.EndChild();
    end
end

local function getDropView()
    local query = lower(state.dropSearch[1]);
    local cached = state.dropViewCache;
    if cached ~= nil and cached.query == query and cached.category == state.dropCategory and
        cached.typeFilter == state.dropTypeFilter and cached.sort == state.dropSort then
        return cached;
    end
    local view = {
        query = query,
        category = state.dropCategory,
        typeFilter = state.dropTypeFilter,
        sort = state.dropSort,
        items = {},
        visibleIds = {},
    };
    for _, item in ipairs(state.dropItems) do
        local visible = state.dropCategory == 0 or item.category == state.dropCategory;
        if visible and state.dropTypeFilter ~= '' then
            visible = item.typeName == state.dropTypeFilter;
        end
        if visible and query ~= '' then
            visible = lower(item.name):find(query, 1, true) ~= nil or
                lower(item.description):find(query, 1, true) ~= nil or
                lower(DROP_CATEGORY_NAMES[item.category]):find(query, 1, true) ~= nil;
            if not visible then
                for _, source in ipairs(item.sources) do
                    if lower(sourceMonsterName(source)):find(query, 1, true) or
                        lower(sourceZoneSearchName(source)):find(query, 1, true) then
                        visible = true;
                        break
                    end
                end
            end
        end
        if visible then
            view.items[#view.items + 1] = item;
            view.visibleIds[item.id] = true;
        end
    end
    if state.dropSort == 2 then
        table.sort(view.items, function (a, b)
            if a.minimumDropLevel ~= b.minimumDropLevel then
                return a.minimumDropLevel < b.minimumDropLevel;
            end
            return lower(a.name) < lower(b.name);
        end);
    end
    state.dropViewCache = view;
    return view;
end

local function renderVirtualDropRows(items)
    if #items == 0 then return; end
    local rowHeight = imgui.GetFrameHeightWithSpacing();
    local originY = imgui.GetCursorPosY();
    local scrollY = imgui.GetScrollY();
    local viewportHeight = imgui.GetWindowHeight();
    local first = math.max(1, math.floor(scrollY / rowHeight) + 1);
    local last = math.min(#items, math.ceil((scrollY + viewportHeight) / rowHeight) + 2);
    imgui.SetCursorPosY(originY + (first - 1) * rowHeight);
    for index = first, last do
        local item = items[index];
        local rowY = imgui.GetCursorPosY();
        local level = item.minimumDropLevel < math.huge and tostring(item.minimumDropLevel) or '?';
        local label = string.format('Lv.%s  [%s]  %s##drop_item_%d',
            level, DROP_CATEGORY_NAMES[item.category], item.name, item.id);
        if imgui.Selectable(label, state.selectedDropItem == item) then state.selectedDropItem = item; end
        imgui.SetCursorPosY(rowY + rowHeight);
    end
    imgui.SetCursorPosY(originY + #items * rowHeight);
    imgui.Dummy({ 1, 1 });
end

local function renderDropItemDetails(item, idPrefix)
    if item == nil then
        imgui.TextDisabled('Select a dropped item from the list.');
        return;
    end
    imgui.Text(item.name); imgui.SameLine();
    imgui.TextDisabled(DROP_CATEGORY_NAMES[item.category]);
    if item.minimumDropLevel < math.huge then
        imgui.TextDisabled(string.format('Lowest listed monster level: %d', item.minimumDropLevel));
    else
        imgui.TextDisabled('Lowest listed monster level: unknown');
    end
    if item.description ~= '' then imgui.TextWrapped(item.description); end
    renderDropSources(item.sources, idPrefix .. '_' .. item.id);
    renderCraftingSources(acquisition.recipes[item.id], idPrefix .. '_' .. item.id);
end

local function renderDrops()
    local toolbarWidth = imgui.GetWindowWidth();
    searchHeader(state.dropSearch, 'item, monster, or zone');
    if toolbarWidth >= 1050 then imgui.SameLine(); end
    local categories = {
        { label = 'All', category = 0 },
        { label = 'Weapons', category = 2 },
        { label = 'Armor', category = 3 },
    };
    local categoryLabel = DROP_CATEGORY_NAMES[state.dropCategory] or 'All';
    imgui.TextDisabled('Category:'); imgui.SameLine();
    imgui.PushItemWidth(110);
    if imgui.BeginCombo('##drop_category', categoryLabel) then
        for _, category in ipairs(categories) do
            if imgui.Selectable(category.label, state.dropCategory == category.category) then
                state.dropCategory = category.category;
                state.dropTypeFilter = '';
            end
        end
        imgui.EndCombo();
    end
    imgui.PopItemWidth();
    if toolbarWidth >= 700 then imgui.SameLine(); end
    imgui.TextDisabled('Type:'); imgui.SameLine();
    imgui.PushItemWidth(160);
    if imgui.BeginCombo('##drop_type_filter', state.dropTypeFilter ~= '' and state.dropTypeFilter or 'All types') then
        if imgui.Selectable('All types', state.dropTypeFilter == '') then state.dropTypeFilter = ''; end
        for _, typeName in ipairs(state.dropTypeNames[state.dropCategory] or {}) do
            if imgui.Selectable(typeName, state.dropTypeFilter == typeName) then
                state.dropTypeFilter = typeName;
            end
        end
        imgui.EndCombo();
    end
    imgui.PopItemWidth();
    if toolbarWidth >= 920 then imgui.SameLine(); end
    imgui.TextDisabled('Sort:');
    for index, label in ipairs({ 'Name', 'Level' }) do
        imgui.SameLine();
        local selected = pushSelectedButton(state.dropSort == index);
        if imgui.SmallButton(label .. '##drop_sort_' .. index) then state.dropSort = index; end
        if selected then imgui.PopStyleColor(); end
    end
    browserListToggle();
    local view = getDropView();
    imgui.TextDisabled(string.format('%d non-vendor equipment item%s match. Drop rates are intentionally omitted.',
        #view.items, #view.items == 1 and '' or 's'));
    imgui.Separator();

    local stacked = imgui.GetWindowWidth() < 760;
    if state.showBrowserList[1] and not stacked and
        imgui.BeginTable('##drop_layout', 2, ImGuiTableFlags_SizingStretchProp) then
        imgui.TableSetupColumn('Dropped items', ImGuiTableColumnFlags_WidthStretch, 1.0);
        imgui.TableSetupColumn('Sources', ImGuiTableColumnFlags_WidthStretch, 2.0);
        imgui.TableNextRow(); imgui.TableNextColumn();
        imgui.BeginChild('##drop_list', { 0, 0 }, ImGuiChildFlags_Borders);
        renderVirtualDropRows(view.items);
        if #view.items == 0 then state.selectedDropItem = nil;
        elseif state.selectedDropItem == nil or not view.visibleIds[state.selectedDropItem.id] then
            state.selectedDropItem = view.items[1];
        end
        imgui.EndChild();
        imgui.TableNextColumn();
        imgui.BeginChild('##drop_details', { 0, 0 }, ImGuiChildFlags_Borders);
        renderDropItemDetails(state.selectedDropItem, 'wide');
        imgui.EndChild();
        imgui.EndTable();
    else
        if state.showBrowserList[1] then
            imgui.BeginChild('##drop_list_stacked', { 0, 180 }, ImGuiChildFlags_Borders);
            renderVirtualDropRows(view.items);
            if #view.items == 0 then state.selectedDropItem = nil;
            elseif state.selectedDropItem == nil or not view.visibleIds[state.selectedDropItem.id] then
                state.selectedDropItem = view.items[1];
            end
            imgui.EndChild();
        end
        imgui.BeginChild('##drop_details_full', { 0, 0 }, ImGuiChildFlags_Borders);
        renderDropItemDetails(state.selectedDropItem, 'full');
        imgui.EndChild();
    end
end

local function nmSortRows(rows)
    table.sort(rows, function (a, b)
        if state.nmSort == 2 then
            local aLevel = a.minLevel > 0 and a.minLevel or math.huge;
            local bLevel = b.minLevel > 0 and b.minLevel or math.huge;
            if aLevel ~= bLevel then return aLevel < bLevel; end
        elseif state.nmSort == 3 and lower(a.zone) ~= lower(b.zone) then
            return lower(a.zone) < lower(b.zone);
        end
        return lower(a.monster) < lower(b.monster);
    end);
end

local function getNmView()
    local query = lower(state.nmSearch[1]);
    local zoneId = state.currentLocation and state.currentLocation.zoneId or 0;
    local cached = state.nmViewCache;
    if cached ~= nil and cached.query == query and cached.zoneId == zoneId and cached.sort == state.nmSort then
        return cached;
    end

    local current, other = {}, {};
    local view = {
        query = query,
        zoneId = zoneId,
        sort = state.nmSort,
        items = {},
        sections = {},
        visibleKeys = {},
        currentCount = 0,
    };
    for _, nm in ipairs(state.nms) do
        local visible = query == '' or lower(nm.monster):find(query, 1, true) ~= nil or
            lower(nm.zone):find(query, 1, true) ~= nil;
        if not visible then
            local methods = acquisition.spawnMethods[nm.zoneId];
            methods = methods and methods[nm.monster] or nil;
            for _, method in ipairs(methods or {}) do
                local placeholder = method.placeholder or method[1] or '';
                if lower(placeholder):find(query, 1, true) ~= nil then
                    visible = true;
                    break
                end
            end
        end
        if visible then
            local target = nm.zoneId == zoneId and current or other;
            target[#target + 1] = nm;
            view.visibleKeys[nm.key] = true;
        end
    end
    nmSortRows(current);
    nmSortRows(other);
    view.currentCount = #current;
    if zoneId > 0 then
        view.sections[#view.sections + 1] = {
            zoneId = zoneId,
            zone = state.currentLocation and state.currentLocation.zone or ('Zone #' .. tostring(zoneId)),
            current = true,
            items = current,
        };
    end
    local sectionsByZone = {};
    for _, nm in ipairs(other) do
        local section = sectionsByZone[nm.zoneId];
        if section == nil then
            section = { zoneId = nm.zoneId, zone = nm.zone, current = false, items = {} };
            sectionsByZone[nm.zoneId] = section;
            view.sections[#view.sections + 1] = section;
        end
        section.items[#section.items + 1] = nm;
    end
    table.sort(view.sections, function (a, b)
        if a.current ~= b.current then return a.current; end
        return lower(a.zone) < lower(b.zone);
    end);
    for _, section in ipairs(view.sections) do
        nmSortRows(section.items);
        for _, nm in ipairs(section.items) do view.items[#view.items + 1] = nm; end
    end
    state.nmViewCache = view;
    return view;
end

local function renderNmSections(view)
    for _, section in ipairs(view.sections) do
        local title;
        if section.current then
            title = string.format('Current Zone - %s (%d)', section.zone, #section.items);
        else
            title = string.format('%s (%d)', section.zone, #section.items);
        end
        if view.query ~= '' then imgui.SetNextItemOpen(true, ImGuiCond_Always); end
        local flags = section.current and ImGuiTreeNodeFlags_DefaultOpen or 0;
        if imgui.CollapsingHeader(title .. '###nm_zone_' .. tostring(section.zoneId), flags) then
            if #section.items == 0 then
                imgui.TextDisabled(view.query ~= '' and 'No matching NMs in this zone.' or
                    'No cataloged NMs in this zone.');
            end
            for _, nm in ipairs(section.items) do
                local level = nm.minLevel > 0 and tostring(nm.minLevel) or '?';
                local label = string.format('Lv.%s  %s##nm_%s', level, nm.monster, nm.key);
                if imgui.Selectable(label, state.selectedNm == nm) then state.selectedNm = nm; end
            end
        end
    end
end

local function nmEquipmentTooltip(drop)
    local category = drop.equipmentCategory == 2 and 'Weapon' or 'Armor';
    local lines = { drop.name };
    if drop.description ~= nil and drop.description ~= '' then
        lines[#lines + 1] = drop.description;
    end
    lines[#lines + 1] = '';
    lines[#lines + 1] = string.format('%s   Level %d', category, drop.level);
    if drop.equipmentCategory == 2 then
        lines[#lines + 1] = string.format('%s   DMG %d   Delay %d',
            WEAPON_TYPES[drop.skill] or 'Other weapon', drop.damage, drop.delay);
    end
    local slots = slotsText(drop.slots);
    if slots ~= '' then lines[#lines + 1] = 'Slots: ' .. slots; end
    local jobs = jobsText(drop.jobs);
    if jobs ~= '' then lines[#lines + 1] = 'Jobs: ' .. jobs; end
    return (table.concat(lines, '\n'):gsub('%%', '%%%%'));
end

local function renderNmDetails(nm, idPrefix)
    if nm == nil then
        imgui.TextDisabled('Select an NM from the list.');
        return;
    end
    if state.currentLocation ~= nil and nm.zoneId == state.currentLocation.zoneId then
        imgui.TextColored(theme.colors.ok, 'CURRENT ZONE');
    end
    imgui.TextWrapped(nm.monster);
    imgui.TextDisabled(nm.zone .. '   ' .. sourceLevelText(nm));
    renderSourcePosition(nm);
    portButton(closestTeleport(nm.zone), 'nm_' .. idPrefix .. '_' .. nm.key);
    imgui.Separator();
    imgui.TextColored(theme.colors.hint, 'SPAWN');
    local zoneMethods = acquisition.spawnMethods[nm.zoneId];
    local methods = zoneMethods and zoneMethods[nm.monster] or nil;
    if methods ~= nil and #methods > 0 then
        renderSpawnMethod(nm);
    else
        textDisabledWrapped('No script-exposed placeholder instructions are available. This NM may use a timed, forced, battlefield, event, or other spawn method.');
    end
    imgui.Separator();
    if #nm.drops > 0 then
        if imgui.CollapsingHeader(string.format('Tracked drops (%d)###nm_drops_open_%s', #nm.drops, nm.key),
            ImGuiTreeNodeFlags_DefaultOpen) then
            imgui.TextDisabled('Equipment and spell sources already tracked by VanaCompass. Drop rates are omitted.');
            for index = 1, math.min(#nm.drops, 50) do
                local drop = nm.drops[index];
                imgui.Selectable(drop.name .. '##nm_drop_' .. nm.key .. '_' .. tostring(drop.id), false);
                if drop.equipmentCategory ~= nil and imgui.IsItemHovered() then
                    imgui.SetTooltip(nmEquipmentTooltip(drop));
                end
            end
            if #nm.drops > 50 then
                imgui.TextDisabled(string.format('+ %d more tracked items', #nm.drops - 50));
            end
        end
    else
        imgui.TextDisabled('No equipment or spell drops are currently tracked for this NM.');
    end
end

local function renderNms()
    refreshCurrentLocation();
    local toolbarWidth = imgui.GetWindowWidth();
    searchHeader(state.nmSearch, 'NM, placeholder, or zone');
    if toolbarWidth >= 640 then imgui.SameLine(); end
    imgui.TextDisabled('Sort:');
    for index, label in ipairs({ 'Name', 'Level', 'Zone' }) do
        imgui.SameLine();
        local selected = pushSelectedButton(state.nmSort == index);
        if imgui.SmallButton(label .. '##nm_sort_' .. index) then state.nmSort = index; end
        if selected then imgui.PopStyleColor(); end
    end
    browserListToggle();
    local view = getNmView();
    local currentZone = state.currentLocation and state.currentLocation.zone or 'current zone';
    imgui.TextDisabled(string.format('%d NM%s match. %d in %s are pinned first.',
        #view.items, #view.items == 1 and '' or 's', view.currentCount, currentZone));
    imgui.Separator();

    local stacked = imgui.GetWindowWidth() < 760;
    if state.showBrowserList[1] and not stacked and
        imgui.BeginTable('##nm_layout', 2, ImGuiTableFlags_SizingStretchProp) then
        imgui.TableSetupColumn('Notorious monsters', ImGuiTableColumnFlags_WidthStretch, 1.15);
        imgui.TableSetupColumn('NM guide', ImGuiTableColumnFlags_WidthStretch, 1.85);
        imgui.TableNextRow(); imgui.TableNextColumn();
        imgui.BeginChild('##nm_list', { 0, 0 }, ImGuiChildFlags_Borders);
        renderNmSections(view);
        if #view.items == 0 then state.selectedNm = nil;
        elseif state.selectedNm == nil or not view.visibleKeys[state.selectedNm.key] then
            state.selectedNm = view.items[1];
        end
        imgui.EndChild();
        imgui.TableNextColumn();
        imgui.BeginChild('##nm_details', { 0, 0 }, ImGuiChildFlags_Borders);
        renderNmDetails(state.selectedNm, 'wide');
        imgui.EndChild();
        imgui.EndTable();
    else
        if state.showBrowserList[1] then
            imgui.BeginChild('##nm_list_stacked', { 0, 180 }, ImGuiChildFlags_Borders);
            renderNmSections(view);
            if #view.items == 0 then state.selectedNm = nil;
            elseif state.selectedNm == nil or not view.visibleKeys[state.selectedNm.key] then
                state.selectedNm = view.items[1];
            end
            imgui.EndChild();
        end
        imgui.BeginChild('##nm_details_stacked', { 0, 0 }, ImGuiChildFlags_Borders);
        renderNmDetails(state.selectedNm, 'stacked');
        imgui.EndChild();
    end
end

local function questVisible(quest)
    if state.questMode == 2 and not quest.artifact then return false; end
    if state.questMode == 3 and not quest.jobUnlock then return false; end
    if state.questMode == 2 and not state.showOtherArtifactJobs[1] and quest.jobId ~= nil then
        local player = AshitaCore:GetMemoryManager():GetPlayer();
        if player ~= nil and quest.jobId ~= player:GetMainJob() then return false; end
    end
    if not state.showAboveLevel[1] and quest.minLevel ~= nil then
        local player = AshitaCore:GetMemoryManager():GetPlayer();
        if player ~= nil and quest.minLevel > player:GetMainJobLevel() then return false; end
    end
    if state.questCompletionKnown and not state.showCompletedQuests[1] and
        completedQuest(quest.log, quest.id) and not activeQuest(quest.log, quest.id) then return false; end
    local query = lower(state.questSearch[1]);
    if query == '' or lower(quest.name):find(query, 1, true) or lower(quest.area):find(query, 1, true) or
        lower(quest.jobName):find(query, 1, true) then return true; end
    if quest.start ~= nil and
        (lower(quest.start.contact):find(query, 1, true) or lower(quest.start.location):find(query, 1, true) or
            lower(quest.start.grid):find(query, 1, true)) then return true; end
    for _, step in ipairs(quest.steps) do
        if lower(step.text):find(query, 1, true) or lower(step.pos):find(query, 1, true) then return true; end
    end
    return false;
end

local function renderGuideSteps(entry, prefix, firstIsStart, progress)
    local progressMatches = progress ~= nil and not progress.unclear and progress.step > 0 and
        progress.n == #entry.steps;
    if progress ~= nil then
        if progress.unclear then
            imgui.TextColored(theme.colors.warn,
                'Active, but DWTracker cannot determine one unique current objective.');
        elseif progress.n ~= #entry.steps then
            imgui.TextColored(theme.colors.warn,
                string.format('Active, but guide data has %d steps while the server reports %d; no step is highlighted.',
                    #entry.steps, progress.n));
        elseif progress.step > 0 then
            imgui.TextColored(theme.colors.hint,
                string.format('CURRENT OBJECTIVE: STEP %d OF %d', progress.step, progress.n));
        end
        imgui.Separator();
    end
    for index, step in ipairs(entry.steps) do
        local isCurrent = progressMatches and index == progress.step;
        local isDone = progressMatches and index < progress.step;
        if isCurrent then
            imgui.TextColored(theme.colors.hint, 'CURRENT STEP ' .. tostring(index));
        elseif isDone then
            imgui.TextColored(theme.colors.dim, 'DONE - STEP ' .. tostring(index));
        elseif index == 1 and firstIsStart then
            imgui.TextColored(theme.colors.ok, 'START / FIRST OBJECTIVE');
        else
            imgui.TextColored(theme.colors.hint, 'STEP ' .. tostring(index));
        end
        if isCurrent then imgui.PushStyleColor(ImGuiCol_Text, theme.colors.hint);
        elseif isDone then imgui.PushStyleColor(ImGuiCol_Text, theme.colors.dim); end
        imgui.TextWrapped(step.text or '');
        if isCurrent or isDone then imgui.PopStyleColor(); end
        if step.pos ~= nil and step.pos ~= '' then
            renderGuideLocation(step.pos, prefix .. '_' .. index);
        end
        if index < #entry.steps then imgui.Separator(); end
    end
end

local function renderStartCard(entry, idPrefix)
    local start = entry.start;
    imgui.TextColored(theme.colors.ok, 'START');
    if start == nil then
        imgui.TextDisabled('Starter information is unavailable for this entry.');
        return;
    end
    imgui.TextDisabled(start.kind .. ':'); imgui.SameLine(); imgui.TextWrapped(start.contact);
    local grid, hasPosition = guidePositionGrid(start.location);
    if start.grid ~= nil and start.grid ~= '' then grid = start.grid; end
    if grid ~= nil then
        imgui.TextDisabled('Map grid:'); imgui.SameLine(); imgui.Text(grid);
    elseif hasPosition then
        imgui.TextDisabled('Map grid: unavailable');
    end
    imgui.TextDisabled('Exact location:'); imgui.SameLine(); imgui.TextWrapped(start.location);
    local zone = zoneFromText(start.location);
    portButton(zone and closestTeleport(zone) or nil, idPrefix);
    imgui.Separator();
    imgui.TextDisabled('Walkthrough');
end

local function renderQuests()
    if state.showBrowserList[1] then
        searchHeader(state.questSearch, 'quest, region, NPC, item, or zone');
        imgui.SameLine();
        if imgui.Button('Open active tracker') then AshitaCore:GetChatManager():QueueCommand(1, '/tracker'); end
        if imgui.IsItemHovered() then imgui.SetTooltip('Open Driftwood\'s authoritative active/completed quest tracker.'); end
        imgui.SameLine(); imgui.Checkbox('Show quests above my level', state.showAboveLevel);
        imgui.SameLine(); imgui.Checkbox('Show completed', state.showCompletedQuests);
        imgui.SameLine();
        if imgui.Button('Sync completion##quests') then requestMissionSync(); end
        for index, label in ipairs({ 'All quests', 'Artifact quests', 'Job unlocks' }) do
            if index > 1 then imgui.SameLine(); end
            local selected = pushSelectedButton(state.questMode == index);
            if imgui.Button(label .. '##questmode_' .. index) then state.questMode = index; end
            if selected then imgui.PopStyleColor(); end
        end
        if state.questMode == 2 then
            imgui.SameLine(); imgui.Checkbox('Show other jobs', state.showOtherArtifactJobs);
        end
        imgui.SameLine();
        local player = AshitaCore:GetMemoryManager():GetPlayer();
        if player then
            local jobName = AshitaCore:GetResourceManager():GetString('jobs.names_abbr', player:GetMainJob()) or '?';
            imgui.TextDisabled(string.format('Current job: %s %d', jobName, player:GetMainJobLevel()));
        else
            imgui.TextDisabled('Current job unavailable');
        end
        if state.questMode == 3 then
            imgui.TextWrapped('Advanced-job unlock chains are listed in prerequisite order. Reach level 30 on any job before starting the final unlock steps.');
        end
        imgui.TextWrapped('Level-appropriate entries are shown by default. Fame, job, nation, prior quests and other prerequisites still apply. ' .. state.missionSyncStatus);
    end
    browserListToggle();
    imgui.Separator();
    local questStacked = imgui.GetWindowWidth() < 760;
    if state.showBrowserList[1] and imgui.BeginTable('##quest_layout', questStacked and 1 or 2, ImGuiTableFlags_SizingStretchProp) then
        imgui.TableSetupColumn('Quests', ImGuiTableColumnFlags_WidthStretch, questStacked and 1.0 or 0.85);
        if not questStacked then imgui.TableSetupColumn('Guide', ImGuiTableColumnFlags_WidthStretch, 2.15); end
        imgui.TableNextRow(); imgui.TableNextColumn();
        imgui.BeginChild('##quest_list', { 0, questStacked and 180 or 0 }, ImGuiChildFlags_Borders);
        local visibleQuests = {};
        for _, quest in ipairs(state.quests) do
            if questVisible(quest) then visibleQuests[#visibleQuests + 1] = quest; end
        end
        if state.questMode == 3 then
            table.sort(visibleQuests, function (a, b)
                if a.jobOrder ~= b.jobOrder then return a.jobOrder < b.jobOrder; end
                return a.chainStep < b.chainStep;
            end);
        end
        local lastGroup = nil;
        local firstVisible = nil;
        for _, quest in ipairs(visibleQuests) do
            firstVisible = firstVisible or quest;
            local group = state.questMode == 3 and quest.jobName or quest.area;
            if lastGroup ~= group then imgui.TextDisabled(group); lastGroup = group; end
            local levelLabel = quest.minLevel and ('[Lv.' .. quest.minLevel .. '] ') or '';
            local chainLabel = state.questMode == 3 and
                string.format('[%d/%d] ', quest.chainStep, quest.chainCount) or '';
            local progress = questProgress(quest.log, quest.id);
            local statusLabel;
            if progress ~= nil and not progress.unclear and progress.step > 0 then
                statusLabel = string.format('[Active %d/%d] ', progress.step, progress.n);
            elseif activeQuest(quest.log, quest.id) then
                statusLabel = '[Active] ';
            else
                statusLabel = completedQuest(quest.log, quest.id) and '[Done] ' or '';
            end
            if imgui.Selectable(statusLabel .. chainLabel .. levelLabel .. quest.name .. '##q' .. quest.log .. '_' .. quest.id,
                state.selectedQuest == quest) then
                state.selectedQuest = quest;
            end
        end
        if firstVisible == nil then
            imgui.TextDisabled('No matching quests. Enable Show completed or change the job, level, or search filter.');
            state.selectedQuest = nil;
        elseif state.selectedQuest == nil or not questVisible(state.selectedQuest) then
            state.selectedQuest = firstVisible;
        end
        imgui.EndChild();
        if questStacked then imgui.TableNextRow(); end
        imgui.TableNextColumn();
        imgui.BeginChild('##quest_details', { 0, 0 }, ImGuiChildFlags_Borders);
        local quest = state.selectedQuest;
        if quest then
            imgui.TextWrapped(quest.name .. '  ' .. quest.area);
            if activeQuest(quest.log, quest.id) then
                imgui.SameLine(); imgui.TextColored(theme.colors.info, 'Active');
            elseif completedQuest(quest.log, quest.id) then
                imgui.SameLine(); imgui.TextColored(theme.colors.ok, 'Completed');
            end
            imgui.Separator();
            if quest.jobUnlock then
                local stage = quest.chainStep == quest.chainCount and 'Final job-unlock quest' or
                    string.format('Prerequisite %d of %d', quest.chainStep, quest.chainCount - 1);
                imgui.TextColored(theme.colors.warn, quest.jobName .. ' - ' .. stage);
            end
            if quest.minLevel then imgui.TextDisabled('Stated minimum level: ' .. quest.minLevel); end
            renderStartCard(quest, 'quest_start_' .. quest.log .. '_' .. quest.id);
            renderGuideSteps(quest, 'quest_' .. quest.log .. '_' .. quest.id, false,
                questProgress(quest.log, quest.id));
        end
        imgui.EndChild();
        imgui.EndTable();
    elseif not state.showBrowserList[1] then
        imgui.BeginChild('##quest_details_full', { 0, 0 }, ImGuiChildFlags_Borders);
        local quest = state.selectedQuest;
        if quest then
            imgui.TextWrapped(quest.name .. '  ' .. quest.area);
            if activeQuest(quest.log, quest.id) then imgui.SameLine(); imgui.TextColored(theme.colors.info, 'Active');
            elseif completedQuest(quest.log, quest.id) then imgui.SameLine(); imgui.TextColored(theme.colors.ok, 'Completed'); end
            imgui.Separator();
            if quest.jobUnlock then
                local stage = quest.chainStep == quest.chainCount and 'Final job-unlock quest' or
                    string.format('Prerequisite %d of %d', quest.chainStep, quest.chainCount - 1);
                imgui.TextColored(theme.colors.warn, quest.jobName .. ' - ' .. stage);
            end
            if quest.minLevel then imgui.TextDisabled('Stated minimum level: ' .. quest.minLevel); end
            renderStartCard(quest, 'quest_start_full_' .. quest.log .. '_' .. quest.id);
            renderGuideSteps(quest, 'quest_full_' .. quest.log .. '_' .. quest.id, false,
                questProgress(quest.log, quest.id));
        else imgui.TextDisabled('Show the list and select a quest.'); end
        imgui.EndChild();
    end
end

local function missionVisible(mission)
    if state.storyMode ~= 0 and mission.areaIndex ~= state.storyMode then return false; end
    if state.missionCompletionKnown and not state.showCompletedMissions[1] and
        completedMission(mission.log, mission.id) and not activeMission(mission.log, mission.id) then return false; end
    local query = lower(state.missionSearch[1]);
    if query == '' or lower(mission.name):find(query, 1, true) or lower(mission.area):find(query, 1, true) then return true; end
    if mission.start ~= nil and
        (lower(mission.start.contact):find(query, 1, true) or lower(mission.start.location):find(query, 1, true)) then return true; end
    for _, step in ipairs(mission.steps) do
        if lower(step.text):find(query, 1, true) or lower(step.pos):find(query, 1, true) then return true; end
    end
    return false;
end

local function renderMainStory()
    searchHeader(state.missionSearch, 'mission, NPC, objective, or zone');
    imgui.SameLine();
    if imgui.Button('Open active tracker##missions') then AshitaCore:GetChatManager():QueueCommand(1, '/tracker'); end
    imgui.SameLine(); imgui.Checkbox('Show completed', state.showCompletedMissions);
    imgui.SameLine();
    if imgui.Button('Sync completion') then requestMissionSync(); end
    local labels = { 'All', "San d'Oria", 'Bastok', 'Windurst', 'Rise of the Zilart' };
    for index, label in ipairs(labels) do
        imgui.SameLine();
        local mode = index - 1;
        local selected = pushSelectedButton(state.storyMode == mode);
        if imgui.SmallButton(label .. '##story_' .. mode) then state.storyMode = mode; end
        if selected then imgui.PopStyleColor(); end
    end
    if state.showBrowserList[1] then
        imgui.TextWrapped('Missions are listed in story-ID order within each line. ' .. state.missionSyncStatus);
    end
    browserListToggle();
    imgui.Separator();
    local storyStacked = imgui.GetWindowWidth() < 760;
    if state.showBrowserList[1] and imgui.BeginTable('##story_layout', storyStacked and 1 or 2, ImGuiTableFlags_SizingStretchProp) then
        imgui.TableSetupColumn('Mission chain', ImGuiTableColumnFlags_WidthStretch, storyStacked and 1.0 or 0.9);
        if not storyStacked then imgui.TableSetupColumn('Guide', ImGuiTableColumnFlags_WidthStretch, 2.1); end
        imgui.TableNextRow(); imgui.TableNextColumn();
        imgui.BeginChild('##story_list', { 0, storyStacked and 180 or 0 }, ImGuiChildFlags_Borders);
        local lastArea = nil;
        local firstVisible = nil;
        for _, mission in ipairs(state.missions) do
            if missionVisible(mission) then
                firstVisible = firstVisible or mission;
                if lastArea ~= mission.area then imgui.TextDisabled(mission.area); lastArea = mission.area; end
                local repeatLabel = mission.repeatable and ' [repeatable]' or '';
                local progress = missionProgress(mission.log, mission.id);
                local statusLabel = completedMission(mission.log, mission.id) and '[Done] ' or '';
                if progress ~= nil and not progress.unclear and progress.step > 0 then
                    statusLabel = string.format('[Active %d/%d] ', progress.step, progress.n);
                elseif activeMission(mission.log, mission.id) then
                    statusLabel = '[Active] ';
                end
                if imgui.Selectable(statusLabel .. mission.name .. repeatLabel .. '##m' .. mission.log .. '_' .. mission.id,
                    state.selectedMission == mission) then state.selectedMission = mission; end
            end
        end
        if firstVisible == nil then
            imgui.TextDisabled('No matching missions. Enable Show completed or change the story filter.');
            state.selectedMission = nil;
        elseif state.selectedMission == nil or not missionVisible(state.selectedMission) then
            state.selectedMission = firstVisible;
        end
        imgui.EndChild();
        if storyStacked then imgui.TableNextRow(); end
        imgui.TableNextColumn();
        imgui.BeginChild('##story_details', { 0, 0 }, ImGuiChildFlags_Borders);
        local mission = state.selectedMission;
        if mission then
            imgui.TextWrapped(mission.name .. '  ' .. mission.area);
            if activeMission(mission.log, mission.id) then
                imgui.SameLine(); imgui.TextColored(theme.colors.info, 'Active');
            elseif completedMission(mission.log, mission.id) then
                imgui.SameLine(); imgui.TextColored(theme.colors.ok, 'Completed');
            end
            imgui.Separator();
            renderStartCard(mission, 'mission_start_' .. mission.log .. '_' .. mission.id);
            renderGuideSteps(mission, 'mission_' .. mission.log .. '_' .. mission.id, false,
                missionProgress(mission.log, mission.id));
        end
        imgui.EndChild();
        imgui.EndTable();
    elseif not state.showBrowserList[1] then
        imgui.BeginChild('##story_details_full', { 0, 0 }, ImGuiChildFlags_Borders);
        local mission = state.selectedMission;
        if mission then
            imgui.TextWrapped(mission.name .. '  ' .. mission.area);
            if activeMission(mission.log, mission.id) then imgui.SameLine(); imgui.TextColored(theme.colors.info, 'Active');
            elseif completedMission(mission.log, mission.id) then imgui.SameLine(); imgui.TextColored(theme.colors.ok, 'Completed'); end
            imgui.Separator();
            renderStartCard(mission, 'mission_start_full_' .. mission.log .. '_' .. mission.id);
            renderGuideSteps(mission, 'mission_full_' .. mission.log .. '_' .. mission.id, false,
                missionProgress(mission.log, mission.id));
        else imgui.TextDisabled('Show the list and select a mission.'); end
        imgui.EndChild();
    end
end

local function renderWelcome()
    if not imgui.BeginChild('##welcome_content', { 0, 0 }, ImGuiChildFlags_None) then
        imgui.EndChild();
        return;
    end
    imgui.Text('VanaCompass');
    imgui.TextWrapped('A searchable in-game guide for finding useful purchases and figuring out where to go next. Every Port button uses Driftwood\'s normal travel command; the server still checks unlocks and travel rules.');
    imgui.TextWrapped('/vana toggles this window; /vana <text> searches all purchase tabs.');
    imgui.Separator();

    imgui.TextColored(theme.colors.hint, 'TAB VISIBILITY');
    imgui.TextWrapped('Choose which guide tabs appear above. Welcome always remains visible so you can change these settings later.');
    local tabSettingsChanged = false;
    if imgui.Button('Show all tabs##welcome_show_all_tabs') then
        for _, tab in ipairs(TAB_DEFINITIONS) do state.visibleTabs[tab.key][1] = true; end
        tabSettingsChanged = true;
    end
    imgui.SameLine();
    if imgui.Button('Spells only##welcome_spells_only') then
        for _, tab in ipairs(TAB_DEFINITIONS) do
            state.visibleTabs[tab.key][1] = tab.key == 'spells';
        end
        tabSettingsChanged = true;
    end
    for _, tab in ipairs(TAB_DEFINITIONS) do
        if imgui.Checkbox(tab.label .. '##welcome_tab_' .. tab.key, state.visibleTabs[tab.key]) then
            tabSettingsChanged = true;
        end
    end
    if tabSettingsChanged then saveVisibleTabs(); end
    imgui.Separator();

    if imgui.CollapsingHeader('NEW PLAYER###welcome_new_player') then
        imgui.TextColored(theme.colors.warn, 'SIGNET, CONQUEST POINTS, AND EXP RINGS');
        imgui.TextWrapped('Keep Signet active while adventuring in conquest regions. Defeating eligible enemies with Signet earns Conquest Points, which buy some of the most useful early progression rewards.');
        imgui.Spacing();
        imgui.TextColored(theme.colors.hint, '1. Cast Signet anywhere');
        imgui.TextWrapped('Type !signet anywhere on DriftwoodXI to receive the Signet buff. Recast it whenever it expires or is removed.');
        if imgui.Button('Cast Signet now##welcome_signet') then
            AshitaCore:GetChatManager():QueueCommand(1, '!signet');
        end
        if imgui.IsItemHovered() then imgui.SetTooltip('Runs the DriftwoodXI !signet command.'); end
        imgui.Spacing();
        imgui.TextColored(theme.colors.hint, '2. Buy an EXP ring from a city Conquest guard');
        imgui.TextWrapped('Return to your home nation and speak with a Conquest guard near a city gate or exit. San d\'Oria has guards in Southern and Northern San d\'Oria; Bastok has guards in Bastok Markets and Bastok Mines; Windurst has guards throughout its Waters, Woods, Walls, and Port districts.');
        imgui.TextWrapped('Choose the option to spend Conquest Points, open Common rewards, and look for Chariot Band, Empress Band, or Emperor Band. Availability and cost still follow the server\'s conquest rules.');
        imgui.Spacing();
        imgui.TextColored(theme.colors.hint, '3. Use the ring while leveling');
        imgui.TextWrapped('Equip the ring and use it from the item menu to activate its EXP bonus. These rings have limited charges and reuse restrictions, so keep one ready and refresh or replace it through a Conquest guard when allowed.');
        imgui.Spacing();
        imgui.TextColored(theme.colors.hint, '4. Earn Drift Coins with /quests');
        imgui.TextWrapped('Type /quests anywhere to open the Drift Board. It offers three daily and three weekly contracts for your current level band, tracks their progress as you fight, and also shows the server-wide community contract. Accept contracts before working on their objectives; completed contracts pay DC, which means Drift Coins.');
        if imgui.Button('Open Drift Board##welcome_quests') then
            AshitaCore:GetChatManager():QueueCommand(1, '/quests');
        end
        if imgui.IsItemHovered() then imgui.SetTooltip('Runs /quests to open DriftwoodXI\'s Drift Board.'); end
        imgui.Spacing();
        imgui.TextColored(theme.colors.hint, '5. Spend DC on augments');
        imgui.TextWrapped('Open the Exchange tab inside /quests to see the current rotating augment offers and their DC prices. Choose an augment, select eligible unequipped gear, review the destination slot and quoted price, then confirm the purchase. Augmented equipment becomes bound to your account and cannot be traded, auctioned, or bazaared.');
    end
    imgui.Separator();

    imgui.BulletText(string.format('%d vendor, quest-reward, and monster-dropped spells with learned/missing state.', #state.spells));
    imgui.BulletText(string.format('%d weapons and %d armor pieces sold by standard vendors.', #state.items.weapon, #state.items.armor));
    imgui.BulletText(string.format('%d other vendor supplies.', #state.items.supply));
    imgui.BulletText(string.format('%d searchable crafting-related items with NPC and synthesis sources.', #state.materials));
    imgui.BulletText(string.format('%d non-vendor dropped weapons and armor.', #state.dropItems));
    imgui.BulletText(string.format('%d notorious monsters with current-zone priority.', #state.nms));
    imgui.BulletText(string.format('%d implemented regional quest guides.', #state.quests));
    imgui.BulletText(string.format('%d nation and Zilart main-story mission guides.', #state.missions));
    imgui.Spacing();
    imgui.TextWrapped('Vendor inventories are generated from standard LandSandBoat data. Quest steps are Driftwood\'s own guide data.');
    imgui.EndChild();
end

local function renderWindow()
    renderCurrentLocation();
    imgui.Separator();
    if imgui.Button('Refresh character state') then rebuildCatalogs(); end
    imgui.Separator();
    if imgui.BeginTabBar('##vanacompass_tabs') then
        if imgui.BeginTabItem('Welcome') then renderWelcome(); imgui.EndTabItem(); end
        if state.visibleTabs.spells[1] and imgui.BeginTabItem('Spells') then renderSpells(); imgui.EndTabItem(); end
        if state.visibleTabs.vendorGear[1] and imgui.BeginTabItem('Vendor Gear') then renderVendorGear(); imgui.EndTabItem(); end
        if state.visibleTabs.supplies[1] and imgui.BeginTabItem('Supplies') then renderItems('supply'); imgui.EndTabItem(); end
        if state.visibleTabs.materials[1] and imgui.BeginTabItem('Materials') then renderMaterials(); imgui.EndTabItem(); end
        if state.visibleTabs.drops[1] and imgui.BeginTabItem('Drops') then renderDrops(); imgui.EndTabItem(); end
        if state.visibleTabs.nms[1] and imgui.BeginTabItem('NMs') then renderNms(); imgui.EndTabItem(); end
        if state.visibleTabs.quests[1] and imgui.BeginTabItem('Quests') then renderQuests(); imgui.EndTabItem(); end
        if state.visibleTabs.mainStory[1] and imgui.BeginTabItem('Main Story') then renderMainStory(); imgui.EndTabItem(); end
        imgui.EndTabBar();
    end
end

local function handleTrackerRecord(line)
    local parts = splitFields(line, '|');
    local kind = parts[1];
    if kind == 'd' then
        local version = tonumber(parts[2]) or 0;
        if version ~= 1 then
            state.missionSyncInbound = false;
            state.missionSyncStatus = string.format('Tracker protocol %d is unsupported; update VanaCompass.', version);
            return;
        end
        state.missionSyncInbound = parts[3] == 'sync';
        if state.missionSyncInbound then
            state.completedQuestChunks = {};
            state.activeQuestIds = {};
            state.activeQuestSteps = {};
            state.completedMissionChunks = {};
            state.activeMissionIds = {};
            state.activeMissionSteps = {};
        end
        return;
    end
    if kind == 'm' or kind == 'e' then
        state.missionSyncStatus = line:sub(3);
        if kind == 'e' then state.missionSyncInbound = false; end
        return;
    end
    if not state.missionSyncInbound then return; end
    if kind == 'z' then
        state.missionSyncInbound = false;
        state.questCompletionKnown = true;
        state.missionCompletionKnown = true;
        state.missionSyncStatus = 'Completion status synced.';
        return;
    end
    if kind == 'am' then
        local log = tonumber(parts[2]);
        local row = splitFields(parts[3], ':');
        if log ~= nil and row[1] ~= nil then
            local id = tonumber(row[1]);
            state.activeMissionIds[log] = id;
            if id ~= nil then
                state.activeMissionSteps[log] = {
                    id = id,
                    step = tonumber(row[2]) or 0,
                    n = tonumber(row[3]) or 0,
                };
            end
        end
        return;
    end
    if kind == 'aq' then
        local log = tonumber(parts[2]);
        if log == nil then return; end
        state.activeQuestIds[log] = state.activeQuestIds[log] or {};
        state.activeQuestSteps[log] = state.activeQuestSteps[log] or {};
        for _, encoded in ipairs(splitFields(parts[3], ',')) do
            local row = splitFields(encoded, ':');
            local id = tonumber(row[1]);
            if id ~= nil then
                state.activeQuestIds[log][id] = true;
                state.activeQuestSteps[log][id] = {
                    step = tonumber(row[2]) or 0,
                    n = tonumber(row[3]) or 0,
                };
            end
        end
        return;
    end
    if kind == 'u' and parts[2] == 'q' then
        local log, id = tonumber(parts[3]), tonumber(parts[4]);
        if log ~= nil and id ~= nil then
            state.activeQuestIds[log] = state.activeQuestIds[log] or {};
            state.activeQuestIds[log][id] = true;
            state.activeQuestSteps[log] = state.activeQuestSteps[log] or {};
            state.activeQuestSteps[log][id] = { step = 0, n = 0, unclear = true };
        end
        return;
    end
    if kind == 'u' and parts[2] == 'm' then
        local log, id = tonumber(parts[3]), tonumber(parts[4]);
        if log ~= nil and id ~= nil then
            state.activeMissionIds[log] = id;
            state.activeMissionSteps[log] = { id = id, step = 0, n = 0, unclear = true };
        end
        return;
    end
    if kind == 'cm' then
        local log = tonumber(parts[2]);
        if log == nil then return; end
        state.completedMissionChunks[log] = state.completedMissionChunks[log] or {};
        for _, encoded in ipairs(splitFields(parts[3], ',')) do
            local row = splitFields(encoded, ':');
            if row[1] ~= nil and row[2] ~= nil then
                state.completedMissionChunks[log][tonumber(row[1]) or 0] = tonumber(row[2], 16) or 0;
            end
        end
        return;
    end
    if kind == 'cq' then
        local log = tonumber(parts[2]);
        if log == nil then return; end
        state.completedQuestChunks[log] = state.completedQuestChunks[log] or {};
        for _, encoded in ipairs(splitFields(parts[3], ',')) do
            local row = splitFields(encoded, ':');
            if row[1] ~= nil and row[2] ~= nil then
                state.completedQuestChunks[log][tonumber(row[1]) or 0] = tonumber(row[2], 16) or 0;
            end
        end
    end
end

ashita.events.register('packet_in', 'vanacompass_tracker_packet', function (e)
    if e.id ~= 0x0017 then return; end
    local sender = e.data_modified:sub(0x09, 0x17):gsub('%z.*$', '');
    if sender ~= '_DWTDATA' then return; end
    e.blocked = true;
    local message = e.data_modified:sub(0x18, e.size):gsub('%z.*$', '');
    local ok, err = pcall(handleTrackerRecord, message);
    if not ok then state.missionSyncStatus = 'Completion sync error: ' .. tostring(err); end
end);

ashita.events.register('load', 'vanacompass_load', function ()
    rebuildCatalogs(); rebuildQuests(); rebuildMissions();
    requestMissionSync();
    print(chat.header('vanacompass'):append(chat.message('/vana opens VanaCompass. ScrollFinder remains available separately with /scrolls.')));
end);

ashita.events.register('command', 'vanacompass_command', function (e)
    local args = e.command:args();
    if #args == 0 or (args[1] ~= '/vana' and args[1] ~= '/vanacompass' and args[1] ~= '/vc') then return; end
    e.blocked = true;
    if #args >= 2 and lower(args[2]) == 'help' then
        print(chat.header('vanacompass'):append(chat.message('/vana toggles; /vana <text> opens and searches purchases; /vana refresh rereads character state.')));
        return;
    elseif #args >= 2 and lower(args[2]) == 'refresh' then
        rebuildCatalogs(); rebuildQuests(); rebuildMissions();
        requestMissionSync();
        print(chat.header('vanacompass'):append(chat.message('Catalog and character state refreshed.')));
        return;
    elseif #args >= 2 then
        local terms = {};
        for index = 2, #args do terms[#terms + 1] = args[index]; end
        local query = table.concat(terms, ' ');
        state.spellSearch[1], state.itemSearch[1], state.materialSearch[1], state.dropSearch[1],
            state.nmSearch[1], state.questSearch[1], state.missionSearch[1] =
            query, query, query, query, query, query, query;
        state.open[1] = true;
    else
        state.open[1] = not state.open[1];
    end
end);

ashita.events.register('d3d_present', 'vanacompass_present', function ()
    if not state.open[1] then return; end
    local pushed = theme.push();
    imgui.SetNextWindowSize({ 1120, 650 }, ImGuiCond_FirstUseEver);
    local visible = imgui.Begin('VanaCompass##vanacompass', state.open,
        bit.bor(ImGuiWindowFlags_NoDocking, ImGuiWindowFlags_NoScrollbar));
    if visible then
        local ok, err = pcall(renderWindow);
        if not ok then
            state.open[1] = false;
            if not state.errorReported then
                state.errorReported = true;
                print(chat.header('vanacompass'):append(chat.error('Window closed after an error: ' .. tostring(err))));
            end
        end
    end
    imgui.End();
    theme.pop(pushed);
end);
