-- Traditional Chinese localization for QuickTravel addon by BlueNightSky
-- Complete translation set maintaining consistency with English base
-- All strings translated to provide native Traditional Chinese user experience

local L = select(2, ...).L('zhTW')

-- === CORE ADDON IDENTITY ===
L["QT_TITLE"] = "快速傳送"

-- === EXPANSION CATEGORIES ===
-- World of Warcraft expansion names for UI organization
L["Cataclysm"] = "浩劫與重生"
L["Mists of Pandaria"] = "潘達利亞之謎"
L["Warlords of Draenor"] = "德拉諾之霸"
L["Legion"] = "軍臨天下"
L["Battle for Azeroth"] = "決戰艾澤拉斯"
L["Shadowlands"] = "暗影之境"
L["Dragonflight"] = "巨龍崛起"
L["The War Within"] = "地心之戰"
L["Current Season"] = "當前賽季"
L["Hearthstones"] = "爐石"
L["HEARTHSTONE_RANDOM_VARIANT"] = "爐石 (隨機變化)"
L["Wormhole Generator"] = "Wormhole Generator"

-- === DUNGEON AND RAID LOCATIONS BY EXPANSION ===
-- Organized chronologically by expansion for easy maintenance

-- Cataclysm Dungeons
L["DUNGEON_VORTEX_PINNACLE"] = "漩渦尖塔" --5035
L["DUNGEON_THRONE_OF_THE_TIDES"] = "海潮王座" --5004
L["DUNGEON_GRIM_BATOL"] = "格瑞姆巴托" --4950

-- Mists of Pandaria Dungeons
L["DUNGEON_TEMPLE_OF_THE_JADE_SERPENT"] = "玉蛟寺" --5956
L["DUNGEON_SIEGE_OF_NIUZAO"] = "圍攻怒兆寺" --6214
L["DUNGEON_SCHOLOMANCE"] = "通靈學院" --2057
L["DUNGEON_SCARLET_MONASTERY"] = "血色修道院" --6109
L["DUNGEON_SCARLET_HALLS"] = "血色大廳" --6052
L["DUNGEON_GATE_OF_THE_SETTING_SUN"] = "落陽關" --5976
L["DUNGEON_MOGUSHAN_PALACE"] = "魔古山宮" --6182
L["DUNGEON_SHADO_PAN_MONASTERY"] = "影潘僧院" --5918
L["DUNGEON_STORMSTOUT_BREWERY"] = "風暴烈酒酒坊" --5963

-- Warlords of Draenor Dungeons
L["DUNGEON_SHADOWMOON_BURIAL_GROUNDS"] = "影月墓地" --6932
L["DUNGEON_EVERBLOOM"] = "永茂林" --7109
L["DUNGEON_BLOODMAUL_SLAG_MINES"] = "血槌熔渣礦場" --6874
L["DUNGEON_AUCHINDOUN"] = "奧齊頓" --6912
L["DUNGEON_SKYREACH"] = "擎天峰" --6988
L["DUNGEON_UPPER_BLACKROCK_SPIRE"] = "黑石塔上層" --7307
L["DUNGEON_GRIMRAIL_DEPOT"] = "恐軌車站" --6984
L["DUNGEON_IRON_DOCKS"] = "鋼鐵碼頭" --6951

-- Legion Dungeons
L["DUNGEON_DARKHEART_THICKET"] = "暗心灌木林" --7673
L["DUNGEON_BLACK_ROOK_HOLD"] = "玄鴉堡" --7805
L["DUNGEON_HALLS_OF_VALOR"] = "英靈殿" --7672
L["DUNGEON_NELTHARIONS_LAIR"] = "奈薩里奧巢穴" --7546
L["DUNGEON_COURT_OF_STARS"] = "眾星之廷" --8079
L["DUNGEON_KARAZHAN"] = "重返卡拉贊" --8443

-- Battle for Azeroth Dungeons
L["DUNGEON_ATALDAZAR"] = "阿塔達薩" --9028
L["DUNGEON_FREEHOLD"] = "自由港" --9164
L["DUNGEON_WAYCREST_MANOR"] = "威奎斯特莊園" --9424
L["DUNGEON_THE_UNDERROT"] = "幽腐深窟" --9391
L["DUNGEON_MECHAGON"] = "機械岡行動" --10225
L["DUNGEON_SIEGE_OF_BORALUS"] = "波拉勒斯圍城戰" --9354
L["DUNGEON_THE_MOTHERLOAD"] = "晶喜鎮！" --8064

