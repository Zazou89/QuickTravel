local _, addon = ...
local L = addon.L

-- Options module for QuickTravel
local Options = {}
addon.Options = Options

-- Default settings configuration
local DEFAULT_SETTINGS = {
    showLoginMessage = true,
    autoClose = true,
    favorites = {},
    showCurrentSeason = true,
    showHearthstones = false,
    useRandomHearthstoneVariant = true,
    selectedHearthstoneVariant = nil,
    reverseExpansionOrder = false,
    showLFGTab = true,
    showUnlearnedSpells = false,
    showSpellTooltips = true
}

-- Initialize saved variables with default values
function Options:InitializeSettings()
    if not QuickTravelDB then
        QuickTravelDB = {}
    end

    for key, defaultValue in pairs(DEFAULT_SETTINGS) do
        if QuickTravelDB[key] == nil then
            QuickTravelDB[key] = defaultValue
        end
    end

    self.db = QuickTravelDB
    return QuickTravelDB
end

-- Create a visual separator line
function Options:CreateSeparator(parent, previousElement, offsetY)
    offsetY = offsetY or -15
    
    local separator = parent:CreateTexture(nil, "ARTWORK")
    separator:SetHeight(8) -- Height of the separator line
    separator:SetPoint("LEFT", parent, "LEFT", 20, 0)
    separator:SetPoint("RIGHT", parent, "RIGHT", -20, 0)
    separator:SetPoint("TOP", previousElement, "BOTTOM", 0, offsetY)
    separator:SetTexture("Interface\\Common\\UI-TooltipDivider-Transparent")
    separator:SetAlpha(0.8)
    
    return separator
end

-- Hearthstone variants cache
local variantCache = {
    ownedVariants = nil,
    lastScan = 0,
    cacheTimeout = 60 -- 1 minute
}

-- Get owned hearthstone variants with caching
local function GetOwnedHearthstoneVariants()
    local now = GetTime()
    if variantCache.ownedVariants and (now - variantCache.lastScan < variantCache.cacheTimeout) then
        return variantCache.ownedVariants
    end
    
    local owned = {}
    local constants = addon.constants
    if constants and constants.hearthstoneVariants then
        for _, variantID in ipairs(constants.hearthstoneVariants) do
            if PlayerHasToy(variantID) then
                local name = C_Item.GetItemNameByID(variantID)
                if name then
                    table.insert(owned, {id = variantID, name = name})
                end
            end
        end
        
        -- Sort alphabetically
        table.sort(owned, function(a, b) return a.name < b.name end)
    end
    
    variantCache.ownedVariants = owned
    variantCache.lastScan = now
    return owned
end

-- Invalidate variant cache
local function InvalidateVariantCache()
    variantCache.ownedVariants = nil
    variantCache.lastScan = 0
end

