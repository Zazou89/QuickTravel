local _, addon = ...
local L = addon.L

-- Display order for expansions in the UI - controls the sequence in which categories appear
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
    L["The War Within"],
    L["Wormhole Generator"],
    L["Mage Teleport"],
    L["Mage Portal"]
}

-- Complete list of all available Hearthstone variant toy IDs
local hearthstoneVariants = {
    {id = 54452, nameKey = "HEARTHSTONE_VARIANT_54452"},
    {id = 64488, nameKey = "HEARTHSTONE_VARIANT_64488"},
    {id = 93672, nameKey = "HEARTHSTONE_VARIANT_93672"},
    {id = 142542, nameKey = "HEARTHSTONE_VARIANT_142542"},
    {id = 162973, nameKey = "HEARTHSTONE_VARIANT_162973"},
    {id = 163045, nameKey = "HEARTHSTONE_VARIANT_163045"},
    {id = 165669, nameKey = "HEARTHSTONE_VARIANT_165669"},
    {id = 165670, nameKey = "HEARTHSTONE_VARIANT_165670"},
    {id = 165802, nameKey = "HEARTHSTONE_VARIANT_165802"},
    {id = 166746, nameKey = "HEARTHSTONE_VARIANT_166746"},
    {id = 166747, nameKey = "HEARTHSTONE_VARIANT_166747"},
    {id = 168907, nameKey = "HEARTHSTONE_VARIANT_168907"},
    {id = 172179, nameKey = "HEARTHSTONE_VARIANT_172179"},
    {id = 180290, nameKey = "HEARTHSTONE_VARIANT_180290"},
    {id = 182773, nameKey = "HEARTHSTONE_VARIANT_182773"},
    {id = 183716, nameKey = "HEARTHSTONE_VARIANT_183716"},
    {id = 184353, nameKey = "HEARTHSTONE_VARIANT_184353"},
    {id = 188952, nameKey = "HEARTHSTONE_VARIANT_188952"},
    {id = 190196, nameKey = "HEARTHSTONE_VARIANT_190196"},
    {id = 190237, nameKey = "HEARTHSTONE_VARIANT_190237"},
    {id = 193588, nameKey = "HEARTHSTONE_VARIANT_193588"},
    {id = 200630, nameKey = "HEARTHSTONE_VARIANT_200630"},
    {id = 206195, nameKey = "HEARTHSTONE_VARIANT_206195"},
    {id = 208704, nameKey = "HEARTHSTONE_VARIANT_208704"},
    {id = 209035, nameKey = "HEARTHSTONE_VARIANT_209035"},
    {id = 212337, nameKey = "HEARTHSTONE_VARIANT_212337"},
    {id = 228940, nameKey = "HEARTHSTONE_VARIANT_228940"},
    {id = 235016, nameKey = "HEARTHSTONE_VARIANT_235016"},
    {id = 236687, nameKey = "HEARTHSTONE_VARIANT_236687"},
    {id = 245970, nameKey = "HEARTHSTONE_VARIANT_245970"},
    {id = 246565, nameKey = "HEARTHSTONE_VARIANT_246565"},
    {id = 210455, nameKey = "HEARTHSTONE_VARIANT_210455"}
}

