--[[
    Bleakfiber's Unit Toggles - Config.lua
    Data Layer: Database Defaults, Profiles, CVar Accessors, Slash Commands & Hub Registration
]]

local addonName, BUT = ...
BUT = BUT or {}
_G["BleakfibersUnitToggles"] = BUT

local ADDON_NAME = "BleakfibersUnitToggles"
local FULL_TITLE = "Bleakfiber's Unit Toggles"
local DISPLAY_TITLE = "Unit Toggles"

local Config = {}
BUT.Config = Config
_G["BleakfibersUnitTogglesConfig"] = Config

--[[-----------------------------------------------------------------------------
    CVar Catalog Definitions (20 Managed CVars)
-------------------------------------------------------------------------------]]
Config.CVAR_DEFINITIONS = {
    -- Category 1: Friendly Units
    {
        cvar = "UnitNameFriendlyPlayerName",
        label = "Friendly Players",
        category = "friendly",
        default = true,
        tooltip = "Show overhead names for friendly player characters.\n\nCVar: UnitNameFriendlyPlayerName (0|1)"
    },
    {
        cvar = "UnitNameFriendlyPetName",
        label = "Friendly Pets",
        category = "friendly",
        default = true,
        tooltip = "Show overhead names for friendly player pets.\n\nCVar: UnitNameFriendlyPetName (0|1)"
    },
    {
        cvar = "UnitNameFriendlyMinionName",
        label = "Friendly Minions",
        category = "friendly",
        default = true,
        tooltip = "Show overhead names for friendly player minions and summoned units.\n\nCVar: UnitNameFriendlyMinionName (0|1)"
    },
    {
        cvar = "UnitNameFriendlyGuardianName",
        label = "Friendly Guardians",
        category = "friendly",
        default = true,
        tooltip = "Show overhead names for friendly guardians.\n\nCVar: UnitNameFriendlyGuardianName (0|1)"
    },
    {
        cvar = "UnitNameFriendlyTotemName",
        label = "Friendly Totems",
        category = "friendly",
        default = true,
        tooltip = "Show overhead names for friendly totems.\n\nCVar: UnitNameFriendlyTotemName (0|1)"
    },
    {
        cvar = "UnitNameFriendlySpecialNPCName",
        label = "Friendly Special NPCs",
        category = "friendly",
        default = true,
        tooltip = "Show overhead names for questgivers, vendors, flight masters, and special NPCs.\n\nCVar: UnitNameFriendlySpecialNPCName (0|1)"
    },

    -- Category 2: NPCs & World
    {
        cvar = "UnitNameOwn",
        label = "My Own Name",
        category = "npc",
        default = false,
        tooltip = "Show your own character name above your head.\n\nCVar: UnitNameOwn (0|1)"
    },
    {
        cvar = "UnitNameNPC",
        label = "All NPCs",
        category = "npc",
        default = false,
        tooltip = "Show overhead names for all NPCs regardless of reaction.\n\nCVar: UnitNameNPC (0|1)"
    },
    {
        cvar = "UnitNameInteractiveNPC",
        label = "Interactive NPCs",
        category = "npc",
        default = true,
        tooltip = "Show overhead names for interactive NPCs (bankers, flight masters, innkeepers).\n\nCVar: UnitNameInteractiveNPC (0|1)"
    },
    {
        cvar = "UnitNameNonCombatCreatureName",
        label = "Critters & Companions",
        category = "npc",
        default = false,
        tooltip = "Show overhead names for critters and non-combat pets.\n\nCVar: UnitNameNonCombatCreatureName (0|1)"
    },

    -- Category 3: Enemy Units
    {
        cvar = "UnitNameEnemyPlayerName",
        label = "Enemy Players",
        category = "enemy",
        default = true,
        tooltip = "Show overhead names for hostile/enemy player characters.\n\nCVar: UnitNameEnemyPlayerName (0|1)"
    },
    {
        cvar = "UnitNameEnemyPetName",
        label = "Enemy Pets",
        category = "enemy",
        default = true,
        tooltip = "Show overhead names for hostile/enemy player pets.\n\nCVar: UnitNameEnemyPetName (0|1)"
    },
    {
        cvar = "UnitNameEnemyMinionName",
        label = "Enemy Minions",
        category = "enemy",
        default = true,
        tooltip = "Show overhead names for hostile/enemy player minions and summoned units.\n\nCVar: UnitNameEnemyMinionName (0|1)"
    },
    {
        cvar = "UnitNameEnemyGuardianName",
        label = "Enemy Guardians",
        category = "enemy",
        default = true,
        tooltip = "Show overhead names for hostile/enemy guardians.\n\nCVar: UnitNameEnemyGuardianName (0|1)"
    },
    {
        cvar = "UnitNameEnemyTotemName",
        label = "Enemy Totems",
        category = "enemy",
        default = true,
        tooltip = "Show overhead names for hostile/enemy totems.\n\nCVar: UnitNameEnemyTotemName (0|1)"
    },
    {
        cvar = "UnitNameHostleNPC",
        label = "Hostile NPCs",
        category = "enemy",
        default = true,
        tooltip = "Show overhead names for hostile NPCs and monsters.\n\nCVar: UnitNameHostleNPC (0|1)"
    },

    -- Category 4: Guild & Titles
    {
        cvar = "UnitNamePlayerGuild",
        label = "Player Guild Names",
        category = "player",
        default = true,
        tooltip = "Show guild names under player character names.\n\nCVar: UnitNamePlayerGuild (0|1)"
    },
    {
        cvar = "UnitNameGuildTitle",
        label = "Player Guild Titles",
        category = "player",
        default = true,
        tooltip = "Show guild ranks/titles on player characters.\n\nCVar: UnitNameGuildTitle (0|1)"
    },
    {
        cvar = "UnitNamePlayerPVPTitle",
        label = "Player PvP Titles",
        category = "player",
        default = true,
        tooltip = "Show PvP titles and ranks on player characters.\n\nCVar: UnitNamePlayerPVPTitle (0|1)"
    },
    {
        cvar = "UnitNameForceHideMinus",
        label = "Force Hide Minor Units",
        category = "player",
        default = false,
        tooltip = "Force hide overhead names for trivial/minor ('minus') units.\n\nCVar: UnitNameForceHideMinus (0|1)"
    },
}

