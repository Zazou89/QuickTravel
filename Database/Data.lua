local _, addon = ...
local L = addon.L

-- Expansion display order configuration
-- This array defines the order in which expansions appear in the UI
local orderedExpansions = {
    L["Current Season"],
    L["Hearthstones"],
    L["Cataclysm"],
    L["Mists of Pandaria"],
    L["Warlords of Draenor"],
    L["Legion"],
    L["Battle for Azeroth"],
    L["Shadowlands"],
    L["Dragonflight"],
    L["War Within"]
}

-- Hearthstone variants list
local hearthstoneVariants = {
    166747, 165802, 165670, 165669, 166746, 163045, 162973, 142542,
    64488, 54452, 93672, 168907, 172179, 182773, 180290, 184353,
    183716, 188952, 190237, 193588, 190196, 200630, 206195, 209035,
    208704, 212337, 228940, 236687, 235016
}

-- Preparation for the next season
-- This array will be used for the Patch 11.2
-- [L["Current Season"]] = {"ara_kara", "the_dawnbreaker", "operation_floodgate", "priory_sacred_flame", "halls_atonement", "tazavesh", "eco_dome_al_dani", "manaforge_omega"},


-- Mapping of expansion names to their instance keys
-- Each expansion contains an array of instance keys that belong to it
local mapExpansionToKeys = {
    [L["Current Season"]] = {"mechagon", "theatre_pain", "rookery", "darkflame_cleft", "cinderbrew_brewery", "priory_sacred_flame", "siege_boralus", "motherlode", "liberation_undermine"},
    [L["Hearthstones"]] = {"hearthstone_dalaran", "hearthstone_garrison", "hearthstone_variant"},
    [L["Cataclysm"]] = {"vortex_pinnacle", "throne_tides", "grim_batol"},
    [L["Mists of Pandaria"]] = {"temple_jade_serpent", "siege_niuzao", "scholomance", "scarlet_monastery", "scarlet_halls", "gate_setting_sun", "mogushan_palace", "shado_pan_monastery", "stormstout_brewery"},
    [L["Warlords of Draenor"]] = {"shadowmoon_burial", "everbloom", "bloodmaul_slag", "auchindoun", "skyreach", "upper_blackrock", "grimrail_depot", "iron_docks"},
    [L["Legion"]] = {"darkheart_thicket", "black_rook_hold", "halls_valor", "neltharions_lair", "court_stars", "karazhan"},
    [L["Battle for Azeroth"]] = {"ataldazar", "freehold", "waycrest_manor", "underrot", "mechagon", "siege_boralus", "motherlode"},
    [L["Shadowlands"]] = {"necrotic_wake", "plaguefall", "mists_tirna_scithe", "halls_atonement", "spires_ascension", "theatre_pain", "de_other_side", "sanguine_depths", "tazavesh", "castle_nathria", "sanctum_domination", "sepulcher_first_ones"},
    [L["Dragonflight"]] = {"ruby_life_pools", "nokhud_offensive", "azure_vault", "algethar_academy", "uldaman", "neltharus", "brackenhide_hollow", "halls_infusion", "dawn_infinite", "vault_incarnates", "aberrus", "amirdrassil"},
    [L["War Within"]] = {"city_threads", "ara_kara", "stonevault", "dawnbreaker", "rookery", "darkflame_cleft", "cinderbrew_brewery", "priory_sacred_flame", "operation_floodgate", "liberation_undermine"}
}

