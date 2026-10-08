--[[
    Bleakfiber's Unit Toggles - UI.lua
    Presentation Layer: Dark Slate & Gold Theme, Widget Factory,
    Two-Column Canvas Layout, Quick Presets & Standalone Fallback Window
]]

local addonName, BUT = ...
BUT = BUT or {}
_G["BleakfibersUnitToggles"] = BUT

local ADDON_NAME = "BleakfibersUnitToggles"
local FULL_TITLE = "Bleakfiber's Unit Toggles"

local UI = {}
BUT.UI = UI
_G["BleakfibersUnitTogglesUI"] = UI

local Config = setmetatable({}, {
    __index = function(_, k)
        local c = BUT.Config or _G["BleakfibersUnitTogglesConfig"]
        if c then return c[k] end
    end,
})

-- Visual Theme: Dark Slate & Gold Bevel
local COLORS = {
    bgSlate      = { 0.08, 0.10, 0.13, 0.96 }, -- Dark iron / slate main backdrop
    contentBg    = { 0.05, 0.06, 0.08, 0.94 }, -- Inset dark container
    goldBorder   = { 0.82, 0.68, 0.28, 1.00 }, -- Bright beveled gold border
    goldMuted    = { 0.50, 0.42, 0.20, 0.85 }, -- Secondary / inset gold border
    goldText     = { 1.00, 0.82, 0.25 },       -- #FFD140
    whiteText    = { 0.90, 0.92, 0.94 },
    dimText      = { 0.55, 0.58, 0.63 },
    tabNormal    = { 0.12, 0.14, 0.17, 0.65 },
    tabActive    = { 0.24, 0.21, 0.13, 0.95 },
}

local BACKDROP_TEMPLATE = BackdropTemplateMixin and "BackdropTemplate" or nil

local WINDOW_BACKDROP = {
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
}

local INSET_BACKDROP = {
    bgFile = "Interface\\Buttons\\WHITE8X8",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 12,
    edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

-- Dictionary of all active checkbox frames indexed by CVar
UI.checkboxes = {}

--[[-----------------------------------------------------------------------------
    Local Fallback Widget Factory (When Master Hub is not loaded)
-------------------------------------------------------------------------------]]
function UI:CreateSectionHeader(parent, text, x, y)
    local header = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    header:SetText(text)
    header:SetTextColor(COLORS.goldText[1], COLORS.goldText[2], COLORS.goldText[3])
    return header
end

function UI:CreateDivider(parent, y, width)
    local div = parent:CreateTexture(nil, "ARTWORK")
    div:SetHeight(1)
    if width then
        div:SetWidth(width)
        div:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, y)
    else
        div:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, y)
        div:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -16, y)
    end
    div:SetColorTexture(COLORS.goldMuted[1], COLORS.goldMuted[2], COLORS.goldMuted[3], 0.4)
    return div
end

