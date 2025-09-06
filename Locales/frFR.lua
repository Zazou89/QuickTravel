-- French localization for QuickTravel addon
-- Complete translation set maintaining consistency with English base
-- All strings translated to provide native French user experience

local L = select(2, ...).L('frFR')

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
L["Current Season"] = "Saison Actuelle"
L["Hearthstones"] = "Pierres de foyer"
L["HEARTHSTONE_RANDOM_VARIANT"] = "Pierre de foyer (variante aléatoire)"
L["Wormhole Generator"] = "Générateur de tunnel spatiotemporel"
L["Mage Teleport"] = "Téléportation de Mage"
L["Mage Portal"] = "Portail de Mage"

-- === DUNGEON AND RAID LOCATIONS BY EXPANSION ===
-- Organized chronologically by expansion for easy maintenance

-- Cataclysm Dungeons
L["DUNGEON_VORTEX_PINNACLE"] = "La cime du Vortex"
L["DUNGEON_THRONE_OF_THE_TIDES"] = "Trône des marées"
L["DUNGEON_GRIM_BATOL"] = "Grim Batol"

-- Mists of Pandaria Dungeons
L["DUNGEON_TEMPLE_OF_THE_JADE_SERPENT"] = "Temple du Serpent de jade"
L["DUNGEON_SIEGE_OF_NIUZAO"] = "Siège du temple de Niuzao"
L["DUNGEON_SCHOLOMANCE"] = "Scholomance"
L["DUNGEON_SCARLET_MONASTERY"] = "Monastère Écarlate"
L["DUNGEON_SCARLET_HALLS"] = "Salles Écarlates"
L["DUNGEON_GATE_OF_THE_SETTING_SUN"] = "Porte du Soleil couchant"
L["DUNGEON_MOGUSHAN_PALACE"] = "Palais Mogu'shan"
L["DUNGEON_SHADO_PAN_MONASTERY"] = "Monastère des Pandashan"
L["DUNGEON_STORMSTOUT_BREWERY"] = "Brasserie Brune d'Orage"

-- Warlords of Draenor Dungeons
L["DUNGEON_SHADOWMOON_BURIAL_GROUNDS"] = "Terres sacrées d'Ombrelune"
L["DUNGEON_EVERBLOOM"] = "La Flore éternelle"
L["DUNGEON_BLOODMAUL_SLAG_MINES"] = "Mine de la Masse-Sanglante"
L["DUNGEON_AUCHINDOUN"] = "Auchindoun"
L["DUNGEON_SKYREACH"] = "Orée-du-Ciel"
L["DUNGEON_UPPER_BLACKROCK_SPIRE"] = "Sommet du pic Rochenoire"
L["DUNGEON_GRIMRAIL_DEPOT"] = "Dépôt de Tristerail"
L["DUNGEON_IRON_DOCKS"] = "Quais de Fer"

-- Legion Dungeons
L["DUNGEON_DARKHEART_THICKET"] = "Fourré Sombrecœur"
L["DUNGEON_BLACK_ROOK_HOLD"] = "Bastion du Freux"
L["DUNGEON_HALLS_OF_VALOR"] = "Salles des Valeureux"
L["DUNGEON_NELTHARIONS_LAIR"] = "Repaire de Neltharion"
L["DUNGEON_COURT_OF_STARS"] = "Cour des Étoiles"
L["DUNGEON_KARAZHAN"] = "Karazhan"

-- Battle for Azeroth Dungeons
L["DUNGEON_ATALDAZAR"] = "Atal'Dazar"
L["DUNGEON_FREEHOLD"] = "Port-Liberté"
L["DUNGEON_WAYCREST_MANOR"] = "Manoir Malvoie"
L["DUNGEON_THE_UNDERROT"] = "Tréfonds Putrides"
L["DUNGEON_MECHAGON"] = "Opération Mécagone"
L["DUNGEON_SIEGE_OF_BORALUS"] = "Siège de Boralus"
L["DUNGEON_THE_MOTHERLOAD"] = "Le Filon"