-- Create the options configuration frame
function Options:CreateOptionsFrame(mainFrame)
    if self.optionsFrame then
        return self.optionsFrame
    end

    self.optionsFrame = CreateFrame("Frame", "QuickTravelOptionsFrame", UIParent, "PortraitFrameTemplate")
    self.optionsFrame:SetSize(290, 480)

    -- Position relative to main frame if available
    if mainFrame then
        self.optionsFrame:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 10, 0)
    else
        self.optionsFrame:SetPoint("CENTER")
    end

    self.optionsFrame:EnableMouse(true)
    SetPortraitToTexture(self.optionsFrame.PortraitContainer.portrait, "Interface\\Icons\\inv_10_engineering_manufacturedparts_gear_firey")

    -- Options frame title
    local titleText = self.optionsFrame.TitleContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("CENTER", self.optionsFrame.TitleContainer, "CENTER", -15, 0)
    titleText:SetText(OPTIONS)
    titleText:SetTextColor(1, 0.82, 0)

    -- === SECTION 1: DISPLAY ===
    -- Show login message checkbox
    local hideLoginCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    hideLoginCheckbox:SetPoint("TOPLEFT", self.optionsFrame, "TOPLEFT", 20, -60)
    hideLoginCheckbox:SetSize(22, 22)

    local showLoginText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showLoginText:SetPoint("LEFT", hideLoginCheckbox, "RIGHT", 8, 0)
    showLoginText:SetText(L["SHOW_LOGIN_MESSAGE"])
    showLoginText:SetTextColor(1, 1, 1)

    -- Show current season checkbox
    local showSeasonCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showSeasonCheckbox:SetPoint("TOPLEFT", hideLoginCheckbox, "BOTTOMLEFT", 0, -10)
    showSeasonCheckbox:SetSize(22, 22)

    local showSeasonText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showSeasonText:SetPoint("LEFT", showSeasonCheckbox, "RIGHT", 8, 0)
    showSeasonText:SetText(L["SHOW_CURRENT_SEASON"])
    showSeasonText:SetTextColor(1, 1, 1)

    -- Show spell tooltips checkbox
    local showTooltipsCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showTooltipsCheckbox:SetPoint("TOPLEFT", showSeasonCheckbox, "BOTTOMLEFT", 0, -10)
    showTooltipsCheckbox:SetSize(22, 22)

    local showTooltipsText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showTooltipsText:SetPoint("LEFT", showTooltipsCheckbox, "RIGHT", 8, 0)
    showTooltipsText:SetText(L["SHOW_SPELL_TOOLTIPS"])
    showTooltipsText:SetTextColor(1, 1, 1)

    -- Show unlearned spells checkbox
    local showUnlearnedCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showUnlearnedCheckbox:SetPoint("TOPLEFT", showTooltipsCheckbox, "BOTTOMLEFT", 0, -10)
    showUnlearnedCheckbox:SetSize(22, 22)

    local showUnlearnedText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showUnlearnedText:SetPoint("LEFT", showUnlearnedCheckbox, "RIGHT", 8, 0)
    showUnlearnedText:SetText(L["SHOW_UNLEARNED_SPELLS"])
    showUnlearnedText:SetTextColor(1, 1, 1)

    -- SEPARATOR 1
    local separator1 = self:CreateSeparator(self.optionsFrame, showUnlearnedCheckbox)

    -- === SECTION 2: HEARTHSTONES ===
    -- Show hearthstones checkbox
    local showHearthstonesCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showHearthstonesCheckbox:SetPoint("TOPLEFT", separator1, "BOTTOMLEFT", 0, -15)
    showHearthstonesCheckbox:SetSize(22, 22)

    local showHearthstonesText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showHearthstonesText:SetPoint("LEFT", showHearthstonesCheckbox, "RIGHT", 8, 0)
    showHearthstonesText:SetText(L["SHOW_HEARTHSTONES"])
    showHearthstonesText:SetTextColor(1, 1, 1)

    -- Random hearthstone variant checkbox
    local randomHearthstoneCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    randomHearthstoneCheckbox:SetPoint("TOPLEFT", showHearthstonesCheckbox, "BOTTOMLEFT", 0, -10)
    randomHearthstoneCheckbox:SetSize(22, 22)

    local randomHearthstoneText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    randomHearthstoneText:SetPoint("LEFT", randomHearthstoneCheckbox, "RIGHT", 8, 0)
    randomHearthstoneText:SetText(L["USE_RANDOM_HEARTHSTONE_VARIANT"])
    randomHearthstoneText:SetTextColor(1, 1, 1)

    -- Hearthstone variant dropdown
    local hearthstoneDropdown = CreateFrame("Frame", "QuickTravelHearthstoneDropdown", self.optionsFrame, "UIDropDownMenuTemplate")
    hearthstoneDropdown:SetPoint("TOPLEFT", randomHearthstoneCheckbox, "BOTTOMLEFT", 5, -10)
    hearthstoneDropdown:SetSize(200, 32)

    -- SEPARATOR 2
    local separator2 = self:CreateSeparator(self.optionsFrame, hearthstoneDropdown)

    -- === SECTION 3: BEHAVIOR ===
    -- Auto close checkbox
    local autoCloseCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    autoCloseCheckbox:SetPoint("TOPLEFT", separator2, "BOTTOMLEFT", 0, -15)
    autoCloseCheckbox:SetSize(22, 22)

    local autoCloseText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    autoCloseText:SetPoint("LEFT", autoCloseCheckbox, "RIGHT", 8, 0)
    autoCloseText:SetText(L["AUTO_CLOSE"])
    autoCloseText:SetTextColor(1, 1, 1)

    -- Reverse expansion order checkbox
    local reverseOrderCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    reverseOrderCheckbox:SetPoint("TOPLEFT", autoCloseCheckbox, "BOTTOMLEFT", 0, -10)
    reverseOrderCheckbox:SetSize(22, 22)

    local reverseOrderText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    reverseOrderText:SetPoint("LEFT", reverseOrderCheckbox, "RIGHT", 8, 0)
    reverseOrderText:SetText(L["REVERSE_EXPANSION_ORDER"])
    reverseOrderText:SetTextColor(1, 1, 1)

    -- SEPARATOR 3
    local separator3 = self:CreateSeparator(self.optionsFrame, reverseOrderCheckbox)

    -- === SECTION 4: LFG ATTACHMENT ===
    -- Show LFG tab checkbox
    local showLFGTabCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    showLFGTabCheckbox:SetPoint("TOPLEFT", separator3, "BOTTOMLEFT", 0, -15)
    showLFGTabCheckbox:SetSize(22, 22)

    local showLFGTabText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    showLFGTabText:SetPoint("LEFT", showLFGTabCheckbox, "RIGHT", 8, 0)
    showLFGTabText:SetText(L["SHOW_LFG_TAB"])
    showLFGTabText:SetTextColor(1, 1, 1)

    -- Store references to checkboxes
    self.optionsFrame.hideLoginCheckbox = hideLoginCheckbox
    self.optionsFrame.autoCloseCheckbox = autoCloseCheckbox
    self.optionsFrame.showSeasonCheckbox = showSeasonCheckbox
    self.optionsFrame.showHearthstonesCheckbox = showHearthstonesCheckbox
    self.optionsFrame.randomHearthstoneCheckbox = randomHearthstoneCheckbox
    self.optionsFrame.hearthstoneDropdown = hearthstoneDropdown
    self.optionsFrame.reverseOrderCheckbox = reverseOrderCheckbox   
    self.optionsFrame.reverseOrderCheckbox = reverseOrderCheckbox
    self.optionsFrame.showLFGTabCheckbox = showLFGTabCheckbox
    self.optionsFrame.showUnlearnedCheckbox = showUnlearnedCheckbox
    self.optionsFrame.showTooltipsCheckbox = showTooltipsCheckbox
    

    self:LoadOptionsValues()
    self:SetupEventHandlers()

    self.optionsFrame:Hide()
    return self.optionsFrame
