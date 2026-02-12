-- English (US) localization for QuickTravel addon
-- Primary language file containing all translatable strings
-- Serves as the base reference for other language translations

local L = select(2, ...).L('enUS')

-- === CORE ADDON IDENTITY ===
L["QT_TITLE"] = "Quick Travel"

-- === EXPANSION CATEGORIES ===
-- World of Warcraft expansion names for UI organization
L["Cataclysm"] = "Cataclysm"
L["Mists of Pandaria"] = "Mists of Pandaria"
L["Warlords of Draenor"] = "Warlords of Draenor"
L["Legion"] = "Legion"
L["Battle for Azeroth"] = "Battle for Azeroth"
L["Shadowlands"] = "Shadowlands"
L["Dragonflight"] = "Dragonflight"
L["The War Within"] = "The War Within"
L["Midnight"] = "Midnight"
L["Current Season"] = "Current Season"
L["Hearthstones"] = "Hearthstones"
L["HEARTHSTONE_RANDOM_VARIANT"] = "Hearthstone (random variant)"
L["Wormhole Generator"] = "Wormhole Generator"
L["Mage Teleport"] = "Mage Teleport"
L["Mage Portal"] = "Mage Portal"

-- === DUNGEON AND RAID LOCATIONS BY EXPANSION ===
-- Organized chronologically by expansion for easy maintenance

-- Wrath of the Lich King Dungeons
L["DUNGEON_PIT_OF_SARON"] = "Pit of Saron" --4813

-- Cataclysm Dungeons
L["DUNGEON_VORTEX_PINNACLE"] = "The Vortex Pinnacle" --5035
L["DUNGEON_THRONE_OF_THE_TIDES"] = "Throne of the Tides" --5004
L["DUNGEON_GRIM_BATOL"] = "Grim Batol" --4950

-- Mists of Pandaria Dungeons
L["DUNGEON_TEMPLE_OF_THE_JADE_SERPENT"] = "Temple of the Jade Serpent" --5956
L["DUNGEON_SIEGE_OF_NIUZAO"] = "Siege of Niuzao Temple" --6214
L["DUNGEON_SCHOLOMANCE"] = "Scholomance" --2057
L["DUNGEON_SCARLET_MONASTERY"] = "Scarlet Monastery" --6109
L["DUNGEON_SCARLET_HALLS"] = "Scarlet Halls" --6052
L["DUNGEON_GATE_OF_THE_SETTING_SUN"] = "Gate of the Setting Sun" --5976
L["DUNGEON_MOGUSHAN_PALACE"] = "Mogu'shan Palace" --6182
L["DUNGEON_SHADO_PAN_MONASTERY"] = "Shado-Pan Monastery" --5918
L["DUNGEON_STORMSTOUT_BREWERY"] = "Stormstout Brewery" --5963

-- Warlords of Draenor Dungeons
L["DUNGEON_SHADOWMOON_BURIAL_GROUNDS"] = "Shadowmoon Burial Grounds" --6932
L["DUNGEON_EVERBLOOM"] = "The Everbloom" --7109
L["DUNGEON_BLOODMAUL_SLAG_MINES"] = "Bloodmaul Slag Mines" --6874
L["DUNGEON_AUCHINDOUN"] = "Auchindoun" --6912
L["DUNGEON_SKYREACH"] = "Skyreach" --6988
L["DUNGEON_UPPER_BLACKROCK_SPIRE"] = "Upper Blackrock Spire" --7307
L["DUNGEON_GRIMRAIL_DEPOT"] = "Grimrail Depot" --6984
L["DUNGEON_IRON_DOCKS"] = "Iron Docks" --6951

-- Legion Dungeons
L["DUNGEON_DARKHEART_THICKET"] = "Darkheart Thicket" --7673
L["DUNGEON_BLACK_ROOK_HOLD"] = "Black Rook Hold" --7805
L["DUNGEON_HALLS_OF_VALOR"] = "Halls of Valor" --7672
L["DUNGEON_NELTHARIONS_LAIR"] = "Neltharion's Lair" --7546
L["DUNGEON_COURT_OF_STARS"] = "Court of Stars" --8079
L["DUNGEON_KARAZHAN"] = "Return to Karazhan" --8443
L["DUNGEON_SEAT_OF_THE_TRIUMVIRATE"] = "The Seat of the Triumvirate" --8910