-- Shadowlands Dungeons and Raids
L["DUNGEON_THE_NECROTIC_WAKE"] = "Sillage nécrotique"
L["DUNGEON_PLAGUEFALL"] = "Malepeste"
L["DUNGEON_MISTS_OF_TIRNA_SCITHE"] = "Brumes de Tirna Scithe"
L["DUNGEON_HALLS_OF_ATONEMENT"] = "Salles de l'Expiation"
L["DUNGEON_SPIRES_OF_ASCENSION"] = "Flèches de l'Ascension"
L["DUNGEON_THEATRE_OF_PAIN"] = "Théâtre de la Souffrance"
L["DUNGEON_DE_OTHER_SIDE"] = "L'Autre côté"
L["DUNGEON_SANGUINE_DEPTHS"] = "Profondeurs Sanguines"
L["DUNGEON_TAZAVESH_THE_VEILED_MARKET"] = "Tazavesh, le marché dissimulé"
L["RAID_CASTLE_NATHRIA"] = "Château Nathria"
L["RAID_SANCTUM_OF_DOMINATION"] = "Sanctum de Domination"
L["RAID_SEPULCHER_OF_THE_FIRST_ONES"] = "Sépulcre des Fondateurs"

-- Dragonflight Dungeons and Raids
L["DUNGEON_RUBY_LIFE_POOLS"] = "Bassins de l'Essence rubis"
L["DUNGEON_NOKHUD_OFFENSIVE"] = "L'offensive nokhud"
L["DUNGEON_AZURE_VAULT"] = "Caveau d'Azur"
L["DUNGEON_ALGETHAR_ACADEMY"] = "Académie d'Algeth'ar"
L["DUNGEON_ULDAMAN"] = "Uldaman : l'héritage de Tyr"
L["DUNGEON_NELTHARUS"] = "Neltharus"
L["DUNGEON_BRACKENHIDE_HOLLOW"] = "Creux des Fougerobes"
L["DUNGEON_HALLS_OF_INFUSION"] = "Salles de l'Imprégnation"
L["DUNGEON_DAWN_OF_THE_INFINITE"] = "Aube de l'Infini"
L["RAID_VAULT_OF_THE_INCARNATES"] = "Chambres des Incarnations"
L["RAID_ABBERUS_THE_SHADOWED_CRUCIBLE"] = "Aberrus, le Creuset de l'Ombre"
L["RAID_AMIRDRASSIL_THE_DREAMS_HOPE"] = "Amirdrassil, l'Espoir du Rêve"

-- The War Within Dungeons and Raids
L["DUNGEON_CITY_OF_THREADS"] = "Cité des Fils"
L["DUNGEON_ARA_KARA_CITY_OF_ECHOS"] = "Ara-Kara, la cité des Échos"
L["DUNGEON_STONEVAULT"] = "La Cavepierre"
L["DUNGEON_DAWNBREAKER"] = "Le Brise-Aube"
L["DUNGEON_THE_ROOKERY"] = "La colonie"
L["DUNGEON_DARKFLAME_CLEFT"] = "Faille de Flamme-Noire"
L["DUNGEON_CINDERBREW_MEADERY"] = "Hydromellerie de Brassecendre"
L["DUNGEON_PRIORY_OF_THE_SACRED_FLAME"] = "Prieuré de la Flamme sacrée"
L["DUNGEON_OPERATION_FLOODGATE"] = "Opération Vannes ouvertes"
L["DUNGEON_ECO_DOME_AL_DANI"] = "Écodôme Al'dani"
L["RAID_LIBERATION_OF_UNDERMINE"] = "Libération de Terremine"
L["RAID_MANAFORGE_OMEGA"] = "Manaforge Oméga"

-- Special Hearthstone Items
L["HEARTHSTONE_DALARAN"] = "Pierre de foyer de Dalaran"
L["HEARTHSTONE_GARRISON"] = "Pierre de foyer de fief"

