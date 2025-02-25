local _, BattleRadar = ...

-- Уровни отладки
BattleRadar.DEBUG_LEVELS = {
    INFO = 1,
    WARNING = 2,
    ERROR = 3
}

-- Цвета для разных уровней отладки
local DEBUG_COLORS = {
    [1] = "00FF00", -- INFO: зеленый
    [2] = "FFB400", -- WARNING: оранжевый
    [3] = "FF0000"  -- ERROR: красный
}

-- Префиксы для разных уровней отладки
local DEBUG_PREFIXES = {
    [1] = "INFO",
    [2] = "WARNING",
    [3] = "ERROR"
}

-- Функция для отладочного вывода
function BattleRadar:Debug(message, level)
    if not self.db.debugMode then return end
    
    level = level or self.DEBUG_LEVELS.INFO
    local color = DEBUG_COLORS[level]
    local prefix = DEBUG_PREFIXES[level]
    
    if type(message) == "table" then
        print(string.format("|cFF%sBattleRadar %s:|r Table contents:", color, prefix))
        self:DebugTable(message)
    else
        print(string.format("|cFF%sBattleRadar %s:|r %s", color, prefix, tostring(message)))
    end
end

-- Специальные функции для разных уровней
function BattleRadar:Info(message)
    self:Debug(message, self.DEBUG_LEVELS.INFO)
end

function BattleRadar:Warning(message)
    self:Debug(message, self.DEBUG_LEVELS.WARNING)
end

function BattleRadar:Error(message)
    self:Debug(message, self.DEBUG_LEVELS.ERROR)
end

-- Улучшенный вывод таблиц с отступами
function BattleRadar:DebugTable(tbl, depth)
    if not self.db.debugMode then return end
    
    depth = depth or 0
    local indent = string.rep("  ", depth)
    
    if type(tbl) ~= "table" then
        print(indent .. tostring(tbl))
        return
    end
    
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

-- Слеш-команда для управления режимом отладки
SLASH_BATTLERADARDEBUG1 = "/brd"
SlashCmdList["BATTLERADARDEBUG"] = function(msg)
    if not BattleRadar.db then
        print("|cFFFF0000BattleRadar ERROR:|r База данных не инициализирована")
        return
    end
    
    -- Обработка параметров команды
    msg = msg:lower():trim()
    
    if msg == "db" then
        -- Если режим отладки выключен, включаем его
        if not BattleRadar.db.debugMode then
            BattleRadar.db.debugMode = true
            print("|cFF33FF99BattleRadar|r: Режим отладки |cFF00FF00включен|r для просмотра базы данных")
            -- Обновляем чекбокс в настройках если он есть
            if BattleRadar.optionsPanel and BattleRadar.optionsPanel.debugCheckbox then
                BattleRadar.optionsPanel.debugCheckbox:SetChecked(true)
            end
        end
        -- Выводим текущее состояние БД
        print("|cFF33FF99BattleRadar|r: Текущее состояние базы данных:")
        BattleRadar:DebugTable(BattleRadar.db)
        return
    end
    
    -- Просто переключаем режим отладки
    BattleRadar.db.debugMode = not BattleRadar.db.debugMode
    
    -- Обновляем чекбокс в настройках если он есть
    if BattleRadar.optionsPanel and BattleRadar.optionsPanel.debugCheckbox then
        BattleRadar.optionsPanel.debugCheckbox:SetChecked(BattleRadar.db.debugMode)
    end
    
    -- Выводим только сообщение о статусе
    print(string.format("|cFF33FF99BattleRadar|r: Режим отладки %s", 
        BattleRadar.db.debugMode and "|cFF00FF00включен|r" or "|cFFFF0000выключен|r"))
end 