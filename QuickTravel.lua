local ADDON_NAME, addon = ...
local QuickTravel = {}
addon.QuickTravel = QuickTravel
local L = addon.L
local constants = addon.constants
local isFrameShown = false
local ConfigManager = addon.ConfigManager


 -- Anchor QuickTravel next to Raider.io if visible, otherwise next to the Group Finder.
local function AnchorQuickTravelFrame()
    local raiderioFrame = _G["RaiderIO_ProfileTooltip"]
    if raiderioFrame and raiderioFrame:IsShown() then
        QuickTravel.mainFrame:ClearAllPoints()
        QuickTravel.mainFrame:SetPoint("TOPLEFT", raiderioFrame, "TOPRIGHT", 10, 0)
    else
        QuickTravel.mainFrame:ClearAllPoints()
        QuickTravel.mainFrame:SetPoint("TOPLEFT", PVEFrame, "TOPRIGHT", 10, 0)
    end
end

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
    self.mainFrame:HookScript("OnShow", AnchorQuickTravelFrame)
    local savedHeight = addon.Options.db and addon.Options.db.frameHeight or 500
    self.mainFrame:SetSize(320, savedHeight)
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
    self:SetupFrameResizing()
    self:PopulatePortalList()

    -- Register main frame for ESC key handling
    table.insert(UISpecialFrames, "QuickTravelFrame")
    
    self.mainFrame:Hide()

    return self.mainFrame
end

-- Create scrollable content area for the portal list
function QuickTravel:CreateScrollFrame()
    local scrollFrame = CreateFrame("ScrollFrame", nil, self.mainFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", self.mainFrame, "TOPLEFT", 12, -85)
    scrollFrame:SetPoint("BOTTOMRIGHT", self.mainFrame, "BOTTOMRIGHT", -32, 20)

    local contentFrame = CreateFrame("Frame", nil, scrollFrame)
    contentFrame:SetSize(330, 1)
    scrollFrame:SetScrollChild(contentFrame)

    self.mainFrame.scrollFrame = scrollFrame
    self.mainFrame.contentFrame = contentFrame
end

-- Setup frame resizing system with lock support
function QuickTravel:SetupFrameResizing()
    -- Enable resizing
    self.mainFrame:SetResizable(true)
    
    -- Create resize handle (bottom-right corner)
    local resizeButton = CreateFrame("Button", nil, self.mainFrame)
    resizeButton:SetSize(16, 16)
    resizeButton:SetPoint("BOTTOMRIGHT", -6, 6)
    resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    
    -- Resize cursor on hover
    resizeButton:SetScript("OnEnter", function()
        SetCursor("UI_RESIZE_CURSOR")
    end)
    
    resizeButton:SetScript("OnLeave", function()
        ResetCursor()
    end)
    
    -- Handle resize drag
    resizeButton:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            QuickTravel.mainFrame:StartSizing("BOTTOMRIGHT")
        end
    end)
    
    resizeButton:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            QuickTravel.mainFrame:StopMovingOrSizing()
            -- Save new height
            if addon.Options.db then
                addon.Options.db.frameHeight = QuickTravel.mainFrame:GetHeight()
            end
        end
    end)
    
    -- Constrain width and height limits
    self.mainFrame:SetScript("OnSizeChanged", function(frame, width, height)
        local needsUpdate = false
        
        -- Keep width constant
        if width ~= 320 then
            frame:SetWidth(320)
            needsUpdate = true
        end
        
        -- Enforce height limits (300-1000px)
        local minHeight, maxHeight = 300, 1000
        if height < minHeight then
            frame:SetHeight(minHeight)
            needsUpdate = true
        elseif height > maxHeight then
            frame:SetHeight(maxHeight)
            needsUpdate = true
        end
        
        -- Save valid height
        if not needsUpdate and addon.Options.db then
            addon.Options.db.frameHeight = height
        end
    end)
    
    -- Store reference
    self.mainFrame.resizeButton = resizeButton
    
    -- Apply initial lock state
    self:UpdateResizeState()
end

-- Toggle resize functionality based on lock setting
function QuickTravel:UpdateResizeState()
    if not self.mainFrame or not self.mainFrame.resizeButton then
        return
    end
    
    local isLocked = addon.Options.db and addon.Options.db.lockFrameHeight or false
    self.mainFrame:SetResizable(not isLocked)
    self.mainFrame.resizeButton:SetShown(not isLocked)
end

