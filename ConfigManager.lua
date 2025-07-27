local _, addon = ...
local L = addon.L

-- Version number to track when reset is needed
local CURRENT_CONFIG_VERSION = 2

-- Fixed category keys (language-independent)
local CATEGORY_KEYS = {
    CURRENT_SEASON = "current_season",
    HEARTHSTONES = "hearthstones", 
    CATACLYSM = "cataclysm",
    MISTS_OF_PANDARIA = "mists_of_pandaria",
    WARLORDS_OF_DRAENOR = "warlords_of_draenor",
    LEGION = "legion",
    BATTLE_FOR_AZEROTH = "battle_for_azeroth",
    SHADOWLANDS = "shadowlands",
    DRAGONFLIGHT = "dragonflight",
    THE_WAR_WITHIN = "the_war_within"
}

-- Default category order with fixed keys
local DEFAULT_CATEGORY_ORDER = {
    {key = CATEGORY_KEYS.CURRENT_SEASON, enabled = true, order = 1},
    {key = CATEGORY_KEYS.HEARTHSTONES, enabled = true, order = 2},
    {key = CATEGORY_KEYS.CATACLYSM, enabled = true, order = 3},
    {key = CATEGORY_KEYS.MISTS_OF_PANDARIA, enabled = true, order = 4},
    {key = CATEGORY_KEYS.WARLORDS_OF_DRAENOR, enabled = true, order = 5},
    {key = CATEGORY_KEYS.LEGION, enabled = true, order = 6},
    {key = CATEGORY_KEYS.BATTLE_FOR_AZEROTH, enabled = true, order = 7},
    {key = CATEGORY_KEYS.SHADOWLANDS, enabled = true, order = 8},
    {key = CATEGORY_KEYS.DRAGONFLIGHT, enabled = true, order = 9},
    {key = CATEGORY_KEYS.THE_WAR_WITHIN, enabled = true, order = 10}
}

-- Mapping from fixed keys to localized names
local function GetLocalizedName(categoryKey)
    local keyToLocalized = {
        [CATEGORY_KEYS.CURRENT_SEASON] = L["Current Season"],
        [CATEGORY_KEYS.HEARTHSTONES] = L["Hearthstones"],
        [CATEGORY_KEYS.CATACLYSM] = L["Cataclysm"],
        [CATEGORY_KEYS.MISTS_OF_PANDARIA] = L["Mists of Pandaria"],
        [CATEGORY_KEYS.WARLORDS_OF_DRAENOR] = L["Warlords of Draenor"],
        [CATEGORY_KEYS.LEGION] = L["Legion"],
        [CATEGORY_KEYS.BATTLE_FOR_AZEROTH] = L["Battle for Azeroth"],
        [CATEGORY_KEYS.SHADOWLANDS] = L["Shadowlands"],
        [CATEGORY_KEYS.DRAGONFLIGHT] = L["Dragonflight"],
        [CATEGORY_KEYS.THE_WAR_WITHIN] = L["The War Within"]
    }
    return keyToLocalized[categoryKey] or categoryKey
end

-- Check if reset is needed and perform it
local function CheckAndResetConfig()
    local needsReset = false
    
    -- Check if config version is outdated or missing
    if not QuickTravelDB or not QuickTravelDB.configVersion or QuickTravelDB.configVersion < CURRENT_CONFIG_VERSION then
        needsReset = true
    end
    
    -- Check if old localized system is being used
    if QuickTravelDB and QuickTravelDB.categoryOrder and QuickTravelDB.categoryOrder[1] then
        if QuickTravelDB.categoryOrder[1].name and not QuickTravelDB.categoryOrder[1].key then
            needsReset = true
        end
    end
    
    if needsReset then
        -- Show reset message
        print("|cffff6600QuickTravel|r: Configuration reset due to system update. Reconfigure with /qt if needed.")
        
        -- Reset the entire config
        QuickTravelDB = {
            configVersion = CURRENT_CONFIG_VERSION,
            showLoginMessage = true,
            autoClose = true,
            favorites = {},
            useRandomHearthstoneVariant = true,
            selectedHearthstoneVariant = nil,
            categoryOrder = DEFAULT_CATEGORY_ORDER,
            showLFGTab = true,
            showUnlearnedSpells = false,
            showSpellTooltips = true
        }
        
        return true -- Reset occurred
    end
    
    return false -- No reset needed
end

-- Get category order with localized names for display
local function GetLocalizedCategoryOrder(categoryOrder)
    local localizedOrder = {}
    for _, category in ipairs(categoryOrder) do
        table.insert(localizedOrder, {
            key = category.key,
            name = GetLocalizedName(category.key),
            enabled = category.enabled,
            order = category.order
        })
    end
    return localizedOrder
end

-- Export functions and constants
addon.ConfigManager = {
    CATEGORY_KEYS = CATEGORY_KEYS,
    DEFAULT_CATEGORY_ORDER = DEFAULT_CATEGORY_ORDER,
    CheckAndResetConfig = CheckAndResetConfig,
    GetLocalizedName = GetLocalizedName,
    GetLocalizedCategoryOrder = GetLocalizedCategoryOrder,
    CURRENT_CONFIG_VERSION = CURRENT_CONFIG_VERSION
}