local _, addon = ...
local L = addon.L

-- Options module: manages all user settings and preferences UI
local Options = {}
addon.Options = Options

-- Initialize saved variables with default values
function Options:InitializeSettings()
    local wasReset = addon.ConfigManager.CheckAndResetConfig()
    if not QuickTravelDB then
        QuickTravelDB = {}
    end
    
    local DEFAULT_SETTINGS = {
        configVersion = addon.ConfigManager.CURRENT_CONFIG_VERSION,   -- (number) Config schema version for upgrades/reset
        showLoginMessage = true,                                      -- (boolean) Show login message in chat when addon loads
        autoClose = true,                                             -- (boolean) Auto-close addon UI after portal use
        favorites = {},                                               -- (table, array of strings) List of favorite portal instanceKeys
        useRandomHearthstoneVariant = true,                           -- (boolean) Use a random owned Hearthstone variant
        selectedHearthstoneVariant = nil,                             -- (number or nil) Selected Hearthstone variant ItemID (if not random)
        categoryOrder = addon.ConfigManager.DEFAULT_CATEGORY_ORDER,   -- (table, array) User's preferred order and enable state for portal categories
        showLFGTab = true,                                            -- (boolean) Show the QuickTravel tab in the Group Finder (LFG)
        showUnlearnedSpells = false,                                  -- (boolean) Show spells/portals the player has not learned yet
        showSpellTooltips = true                                      -- (boolean) Show tooltips for spells/portals in the UI
    }
    
    -- Apply defaults for missing settings
    for key, defaultValue in pairs(DEFAULT_SETTINGS) do
        if QuickTravelDB[key] == nil then
            QuickTravelDB[key] = defaultValue
        end
    end
    
    self.db = QuickTravelDB
    return QuickTravelDB
end

-- Create a visual separator line between UI sections
function Options:CreateSeparator(parent, previousElement, offsetY)
    offsetY = offsetY or -15
    local separator = parent:CreateTexture(nil, "ARTWORK")
    separator:SetHeight(8)
    separator:SetPoint("LEFT", parent, "LEFT", 20, 0)
    separator:SetPoint("RIGHT", parent, "RIGHT", -20, 0)
    separator:SetPoint("TOP", previousElement, "BOTTOM", 0, offsetY)
    separator:SetTexture("Interface\\Common\\UI-TooltipDivider-Transparent")
    separator:SetAlpha(0.8)
    return separator
end

-- Cache system for owned Hearthstone variant toys to avoid repeated API calls
local variantCache = {
    ownedVariants = nil,
    lastScan = 0,
    cacheTimeout = 60
}

-- Get sorted list of owned Hearthstone variant toys with caching
local function GetOwnedHearthstoneVariants(forceRefresh)
    local now = GetTime()
    if not forceRefresh and variantCache.ownedVariants and (now - variantCache.lastScan < variantCache.cacheTimeout) then
        return variantCache.ownedVariants
    end
    
    local owned = {}
    local constants = addon.constants
    if constants and constants.hearthstoneVariants then
        for _, variant in ipairs(constants.hearthstoneVariants) do
            if PlayerHasToy(variant.id) then
                local name = L[variant.nameKey] or ("Hearthstone " .. variant.id)
                table.insert(owned, {id = variant.id, name = name})
            end
        end
        table.sort(owned, function(a, b) return a.name < b.name end)
    end
    
    variantCache.ownedVariants = owned
    variantCache.lastScan = now
    return owned
end

-- Clear the Hearthstone variants cache
local function InvalidateVariantCache()
    variantCache.ownedVariants = nil
    variantCache.lastScan = 0
end