-- Create QuickTravel button in the LFG frame
function QuickTravel:CreateLFGButton()
    if self.lfgButton or not PVEFrame then
        return
    end
    
    local button = CreateFrame("Button", "QuickTravel_LFGButton", PVEFrame)
    button:SetSize(130, 38)
    
    -- Position in bottom left area
    button:SetPoint("BOTTOM", PVEFrame, "BOTTOMLEFT", 115, 20)
    
    -- Button styling with War Within atlas
    button:SetNormalAtlas("auctionhouse-nav-button")
    
    -- Create hover and pressed textures
    local highlight = button:CreateTexture(nil, "ARTWORK")
    highlight:SetSize(124, 24)
    highlight:SetPoint("CENTER", button, "CENTER", 0, 7)
    highlight:SetAtlas("auctionhouse-nav-button-highlight")
    highlight:SetAlpha(0)
    
    local pressed = button:CreateTexture(nil, "ARTWORK")
    pressed:SetSize(124, 24)
    pressed:SetPoint("CENTER", button, "CENTER", 0, 7)
    pressed:SetAtlas("auctionhouse-nav-button-select")
    pressed:SetAlpha(0)
    
    -- Track button state for hover effects
    local isPressed = false
    
    -- Hover effects
    button:SetScript("OnEnter", function(self)
        if not isPressed then
            highlight:SetAlpha(0.65)
        end
    end)
    
    button:SetScript("OnLeave", function(self)
        highlight:SetAlpha(0)
    end)
    
    -- Click effects
    button:SetScript("OnMouseDown", function(self)
        isPressed = true
        highlight:SetAlpha(0)
        pressed:SetAlpha(1)
    end)
    
    button:SetScript("OnMouseUp", function(self)
        isPressed = false
        pressed:SetAlpha(0)
        if self:IsMouseOver() then
            highlight:SetAlpha(0.65)
        end
    end)
   
    -- Button text
    local buttonText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    buttonText:SetPoint("CENTER", button, "CENTER", -2, 7)
    buttonText:SetText(L["QT_TITLE"])
    buttonText:SetTextColor(1, 0.82, 0)
    button.text = buttonText
    
    -- Button icon
    local icon = button:CreateTexture(nil, "OVERLAY")
    icon:SetSize(37, 37)
    icon:SetAtlas("Crosshair_innkeeper_48")
    icon:SetPoint("RIGHT", buttonText, "LEFT", -5, 0)
   
    -- Button click handler with toggle functionality
    button:SetScript("OnClick", function()
    if QuickTravel.mainFrame and QuickTravel.mainFrame:IsShown() then
        QuickTravel:HideFrame()
    else
        QuickTravel:ShowFrame()
        if QuickTravel.mainFrame then
            AnchorQuickTravelFrame()
        end
    end
    end)
   
    -- Tab visibility management - only show in Dungeons & Raids tab
    local function UpdateButtonVisibility()
        local currentTab = PVEFrame.selectedTab or 1
        if currentTab == 1 then
            button:Show()
        else
            button:Hide()
        end
    end
    
    -- Hook into tab clicks with delay for selectedTab to update
    for i = 1, 4 do
        local tab = _G["PVEFrameTab"..i]
        if tab then
            tab:HookScript("OnClick", function()
                C_Timer.After(0.05, UpdateButtonVisibility)
            end)
        end
    end
    
    -- Handle initial state when PVE frame opens
    PVEFrame:HookScript("OnShow", function()
        C_Timer.After(0.1, UpdateButtonVisibility)
    end)

    -- Auto-close QuickTravel when LFG window closes
    PVEFrame:HookScript("OnHide", function()
        if QuickTravel.mainFrame and QuickTravel.mainFrame:IsShown() then
            QuickTravel:HideFrame()
        end
    end)    
    
    button:Show()
    self.lfgButton = button
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
                -- Handle Hearthstone variants with random selection
                local useRandom = QuickTravel.db and QuickTravel.db.useRandomHearthstoneVariant
                local selectedVariant = QuickTravel.db and QuickTravel.db.selectedHearthstoneVariant
                
                if useRandom then
                    -- Random variant: display tooltip with random selection info
                    GameTooltip:SetText(portal.displayName, 1, 1, 1)
                    GameTooltip:AddLine("|cff00ff00" .. L["CLICK_TO_USE"] .. "|r")
                    GameTooltip:AddLine("|cffcccccc" .. L["RANDOM_VARIANT_TOOLTIP"] .. "|r")
                elseif selectedVariant then
                    -- Specific variant: display tooltip for selected variant
                    GameTooltip:SetToyByItemID(selectedVariant)
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine("|cff00ff00" .. L["CLICK_TO_USE"] .. "|r")
                else
                    -- Fallback to basic Hearthstone item
                    GameTooltip:SetItemByID(portal.fallback or 6948)
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine("|cff00ff00" .. L["CLICK_TO_USE"] .. "|r")
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
SLASH_QUICKTRAVEL3 = "/qtl"

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
        C_Timer.After(1, function()
            if PVEFrame then
                PVEFrame:HookScript("OnShow", function()
                    if addon.Options.db.showLFGTab then
                        QuickTravel:CreateLFGButton()
                    end
                end)
            end
        end)

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
        for _, variant in ipairs(portal.variants) do
            if PlayerHasToy(variant.id) then
                table.insert(ownedVariants, variant.id)
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

-- Basic LDB support
if LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true) then
    local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
    
    LDB:NewDataObject("QuickTravel", {
        type = "launcher",
        icon = "Interface\\Icons\\inv_spell_arcane_portaldornogal",
        text = L["QT_TITLE"],
        
        OnClick = function(self, button)
            if button == "LeftButton" then
                QuickTravel:ToggleFrame()
            elseif button == "RightButton" then
                addon.Options:ToggleOptionsFrame()
            end
        end,
        
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("|cff00ff00" .. L["QT_TITLE"] .. "|r")
            tooltip:AddLine("|cffffffffLeft-click:|r " .. L["TOGGLE_QUICKTRAVEL"])
            tooltip:AddLine("|cffffffffRight-click:|r " .. L["OPTIONS_TAB"])
        end,
    })
end