local _, BattleRadar = ...

-- Константы аддона
BattleRadar.CONSTANTS = {
    -- Основная информация
    ADDON_NAME = "BattleRadar",
    VERSION = "0.0.1",
    
    -- Звуковые эффекты
    SOUND = {
        OPEN = 808,   -- Звук открытия окна
        CLOSE = 808   -- Звук закрытия окна
    },
    
    -- Цветовые коды для текста
    COLORS = {
        RED = "|cFFFF0000",
        GREEN = "|cFF00FF00",
    },

    -- Размеры окон
    SIZES = {
        MAIN_WINDOW = {
            WIDTH = 500,
            HEIGHT = 350
        },
        COMBAT_FRAME = {
            WIDTH = 150,
            HEIGHT = 30
        },
        STATS_SECTION = {
            WIDTH = 230,
            HEIGHT = 200
        },
        CONTROL_SECTION = {
            WIDTH = 230,
            HEIGHT = 200
        }
    },

    -- Позиции по умолчанию
    POSITIONS = {
        COMBAT_FRAME = {
            POINT = "TOP",
            Y_OFFSET = -100
        }
    },

    -- Настройки интерфейса
    UI = {
        BUTTON = {
            WIDTH = 200,
            HEIGHT = 25
        },
        TITLE_HEIGHT = 30,
        SECTION_PADDING = 10,
        BUTTON_SPACING = 5
    },

    -- Тексты интерфейса
    TEXT = {
        COMBAT = {
            IN = "● IN COMBAT",
            OUT = "○ OUT OF COMBAT"
        },
        STATS = {
            FORMAT = "Total kills: %d\ngold %d silver %d copper"
        },
        BUTTONS = {
            RESET = "Reset Statistics",
            WIPE = "Wipe Database",
            DEBUG = "Toggle Debug Mode"
        },
        SECTIONS = {
            STATS = "Statistics",
            CONTROLS = "Controls",
            COMBAT_SETTINGS = "Combat Frame Settings"
        },
        SETTINGS = {
            ALWAYS_SHOW = "Always show combat frame",
            TRANSPARENCY = "Frame transparency"
        }
    },

    -- Настройки по умолчанию
    DEFAULTS = {
        COMBAT_FRAME = {
            ALPHA = 0.8,
            ALWAYS_SHOW = false,
            ICONS = {
                IN_COMBAT = "Interface/Icons/Ability_Warrior_OffensiveStance",
                OUT_COMBAT = "Interface/Icons/Spell_LifegivingSpeed"
            }
        },
        HIDE_DELAY = 3  -- Задержка скрытия фрейма боя в секундах
    }
} 