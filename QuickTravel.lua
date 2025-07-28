local ADDON_NAME, addon = ...
local QuickTravel = {}
addon.QuickTravel = QuickTravel
local L = addon.L
local constants = addon.constants
local isFrameShown = false
local ConfigManager = addon.ConfigManager

-- Addon compartment click handler for minimap/interface icons
function QuickTravel_OnAddonCompartmentClick(addonName, buttonName)
    QuickTravel:ToggleFrame()
end

-- Create the main QuickTravel UI frame with portal list
function QuickTravel:CreateMainFrame()
    if self.mainFrame then
        return self.mainFrame
    end

    -- Main frame using Blizzard's portrait template for consistency
    self.mainFrame = CreateFrame("Frame", "QuickTravelFrame", UIParent, "PortraitFrameTemplate")
    self.mainFrame:SetSize(320, 500)
    self.mainFrame:SetPoint("CENTER")
    self.mainFrame:SetMovable(true)
    self.mainFrame:EnableMouse(true)
    self.mainFrame:RegisterForDrag("LeftButton")
    self.mainFrame:SetScript("OnDragStart", self.mainFrame.StartMoving)
    self.mainFrame:SetScript("OnDragStop", self.mainFrame.StopMovingOrSizing)
    
    -- Set portal icon as frame portrait
    SetPortraitToTexture(self.mainFrame.PortraitContainer.portrait, "Interface\\Icons\\inv_spell_arcane_portaldornogal")
    self.mainFrame.PortraitContainer.portrait:SetTexCoord(0.12, 0.96, 0.12, 0.92)

    -- Frame title text
    local titleText = self.mainFrame.TitleContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("CENTER", self.mainFrame.TitleContainer, "CENTER", -10, 0)
    titleText:SetText(L["QT_TITLE"])
    titleText:SetTextColor(1, 0.82, 0)
    self.mainFrame.titleText = titleText

    -- Search box for filtering portals by name or expansion
    local searchBox = CreateFrame("EditBox", nil, self.mainFrame, "SearchBoxTemplate")
    searchBox:SetSize(250, 30)
    searchBox:SetPoint("TOP", self.mainFrame, "TOP", 0, -53)
    searchBox:SetAutoFocus(false)
    searchBox:SetScript("OnTextChanged", function(editBox)
        SearchBoxTemplate_OnTextChanged(editBox)
        QuickTravel:PopulatePortalList(editBox:GetText())
    end)
    self.mainFrame.searchBox = searchBox

    -- Options button with gear icon
    local optionsButton = CreateFrame("Button", nil, self.mainFrame)
    optionsButton:SetSize(24, 24)
    optionsButton:SetPoint("LEFT", searchBox, "RIGHT", 4, 0)

    -- Gear icon with hover effect
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
        addon.Options:ToggleOptionsFrame(self.mainFrame)
    end)

    -- Auto-hide options when main frame closes
    self.mainFrame:SetScript("OnHide", function()
        if isFrameShown then
            addon.Options:HideOptionsFrame()
            isFrameShown = false
        end
    end)

    self.mainFrame.optionsButton = optionsButton
    self:CreateScrollFrame()
    self:PopulatePortalList()
    self.mainFrame:Hide()

    return self.mainFrame
end

-- Create scrollable content area for the portal list
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

-- Create QuickTravel tab button in the LFG frame
function QuickTravel:CreateLFGButton()
    if self.lfgButton or not PVEFrame then
        return
    end

    local button = CreateFrame("Button", "QuickTravelLFGTab", PVEFrame, "PanelTabButtonTemplate")
    button:SetPoint("LEFT", PVEFrame.tab4, "RIGHT", 3, 0)
    button:SetText(L["LFG_TAB_PORTALS"])
    button:SetSize(80, 32)
    
    -- Configure tab appearance and behavior
    PanelTemplates_TabResize(button, 0)
    PanelTemplates_DeselectTab(button)
    
    -- Tab click opens QuickTravel frame
    button:SetScript("OnClick", function(self)
        QuickTravel:ToggleFrame()
    end)
    
    self.lfgButton = button
