local ADDON_NAME, addon = ...
local QuickTravel = {}
addon.QuickTravel = QuickTravel
local L = addon.L
local constants = addon.constants
local isFrameShown = false

-- Compartment click handler for the addon icon
function QuickTravel_OnAddonCompartmentClick(addonName, buttonName)
    QuickTravel:ToggleFrame()
end

-- Default settings configuration
local DEFAULT_SETTINGS = {
    showLoginMessage = true,
    autoClose = true,
    favorites = {},
    showCurrentSeason = true,
    reverseExpansionOrder = false,
    attachToLFG = true,
    showUnlearnedSpells = false,
    showSpellTooltips = true
}

-- Calculate intelligent offset based on loaded addons to position the frame correctly
local function GetSmartOffset()
    local baseOffset = 10
    local pgfLoaded = C_AddOns.IsAddOnLoaded("PremadeGroupsFilter")
    local rioLoaded = C_AddOns.IsAddOnLoaded("RaiderIO")
    
    if pgfLoaded and rioLoaded then
        local offset = baseOffset + 650
        return offset
    elseif pgfLoaded then
        local offset = baseOffset + 420
        return offset
    elseif rioLoaded then
        local offset = baseOffset + 230
        return offset
    else
        return baseOffset
    end
end

-- Create the main frame UI
function QuickTravel:CreateMainFrame()
    if self.mainFrame then
        return self.mainFrame
    end

    -- Create main frame with portrait template
    self.mainFrame = CreateFrame("Frame", "QuickTravelFrame", UIParent, "PortraitFrameTemplate")
    self.mainFrame:SetSize(320, 600)
    self.mainFrame:SetPoint("CENTER")
    self.mainFrame:SetMovable(true)
    self.mainFrame:EnableMouse(true)
    self.mainFrame:RegisterForDrag("LeftButton")
    self.mainFrame:SetScript("OnDragStart", self.mainFrame.StartMoving)
    self.mainFrame:SetScript("OnDragStop", self.mainFrame.StopMovingOrSizing)
    
    -- Set portrait icon
    SetPortraitToTexture(self.mainFrame.PortraitContainer.portrait, "Interface\\Icons\\inv_spell_arcane_portaldornogal")
    self.mainFrame.PortraitContainer.portrait:SetTexCoord(0.12, 0.96, 0.12, 0.92)

    -- Create title text
    local titleText = self.mainFrame.TitleContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("CENTER", self.mainFrame.TitleContainer, "CENTER", -10, 0)
    titleText:SetText(L["QT_TITLE"])
    titleText:SetTextColor(1, 0.82, 0)
    self.mainFrame.titleText = titleText

    -- Create search box for filtering portals
    local searchBox = CreateFrame("EditBox", nil, self.mainFrame, "SearchBoxTemplate")
    searchBox:SetSize(250, 30)
    searchBox:SetPoint("TOP", self.mainFrame, "TOP", 0, -53)
    searchBox:SetAutoFocus(false)
    searchBox:SetScript("OnTextChanged", function(editBox)
        SearchBoxTemplate_OnTextChanged(editBox)
        QuickTravel:PopulatePortalList(editBox:GetText())
    end)
    self.mainFrame.searchBox = searchBox

    -- Create options button with gear icon
    local optionsButton = CreateFrame("Button", nil, self.mainFrame)
    optionsButton:SetSize(24, 24)
    optionsButton:SetPoint("LEFT", searchBox, "RIGHT", 4, 0)

    local optionsIcon = optionsButton:CreateTexture(nil, "ARTWORK")
    optionsIcon:SetAllPoints()
    optionsIcon:SetTexture("Interface\\WorldMap\\Gear_64Grey")
    optionsIcon:SetDesaturated(true)
    optionsIcon:SetAlpha(0.6)

    local highlight = optionsButton:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetTexture("Interface\\WorldMap\\Gear_64Grey")
    highlight:SetDesaturated(false)
    highlight:SetAlpha(1)

    optionsButton:SetScript("OnClick", function()
        QuickTravel:ToggleOptionsFrame()
    end)

    -- Hide options frame when main frame is hidden
    self.mainFrame:SetScript("OnHide", function()
        if isFrameShown then
            self:HideOptionsFrame()
            isFrameShown = false
        end
    end)

    self.mainFrame.optionsButton = optionsButton
    self:CreateScrollFrame()
    self:PopulatePortalList()
    self.mainFrame:Hide()

    return self.mainFrame