-- Category-to-instance mapping: defines which dungeons/raids belong to each expansion category
local mapCategoryKeysToInstances = {
    ["current_season"] = {"ara_kara", "the_dawnbreaker", "operation_floodgate", "priory_sacred_flame", "halls_atonement", "tazavesh", "eco_dome_al_dani", "manaforge_omega"}, --TWW: Season 3
    --["current_season"] = {"mechagon", "theatre_pain", "rookery", "darkflame_cleft", "cinderbrew_meadery", "priory_sacred_flame", "siege_boralus", "motherlode", "liberation_undermine"}, --TWW: Season 2
    ["hearthstones"] = {"hearthstone_variant", "hearthstone_dalaran", "hearthstone_garrison"},
    ["cataclysm"] = {"vortex_pinnacle", "throne_tides", "grim_batol"},
    ["mists_of_pandaria"] = {"temple_jade_serpent", "siege_niuzao", "scholomance", "scarlet_monastery", "scarlet_halls", "gate_setting_sun", "mogushan_palace", "shado_pan_monastery", "stormstout_brewery"},
    ["warlords_of_draenor"] = {"shadowmoon_burial", "everbloom", "bloodmaul_slag", "auchindoun", "skyreach", "upper_blackrock", "grimrail_depot", "iron_docks"},
    ["legion"] = {"darkheart_thicket", "black_rook_hold", "halls_valor", "neltharions_lair", "court_stars", "karazhan"},
    ["battle_for_azeroth"] = {"ataldazar", "freehold", "waycrest_manor", "underrot", "mechagon", "siege_boralus", "motherlode"},
    ["shadowlands"] = {"necrotic_wake", "plaguefall", "mists_tirna_scithe", "halls_atonement", "spires_ascension", "theatre_pain", "de_other_side", "sanguine_depths", "tazavesh", "castle_nathria", "sanctum_domination", "sepulcher_first_ones"},
    ["dragonflight"] = {"ruby_life_pools", "nokhud_offensive", "azure_vault", "algethar_academy", "uldaman", "neltharus", "brackenhide_hollow", "halls_infusion", "dawn_infinite", "vault_incarnates", "aberrus", "amirdrassil"},
    ["the_war_within"] = {"city_threads", "ara_kara", "stonevault", "dawnbreaker", "rookery", "darkflame_cleft", "cinderbrew_meadery", "priory_sacred_flame", "operation_floodgate", "liberation_undermine"},
    ["wormhole_generator"] = {"ultrasafe_transporter_gadgetzan", "ultrasafe_transporter_toshleys_station", "wormhole_generator_northrend", "wormhole_generator_pandaria", "wormhole_generator_argus", "wormhole_generator_zandalar", "wormhole_generator_kul_tiras", "wormhole_generator_shadowlands", "wormhole_generator_dragon_isles", "wormhole_generator_khaz_algar"},
    ["mage_teleport"] = {"mage_teleport_hall_of_the_guardian","mage_teleport_stormwind","mage_teleport_ironforge","mage_teleport_darnassus","mage_teleport_exodar","mage_teleport_theramore","mage_teleport_orgrimmar","mage_teleport_undercity","mage_teleport_thunder_bluff","mage_teleport_silvermoon_city","mage_teleport_stonard","mage_teleport_shattrath","mage_teleport_dalaran","mage_teleport_tol_barad","mage_teleport_vale_of_eternal_blossoms","mage_teleport_stormshield","mage_teleport_warspear","mage_teleport_dalaran_broken_isles","mage_teleport_boralus","mage_teleport_dazar_alor","mage_teleport_oribos","mage_teleport_valdrakken","mage_teleport_dornogal"},
    ["mage_portal"] = {"mage_portal_stormwind", "mage_portal_ironforge", "mage_portal_darnassus", "mage_portal_exodar", "mage_portal_theramore", "mage_portal_orgrimmar", "mage_portal_undercity", "mage_portal_thunder_bluff", "mage_portal_silvermoon_city", "mage_portal_stonard", "mage_portal_shattrath", "mage_portal_dalaran", "mage_portal_tol_barad", "mage_portal_vale_of_eternal_blossoms", "mage_portal_stormshield", "mage_portal_warspear", "mage_portal_dalaran_broken_isles", "mage_portal_boralus", "mage_portal_dazar_alor", "mage_portal_oribos", "mage_portal_valdrakken", "mage_portal_dornogal"}
}