-- Battle for Azeroth Dungeons
L["DUNGEON_ATALDAZAR"] = "Atal'Dazar" --9028
L["DUNGEON_FREEHOLD"] = "Freehold" --9164
L["DUNGEON_WAYCREST_MANOR"] = "Waycrest Manor" --9424
L["DUNGEON_THE_UNDERROT"] = "The Underrot" --9391
L["DUNGEON_MECHAGON"] = "Operation: Mechagon" --10225
L["DUNGEON_SIEGE_OF_BORALUS"] = "Siege of Boralus" --9354
L["DUNGEON_THE_MOTHERLOAD"] = "The MOTHERLODE!!" --8064

-- Shadowlands Dungeons and Raids
L["DUNGEON_THE_NECROTIC_WAKE"] = "The Necrotic Wake" --12916
L["DUNGEON_PLAGUEFALL"] = "Plaguefall" --13228
L["DUNGEON_MISTS_OF_TIRNA_SCITHE"] = "Mists of Tirna Scithe" --13334
L["DUNGEON_HALLS_OF_ATONEMENT"] = "Halls of Atonement" --12831
L["DUNGEON_SPIRES_OF_ASCENSION"] = "Spires of Ascension" --12837
L["DUNGEON_THEATRE_OF_PAIN"] = "Theater of Pain" --12841
L["DUNGEON_DE_OTHER_SIDE"] = "De Other Side" --13309
L["DUNGEON_SANGUINE_DEPTHS"] = "Sanguine Depths" --12842
L["DUNGEON_TAZAVESH_THE_VEILED_MARKET"] = "Tazavesh, the Veiled Market" --13577
L["RAID_CASTLE_NATHRIA"] = "Castle Nathria" --13224
L["RAID_SANCTUM_OF_DOMINATION"] = "Sanctum of Domination" --13561
L["RAID_SEPULCHER_OF_THE_FIRST_ONES"] = "Sepulcher of the First Ones" --13742

-- Dragonflight Dungeons and Raids
L["DUNGEON_RUBY_LIFE_POOLS"] = "Ruby Life Pools" --14063
L["DUNGEON_NOKHUD_OFFENSIVE"] = "The Nokhud Offensive" --13982
L["DUNGEON_AZURE_VAULT"] = "The Azure Vault" --13954
L["DUNGEON_ALGETHAR_ACADEMY"] = "Algeth'ar Academy" --14032
L["DUNGEON_ULDAMAN"] = "Uldaman: Legacy of Tyr" -- 16278 (achievement)
L["DUNGEON_NELTHARUS"] = "Neltharus" --14011
L["DUNGEON_BRACKENHIDE_HOLLOW"] = "Brackenhide Hollow" --13991
L["DUNGEON_HALLS_OF_INFUSION"] = "Halls of Infusion" --14082
L["DUNGEON_DAWN_OF_THE_INFINITE"] = "Dawn of the Infinite" --14514
L["RAID_VAULT_OF_THE_INCARNATES"] = "Vault of the Incarnates" --14030
L["RAID_ABBERUS_THE_SHADOWED_CRUCIBLE"] = "Aberrus, the Shadowed Crucible" --14663
L["RAID_AMIRDRASSIL_THE_DREAMS_HOPE"] = "Amirdrassil, the Dream's Hope" --14643

-- The War Within Dungeons and Raids
L["DUNGEON_CITY_OF_THREADS"] = "City of Threads" --14753
L["DUNGEON_ARA_KARA_CITY_OF_ECHOS"] = "Ara-Kara, City of Echoes" --15093
L["DUNGEON_STONEVAULT"] = "The Stonevault" --14883
L["DUNGEON_DAWNBREAKER"] = "The Dawnbreaker" --14971
L["DUNGEON_THE_ROOKERY"] = "The Rookery" --14938
L["DUNGEON_DARKFLAME_CLEFT"] = "Darkflame Cleft" --14882
L["DUNGEON_CINDERBREW_MEADERY"] = "Cinderbrew Meadery" --15103
L["DUNGEON_PRIORY_OF_THE_SACRED_FLAME"] = "Priory of the Sacred Flame" --14954
L["DUNGEON_OPERATION_FLOODGATE"] = "Operation: Floodgate" --15452
L["DUNGEON_ECO_DOME_AL_DANI"] = "Eco-Dome Al'dani" --16104
L["RAID_LIBERATION_OF_UNDERMINE"] = "Liberation of Undermine" --15522
L["RAID_MANAFORGE_OMEGA"] = "Manaforge Omega" --16178

