local _, BattleRadar = ...

-- Обработчики событий
local EventHandlers = {
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
function BattleRadar:InitEvents()
    local frame = CreateFrame("Frame")
    
    -- Регистрация событий
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    
    frame:SetScript("OnEvent", function(self, event, ...)
        if EventHandlers[event] then
            EventHandlers[event](self, ...)
        end
    end)
end 