end

-- Create scrollable content frame for portal list
function QuickTravel:CreateScrollFrame()
    local scrollFrame = CreateFrame("ScrollFrame", nil, self.mainFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", self.mainFrame, "TOPLEFT", 12, -85)
    scrollFrame:SetPoint("BOTTOMRIGHT", self.mainFrame, "BOTTOMRIGHT", -32, 12)

    local contentFrame = CreateFrame("Frame", nil, scrollFrame)
    contentFrame:SetSize(330, 1)
    scrollFrame:SetScrollChild(contentFrame)

    self.mainFrame.scrollFrame = scrollFrame
    self.mainFrame.contentFrame = contentFrame
end

-- Create a visual separator line
function QuickTravel:CreateSeparator(parent, previousElement, offsetY)
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

-- Initialize saved variables with default values
function QuickTravel:InitializeSettings()
    if not QuickTravelDB then
        QuickTravelDB = {}
    end

    for key, defaultValue in pairs(DEFAULT_SETTINGS) do
        if QuickTravelDB[key] == nil then
            QuickTravelDB[key] = defaultValue
        end
    end

    self.db = QuickTravelDB
end

-- Create the options configuration frame
function QuickTravel:CreateOptionsFrame()
    if self.optionsFrame then
        return self.optionsFrame
    end

    self.optionsFrame = CreateFrame("Frame", "QuickTravelOptionsFrame", UIParent, "PortraitFrameTemplate")
    self.optionsFrame:SetSize(370, 360)

    -- Position relative to main frame if available
    if self.mainFrame then
        self.optionsFrame:SetPoint("TOPLEFT", self.mainFrame, "TOPRIGHT", 10, 0)
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

    -- === SECTION 2: BEHAVIOR ===
    -- Auto close checkbox
    local autoCloseCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    autoCloseCheckbox:SetPoint("TOPLEFT", separator1, "BOTTOMLEFT", 0, -15)
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

    -- SEPARATOR 2
    local separator2 = self:CreateSeparator(self.optionsFrame, reverseOrderCheckbox)

    -- === SECTION 3: LFG ATTACHMENT ===
    -- Attach to LFG frame checkbox
    local attachLFGCheckbox = CreateFrame("CheckButton", nil, self.optionsFrame, "InterfaceOptionsCheckButtonTemplate")
    attachLFGCheckbox:SetPoint("TOPLEFT", separator2, "BOTTOMLEFT", 0, -15)
    attachLFGCheckbox:SetSize(22, 22)

    local attachLFGText = self.optionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    attachLFGText:SetPoint("LEFT", attachLFGCheckbox, "RIGHT", 8, 0)
    attachLFGText:SetText(L["ATTACH_TO_LFG"])
    attachLFGText:SetTextColor(1, 1, 1)
    attachLFGText:SetJustifyH("LEFT")

    -- Store references to checkboxes
    self.optionsFrame.hideLoginCheckbox = hideLoginCheckbox
    self.optionsFrame.autoCloseCheckbox = autoCloseCheckbox
    self.optionsFrame.showSeasonCheckbox = showSeasonCheckbox
    self.optionsFrame.reverseOrderCheckbox = reverseOrderCheckbox
    self.optionsFrame.attachLFGCheckbox = attachLFGCheckbox
    self.optionsFrame.showUnlearnedCheckbox = showUnlearnedCheckbox
    self.optionsFrame.showTooltipsCheckbox = showTooltipsCheckbox

    self:LoadOptionsValues()

    -- Checkbox event handlers
    hideLoginCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showLoginMessage = checkbox:GetChecked()
        print("|cff00ff00QuickTravel|r: " .. (self.db.showLoginMessage and L["MSG_LOGIN_MESSAGE_ENABLED"] or L["MSG_LOGIN_MESSAGE_DISABLED"]))
    end)

    autoCloseCheckbox:SetScript("OnClick", function(checkbox)
        self.db.autoClose = checkbox:GetChecked()
    end)

    showSeasonCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showCurrentSeason = checkbox:GetChecked()
        self:PopulatePortalList()
    end)

    reverseOrderCheckbox:SetScript("OnClick", function(checkbox)
        self.db.reverseExpansionOrder = checkbox:GetChecked()
        self:PopulatePortalList()
    end)

    attachLFGCheckbox:SetScript("OnClick", function(checkbox)
        self.db.attachToLFG = checkbox:GetChecked()
    end)

    showUnlearnedCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showUnlearnedSpells = checkbox:GetChecked()
        constants.DataManager:InvalidateCache()
        self:PopulatePortalList()
    end)

    showTooltipsCheckbox:SetScript("OnClick", function(checkbox)
        self.db.showSpellTooltips = checkbox:GetChecked()
    end)

    self.optionsFrame:Hide()
    return self.optionsFrame
