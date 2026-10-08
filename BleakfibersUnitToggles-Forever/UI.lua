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

local function SetupAutoScroll(scrollFrame, scrollChild)
    if not (scrollFrame and scrollChild) then return end
    local scrollBar = _G[scrollFrame:GetName() and (scrollFrame:GetName() .. "ScrollBar")]

    local function UpdateScrollState()
        local frameHeight = scrollFrame:GetHeight()
        local childHeight = scrollChild:GetHeight()
        if not frameHeight or frameHeight <= 0 then return end
        if childHeight <= frameHeight + 2 then
            if scrollBar and scrollBar:IsShown() then
                scrollBar:Hide()
            end
            scrollFrame:EnableMouseWheel(false)
            scrollFrame:SetVerticalScroll(0)
        else
            if scrollBar and not scrollBar:IsShown() then
                scrollBar:Show()
            end
            scrollFrame:EnableMouseWheel(true)
        end
    end

    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local frameHeight = self:GetHeight()
        local childHeight = scrollChild:GetHeight()
        if not frameHeight or childHeight <= frameHeight + 2 then return end
        local cur = self:GetVerticalScroll()
        local maxScroll = math.max(0, childHeight - frameHeight)
        local step = 32
        local newScroll = cur - (delta * step)
        if newScroll < 0 then newScroll = 0 end
        if newScroll > maxScroll then newScroll = maxScroll end
        self:SetVerticalScroll(newScroll)
    end)

    scrollFrame:HookScript("OnSizeChanged", UpdateScrollState)
    scrollChild:HookScript("OnSizeChanged", UpdateScrollState)
    scrollFrame:HookScript("OnShow", UpdateScrollState)
    UpdateScrollState()
    return UpdateScrollState
end