end

-- Hook into PVE frame to add LFG tab when appropriate
local function InitializeLFGHook()
    if PVEFrame then
        PVEFrame:HookScript("OnShow", function()
            if addon.Options.db.showLFGTab then
                QuickTravel:CreateLFGButton()
            end
        end)
    end
end

-- Populate the main portal list organized by expansion categories
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
        -- Clear existing portal buttons and text
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
    local finalExpansionOrder = expansionOrder
    local yOffset = 0
    local currentSeasonKey = L["Current Season"]

    -- Filter portals based on search text
    local function portalMatchesFilter(portal, filter)
        local hasFilter = filter and filter ~= "" and filter ~= L["SEARCH"]
        -- Hide current season portals when filtered to avoid duplicates
        if hasFilter and portal.expansion == currentSeasonKey then
            return false
        end

        if not filter or filter == "" or filter == L["SEARCH"] then
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

    -- Display favorites section first if any favorites match filter
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

    -- Display portals organized by expansion
    for _, expansion in ipairs(finalExpansionOrder) do
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

    -- Display appropriate message when no results found
    if filterText and filterText ~= "" and filterText ~= L["SEARCH"] and totalFilteredPortals == 0 then
        local noResultsText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noResultsText:SetPoint("CENTER", 0, 0)
        noResultsText:SetText(L["NO_SEARCH_RESULTS"])
        noResultsText:SetTextColor(0.7, 0.7, 0.7)
        yOffset = -80
    elseif (not foundPortals or #foundPortals == 0) and yOffset >= -10 then
        local noPortalsText = contentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        noPortalsText:SetPoint("CENTER", 0, 0)
        noPortalsText:SetText(L["NO_CATEGORIES_SELECTED"])
        noPortalsText:SetTextColor(0.7, 0.7, 0.7)
        yOffset = -80
    end

    contentFrame:SetHeight(math.abs(yOffset))
end

-- Force refresh of portal list by clearing cache and repopulating
function QuickTravel:RefreshPortals()
    constants.DataManager:InvalidateCache()

    if self.mainFrame and self.mainFrame:IsShown() then
        self:PopulatePortalList()
    end
end

-- Check if a portal is marked as favorite
function QuickTravel:IsFavorite(instanceKey)
    if not addon.Options.db or not addon.Options.db.favorites then
        return false
    end

    for _, favinstanceKey in ipairs(addon.Options.db.favorites) do
        if favinstanceKey == instanceKey then
            return true
        end
    end

    return false
end

-- Add portal to favorites list
function QuickTravel:AddToFavorites(instanceKey)
    if not addon.Options.db.favorites then
        addon.Options.db.favorites = {}
    end

    if not self:IsFavorite(instanceKey) then
        table.insert(addon.Options.db.favorites, instanceKey)
        self:PopulatePortalList()
    end
end

-- Remove portal from favorites list
function QuickTravel:RemoveFromFavorites(instanceKey)
    if not addon.Options.db.favorites then
        return
    end

    for i, favinstanceKey in ipairs(addon.Options.db.favorites) do
        if favinstanceKey == instanceKey then
            table.remove(addon.Options.db.favorites, i)
            self:PopulatePortalList()
            break
        end
    end
end

-- Toggle favorite status of a portal
function QuickTravel:ToggleFavorite(instanceKey)
    if self:IsFavorite(instanceKey) then
        self:RemoveFromFavorites(instanceKey)
    else
        self:AddToFavorites(instanceKey)
    end
end

-- Get complete portal data for all favorited portals
function QuickTravel:GetFavoritePortals()
    if not addon.Options.db.favorites or #addon.Options.db.favorites == 0 then
        return {}
    end

    local allPortals = constants.DataManager:GetAvailablePortals()
    local favoritePortals = {}

    for _, favinstanceKey in ipairs(addon.Options.db.favorites) do
        for _, portal in ipairs(allPortals) do
            if portal.instanceKey == favinstanceKey then
                table.insert(favoritePortals, portal)
                break
            end
        end
    end

    return favoritePortals
end

-- Update cooldown displays for all visible portal buttons
function QuickTravel:UpdateCooldowns()
    if not self.mainFrame or not self.mainFrame.contentFrame then
        return
    end
    
    local children = { self.mainFrame.contentFrame:GetChildren() }
    for _, child in ipairs(children) do
        if child.cooldown then
            if child.isToy and child.toyID then
                local startTime, duration = GetItemCooldown(child.toyID)
                if startTime > 0 and duration > 0 then
                    child.cooldown:SetCooldown(startTime, duration)
                end
            elseif child.isVariant then
                local portal = {variants = self.variants, fallback = self.fallback, isVariant = true}
                local effectiveID = QuickTravel:GetEffectiveHearthstoneID(portal)
                local startTime, duration = GetItemCooldown(effectiveID)
                if startTime > 0 and duration > 0 then
                    child.cooldown:SetCooldown(startTime, duration)
                end
            elseif child.spellID then
                local cooldownInfo = C_Spell.GetSpellCooldown(child.spellID)
                if cooldownInfo and cooldownInfo.startTime > 0 and cooldownInfo.duration > 0 then
                    child.cooldown:SetCooldown(cooldownInfo.startTime, cooldownInfo.duration)
                end
            end
        end
    end
end

-- Create individual portal button with icon, name, tooltip, and click functionality
function QuickTravel:CreatePortalButton(contentFrame, portal, yOffset)
    local portalButton = CreateFrame("Button", nil, contentFrame, "SecureActionButtonTemplate")
    portalButton:SetSize(310, 30)
    portalButton:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 0, yOffset)
    
    -- Configure secure action attributes for known spells/toys only
    if portal.isKnown then
        if portal.isToy then
            portalButton:SetAttribute("type", "toy")
            portalButton:SetAttribute("toy", portal.toyID)
        elseif portal.isVariant then
            -- Set initial attribute for Hearthstone variants
            local effectiveID = self:GetEffectiveHearthstoneID(portal)
            if effectiveID == portal.fallback then
                portalButton:SetAttribute("type", "item")
                portalButton:SetAttribute("item", effectiveID)
            else
                portalButton:SetAttribute("type", "toy")
                portalButton:SetAttribute("toy", effectiveID)
            end
        else
            portalButton:SetAttribute("type", "spell")
            portalButton:SetAttribute("spell", portal.spellID)
        end
        portalButton:RegisterForClicks("LeftButtonUp", "LeftButtonDown", "RightButtonUp")
    else
        -- Disable secure actions for unknown spells but keep mouse events for tooltips
        portalButton:SetAttribute("type", nil)
        portalButton:EnableMouse(true)
    end

    -- Background texture (transparent by default)
    local bg = portalButton:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0)
    portalButton:SetNormalTexture(bg)

    -- Hover highlight effect for known portals
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
    
    -- Desaturate icon for unknown portals
    if not portal.isKnown then
        icon:SetDesaturated(true)
        icon:SetAlpha(0.4)
    end

    -- Cooldown display frame for known portals
    if portal.isKnown then
        local cooldown = CreateFrame("Cooldown", nil, portalButton, "CooldownFrameTemplate")
        cooldown:SetAllPoints(icon)
        cooldown:SetSwipeColor(0, 0, 0, 0.8)

        -- Style cooldown text after frame creation
        C_Timer.After(0.1, function()
            for i = 1, cooldown:GetNumRegions() do
                local region = select(i, cooldown:GetRegions())
                if region and region:GetObjectType() == "FontString" then
                    region:SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE")
                end
            end
        end)
        
        -- Set initial cooldown state
        if portal.isToy then
            local startTime, duration = GetItemCooldown(portal.toyID)
            if startTime > 0 and duration > 0 then
                cooldown:SetCooldown(startTime, duration)
            end
        elseif portal.isVariant then
            local effectiveID = QuickTravel:GetEffectiveHearthstoneID(portal)
            local startTime, duration = GetItemCooldown(effectiveID)
            if startTime > 0 and duration > 0 then
                cooldown:SetCooldown(startTime, duration)
            end
        else
            local cooldownInfo = C_Spell.GetSpellCooldown(portal.spellID)
            if cooldownInfo and cooldownInfo.startTime > 0 and cooldownInfo.duration > 0 then
                cooldown:SetCooldown(cooldownInfo.startTime, cooldownInfo.duration)
            end
        end
        
        -- Store references for cooldown updates
        portalButton.cooldown = cooldown
        portalButton.spellID = portal.spellID
        portalButton.toyID = portal.toyID
        portalButton.isToy = portal.isToy
        portalButton.isVariant = portal.isVariant
        portalButton.variants = portal.variants
        portalButton.fallback = portal.fallback
    end

    -- Portal name text
    local portalText = portalButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    portalText:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    portalText:SetText(portal.displayName)
    
    -- Color text based on availability
    if portal.isKnown then
        portalText:SetTextColor(1, 1, 1)
    else
        portalText:SetTextColor(0.4, 0.4, 0.4)
    end

    -- Tooltip display on hover
    portalButton:SetScript("OnEnter", function(self)
        -- Only show tooltips if enabled in settings
        if not addon.Options.db.showSpellTooltips then
            return
        end

        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        
        if portal.isKnown then
            if portal.isToy then
                GameTooltip:SetToyByItemID(portal.toyID)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cff00ff00" .. L["CLICK_TO_USE"] .. "|r")
            elseif portal.isVariant then
                -- Generic tooltip for random variants to preserve surprise
                GameTooltip:SetText(portal.displayName, 1, 1, 1)
                GameTooltip:AddLine("|cff00ff00" .. L["CLICK_TO_USE"] .. "|r")
                if QuickTravel.db and QuickTravel.db.useRandomHearthstoneVariant then
                    GameTooltip:AddLine("|cffcccccc" .. L["RANDOM_VARIANT_TOOLTIP"] .. "|r")
                end
            else
                GameTooltip:SetSpellByID(portal.spellID)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cff00ff00" .. L["CLICK_TO_TELEPORT"] .. "|r")
            end
            
            -- Favorite status instructions
            if QuickTravel:IsFavorite(portal.instanceKey) then
                GameTooltip:AddLine("|cffff9999" .. L["RIGHT_CLICK_REMOVE_FAVORITE"] .. "|r")
            else
                GameTooltip:AddLine("|cff99ff99" .. L["RIGHT_CLICK_ADD_FAVORITE"] .. "|r")
            end
        else
            -- Tooltip for unavailable portals
            GameTooltip:SetText(portal.displayName, 0.5, 0.5, 0.5)           
            if portal.isToy or portal.isVariant then
                GameTooltip:AddLine("|cffff6666" .. L["TOY_NOT_OWNED"] .. "|r")
            else
                GameTooltip:AddLine("|cffff6666" .. L["SPELL_NOT_LEARNED"] .. "|r")
            end
        end
        
        GameTooltip:Show()
    end)

    portalButton:SetScript("OnLeave", GameTooltip_Hide)

    -- Handle button clicks for known portals
    if portal.isKnown then
        portalButton:SetScript("PostClick", function(self, button)
            if button == "RightButton" then
                -- Right-click toggles favorite status
                QuickTravel:ToggleFavorite(portal.instanceKey)
            elseif button == "LeftButton" then
                -- Update variant attribute for next click if needed
                if portal.isVariant then
                    local effectiveID = QuickTravel:GetEffectiveHearthstoneID(portal)
                    if effectiveID == portal.fallback then
                        self:SetAttribute("type", "item")
                        self:SetAttribute("item", effectiveID)
                        self:SetAttribute("toy", nil)
                    else
                        self:SetAttribute("type", "toy")
                        self:SetAttribute("toy", effectiveID)
                        self:SetAttribute("item", nil)
                    end
                end
                
                -- Update cooldown display after action
                C_Timer.After(0.1, function()
                    if self.cooldown then
                        if self.isToy and self.toyID then
                            local startTime, duration = GetItemCooldown(self.toyID)
                            if startTime > 0 and duration > 0 then
                                self.cooldown:SetCooldown(startTime, duration)
                            end
                        elseif self.isVariant then
                            local portal = {variants = self.variants, fallback = self.fallback, isVariant = true}
                            local effectiveID = QuickTravel:GetEffectiveHearthstoneID(portal)
                            local startTime, duration = GetItemCooldown(effectiveID)
                            if startTime > 0 and duration > 0 then
                                self.cooldown:SetCooldown(startTime, duration)
                            end
                        elseif self.spellID then
                            local cooldownInfo = C_Spell.GetSpellCooldown(self.spellID)
                            if cooldownInfo and cooldownInfo.startTime > 0 and cooldownInfo.duration > 0 then
                                self.cooldown:SetCooldown(cooldownInfo.startTime, cooldownInfo.duration)
                            end
                        end
                    end
                end)
                
                -- Auto-close if enabled in settings
                if addon.Options.db.autoClose then
                    C_Timer.After(0.5, function()
                        QuickTravel:HideFrame()
                        addon.Options:HideOptionsFrame()
                    end)
                end
            end
        end)
    end

    return yOffset - 30
