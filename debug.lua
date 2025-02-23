local _, BattleRadar = ...

-- Включение режима отладки по умолчанию
BattleRadar.debug = true

-- Функция для отладочного вывода
function BattleRadar:Debug(message)
    if not self.debugMode then return end

    if type(message) == "table" then
        print("|cFF00FF00BattleRadar Debug:|r Table contents:")
        for k, v in pairs(message) do
            print("  " .. tostring(k) .. " = " .. tostring(v))
        end
    else
        print("|cFF00FF00BattleRadar Debug:|r " .. tostring(message))
    end
end

-- Слеш-команда для включения/выключения режима отладки
SLASH_BATTLERADARDEBUG1 = "/brd"
SlashCmdList["BATTLERADARDEBUG"] = function(msg)
    BattleRadar.debug = not BattleRadar.debug
    print("BattleRadar debug mode:", BattleRadar.debug and "ON" or "OFF")
end 