-- Midnight Dungeons and Raids
L["DUNGEON_WINDRUNNERS_SPIRE"] = "Windrunner Spire" --15808
L["DUNGEON_NEXUS_POINT_XENAS"] = "Nexus-Point Xenas" --16573
L["DUNGEON_MAISARA_CAVERNS"] = "Maisara Caverns" --16395
L["DUNGEON_MAGISTER_TERRACE"] = "Magisters' Terrace" --15829

-- Special Hearthstone Items
L["HEARTHSTONE_DALARAN"] = "Dalaran Hearthstone"
L["HEARTHSTONE_GARRISON"] = "Garrison Hearthstone"

-- === HEARTHSTONE VARIANTS ===
L["HEARTHSTONE_VARIANT_DEFAULT"] = "Hearthstone"
L["HEARTHSTONE_VARIANT_54452"] = "Ethereal Portal"
L["HEARTHSTONE_VARIANT_64488"] = "The Innkeeper's Daughter"
L["HEARTHSTONE_VARIANT_93672"] = "Dark Portal"
L["HEARTHSTONE_VARIANT_142542"] = "Tome of Town Portal"
L["HEARTHSTONE_VARIANT_162973"] = "Greatfather Winter's Hearthstone"
L["HEARTHSTONE_VARIANT_163045"] = "Headless Horseman's Hearthstone"
L["HEARTHSTONE_VARIANT_165669"] = "Lunar Elder's Hearthstone"
L["HEARTHSTONE_VARIANT_165670"] = "Peddlefeet's Lovely Hearthstone"
L["HEARTHSTONE_VARIANT_165802"] = "Noble Gardener's Hearthstone"
L["HEARTHSTONE_VARIANT_166746"] = "Fire Eater's Hearthstone"
L["HEARTHSTONE_VARIANT_166747"] = "Brewfest Reveler's Hearthstone"
L["HEARTHSTONE_VARIANT_168907"] = "Holographic Digitalization Hearthstone"
L["HEARTHSTONE_VARIANT_172179"] = "Eternal Traveler's Hearthstone"
L["HEARTHSTONE_VARIANT_180290"] = "Night Fae Hearthstone"
L["HEARTHSTONE_VARIANT_182773"] = "Necrolord Hearthstone"
L["HEARTHSTONE_VARIANT_183716"] = "Venthyr Sinstone"
L["HEARTHSTONE_VARIANT_184353"] = "Kyrian Hearthstone"
L["HEARTHSTONE_VARIANT_188952"] = "Dominated Hearthstone"
L["HEARTHSTONE_VARIANT_190196"] = "Enlightened Hearthstone"
L["HEARTHSTONE_VARIANT_190237"] = "Broker Translocation Matrix"
L["HEARTHSTONE_VARIANT_193588"] = "Timewalker's Hearthstone"
L["HEARTHSTONE_VARIANT_200630"] = "Ohn'ir Windsage's Hearthstone"
L["HEARTHSTONE_VARIANT_206195"] = "Path of the Naaru"
L["HEARTHSTONE_VARIANT_208704"] = "Deepdweller's Earthen Hearthstone"
L["HEARTHSTONE_VARIANT_209035"] = "Hearthstone of the Flame"
L["HEARTHSTONE_VARIANT_212337"] = "Stone of the Hearth"
L["HEARTHSTONE_VARIANT_228940"] = "Notorious Thread's Hearthstone"
L["HEARTHSTONE_VARIANT_235016"] = "Redeployment Module"
L["HEARTHSTONE_VARIANT_236687"] = "Explosive Hearthstone"
L["HEARTHSTONE_VARIANT_245970"] = "P.O.S.T. Master's Express Hearthstone"
L["HEARTHSTONE_VARIANT_246565"] = "Cosmic Hearthstone"
L["HEARTHSTONE_VARIANT_210455"] = "Draenic Hologem"