end

-- Setup event handlers for all checkboxes
function Options:SetupEventHandlers()
    local QuickTravel = addon.QuickTravel
    local constants = addon.constants

    -- Checkbox event handlers
    self.optionsFrame.hideLoginCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showLoginMessage = checkbox:GetChecked()
        print("|cff00ff00QuickTravel|r: " .. (self.db.showLoginMessage and L["MSG_LOGIN_MESSAGE_ENABLED"] or L["MSG_LOGIN_MESSAGE_DISABLED"]))
    end)

    self.optionsFrame.autoCloseCheckbox:SetScript("OnClick", function(checkbox)
        self.db.autoClose = checkbox:GetChecked()
    end)

    self.optionsFrame.showSeasonCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showCurrentSeason = checkbox:GetChecked()
        if QuickTravel then
            QuickTravel:PopulatePortalList()
        end
    end)

    self.optionsFrame.showHearthstonesCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showHearthstones = checkbox:GetChecked()
        self:UpdateHearthstoneControls()
        if constants then
            constants.DataManager:InvalidateCache()
        end
        if QuickTravel then
            QuickTravel:PopulatePortalList()
        end
    end)

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

    self.optionsFrame.reverseOrderCheckbox:SetScript("OnClick", function(checkbox)
        self.db.reverseExpansionOrder = checkbox:GetChecked()
        if QuickTravel then
            QuickTravel:PopulatePortalList()
        end
    end)

    self.optionsFrame.showLFGTabCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showLFGTab = checkbox:GetChecked()
        
        if self.db.showLFGTab then
            -- Create or update the LFG button
            if QuickTravel then
                QuickTravel:CreateLFGButton()
            end
        else
            -- Delete if disabled
            if QuickTravel and QuickTravel.lfgButton then
                QuickTravel.lfgButton:Hide()
                QuickTravel.lfgButton:SetParent(nil)
                QuickTravel.lfgButton = nil
            end
        end
    end)

    self.optionsFrame.showUnlearnedCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showUnlearnedSpells = checkbox:GetChecked()
        if constants then
            constants.DataManager:InvalidateCache()
        end
        if QuickTravel then
            QuickTravel:PopulatePortalList()
        end
    end)

    self.optionsFrame.showTooltipsCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showSpellTooltips = checkbox:GetChecked()
    end)