end

-- Load saved values into options checkboxes
function QuickTravel:LoadOptionsValues()
    if not self.optionsFrame then
        return
    end

    self.optionsFrame.hideLoginCheckbox:SetChecked(self.db.showLoginMessage)
    self.optionsFrame.autoCloseCheckbox:SetChecked(self.db.autoClose)
    self.optionsFrame.showSeasonCheckbox:SetChecked(self.db.showCurrentSeason)
    self.optionsFrame.reverseOrderCheckbox:SetChecked(self.db.reverseExpansionOrder)
    self.optionsFrame.attachLFGCheckbox:SetChecked(self.db.attachToLFG)
    self.optionsFrame.showUnlearnedCheckbox:SetChecked(self.db.showUnlearnedSpells)
    self.optionsFrame.showTooltipsCheckbox:SetChecked(self.db.showSpellTooltips)
end

-- Show the options frame
function QuickTravel:ShowOptionsFrame()
    if not self.optionsFrame then
        self:CreateOptionsFrame()
    end

    self:LoadOptionsValues()
    self.optionsFrame:Show()
end

-- Hide the options frame
function QuickTravel:HideOptionsFrame()
    if self.optionsFrame then
        self.optionsFrame:Hide()
    end
end

-- Toggle options frame visibility
function QuickTravel:ToggleOptionsFrame()
    if self.optionsFrame and self.optionsFrame:IsShown() then
        self:HideOptionsFrame()
    else
        self:ShowOptionsFrame()
    end
end

-- Get expansion order based on user preference (normal or reversed)
function QuickTravel:GetExpansionOrder(originalOrder)
    if not self.db.reverseExpansionOrder then
        return originalOrder
    end

    local reorderedList = {}

    -- Keep current season at the top if enabled
    if self.db.showCurrentSeason then
        table.insert(reorderedList, L["Current Season"])
    end

    -- Reverse all other expansions
    local otherExpansions = {}
    for _, expansion in ipairs(originalOrder) do
        if expansion ~= L["Current Season"] then
            table.insert(otherExpansions, 1, expansion)
        end
    end

    for _, expansion in ipairs(otherExpansions) do
        table.insert(reorderedList, expansion)
    end

    return reorderedList
end

-- Handle LFG frame show event for auto-attachment
local function OnLFGListFrameShow()
    if not QuickTravel.db.attachToLFG or not QuickTravel.mainFrame then
        return
    end

    if PVEFrame:IsShown() and LFGListFrame:IsShown() and LFGListFrame.CategorySelection then
        C_Timer.After(0.1, function()
            local selectedCategory = LFGListFrame.CategorySelection.selectedCategory
            -- Categories 2 and 3 are Dungeons and Raids
            if selectedCategory == 2 or selectedCategory == 3 then
                local smartOffset = GetSmartOffset()
                QuickTravel.mainFrame:ClearAllPoints()
                QuickTravel.mainFrame:SetPoint("TOPLEFT", PVEFrame, "TOPRIGHT", smartOffset, 0)
                QuickTravel.mainFrame:SetSize(320, 428)
                QuickTravel:ShowFrame()
            end
        end)
    end
