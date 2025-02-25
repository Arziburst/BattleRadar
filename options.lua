local _, BattleRadar = ...

function BattleRadar:SetupConfig()
    -- Создаем основную панель настроек
    local panel = CreateFrame("Frame", nil, UIParent)
    panel.name = "BattleRadar"
    
    -- Заголовок
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("BattleRadar Settings")
    
    -- Чекбокс для постоянного отображения
    local showCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    showCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    showCheckbox.Text:SetText("Always show combat frame")
    showCheckbox:SetChecked(self.db.combatFrameSettings.alwaysShow)
    
    -- Поле ввода времени скрытия
    local hideDelayInput = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    hideDelayInput:SetSize(50, 20)
    hideDelayInput:SetPoint("LEFT", showCheckbox.Text, "RIGHT", 10, 0)
    hideDelayInput:SetAutoFocus(false)
    hideDelayInput:SetNumeric(true)
    hideDelayInput:SetMaxLetters(3)
    
    -- Устанавливаем начальное значение
    hideDelayInput:SetText(tostring(self.db.combatFrameSettings.hideDelay))
    
    -- Текст подсказки для поля ввода
    local hideDelayText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    hideDelayText:SetPoint("LEFT", hideDelayInput, "RIGHT", 5, 0)
    hideDelayText:SetText("seconds to hide")
    
    -- Обновление видимости и активности поля ввода
    local function UpdateHideDelayInputState()
        if showCheckbox:GetChecked() then
            hideDelayInput:Disable()
            hideDelayInput:SetAlpha(0.5)
            hideDelayText:SetAlpha(0.5)
        else
            hideDelayInput:Enable()
            hideDelayInput:SetAlpha(1)
            hideDelayText:SetAlpha(1)
        end
    end
    
    -- Обработчик изменения значения в поле ввода
    hideDelayInput:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        if text == "" then return end
        
        local value = tonumber(text)
        if value then
            value = math.max(1, math.min(999, value))
            BattleRadar.db.combatFrameSettings.hideDelay = tostring(value)
        end
    end)
    
    -- Обработчик потери фокуса полем ввода
    hideDelayInput:SetScript("OnEditFocusLost", function(self)
        local text = self:GetText()
        if text == "" then
            self:SetText(BattleRadar.db.combatFrameSettings.hideDelay)
            return
        end
        
        local value = tonumber(text)
        if value then
            value = math.max(1, math.min(999, value))
            local strValue = tostring(value)
            self:SetText(strValue)
            BattleRadar.db.combatFrameSettings.hideDelay = strValue
        else
            self:SetText(BattleRadar.db.combatFrameSettings.hideDelay)
        end
    end)
    
    -- Обработчик нажатия Enter
    hideDelayInput:SetScript("OnEnterPressed", function(self)
        local text = self:GetText()
        if text == "" then
            self:SetText(BattleRadar.db.combatFrameSettings.hideDelay)
            self:ClearFocus()
            return
        end
        
        local value = tonumber(text)
        if value then
            value = math.max(1, math.min(999, value))
            local strValue = tostring(value)
            self:SetText(strValue)
            BattleRadar.db.combatFrameSettings.hideDelay = strValue
        else
            self:SetText(BattleRadar.db.combatFrameSettings.hideDelay)
        end
        self:ClearFocus()
    end)
    
    -- Обработчик нажатия Escape
    hideDelayInput:SetScript("OnEscapePressed", function(self)
        self:SetText(BattleRadar.db.combatFrameSettings.hideDelay)
        self:ClearFocus()
    end)
    
    showCheckbox:SetScript("OnClick", function(self)
        BattleRadar.db.combatFrameSettings.alwaysShow = self:GetChecked()
        UpdateHideDelayInputState()
        if self:GetChecked() then
            BattleRadar.combatStatusFrame:Show()
        else
            BattleRadar.combatStatusFrame:Hide()
        end
    end)
    
    -- Инициализация начального состояния
    UpdateHideDelayInputState()
    
    -- Чекбокс для блокировки фрейма
    local lockFrameCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    lockFrameCheckbox:SetPoint("TOPLEFT", showCheckbox, "BOTTOMLEFT", 0, -10)
    lockFrameCheckbox.Text:SetText("Lock combat frame position")
    lockFrameCheckbox:SetChecked(self.db.combatFrameSettings.lockFrame)
    lockFrameCheckbox:SetScript("OnClick", function(self)
        BattleRadar.db.combatFrameSettings.lockFrame = self:GetChecked()
        BattleRadar:UpdateFrameLock()
    end)
    
    -- Чекбокс для отображения кнопки на миникарте
    local minimapCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    minimapCheckbox:SetPoint("TOPLEFT", lockFrameCheckbox, "BOTTOMLEFT", 0, -10)
    minimapCheckbox.Text:SetText(self.CONSTANTS.TEXT.SETTINGS.SHOW_MINIMAP)
    minimapCheckbox:SetChecked(self.db.combatFrameSettings.showMinimapButton)
    minimapCheckbox:SetScript("OnClick", function(self)
        BattleRadar.db.combatFrameSettings.showMinimapButton = self:GetChecked()
        if self:GetChecked() then
            BattleRadar.minimapButton:Show()
        else
            BattleRadar.minimapButton:Hide()
        end
    end)
    
    -- Слайдер прозрачности
    local alphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    alphaSlider:SetPoint("TOPLEFT", minimapCheckbox, "BOTTOMLEFT", 0, -40)
    alphaSlider:SetWidth(200)
    alphaSlider:SetMinMaxValues(0, 1)
    alphaSlider:SetValue(self.db.combatFrameSettings.alpha)
    alphaSlider:SetValueStep(0.1)
    alphaSlider.Text:SetText("Frame transparency")
    alphaSlider:SetScript("OnValueChanged", function(self, value)
        BattleRadar.db.combatFrameSettings.alpha = value
        BattleRadar:UpdateCombatFrameAlpha(value)
    end)
    
    -- Чекбокс для режима отладки
    local debugCheckbox = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    debugCheckbox:SetPoint("TOPLEFT", alphaSlider, "BOTTOMLEFT", 0, -20)
    debugCheckbox.Text:SetText("Enable debug mode")
    debugCheckbox:SetChecked(self.db.debugMode)
    debugCheckbox:SetScript("OnClick", function(self)
        BattleRadar.db.debugMode = self:GetChecked()
        print(string.format("|cFF33FF99BattleRadar|r: Режим отладки %s", 
            BattleRadar.db.debugMode and "|cFF00FF00включен|r" or "|cFFFF0000выключен|r"))
    end)
    
    -- Кнопка сброса настроек
    local resetButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    resetButton:SetSize(120, 22)
    resetButton:SetPoint("TOPLEFT", debugCheckbox, "BOTTOMLEFT", 0, -20)
    resetButton:SetText("Reset Settings")
    resetButton:SetScript("OnClick", function()
        -- Создаем диалог подтверждения
        StaticPopupDialogs["BATTLERADAR_RESET_CONFIRM"] = {
            text = "Are you sure you want to reset all BattleRadar settings to default?",
            button1 = "Yes",
            button2 = "No",
            OnAccept = function()
                -- Сбрасываем настройки
                BattleRadar:WipeDB()
                
                -- Обновляем значения в элементах управления
                showCheckbox:SetChecked(BattleRadar.db.combatFrameSettings.alwaysShow)
                lockFrameCheckbox:SetChecked(BattleRadar.db.combatFrameSettings.lockFrame)
                minimapCheckbox:SetChecked(BattleRadar.db.combatFrameSettings.showMinimapButton)
                alphaSlider:SetValue(BattleRadar.db.combatFrameSettings.alpha)
                hideDelayInput:SetText(tostring(BattleRadar.db.combatFrameSettings.hideDelay))
                debugCheckbox:SetChecked(BattleRadar.db.debugMode)
                UpdateHideDelayInputState() -- Обновляем состояние поля ввода
                
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
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3
        }
        StaticPopup_Show("BATTLERADAR_RESET_CONFIRM")
    end)
    
    -- Сохраняем ссылку на панель
    self.optionsPanel = panel
    self.optionsPanel.hideDelayInput = hideDelayInput
    self.optionsPanel.debugCheckbox = debugCheckbox
    
    -- Регистрируем в системе настроек
    Settings.RegisterAddOnCategory(Settings.RegisterCanvasLayoutCategory(panel, "BattleRadar"))