-- Create the main options UI frame with two tabs: Settings and Categories
function Options:CreateOptionsFrame(mainFrame)
    if self.optionsFrame then
        return self.optionsFrame
    end
    
    -- Main options frame with portrait template
    self.optionsFrame = CreateFrame("Frame", "QuickTravelOptionsFrame", UIParent, "PortraitFrameTemplate")
    self.optionsFrame:SetSize(290, 430)
    if mainFrame then
        self.optionsFrame:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 10, 0)
    else
        self.optionsFrame:SetPoint("CENTER")
    end
    self.optionsFrame:EnableMouse(true)
    SetPortraitToTexture(self.optionsFrame.PortraitContainer.portrait, "Interface\\Icons\\inv_10_engineering_manufacturedparts_gear_firey")

    -- Frame title
    local titleText = self.optionsFrame.TitleContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("CENTER", self.optionsFrame.TitleContainer, "CENTER", -15, 0)
    titleText:SetText(OPTIONS)
    titleText:SetTextColor(1, 0.82, 0)

    -- Create tab system for switching between options and categories
    local tab1 = CreateFrame("Button", "QuickTravelOptionsTab1", self.optionsFrame, "PanelTabButtonTemplate")
    tab1:SetPoint("TOPLEFT", self.optionsFrame, "BOTTOMLEFT", 5, 2)
    tab1:SetText(L["OPTIONS_TAB"])
    PanelTemplates_TabResize(tab1, 0)

    local tab2 = CreateFrame("Button", "QuickTravelOptionsTab2", self.optionsFrame, "PanelTabButtonTemplate")
    tab2:SetPoint("LEFT", tab1, "RIGHT", 3, 0)
    tab2:SetText(L["CATEGORIES_TAB"])
    PanelTemplates_TabResize(tab2, 0)

    self.optionsFrame.tab1 = tab1
    self.optionsFrame.tab2 = tab2
    self.optionsFrame.currentTab = 1

    -- Create content frames for each tab
    local optionsContent = CreateFrame("Frame", nil, self.optionsFrame)
    optionsContent:SetPoint("TOPLEFT", self.optionsFrame, "TOPLEFT", 10, -60)
    optionsContent:SetPoint("BOTTOMRIGHT", self.optionsFrame, "BOTTOMRIGHT", -10, 10)
    
    local categoriesContent = CreateFrame("Frame", nil, self.optionsFrame)
    categoriesContent:SetPoint("TOPLEFT", self.optionsFrame, "TOPLEFT", 10, -60)
    categoriesContent:SetPoint("BOTTOMRIGHT", self.optionsFrame, "BOTTOMRIGHT", -10, 10)
    categoriesContent:Hide()

    -- Categories tab: scrollable list for reordering and enabling/disabling categories
    local categoriesTitle = categoriesContent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    categoriesTitle:SetPoint("TOPLEFT", categoriesContent, "TOPLEFT", 8, 0)
    categoriesTitle:SetText(L["CATEGORIES_ORDER_HEADER"])
    categoriesTitle:SetTextColor(1, 0.82, 0)
    
    local categoriesScrollFrame = CreateFrame("ScrollFrame", nil, categoriesContent, "UIPanelScrollFrameTemplate")
    categoriesScrollFrame:SetPoint("TOPLEFT", categoriesContent, "TOPLEFT", 0, -20)
    categoriesScrollFrame:SetPoint("BOTTOMRIGHT", categoriesContent, "BOTTOMRIGHT", -25, 0)
    
    local categoriesContentFrame = CreateFrame("Frame", nil, categoriesScrollFrame)
    categoriesContentFrame:SetSize(300, 1)
    categoriesScrollFrame:SetScrollChild(categoriesContentFrame)

    -- Store references for later use
    self.optionsFrame.categoriesScrollFrame = categoriesScrollFrame
    self.optionsFrame.categoriesContentFrame = categoriesContentFrame
    self.optionsFrame.optionsContent = optionsContent
    self.optionsFrame.categoriesContent = categoriesContent
    self.optionsFrame.numTabs = 2

    -- Tab click handlers
    tab1:SetScript("OnClick", function() self:ShowTab(1) end)
    tab2:SetScript("OnClick", function() self:ShowTab(2) end)
    PanelTemplates_SetTab(self.optionsFrame, 1)

    -- DISPLAY SECTION: checkboxes for UI display options
    local displayHeader = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    displayHeader:SetPoint("TOPLEFT", self.optionsFrame.optionsContent, "TOPLEFT", 10, 0)
    displayHeader:SetText(L["DISPLAY_HEADER"])
    displayHeader:SetTextColor(1, 0.82, 0)

    -- Show login message checkbox
    local hideLoginCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame.optionsContent, "InterfaceOptionsCheckButtonTemplate")
    hideLoginCheckbox:SetPoint("TOPLEFT", displayHeader, "BOTTOMLEFT", 0, -10)
    hideLoginCheckbox:SetSize(22, 22)
    local showLoginText = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showLoginText:SetPoint("LEFT", hideLoginCheckbox, "RIGHT", 8, 0)
    showLoginText:SetText(L["SHOW_LOGIN_MESSAGE"])
    showLoginText:SetTextColor(1, 1, 1)

    -- Show spell tooltips checkbox
    local showTooltipsCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame.optionsContent, "InterfaceOptionsCheckButtonTemplate")
    showTooltipsCheckbox:SetPoint("TOPLEFT", hideLoginCheckbox, "BOTTOMLEFT", 0, -10)
    showTooltipsCheckbox:SetSize(22, 22)
    local showTooltipsText = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showTooltipsText:SetPoint("LEFT", showTooltipsCheckbox, "RIGHT", 8, 0)
    showTooltipsText:SetText(L["SHOW_SPELL_TOOLTIPS"])
    showTooltipsText:SetTextColor(1, 1, 1)

    -- Show unlearned spells checkbox
    local showUnlearnedCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame.optionsContent, "InterfaceOptionsCheckButtonTemplate")
    showUnlearnedCheckbox:SetPoint("TOPLEFT", showTooltipsCheckbox, "BOTTOMLEFT", 0, -10)
    showUnlearnedCheckbox:SetSize(22, 22)
    local showUnlearnedText = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showUnlearnedText:SetPoint("LEFT", showUnlearnedCheckbox, "RIGHT", 8, 0)
    showUnlearnedText:SetText(L["SHOW_UNLEARNED_SPELLS"])
    showUnlearnedText:SetTextColor(1, 1, 1)

    -- Show LFG tab checkbox
    local showLFGTabCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame.optionsContent, "InterfaceOptionsCheckButtonTemplate")
    showLFGTabCheckbox:SetPoint("TOPLEFT", showUnlearnedCheckbox, "BOTTOMLEFT", 0, -10)
    showLFGTabCheckbox:SetSize(22, 22)
    local showLFGTabText = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showLFGTabText:SetPoint("LEFT", showLFGTabCheckbox, "RIGHT", 8, 0)
    showLFGTabText:SetText(L["SHOW_LFG_TAB"])
    showLFGTabText:SetTextColor(1, 1, 1)

    -- BEHAVIOR SECTION: addon behavior settings
    local behaviorHeader = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    behaviorHeader:SetPoint("TOPLEFT", showLFGTabCheckbox, "BOTTOMLEFT", 0, -25)
    behaviorHeader:SetText(L["BEHAVIOR_HEADER"])
    behaviorHeader:SetTextColor(1, 0.82, 0)

    -- Auto-close frame after teleport checkbox
    local autoCloseCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame.optionsContent, "InterfaceOptionsCheckButtonTemplate")
    autoCloseCheckbox:SetPoint("TOPLEFT", behaviorHeader, "BOTTOMLEFT", 0, -10)
    autoCloseCheckbox:SetSize(22, 22)
    local autoCloseText = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    autoCloseText:SetPoint("LEFT", autoCloseCheckbox, "RIGHT", 8, 0)
    autoCloseText:SetText(L["AUTO_CLOSE"])
    autoCloseText:SetTextColor(1, 1, 1)

    -- HEARTHSTONE SECTION: Hearthstone variant selection
    local hearthstoneHeader = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    hearthstoneHeader:SetPoint("TOPLEFT", autoCloseCheckbox, "BOTTOMLEFT", 0, -25)
    hearthstoneHeader:SetText(L["HEARTHSTONE_HEADER"])
    hearthstoneHeader:SetTextColor(1, 0.82, 0)

    -- Use random Hearthstone variant checkbox
    local randomHearthstoneCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame.optionsContent, "InterfaceOptionsCheckButtonTemplate")
    randomHearthstoneCheckbox:SetPoint("TOPLEFT", hearthstoneHeader, "BOTTOMLEFT", 0, -10)
    randomHearthstoneCheckbox:SetSize(22, 22)
    local randomHearthstoneText = self.optionsFrame.optionsContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    randomHearthstoneText:SetPoint("LEFT", randomHearthstoneCheckbox, "RIGHT", 8, 0)
    randomHearthstoneText:SetText(L["USE_RANDOM_HEARTHSTONE_VARIANT"])
    randomHearthstoneText:SetTextColor(1, 1, 1)

    -- Dropdown for selecting specific Hearthstone variant
    local hearthstoneDropdown = CreateFrame("Frame", "QuickTravelHearthstoneDropdown", self.optionsFrame.optionsContent, "UIDropDownMenuTemplate")
    hearthstoneDropdown:SetPoint("TOPLEFT", randomHearthstoneCheckbox, "BOTTOMLEFT", 5, -10)
    hearthstoneDropdown:SetSize(200, 32)

    -- Store references for event handling
    self.optionsFrame.hideLoginCheckbox = hideLoginCheckbox
    self.optionsFrame.autoCloseCheckbox = autoCloseCheckbox
    self.optionsFrame.randomHearthstoneCheckbox = randomHearthstoneCheckbox
    self.optionsFrame.hearthstoneDropdown = hearthstoneDropdown
    self.optionsFrame.showLFGTabCheckbox = showLFGTabCheckbox
    self.optionsFrame.showUnlearnedCheckbox = showUnlearnedCheckbox
    self.optionsFrame.showTooltipsCheckbox = showTooltipsCheckbox
    self.optionsFrame.randomHearthstoneText = randomHearthstoneText

    self:LoadOptionsValues()
    self:SetupEventHandlers()
    self.optionsFrame:Hide()
    return self.optionsFrame