end

-- Handle LFG frame hide event for auto-detachment
local function OnLFGListFrameHide()
    if QuickTravel.mainFrame and QuickTravel.mainFrame:IsShown() and QuickTravel.db.attachToLFG then
        QuickTravel:HideFrame()
        QuickTravel.mainFrame:SetSize(320, 600)
        QuickTravel.mainFrame:ClearAllPoints()
        QuickTravel.mainFrame:SetPoint("CENTER")
    end
end

-- Initialize LFG frame hooks for auto-attachment feature
local function InitializeLFGHook()
    if LFGListFrame and PVEFrame then
        LFGListFrame:HookScript("OnShow", OnLFGListFrameShow)
        PVEFrame:HookScript("OnHide", OnLFGListFrameHide)

        if LFGListFrame.CategorySelection then
            hooksecurefunc("LFGListCategorySelection_SelectCategory", function()
                if not QuickTravel.db.attachToLFG then
                    return
                end

                local selectedCategory = LFGListFrame.CategorySelection.selectedCategory
                if selectedCategory == 2 or selectedCategory == 3 then
                    if PVEFrame:IsShown() and LFGListFrame:IsShown() then
                        local smartOffset = GetSmartOffset()
                        QuickTravel.mainFrame:ClearAllPoints()
                        QuickTravel.mainFrame:SetPoint("TOPLEFT", PVEFrame, "TOPRIGHT", smartOffset, 0)
                        QuickTravel.mainFrame:SetSize(320, 428)
                        QuickTravel:ShowFrame()
                    end
                else
                    if QuickTravel.mainFrame and QuickTravel.mainFrame:IsShown() and QuickTravel.db.attachToLFG then
                        QuickTravel:HideFrame()
                        QuickTravel.mainFrame:SetSize(320, 600)
                        QuickTravel.mainFrame:ClearAllPoints()
                        QuickTravel.mainFrame:SetPoint("CENTER")
                    end
                end
            end)
        end
    end
end