-- Master database: maps instance keys to their teleportation data (spell IDs, toy IDs, localization keys)
local instanceDatabase = {
    -- Hearthstone items and variants
    ["hearthstone_dalaran"] = {toyID = 140192, nameKey = "HEARTHSTONE_DALARAN"},
    ["hearthstone_garrison"] = {toyID = 110560, nameKey = "HEARTHSTONE_GARRISON"},
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
    
    -- Battle for Azeroth Dungeons with faction-specific handling
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
    
    -- The War Within Dungeons and Raids
    ["city_threads"] = {spellID = 445416, nameKey = "DUNGEON_CITY_OF_THREADS"},
    ["ara_kara"] = {spellID = 445417, nameKey = "DUNGEON_ARA_KARA_CITY_OF_ECHOS"},
    ["stonevault"] = {spellID = 445269, nameKey = "DUNGEON_STONEVAULT"},
    ["the_dawnbreaker"] = {spellID = 445414, nameKey = "DUNGEON_DAWNBREAKER"},
    ["rookery"] = {spellID = 445443, nameKey = "DUNGEON_THE_ROOKERY"},
    ["darkflame_cleft"] = {spellID = 445441, nameKey = "DUNGEON_DARKFLAME_CLEFT"},
    ["cinderbrew_meadery"] = {spellID = 445440, nameKey = "DUNGEON_CINDERBREW_MEADERY"},
    ["priory_sacred_flame"] = {spellID = 445444, nameKey = "DUNGEON_PRIORY_OF_THE_SACRED_FLAME"},
    ["operation_floodgate"] = {spellID = 1216786, nameKey = "DUNGEON_OPERATION_FLOODGATE"},
    ["eco_dome_al_dani"] = {spellID = 1237215, nameKey = "DUNGEON_ECO_DOME_AL_DANI"},    
    ["liberation_undermine"] = {spellID = 1226482, nameKey = "RAID_LIBERATION_OF_UNDERMINE"},
    ["manaforge_omega"] = {spellID = 1239155, nameKey = "RAID_MANAFORGE_OMEGA"},

    -- Wormhole Generator
    ["ultrasafe_transporter_gadgetzan"] = {toyID = 18986, nameKey = "ULTRASAFE_TRANSPORTER_GADGETZAN"},
    ["ultrasafe_transporter_toshleys_station"] = {toyID = 30544, nameKey = "ULTRASAFE_TRANSPORTER_TOSHLEYS_STATION"},
    ["wormhole_generator_northrend"] = {toyID = 48933, nameKey = "WORMHOLE_GENERATOR_NORTHREND"},
    ["wormhole_generator_pandaria"] = {toyID = 87215, nameKey = "WORMHOLE_GENERATOR_PANDARIA"},
    ["wormhole_generator_argus"] = {toyID = 151652, nameKey = "WORMHOLE_GENERATOR_ARGUS"},
    ["wormhole_generator_zandalar"] = {toyID = 168808, nameKey = "WORMHOLE_GENERATOR_ZANDALAR"},
    ["wormhole_generator_kul_tiras"] = {toyID = 168807, nameKey = "WORMHOLE_GENERATOR_KUL_TIRAS"},
    ["wormhole_generator_shadowlands"] = {toyID = 172924, nameKey = "WORMHOLE_GENERATOR_SHADOWLANDS"},
    ["wormhole_generator_dragon_isles"] = {toyID = 198156, nameKey = "WORMHOLE_GENERATOR_DRAGON_ISLES"},
    ["wormhole_generator_khaz_algar"] = {toyID = 221966, nameKey = "WORMHOLE_GENERATOR_KHAZ_ALGAR"},

    -- Mage teleport
    ["mage_teleport_hall_of_the_guardian"] = {spellID = 193759, nameKey = "MAGE_TELEPORT_HALL_OF_THE_GUARDIAN"},

    ["mage_teleport_stormwind"] = {alliance = 3561, nameKey = "MAGE_TELEPORT_STORMWIND"},
    ["mage_teleport_ironforge"] = {alliance = 3562, nameKey = "MAGE_TELEPORT_IRONFORGE"},
    ["mage_teleport_darnassus"] = {alliance = 3565, nameKey = "MAGE_TELEPORT_DARNASSUS"},
    ["mage_teleport_exodar"] = {alliance = 32271, nameKey = "MAGE_TELEPORT_EXODAR"},
    ["mage_teleport_theramore"] = {alliance = 49359, nameKey = "MAGE_TELEPORT_THERAMORE"},

    ["mage_teleport_orgrimmar"] = {horde = 3567, nameKey = "MAGE_TELEPORT_ORGRIMMAR"},
    ["mage_teleport_undercity"] = {horde = 3563, nameKey = "MAGE_TELEPORT_UNDERCITY"},
    ["mage_teleport_thunder_bluff"] = {horde = 3566, nameKey = "MAGE_TELEPORT_THUNDER_BLUFF"},
    ["mage_teleport_silvermoon_city"] = {horde = 32272, nameKey = "MAGE_TELEPORT_SILVERMOON_CITY"},
    ["mage_teleport_stonard"] = {horde = 49358, nameKey = "MAGE_TELEPORT_STONARD"},

    ["mage_teleport_shattrath"] = {alliance = 33690, horde = 35715, nameKey = "MAGE_TELEPORT_SHATTRATH"},
    ["mage_teleport_dalaran"] = {spellID = 53140, nameKey = "MAGE_TELEPORT_DALARAN"},
    ["mage_teleport_tol_barad"] = {alliance = 88342, horde = 88344, nameKey = "MAGE_TELEPORT_TOL_BARAD"},
    ["mage_teleport_vale_of_eternal_blossoms"] = {alliance = 132621, horde = 132627, nameKey = "MAGE_TELEPORT_VALE_OF_ETERNAL_BLOSSOMS"},

    ["mage_teleport_stormshield"] = {alliance = 176248, nameKey = "MAGE_TELEPORT_STORMSHIELD"},
    ["mage_teleport_warspear"] = {horde = 176242, nameKey = "MAGE_TELEPORT_WARSPEAR"},

    ["mage_teleport_dalaran_broken_isles"] = {spellID = 224869, nameKey = "MAGE_TELEPORT_DALARAN_BROKEN_ISLES"},

    ["mage_teleport_boralus"] = {alliance = 281403, nameKey = "MAGE_TELEPORT_BORALUS"},
    ["mage_teleport_dazar_alor"] = {horde = 281404, nameKey = "MAGE_TELEPORT_DAZAR_ALOR"},

    ["mage_teleport_oribos"] = {spellID = 344587, nameKey = "MAGE_TELEPORT_ORIBOS"},
    ["mage_teleport_valdrakken"] = {spellID = 395277, nameKey = "MAGE_TELEPORT_VALDRAKKEN"},
    ["mage_teleport_dornogal"] = {spellID = 446540, nameKey = "MAGE_TELEPORT_DORNOGAL"},
    
    -- Mage portal
    ["mage_portal_stormwind"] = {alliance = 10059, nameKey = "MAGE_PORTAL_STORMWIND"},
    ["mage_portal_ironforge"] = {alliance = 11416, nameKey = "MAGE_PORTAL_IRONFORGE"},
    ["mage_portal_darnassus"] = {alliance = 11419, nameKey = "MAGE_PORTAL_DARNASSUS"},
    ["mage_portal_exodar"] = {alliance = 32266, nameKey = "MAGE_PORTAL_EXODAR"},
    ["mage_portal_theramore"] = {alliance = 49360, nameKey = "MAGE_PORTAL_THERAMORE"},

    ["mage_portal_orgrimmar"] = {horde = 11417, nameKey = "MAGE_PORTAL_ORGRIMMAR"},
    ["mage_portal_undercity"] = {horde = 11418, nameKey = "MAGE_PORTAL_UNDERCITY"},
    ["mage_portal_thunder_bluff"] = {horde = 11420, nameKey = "MAGE_PORTAL_THUNDER_BLUFF"},
    ["mage_portal_silvermoon_city"] = {horde = 32267, nameKey = "MAGE_PORTAL_SILVERMOON_CITY"},
    ["mage_portal_stonard"] = {horde = 49361, nameKey = "MAGE_PORTAL_STONARD"},

    ["mage_portal_shattrath"] = {alliance = 33691, horde = 35717, nameKey = "MAGE_PORTAL_SHATTRATH"},
    ["mage_portal_dalaran"] = {spellID = 53142, nameKey = "MAGE_PORTAL_DALARAN"},
    ["mage_portal_tol_barad"] = {alliance = 88345, horde = 88346, nameKey = "MAGE_PORTAL_TOL_BARAD"},
    ["mage_portal_vale_of_eternal_blossoms"] = {alliance = 132620, horde = 132626, nameKey = "MAGE_PORTAL_VALE_OF_ETERNAL_BLOSSOMS"},

    ["mage_portal_stormshield"] = {alliance = 176246, nameKey = "MAGE_PORTAL_STORMSHIELD"},
    ["mage_portal_warspear"] = {horde = 176244, nameKey = "MAGE_PORTAL_WARSPAR"},

    ["mage_portal_dalaran_broken_isles"] = {spellID = 224871, nameKey = "MAGE_PORTAL_DALARAN_BROKEN_ISLES"},

    ["mage_portal_boralus"] = {alliance = 281400, nameKey = "MAGE_PORTAL_BORALUS"},
    ["mage_portal_dazar_alor"] = {horde = 281402, nameKey = "MAGE_PORTAL_DAZAR_ALOR"},

    ["mage_portal_oribos"] = {spellID = 344597, nameKey = "MAGE_PORTAL_ORIBOS"},
    ["mage_portal_valdrakken"] = {spellID = 395289, nameKey = "MAGE_PORTAL_VALDRAKKEN"},
    ["mage_portal_dornogal"] = {spellID = 446534, nameKey = "MAGE_PORTAL_DORNOGAL"},
}