-- Fast lookup map
Config.CVAR_LOOKUP = {}
local DB_DEFAULTS = {
    cvars = {}
}

for _, def in ipairs(Config.CVAR_DEFINITIONS) do
    Config.CVAR_LOOKUP[def.cvar] = def
    Config.CVAR_LOOKUP[def.cvar:lower()] = def
    DB_DEFAULTS.cvars[def.cvar] = def.default
end

local function DeepCopy(src)
    if type(src) ~= "table" then return src end
    local copy = {}
    for k, v in pairs(src) do
        copy[k] = type(v) == "table" and DeepCopy(v) or v
    end
    return copy
end

--[[-----------------------------------------------------------------------------
    Database & Profile Management
-------------------------------------------------------------------------------]]
function Config:InitDB()
    if type(BleakfibersUnitTogglesDB) ~= "table" then
        BleakfibersUnitTogglesDB = {}
    end
    if not BleakfibersUnitTogglesDB.activeProfile or BleakfibersUnitTogglesDB.activeProfile == "" then
        BleakfibersUnitTogglesDB.activeProfile = "Default"
    end
    if type(BleakfibersUnitTogglesDB.profiles) ~= "table" then
        BleakfibersUnitTogglesDB.profiles = {}
    end

    local activeKey = BleakfibersUnitTogglesDB.activeProfile
    if not BleakfibersUnitTogglesDB.profiles[activeKey] then
        BleakfibersUnitTogglesDB.profiles[activeKey] = DeepCopy(DB_DEFAULTS)
        -- Pre-populate newly created default profile with current engine CVar values if present
        for _, def in ipairs(Config.CVAR_DEFINITIONS) do
            local currentEngineVal = GetCVarBool(def.cvar)
            if currentEngineVal ~= nil then
                BleakfibersUnitTogglesDB.profiles[activeKey].cvars[def.cvar] = currentEngineVal
            end
        end
    end

    -- Ensure all 19 cvars exist in active profile
    local prof = BleakfibersUnitTogglesDB.profiles[activeKey]
    if type(prof.cvars) ~= "table" then prof.cvars = {} end
    for _, def in ipairs(Config.CVAR_DEFINITIONS) do
        if prof.cvars[def.cvar] == nil then
            prof.cvars[def.cvar] = def.default
        end
    end