-- Populate the portal list with available portals, organized by expansion
function QuickTravel:PopulatePortalList(filterText)
    if not self.mainFrame or not self.mainFrame.scrollFrame then
        return
    end

    local contentFrame = self.mainFrame.contentFrame
    if not contentFrame then
        contentFrame = CreateFrame("Frame", nil, self.mainFrame.scrollFrame)
        contentFrame:SetSize(330, 1)
        self.mainFrame.scrollFrame:SetScrollChild(contentFrame)
        self.mainFrame.contentFrame = contentFrame
    else
        -- Clear existing content
        local children = { contentFrame:GetChildren() }
        for _, child in ipairs(children) do
            child:Hide()
            child:SetParent(nil)
        end

        local regions = { contentFrame:GetRegions() }
        for _, region in ipairs(regions) do
            if region:GetObjectType() == "FontString" then
                region:Hide()
                region:SetParent(nil)
            end
        end
    end

    -- Get available portals and organize by expansion
    local foundPortals = constants.DataManager:GetAvailablePortals()
    local organizedPortals, expansionOrder = constants.DataManager:OrganizeByExpansion(foundPortals)
    local finalExpansionOrder = self:GetExpansionOrder(expansionOrder)
    local yOffset = 0
    local currentSeasonKey = L["Current Season"]

    -- Filter function to check if portal matches search criteria
    local function portalMatchesFilter(portal, filter)
        local hasFilter = filter and filter ~= "" and filter ~= (L["SEARCH"] or "Rechercher...")
        -- Hide current season portals when filtered to avoid duplicates
        if hasFilter and portal.expansion == currentSeasonKey then
            return false
        end

        if not filter or filter == "" or filter == (L["SEARCH"] or "Rechercher...") then
            return true
        end

        filter = filter:lower()
        if portal.displayName and portal.displayName:lower():find(filter, 1, true) then
            return true
        end

        if portal.expansion and portal.expansion:lower():find(filter, 1, true) then
            return true
        end

        return false
    end

    -- Show favorites section first
    local favoritePortals = self:GetFavoritePortals()
    local filteredFavorites = {}

    for _, portal in ipairs(favoritePortals) do
        if portalMatchesFilter(portal, filterText) then
            table.insert(filteredFavorites, portal)
        end
    end

    if #filteredFavorites > 0 then
        local favoritesHeader = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        favoritesHeader:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 10, yOffset - 10)
        favoritesHeader:SetText(L["FAVORITES"])
        favoritesHeader:SetTextColor(1, 0.5, 0)
        yOffset = yOffset - 35

        for _, portal in ipairs(filteredFavorites) do
            yOffset = self:CreatePortalButton(contentFrame, portal, yOffset)
        end

        yOffset = yOffset - 10
    end

    local totalFilteredPortals = 0

    -- Show portals organized by expansion
    for _, expansion in ipairs(finalExpansionOrder) do
        if not (expansion == L["Current Season"] and not self.db.showCurrentSeason) then
            local filteredPortals = {}

            for _, portal in ipairs(organizedPortals[expansion] or {}) do
                if portalMatchesFilter(portal, filterText) then
                    table.insert(filteredPortals, portal)
                end
            end

            totalFilteredPortals = totalFilteredPortals + #filteredPortals

            if #filteredPortals > 0 then
                local expansionHeader = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                expansionHeader:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 10, yOffset - 10)
                expansionHeader:SetText(expansion)
                expansionHeader:SetTextColor(1, 0.82, 0)
                yOffset = yOffset - 35

                for _, portal in ipairs(filteredPortals) do
                    yOffset = self:CreatePortalButton(contentFrame, portal, yOffset)
                end

                yOffset = yOffset - 10
            end
        end
    end

    -- Show appropriate message when no results found
    if filterText and filterText ~= "" and filterText ~= (L["SEARCH"] or "Rechercher...") and totalFilteredPortals == 0 then
        local noResultsText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noResultsText:SetPoint("CENTER", 0, 0)
        noResultsText:SetText(L["NO_SEARCH_RESULTS"])
        noResultsText:SetTextColor(0.7, 0.7, 0.7)
        yOffset = -80
    elseif not foundPortals or #foundPortals == 0 then
        local noPortalsText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noPortalsText:SetPoint("CENTER", 0, 0)
        noPortalsText:SetText(L["NO_PORTALS_FOUND"])
        yOffset = -80
    end

    contentFrame:SetHeight(math.abs(yOffset))
end

-- Refresh portal list by invalidating cache and repopulating
function QuickTravel:RefreshPortals()
    constants.DataManager:InvalidateCache()

    if self.mainFrame and self.mainFrame:IsShown() then
        self:PopulatePortalList()
    end
end

-- Check if an instance is marked as favorite
function QuickTravel:IsFavorite(instanceKey)
    if not self.db or not self.db.favorites then
        return false
    end

    for _, favinstanceKey in ipairs(self.db.favorites) do
        if favinstanceKey == instanceKey then
            return true
        end
    end

    return false
end

-- Add an instance to favorites list
function QuickTravel:AddToFavorites(instanceKey)
    if not self.db.favorites then
        self.db.favorites = {}
    end

    if not self:IsFavorite(instanceKey) then
        table.insert(self.db.favorites, instanceKey)
        self:PopulatePortalList()
    end
end

-- Remove an instance from favorites list
function QuickTravel:RemoveFromFavorites(instanceKey)
    if not self.db.favorites then
        return
    end

    for i, favinstanceKey in ipairs(self.db.favorites) do
        if favinstanceKey == instanceKey then
            table.remove(self.db.favorites, i)
            self:PopulatePortalList()
            break
        end
    end
end