end

-- Set up event handlers for all interactive UI elements
function Options:SetupEventHandlers()
    local QuickTravel = addon.QuickTravel
    local constants = addon.constants

    -- Login message toggle
    self.optionsFrame.hideLoginCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showLoginMessage = checkbox:GetChecked()
        print("|cff00ff00QuickTravel|r: " .. (self.db.showLoginMessage and L["MSG_LOGIN_MESSAGE_ENABLED"] or L["MSG_LOGIN_MESSAGE_DISABLED"]))
    end)
    
    -- Auto-close toggle
    self.optionsFrame.autoCloseCheckbox:SetScript("OnClick", function(checkbox)
        self.db.autoClose = checkbox:GetChecked()
    end)
    
    -- Random Hearthstone variant toggle
    self.optionsFrame.randomHearthstoneCheckbox:SetScript("OnClick", function(checkbox)
        self.db.useRandomHearthstoneVariant = checkbox:GetChecked()
        self:UpdateHearthstoneControls()
        if constants then
            constants.DataManager:InvalidateCache()
        end
        if QuickTravel then
            QuickTravel:PopulatePortalList()
        end
    end)
    
    -- LFG tab visibility toggle
    self.optionsFrame.showLFGTabCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showLFGTab = checkbox:GetChecked()
        if self.db.showLFGTab then
            if QuickTravel then
                QuickTravel:CreateLFGButton()
            end
        else
            if QuickTravel and QuickTravel.lfgButton then
                QuickTravel.lfgButton:Hide()
                QuickTravel.lfgButton:SetParent(nil)
                QuickTravel.lfgButton = nil
            end
        end
    end)
    
    -- Unlearned spells visibility toggle
    self.optionsFrame.showUnlearnedCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showUnlearnedSpells = checkbox:GetChecked()
        if constants then
            constants.DataManager:InvalidateCache()
        end
        if QuickTravel then
            QuickTravel:PopulatePortalList()
        end
    end)
    
    -- Spell tooltips toggle
    self.optionsFrame.showTooltipsCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showSpellTooltips = checkbox:GetChecked()
    end)
