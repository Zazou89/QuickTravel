-- Russian localization for QuickTravel addon by Hollicsh
-- Complete translation set maintaining consistency with English base
-- All strings translated to provide native Russian user experience

local L = select(2, ...).L('ruRU')

-- === CORE ADDON IDENTITY ===
L["QT_TITLE"] = "Быстрая телепортация"

-- === EXPANSION CATEGORIES ===
-- World of Warcraft expansion names for UI organization
L["Cataclysm"] = "Катаклизм"
L["Mists of Pandaria"] = "Пандария"
L["Warlords of Draenor"] = "Дренор"
L["Legion"] = "Легион"
L["Battle for Azeroth"] = "Битва за Азерот"
L["Shadowlands"] = "Темные Земли"
L["Dragonflight"] = "Драконы"
L["The War Within"] = "Война Внутри"
L["Current Season"] = "Текущий сезон"
L["Hearthstones"] = "Камни возвращений"
L["HEARTHSTONE_RANDOM_VARIANT"] = "Камень возвращения (случайный вариант)"
L["Wormhole Generator"] = "Генератор червоточин"
L["Mage Teleport"] = "Телепортация магов"
L["Mage Portal"] = "Портал магов"

-- === DUNGEON AND RAID LOCATIONS BY EXPANSION ===
-- Organized chronologically by expansion for easy maintenance

-- Cataclysm Dungeons
L["DUNGEON_VORTEX_PINNACLE"] = "Вершина Смерча" --5035
L["DUNGEON_THRONE_OF_THE_TIDES"] = "Трон Приливов" --5004
L["DUNGEON_GRIM_BATOL"] = "Грим Батол" --4950

-- Mists of Pandaria Dungeons
L["DUNGEON_TEMPLE_OF_THE_JADE_SERPENT"] = "Храм Нефритовой Змеи" --5956
L["DUNGEON_SIEGE_OF_NIUZAO"] = "Осада храма Нюцзао" --6214
L["DUNGEON_SCHOLOMANCE"] = "Некроситет" --2057
L["DUNGEON_SCARLET_MONASTERY"] = "Монастырь Алого ордена" --6109
L["DUNGEON_SCARLET_HALLS"] = "Залы Алого ордена" --6052
L["DUNGEON_GATE_OF_THE_SETTING_SUN"] = "Врата Заходящего Солнца" --5976
L["DUNGEON_MOGUSHAN_PALACE"] = "Дворец Могу'шан" --6182
L["DUNGEON_SHADO_PAN_MONASTERY"] = "Монастырь Шадо-Пан" --5918
L["DUNGEON_STORMSTOUT_BREWERY"] = "Хмелеварня Буйных Портеров" --5963

-- Warlords of Draenor Dungeons
L["DUNGEON_SHADOWMOON_BURIAL_GROUNDS"] = "Некрополь Призрачной Луны" --6932
L["DUNGEON_EVERBLOOM"] = "Вечное Цветение" --7109
L["DUNGEON_BLOODMAUL_SLAG_MINES"] = "Шлаковые шахты Кровавого Молота" --6874
L["DUNGEON_AUCHINDOUN"] = "Аукиндон" --6912
L["DUNGEON_SKYREACH"] = "Небесный Путь" --6988
L["DUNGEON_UPPER_BLACKROCK_SPIRE"] = "Верхняя часть пика Черной горы" --7307
L["DUNGEON_GRIMRAIL_DEPOT"] = "Депо Мрачных Путей" --6984
L["DUNGEON_IRON_DOCKS"] = "Железные доки" --6951

-- Legion Dungeons
L["DUNGEON_DARKHEART_THICKET"] = "Чаща Темного Сердца" --7673
L["DUNGEON_BLACK_ROOK_HOLD"] = "Крепость Черной Ладьи" --7805
L["DUNGEON_HALLS_OF_VALOR"] = "Чертоги Доблести" --7672
L["DUNGEON_NELTHARIONS_LAIR"] = "Логово Нелтариона" --7546
L["DUNGEON_COURT_OF_STARS"] = "Квартал Звезд" --8079
L["DUNGEON_KARAZHAN"] = "Возвращение в Каражан" --8443