-- Toggle favorite status of an instance
function QuickTravel:ToggleFavorite(instanceKey)
    if self:IsFavorite(instanceKey) then
        self:RemoveFromFavorites(instanceKey)
    else
        self:AddToFavorites(instanceKey)
    end
end

-- Get list of favorite portals with full portal data
function QuickTravel:GetFavoritePortals()
    if not self.db.favorites or #self.db.favorites == 0 then
        return {}
    end

    local allPortals = constants.DataManager:GetAvailablePortals()
    local favoritePortals = {}

    for _, favinstanceKey in ipairs(self.db.favorites) do
        for _, portal in ipairs(allPortals) do
            if portal.instanceKey == favinstanceKey then
                table.insert(favoritePortals, portal)
                break
            end
        end
    end

    return favoritePortals
end

-- Update cooldowns for all visible portal buttons
function QuickTravel:UpdateCooldowns()
    if not self.mainFrame or not self.mainFrame.contentFrame then
        return
    end
    
    local children = { self.mainFrame.contentFrame:GetChildren() }
    for _, child in ipairs(children) do
        if child.cooldown and child.spellID then
            local cooldownInfo = C_Spell.GetSpellCooldown(child.spellID)
            if cooldownInfo and cooldownInfo.startTime > 0 and cooldownInfo.duration > 0 then
                child.cooldown:SetCooldown(cooldownInfo.startTime, cooldownInfo.duration)
            end
        end
    end
end

-- Create a clickable portal button with icon, text, and tooltip
function QuickTravel:CreatePortalButton(contentFrame, portal, yOffset)
    local portalButton = CreateFrame("Button", nil, contentFrame, "SecureActionButtonTemplate")
    portalButton:SetSize(310, 30)
    portalButton:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 0, yOffset)
    
    -- Only set spell attribute and register clicks if the spell is known
    if portal.isKnown then
        portalButton:SetAttribute("type", "spell")
        portalButton:SetAttribute("spell", portal.spellID)
        portalButton:RegisterForClicks("LeftButtonUp", "LeftButtonDown", "RightButtonUp")
    else
        -- Disable interaction for unknown spells
        portalButton:SetAttribute("type", nil)
        portalButton:EnableMouse(true) -- Keep mouse events for tooltip only
    end

    -- Background and highlight textures
    local bg = portalButton:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0)
    portalButton:SetNormalTexture(bg)

    local highlight = portalButton:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    if portal.isKnown then
        highlight:SetColorTexture(1, 1, 1, 0.1)
        portalButton:SetHighlightTexture(highlight)
    end

    -- Portal icon
    local icon = portalButton:CreateTexture(nil, "ARTWORK")
    icon:SetSize(26, 26)
    icon:SetPoint("LEFT", portalButton, "LEFT", 15, 0)
    icon:SetTexture(portal.texture)
    
    if not portal.isKnown then
        icon:SetDesaturated(true)
        icon:SetAlpha(0.4)
    end

    -- Cooldown frame for known spells
    if portal.isKnown then
        local cooldown = CreateFrame("Cooldown", nil, portalButton, "CooldownFrameTemplate")
        cooldown:SetAllPoints(icon)
        cooldown:SetSwipeColor(0, 0, 0, 0.8)
        
        -- Check and display initial cooldown
        local cooldownInfo = C_Spell.GetSpellCooldown(portal.spellID)
        if cooldownInfo and cooldownInfo.startTime > 0 and cooldownInfo.duration > 0 then
            cooldown:SetCooldown(cooldownInfo.startTime, cooldownInfo.duration)
        end
        
        portalButton.cooldown = cooldown
        portalButton.spellID = portal.spellID -- Store for updates
    end

    -- Portal name text
    local portalText = portalButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    portalText:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    portalText:SetText(portal.displayName)
    
    if portal.isKnown then
        portalText:SetTextColor(1, 1, 1)
    else
        portalText:SetTextColor(0.4, 0.4, 0.4)
    end

    -- Tooltip on hover
    portalButton:SetScript("OnEnter", function(self)

        -- Only show tooltips if the setting is enabled
        if not QuickTravel.db.showSpellTooltips then
            return
        end

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        
        if portal.isKnown then
            GameTooltip:SetSpellByID(portal.spellID)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff00ff00" .. L["CLICK_TO_TELEPORT"] .. "|r")
            
            if QuickTravel:IsFavorite(portal.instanceKey) then
                GameTooltip:AddLine("|cffff9999" .. L["RIGHT_CLICK_REMOVE_FAVORITE"] .. "|r")
            else
                GameTooltip:AddLine("|cff99ff99" .. L["RIGHT_CLICK_ADD_FAVORITE"] .. "|r")
            end
        else
            -- Text is grayed out for unlearned spells
            GameTooltip:SetText(portal.displayName, 0.5, 0.5, 0.5)
            GameTooltip:AddLine("|cffff6666" .. L["SPELL_NOT_LEARNED"] .. "|r")
        end
        
        GameTooltip:Show()
    end)

    portalButton:SetScript("OnLeave", GameTooltip_Hide)

    -- Handle clicks only for known spells
    if portal.isKnown then
        portalButton:SetScript("PostClick", function(self, button)
            if button == "RightButton" then
                QuickTravel:ToggleFavorite(portal.instanceKey)
            elseif button == "LeftButton" then
                -- Update cooldown after spell cast
                C_Timer.After(0.1, function()
                    if self.cooldown and self.spellID then
                        local cooldownInfo = C_Spell.GetSpellCooldown(self.spellID)
                        if cooldownInfo and cooldownInfo.startTime > 0 and cooldownInfo.duration > 0 then
                            self.cooldown:SetCooldown(cooldownInfo.startTime, cooldownInfo.duration)
                        end
                    end
                end)
                
                if QuickTravel.db.autoClose then
                    C_Timer.After(0.5, function()
                        QuickTravel:HideFrame()
                        QuickTravel:HideOptionsFrame()
                    end)
                end
            end
        end)
    end

    return yOffset - 30
