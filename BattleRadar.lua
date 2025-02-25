local _, BattleRadar = ...

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
    BattleRadar:WipeDB()
end

-- Инициализация аддона
function BattleRadar:Init()
    self:InitDB()
    self:InitMinimapButton()
    self:InitCombatFrame()
    self:InitEvents()
end

BattleRadar:Init()