-- Wormhole Generator
L["ULTRASAFE_TRANSPORTER_GADGETZAN"] = "Gadgetzan"
L["ULTRASAFE_TRANSPORTER_TOSHLEYS_STATION"] = "Outland"
L["WORMHOLE_GENERATOR_NORTHREND"] = "Northrend"
L["WORMHOLE_GENERATOR_PANDARIA"] = "Pandaria"
L["WORMHOLE_GENERATOR_ARGUS"] = "Argus"
L["WORMHOLE_GENERATOR_ZANDALAR"] = "Zandalar"
L["WORMHOLE_GENERATOR_KUL_TIRAS"] = "Kul Tiras"
L["WORMHOLE_GENERATOR_SHADOWLANDS"] = "Shadowlands"
L["WORMHOLE_GENERATOR_DRAGON_ISLES"] = "Dragon Isles"
L["WORMHOLE_GENERATOR_KHAZ_ALGAR"] = "Khaz Algar"

-- Mage Teleport
L["MAGE_TELEPORT_HALL_OF_THE_GUARDIAN"] = "Hall of the Guardian" --193759
L["MAGE_TELEPORT_STORMWIND"] = "Stormwind" --3651
L["MAGE_TELEPORT_IRONFORGE"] = "Ironforge" --3562
L["MAGE_TELEPORT_DARNASSUS"] = "Darnassus" --3565
L["MAGE_TELEPORT_EXODAR"] = "Exodar" --32271
L["MAGE_TELEPORT_THERAMORE"] = "Theramore" --49359

L["MAGE_TELEPORT_ORGRIMMAR"] = "Orgrimmar" --3567
L["MAGE_TELEPORT_UNDERCITY"] = "Undercity" --3563
L["MAGE_TELEPORT_THUNDER_BLUFF"] = "Thunder Bluff" --3566
L["MAGE_TELEPORT_SILVERMOON_CITY"] = "Silvermoon" --32272
L["MAGE_TELEPORT_STONARD"] = "Stonard" --49358

L["MAGE_TELEPORT_SHATTRATH"] = "Shattrath" --33690/35715
L["MAGE_TELEPORT_DALARAN"] = "Dalaran - Northrend" --53140
L["MAGE_TELEPORT_TOL_BARAD"] = "Tol Barad" --88342/88344
L["MAGE_TELEPORT_VALE_OF_ETERNAL_BLOSSOMS"] = "Vale of Eternal Blossoms" --132621/132627

L["MAGE_TELEPORT_STORMSHIELD"] = "Stormshield" --176248
L["MAGE_TELEPORT_WARSPEAR"] = "Warspear" --176242

L["MAGE_TELEPORT_DALARAN_BROKEN_ISLES"] = "Dalaran - Broken Isles" --224869
L["MAGE_TELEPORT_BORALUS"] = "Boralus" --281403
L["MAGE_TELEPORT_DAZAR_ALOR"] = "Dazar'alor" --281404
L["MAGE_TELEPORT_ORIBOS"] = "Oribos" --344587
L["MAGE_TELEPORT_VALDRAKKEN"] = "Valdrakken" --395277
L["MAGE_TELEPORT_DORNOGAL"] = "Dornogal" --446540

-- Mage Portal
L["MAGE_PORTAL_STORMWIND"] = "Hurlevent" --10059
L["MAGE_PORTAL_IRONFORGE"] = "Forgefer" --11416
L["MAGE_PORTAL_DARNASSUS"] = "Darnassus" --11419
L["MAGE_PORTAL_EXODAR"] = "Exodar" --32266
L["MAGE_PORTAL_THERAMORE"] = "Theramore" --49360

L["MAGE_PORTAL_ORGRIMMAR"] = "Orgrimmar" --11417
L["MAGE_PORTAL_UNDERCITY"] = "Fossoyeuse" --11418
L["MAGE_PORTAL_THUNDER_BLUFF"] = "Pitons-du-Tonnerre" --11420
L["MAGE_PORTAL_SILVERMOON_CITY"] = "Lune-d'Argent" --32267
L["MAGE_PORTAL_STONARD"] = "Pierrêche" --49361