function UI:CreateCheckbox(parent, name, labelText, x, y, getFunc, setFunc, tooltip)
    local cb = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    cb.text = _G[name .. "Text"]
    if cb.text then
        cb.text:SetText(labelText)
        cb.text:SetFontObject("GameFontHighlight")
    end

    cb.getFunc = getFunc
    cb.setFunc = setFunc
    cb:SetChecked(getFunc and getFunc() or false)

    cb:SetScript("OnClick", function(self)
        if self.setFunc then
            self.setFunc(self:GetChecked())
        end
    end)

    if tooltip then
        cb:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:ClearLines()
            GameTooltip:AddLine(labelText, COLORS.goldText[1], COLORS.goldText[2], COLORS.goldText[3])
            GameTooltip:AddLine(tooltip, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        cb:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    return cb
end

function UI:CreateButton(parent, name, text, x, y, width, height, onClick)
    local btn = CreateFrame("Button", name, parent, BACKDROP_TEMPLATE)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    btn:SetSize(width or 100, height or 22)
    btn:SetBackdrop(INSET_BACKDROP)
    btn:SetBackdropColor(unpack(COLORS.tabNormal))
    btn:SetBackdropBorderColor(unpack(COLORS.goldMuted))

    local label = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("CENTER", btn, "CENTER", 0, 0)
    label:SetText(text)
    btn.label = label

    btn:SetScript("OnEnter", function(self)
        self:SetBackdropColor(0.20, 0.22, 0.28, 0.95)
        self:SetBackdropBorderColor(unpack(COLORS.goldBorder))
        label:SetTextColor(COLORS.goldText[1], COLORS.goldText[2], COLORS.goldText[3])
    end)

    btn:SetScript("OnLeave", function(self)
        self:SetBackdropColor(unpack(COLORS.tabNormal))
        self:SetBackdropBorderColor(unpack(COLORS.goldMuted))
        label:SetTextColor(COLORS.whiteText[1], COLORS.whiteText[2], COLORS.whiteText[3])
    end)

    if onClick then
        btn:SetScript("OnClick", onClick)
    end

    return btn
end

--[[-----------------------------------------------------------------------------
    Live Refresh & Checkbox Synchronization
-------------------------------------------------------------------------------]]
function UI:Refresh(customStatusMsg)
    local activeCount = 0
    local totalCount = (Config.CVAR_DEFINITIONS and #Config.CVAR_DEFINITIONS) or 19

    if Config.CVAR_DEFINITIONS then
        for _, def in ipairs(Config.CVAR_DEFINITIONS) do
            local cb = (self.checkboxes and self.checkboxes[def.cvar]) or _G["BUT_CB_" .. def.cvar]
            local isChecked = Config:GetCVar(def.cvar) and true or false
            if cb and cb.SetChecked then
                cb:SetChecked(isChecked)
            end
            if isChecked then
                activeCount = activeCount + 1
            end
        end
    end

    -- Update active status readout
    if self.statusText then
        if customStatusMsg then
            self.statusText:SetText(customStatusMsg)
        else
            local statusColor = "|cffffd100"
            if activeCount == totalCount then
                statusColor = "|cff22ff22"
            elseif activeCount == 0 then
                statusColor = "|cffff2222"
            end
            self.statusText:SetText(string.format("%sActive: %d / %d toggles enabled|r", statusColor, activeCount, totalCount))
        end
    end

    -- Update profile title if in standalone mode
    if self.profileLabel then
        self.profileLabel:SetText("Profile: |cffffd100" .. Config:GetActiveProfile() .. "|r")
    end
end

--[[-----------------------------------------------------------------------------
    Options Panel Layout (Context-Aware)
-------------------------------------------------------------------------------]]
function UI:BuildOptions(parentContainer, isMasterHub)
    isMasterHub = isMasterHub or (parentContainer and parentContainer.isMasterHub) or false

    -- Use Master Hub widget toolkit if available, else local factory
    local Kit = (BleakfibersAddonConfigForever and BleakfibersAddonConfigForever.UI) or self

    -- Reset checkbox registry
    self.checkboxes = {}

    local startY = -12

    -- Standalone header & description
    if not isMasterHub then
        local header = parentContainer:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        header:SetPoint("TOPLEFT", parentContainer, "TOPLEFT", 16, -14)
        header:SetText(FULL_TITLE)
        header:SetTextColor(COLORS.goldText[1], COLORS.goldText[2], COLORS.goldText[3])

        local profileLabel = parentContainer:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        profileLabel:SetPoint("TOPRIGHT", parentContainer, "TOPRIGHT", -16, -18)
        profileLabel:SetText("Profile: |cffffd100" .. Config:GetActiveProfile() .. "|r")
        self.profileLabel = profileLabel

        startY = -46
    end

    --[[
        Quick Action Preset Buttons:
        [Enable All] [Disable All] [PvP Preset] [Blizzard Def] [Sync Live]
    ]]
    local btnWidth = 78
    local btnHeight = 22
    local btnSpacing = 6
    local curX = 16

    Kit:CreateButton(parentContainer, "BUT_BtnAllOn", "Enable All", curX, startY, btnWidth, btnHeight, function()
        Config:SetAll(true)
        UI:Refresh("|cff22ff22Preset: All Enabled (19/19)|r")
    end)
    curX = curX + btnWidth + btnSpacing

    Kit:CreateButton(parentContainer, "BUT_BtnAllOff", "Disable All", curX, startY, btnWidth, btnHeight, function()
        Config:SetAll(false)
        UI:Refresh("|cffff2222Preset: All Disabled (0/19)|r")
    end)
    curX = curX + btnWidth + btnSpacing

    Kit:CreateButton(parentContainer, "BUT_BtnPvP", "PvP Preset", curX, startY, btnWidth, btnHeight, function()
        Config:ApplyPvPPreset()
        UI:Refresh("|cffffd100Preset: PvP Configuration Applied|r")
    end)
    curX = curX + btnWidth + btnSpacing

    Kit:CreateButton(parentContainer, "BUT_BtnDefaults", "Blizzard Def", curX, startY, 86, btnHeight, function()
        Config:ApplyBlizzardDefaults()
        UI:Refresh("|cff3399ffPreset: Blizzard Defaults Restored|r")
    end)
    curX = curX + 86 + btnSpacing

    Kit:CreateButton(parentContainer, "BUT_BtnSync", "Sync Live", curX, startY, 74, btnHeight, function()
        if BUT.Core and BUT.Core.SyncFromEngine then
            BUT.Core:SyncFromEngine()
        end
        UI:Refresh("|cffffd100Synchronized with live game engine|r")
    end)

    -- Status readout line below presets
    startY = startY - 26
    local statusText = parentContainer:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusText:SetPoint("TOPLEFT", parentContainer, "TOPLEFT", 16, startY)
    statusText:SetText("Active: 0 / 19 toggles enabled")
    self.statusText = statusText

    -- Divider below presets & status
    startY = startY - 14
    Kit:CreateDivider(parentContainer, startY)
    startY = startY - 14

    --[[
        2-Column Canvas Grid Standards:
        Column 1 (Left):  x = 16,  width = 240px
        Column 2 (Right): x = 280, width = 240px
    ]]
    local col1X = 16
    local col2X = 280
    local stepY = 26

    -------------------------------------------------------------------------
    -- COLUMN 1: Friendly Units & NPCs
    -------------------------------------------------------------------------
    local y1 = startY
    Kit:CreateSectionHeader(parentContainer, "Friendly Units", col1X, y1)
    y1 = y1 - 22

    local friendlyCVars = {
        "UnitNameFriendlyPlayerName",
        "UnitNameFriendlyPetName",
        "UnitNameFriendlyMinionName",
        "UnitNameFriendlyGuardianName",
        "UnitNameFriendlyTotemName",
        "UnitNameFriendlySpecialNPCName",
    }

    for _, cvar in ipairs(friendlyCVars) do
        local def = Config.CVAR_LOOKUP[cvar]
        if def then
            local cb = Kit:CreateCheckbox(
                parentContainer,
                "BUT_CB_" .. cvar,
                def.label,
                col1X,
                y1,
                function() return Config:GetCVar(cvar) end,
                function(val)
                    Config:SetCVar(cvar, val and true or false)
                    UI:Refresh()
                end,
                def.tooltip
            )
            self.checkboxes[cvar] = cb
            y1 = y1 - stepY
        end
    end

    y1 = y1 - 10
    Kit:CreateSectionHeader(parentContainer, "NPCs & Creatures", col1X, y1)
    y1 = y1 - 22

    local npcCVars = {
        "UnitNameNPC",
        "UnitNameInteractiveNPC",
        "UnitNameNonCombatCreatureName",
    }

    for _, cvar in ipairs(npcCVars) do
        local def = Config.CVAR_LOOKUP[cvar]
        if def then
            local cb = Kit:CreateCheckbox(
                parentContainer,
                "BUT_CB_" .. cvar,
                def.label,
                col1X,
                y1,
                function() return Config:GetCVar(cvar) end,
                function(val)
                    Config:SetCVar(cvar, val and true or false)
                    UI:Refresh()
                end,
                def.tooltip
            )
            self.checkboxes[cvar] = cb
            y1 = y1 - stepY
        end
    end

    -------------------------------------------------------------------------
    -- COLUMN 2: Enemy Units & Player Details
    -------------------------------------------------------------------------
    local y2 = startY
    Kit:CreateSectionHeader(parentContainer, "Enemy Units", col2X, y2)
    y2 = y2 - 22

    local enemyCVars = {
        "UnitNameEnemyPlayerName",
        "UnitNameEnemyPetName",
        "UnitNameEnemyMinionName",
        "UnitNameEnemyTotemName",
        "UnitNameHostleNPC",
    }

    for _, cvar in ipairs(enemyCVars) do
        local def = Config.CVAR_LOOKUP[cvar]
        if def then
            local cb = Kit:CreateCheckbox(
                parentContainer,
                "BUT_CB_" .. cvar,
                def.label,
                col2X,
                y2,
                function() return Config:GetCVar(cvar) end,
                function(val)
                    Config:SetCVar(cvar, val and true or false)
                    UI:Refresh()
                end,
                def.tooltip
            )
            self.checkboxes[cvar] = cb
            y2 = y2 - stepY
        end
    end

    y2 = y2 - 10
    Kit:CreateSectionHeader(parentContainer, "Player & Names Display", col2X, y2)
    y2 = y2 - 22

    local playerCVars = {
        "UnitNameOwn",
        "UnitNamePlayerGuild",
        "UnitNameGuildTitle",
        "UnitNameFocused",
        "UnitNameForceHideMinus",
    }

    for _, cvar in ipairs(playerCVars) do
        local def = Config.CVAR_LOOKUP[cvar]
        if def then
            local cb = Kit:CreateCheckbox(
                parentContainer,
                "BUT_CB_" .. cvar,
                def.label,
                col2X,
                y2,
                function() return Config:GetCVar(cvar) end,
                function(val)
                    Config:SetCVar(cvar, val and true or false)
                    UI:Refresh()
                end,
                def.tooltip
            )
            self.checkboxes[cvar] = cb
            y2 = y2 - stepY
        end
    end

    -- Initial sync of checkboxes with active profile
    self:Refresh()
end

--[[-----------------------------------------------------------------------------
    Standalone Window Fallback (When Master Hub is not loaded)
-------------------------------------------------------------------------------]]
function UI:CreateStandaloneWindow()
    if self.standaloneFrame then return self.standaloneFrame end

    local f = CreateFrame("Frame", "BleakfibersUnitTogglesStandaloneWindow", UIParent, BACKDROP_TEMPLATE)
    f:SetSize(620, 500)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetFrameStrata("HIGH")
    f:SetToplevel(true)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetMovable(true)

    tinsert(UISpecialFrames, "BleakfibersUnitTogglesStandaloneWindow")

    f:SetBackdrop(WINDOW_BACKDROP)
    f:SetBackdropColor(unpack(COLORS.bgSlate))
    f:SetBackdropBorderColor(unpack(COLORS.goldBorder))

    local titleBar = CreateFrame("Frame", nil, f)
    titleBar:SetHeight(32)
    titleBar:SetPoint("TOPLEFT", f, "TOPLEFT", 6, -6)
    titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -32, -6)
    titleBar:EnableMouse(true)
    titleBar:RegisterForDrag("LeftButton")
    titleBar:SetScript("OnDragStart", f.StartMoving)
    titleBar:SetScript("OnDragStop", f.StopMovingOrSizing)

    local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("LEFT", titleBar, "LEFT", 10, 0)
    title:SetText("|cffffd100" .. FULL_TITLE .. "|r")

    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetSize(28, 28)
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local content = CreateFrame("Frame", nil, f, BACKDROP_TEMPLATE)
    content:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -38)
    content:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -10, 10)
    content:SetBackdrop(INSET_BACKDROP)
    content:SetBackdropColor(unpack(COLORS.contentBg))
    content:SetBackdropBorderColor(unpack(COLORS.goldMuted))

    self:BuildOptions(content, false)

    f:Hide()
    self.standaloneFrame = f
    return f
end

function UI:ToggleStandaloneWindow()
    local win = self:CreateStandaloneWindow()
    if win:IsShown() then
        win:Hide()
    else
        self:Refresh()
        win:Show()
    end
end
