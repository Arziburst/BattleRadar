local _, BattleRadar = ...

-- Создание главного окна настроек
function BattleRadar:CreateMainWindow()
    local mainFrame = CreateFrame("Frame", "BattleRadarMainFrame", UIParent, "BasicFrameTemplateWithInset")
    mainFrame:SetSize(self.CONSTANTS.SIZES.MAIN_WINDOW.WIDTH, self.CONSTANTS.SIZES.MAIN_WINDOW.HEIGHT)
    -- Устанавливаем позицию из сохраненных настроек или по центру
    if self.db.windowPosition then
        local pos = self.db.windowPosition
        mainFrame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    else
        mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end

    -- Создание секций окна
    self:CreateHeaderSection(mainFrame)    -- Секция заголовка
    self:CreateStatsSection(mainFrame)     -- Секция статистики
    self:CreateControlSection(mainFrame)   -- Секция управления

    -- Настройка перемещения окна
    mainFrame:EnableMouse(true)
    mainFrame:SetMovable(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    mainFrame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        BattleRadar:SaveWindowPosition()
    end)

    -- Звуковые эффекты при открытии/закрытии
    mainFrame:SetScript("OnShow", function()
        PlaySound(self.CONSTANTS.SOUND.OPEN)
    end)
    mainFrame:SetScript("OnHide", function()
        PlaySound(self.CONSTANTS.SOUND.CLOSE)
    end)

    -- Скрываем окно при создании
    mainFrame:Hide()
    self.mainFrame = mainFrame

    -- Добавление в список специальных фреймов для закрытия клавишей Escape
    table.insert(UISpecialFrames, "BattleRadarMainFrame")
end

-- Переключение видимости окна
function BattleRadar:ToggleWindow()
    if self.mainFrame:IsShown() then
        self.mainFrame:Hide()
    else
        self.mainFrame:Show()
    end
end

-- Обновление текста статистики
function BattleRadar:UpdateStatsText()
    if not self.statsText then return end
    
    local stats = self:GetStats()
    local text = string.format(self.CONSTANTS.TEXT.STATS.FORMAT,
        stats.kills,
        stats.gold,
        stats.silver,
        stats.copper
    )
    self.statsText:SetText(text)
end

-- Создание секции заголовка
function BattleRadar:CreateHeaderSection(mainFrame)
    -- Создание заголовка окна
    mainFrame.TitleBg:SetHeight(self.CONSTANTS.UI.TITLE_HEIGHT)
    mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    mainFrame.title:SetPoint("TOPLEFT", mainFrame.TitleBg, "TOPLEFT", 5, -3)
    mainFrame.title:SetText(self.CONSTANTS.ADDON_NAME .. " Settings")

    -- Отображение информации о персонаже
    mainFrame.playerName = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainFrame.playerName:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 15, -35)
    mainFrame.playerName:SetText("Character: " .. UnitName("player") .. " (Level " .. UnitLevel("player") .. ")")
end

-- Создание секции статистики
function BattleRadar:CreateStatsSection(mainFrame)
    -- Создание рамки для статистики
    local statsFrame = CreateFrame("Frame", nil, mainFrame, "InsetFrameTemplate")
    statsFrame:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 10, -60)
    statsFrame:SetSize(self.CONSTANTS.SIZES.STATS_SECTION.WIDTH, self.CONSTANTS.SIZES.STATS_SECTION.HEIGHT)

    -- Заголовок секции
    local statsTitle = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    statsTitle:SetPoint("TOPLEFT", statsFrame, "TOPLEFT", self.CONSTANTS.UI.SECTION_PADDING, -self.CONSTANTS.UI.SECTION_PADDING)
    statsTitle:SetText(self.CONSTANTS.TEXT.SECTIONS.STATS)

    -- Отображение статистики
    mainFrame.statsText = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    mainFrame.statsText:SetPoint("TOPLEFT", statsTitle, "BOTTOMLEFT", 0, -10)
    self.statsText = mainFrame.statsText
    self:UpdateStatsText()
end

