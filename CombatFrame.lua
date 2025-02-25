local _, BattleRadar = ...

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

function BattleRadar:InitCombatFrame()
    self.combatStatusFrame = self:CreateCombatStatusFrame()
end 