-- Battle for Azeroth Dungeons
L["DUNGEON_ATALDAZAR"] = "Атал'Дазар" --9028
L["DUNGEON_FREEHOLD"] = "Вольная Гавань" --9164
L["DUNGEON_WAYCREST_MANOR"] = "Усадьба Уэйкрестов" --9424
L["DUNGEON_THE_UNDERROT"] = "Подгнилье" --9391
L["DUNGEON_MECHAGON"] = "Операция: Мехагон" --10225
L["DUNGEON_SIEGE_OF_BORALUS"] = "Осада Боралуса" --9354
L["DUNGEON_THE_MOTHERLOAD"] = "ЗОЛОТАЯ ЖИЛА!!!" --8064

-- Shadowlands Dungeons and Raids
L["DUNGEON_THE_NECROTIC_WAKE"] = "Смертельная тризна" --12916
L["DUNGEON_PLAGUEFALL"] = "Чумные каскады" --13228
L["DUNGEON_MISTS_OF_TIRNA_SCITHE"] = "Туманы Тирна Скитта" --13334
L["DUNGEON_HALLS_OF_ATONEMENT"] = "Чертоги Покаяния" --12831
L["DUNGEON_SPIRES_OF_ASCENSION"] = "Шпили Перерождения" --12837
L["DUNGEON_THEATRE_OF_PAIN"] = "Театр Боли" --12841
L["DUNGEON_DE_OTHER_SIDE"] = "Та Сторона" --13309
L["DUNGEON_SANGUINE_DEPTHS"] = "Кровавые катакомбы" --12842
L["DUNGEON_TAZAVESH_THE_VEILED_MARKET"] = "Тайный рынок Тазавеш" --13577
L["RAID_CASTLE_NATHRIA"] = "Замок Нафрия" --13224
L["RAID_SANCTUM_OF_DOMINATION"] = "Святилище Господства" --13561
L["RAID_SEPULCHER_OF_THE_FIRST_ONES"] = "Гробница Предвечных" --13742

-- Dragonflight Dungeons and Raids
L["DUNGEON_RUBY_LIFE_POOLS"] = "Рубиновые Омуты Жизни" --14063
L["DUNGEON_NOKHUD_OFFENSIVE"] = "Наступление клана Нокхуд" --13982
L["DUNGEON_AZURE_VAULT"] = "Лазурное хранилище" --13954
L["DUNGEON_ALGETHAR_ACADEMY"] = "Академия Алгет'ар" --14032
L["DUNGEON_ULDAMAN"] = "Ульдаман: наследие Тира" -- 16278 (achievement)
L["DUNGEON_NELTHARUS"] = "Нелтарий" --14011
L["DUNGEON_BRACKENHIDE_HOLLOW"] = "Лощина Бурошкуров" --13991
L["DUNGEON_HALLS_OF_INFUSION"] = "Чертоги Насыщения" --14082
L["DUNGEON_DAWN_OF_THE_INFINITE"] = "Рассвет Бесконечности" --14514
L["RAID_VAULT_OF_THE_INCARNATES"] = "Хранилище Воплощений" --14030
L["RAID_ABBERUS_THE_SHADOWED_CRUCIBLE"] = "Аберрий, Затененное Горнило" --14663
L["RAID_AMIRDRASSIL_THE_DREAMS_HOPE"] = "Амирдрассил, Надежда Сна" --14643

-- The War Within Dungeons and Raids
L["DUNGEON_CITY_OF_THREADS"] = "Город Нитей" --14753
L["DUNGEON_ARA_KARA_CITY_OF_ECHOS"] = "Ара-Кара, Город Отголосков" --15093
L["DUNGEON_STONEVAULT"] = "Каменный Свод" --14883
L["DUNGEON_DAWNBREAKER"] = "Сияющий Рассвет" --14971
L["DUNGEON_THE_ROOKERY"] = "Гнездовье" --14938
L["DUNGEON_DARKFLAME_CLEFT"] = "Расселина Темного Пламени" --14882
L["DUNGEON_CINDERBREW_MEADERY"] = "Искроварня" --15103
L["DUNGEON_PRIORY_OF_THE_SACRED_FLAME"] = "Приорат Священного Пламени" --14954
L["DUNGEON_OPERATION_FLOODGATE"] = "Операция: Шлюз" --15452
L["DUNGEON_ECO_DOME_AL_DANI"] = "Заповедник Аль'дани" --16104
L["RAID_LIBERATION_OF_UNDERMINE"] = "Освобождение Нижней Шахты" --15522
L["RAID_MANAFORGE_OMEGA"] = "Манагорн Омега" --16178