end

-- Load saved settings into UI controls
function Options:LoadOptionsValues()
    if not self.optionsFrame then return end
    
    self.optionsFrame.hideLoginCheckbox:SetChecked(self.db.showLoginMessage)
    self.optionsFrame.autoCloseCheckbox:SetChecked(self.db.autoClose)
    self.optionsFrame.randomHearthstoneCheckbox:SetChecked(self.db.useRandomHearthstoneVariant)
    self:SetupHearthstoneDropdown()
    self:UpdateHearthstoneControls()
    self.optionsFrame.showLFGTabCheckbox:SetChecked(self.db.showLFGTab)
    self.optionsFrame.showUnlearnedCheckbox:SetChecked(self.db.showUnlearnedSpells)
    self.optionsFrame.showTooltipsCheckbox:SetChecked(self.db.showSpellTooltips)
    self:SetupCategoriesList()
end

-- Display options window, creating it if necessary
function Options:ShowOptionsFrame(mainFrame)
    if not self.optionsFrame then
        self:CreateOptionsFrame(mainFrame)
        self:LoadOptionsValues()
    end
    self.optionsFrame:Show()
end

-- Hide options window
function Options:HideOptionsFrame()
    if self.optionsFrame then
        self.optionsFrame:Hide()
    end
end

-- Toggle options window visibility
function Options:ToggleOptionsFrame(mainFrame)
    if self.optionsFrame and self.optionsFrame:IsShown() then
        self:HideOptionsFrame()
    else
        self:ShowOptionsFrame(mainFrame)
    end
end