end

-- Display the main QuickTravel frame
function QuickTravel:ShowFrame()
    if not self.mainFrame then
        self:CreateMainFrame()
    end

    self.mainFrame:Show()
    isFrameShown = true
    
    -- Refresh cooldowns when frame becomes visible
    self:UpdateCooldowns()
end

-- Hide the main QuickTravel frame
function QuickTravel:HideFrame()
    if self.mainFrame then
        self.mainFrame:Hide()
    end

    addon.Options:HideOptionsFrame()
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

-- Register slash commands for opening QuickTravel
SLASH_QUICKTRAVEL1 = "/quicktravel"
SLASH_QUICKTRAVEL2 = "/qt"

SlashCmdList["QUICKTRAVEL"] = function()
    QuickTravel:ToggleFrame()
end

-- Keybinding function for opening QuickTravel
function QuickTravel_ToggleBinding()
    QuickTravel:ToggleFrame()
end

-- Keybinding localization strings
BINDING_HEADER_QUICKTRAVEL = L["QT_TITLE"]
BINDING_NAME_QUICKTRAVEL_TOGGLE = L["TOGGLE_QUICKTRAVEL"]

-- Event handling frame for addon lifecycle and game events
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("LEARNED_SPELL_IN_TAB")

frame:SetScript("OnEvent", function(self, event, addonName, spellID)
    if event == "ADDON_LOADED" and addonName == ADDON_NAME then
        -- Initialize settings and show login message if enabled
        QuickTravel.db = addon.Options:InitializeSettings()
        C_Timer.After(1, InitializeLFGHook)

        if addon.Options.db.showLoginMessage then
            print("|cff00ff00QuickTravel|r " .. L["LOADED"])
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Ensure main frame is created when entering world
        QuickTravel:CreateMainFrame()
    elseif event == "LEARNED_SPELL_IN_TAB" then
        -- Refresh portal list when player learns new teleportation spells
        QuickTravel:RefreshPortals()
    end
end)

-- Determine which Hearthstone variant to use based on settings
function QuickTravel:GetEffectiveHearthstoneID(portal)
    if not portal.isVariant or not portal.variants then
        return portal.toyID or portal.spellID or 6948
    end
    
    local useRandom = self.db and self.db.useRandomHearthstoneVariant
    local selectedVariant = self.db and self.db.selectedHearthstoneVariant
    
    if useRandom then
        -- Select random owned variant
        local ownedVariants = {}
        for _, variantID in ipairs(portal.variants) do
            if PlayerHasToy(variantID) then
                table.insert(ownedVariants, variantID)
            end
        end
        
        if #ownedVariants > 0 then
            return ownedVariants[math.random(1, #ownedVariants)]
        end
    elseif selectedVariant and PlayerHasToy(selectedVariant) then
        -- Use specifically selected variant
        return selectedVariant
    end
    
    -- Fallback to basic Hearthstone item
    return portal.fallback
end

-- Global reference for external addon access
_G["QuickTravel"] = QuickTravel