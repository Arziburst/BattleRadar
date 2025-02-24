local _, BattleRadar = ...

-- Обработчики событий
local EventHandlers = {
    [BattleRadar.CONSTANTS.EVENTS.ADDON_LOADED] = function(self, addon)
        if addon ~= "BattleRadar" then return end
        BattleRadar:InitDB()
        BattleRadar:CreateCombatStatusFrame()
        BattleRadar:SetupConfig()
        print(BattleRadar.CONSTANTS.ADDON_NAME .. " v" .. BattleRadar.CONSTANTS.VERSION .. " ready!")
    end,
    
    [BattleRadar.CONSTANTS.EVENTS.ENTER_COMBAT] = function()
        BattleRadar.inCombat = true
        BattleRadar:UpdateCombatStatus(true)
    end,
    
    [BattleRadar.CONSTANTS.EVENTS.EXIT_COMBAT] = function()
        BattleRadar.inCombat = false
        BattleRadar:UpdateCombatStatus(false)
    end
}

-- Инициализация системы событий
-- Регистрирует и обрабатывает все игровые события
function BattleRadar:InitEvents()
    local frame = CreateFrame("Frame")
    
    -- Регистрация событий
    frame:RegisterEvent("ADDON_LOADED")
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    
    frame:SetScript("OnEvent", function(self, event, ...)
        if EventHandlers[event] then
            EventHandlers[event](self, ...)
        end
    end)
end 