end

function Config:GetActiveProfile()
    return (BleakfibersUnitTogglesDB and BleakfibersUnitTogglesDB.activeProfile) or "Default"
end

function Config:GetProfiles()
    local list = {}
    if BleakfibersUnitTogglesDB and BleakfibersUnitTogglesDB.profiles then
        for name in pairs(BleakfibersUnitTogglesDB.profiles) do
            table.insert(list, name)
        end
    end
    if #list == 0 then table.insert(list, "Default") end
    table.sort(list)
    return list
end

function Config:SetActiveProfile(name)
    if not name or name == "" then return end
    self:InitDB()
    if not BleakfibersUnitTogglesDB.profiles[name] then
        local cur = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile]
        BleakfibersUnitTogglesDB.profiles[name] = DeepCopy(cur or DB_DEFAULTS)
    end
    BleakfibersUnitTogglesDB.activeProfile = name

    -- Apply all CVars for this profile to the WoW engine
    if BUT.Core and BUT.Core.ApplyAllCVars then
        BUT.Core:ApplyAllCVars()
    end

    -- Refresh UI if open
    if BUT.UI and BUT.UI.Refresh then
        BUT.UI:Refresh()
    end
end

function Config:CreateProfile(name, fromName)
    if not name or name == "" then return end
    self:InitDB()
    -- Never overwrite existing profile!
    if not BleakfibersUnitTogglesDB.profiles[name] then
        local source = fromName and BleakfibersUnitTogglesDB.profiles[fromName]
        if not source then
            source = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile] or DB_DEFAULTS
        end
        BleakfibersUnitTogglesDB.profiles[name] = DeepCopy(source)
    end
    self:SetActiveProfile(name)
end

function Config:SaveCurrentAs(name)
    if not name or name == "" then return end
    self:InitDB()
    local cur = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile]
    BleakfibersUnitTogglesDB.profiles[name] = DeepCopy(cur or DB_DEFAULTS)
    self:SetActiveProfile(name)
end

function Config:DeleteProfile(name)
    if not name or name == "Default" then return end
    self:InitDB()
    BleakfibersUnitTogglesDB.profiles[name] = nil
    if BleakfibersUnitTogglesDB.activeProfile == name then
        self:SetActiveProfile("Default")
    end
end

function Config:CopyProfile(fromName, toName)
    self:InitDB()
    if BleakfibersUnitTogglesDB.profiles[fromName] then
        BleakfibersUnitTogglesDB.profiles[toName] = DeepCopy(BleakfibersUnitTogglesDB.profiles[fromName])
        if BleakfibersUnitTogglesDB.activeProfile == toName then
            if BUT.Core and BUT.Core.ApplyAllCVars then BUT.Core:ApplyAllCVars() end
            if BUT.UI and BUT.UI.Refresh then BUT.UI:Refresh() end
        end
    end
end

function Config:ResetProfile(name)
    name = name or self:GetActiveProfile()
    self:InitDB()
    BleakfibersUnitTogglesDB.profiles[name] = DeepCopy(DB_DEFAULTS)
    if BleakfibersUnitTogglesDB.activeProfile == name then
        if BUT.Core and BUT.Core.ApplyAllCVars then BUT.Core:ApplyAllCVars() end
        if BUT.UI and BUT.UI.Refresh then BUT.UI:Refresh() end
    end
end

--[[-----------------------------------------------------------------------------
    CVar Get / Set Accessors
-------------------------------------------------------------------------------]]
function Config:GetCVar(cvar)
    self:InitDB()
    local cur = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile]
    if cur and cur.cvars and cur.cvars[cvar] ~= nil then
        return cur.cvars[cvar]
    end
    local engineVal = GetCVarBool(cvar)
    if engineVal ~= nil then return engineVal end
    local def = Config.CVAR_LOOKUP[cvar]
    return def and def.default or false
end

