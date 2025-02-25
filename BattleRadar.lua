local _, BattleRadar = ...

-- Инициализация аддона
local function Init()
    -- Инициализация базы данных
    BattleRadar:InitDB()
    
    -- Создаем панель настроек
    BattleRadar:SetupConfig()
    
    -- Инициализируем фрейм
    BattleRadar:InitCombatFrame()
    
    -- Создаем кнопку миникарты
    BattleRadar:InitMinimapButton()
    
    -- Инициализируем систему событий
    BattleRadar:InitEvents()
    
    -- Приветственное сообщение
    print("|cFF33FF99BattleRadar|r: Аддон загружен. Используйте /brs для настроек.")
end

-- Регистрация слэш-команд
SLASH_BATTLERADAR1 = "/brs"
SlashCmdList["BATTLERADAR"] = function(msg)
    if SettingsPanel and SettingsPanel:IsShown() then
        SettingsPanel:Close()
    else
        SettingsPanel:Open()
        local category = SettingsPanel:GetCategoryList():GetCategory("AddOns")
        if category then
            category:SelectFirstChild()
            for _, subCategory in ipairs(category:GetChildren()) do
                if subCategory:GetName() == "BattleRadar" then
                    subCategory:Select()
                    break
                end
            end
        end
    end
end

-- Команда сброса
SLASH_BATTLERADARRESET1 = "/brr"
SlashCmdList["BATTLERADARRESET"] = function(msg)
    -- Сбрасываем настройки
    BattleRadar:WipeDB()
    
    -- Обновляем значения в элементах управления
    if BattleRadar.optionsPanel then
        local showCheckbox = BattleRadar.optionsPanel.showCheckbox
        if showCheckbox then
            showCheckbox:SetChecked(BattleRadar.db.combatFrameSettings.alwaysShow)
        end
        
        local lockFrameCheckbox = BattleRadar.optionsPanel.lockFrameCheckbox
        if lockFrameCheckbox then
            lockFrameCheckbox:SetChecked(BattleRadar.db.combatFrameSettings.lockFrame)
        end
        
        local minimapCheckbox = BattleRadar.optionsPanel.minimapCheckbox
        if minimapCheckbox then
            minimapCheckbox:SetChecked(BattleRadar.db.combatFrameSettings.showMinimapButton)
        end
        
        local alphaSlider = BattleRadar.optionsPanel.alphaSlider
        if alphaSlider then
            alphaSlider:SetValue(BattleRadar.db.combatFrameSettings.alpha)
        end
        
        local hideDelayInput = BattleRadar.optionsPanel.hideDelayInput
        if hideDelayInput then
            hideDelayInput:SetText(BattleRadar.db.combatFrameSettings.hideDelay)
        end
    end
    
    -- Сбрасываем позицию фрейма
    if BattleRadar.combatStatusFrame then
        BattleRadar.combatStatusFrame:ClearAllPoints()
        BattleRadar.combatStatusFrame:SetPoint(BattleRadar.CONSTANTS.POSITIONS.COMBAT_FRAME.POINT, 
            UIParent, 
            BattleRadar.CONSTANTS.POSITIONS.COMBAT_FRAME.POINT, 
            0, 
            BattleRadar.CONSTANTS.POSITIONS.COMBAT_FRAME.Y_OFFSET)
    end
    
    -- Применяем настройки
    BattleRadar:UpdateCombatStatus(BattleRadar.inCombat)
    BattleRadar:UpdateFrameLock()
    BattleRadar:UpdateCombatFrameAlpha(BattleRadar.db.combatFrameSettings.alpha)
    
    -- Обновляем видимость кнопки миникарты
    if BattleRadar.db.combatFrameSettings.showMinimapButton then
        BattleRadar.minimapButton:Show()
    else
        BattleRadar.minimapButton:Hide()
    end
    
    -- Сообщение о сбросе
    print("|cFF33FF99BattleRadar|r: Настройки сброшены к значениям по умолчанию.")
end

-- Регистрируем событие загрузки аддона
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "BattleRadar" then
        Init()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)