-- Populate Hearthstone variant dropdown with owned variants
function Options:SetupHearthstoneDropdown()
    local dropdown = self.optionsFrame.hearthstoneDropdown
    if not dropdown then return end
    
    local ownedVariants = GetOwnedHearthstoneVariants()
    
    -- Set default selection if none exists
    if #ownedVariants > 0 and not self.db.selectedHearthstoneVariant then
        self.db.selectedHearthstoneVariant = ownedVariants[1].id
    end
    
    UIDropDownMenu_SetWidth(dropdown, 180)
    UIDropDownMenu_Initialize(dropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        
        if #ownedVariants == 0 then
            info.text = L["NO_HEARTHSTONE_VARIANTS"]
            info.disabled = true
            info.notCheckable = true
            UIDropDownMenu_AddButton(info)
        else
            for _, variant in ipairs(ownedVariants) do
                info = UIDropDownMenu_CreateInfo()
                info.text = variant.name
                info.value = variant.id
                info.checked = (variant.id == Options.db.selectedHearthstoneVariant)
                info.func = function()
                    Options.db.selectedHearthstoneVariant = variant.id
                    UIDropDownMenu_SetSelectedValue(dropdown, variant.id)
                    if addon.constants then
                        addon.constants.DataManager:InvalidateCache()
                    end
                    if addon.QuickTravel then
                        addon.QuickTravel:PopulatePortalList()
                    end
                end
                UIDropDownMenu_AddButton(info)
            end
        end
    end)
    
    if self.db.selectedHearthstoneVariant then
        UIDropDownMenu_SetSelectedValue(dropdown, self.db.selectedHearthstoneVariant)
    end
end

-- Update Hearthstone control states based on category and variant availability
function Options:UpdateHearthstoneControls()
    if not self.optionsFrame then return end
    
    -- Check if Hearthstones category is enabled
    local hearthstonesEnabled = false
    if self.db.categoryOrder then
        for _, category in ipairs(self.db.categoryOrder) do
            if category.key == addon.ConfigManager.CATEGORY_KEYS.HEARTHSTONES and category.enabled then
                hearthstonesEnabled = true
                break
            end
        end
    else
        hearthstonesEnabled = true
    end
    
    local ownedVariants = GetOwnedHearthstoneVariants()
    local hasVariants = #ownedVariants > 0
    local randomEnabled = hearthstonesEnabled and hasVariants
    
    -- Enable/disable random checkbox based on category and variant availability
    self.optionsFrame.randomHearthstoneCheckbox:SetEnabled(randomEnabled)
    if randomEnabled then
        if self.optionsFrame.randomHearthstoneText then
            self.optionsFrame.randomHearthstoneText:SetTextColor(1, 1, 1)
        end
    else
        if self.optionsFrame.randomHearthstoneText then
            self.optionsFrame.randomHearthstoneText:SetTextColor(0.5, 0.5, 0.5)
        end
    end
    
    -- Auto-disable random setting if requirements not met
    if not hearthstonesEnabled or not hasVariants then
        self.optionsFrame.randomHearthstoneCheckbox:SetChecked(false)
        self.db.useRandomHearthstoneVariant = false
    end
    
    -- Enable/disable dropdown based on random setting
    local dropdownEnabled = hearthstonesEnabled and hasVariants and not self.db.useRandomHearthstoneVariant
    if dropdownEnabled then
        UIDropDownMenu_EnableDropDown(self.optionsFrame.hearthstoneDropdown)
    else
        UIDropDownMenu_DisableDropDown(self.optionsFrame.hearthstoneDropdown)
    end
end

-- Switch between options tabs
function Options:ShowTab(tabID)
    self.optionsFrame.currentTab = tabID
    if tabID == 1 then
        self.optionsFrame.optionsContent:Show()
        self.optionsFrame.categoriesContent:Hide()
        PanelTemplates_SetTab(self.optionsFrame, 1)
    else
        self.optionsFrame.optionsContent:Hide()
        self.optionsFrame.categoriesContent:Show()
        PanelTemplates_SetTab(self.optionsFrame, 2)
    end
end

