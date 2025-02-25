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
    
    -- Размеры
    SIZES = {
        COMBAT_FRAME = {
            WIDTH = 32,
            HEIGHT = 32
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
        BUTTONS = {
            RESET = "Reset Settings"
        },
        SETTINGS = {
            ALWAYS_SHOW = "Always show combat frame",
            SHOW_MINIMAP = "Show minimap button",
            TRANSPARENCY = "Frame transparency",
            RESET_CONFIRM = "Are you sure you want to reset all BattleRadar settings to default?"
        }
    },

    -- Настройки по умолчанию
    DEFAULTS = {
        COMBAT_FRAME = {
            ALPHA = 0.8,
            ALWAYS_SHOW = true,
            SHOW_MINIMAP = true,
            LOCK_FRAME = false,
            ICONS = {
                IN_COMBAT = "Interface/Icons/Ability_Warrior_OffensiveStance",
                OUT_COMBAT = "Interface/Icons/Spell_LifegivingSpeed"
            }
        },
        HIDE_DELAY = 3
    },

    MINIMAP = {
        BUTTON = {
            SIZE = 30,           -- Размер кнопки как у других аддонов
            ICON_SIZE = 20,      -- Размер иконки чтобы не вылезала
            BORDER_SIZE = 50,    -- Размер бордера пропорционально
            RADIUS = 104,         -- Увеличиваем радиус от центра миникарты
            TOOLTIP = {
                TITLE = "BattleRadar",
                HINT = "Click to open settings"
            }
        }
    }
} 