-- Создание секции управления
function BattleRadar:CreateControlSection(mainFrame)
    -- Создание рамки для кнопок
    local controlFrame = CreateFrame("Frame", nil, mainFrame, "InsetFrameTemplate")
    controlFrame:SetPoint("TOPRIGHT", mainFrame, "TOPRIGHT", -10, -60)
    controlFrame:SetSize(self.CONSTANTS.SIZES.CONTROL_SECTION.WIDTH, self.CONSTANTS.SIZES.CONTROL_SECTION.HEIGHT)

    -- Заголовок секции
    local controlTitle = controlFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    controlTitle:SetPoint("TOPLEFT", controlFrame, "TOPLEFT", 10, -10)
    controlTitle:SetText(self.CONSTANTS.TEXT.SECTIONS.CONTROLS)

    -- Кнопка сброса статистики
    local resetButton = CreateFrame("Button", nil, controlFrame, "UIPanelButtonTemplate")
    resetButton:SetSize(self.CONSTANTS.UI.BUTTON.WIDTH, self.CONSTANTS.UI.BUTTON.HEIGHT)
    resetButton:SetPoint("TOPLEFT", controlTitle, "BOTTOMLEFT", 0, -10)
    resetButton:SetText(self.CONSTANTS.TEXT.BUTTONS.RESET)
    resetButton:SetScript("OnClick", function()
        BattleRadar:ResetDB()
    end)

    -- Кнопка полного сброса
    local wipeButton = CreateFrame("Button", nil, controlFrame, "UIPanelButtonTemplate")
    wipeButton:SetSize(self.CONSTANTS.UI.BUTTON.WIDTH, self.CONSTANTS.UI.BUTTON.HEIGHT)
    wipeButton:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", 0, -self.CONSTANTS.UI.BUTTON_SPACING)
    wipeButton:SetText(self.CONSTANTS.TEXT.BUTTONS.WIPE)
    wipeButton:SetScript("OnClick", function()
        BattleRadar:WipeDB()
    end)

    -- Кнопка переключения режима отладки
    local debugButton = CreateFrame("Button", nil, controlFrame, "UIPanelButtonTemplate")
    debugButton:SetSize(self.CONSTANTS.UI.BUTTON.WIDTH, self.CONSTANTS.UI.BUTTON.HEIGHT)
    debugButton:SetPoint("TOPLEFT", wipeButton, "BOTTOMLEFT", 0, -self.CONSTANTS.UI.BUTTON_SPACING)
    debugButton:SetText(self.CONSTANTS.TEXT.BUTTONS.DEBUG)
    
    local function UpdateDebugButtonState()
        if BattleRadar.db.debugMode then
            debugButton:SetNormalFontObject("GameFontGreen")
            debugButton:SetText(self.CONSTANTS.TEXT.BUTTONS.DEBUG .. " |cFF00FF00(ON)|r")
        else
            debugButton:SetNormalFontObject("GameFontNormal")
            debugButton:SetText(self.CONSTANTS.TEXT.BUTTONS.DEBUG .. " |cFFFF0000(OFF)|r")
        end
    end
    
    debugButton:SetScript("OnClick", function()
        BattleRadar.db.debugMode = not BattleRadar.db.debugMode
        BattleRadar.debugMode = BattleRadar.db.debugMode  -- Обновляем локальную переменную
        UpdateDebugButtonState()
        print("|cFF00FF00BattleRadar:|r Debug mode " .. (BattleRadar.debugMode and "enabled" or "disabled"))
    end)
    
    UpdateDebugButtonState()

    -- Разделитель
    local separator = controlFrame:CreateTexture(nil, "ARTWORK")
    separator:SetHeight(1)
    separator:SetWidth(self.CONSTANTS.UI.BUTTON.WIDTH)
    separator:SetPoint("TOPLEFT", debugButton, "BOTTOMLEFT", 0, -self.CONSTANTS.UI.BUTTON_SPACING * 2)
    separator:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    
    -- Секция настроек фрейма статуса боя
    local combatFrameTitle = controlFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    combatFrameTitle:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -self.CONSTANTS.UI.BUTTON_SPACING * 2)
    combatFrameTitle:SetText(self.CONSTANTS.TEXT.SECTIONS.COMBAT_SETTINGS)
    
    -- Чекбокс для постоянного отображения
    local showCheckbox = CreateFrame("CheckButton", nil, controlFrame, "ChatConfigCheckButtonTemplate")
    showCheckbox:SetPoint("TOPLEFT", combatFrameTitle, "BOTTOMLEFT", 0, -10)
    showCheckbox:SetChecked(self.db.combatFrameSettings.alwaysShow)
    showCheckbox.text = showCheckbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showCheckbox.text:SetPoint("LEFT", showCheckbox, "RIGHT", 5, 0)
    showCheckbox.text:SetText("Always show combat frame")
    showCheckbox:SetScript("OnClick", function(self)
        BattleRadar.db.combatFrameSettings.alwaysShow = self:GetChecked()
        if self:GetChecked() then
            BattleRadar.combatStatusFrame:Show()
        else
            BattleRadar.combatStatusFrame:Hide()
        end
    end)
    
    -- Слайдер прозрачности
    local alphaSlider = CreateFrame("Slider", nil, controlFrame, "OptionsSliderTemplate")
    alphaSlider:SetPoint("TOPLEFT", showCheckbox, "BOTTOMLEFT", 0, -30)
    alphaSlider:SetWidth(200)
    alphaSlider:SetMinMaxValues(0, 1)
    alphaSlider:SetValue(self.db.combatFrameSettings.alpha)
    alphaSlider:SetValueStep(0.1)
    alphaSlider.text = alphaSlider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    alphaSlider.text:SetPoint("BOTTOM", alphaSlider, "TOP", 0, 5)
    alphaSlider.text:SetText("Frame transparency")
    alphaSlider:SetScript("OnValueChanged", function(self, value)
        BattleRadar.db.combatFrameSettings.alpha = value
        BattleRadar.combatStatusFrame:SetBackdropColor(0, 0, 0, value)
        
        -- Обновляем прозрачность иконок
        BattleRadar.combatStatusFrame.statusIcon:SetAlpha(value)
        BattleRadar.combatStatusFrame:SetAlpha(value)
    end)
