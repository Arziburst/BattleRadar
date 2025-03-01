local _, BattleRadar = ...

-- Структура базы данных
local DEFAULT_DB = {
    windowPosition = nil,  -- Позиция окна
    combatFramePosition = nil, -- Позиция фрейма статуса боя
    minimapButtonPosition = -0.75, -- Начальная позиция справа
    combatFrameSettings = {
        alpha = BattleRadar.CONSTANTS.DEFAULTS.COMBAT_FRAME.ALPHA,
        alwaysShow = BattleRadar.CONSTANTS.DEFAULTS.COMBAT_FRAME.ALWAYS_SHOW,
        showMinimapButton = BattleRadar.CONSTANTS.DEFAULTS.COMBAT_FRAME.SHOW_MINIMAP,
        lockFrame = false,  -- По умолчанию фрейм можно двигать
        hideDelay = "3" -- Время до скрытия иконки
    },
    debugMode = false -- Режим отладки выключен по умолчанию
}

-- Методы работы с БД
function BattleRadar:InitDB()
    if not BattleRadarDB then
        BattleRadarDB = self:GetDefaultDB()
    end
    
    -- Проверяем наличие всех необходимых полей
    if not BattleRadarDB.combatFrameSettings then
        BattleRadarDB.combatFrameSettings = DEFAULT_DB.combatFrameSettings
    end
    
    -- Проверяем и устанавливаем значения по умолчанию
    if type(BattleRadarDB.combatFrameSettings.hideDelay) ~= "string" then
        BattleRadarDB.combatFrameSettings.hideDelay = DEFAULT_DB.combatFrameSettings.hideDelay
    end
    
    -- Проверяем наличие поля debugMode
    if type(BattleRadarDB.debugMode) ~= "boolean" then
        BattleRadarDB.debugMode = DEFAULT_DB.debugMode
    end
    
    self.db = BattleRadarDB
end

-- Получение копии начального состояния БД
function BattleRadar:GetDefaultDB()
    return CopyTable(DEFAULT_DB)
end

-- Сброс базы данных к начальному состоянию
function BattleRadar:ResetDB()
    self.db = self:GetDefaultDB()
    self:LoadSettings()
end

-- Полная очистка базы данных
function BattleRadar:WipeDB()
    BattleRadarDB = self:GetDefaultDB()
    self.db = BattleRadarDB
    self:LoadSettings()
end

-- Сохранение позиции окна
function BattleRadar:SaveWindowPosition(point, x, y)
    self.db.windowPosition = {point = point, x = x, y = y}
end

-- Загрузка позиции окна
function BattleRadar:LoadWindowPosition()
    return self.db.windowPosition
end

function BattleRadar:LoadSettings()
    -- Загружаем настройки из БД
    if self.optionsPanel then
        local checkbox = self.optionsPanel.showCheckbox
        if checkbox then
            checkbox:SetChecked(self.db.combatFrameSettings.alwaysShow)
        end
        
        local minimapCheckbox = self.optionsPanel.minimapCheckbox
        if minimapCheckbox then
            minimapCheckbox:SetChecked(self.db.combatFrameSettings.showMinimapButton)
        end
        
        local slider = self.optionsPanel.alphaSlider
        if slider then
            slider:SetValue(self.db.combatFrameSettings.alpha)
        end
        
        local hideDelayInput = self.optionsPanel.hideDelayInput
        if hideDelayInput then
            hideDelayInput:SetText(tostring(self.db.combatFrameSettings.hideDelay))
        end
    end
end 