-- === HEARTHSTONE VARIANTS ===
L["HEARTHSTONE_VARIANT_DEFAULT"] = "Pierre de foyer"
L["HEARTHSTONE_VARIANT_54452"] = "Portail éthérien"
L["HEARTHSTONE_VARIANT_64488"] = "La fille de l'aubergiste"
L["HEARTHSTONE_VARIANT_93672"] = "Porte des ténèbres"
L["HEARTHSTONE_VARIANT_142542"] = "Tome de Portail de retour en ville"
L["HEARTHSTONE_VARIANT_162973"] = "Pierre de foyer de Grandpère Hiver"
L["HEARTHSTONE_VARIANT_163045"] = "Pierre de foyer du Cavalier sans tête"
L["HEARTHSTONE_VARIANT_165669"] = "Pierre de foyer d’ancien lunaire"
L["HEARTHSTONE_VARIANT_165670"] = "Pierre de foyer ravissante de Colportecœur"
L["HEARTHSTONE_VARIANT_165802"] = "Pierre de foyer du noble jardinier"
L["HEARTHSTONE_VARIANT_166746"] = "Pierre de foyer du cracheur de feu"
L["HEARTHSTONE_VARIANT_166747"] = "Pierre de foyer de fêtard de la fête des Brasseurs"
L["HEARTHSTONE_VARIANT_168907"] = "Pierre de foyer à numérisation holographique"
L["HEARTHSTONE_VARIANT_172179"] = "Pierre de foyer du voyageur éternel"
L["HEARTHSTONE_VARIANT_180290"] = "Pierre de foyer des Faë nocturnes"
L["HEARTHSTONE_VARIANT_182773"] = "Pierre de foyer de Nécro-seigneur"
L["HEARTHSTONE_VARIANT_183716"] = "Stèle du vice venthyr"
L["HEARTHSTONE_VARIANT_184353"] = "Pierre de foyer kyriane"
L["HEARTHSTONE_VARIANT_188952"] = "Pierre de foyer dominée"
L["HEARTHSTONE_VARIANT_190196"] = "Pierre de foyer des Éclairés"
L["HEARTHSTONE_VARIANT_190237"] = "Matrice de transposition de négociant"
L["HEARTHSTONE_VARIANT_193588"] = "Pierre de foyer de marcheur du temps"
L["HEARTHSTONE_VARIANT_200630"] = "Pierre de foyer de sage-du-vent ohn'ir"
L["HEARTHSTONE_VARIANT_206195"] = "Voie des Naaru"
L["HEARTHSTONE_VARIANT_208704"] = "Pierre de foyer en terre de rôdeur des profondeurs"
L["HEARTHSTONE_VARIANT_209035"] = "Pierre de foyer de la Flamme"
L["HEARTHSTONE_VARIANT_212337"] = "Pierre du foyer"
L["HEARTHSTONE_VARIANT_228940"] = "Pierre de foyer de fil notoire"
L["HEARTHSTONE_VARIANT_235016"] = "Module de redéploiement"
L["HEARTHSTONE_VARIANT_236687"] = "Pierre de foyer explosive"
L["HEARTHSTONE_VARIANT_245970"] = "Pierre de foyer expresse du maître de P.O.S.T.E."
L["HEARTHSTONE_VARIANT_246565"] = "Pierre de foyer cosmique"
L["HEARTHSTONE_VARIANT_210455"] = "Hologemme draenique"

-- Wormhole Generator
L["ULTRASAFE_TRANSPORTER_GADGETZAN"] = "Gadgetzan"
L["ULTRASAFE_TRANSPORTER_TOSHLEYS_STATION"] = "Outreterre"
L["WORMHOLE_GENERATOR_NORTHREND"] = "Norfendre"
L["WORMHOLE_GENERATOR_PANDARIA"] = "Pandarie"
L["WORMHOLE_GENERATOR_ARGUS"] = "Argus"
L["WORMHOLE_GENERATOR_ZANDALAR"] = "Zandalar"
L["WORMHOLE_GENERATOR_KUL_TIRAS"] = "Kul Tiras"
L["WORMHOLE_GENERATOR_SHADOWLANDS"] = "Ombreterre"
L["WORMHOLE_GENERATOR_DRAGON_ISLES"] = "Îles aux Dragons"
L["WORMHOLE_GENERATOR_KHAZ_ALGAR"] = "Khaz Algar"

-- Mage Teleport
L["MAGE_TELEPORT_HALL_OF_THE_GUARDIAN"] = "Hall du Gardien" --193759
L["MAGE_TELEPORT_STORMWIND"] = "Hurlevent" --3561
L["MAGE_TELEPORT_IRONFORGE"] = "Forgefer" --3562
L["MAGE_TELEPORT_DARNASSUS"] = "Darnassus" --3565
L["MAGE_TELEPORT_EXODAR"] = "Exodar" --32271
L["MAGE_TELEPORT_THERAMORE"] = "Theramore" --49359