function Config:SetCVar(cvar, value)
    self:InitDB()
    local cur = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile]
    if cur and cur.cvars then
        cur.cvars[cvar] = (value and true or false)
    end

    -- Write directly to engine
    SetCVar(cvar, value and "1" or "0")

    -- Notify UI
    if BUT.UI and BUT.UI.Refresh then
        BUT.UI:Refresh()
    end
end

function Config:ToggleCVar(cvar)
    local cur = self:GetCVar(cvar)
    self:SetCVar(cvar, not cur)
    return not cur
end

function Config:SetAll(value)
    self:InitDB()
    local cur = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile]
    for _, def in ipairs(Config.CVAR_DEFINITIONS) do
        if cur and cur.cvars then
            cur.cvars[def.cvar] = value and true or false
        end
        SetCVar(def.cvar, value and "1" or "0")
    end
    if BUT.UI and BUT.UI.Refresh then BUT.UI:Refresh() end
end

function Config:ApplyPvPPreset()
    self:InitDB()
    local cur = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile]
    local pvpSettings = {
        UnitNameFriendlyPlayerName = true,
        UnitNameFriendlyPetName = false,
        UnitNameFriendlyMinionName = false,
        UnitNameFriendlyGuardianName = false,
        UnitNameFriendlyTotemName = false,
        UnitNameFriendlySpecialNPCName = true,
        UnitNameEnemyPlayerName = true,
        UnitNameEnemyPetName = true,
        UnitNameEnemyMinionName = true,
        UnitNameEnemyGuardianName = true,
        UnitNameEnemyTotemName = true,
        UnitNameHostleNPC = true,
        UnitNameNPC = false,
        UnitNameInteractiveNPC = false,
        UnitNameNonCombatCreatureName = false,
        UnitNameOwn = false,
        UnitNamePlayerGuild = false,
        UnitNameGuildTitle = false,
        UnitNamePlayerPVPTitle = true,
        UnitNameForceHideMinus = true,
    }
    for cvar, val in pairs(pvpSettings) do
        if cur and cur.cvars then cur.cvars[cvar] = val end
        SetCVar(cvar, val and "1" or "0")
    end
    if BUT.UI and BUT.UI.Refresh then BUT.UI:Refresh() end
end

function Config:ApplyBlizzardDefaults()
    self:InitDB()
    local cur = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile]
    for _, def in ipairs(Config.CVAR_DEFINITIONS) do
        if cur and cur.cvars then
            cur.cvars[def.cvar] = def.default
        end
        SetCVar(def.cvar, def.default and "1" or "0")
    end
    if BUT.UI and BUT.UI.Refresh then BUT.UI:Refresh() end
end

--[[-----------------------------------------------------------------------------
    Open / Toggle Configuration Window
-------------------------------------------------------------------------------]]
function Config:Open(forceStandalone)
    if not forceStandalone and BleakfibersAddonConfigForever and BleakfibersAddonConfigForever.SelectModule then
        BleakfibersAddonConfigForever:ShowUI()
        BleakfibersAddonConfigForever:SelectModule(ADDON_NAME)
    else
        local ui = BUT.UI or _G["BleakfibersUnitTogglesUI"]
        if ui and ui.ToggleStandaloneWindow then
            ui:ToggleStandaloneWindow()
        end
    end
end

--[[-----------------------------------------------------------------------------
    Slash Commands
-------------------------------------------------------------------------------]]
SLASH_BLEAKFIBERSUNITTOGGLES1 = "/but"
SLASH_BLEAKFIBERSUNITTOGGLES2 = "/unittoggles"
SLASH_BLEAKFIBERSUNITTOGGLES3 = "/bleakunit"

