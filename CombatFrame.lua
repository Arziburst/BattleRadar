local _, BattleRadar = ...

-- Обновление прозрачности фрейма статуса боя
function BattleRadar:UpdateCombatFrameAlpha(value)
    if not self.combatStatusFrame then return end
    self.combatStatusFrame.statusIcon:SetAlpha(value)
    self.combatStatusFrame:SetAlpha(value)
end

function BattleRadar:CreateCombatStatusFrame()
    -- Проверяем, существует ли уже фрейм, и если да - удаляем его
    if self.combatStatusFrame then
        self.combatStatusFrame:Hide()
        self.combatStatusFrame:SetParent(nil)
        self.combatStatusFrame = nil
    end

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
    
    -- Обновляем состояние блокировки
    self:UpdateFrameLock()
    
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
                if not UnitAffectingCombat("player") then
                    self.combatStatusFrame:Hide()
                end
            end)
        end
    end
end

function BattleRadar:UpdateFrameLock()
    if not self.combatStatusFrame then return end
    
    if self.db.combatFrameSettings.lockFrame then
        self.combatStatusFrame:SetMovable(false)
        self.combatStatusFrame:EnableMouse(false)
        self.combatStatusFrame:RegisterForDrag(nil)
        self.combatStatusFrame:SetScript("OnDragStart", nil)
        self.combatStatusFrame:SetScript("OnDragStop", nil)
    else
        self.combatStatusFrame:SetMovable(true)
        self.combatStatusFrame:EnableMouse(true)
        self.combatStatusFrame:RegisterForDrag("LeftButton")
        self.combatStatusFrame:SetScript("OnDragStart", function(frame) 
            frame:StartMoving() 
        end)
        self.combatStatusFrame:SetScript("OnDragStop", function(frame) 
            frame:StopMovingOrSizing()
            -- Сохраняем позицию
            local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
            self.db.combatFramePosition = {point = point, x = xOfs, y = yOfs}
        end)
    end
end

function BattleRadar:InitCombatFrame()
    self.combatStatusFrame = self:CreateCombatStatusFrame()
end 