L["MAGE_TELEPORT_ORGRIMMAR"] = "Orgrimmar" --3567
L["MAGE_TELEPORT_UNDERCITY"] = "Fossoyeuse" --3563
L["MAGE_TELEPORT_THUNDER_BLUFF"] = "Pitons-du-Tonnerre" --3566
L["MAGE_TELEPORT_SILVERMOON_CITY"] = "Lune-d'Argent" --32272
L["MAGE_TELEPORT_STONARD"] = "Pierrêche" --49358

L["MAGE_TELEPORT_SHATTRATH"] = "Shattrath" --33690/35715
L["MAGE_TELEPORT_DALARAN"] = "Dalaran - Norfendre" --53140
L["MAGE_TELEPORT_TOL_BARAD"] = "Tol Barad" --88342/88344
L["MAGE_TELEPORT_VALE_OF_ETERNAL_BLOSSOMS"] = "Val de l'Éternel printemps" --132621/132627

L["MAGE_TELEPORT_STORMSHIELD"] = "Bouclier-des-Tempêtes" --176248
L["MAGE_TELEPORT_WARSPEAR"] = "Fer-de-Lance" --176242

L["MAGE_TELEPORT_DALARAN_BROKEN_ISLES"] = "Dalaran - Îles Brisées" --224869
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
L["SEARCH"] = "Rechercher..."
L["CLICK_TO_TELEPORT"] = "Cliquez pour vous téléporter"
L["CLICK_TO_USE"] = "Cliquez pour utiliser"
L["NO_CATEGORIES_SELECTED"] = "Aucune catégorie sélectionnée"
L["NO_SEARCH_RESULTS"] = "Aucun résultat pour cette recherche."
L["LOADED"] = "chargé ! Utilisez /qt pour ouvrir."
L["RIGHT_CLICK_ADD_FAVORITE"] = "Clic droit pour ajouter aux favoris"
L["RIGHT_CLICK_REMOVE_FAVORITE"] = "Clic droit pour retirer des favoris"
L["TOGGLE_QUICKTRAVEL"] = "Ouvrir/Fermer QuickTravel"
L["SPELL_NOT_LEARNED"] = "Sort non appris"
L["TOY_NOT_OWNED"] = "Jouet non possédé"
L["LFG_TAB_PORTAILS"] = "Portails"
L["RANDOM_VARIANT_TOOLTIP"] = "Utilise une variante aléatoire de la pierre de foyer"

-- Favorites System
L["FAVORITES"] = "Favoris"

-- === CONFIGURATION OPTIONS ===
-- Settings and preferences interface labels

-- Display Options
L["SHOW_LOGIN_MESSAGE"] = "Afficher le message de connexion"
L["AUTO_CLOSE"] = "Fermer auto. l'adddon lors du TP"
L["SHOW_CURRENT_SEASON"] = "Afficher la saison actuelle"
L["SHOW_HEARTHSTONES"] = "Afficher les pierres de foyer"
L["SHOW_UNLEARNED_SPELLS"] = "Afficher les sorts non appris"
L["SHOW_SPELL_TOOLTIPS"] = "Afficher les infobulles des sorts"
L["SHOW_LFG_TAB"] = "Afficher le bouton dans la rech. de groupe"
L["LOCK_FRAME_HEIGHT"] = "Verrouiller la hauteur de la fenêtre"
L["SHOW_MINIMAP_ICON"] = "Afficher l'icône sur la minicarte"

-- Interface Tabs
L["OPTIONS_TAB"] = "Options"
L["CATEGORIES_TAB"] = "Catégories"

-- Hearthstone Configuration
L["USE_RANDOM_HEARTHSTONE_VARIANT"] = "Utiliser une variante aléatoire"
L["NO_HEARTHSTONE_VARIANTS"] = "Aucun variant possédé"

-- Category Management
L["REVERSE_EXPANSION_ORDER"] = "Inverser l'ordre des extensions"
L["CATEGORIES_ORDER_HEADER"] = "Ordre des catégories"

-- Options Section Headers
L["DISPLAY_HEADER"] = "Affichage"
L["BEHAVIOR_HEADER"] = "Comportement"
L["HEARTHSTONE_HEADER"] = "Pierre de foyer"

-- === USER FEEDBACK MESSAGES ===
-- System notifications and status updates
L["MSG_LOGIN_MESSAGE_ENABLED"] = "Message de connexion activé"
L["MSG_LOGIN_MESSAGE_DISABLED"] = "Message de connexion désactivé"