L["MAGE_PORTAL_SHATTRATH"] = "Shattrath" -- 33691/35717
L["MAGE_PORTAL_DALARAN"] = "Dalaran - Norfendre" --53142
L["MAGE_PORTAL_TOL_BARAD"] = "Tol Barad" -- 88345/88346
L["MAGE_PORTAL_VALE_OF_ETERNAL_BLOSSOMS"] = "Val de l'Éternel printemps" -- 132620/132626

L["MAGE_PORTAL_STORMSHIELD"] = "Bouclier-des-Tempêtes" --176246
L["MAGE_PORTAL_WARSPEAR"] = "Fer-de-Lance" --176244

L["MAGE_PORTAL_DALARAN_BROKEN_ISLES"] = "Dalaran - Îles Brisées" --224871
L["MAGE_PORTAL_BORALUS"] = "Boralus" --281400
L["MAGE_PORTAL_DAZAR_ALOR"] = "Dazar'alor" --281402
L["MAGE_PORTAL_ORIBOS"] = "Oribos" --344597
L["MAGE_PORTAL_VALDRAKKEN"] = "Valdrakken" --395289
L["MAGE_PORTAL_DORNOGAL"] = "Dornogal" --446534

-- === USER INTERFACE STRINGS ===
-- Core interface elements and user interaction text

-- General UI Elements
L["SEARCH"] = "Search..."
L["CLICK_TO_TELEPORT"] = "Click to teleport"
L["CLICK_TO_USE"] = "Click to use"
L["NO_CATEGORIES_SELECTED"] = "No categories selected"
L["NO_SEARCH_RESULTS"] = "No results for this search."
L["LOADED"] = "loaded! Use /qt to open."
L["RIGHT_CLICK_ADD_FAVORITE"] = "Right-click to add to favorites"
L["RIGHT_CLICK_REMOVE_FAVORITE"] = "Right-click to remove from favorites"
L["TOGGLE_QUICKTRAVEL"] = "Toggle QuickTravel"
L["SPELL_NOT_LEARNED"] = "Spell not learned"
L["TOY_NOT_OWNED"] = "Toy not owned"
L["LFG_TAB_PORTALS"] = "Portals"
L["RANDOM_VARIANT_TOOLTIP"] = "A random hearthstone variant will be used"

-- Favorites System
L["FAVORITES"] = "Favorites"

-- === CONFIGURATION OPTIONS ===
-- Settings and preferences interface labels

-- Display Options
L["SHOW_LOGIN_MESSAGE"] = "Show login message"
L["AUTO_CLOSE"] = "Auto-close addon while casting"
L["SHOW_CURRENT_SEASON"] = "Show current season"
L["SHOW_HEARTHSTONES"] = "Show hearthstones"
L["SHOW_UNLEARNED_SPELLS"] = "Show unlearned spells"
L["SHOW_SPELL_TOOLTIPS"] = "Show spell tooltips"
L["SHOW_LFG_TAB"] = "Show button in Group Finder"
L["LOCK_FRAME_HEIGHT"] = "Lock frame height"
L["SHOW_MINIMAP_ICON"] = "Show minimap icon"

-- Interface Tabs
L["OPTIONS_TAB"] = "Options"
L["CATEGORIES_TAB"] = "Categories"

-- Hearthstone Configuration
L["USE_RANDOM_HEARTHSTONE_VARIANT"] = "Use random hearthstone variant"
L["NO_HEARTHSTONE_VARIANTS"] = "No variants owned"

-- Category Management
L["REVERSE_EXPANSION_ORDER"] = "Reverse expansion order"
L["CATEGORIES_ORDER_HEADER"] = "Categories Order"

-- Options Section Headers
L["DISPLAY_HEADER"] = "Display"
L["BEHAVIOR_HEADER"] = "Behavior"
L["HEARTHSTONE_HEADER"] = "Hearthstone"

-- === USER FEEDBACK MESSAGES ===
-- System notifications and status updates
L["MSG_LOGIN_MESSAGE_ENABLED"] = "Login message enabled"
L["MSG_LOGIN_MESSAGE_DISABLED"] = "Login message disabled"