end

-- Load saved values into options checkboxes
function Options:LoadOptionsValues()
    if not self.optionsFrame then
        return
    end

    self.optionsFrame.hideLoginCheckbox:SetChecked(self.db.showLoginMessage)
    self.optionsFrame.autoCloseCheckbox:SetChecked(self.db.autoClose)
    self.optionsFrame.showSeasonCheckbox:SetChecked(self.db.showCurrentSeason)
    self.optionsFrame.showHearthstonesCheckbox:SetChecked(self.db.showHearthstones)
    self.optionsFrame.randomHearthstoneCheckbox:SetChecked(self.db.useRandomHearthstoneVariant)
    self:SetupHearthstoneDropdown()
    self:UpdateHearthstoneControls()
    self.optionsFrame.reverseOrderCheckbox:SetChecked(self.db.reverseExpansionOrder)
    self.optionsFrame.showLFGTabCheckbox:SetChecked(self.db.showLFGTab)
    self.optionsFrame.showUnlearnedCheckbox:SetChecked(self.db.showUnlearnedSpells)
    self.optionsFrame.showTooltipsCheckbox:SetChecked(self.db.showSpellTooltips)
end

-- Show the options frame
function Options:ShowOptionsFrame(mainFrame)
    if not self.optionsFrame then
        self:CreateOptionsFrame(mainFrame)
    end

    self:LoadOptionsValues()
    self.optionsFrame:Show()
end

-- Hide the options frame
function Options:HideOptionsFrame()
    if self.optionsFrame then
        self.optionsFrame:Hide()
    end
end

-- Toggle options frame visibility
function Options:ToggleOptionsFrame(mainFrame)
    if self.optionsFrame and self.optionsFrame:IsShown() then
        self:HideOptionsFrame()
    else
        self:ShowOptionsFrame(mainFrame)
    end
end

-- Setup hearthstone dropdown
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
    
    -- Set current selection
    if self.db.selectedHearthstoneVariant then
        UIDropDownMenu_SetSelectedValue(dropdown, self.db.selectedHearthstoneVariant)
    end
end

-- Update hearthstone controls state
function Options:UpdateHearthstoneControls()
    if not self.optionsFrame then return end
    
    local showHearthstones = self.db.showHearthstones
    local ownedVariants = GetOwnedHearthstoneVariants()
    local hasVariants = #ownedVariants > 0
    
    -- Enable/disable random checkbox based on master setting and variants
    local randomEnabled = showHearthstones and hasVariants
    self.optionsFrame.randomHearthstoneCheckbox:SetEnabled(randomEnabled)
    
    if not showHearthstones or not hasVariants then
        self.optionsFrame.randomHearthstoneCheckbox:SetChecked(false)
        self.db.useRandomHearthstoneVariant = false
    end
    
    -- Enable/disable dropdown
    local dropdownEnabled = showHearthstones and hasVariants and not self.db.useRandomHearthstoneVariant
    if dropdownEnabled then
        UIDropDownMenu_EnableDropDown(self.optionsFrame.hearthstoneDropdown)
    else
        UIDropDownMenu_DisableDropDown(self.optionsFrame.hearthstoneDropdown)
    end
end

-- Export the module
return Options