end

-- Создание фрейма статуса боя
function BattleRadar:CreateCombatStatusFrame()
    local frame = CreateFrame("Frame", "BattleRadarCombatStatus", UIParent)
    frame:SetSize(self.CONSTANTS.SIZES.COMBAT_FRAME.WIDTH, self.CONSTANTS.SIZES.COMBAT_FRAME.HEIGHT)
    frame:SetPoint(self.CONSTANTS.POSITIONS.COMBAT_FRAME.POINT, UIParent, self.CONSTANTS.POSITIONS.COMBAT_FRAME.POINT, 0, self.CONSTANTS.POSITIONS.COMBAT_FRAME.Y_OFFSET)
    
    -- Иконка статуса
    frame.statusIcon = frame:CreateTexture(nil, "ARTWORK")
    frame.statusIcon:SetSize(32, 32)
    frame.statusIcon:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.statusIcon:SetTexture(self.CONSTANTS.DEFAULTS.COMBAT_FRAME.ICONS.OUT_COMBAT)
    frame.statusIcon:SetAlpha(self.db.combatFrameSettings.alpha) -- Устанавливаем начальную прозрачность
    
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

-- Обновление текста статуса боя
function BattleRadar:UpdateCombatStatus(inCombat)
    if not self.combatStatusFrame then return end
    
    if self.db.combatFrameSettings.alwaysShow or inCombat then
        self.combatStatusFrame:Show()
    end
    
    if inCombat then
        self.combatStatusFrame.statusIcon:SetTexture(self.CONSTANTS.DEFAULTS.COMBAT_FRAME.ICONS.IN_COMBAT)
    else
        self.combatStatusFrame.statusIcon:SetTexture(self.CONSTANTS.DEFAULTS.COMBAT_FRAME.ICONS.OUT_COMBAT)
        if not self.db.combatFrameSettings.alwaysShow then
            C_Timer.After(self.CONSTANTS.DEFAULTS.HIDE_DELAY, function()
                self.combatStatusFrame:Hide()
            end)
        end
    end
end

