local _, BattleRadar = ...

-- Начальное состояние БД
local DEFAULT_DB = {
    windowPosition = nil,  -- Позиция окна
    totalGold = 0,        -- Собранное золото
    totalSilver = 0,      -- Собранное серебро
    totalCopper = 0,      -- Собранная медь
    totalKills = 0        -- Общее количество убийств
}

-- Инициализация базы данных
-- Создает или загружает сохраненные настройки и статистику
function BattleRadar:InitDB()
    -- BattleRadarDB уже существует если был сохранен ранее
    -- Если нет - создаем новый с дефолтными значениями
    BattleRadarDB = BattleRadarDB or self:GetDefaultDB()
    self.db = BattleRadarDB
end

-- Получение копии начального состояния БД
function BattleRadar:GetDefaultDB()
    local copy = {}
    for k, v in pairs(DEFAULT_DB) do
        copy[k] = v
    end
    return copy
end

-- Сброс статистики золота и убийств
-- @param keepPosition - если true, сохраняет текущую позицию окна
function BattleRadar:ResetDB(keepPosition)
    -- Сохраняем текущую позицию окна если нужно
    local currentPos = keepPosition and self.db.windowPosition or nil
    
    -- Сбрасываем только золото и убийства
    self.db.totalGold = 0
    self.db.totalSilver = 0
    self.db.totalCopper = 0
    self.db.totalKills = 0
    
    -- Восстанавливаем позицию если нужно
    if keepPosition then
        self.db.windowPosition = currentPos
    end
    
    self:UpdateStatsText()
    self:Debug("Statistics have been reset" .. (keepPosition and " (window position kept)" or ""))
end

-- Полное удаление БД
function BattleRadar:WipeDB()
    BattleRadarDB = nil
    self.db = self:GetDefaultDB()
    self:UpdateStatsText()
    self:Debug("Database has been completely wiped")
end

-- Сохранение позиции окна настроек
function BattleRadar:SaveWindowPosition()
    local point, _, _, x, y = self.mainFrame:GetPoint()
    self.db.windowPosition = {point = point, x = x, y = y}
end

-- Загрузка сохраненной позиции окна
function BattleRadar:LoadWindowPosition()
    return self.db.windowPosition
end

-- Добавление полученного золота в статистику
-- Автоматически конвертирует медь в серебро и золото
function BattleRadar:AddGold(gold, silver, copper)
    self.db.totalGold = self.db.totalGold + (gold or 0)
    self.db.totalSilver = self.db.totalSilver + (silver or 0)
    self.db.totalCopper = self.db.totalCopper + (copper or 0)
    
    -- Конвертация медных в серебро (100 медных = 1 серебряная)
    while self.db.totalCopper >= 100 do
        self.db.totalCopper = self.db.totalCopper - 100
        self.db.totalSilver = self.db.totalSilver + 1
    end
    
    -- Конвертация серебра в золото (100 серебряных = 1 золотая)
    while self.db.totalSilver >= 100 do
        self.db.totalSilver = self.db.totalSilver - 100
        self.db.totalGold = self.db.totalGold + 1
    end
    
    self:UpdateStatsText()
end

-- Увеличение счетчика убийств
function BattleRadar:AddKill()
    self.db.totalKills = self.db.totalKills + 1
    self:UpdateStatsText()
end

-- Получение текущей статистики
function BattleRadar:GetStats()
    return {
        kills = self.db.totalKills,
        gold = self.db.totalGold,
        silver = self.db.totalSilver,
        copper = self.db.totalCopper
    }
end 