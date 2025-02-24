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
    showCheckbox:SetScript("OnClick", function(self)
        BattleRadar.db.combatFrameSettings.alwaysShow = self:GetChecked()
        if self:GetChecked() then
            BattleRadar.combatStatusFrame:Show()
        else
            BattleRadar.combatStatusFrame:Hide()
        end
    end)
    
    -- Слайдер прозрачности
    local alphaSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
    alphaSlider:SetPoint("TOPLEFT", showCheckbox, "BOTTOMLEFT", 0, -40)
    alphaSlider:SetWidth(200)
    alphaSlider:SetMinMaxValues(0, 1)
    alphaSlider:SetValue(self.db.combatFrameSettings.alpha)
    alphaSlider:SetValueStep(0.1)
    alphaSlider.Text:SetText("Frame transparency")
    alphaSlider:SetScript("OnValueChanged", function(self, value)
        BattleRadar.db.combatFrameSettings.alpha = value
        BattleRadar:UpdateCombatFrameAlpha(value)
    end)
    
    -- Сохраняем ссылку на панель
    self.optionsPanel = panel
    
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
    
    if self.db.combatFrameSettings.alwaysShow or inCombat then
        self.combatStatusFrame:Show()
        self:UpdateCombatFrameAlpha(self.db.combatFrameSettings.alpha)
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