-- Advanced data manager with intelligent caching and portal organization
local DataManager = {
    -- Cache configuration to minimize API calls and improve performance
    _cache = {
        availablePortals = nil,
        lastScan = 0,
        cacheTimeout = 120 -- Cache valid for 2 minutes
    },
    
    -- Retrieve complete instance information by key with faction-specific spell support
    GetInstanceInfo = function(self, instanceKey)
        local instanceData = instanceDatabase[instanceKey]
        if not instanceData then
            return nil
        end

        -- Handle toy items (Hearthstones, special items)
        if instanceData.toyID then
            return {
                toyID = instanceData.toyID,
                nameKey = instanceData.nameKey or instanceData.toyID
            }
        -- Handle Hearthstone variants with fallback support
        elseif instanceData.variants then
            return {
                variants = instanceData.variants,
                fallback = instanceData.fallback,
                nameKey = "hearthstone_variant"
            }
        end  
        
        -- Handle faction-specific spells (Alliance/Horde different spell IDs)
        if instanceData.alliance or instanceData.horde then
            local playerFaction = UnitFactionGroup("player")
            local spellID
            
            if playerFaction == "Alliance" and instanceData.alliance then
                spellID = instanceData.alliance
            elseif playerFaction == "Horde" and instanceData.horde then
                spellID = instanceData.horde
            else
                -- Fallback for unknown faction scenarios
                spellID = instanceData.alliance or instanceData.horde
            end
            
            return {
                spellID = spellID,
                nameKey = instanceData.nameKey
            }
        end
        
        -- Return standard spell data
        return instanceData
    end,
    
    -- Scan and cache all available portals based on player knowledge and settings
    GetAvailablePortals = function(self, forceRefresh)
        local now = GetTime()
        
        -- Return cached data if still valid and not forcing refresh
        if not forceRefresh and self._cache.availablePortals and 
        (now - self._cache.lastScan < self._cache.cacheTimeout) then
            return self._cache.availablePortals
        end
        
        local portals = {}
        local showUnlearned = addon.QuickTravel.db and addon.QuickTravel.db.showUnlearnedSpells or false
        local showUnlearnedCurrentSeasonOnly = addon.QuickTravel.db and addon.QuickTravel.db.showUnlearnedCurrentSeasonOnlySpells or false
        
        -- Get user-customized expansion order (only enabled categories)
        local customOrder = self:GetCustomExpansionOrder()

        -- Process each enabled expansion category
        for _, expansion in ipairs(customOrder) do
            -- Convert localized expansion name back to category key
            local categoryKey = nil
            if addon.ConfigManager then
                for key, _ in pairs(addon.ConfigManager.CATEGORY_KEYS) do
                    if addon.ConfigManager.GetLocalizedName(addon.ConfigManager.CATEGORY_KEYS[key]) == expansion then
                        categoryKey = addon.ConfigManager.CATEGORY_KEYS[key]
                        break
                    end
                end
            end

            local instanceKeys = mapCategoryKeysToInstances[categoryKey]
            if instanceKeys then
                for _, instanceKey in ipairs(instanceKeys) do
                    local dbEntry = instanceDatabase[instanceKey]
                    if dbEntry then
                        local playerFaction = UnitFactionGroup("player")
                        local shouldSkip = false

                        if dbEntry.alliance and not dbEntry.horde and playerFaction ~= "Alliance" then
                            shouldSkip = true -- Alliance-only spell, but player is Horde
                        elseif dbEntry.horde and not dbEntry.alliance and playerFaction ~= "Horde" then
                            shouldSkip = true -- Horde-only spell, but player is Alliance
                        end

                        if not shouldSkip then
                            local instanceInfo = self:GetInstanceInfo(instanceKey)
                            if instanceInfo then
                                local isKnown = false
                                local displayTexture = 134400 -- Default icon
                                local displayName = ""
                                
                                -- Process toy items
                                if instanceInfo.toyID then
                                    isKnown = PlayerHasToy(instanceInfo.toyID)
                                    displayTexture = C_Item.GetItemIconByID(instanceInfo.toyID) or 134400
                                    
                                    if instanceInfo.nameKey and type(instanceInfo.nameKey) == "string" then
                                        displayName = L[instanceInfo.nameKey]
                                    else
                                        displayName = C_Item.GetItemNameByID(instanceInfo.toyID) or ("Toy " .. instanceInfo.toyID)
                                    end
                                -- Process Hearthstone variants with special naming logic
                                elseif instanceInfo.variants then
                                    local useRandom = addon.QuickTravel.db and addon.QuickTravel.db.useRandomHearthstoneVariant
                                    local selectedVariant = addon.QuickTravel.db and addon.QuickTravel.db.selectedHearthstoneVariant
                                    
                                    -- Check if player owns any Hearthstone variants
                                    local hasVariants = false
                                    for _, variant in ipairs(instanceInfo.variants) do
                                        if PlayerHasToy(variant.id) then
                                            hasVariants = true
                                            break
                                        end
                                    end
                                    
                                    isKnown = hasVariants or GetItemCount(instanceInfo.fallback) > 0
                                    
                                    -- Set display name and icon based on variant settings
                                    if useRandom then
                                        displayName = L["HEARTHSTONE_RANDOM_VARIANT"]
                                        displayTexture = C_Item.GetItemIconByID(instanceInfo.fallback) or 134400
                                    elseif selectedVariant then
                                        -- Find the selected variant data
                                        local selectedVariantData = nil
                                        for _, variant in ipairs(instanceInfo.variants) do
                                            if variant.id == selectedVariant and PlayerHasToy(variant.id) then
                                                selectedVariantData = variant
                                                break
                                            end
                                        end
                                        
                                        if selectedVariantData then
                                            displayName = L[selectedVariantData.nameKey] or C_Item.GetItemNameByID(selectedVariant) or L["HEARTHSTONE_VARIANT_DEFAULT"]
                                            displayTexture = C_Item.GetItemIconByID(selectedVariant) or C_Item.GetItemIconByID(instanceInfo.fallback) or 134400
                                        else
                                            displayName = C_Item.GetItemNameByID(instanceInfo.fallback) or L["HEARTHSTONE_VARIANT_DEFAULT"]
                                            displayTexture = C_Item.GetItemIconByID(instanceInfo.fallback) or 134400
                                        end
                                    else
                                        displayName = C_Item.GetItemNameByID(instanceInfo.fallback) or L["HEARTHSTONE_VARIANT_DEFAULT"]
                                        displayTexture = C_Item.GetItemIconByID(instanceInfo.fallback) or 134400
                                    end
                                -- Process teleportation spells
                                elseif instanceInfo.spellID and instanceInfo.spellID > 0 then
                                    isKnown = IsSpellKnown(instanceInfo.spellID)
                                    displayTexture = C_Spell.GetSpellTexture(instanceInfo.spellID) or 134400
                                    displayName = L[instanceInfo.nameKey]
                                end
                                
                                -- Include portal if known or if showing unlearned items is enabled
                                if (isKnown or (showUnlearned and (not showUnlearnedCurrentSeasonOnly or addon.ConfigManager.CATEGORY_KEYS.CURRENT_SEASON == categoryKey))) and (instanceInfo.toyID or instanceInfo.spellID or instanceInfo.variants) then
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
        end
        
        -- Update cache with fresh data
        self._cache.availablePortals = portals
        self._cache.lastScan = now
        return portals
    end,
    
    -- Organize portal list by expansion for UI display
    OrganizeByExpansion = function(self, portals)
        local organized = {}
        local finalOrder = self:GetCustomExpansionOrder()
        
        -- Initialize empty tables for each expansion category
        for _, expansion in ipairs(finalOrder) do
            organized[expansion] = {}
        end
        
        -- Sort portals into their respective expansion categories
        for _, portal in ipairs(portals) do
            if organized[portal.expansion] then
                table.insert(organized[portal.expansion], portal)
            end
        end
        
        return organized, finalOrder
    end,

    -- Get user-customized expansion display order from addon settings
    GetCustomExpansionOrder = function(self)
        local customOrder = {}
        
        -- Use custom category order from user settings if available
        if addon.QuickTravel and addon.QuickTravel.db and addon.QuickTravel.db.categoryOrder then
            for _, category in ipairs(addon.QuickTravel.db.categoryOrder) do
                if category.enabled then
                    -- Convert category key to localized display name
                    local localizedName = addon.ConfigManager.GetLocalizedName(category.key)
                    table.insert(customOrder, localizedName)
                end
            end
            
            -- Return empty table if no categories are enabled
            if #customOrder == 0 then
                return {}
            end
        else
            -- Fallback to default expansion order with localized names
            for _, defaultCategory in ipairs(addon.ConfigManager.DEFAULT_CATEGORY_ORDER) do
                local localizedName = addon.ConfigManager.GetLocalizedName(defaultCategory.key)
                table.insert(customOrder, localizedName)
            end
        end
        
        return customOrder
    end,
    
    -- Clear cached data to force fresh scan on next request
    InvalidateCache = function(self)
        self._cache.availablePortals = nil
        self._cache.lastScan = 0
    end
}

-- Export all constants and data manager for use throughout the addon
local constants = {
    orderedExpansions = orderedExpansions,
    mapCategoryKeysToInstances = mapCategoryKeysToInstances,
    instanceDatabase = instanceDatabase,
    hearthstoneVariants = hearthstoneVariants,
    DataManager = DataManager
}

addon.constants = constants
