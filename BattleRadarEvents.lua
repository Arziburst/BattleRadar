local _, BattleRadar = ...

-- Инициализация системы событий
function BattleRadar:InitEvents()
    local frame = CreateFrame("Frame")
    
    -- Регистрация событий
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    
    frame:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_REGEN_DISABLED" then
            BattleRadar.inCombat = true
            BattleRadar:UpdateCombatStatus(true)
        elseif event == "PLAYER_REGEN_ENABLED" then
            BattleRadar.inCombat = false
            BattleRadar:UpdateCombatStatus(false)
        end
    end)
end 