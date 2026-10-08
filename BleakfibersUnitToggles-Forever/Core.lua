--[[
    Bleakfiber's Unit Toggles - Core.lua
    Core Framework: Addon Lifecycle, Engine CVar Synchronization & Event Handling
]]

local addonName, BUT = ...
BUT = BUT or {}
_G["BleakfibersUnitToggles"] = BUT

local Core = CreateFrame("Frame", "BleakfibersUnitTogglesCore")
BUT.Core = Core
_G["BleakfibersUnitTogglesCore"] = Core

local Config = setmetatable({}, {
    __index = function(_, k)
        local c = BUT.Config or _G["BleakfibersUnitTogglesConfig"]
        if c then return c[k] end
    end,
})

--[[-----------------------------------------------------------------------------
    CVar Engine Synchronization Methods
-------------------------------------------------------------------------------]]
function Core:ApplyAllCVars()
    if not Config.CVAR_DEFINITIONS then return end
    for _, def in ipairs(Config.CVAR_DEFINITIONS) do
        local val = Config:GetCVar(def.cvar)
        SetCVar(def.cvar, val and "1" or "0")
    end
end

function Core:ApplyCVar(cvar, value)
    if value == nil then
        value = Config:GetCVar(cvar)
    end
    SetCVar(cvar, value and "1" or "0")
end

function Core:SyncFromEngine()
    if not Config.CVAR_DEFINITIONS then return end
    Config:InitDB()
    local cur = BleakfibersUnitTogglesDB.profiles[BleakfibersUnitTogglesDB.activeProfile]
    if not cur or not cur.cvars then return end

    for _, def in ipairs(Config.CVAR_DEFINITIONS) do
        local engineVal = GetCVarBool(def.cvar)
        if engineVal ~= nil then
            cur.cvars[def.cvar] = engineVal
        end
    end

    if BUT.UI and BUT.UI.Refresh then
        BUT.UI:Refresh()
    end
end

--[[-----------------------------------------------------------------------------
    Event Handling & Lifecycle
-------------------------------------------------------------------------------]]
Core:RegisterEvent("ADDON_LOADED")
Core:RegisterEvent("PLAYER_LOGIN")
Core:RegisterEvent("PLAYER_ENTERING_WORLD")
Core:RegisterEvent("CVAR_UPDATE")

Core:SetScript("OnEvent", function(self, event, arg1, arg2)
    if event == "ADDON_LOADED" then
        if arg1 == addonName then
            Config:InitDB()
        end
    elseif event == "PLAYER_LOGIN" then
        Config:InitDB()
        self:ApplyAllCVars()
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:ApplyAllCVars()
    elseif event == "CVAR_UPDATE" then
        local cvarName = arg1
        if cvarName and Config.CVAR_LOOKUP and Config.CVAR_LOOKUP[cvarName] then
            -- Sync live value to active profile
            local def = Config.CVAR_LOOKUP[cvarName]
            local cur = BleakfibersUnitTogglesDB and BleakfibersUnitTogglesDB.profiles and BleakfibersUnitTogglesDB.profiles[Config:GetActiveProfile()]
            if cur and cur.cvars then
                local engineVal = GetCVarBool(def.cvar)
                if engineVal ~= nil and cur.cvars[def.cvar] ~= engineVal then
                    cur.cvars[def.cvar] = engineVal
                    if BUT.UI and BUT.UI.Refresh then
                        BUT.UI:Refresh()
                    end
                end
            end
        end
    end
end)

