local _, BattleRadar = ...

-- Инициализация системы событий
-- Регистрирует и обрабатывает все игровые события
function BattleRadar:InitEvents()
    local frame = CreateFrame("Frame", "BattleRadarEvents", UIParent)
    
    -- Регистрация отслеживаемых событий
    frame:RegisterEvent("PLAYER_LOGIN")           -- Вход в игру
    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") -- События боя
    frame:RegisterEvent("CHAT_MSG_MONEY")         -- Получение золота
    
    -- Обработчик событий
    frame:SetScript("OnEvent", function(self, event, ...)
        -- Инициализация при входе в игру
        if event == "PLAYER_LOGIN" then
            BattleRadar:InitDB()
            BattleRadar:CreateMainWindow()
            BattleRadar:RestoreWindowPosition()
            print(BattleRadar.CONSTANTS.ADDON_NAME .. " v" .. BattleRadar.CONSTANTS.VERSION .. " ready!")
        
        -- Обработка боевых событий (убийства)
        elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
            local _, subevent, _, sourceGUID, _, _, _, destGUID = CombatLogGetCurrentEventInfo()
            if subevent == "UNIT_DIED" then
                BattleRadar:AddKill()
            end
        
        -- Обработка получения золота
        elseif event == "CHAT_MSG_MONEY" then
            -- Получаем сумму из сообщения о получении денег
            local moneyString = ...
            local gold = tonumber(moneyString:match("(%d+) Gold")) or 0
            local silver = tonumber(moneyString:match("(%d+) Silver")) or 0
            local copper = tonumber(moneyString:match("(%d+) Copper")) or 0
            
            if gold > 0 or silver > 0 or copper > 0 then
                BattleRadar:AddGold(gold, silver, copper)
            end
        end
    end)
end 