function UI:CreateCheckbox(parent, name, labelText, x, y, getFunc, setFunc, tooltip)
    local cb = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    cb.text = _G[name .. "Text"]
    if cb.text then
        cb.text:SetText(labelText)
        cb.text:SetFontObject("GameFontHighlight")
        cb.text:SetWordWrap(true)
        cb.text:SetJustifyH("LEFT")
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
    local totalCount = (Config.CVAR_DEFINITIONS and #Config.CVAR_DEFINITIONS) or 20

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
    Options Panel Layout (Responsive Canvas with Auto-Hiding Scrollbar)
-------------------------------------------------------------------------------]]
function UI:BuildOptions(parentContainer, isMasterHub)
    isMasterHub = isMasterHub or (parentContainer and parentContainer.isMasterHub) or false

    local Kit = (BleakfibersAddonConfigForever and BleakfibersAddonConfigForever.UI) or self

    self.checkboxes = {}

    -- Create Responsive ScrollFrame inside parentContainer
    local scrollFrame = CreateFrame("ScrollFrame", "BleakUnitTogglesScrollFrame", parentContainer, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parentContainer, "TOPLEFT", 0, 0)
    scrollFrame:SetPoint("BOTTOMRIGHT", parentContainer, "BOTTOMRIGHT", -22, 0)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(math.max(parentContainer:GetWidth() or 500, 100), 500)
    scrollFrame:SetScrollChild(scrollChild)

    local updateScroll = SetupAutoScroll(scrollFrame, scrollChild)

    -- Standalone header & description (if not master hub)
    local header, profileLabel
    if not isMasterHub then
        header = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, -14)
        header:SetText(FULL_TITLE)
        header:SetTextColor(COLORS.goldText[1], COLORS.goldText[2], COLORS.goldText[3])

        profileLabel = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        profileLabel:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -16, -18)
        profileLabel:SetText("Profile: |cffffd100" .. Config:GetActiveProfile() .. "|r")
        self.profileLabel = profileLabel
    end

    -- Preset Buttons
    local btnAllOn = Kit:CreateButton(scrollChild, "BUT_BtnAllOn", "Enable All", 16, 0, 78, 22, function()
        Config:SetAll(true)
        UI:Refresh("|cff22ff22Preset: All Enabled (20/20)|r")
    end)

    local btnAllOff = Kit:CreateButton(scrollChild, "BUT_BtnAllOff", "Disable All", 16, 0, 78, 22, function()
        Config:SetAll(false)
        UI:Refresh("|cffff2222Preset: All Disabled (0/20)|r")
    end)

    local btnPvP = Kit:CreateButton(scrollChild, "BUT_BtnPvP", "PvP Preset", 16, 0, 78, 22, function()
        Config:ApplyPvPPreset()
        UI:Refresh("|cffffd100Preset: PvP Configuration Applied (8/20)|r")
    end)

    local btnDefaults = Kit:CreateButton(scrollChild, "BUT_BtnDefaults", "Blizzard Def", 16, 0, 86, 22, function()
        Config:ApplyBlizzardDefaults()
        UI:Refresh("|cff3399ffPreset: Blizzard Defaults Restored (16/20)|r")
    end)

    local btnSync = Kit:CreateButton(scrollChild, "BUT_BtnSync", "Sync Live", 16, 0, 74, 22, function()
        if BUT.Core and BUT.Core.SyncFromEngine then
            BUT.Core:SyncFromEngine()
        end
        UI:Refresh("|cffffd100Synchronized with live game engine|r")
    end)

    -- Status readout line below presets
    local statusText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    statusText:SetText("Active: 0 / 20 toggles enabled")
    self.statusText = statusText

    -- Divider below presets & status
    local divider = Kit:CreateDivider(scrollChild, -60)

    -- Section Headers
    local hFriendly = Kit:CreateSectionHeader(scrollChild, "Friendly Units", 16, 0)
    local hNPC = Kit:CreateSectionHeader(scrollChild, "NPCs & World", 16, 0)
    local hEnemy = Kit:CreateSectionHeader(scrollChild, "Enemy Units", 16, 0)
    local hTitles = Kit:CreateSectionHeader(scrollChild, "Guild & Titles", 16, 0)

    local friendlyCVars = {
        "UnitNameFriendlyPlayerName",
        "UnitNameFriendlyPetName",
        "UnitNameFriendlyMinionName",
        "UnitNameFriendlyGuardianName",
        "UnitNameFriendlyTotemName",
        "UnitNameFriendlySpecialNPCName",
    }
    local npcCVars = {
        "UnitNameOwn",
        "UnitNameNPC",
        "UnitNameInteractiveNPC",
        "UnitNameNonCombatCreatureName",
    }
    local enemyCVars = {
        "UnitNameEnemyPlayerName",
        "UnitNameEnemyPetName",
        "UnitNameEnemyMinionName",
        "UnitNameEnemyGuardianName",
        "UnitNameEnemyTotemName",
        "UnitNameHostleNPC",
    }
    local titleCVars = {
        "UnitNamePlayerGuild",
        "UnitNameGuildTitle",
        "UnitNamePlayerPVPTitle",
        "UnitNameForceHideMinus",
    }

    local function CreateGroupCheckboxes(cvars)
        local list = {}
        for _, cvar in ipairs(cvars) do
            local def = Config.CVAR_LOOKUP[cvar]
            if def then
                local cb = Kit:CreateCheckbox(
                    scrollChild,
                    "BUT_CB_" .. cvar,
                    def.label,
                    16,
                    0,
                    function() return Config:GetCVar(cvar) end,
                    function(val)
                        Config:SetCVar(cvar, val and true or false)
                        UI:Refresh()
                    end,
                    def.tooltip
                )
                self.checkboxes[cvar] = cb
                table.insert(list, cb)
            end
        end
        return list
    end

    local friendlyCBs = CreateGroupCheckboxes(friendlyCVars)
    local npcCBs = CreateGroupCheckboxes(npcCVars)
    local enemyCBs = CreateGroupCheckboxes(enemyCVars)
    local titleCBs = CreateGroupCheckboxes(titleCVars)

    -- Dynamic Layout Engine (Evaluates width, reorients columns, wraps presets, sets word wrap)
    local function LayoutCanvas(w)
        if not w or w < 100 then
            w = parentContainer:GetWidth() or 500
        end

        local startY = isMasterHub and -12 or -46
        local btnSpacing = 6

        -- Preset Buttons Layout (Wrap into 2 rows if w < 440)
        local nextY
        if w >= 440 then
            -- Single Row
            btnAllOn:ClearAllPoints()
            btnAllOn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, startY)
            btnAllOff:ClearAllPoints()
            btnAllOff:SetPoint("LEFT", btnAllOn, "RIGHT", btnSpacing, 0)
            btnPvP:ClearAllPoints()
            btnPvP:SetPoint("LEFT", btnAllOff, "RIGHT", btnSpacing, 0)
            btnDefaults:ClearAllPoints()
            btnDefaults:SetPoint("LEFT", btnPvP, "RIGHT", btnSpacing, 0)
            btnSync:ClearAllPoints()
            btnSync:SetPoint("LEFT", btnDefaults, "RIGHT", btnSpacing, 0)
            nextY = startY - 28
        else
            -- 2 Rows (Line break to prevent overlap)
            btnAllOn:ClearAllPoints()
            btnAllOn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, startY)
            btnAllOff:ClearAllPoints()
            btnAllOff:SetPoint("LEFT", btnAllOn, "RIGHT", btnSpacing, 0)
            btnPvP:ClearAllPoints()
            btnPvP:SetPoint("LEFT", btnAllOff, "RIGHT", btnSpacing, 0)

            local row2Y = startY - 26
            btnDefaults:ClearAllPoints()
            btnDefaults:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, row2Y)
            btnSync:ClearAllPoints()
            btnSync:SetPoint("LEFT", btnDefaults, "RIGHT", btnSpacing, 0)
            nextY = row2Y - 28
        end

        -- Status readout & Divider
        statusText:ClearAllPoints()
        statusText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, nextY)
        nextY = nextY - 14

        divider:ClearAllPoints()
        divider:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, nextY)
        divider:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -16, nextY)
        nextY = nextY - 14

        local stepY = 26
        local totalHeight = 0

        if w >= 470 then
            -- 2-Column Responsive Layout
            local colWidth = math.floor((w - 48) / 2)
            local col1X = 16
            local col2X = col1X + colWidth + 16

            -- Column 1
            local y1 = nextY
            hFriendly:ClearAllPoints()
            hFriendly:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y1)
            y1 = y1 - 22
            for _, cb in ipairs(friendlyCBs) do
                cb:ClearAllPoints()
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y1)
                if cb.text then cb.text:SetWidth(colWidth - 32) end
                y1 = y1 - stepY
            end

            y1 = y1 - 10
            hNPC:ClearAllPoints()
            hNPC:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y1)
            y1 = y1 - 22
            for _, cb in ipairs(npcCBs) do
                cb:ClearAllPoints()
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y1)
                if cb.text then cb.text:SetWidth(colWidth - 32) end
                y1 = y1 - stepY
            end

            -- Column 2
            local y2 = nextY
            hEnemy:ClearAllPoints()
            hEnemy:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col2X, y2)
            y2 = y2 - 22
            for _, cb in ipairs(enemyCBs) do
                cb:ClearAllPoints()
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col2X, y2)
                if cb.text then cb.text:SetWidth(colWidth - 32) end
                y2 = y2 - stepY
            end

            y2 = y2 - 10
            hTitles:ClearAllPoints()
            hTitles:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col2X, y2)
            y2 = y2 - 22
            for _, cb in ipairs(titleCBs) do
                cb:ClearAllPoints()
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col2X, y2)
                if cb.text then cb.text:SetWidth(colWidth - 32) end
                y2 = y2 - stepY
            end

            totalHeight = math.abs(math.min(y1, y2)) + 20
        else
            -- 1-Column Responsive Stack (Dynamic line breaks prevent ANY element overlap)
            local colWidth = w - 36
            local col1X = 16
            local y = nextY

            hFriendly:ClearAllPoints()
            hFriendly:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y)
            y = y - 22
            for _, cb in ipairs(friendlyCBs) do
                cb:ClearAllPoints()
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y)
                if cb.text then cb.text:SetWidth(colWidth - 32) end
                y = y - stepY
            end

            y = y - 10
            hNPC:ClearAllPoints()
            hNPC:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y)
            y = y - 22
            for _, cb in ipairs(npcCBs) do
                cb:ClearAllPoints()
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y)
                if cb.text then cb.text:SetWidth(colWidth - 32) end
                y = y - stepY
            end

            y = y - 10
            hEnemy:ClearAllPoints()
            hEnemy:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y)
            y = y - 22
            for _, cb in ipairs(enemyCBs) do
                cb:ClearAllPoints()
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y)
                if cb.text then cb.text:SetWidth(colWidth - 32) end
                y = y - stepY
            end

            y = y - 10
            hTitles:ClearAllPoints()
            hTitles:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y)
            y = y - 22
            for _, cb in ipairs(titleCBs) do
                cb:ClearAllPoints()
                cb:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", col1X, y)
                if cb.text then cb.text:SetWidth(colWidth - 32) end
                y = y - stepY
            end

            totalHeight = math.abs(y) + 20
        end

        scrollChild:SetSize(w - 24, totalHeight)
        if updateScroll then updateScroll() end
    end

    scrollFrame:HookScript("OnSizeChanged", function(self, w)
        if w and w > 60 then
            LayoutCanvas(w)
        end
    end)
    parentContainer:HookScript("OnSizeChanged", function(self, w)
        if w and w > 60 then
            LayoutCanvas(w)
        end
    end)

    LayoutCanvas(parentContainer:GetWidth())
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
    titleBar:SetScript("OnDragStart", function()
        f:StartMoving()
    end)
    titleBar:SetScript("OnDragStop", function()
        f:StopMovingOrSizing()
    end)

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