end

-- Обновление прозрачности фрейма статуса боя
function BattleRadar:UpdateCombatFrameAlpha(value)
    if not self.combatStatusFrame then return end
    self.combatStatusFrame.statusIcon:SetAlpha(value)
    self.combatStatusFrame:SetAlpha(value)
end

function BattleRadar:CreateCombatStatusFrame()
    local frame = CreateFrame("Frame", "BattleRadarCombatStatus", UIParent)
    frame:SetSize(self.CONSTANTS.SIZES.COMBAT_FRAME.WIDTH, self.CONSTANTS.SIZES.COMBAT_FRAME.HEIGHT)
    frame:SetPoint(self.CONSTANTS.POSITIONS.COMBAT_FRAME.POINT, UIParent, self.CONSTANTS.POSITIONS.COMBAT_FRAME.POINT, 0, self.CONSTANTS.POSITIONS.COMBAT_FRAME.Y_OFFSET)
    
    -- Иконка статуса
    frame.statusIcon = frame:CreateTexture(nil, "ARTWORK")
    frame.statusIcon:SetSize(32, 32)
    frame.statusIcon:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.statusIcon:SetTexture(self.CONSTANTS.DEFAULTS.COMBAT_FRAME.ICONS.OUT_COMBAT)
    frame.statusIcon:SetAlpha(self.db.combatFrameSettings.alpha)
    
    -- Настройка перемещения
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, _, x, y = self:GetPoint()
        BattleRadar.db.combatFramePosition = {point = point, x = x, y = y}
    end)
    
    -- Восстанавливаем сохраненную позицию
    if self.db.combatFramePosition then
        local pos = self.db.combatFramePosition
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end
    
    -- Скрываем если не включен режим постоянного отображения
    if not self.db.combatFrameSettings.alwaysShow then
        frame:Hide()
    end
    
    self.combatStatusFrame = frame
    return frame