-- Special Hearthstone Items
L["HEARTHSTONE_DALARAN"] = "Камень возвращения в Даларан"
L["HEARTHSTONE_GARRISON"] = "Камень возвращения в гарнизон"

-- === HEARTHSTONE VARIANTS ===
L["HEARTHSTONE_VARIANT_DEFAULT"] = "Камень возвращения"
L["HEARTHSTONE_VARIANT_54452"] = "Эфириальный портал"
L["HEARTHSTONE_VARIANT_64488"] = "Дочь трактирщика"
L["HEARTHSTONE_VARIANT_93672"] = "Темный портал"
L["HEARTHSTONE_VARIANT_142542"] = "Фолиант возвращения"
L["HEARTHSTONE_VARIANT_162973"] = "Камень возвращения Дедушки Зимы"
L["HEARTHSTONE_VARIANT_163045"] = "Камень возвращения Всадника без головы"
L["HEARTHSTONE_VARIANT_165669"] = "Камень возвращения Лунного предка"
L["HEARTHSTONE_VARIANT_165670"] = "Камушек возвращения Мелкошустра"
L["HEARTHSTONE_VARIANT_165802"] = "Камень возвращения чудесного садовника"
L["HEARTHSTONE_VARIANT_166746"] = "Камень возвращения огнеглотателя"
L["HEARTHSTONE_VARIANT_166747"] = "Камень возвращения гуляки Хмельного фестиваля"
L["HEARTHSTONE_VARIANT_168907"] = "Голографизирующий камень возвращения"
L["HEARTHSTONE_VARIANT_172179"] = "Камень возвращения вечного путника"
L["HEARTHSTONE_VARIANT_180290"] = "Арденвельдский камень возвращения"
L["HEARTHSTONE_VARIANT_182773"] = "Камень возвращения некролордов"
L["HEARTHSTONE_VARIANT_183716"] = "Вентирский камень грехов"
L["HEARTHSTONE_VARIANT_184353"] = "Кирийский камень возвращения"
L["HEARTHSTONE_VARIANT_188952"] = "Подчиненный камень возвращения"
L["HEARTHSTONE_VARIANT_190196"] = "Камень возвращения Просветленных"
L["HEARTHSTONE_VARIANT_190237"] = "Брокерская матрица транслокации"
L["HEARTHSTONE_VARIANT_193588"] = "Камень возвращения Дозорного Времени"
L["HEARTHSTONE_VARIANT_200630"] = "Камень возвращения он'ирского жреца ветра"
L["HEARTHSTONE_VARIANT_206195"] = "Путь наару"
L["HEARTHSTONE_VARIANT_208704"] = "Камень возвращения земных недр"
L["HEARTHSTONE_VARIANT_209035"] = "Огненный камень возвращения"
L["HEARTHSTONE_VARIANT_212337"] = "Возвращающий камень"
L["HEARTHSTONE_VARIANT_228940"] = "Камень возвращения отъявленных нитей"
L["HEARTHSTONE_VARIANT_235016"] = "Модуль передислокации"
L["HEARTHSTONE_VARIANT_236687"] = "Взрывной камень возвращения"
L["HEARTHSTONE_VARIANT_245970"] = "Скорый камень возвращения ПОЧТ-мейстера"
L["HEARTHSTONE_VARIANT_246565"] = "Космический камень возвращения"
L["HEARTHSTONE_VARIANT_210455"] = "Дренейский голографоцвет"