-- Shadowlands Dungeons and Raids
L["DUNGEON_THE_NECROTIC_WAKE"] = "死靈戰地" --12916
L["DUNGEON_PLAGUEFALL"] = "瘟疫之臨" --13228
L["DUNGEON_MISTS_OF_TIRNA_SCITHE"] = "特拉希迷霧" --13334
L["DUNGEON_HALLS_OF_ATONEMENT"] = "贖罪之殿" --12831
L["DUNGEON_SPIRES_OF_ASCENSION"] = "晉升之巔" --12837
L["DUNGEON_THEATRE_OF_PAIN"] = "苦痛劇場" --12841
L["DUNGEON_DE_OTHER_SIDE"] = "彼界境地" --13309
L["DUNGEON_SANGUINE_DEPTHS"] = "血紅深淵" --12842
L["DUNGEON_TAZAVESH_THE_VEILED_MARKET"] = "帷幕市集：塔扎維許" --13577
L["RAID_CASTLE_NATHRIA"] = "納撒亞城" --13224
L["RAID_SANCTUM_OF_DOMINATION"] = "統御之座" --13561
L["RAID_SEPULCHER_OF_THE_FIRST_ONES"] = "首創者聖塚" --13742

-- Dragonflight Dungeons and Raids
L["DUNGEON_RUBY_LIFE_POOLS"] = "晶紅生命之池" --14063
L["DUNGEON_NOKHUD_OFFENSIVE"] = "諾庫德進攻據點" --13982
L["DUNGEON_AZURE_VAULT"] = "蒼藍密庫" --13954
L["DUNGEON_ALGETHAR_ACADEMY"] = "阿爾蓋薩學院" --14032
L["DUNGEON_ULDAMAN"] = "奧達曼：提爾的遺產" -- 16278 (achievement)
L["DUNGEON_NELTHARUS"] = "奈薩魯斯堡" --14011
L["DUNGEON_BRACKENHIDE_HOLLOW"] = "蕨皮谷" --13991
L["DUNGEON_HALLS_OF_INFUSION"] = "灌注迴廊" --14082
L["DUNGEON_DAWN_OF_THE_INFINITE"] = "恆龍黎明" --14514
L["RAID_VAULT_OF_THE_INCARNATES"] = "洪荒化身牢獄" --14030
L["RAID_ABBERUS_THE_SHADOWED_CRUCIBLE"] = "『朧影實驗場』亞貝魯斯" --14663
L["RAID_AMIRDRASSIL_THE_DREAMS_HOPE"] = "『夢境希望』埃達希爾" --14643

-- The War Within Dungeons and Raids
L["DUNGEON_CITY_OF_THREADS"] = "蛛絲城" --14753
L["DUNGEON_ARA_KARA_CITY_OF_ECHOS"] = "『回音之城』厄拉卡拉" --15093
L["DUNGEON_STONEVAULT"] = "石庫" --14883
L["DUNGEON_DAWNBREAKER"] = "破曉者號" --14971
L["DUNGEON_THE_ROOKERY"] = "培育所" --14938
L["DUNGEON_DARKFLAME_CLEFT"] = "暗焰裂縫" --14882
L["DUNGEON_CINDERBREW_MEADERY"] = "燼釀酒裝" --15103
L["DUNGEON_PRIORY_OF_THE_SACRED_FLAME"] = "聖焰隱修院" --14954
L["DUNGEON_OPERATION_FLOODGATE"] = "水閘行動" --15452
L["DUNGEON_ECO_DOME_AL_DANI"] = "艾達尼秘境" --16104
L["RAID_LIBERATION_OF_UNDERMINE"] = "解放幽坑城" --15522
L["RAID_MANAFORGE_OMEGA"] = "法力熔爐歐美加" --16178

-- Special Hearthstone Items
L["HEARTHSTONE_DALARAN"] = "達拉然爐石"
L["HEARTHSTONE_GARRISON"] = "要塞爐石"

-- === HEARTHSTONE VARIANTS ===
L["HEARTHSTONE_VARIANT_DEFAULT"] = "爐石"
L["HEARTHSTONE_VARIANT_54452"] = "Ethereal Portal"
L["HEARTHSTONE_VARIANT_64488"] = "旅店老闆的女兒"
L["HEARTHSTONE_VARIANT_93672"] = "Dark Portal"
L["HEARTHSTONE_VARIANT_142542"] = "城鎮傳送之書"
L["HEARTHSTONE_VARIANT_162973"] = "冬天爺爺的爐石"
L["HEARTHSTONE_VARIANT_163045"] = "無頭騎士的爐石"
L["HEARTHSTONE_VARIANT_165669"] = "新年長者的爐石"
L["HEARTHSTONE_VARIANT_165670"] = "傳播者充滿愛的爐石"
L["HEARTHSTONE_VARIANT_165802"] = "貴族園丁的爐石"
L["HEARTHSTONE_VARIANT_166746"] = "吞火者的爐石"
L["HEARTHSTONE_VARIANT_166747"] = "啤酒節狂歡者的爐石"
L["HEARTHSTONE_VARIANT_168907"] = "全像數位化爐石"
L["HEARTHSTONE_VARIANT_172179"] = "永恆旅人的爐石"
L["HEARTHSTONE_VARIANT_180290"] = "暗夜妖精的爐石"
L["HEARTHSTONE_VARIANT_182773"] = "死靈領主爐石"
L["HEARTHSTONE_VARIANT_183716"] = "汎希爾罪孽石"
L["HEARTHSTONE_VARIANT_184353"] = "琪瑞安爐石"
L["HEARTHSTONE_VARIANT_188952"] = "統御的爐石"
L["HEARTHSTONE_VARIANT_190196"] = "受啟迪的爐石"
L["HEARTHSTONE_VARIANT_190237"] = "仲介者傳送矩陣"
L["HEARTHSTONE_VARIANT_193588"] = "時光行者的爐石"
L["HEARTHSTONE_VARIANT_200630"] = "雍伊爾風之賢者爐石"
L["HEARTHSTONE_VARIANT_206195"] = "納魯之道"
L["HEARTHSTONE_VARIANT_208704"] = "深淵居者的大地爐石"
L["HEARTHSTONE_VARIANT_209035"] = "烈焰爐石"
L["HEARTHSTONE_VARIANT_212337"] = "爐石之石"
L["HEARTHSTONE_VARIANT_228940"] = "兇霸絲線爐石"
L["HEARTHSTONE_VARIANT_235016"] = "再部署模組"
L["HEARTHSTONE_VARIANT_236687"] = "爆炸爐石"