-- Unified instance database mapping instance keys to their spell data
-- Each entry contains the spell ID for teleportation and localization key for the name
local instanceDatabase = {
    -- Hearthstones (toys)
    ["hearthstone_dalaran"] = {toyID = 140192},
    ["hearthstone_garrison"] = {toyID = 110560},
    ["hearthstone_variant"] = {variants = hearthstoneVariants, fallback = 6948},

    -- Cataclysm Dungeons
    ["vortex_pinnacle"] = {spellID = 410080, nameKey = "DUNGEON_VORTEX_PINNACLE"},
    ["throne_tides"] = {spellID = 424142, nameKey = "DUNGEON_THRONE_OF_THE_TIDES"},
    ["grim_batol"] = {spellID = 445424, nameKey = "DUNGEON_GRIM_BATOL"},

    -- Mists of Pandaria Dungeons
    ["temple_jade_serpent"] = {spellID = 131204, nameKey = "DUNGEON_TEMPLE_OF_THE_JADE_SERPENT"},
    ["siege_niuzao"] = {spellID = 131228, nameKey = "DUNGEON_SIEGE_OF_NIUZAO"},
    ["scholomance"] = {spellID = 131232, nameKey = "DUNGEON_SCHOLOMANCE"},
    ["scarlet_monastery"] = {spellID = 131229, nameKey = "DUNGEON_SCARLET_MONASTERY"},
    ["scarlet_halls"] = {spellID = 131231, nameKey = "DUNGEON_SCARLET_HALLS"},
    ["gate_setting_sun"] = {spellID = 131225, nameKey = "DUNGEON_GATE_OF_THE_SETTING_SUN"},
    ["mogushan_palace"] = {spellID = 131222, nameKey = "DUNGEON_MOGUSHAN_PALACE"},
    ["shado_pan_monastery"] = {spellID = 131206, nameKey = "DUNGEON_SHADO_PAN_MONASTERY"},
    ["stormstout_brewery"] = {spellID = 131205, nameKey = "DUNGEON_STORMSTOUT_BREWERY"},
    
    -- Warlords of Draenor Dungeons
    ["shadowmoon_burial"] = {spellID = 159899, nameKey = "DUNGEON_SHADOWMOON_BURIAL_GROUNDS"},
    ["everbloom"] = {spellID = 159901, nameKey = "DUNGEON_EVERBLOOM"},
    ["bloodmaul_slag"] = {spellID = 159895, nameKey = "DUNGEON_BLOODMAUL_SLAG_MINES"},
    ["auchindoun"] = {spellID = 159897, nameKey = "DUNGEON_AUCHINDOUN"},
    ["skyreach"] = {spellID = 159898, nameKey = "DUNGEON_SKYREACH"},
    ["upper_blackrock"] = {spellID = 159902, nameKey = "DUNGEON_UPPER_BLACKROCK_SPIRE"},
    ["grimrail_depot"] = {spellID = 159900, nameKey = "DUNGEON_GRIMRAIL_DEPOT"},
    ["iron_docks"] = {spellID = 159896, nameKey = "DUNGEON_IRON_DOCKS"},
    
    -- Legion Dungeons
    ["darkheart_thicket"] = {spellID = 424163, nameKey = "DUNGEON_DARKHEART_THICKET"},
    ["black_rook_hold"] = {spellID = 424153, nameKey = "DUNGEON_BLACK_ROOK_HOLD"},
    ["halls_valor"] = {spellID = 393764, nameKey = "DUNGEON_HALLS_OF_VALOR"},
    ["neltharions_lair"] = {spellID = 410078, nameKey = "DUNGEON_NELTHARIONS_LAIR"},
    ["court_stars"] = {spellID = 393766, nameKey = "DUNGEON_COURT_OF_STARS"},
    ["karazhan"] = {spellID = 373262, nameKey = "DUNGEON_KARAZHAN"},
    
    -- Battle for Azeroth Dungeons
    ["ataldazar"] = {spellID = 424187, nameKey = "DUNGEON_ATALDAZAR"},
    ["freehold"] = {spellID = 410071, nameKey = "DUNGEON_FREEHOLD"},
    ["waycrest_manor"] = {spellID = 424167, nameKey = "DUNGEON_WAYCREST_MANOR"},
    ["underrot"] = {spellID = 410074, nameKey = "DUNGEON_THE_UNDERROT"},
    ["mechagon"] = {spellID = 373274, nameKey = "DUNGEON_MECHAGON"},
    ["siege_boralus"] = { alliance = 445418, horde = 464256, nameKey = "DUNGEON_SIEGE_OF_BORALUS"}, -- Factiopn-specific spells
    ["motherlode"] = { alliance = 467553, horde = 467555, nameKey = "DUNGEON_THE_MOTHERLOAD"}, -- Factiopn-specific spells
    
    -- Shadowlands Dungeons and Raids
    ["necrotic_wake"] = {spellID = 354462, nameKey = "DUNGEON_THE_NECROTIC_WAKE"},
    ["plaguefall"] = {spellID = 354463, nameKey = "DUNGEON_PLAGUEFALL"},
    ["mists_tirna_scithe"] = {spellID = 354464, nameKey = "DUNGEON_MISTS_OF_TIRNA_SCITHE"},
    ["halls_atonement"] = {spellID = 354465, nameKey = "DUNGEON_HALLS_OF_ATONEMENT"},
    ["spires_ascension"] = {spellID = 354466, nameKey = "DUNGEON_SPIRES_OF_ASCENSION"},
    ["theatre_pain"] = {spellID = 354467, nameKey = "DUNGEON_THEATRE_OF_PAIN"},
    ["de_other_side"] = {spellID = 354468, nameKey = "DUNGEON_DE_OTHER_SIDE"},
    ["sanguine_depths"] = {spellID = 354469, nameKey = "DUNGEON_SANGUINE_DEPTHS"},
    ["tazavesh"] = {spellID = 367416, nameKey = "DUNGEON_TAZAVESH_THE_VEILED_MARKET"},
    ["castle_nathria"] = {spellID = 373190, nameKey = "RAID_CASTLE_NATHRIA"},
    ["sanctum_domination"] = {spellID = 373191, nameKey = "RAID_SANCTUM_OF_DOMINATION"},
    ["sepulcher_first_ones"] = {spellID = 373192, nameKey = "RAID_SEPULCHER_OF_THE_FIRST_ONES"},
    
    -- Dragonflight Dungeons and Raids
    ["ruby_life_pools"] = {spellID = 393256, nameKey = "DUNGEON_RUBY_LIFE_POOLS"},
    ["nokhud_offensive"] = {spellID = 393262, nameKey = "DUNGEON_NOKHUD_OFFENSIVE"},
    ["azure_vault"] = {spellID = 393279, nameKey = "DUNGEON_AZURE_VAULT"},
    ["algethar_academy"] = {spellID = 393273, nameKey = "DUNGEON_ALGETHAR_ACADEMY"},
    ["uldaman"] = {spellID = 393222, nameKey = "DUNGEON_ULDAMAN"},
    ["neltharus"] = {spellID = 393276, nameKey = "DUNGEON_NELTHARUS"},
    ["brackenhide_hollow"] = {spellID = 393267, nameKey = "DUNGEON_BRACKENHIDE_HOLLOW"},
    ["halls_infusion"] = {spellID = 393283, nameKey = "DUNGEON_HALLS_OF_INFUSION"},
    ["dawn_infinite"] = {spellID = 424197, nameKey = "DUNGEON_DAWN_OF_THE_INFINITE"},
    ["vault_incarnates"] = {spellID = 432254, nameKey = "RAID_VAULT_OF_THE_INCARNATES"},
    ["aberrus"] = {spellID = 432257, nameKey = "RAID_ABBERUS_THE_SHADOWED_CRUCIBLE"},
    ["amirdrassil"] = {spellID = 432258, nameKey = "RAID_AMIRDRASSIL_THE_DREAMS_HOPE"},
    
    -- War Within Dungeons and Raids
    ["city_threads"] = {spellID = 445416, nameKey = "DUNGEON_CITY_OF_THREADS"},
    ["ara_kara"] = {spellID = 445417, nameKey = "DUNGEON_ARA_KARA_CITY_OF_ECHOS"},
    ["stonevault"] = {spellID = 445269, nameKey = "DUNGEON_STONEVAULT"},
    ["dawnbreaker"] = {spellID = 445414, nameKey = "DUNGEON_DAWNBREAKER"},
    ["rookery"] = {spellID = 445443, nameKey = "DUNGEON_THE_ROOKERY"},
    ["darkflame_cleft"] = {spellID = 445441, nameKey = "DUNGEON_DARKFLAME_CLEFT"},
    ["cinderbrew_meadery"] = {spellID = 445440, nameKey = "DUNGEON_CINDERBREW_MEADERY"},
    ["priory_sacred_flame"] = {spellID = 445444, nameKey = "DUNGEON_PRIORY_OF_THE_SACRED_FLAME"},
    ["operation_floodgate"] = {spellID = 1216786, nameKey = "DUNGEON_OPERATION_FLOODGATE"},
    --["eco_dome_al_dani"] = {spellID = 1237215, nameKey = "DUNGEON_ECO_DOME_AL_DANI"},    
    ["liberation_undermine"] = {spellID = 1226482, nameKey = "RAID_LIBERATION_OF_UNDERMINE"}
    --["manaforge_omega"] = {spellID = 1239155, nameKey = "RAID_MANAFORGE_OMEGA"}
}