end

function BattleRadar:UpdateCombatStatus(inCombat)
    if not self.combatStatusFrame then return end
    
    -- Отменяем предыдущий таймер если он есть
    if self.hideTimer then
        self.hideTimer:Cancel()
        self.hideTimer = nil
    end
    
    if self.db.combatFrameSettings.alwaysShow or inCombat then
        self.combatStatusFrame:Show()
        self:UpdateCombatFrameAlpha(self.db.combatFrameSettings.alpha)
    end
    
    if inCombat then
        self.combatStatusFrame.statusIcon:SetTexture(self.CONSTANTS.DEFAULTS.COMBAT_FRAME.ICONS.IN_COMBAT)
    else
        self.combatStatusFrame.statusIcon:SetTexture(self.CONSTANTS.DEFAULTS.COMBAT_FRAME.ICONS.OUT_COMBAT)
        if not self.db.combatFrameSettings.alwaysShow then
            local delay = tonumber(self.db.combatFrameSettings.hideDelay) or self.CONSTANTS.DEFAULTS.HIDE_DELAY
            self.hideTimer = C_Timer.NewTimer(delay, function()
                if not UnitAffectingCombat("player") then
                    self.combatStatusFrame:Hide()
                end
                self.hideTimer = nil
            end)
        end
    end
end 