--[[
* DriftwoodXI -- dwtheme
*
* The shared paint for every Driftwood addon window. Stock Ashita ImGui greys
* belong to everyone; these windows are the server's own UI, so they wear the
* launcher's colors instead -- the same deep-ocean-and-sea-glass palette the
* DriftwoodXI launcher paints itself with.
*
* WHERE THE COLORS COME FROM. The launcher writes its active Appearance theme
* to `<Ashita>/config/driftwood-theme.ini` every time the theme is applied --
* pick Nightshade in the launcher and the in-game windows go violet with it.
* The file is re-read every couple of seconds, so changing the launcher theme
* recolors an open game live, no reload required. No file (no launcher, or a
* theme never synced) means the built-in Driftwood house palette below: the
* windows are branded either way, the launcher is a paintbrush, not a
* dependency.
*
* HOW IT IS APPLIED. `push()` pushes the whole ImGui style-color set plus the
* rounding vars and returns what it pushed; `pop()` takes that token back.
* The pair wraps each addon's Begin/End -- OUTSIDE the render pcall, like
* Begin/End themselves, so the style stack stays balanced whatever the render
* pass does. Nothing here touches the global style: other addons keep their
* own look, which is rather the point.
*
* SEMANTIC COLORS. `colors.ok`, `.err`, `.warn`, `.hint`, `.badge`, `.inert`,
* `.pin` are stable table references the addons hand to TextColored; a reload
* rewrites their contents in place, so holding one in a local at file scope is
* safe and stays live.
*
* THIS FILE IS DUPLICATED into each dw* addon folder on purpose: an addon
* folder is the unit of distribution ("copy the folder into addons/"), and a
* shared copy in addons/libs would not travel with it. The copy in dwbags is
* the master; edit there and re-copy.
--]]

local imgui = require('imgui');

local M = {};

-- The Driftwood house palette -- the launcher's base theme tokens
-- (src/renderer/src/theme/tokens.css) in #RRGGBB / #RRGGBBAA form. Every key
-- the ini may carry has a default here, so a partial or absent file can never
-- leave a slot unpainted.
local DEFAULTS = {
    bgDeep       = '#050b13',
    bg           = '#081220',
    surface      = '#0d1a2bb8',
    text         = '#dce8f2',
    textDim      = '#8fa5b8',
    textFaint    = '#5b7186',
    accent       = '#45c6b8',
    accentStrong = '#6fe3d5',
    accentDeep   = '#2b9d92',
    accentInk    = '#04211d',
    wood         = '#c9a87c',
    woodDim      = '#8a7357',
    line         = '#97b2c924',
    lineStrong   = '#97b2c947',
    ok           = '#4ade80',
    warn         = '#fbbf24',
    err          = '#f87171',
    info         = '#7dd3fc',
};

