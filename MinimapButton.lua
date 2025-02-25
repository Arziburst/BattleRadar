local _, BattleRadar = ...

-- Создание иконки на миникарте
local function CreateMinimapButton()
    local button = CreateFrame("Button", "BattleRadarMinimapButton", Minimap)
    button:SetSize(BattleRadar.CONSTANTS.MINIMAP.BUTTON.SIZE, 
                  BattleRadar.CONSTANTS.MINIMAP.BUTTON.SIZE)
    button:SetFrameStrata("MEDIUM")
    
    -- Текстура иконки
    local background = button:CreateTexture(nil, "BACKGROUND")
    background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
    background:SetAllPoints()
    
    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetTexture(BattleRadar.CONSTANTS.DEFAULTS.COMBAT_FRAME.ICONS.IN_COMBAT)
    icon:SetSize(BattleRadar.CONSTANTS.MINIMAP.BUTTON.ICON_SIZE,
                BattleRadar.CONSTANTS.MINIMAP.BUTTON.ICON_SIZE)
    icon:SetPoint("CENTER")
    
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(BattleRadar.CONSTANTS.MINIMAP.BUTTON.BORDER_SIZE,
                  BattleRadar.CONSTANTS.MINIMAP.BUTTON.BORDER_SIZE)
    border:SetPoint("TOPLEFT")
    
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    -- Настройка перемещения
    button:RegisterForDrag("LeftButton")
    
    local function UpdatePosition()
        local angle = BattleRadar.db.minimapButtonPosition or 0
        -- Радиус круга вокруг миникарты
        local radius = BattleRadar.CONSTANTS.MINIMAP.BUTTON.RADIUS
        -- Вычисляем позицию на круге
        local x = radius * math.cos(angle)
        local y = radius * math.sin(angle)
        button:ClearAllPoints()
        button:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end
    
    -- Вызываем UpdatePosition после создания кнопки и после загрузки
    C_Timer.After(0.1, UpdatePosition)
    
    button:SetScript("OnDragStart", function(self)
        self.isMoving = true
    end)
    
    button:SetScript("OnDragStop", function(self)
        self.isMoving = false
        -- Сохраняем позицию в БД сразу после остановки перетаскивания
        BattleRadarDB.minimapButtonPosition = BattleRadar.db.minimapButtonPosition
    end)
    
    button:SetScript("OnUpdate", function(self)
        if self.isMoving then
            local xpos, ypos = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            local cx, cy = Minimap:GetCenter()
            xpos = xpos / scale
            ypos = ypos / scale
            -- Вычисляем угол между курсором и центром миникарты
            local angle = math.atan2(ypos - cy, xpos - cx)
            -- Нормализуем угол
            if angle < 0 then
                angle = angle + (2 * math.pi)
            end
            BattleRadar.db.minimapButtonPosition = angle
            UpdatePosition()
        end
    end)
    
    -- Обработчик клика
    button:SetScript("OnClick", function()
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
    end)
    
    -- Подсказка при наведении
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine(BattleRadar.CONSTANTS.MINIMAP.BUTTON.TOOLTIP.TITLE)
        GameTooltip:AddLine(BattleRadar.CONSTANTS.MINIMAP.BUTTON.TOOLTIP.HINT, 1, 1, 1)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    return button
end

function BattleRadar:InitMinimapButton()
    self.minimapButton = CreateMinimapButton()
    if not self.db.combatFrameSettings.showMinimapButton then
        self.minimapButton:Hide()
    end
end 