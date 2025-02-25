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
    BattleRadar:WipeDB()
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