-- '#RRGGBB' or '#RRGGBBAA' -> { r, g, b, a } in 0..1, or nil if malformed.
local function parseHex(value)
    if (type(value) ~= 'string') then
        return nil;
    end

    local hex = value:match('^#(%x%x%x%x%x%x%x?%x?)$');

    if (hex == nil or (#hex ~= 6 and #hex ~= 8)) then
        return nil;
    end

    local r = tonumber(hex:sub(1, 2), 16) / 255;
    local g = tonumber(hex:sub(3, 4), 16) / 255;
    local b = tonumber(hex:sub(5, 6), 16) / 255;
    local a = 1.0;

    if (#hex == 8) then
        a = tonumber(hex:sub(7, 8), 16) / 255;
    end

    return { r, g, b, a };
end

-- Linear blend of two colors' rgb, opaque result.
local function mix(a, b, t)
    return {
        a[1] + (b[1] - a[1]) * t,
        a[2] + (b[2] - a[2]) * t,
        a[3] + (b[3] - a[3]) * t,
        1.0,
    };
end

local function withAlpha(c, alpha)
    return { c[1], c[2], c[3], alpha };
end

local TRANSPARENT = { 0, 0, 0, 0 };

-- Stable tables the addons hold references to; rebuild() rewrites the
-- contents, never the identity.
M.colors = {
    ok    = {},     -- confirmations ("Sent.")
    err   = {},     -- refusals and errors
    warn  = {},     -- unsaved / caution
    info  = {},     -- informational badges
    hint  = {},     -- the upgrade-marker seafoam
    badge = {},     -- shipped-preset / read-only markers
    inert = {},     -- rows that are present but not active
    pin   = {},     -- the [pin] marker
    text  = {},
    dim   = {},
};

-- The launcher theme's display name, for anything that wants to say it.
M.name = 'Driftwood';

local styleColors = {};     -- { { ImGuiCol_*, {r,g,b,a} }, ... }
local styleVars   = {};     -- { { ImGuiStyleVar_*, value }, ... }

local function setInPlace(dst, src)
    dst[1], dst[2], dst[3], dst[4] = src[1], src[2], src[3], src[4];
end

--[[
* Turn the ~18 semantic palette entries into the full ImGui slot list. Shades
* the palette does not spell out (hovered/active steps, translucent fills) are
* derived here with mix/alpha, so the ini stays small and semantic and every
* launcher theme -- light Shoreline included -- gets coherent widget states
* for free. Translucent accent fills rather than opaque ones are what keep
* button labels readable in both directions: over a dark ground the label is
* pale text on a tinted glass, over Shoreline's paper it is dark text on a
* pale wash.
--]]
local function rebuild(pal)
    local bg      = pal.bg;
    local bgDeep  = pal.bgDeep;
    local text    = pal.text;
    local accent  = pal.accent;
    local strong  = pal.accentStrong;
    local deep    = pal.accentDeep;
    local wood    = pal.wood;

    styleColors = {
        { ImGuiCol_Text,                    text },
        { ImGuiCol_TextDisabled,            pal.textFaint },
        { ImGuiCol_WindowBg,                withAlpha(bg, 0.94) },
        { ImGuiCol_ChildBg,                 TRANSPARENT },
        { ImGuiCol_PopupBg,                 withAlpha(bgDeep, 0.96) },
        { ImGuiCol_Border,                  pal.lineStrong },
        { ImGuiCol_BorderShadow,            TRANSPARENT },
        { ImGuiCol_FrameBg,                 withAlpha(mix(bg, accent, 0.10), 0.62) },
        { ImGuiCol_FrameBgHovered,          withAlpha(mix(bg, accent, 0.20), 0.70) },
        { ImGuiCol_FrameBgActive,           withAlpha(mix(bg, accent, 0.28), 0.78) },
        { ImGuiCol_TitleBg,                 withAlpha(bgDeep, 0.95) },
        { ImGuiCol_TitleBgActive,           mix(bgDeep, deep, 0.55) },
        { ImGuiCol_TitleBgCollapsed,        withAlpha(bgDeep, 0.80) },
        { ImGuiCol_MenuBarBg,               withAlpha(bgDeep, 0.90) },
        { ImGuiCol_ScrollbarBg,             withAlpha(bgDeep, 0.55) },
        { ImGuiCol_ScrollbarGrab,           mix(bg, text, 0.22) },
        { ImGuiCol_ScrollbarGrabHovered,    mix(bg, text, 0.32) },
        { ImGuiCol_ScrollbarGrabActive,     accent },
        { ImGuiCol_CheckMark,               strong },
        { ImGuiCol_SliderGrab,              accent },
        { ImGuiCol_SliderGrabActive,        strong },
        { ImGuiCol_Button,                  withAlpha(accent, 0.32) },
        { ImGuiCol_ButtonHovered,           withAlpha(accent, 0.55) },
        { ImGuiCol_ButtonActive,            withAlpha(strong, 0.70) },
        { ImGuiCol_Header,                  withAlpha(accent, 0.26) },
        { ImGuiCol_HeaderHovered,           withAlpha(accent, 0.38) },
        { ImGuiCol_HeaderActive,            withAlpha(accent, 0.50) },
        { ImGuiCol_Separator,               pal.lineStrong },
        { ImGuiCol_SeparatorHovered,        withAlpha(accent, 0.60) },
        { ImGuiCol_SeparatorActive,         accent },
        { ImGuiCol_ResizeGrip,              withAlpha(accent, 0.22) },
        { ImGuiCol_ResizeGripHovered,       withAlpha(accent, 0.48) },
        { ImGuiCol_ResizeGripActive,        withAlpha(strong, 0.70) },
        { ImGuiCol_InputTextCursor,         strong },
        { ImGuiCol_TabHovered,              withAlpha(accent, 0.48) },
        { ImGuiCol_Tab,                     withAlpha(mix(bg, accent, 0.14), 0.86) },
        { ImGuiCol_TabSelected,             mix(bg, accent, 0.38) },
        { ImGuiCol_TabSelectedOverline,     strong },
        { ImGuiCol_TabDimmed,               withAlpha(mix(bg, accent, 0.06), 0.80) },
        { ImGuiCol_TabDimmedSelected,       mix(bg, accent, 0.22) },
        { ImGuiCol_TabDimmedSelectedOverline, withAlpha(strong, 0.50) },
        { ImGuiCol_TableHeaderBg,           mix(bgDeep, accent, 0.16) },
        { ImGuiCol_TableBorderStrong,       pal.lineStrong },
        { ImGuiCol_TableBorderLight,        pal.line },
        { ImGuiCol_TableRowBg,              TRANSPARENT },
        { ImGuiCol_TableRowBgAlt,           withAlpha(text, 0.04) },
        { ImGuiCol_TextLink,                strong },
        { ImGuiCol_TextSelectedBg,          withAlpha(accent, 0.35) },
        { ImGuiCol_NavCursor,               strong },
        { ImGuiCol_NavWindowingHighlight,   strong },
        { ImGuiCol_PlotLines,               accent },
        { ImGuiCol_PlotLinesHovered,        strong },
        { ImGuiCol_PlotHistogram,           wood },
        { ImGuiCol_PlotHistogramHovered,    strong },
        { ImGuiCol_DragDropTarget,          wood },
    };

    -- The launcher's rounded-corner vocabulary, scaled down for game density.
    styleVars = {
        { ImGuiStyleVar_WindowRounding,     8.0 },
        { ImGuiStyleVar_ChildRounding,      6.0 },
        { ImGuiStyleVar_PopupRounding,      6.0 },
        { ImGuiStyleVar_FrameRounding,      4.0 },
        { ImGuiStyleVar_ScrollbarRounding,  8.0 },
        { ImGuiStyleVar_GrabRounding,       4.0 },
        { ImGuiStyleVar_TabRounding,        5.0 },
        { ImGuiStyleVar_WindowBorderSize,   1.0 },
    };

    setInPlace(M.colors.ok,    pal.ok);
    setInPlace(M.colors.err,   pal.err);
    setInPlace(M.colors.warn,  pal.warn);
    setInPlace(M.colors.info,  pal.info);
    setInPlace(M.colors.hint,  strong);
    setInPlace(M.colors.badge, pal.info);
    setInPlace(M.colors.inert, pal.textFaint);
    setInPlace(M.colors.pin,   wood);
    setInPlace(M.colors.text,  text);
    setInPlace(M.colors.dim,   pal.textDim);
end

-- Parse one ini body into a full palette (defaults fill the gaps), rebuild
-- the slot list from it. Returns true when the content was usable at all.
local function applyContent(raw)
    local pal = {};

    for key in pairs(DEFAULTS) do
        pal[key] = parseHex(DEFAULTS[key]);
    end

    if (raw ~= nil) then
        for key, value in raw:gmatch('([%w]+)%s*=%s*(#%x+)') do
            if (DEFAULTS[key] ~= nil) then
                local parsed = parseHex(value);

                if (parsed ~= nil) then
                    pal[key] = parsed;
                end
            end
        end

        local name = raw:match('theme%s*=%s*([^\r\n]+)');

        if (name ~= nil and #name > 0 and #name <= 64) then
            M.name = name:gsub('%s+$', '');
        end
    else
        M.name = 'Driftwood';
    end

    rebuild(pal);
end

-- The launcher-owned theme file inside the Ashita install. Resolved lazily:
-- AshitaCore exists whenever an addon is running, but there is no need to
-- touch it at require time.
local themePath = nil;

local function themeFile()
    if (themePath == nil) then
        local install = AshitaCore:GetInstallPath();

        themePath = string.format('%s\\config\\driftwood-theme.ini', install:gsub('[\\/]+$', ''));
    end

    return themePath;
end

local lastRaw   = nil;      -- file content last applied, nil = defaults
local lastCheck = 0;        -- os.time() of the last disk look

local function readRaw()
    local file = io.open(themeFile(), 'rb');

    if (file == nil) then
        return nil;
    end

    local raw = file:read('*a');
    file:close();

    return raw;
end

--[[
* Re-read the ini at most every 2 seconds, and only rebuild when the bytes
* actually changed. A missing file is a real state, not an error: it selects
* the defaults, and keeps being checked -- so a launcher installed (or a theme
* first synced) mid-session takes effect without a reload. Everything is
* pcall'd because a theme must never be able to take an addon down; the worst
* a broken file can do is leave the previous coat of paint on.
--]]
local function maybeReload()
    local now = os.time();

    if (now - lastCheck < 2) then
        return;
    end

    lastCheck = now;

    local ok, raw = pcall(readRaw);

    if (not ok or raw == lastRaw) then
        return;
    end

    lastRaw = raw;

    if (not pcall(applyContent, raw)) then
        pcall(applyContent, nil);
    end
end

-- First build happens at require time so push() always has a full list, file
-- or no file.
pcall(applyContent, nil);
maybeReload();

--[[
* Push the theme; returns the counts pop() needs. Call outside the render
* pcall, paired with pop() the way Begin is paired with End -- the token makes
* the balance explicit even if a future reload ever changed the list length
* between frames.
--]]
function M.push()
    maybeReload();

    for i = 1, #styleColors do
        imgui.PushStyleColor(styleColors[i][1], styleColors[i][2]);
    end

    for i = 1, #styleVars do
        imgui.PushStyleVar(styleVars[i][1], styleVars[i][2]);
    end

    return { #styleColors, #styleVars };
end

function M.pop(pushed)
    imgui.PopStyleVar(pushed[2]);
    imgui.PopStyleColor(pushed[1]);
end

return M;
