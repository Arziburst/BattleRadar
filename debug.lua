local _, BattleRadar = ...

-- Включение режима отладки по умолчанию
BattleRadar.debug = true

-- Уровни отладки
local DEBUG_LEVELS = {
    INFO = 1,
    WARNING = 2,
    ERROR = 3
}

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

function BattleRadar:DebugTable(tbl, depth)
    depth = depth or 0
    local indent = string.rep("  ", depth)
    
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(indent .. tostring(k) .. " = {")
            self:DebugTable(v, depth + 1)
            print(indent .. "}")
        else
            print(indent .. tostring(k) .. " = " .. tostring(v))
        end
    end
end

-- Слеш-команда для включения/выключения режима отладки
SLASH_BATTLERADARDEBUG1 = "/brd"
SlashCmdList["BATTLERADARDEBUG"] = function(msg)
    BattleRadar.debug = not BattleRadar.debug
    print("BattleRadar debug mode:", BattleRadar.debug and "ON" or "OFF")
end 