end

-- Show the main frame
function QuickTravel:ShowFrame()
    if not self.mainFrame then
        self:CreateMainFrame()
    end

    self.mainFrame:Show()
    isFrameShown = true
    
    -- Update cooldowns when showing
    self:UpdateCooldowns()
end

-- Hide the main frame
function QuickTravel:HideFrame()
    if self.mainFrame then
        self.mainFrame:Hide()
    end

    self:HideOptionsFrame()
    isFrameShown = false
end

-- Toggle main frame visibility
function QuickTravel:ToggleFrame()
    if isFrameShown then
        self:HideFrame()
    else
        self:ShowFrame()
    end
end

-- Slash command registration
SLASH_QUICKTRAVEL1 = "/quicktravel"
SLASH_QUICKTRAVEL2 = "/qt"

SlashCmdList["QUICKTRAVEL"] = function()
    QuickTravel:ToggleFrame()
end

-- Keybinding function
function QuickTravel_ToggleBinding()
    QuickTravel:ToggleFrame()
end

-- Keybinding localization
BINDING_HEADER_QUICKTRAVEL = "QuickTravel"
BINDING_NAME_QUICKTRAVEL_TOGGLE = L["TOGGLE_QUICKTRAVEL"]

-- Event handler frame for addon lifecycle
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("LEARNED_SPELL_IN_TAB")

frame:SetScript("OnEvent", function(self, event, addonName, spellID)
    if event == "ADDON_LOADED" and addonName == ADDON_NAME then
        QuickTravel:InitializeSettings()
        C_Timer.After(1, InitializeLFGHook)

        if QuickTravel.db.showLoginMessage then
            print("|cff00ff00QuickTravel|r " .. L["LOADED"])
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        QuickTravel:CreateMainFrame()
    elseif event == "LEARNED_SPELL_IN_TAB" then
        -- Refresh portal list when new spells are learned
        QuickTravel:RefreshPortals()
    end
end)

-- Global reference for external access
_G["QuickTravel"] = QuickTravel