local _, BattleRadar = ...

-- Создание главного окна настроек
function BattleRadar:CreateMainWindow()
    local mainFrame = CreateFrame("Frame", "BattleRadarMainFrame", UIParent, "BasicFrameTemplateWithInset")
    mainFrame:SetSize(500, 350)
    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

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

-- Восстановление позиции окна из сохраненных настроек
function BattleRadar:RestoreWindowPosition()
    local pos = self:LoadWindowPosition()
    if pos then
        self.mainFrame:ClearAllPoints()
        self.mainFrame:SetPoint(
            pos.point or "CENTER",
            UIParent,
            pos.point or "CENTER",
            pos.x or 0,
            pos.y or 0
        )
    end
end

-- Обновление текста статистики
function BattleRadar:UpdateStatsText()
    if not self.statsText then return end
    
    local stats = self:GetStats()
    local text = string.format(
        "Total kills: %d\nGold collected: %d gold %d silver %d copper",
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
    mainFrame.TitleBg:SetHeight(30)
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
    statsFrame:SetSize(230, 200)

    -- Заголовок секции
    local statsTitle = statsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    statsTitle:SetPoint("TOPLEFT", statsFrame, "TOPLEFT", 10, -10)
    statsTitle:SetText("Statistics")

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
    controlFrame:SetSize(230, 200)

    -- Заголовок секции
    local controlTitle = controlFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    controlTitle:SetPoint("TOPLEFT", controlFrame, "TOPLEFT", 10, -10)
    controlTitle:SetText("Controls")

    -- Кнопка сброса статистики
    local resetButton = CreateFrame("Button", nil, controlFrame, "UIPanelButtonTemplate")
    resetButton:SetSize(200, 25)
    resetButton:SetPoint("TOPLEFT", controlTitle, "BOTTOMLEFT", 0, -10)
    resetButton:SetText("Reset Statistics")
    resetButton:SetScript("OnClick", function()
        BattleRadar:ResetDB()
    end)

    -- Кнопка полного сброса
    local wipeButton = CreateFrame("Button", nil, controlFrame, "UIPanelButtonTemplate")
    wipeButton:SetSize(200, 25)
    wipeButton:SetPoint("TOPLEFT", resetButton, "BOTTOMLEFT", 0, -5)
    wipeButton:SetText("Wipe Database")
    wipeButton:SetScript("OnClick", function()
        BattleRadar:WipeDB()
    end)
end