-- Modern data manager with intelligent caching system
local DataManager = {
    -- Cache configuration
    _cache = {
        availablePortals = nil,
        lastScan = 0,
        cacheTimeout = 120 -- Cache timeout in seconds
    },
    
    -- Retrieve instance information by key with faction support
    -- @param instanceKey: string - The unique key for the instance
    -- @return table|nil - Instance data or nil if not found
    GetInstanceInfo = function(self, instanceKey)
        local instanceData = instanceDatabase[instanceKey]
        if not instanceData then
            return nil
        end

        if instanceData.toyID then
            return {
                toyID = instanceData.toyID,
                nameKey = instanceData.toyID
            }
        elseif instanceData.variants then
            return {
                variants = instanceData.variants,
                fallback = instanceData.fallback,
                nameKey = "hearthstone_variant"
            }
        end  
        
        -- Handle faction-specific spells
        if instanceData.alliance or instanceData.horde then
            local playerFaction = UnitFactionGroup("player")
            local spellID
            
            if playerFaction == "Alliance" and instanceData.alliance then
                spellID = instanceData.alliance
            elseif playerFaction == "Horde" and instanceData.horde then
                spellID = instanceData.horde
            else
                -- Fallback if faction is unknown or not applicable
                spellID = instanceData.alliance or instanceData.horde
            end
            
            return {
                spellID = spellID,
                nameKey = instanceData.nameKey
            }
        end
        
        -- Return instance data
        return instanceData
    end,
    
    -- Scan for available portals with intelligent caching
    -- @param forceRefresh: boolean - Force cache invalidation and rescan
    -- @return table - Array of available portal data
    GetAvailablePortals = function(self, forceRefresh)
        local now = GetTime()
        
        -- Return cached data if valid and not forcing refresh
        if not forceRefresh and self._cache.availablePortals and 
        (now - self._cache.lastScan < self._cache.cacheTimeout) then
            return self._cache.availablePortals
        end
        
        local portals = {}
        local showUnlearned = addon.QuickTravel.db and addon.QuickTravel.db.showUnlearnedSpells or false
        local showHearthstones = addon.QuickTravel.db and addon.QuickTravel.db.showHearthstones or false
        
        -- Scan through all expansions and their instances
        for _, expansion in ipairs(orderedExpansions) do
            -- Skip Hearthstones if option is disabled
            if expansion == L["Hearthstones"] and not showHearthstones then
                -- Skip this expansion
            else            
            local instanceKeys = mapExpansionToKeys[expansion]
            if instanceKeys then
                for _, instanceKey in ipairs(instanceKeys) do
                    local instanceInfo = self:GetInstanceInfo(instanceKey)
                    
                    -- Include instances with valid spell IDs
                    if instanceInfo then
                        local isKnown = false
                        local displayTexture = 134400
                        local displayName = ""
                        
                        -- Handle toys
                        if instanceInfo.toyID then
                            isKnown = PlayerHasToy(instanceInfo.toyID)
                            displayTexture = C_Item.GetItemIconByID(instanceInfo.toyID) or 134400
                            displayName = C_Item.GetItemNameByID(instanceInfo.toyID) or ("Toy " .. instanceInfo.toyID)
                        elseif instanceInfo.variants then
                            local useRandom = addon.QuickTravel.db and addon.QuickTravel.db.useRandomHearthstoneVariant
                            local selectedVariant = addon.QuickTravel.db and addon.QuickTravel.db.selectedHearthstoneVariant
                            
                            -- Check if any variant is owned
                            local hasVariants = false
                            for _, variantID in ipairs(instanceInfo.variants) do
                                if PlayerHasToy(variantID) then
                                    hasVariants = true
                                    break
                                end
                            end
                            
                            isKnown = hasVariants or GetItemCount(instanceInfo.fallback) > 0
                            
                            if useRandom then
                                displayName = L["HEARTHSTONE_RANDOM_VARIANT"]
                                displayTexture = C_Item.GetItemIconByID(instanceInfo.fallback) or 134400
                            elseif selectedVariant and PlayerHasToy(selectedVariant) then
                                displayName = C_Item.GetItemNameByID(selectedVariant) or L["HEARTHSTONE_RANDOM_VARIANT"]
                                displayTexture = C_Item.GetItemIconByID(selectedVariant) or C_Item.GetItemIconByID(instanceInfo.fallback) or 134400
                            else
                                displayName = C_Item.GetItemNameByID(instanceInfo.fallback) or "Hearthstone"
                                displayTexture = C_Item.GetItemIconByID(instanceInfo.fallback) or 134400
                            end
                        -- Handle spells
                        elseif instanceInfo.spellID and instanceInfo.spellID > 0 then
                            isKnown = IsSpellKnown(instanceInfo.spellID)
                            displayTexture = C_Spell.GetSpellTexture(instanceInfo.spellID) or 134400
                            displayName = L[instanceInfo.nameKey]
                        end
                        
                        -- Include if item is known, or if showing unlearned items
                        if (isKnown or showUnlearned) and (instanceInfo.toyID or instanceInfo.spellID or instanceInfo.variants) then
                            table.insert(portals, {
                                instanceKey = instanceKey,
                                spellID = instanceInfo.spellID,
                                toyID = instanceInfo.toyID,
                                variants = instanceInfo.variants,
                                fallback = instanceInfo.fallback,
                                displayName = displayName,
                                expansion = expansion,
                                texture = displayTexture,
                                isKnown = isKnown,
                                isToy = instanceInfo.toyID ~= nil,
                                isVariant = instanceInfo.variants ~= nil
                            })
                        end
                    end
                end
            end
        end
    end
        
        -- Update cache
        self._cache.availablePortals = portals
        self._cache.lastScan = now
        return portals
    end,
    
    -- Organize portals by expansion for UI display
    -- @param portals: table - Array of portal data
    -- @return table, table - Organized portals by expansion and expansion order
    OrganizeByExpansion = function(self, portals)
        local organized = {}
        
        -- Initialize empty tables for each expansion
        for _, expansion in ipairs(orderedExpansions) do
            organized[expansion] = {}
        end
        
        -- Group portals by their expansion
        for _, portal in ipairs(portals) do
            table.insert(organized[portal.expansion], portal)
        end
        
        return organized, orderedExpansions
    end,
    
    -- Invalidate cache to force fresh data on next request
    -- Useful when new spells are learned or game state changes
    InvalidateCache = function(self)
        self._cache.availablePortals = nil
        self._cache.lastScan = 0
    end
}

-- Export constants and data manager for use by other addon modules
local constants = {
    orderedExpansions = orderedExpansions,
    mapExpansionToKeys = mapExpansionToKeys,
    instanceDatabase = instanceDatabase,
    hearthstoneVariants = hearthstoneVariants,
    DataManager = DataManager
}

addon.constants = constants