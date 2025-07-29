-- French localization for QuickTravel addon
-- Complete translation set maintaining consistency with English base
-- All strings translated to provide native French user experience

local L = select(2, ...).L('frFR')

-- === IDENTITÉ DE BASE DE L'ADDON ===
L["QT_TITLE"] = "Quick Travel"

-- === CATÉGORIES D'EXTENSIONS ===
-- Noms des extensions World of Warcraft pour l'organisation de l'interface
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

-- === DONJONS ET RAIDS PAR EXTENSION ===
-- Organisés chronologiquement par extension pour faciliter la maintenance

-- Donjons Cataclysm
L["DUNGEON_VORTEX_PINNACLE"] = "La cime du Vortex"
L["DUNGEON_THRONE_OF_THE_TIDES"] = "Trône des marées"
L["DUNGEON_GRIM_BATOL"] = "Grim Batol"

-- Donjons Mists of Pandaria
L["DUNGEON_TEMPLE_OF_THE_JADE_SERPENT"] = "Temple du Serpent de jade"
L["DUNGEON_SIEGE_OF_NIUZAO"] = "Siège du temple de Niuzao"
L["DUNGEON_SCHOLOMANCE"] = "Scholomance"
L["DUNGEON_SCARLET_MONASTERY"] = "Monastère Écarlate"
L["DUNGEON_SCARLET_HALLS"] = "Salles Écarlates"
L["DUNGEON_GATE_OF_THE_SETTING_SUN"] = "Porte du Soleil couchant"
L["DUNGEON_MOGUSHAN_PALACE"] = "Palais Mogu'shan"
L["DUNGEON_SHADO_PAN_MONASTERY"] = "Monastère des Pandashan"
L["DUNGEON_STORMSTOUT_BREWERY"] = "Brasserie Brune d'Orage"

-- Donjons Warlords of Draenor
L["DUNGEON_SHADOWMOON_BURIAL_GROUNDS"] = "Terres sacrées d'Ombrelune"
L["DUNGEON_EVERBLOOM"] = "La Flore éternelle"
L["DUNGEON_BLOODMAUL_SLAG_MINES"] = "Mine de la Masse-Sanglante"
L["DUNGEON_AUCHINDOUN"] = "Auchindoun"
L["DUNGEON_SKYREACH"] = "Orée-du-Ciel"
L["DUNGEON_UPPER_BLACKROCK_SPIRE"] = "Sommet du pic Rochenoire"
L["DUNGEON_GRIMRAIL_DEPOT"] = "Dépôt de Tristerail"
L["DUNGEON_IRON_DOCKS"] = "Quais de Fer"

-- Donjons Legion
L["DUNGEON_DARKHEART_THICKET"] = "Fourré Sombrecœur"
L["DUNGEON_BLACK_ROOK_HOLD"] = "Bastion du Freux"
L["DUNGEON_HALLS_OF_VALOR"] = "Salles des Valeureux"
L["DUNGEON_NELTHARIONS_LAIR"] = "Repaire de Neltharion"
L["DUNGEON_COURT_OF_STARS"] = "Cour des Étoiles"
L["DUNGEON_KARAZHAN"] = "Karazhan"

-- Donjons Battle for Azeroth
L["DUNGEON_ATALDAZAR"] = "Atal'Dazar"
L["DUNGEON_FREEHOLD"] = "Port-Liberté"
L["DUNGEON_WAYCREST_MANOR"] = "Manoir Malvoie"
L["DUNGEON_THE_UNDERROT"] = "Tréfonds Putrides"
L["DUNGEON_MECHAGON"] = "Opération Mécagone"
L["DUNGEON_SIEGE_OF_BORALUS"] = "Siège de Boralus"
L["DUNGEON_THE_MOTHERLOAD"] = "Le Filon"

-- Donjons et Raids Shadowlands
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

-- Donjons et Raids Dragonflight
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

-- Donjons et Raids The War Within
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

-- Objets Pierre de foyer spéciaux
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

-- === CHAÎNES D'INTERFACE UTILISATEUR ===
-- Éléments d'interface principaux et texte d'interaction utilisateur

-- Éléments d'interface généraux
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

-- Système de favoris
L["FAVORITES"] = "Favoris"

-- === OPTIONS DE CONFIGURATION ===
-- Étiquettes de l'interface des paramètres et préférences

-- Options d'affichage
L["SHOW_LOGIN_MESSAGE"] = "Afficher le message de connexion"
L["AUTO_CLOSE"] = "Fermer auto. l'adddon lors du TP"
L["SHOW_CURRENT_SEASON"] = "Afficher la saison actuelle"
L["SHOW_HEARTHSTONES"] = "Afficher les pierres de foyer"
L["SHOW_UNLEARNED_SPELLS"] = "Afficher les sorts non appris"
L["SHOW_SPELL_TOOLTIPS"] = "Afficher les infobulles des sorts"
L["SHOW_LFG_TAB"] = "Afficher le bouton dans la rech. de groupe"

-- Onglets d'interface
L["OPTIONS_TAB"] = "Options"
L["CATEGORIES_TAB"] = "Catégories"

-- Configuration des pierres de foyer
L["USE_RANDOM_HEARTHSTONE_VARIANT"] = "Utiliser une variante aléatoire"
L["NO_HEARTHSTONE_VARIANTS"] = "Aucun variant possédé"

-- Gestion des catégories
L["REVERSE_EXPANSION_ORDER"] = "Inverser l'ordre des extensions"
L["CATEGORIES_ORDER_HEADER"] = "Ordre des catégories"

-- En-têtes des sections d'options
L["DISPLAY_HEADER"] = "Affichage"
L["BEHAVIOR_HEADER"] = "Comportement"
L["HEARTHSTONE_HEADER"] = "Pierre de foyer"

-- === MESSAGES DE RETOUR UTILISATEUR ===
-- Notifications système et mises à jour de statut
L["MSG_LOGIN_MESSAGE_ENABLED"] = "Message de connexion activé"
L["MSG_LOGIN_MESSAGE_DISABLED"] = "Message de connexion désactivé"