-- Wormhole Generator
L["ULTRASAFE_TRANSPORTER_GADGETZAN"] = "Прибамбасск"
L["ULTRASAFE_TRANSPORTER_TOSHLEYS_STATION"] = "Запределье"
L["WORMHOLE_GENERATOR_NORTHREND"] = "Нордскол"
L["WORMHOLE_GENERATOR_PANDARIA"] = "Пандария"
L["WORMHOLE_GENERATOR_ARGUS"] = "Аргус"
L["WORMHOLE_GENERATOR_ZANDALAR"] = "Зандалар"
L["WORMHOLE_GENERATOR_KUL_TIRAS"] = "Кул-Тирас"
L["WORMHOLE_GENERATOR_SHADOWLANDS"] = "Темные Земли"
L["WORMHOLE_GENERATOR_DRAGON_ISLES"] = "Драконьи острова"
L["WORMHOLE_GENERATOR_KHAZ_ALGAR"] = "Каз Алгар"

-- Mage Teleport
L["MAGE_TELEPORT_HALL_OF_THE_GUARDIAN"] = "Оплот Хранителя" --193759
L["MAGE_TELEPORT_STORMWIND"] = "Штормград" --3561
L["MAGE_TELEPORT_IRONFORGE"] = "Стальгорн" --3562
L["MAGE_TELEPORT_DARNASSUS"] = "Дарнас" --3565
L["MAGE_TELEPORT_EXODAR"] = "Экзодар" --32271
L["MAGE_TELEPORT_THERAMORE"] = "Терамор" --49359

L["MAGE_TELEPORT_ORGRIMMAR"] = "Оргриммар" --3567
L["MAGE_TELEPORT_UNDERCITY"] = "Подгород" --3563
L["MAGE_TELEPORT_THUNDER_BLUFF"] = "Громовой Утес" --3566
L["MAGE_TELEPORT_SILVERMOON_CITY"] = "Луносвет" --32272
L["MAGE_TELEPORT_STONARD"] = "Каменор" --49358

L["MAGE_TELEPORT_SHATTRATH"] = "Шаттрат" --33690/35715
L["MAGE_TELEPORT_DALARAN"] = "Даларан (Нордскол)" --53140
L["MAGE_TELEPORT_TOL_BARAD"] = "Тол Барад" --88342/88344
L["MAGE_TELEPORT_VALE_OF_ETERNAL_BLOSSOMS"] = "Вечноцветущий дол" --132621/132627

L["MAGE_TELEPORT_STORMSHIELD"] = "Преграда Ветров" --176248
L["MAGE_TELEPORT_WARSPEAR"] = "Копье Войны" --176242

L["MAGE_TELEPORT_DALARAN_BROKEN_ISLES"] = "Даларан (Расколотые острова)" --224869
L["MAGE_TELEPORT_BORALUS"] = "Боралус" --281403
L["MAGE_TELEPORT_DAZAR_ALOR"] = "Дазар'алор" --281404
L["MAGE_TELEPORT_ORIBOS"] = "Орибос" --344587
L["MAGE_TELEPORT_VALDRAKKEN"] = "Вальдраккен" --395277
L["MAGE_TELEPORT_DORNOGAL"] = "Дорногал" --446540

-- Mage Portal
L["MAGE_PORTAL_STORMWIND"] = "Штормград" --10059
L["MAGE_PORTAL_IRONFORGE"] = "Стальгорн" --11416
L["MAGE_PORTAL_DARNASSUS"] = "Дарнас" --11419
L["MAGE_PORTAL_EXODAR"] = "Экзодар" --32266
L["MAGE_PORTAL_THERAMORE"] = "Терамор" --49360

L["MAGE_PORTAL_ORGRIMMAR"] = "Оргриммар" --11417
L["MAGE_PORTAL_UNDERCITY"] = "Подгород" --11418
L["MAGE_PORTAL_THUNDER_BLUFF"] = "Громовой Утес" --11420
L["MAGE_PORTAL_SILVERMOON_CITY"] = "Луносвет" --32267
L["MAGE_PORTAL_STONARD"] = "Каменор" --49361

L["MAGE_PORTAL_SHATTRATH"] = "Шаттрат" -- 33691/35717
L["MAGE_PORTAL_DALARAN"] = "Даларан (Нордскол)" --53142
L["MAGE_PORTAL_TOL_BARAD"] = "Тол Барад" -- 88345/88346
L["MAGE_PORTAL_VALE_OF_ETERNAL_BLOSSOMS"] = "Вечноцветущий дол" -- 132620/132626

