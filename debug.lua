local _, BattleRadar = ...

-- Включение режима отладки по умолчанию
BattleRadar.debug = true

-- Функция для отладочного вывода
function BattleRadar:Debug(...)
    if self.debug then
        print(self.CONSTANTS.COLORS.GREEN .. self.CONSTANTS.ADDON_NAME .. " Debug:|r", ...)
    end
end

-- Слеш-команда для включения/выключения режима отладки
SLASH_BATTLERADARDEBUG1 = "/brd"
SlashCmdList["BATTLERADARDEBUG"] = function(msg)
    BattleRadar.debug = not BattleRadar.debug
    print("BattleRadar debug mode:", BattleRadar.debug and "ON" or "OFF")
end 