local function PrintChat(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff3399ff[Bleakfiber's Unit Toggles]|r " .. msg)
end

SlashCmdList["BLEAKFIBERSUNITTOGGLES"] = function(msg)
    msg = msg and string.trim and string.trim(msg:lower()) or (msg and msg:lower() or "")
    local cmd, arg = strsplit(" ", msg, 2)
    cmd = cmd or ""
    arg = arg and (string.trim and string.trim(arg) or arg) or ""

    if cmd == "" or cmd == "config" or cmd == "ui" then
        Config:Open()
    elseif cmd == "standalone" or cmd == "solo" then
        Config:Open(true)
    elseif cmd == "reset" then
        Config:ResetProfile()
        PrintChat("Reset profile '|cffffd100" .. Config:GetActiveProfile() .. "|r' to defaults.")
    elseif cmd == "pvp" then
        Config:ApplyPvPPreset()
        PrintChat("Applied PvP preset.")
    elseif cmd == "all" or cmd == "enableall" then
        if arg == "0" or arg == "off" then
            Config:SetAll(false)
            PrintChat("All 20 unit toggles set to |cffff2222OFF|r.")
        else
            Config:SetAll(true)
            PrintChat("All 20 unit toggles set to |cff22ff22ON|r.")
        end
    elseif cmd == "disableall" then
        Config:SetAll(false)
        PrintChat("All 20 unit toggles set to |cffff2222OFF|r.")
    elseif cmd == "list" or cmd == "status" then
        PrintChat("Current Unit CVar Status (Profile: |cffffd100" .. Config:GetActiveProfile() .. "|r):")
        for _, def in ipairs(Config.CVAR_DEFINITIONS) do
            local state = Config:GetCVar(def.cvar)
            local stateStr = state and "|cff22ff22[ON]|r" or "|cffff2222[OFF]|r"
            DEFAULT_CHAT_FRAME:AddMessage(string.format("  %s %s (|cff888888%s|r)", stateStr, def.label, def.cvar))
        end
    else
        -- Check if cmd matches a CVar name
        local def = Config.CVAR_LOOKUP[cmd]
        if def then
            local newVal
            if arg == "1" or arg == "on" or arg == "true" then
                newVal = true
            elseif arg == "0" or arg == "off" or arg == "false" then
                newVal = false
            else
                newVal = not Config:GetCVar(def.cvar)
            end
            Config:SetCVar(def.cvar, newVal)
            local stateStr = newVal and "|cff22ff22ON|r" or "|cffff2222OFF|r"
            PrintChat(string.format("%s (%s) is now %s.", def.label, def.cvar, stateStr))
        else
            PrintChat("Commands:")
            PrintChat("  /but - Open configuration hub")
            PrintChat("  /but standalone - Open standalone window")
            PrintChat("  /but list - Display status of all 19 CVars")
            PrintChat("  /but all [on|off] - Toggle all CVars")
            PrintChat("  /but pvp - Apply PvP optimized preset")
            PrintChat("  /but <cvar> [0|1] - Toggle specific CVar")
            PrintChat("  /but reset - Reset current profile to defaults")
        end
    end
end

--[[-----------------------------------------------------------------------------
    Hub Registration & Lifecycle Event
-------------------------------------------------------------------------------]]
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == addonName then
        Config:InitDB()
    end

    if arg1 == "BleakfibersAddonConfig-Forever" or arg1 == addonName then
        if BleakfibersAddonConfigForever and BleakfibersAddonConfigForever.RegisterModule then
            BleakfibersAddonConfigForever:RegisterModule(ADDON_NAME, {
                name = FULL_TITLE,
                sidebarName = DISPLAY_TITLE,
                author = "Bleakfiber",
                isBleakfiber = true,
                description = "Manage unit overhead name and title CVars.",
                db = BleakfibersUnitTogglesDB,

                -- Synchronized Profiles
                profiles = {
                    GetCurrent    = function() return Config:GetActiveProfile() end,
                    SetCurrent    = function(p) Config:SetActiveProfile(p) end,
                    SaveCurrentAs = function(p) Config:SaveCurrentAs(p) end,
                    List          = function() return Config:GetProfiles() end,
                    Create        = function(p, from) Config:CreateProfile(p, from) end,
                    Delete        = function(p) Config:DeleteProfile(p) end,
                    Copy          = function(f, t) Config:CopyProfile(f, t) end,
                    Reset         = function(p) Config:ResetProfile(p) end,
                },

                refresh = function()
                    local ui = BUT.UI or _G["BleakfibersUnitTogglesUI"]
                    if ui and ui.Refresh then ui:Refresh() end
                end,

                buildUI = function(container, isMasterHub)
                    local ui = BUT.UI or _G["BleakfibersUnitTogglesUI"]
                    if ui and ui.BuildOptions then
                        ui:BuildOptions(container, isMasterHub)
                    end
                end,
            })
        end
    end
end)

