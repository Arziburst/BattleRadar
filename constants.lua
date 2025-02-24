local _, BattleRadar = ...

-- Константы аддона
BattleRadar.CONSTANTS = {
    -- Основная информация
    ADDON_NAME = "BattleRadar",
    VERSION = "0.0.1",
    
    -- События
    EVENTS = {
        ADDON_LOADED = "ADDON_LOADED",
        ENTER_COMBAT = "PLAYER_REGEN_DISABLED",
        EXIT_COMBAT = "PLAYER_REGEN_ENABLED"
    },
    
    COMMANDS = {
        SETTINGS = "/brs",
        RESET = "/brr"
    },
    
    -- Звуковые эффекты
    SOUND = {
        OPEN = 882,   -- Звук открытия окна
        CLOSE = 881   -- Звук закрытия окна
    },
    
    -- Цветовые коды для текста
    COLORS = {
        RED = "|cFFFF0000",
        GREEN = "|cFF00FF00",
    },

    -- Размеры
    SIZES = {
        COMBAT_FRAME = {
            WIDTH = 32,
            HEIGHT = 32
        },
        MAIN_WINDOW = {
            WIDTH = 400,
            HEIGHT = 300
        },
        STATS_SECTION = {
            WIDTH = 180,
            HEIGHT = 200
        },
        CONTROL_SECTION = {
            WIDTH = 180,
            HEIGHT = 200
        }
    },

    -- Позиции
    POSITIONS = {
        COMBAT_FRAME = {
            POINT = "CENTER",
            Y_OFFSET = 200
        }
    },

    -- Настройки интерфейса
    UI = {
        BUTTON = {
            WIDTH = 150,
            HEIGHT = 25
        },
        TITLE_HEIGHT = 20,
        SECTION_PADDING = 10,
        BUTTON_SPACING = 5
    },

    -- Тексты интерфейса
    TEXT = {
        STATS = {
            FORMAT = "Total kills: %d\nGold earned: %dg %ds %dc"
        },
        BUTTONS = {
            RESET = "Reset Stats",
            WIPE = "Wipe DB",
            DEBUG = "Debug Mode"
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
        HIDE_DELAY = 3
    }
} 