L["MAGE_PORTAL_STORMSHIELD"] = "Преграда Ветров" --176246
L["MAGE_PORTAL_WARSPEAR"] = "Копье Войны" --176244

L["MAGE_PORTAL_DALARAN_BROKEN_ISLES"] = "Даларан (Расколотые острова)" --224871
L["MAGE_PORTAL_BORALUS"] = "Боралус" --281400
L["MAGE_PORTAL_DAZAR_ALOR"] = "Дазар'алор" --281402
L["MAGE_PORTAL_ORIBOS"] = "Орибос" --344597
L["MAGE_PORTAL_VALDRAKKEN"] = "Вальдраккен" --395289
L["MAGE_PORTAL_DORNOGAL"] = "Дорногал" --446534

-- === USER INTERFACE STRINGS ===
-- Core interface elements and user interaction text

-- General UI Elements
L["SEARCH"] = "Поиск..."
L["CLICK_TO_TELEPORT"] = "Нажмите, чтобы телепортироваться"
L["CLICK_TO_USE"] = "Нажмите, чтобы использовать"
L["NO_CATEGORIES_SELECTED"] = "Категории не выбраны"
L["NO_SEARCH_RESULTS"] = "Ничего не найдено."
L["LOADED"] = "загружено! Используйте /qt, чтобы открыть."
L["RIGHT_CLICK_ADD_FAVORITE"] = "ПКМ - добавить в избранное"
L["RIGHT_CLICK_REMOVE_FAVORITE"] = "ПКМ - удалить из избранного"
L["TOGGLE_QUICKTRAVEL"] = "Вкл./выкл. QuickTravel"
L["SPELL_NOT_LEARNED"] = "Заклинание не изучено"
L["TOY_NOT_OWNED"] = "Нет такой игрушки"
L["LFG_TAB_PORTALS"] = "Порталы"
L["RANDOM_VARIANT_TOOLTIP"] = "Будет использован случайный вариант Камня возвращения"

-- Favorites System
L["FAVORITES"] = "Избранное"

-- === CONFIGURATION OPTIONS ===
-- Settings and preferences interface labels

-- Display Options
L["SHOW_LOGIN_MESSAGE"] = "Показывать сообщение при входе"
L["AUTO_CLOSE"] = "Автоматически закрывать окно аддона\nво время произнесения заклинания"
L["SHOW_CURRENT_SEASON"] = "Показывать текущий сезон"
L["SHOW_HEARTHSTONES"] = "Показывать Камни возвращений"
L["SHOW_UNLEARNED_SPELLS"] = "Показывать неизученные заклинания"
L["SHOW_SPELL_TOOLTIPS"] = "Показывать подсказки заклинаний"
L["SHOW_LFG_TAB"] = "Показывать кнопку в поиске групп"
L["LOCK_FRAME_HEIGHT"] = "Блокировать высоту фрейма"
L["SHOW_MINIMAP_ICON"] = "Показывать иконку на миникарте"

-- Interface Tabs
L["OPTIONS_TAB"] = "Настройки"
L["CATEGORIES_TAB"] = "Категории"

-- Hearthstone Configuration
L["USE_RANDOM_HEARTHSTONE_VARIANT"] = "Использовать случайный вариант\nКамня возвращения"
L["NO_HEARTHSTONE_VARIANTS"] = "Нет собственных вариантов"

-- Category Management
L["REVERSE_EXPANSION_ORDER"] = "Обратный порядок контента WoW"
L["CATEGORIES_ORDER_HEADER"] = "Порядок категорий"

-- Options Section Headers
L["DISPLAY_HEADER"] = "Отображение"
L["BEHAVIOR_HEADER"] = "Режим"
L["HEARTHSTONE_HEADER"] = "Камень возвращения"

-- === USER FEEDBACK MESSAGES ===
-- System notifications and status updates
L["MSG_LOGIN_MESSAGE_ENABLED"] = "Сообщение при входе включено"
L["MSG_LOGIN_MESSAGE_DISABLED"] = "Сообщение при входе отключено"
