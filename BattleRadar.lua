local _, BattleRadar = ...

-- Инициализация основного аддона
-- Запускает систему событий и регистрирует слеш-команды
BattleRadar:InitEvents()

-- Регистрация основной слеш-команды /brs для окна настроек
SLASH_BATTLERADAR1 = "/brs"
SlashCmdList["BATTLERADAR"] = function(msg)
    BattleRadar:ToggleWindow()
end

-- Регистрация слеш-команды /brr для сброса статистики
SLASH_BATTLERADARRESET1 = "/brr"
SlashCmdList["BATTLERADARRESET"] = function(msg)
    if msg == "keeppos" then
        BattleRadar:ResetDB(true)
        print("BattleRadar: Statistics have been reset (window position kept)")
    elseif msg == "wipe" then
        BattleRadar:WipeDB()
        print("BattleRadar: Database has been completely wiped")
    else
        BattleRadar:ResetDB()
        print("BattleRadar: Statistics have been reset")
    end
end