-- Create the categories management list with checkboxes and reorder buttons
function Options:SetupCategoriesList()
    if not self.optionsFrame or not self.optionsFrame.categoriesContent then
        return
    end
    
    -- Clear existing category items
    local children = {self.optionsFrame.categoriesContent:GetChildren()}
    for _, child in ipairs(children) do
        child:Hide()
        child:SetParent(nil)
    end
    
    -- Ensure category order exists
    if not self.db.categoryOrder or #self.db.categoryOrder == 0 then
        self.db.categoryOrder = addon.ConfigManager.DEFAULT_CATEGORY_ORDER
    end
    
    -- Get localized category names and sort by order
    local localizedCategories = addon.ConfigManager.GetLocalizedCategoryOrder(self.db.categoryOrder)
    table.sort(localizedCategories, function(a, b) return a.order < b.order end)
    
    local yOffset = -30
    
    -- Create UI elements for each category
    for i, category in ipairs(localizedCategories) do
        local categoryFrame = CreateFrame("Frame", nil, self.optionsFrame.categoriesContent)
        categoryFrame:SetSize(280, 30)
        categoryFrame:SetPoint("TOPLEFT", self.optionsFrame.categoriesContent, "TOPLEFT", 10, yOffset)
        
        -- Enable/disable checkbox
        local checkbox = CreateFrame("CheckButton", nil, categoryFrame, "InterfaceOptionsCheckButtonTemplate")
        checkbox:SetPoint("LEFT", categoryFrame, "LEFT", 0, 0)
        checkbox:SetSize(22, 22)
        checkbox:SetChecked(category.enabled)
        checkbox:SetScript("OnClick", function(cb)
            -- Update database when checkbox is toggled
            for _, dbCategory in ipairs(self.db.categoryOrder) do
                if dbCategory.key == category.key then
                    dbCategory.enabled = cb:GetChecked()
                    break
                end
            end
            
            -- Update Hearthstone controls if this is the Hearthstones category
            if category.key == addon.ConfigManager.CATEGORY_KEYS.HEARTHSTONES then
                self:UpdateHearthstoneControls()
            end
            
            -- Refresh UI
            if addon.constants then
                addon.constants.DataManager:InvalidateCache()
            end
            if addon.QuickTravel then
                addon.QuickTravel:PopulatePortalList()
            end
        end)
        
        -- Category name
        local nameText = categoryFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameText:SetPoint("LEFT", checkbox, "RIGHT", 8, 0)
        nameText:SetText(category.name)
        nameText:SetTextColor(1, 1, 1)
        
        -- Move up button
        local upButton = CreateFrame("Button", nil, categoryFrame)
        upButton:SetSize(24, 24)
        upButton:SetPoint("RIGHT", categoryFrame, "RIGHT", -50, 0)
        upButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
        upButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
        upButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        upButton:SetScript("OnClick", function()
            self:MoveCategoryUp(i)
        end)
        
        -- Move down button
        local downButton = CreateFrame("Button", nil, categoryFrame)
        downButton:SetSize(24, 24)
        downButton:SetPoint("RIGHT", categoryFrame, "RIGHT", -25, 0)
        downButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
        downButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
        downButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
        downButton:SetScript("OnClick", function()
            self:MoveCategoryDown(i)
        end)
        
        -- Disable buttons at list boundaries
        if i == 1 then
            upButton:SetEnabled(false)
        end
        if i == #localizedCategories then
            downButton:SetEnabled(false)
        end
        
        yOffset = yOffset - 30
    end
end

-- Move category up in display order
function Options:MoveCategoryUp(index)
    if index <= 1 or not self.db.categoryOrder then return end
    
    -- Swap categories in database
    local temp = self.db.categoryOrder[index]
    self.db.categoryOrder[index] = self.db.categoryOrder[index - 1]
    self.db.categoryOrder[index - 1] = temp
    
    -- Update order values
    self.db.categoryOrder[index].order = index
    self.db.categoryOrder[index - 1].order = index - 1
    
    -- Refresh UI
    self:SetupCategoriesList()
    if addon.constants then
        addon.constants.DataManager:InvalidateCache()
    end
    if addon.QuickTravel then
        addon.QuickTravel:PopulatePortalList()
    end
end

-- Move category down in display order
function Options:MoveCategoryDown(index)
    if not self.db.categoryOrder or index >= #self.db.categoryOrder then return end
    
    -- Swap categories in database
    local temp = self.db.categoryOrder[index]
    self.db.categoryOrder[index] = self.db.categoryOrder[index + 1]
    self.db.categoryOrder[index + 1] = temp
    
    -- Update order values
    self.db.categoryOrder[index].order = index
    self.db.categoryOrder[index + 1].order = index + 1
    
    -- Refresh UI
    self:SetupCategoriesList()
    if addon.constants then
        addon.constants.DataManager:InvalidateCache()
    end
    if addon.QuickTravel then
        addon.QuickTravel:PopulatePortalList()
    end
end

return Options