-- Wormhole Generator
L["WORMHOLE_GENERATOR_NORTHREND"] = "Northrend"
L["WORMHOLE_GENERATOR_PANDARIA"] = "Pandaria"
L["WORMHOLE_GENERATOR_ARGUS"] = "Argus"
L["WORMHOLE_GENERATOR_ZANDALAR"] = "Zandalar"
L["WORMHOLE_GENERATOR_KUL_TIRAS"] = "Kul Tiras"
L["WORMHOLE_GENERATOR_SHADOWLANDS"] = "Shadowlands"
L["WORMHOLE_GENERATOR_DRAGON_ISLES"] = "Dragon Isles"
L["WORMHOLE_GENERATOR_KHAZ_ALGAR"] = "Khaz Algar"

-- === USER INTERFACE STRINGS ===
-- Core interface elements and user interaction text

-- General UI Elements
L["SEARCH"] = "搜尋..."
L["CLICK_TO_TELEPORT"] = "點擊來傳送"
L["CLICK_TO_USE"] = "點擊來使用"
L["NO_CATEGORIES_SELECTED"] = "沒有選擇的類別"
L["NO_SEARCH_RESULTS"] = "此搜尋沒有結果。"
L["LOADED"] = "已載入！使用 /qt 來開啟。"
L["RIGHT_CLICK_ADD_FAVORITE"] = "右鍵點擊加入到最愛"
L["RIGHT_CLICK_REMOVE_FAVORITE"] = "右鍵點擊從最愛移除"
L["TOGGLE_QUICKTRAVEL"] = "切換 QuickTravel"
L["SPELL_NOT_LEARNED"] = "法術尚未學得"
L["TOY_NOT_OWNED"] = "玩具尚未擁有"
L["LFG_TAB_PORTALS"] = "傳送門"
L["RANDOM_VARIANT_TOOLTIP"] = "一個隨機變化爐石將被使用"

-- Favorites System
L["FAVORITES"] = "最愛"

-- === CONFIGURATION OPTIONS ===
-- Settings and preferences interface labels

-- Display Options
L["SHOW_LOGIN_MESSAGE"] = "顯示登入訊息"
L["AUTO_CLOSE"] = "當施法時自動關閉插件"
L["SHOW_CURRENT_SEASON"] = "顯示當前賽季"
L["SHOW_HEARTHSTONES"] = "顯示爐石"
L["SHOW_UNLEARNED_SPELLS"] = "顯示未學得法術"
L["SHOW_SPELL_TOOLTIPS"] = "顯示法術提示"
L["SHOW_LFG_TAB"] = "在尋求組隊顯示按鈕"
L["LOCK_FRAME_HEIGHT"] = "鎖定框架高度"

-- Interface Tabs
L["OPTIONS_TAB"] = "選項"
L["CATEGORIES_TAB"] = "類別"

-- Hearthstone Configuration
L["USE_RANDOM_HEARTHSTONE_VARIANT"] = "使用隨機爐石變化"
L["NO_HEARTHSTONE_VARIANTS"] = "沒有爐石變體"

-- Category Management
L["REVERSE_EXPANSION_ORDER"] = "反向資料片順序"
L["CATEGORIES_ORDER_HEADER"] = "類別順序"

-- Options Section Headers
L["DISPLAY_HEADER"] = "顯示"
L["BEHAVIOR_HEADER"] = "動作"
L["HEARTHSTONE_HEADER"] = "爐石"

-- === USER FEEDBACK MESSAGES ===
-- System notifications and status updates
L["MSG_LOGIN_MESSAGE_ENABLED"] = "登入訊息已啟用"
L["MSG_LOGIN_MESSAGE_DISABLED"] = "登入訊息已停用"