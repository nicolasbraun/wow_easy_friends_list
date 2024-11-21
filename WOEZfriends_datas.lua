-- -----------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locales

ns.datas,ns.functions,ns.frames = {},{},{}

-- -----------------------------------------------------------------------------
-- ✔︎ INIT
-- -----------------------------------------------------------------------------

-- ns.datas.version    = GetAddOnMetadata(ADDON_NAME, "Version")
ns.datas.PRINT      = "|cffffffffWF ::|r "
ns.datas.PRINTS     = "|cff1ced6b:: |cffffffffWOEZ FRIENDS|r :: |cff1ced6b"
ns.datas.FOLDR      = "Interface\\AddOns\\WO_ezfriendslist\\"
ns.datas.FOLDRFF    = "Interface\\FriendsFrame\\"
ns.datas.FOLDRCF	= "Interface\\CHATFRAME\\UI-ChatIcon-"
ns.datas.DEBUG      = false
ns.datas.FAKE       = false
ns.datas.LOAD       = false
ns.datas.Class 		= {}
ns.datas.All_friends= {}
ns.datas.All_groups = { g = {}, f = {} }
ns.datas.search  	= false

ns.datas.isOpen     = false
ns.datas.LDBisOver  = false
ns.datas.LDB  		= false
ns.datas.TXTUP      = "..."

ns.datas.NB_BN_friends  	= 0
ns.datas.NB_BN_friends_on 	= 0
ns.datas.NB_IG_friends  	= 0
ns.datas.NB_IG_friends_on 	= 0

ns.datas.NB_friends  		= 0
ns.datas.NB_friends_on 		= 0

ns.datas.NB_guildies  		= 0
ns.datas.NB_guildies_on 	= 0

ns.datas.maxlvl  = 60
ns.datas.play_name_maxwidth = 60
ns.datas.play_btag_maxwidth = 0

-- -----------------------------------------------------------------------------
-- ✔︎ EVENTS
-- -----------------------------------------------------------------------------

ns.datas.events = { "ADDON_LOADED",
                    "PLAYER_GUILD_UPDATE",
                    "GUILD_ROSTER_UPDATE",
					"GROUP_ROSTER_UPDATE",
                    "FRIENDLIST_UPDATE",

					"BN_FRIEND_ACCOUNT_ONLINE",
					"BN_FRIEND_ACCOUNT_OFFLINE",
					"BN_FRIEND_LIST_SIZE_CHANGED",
					"BN_FRIEND_INFO_CHANGED",
					"BN_FRIEND_INVITE_ADDED",
					"BN_FRIEND_INVITE_REMOVED",
					"BN_BLOCK_LIST_UPDATED",
					"BN_CONNECTED",
					"BN_DISCONNECTED",
					"BN_INFO_CHANGED" }

-- -----------------------------------------------------------------------------
-- ✔︎ TEXTE
-- -----------------------------------------------------------------------------

ns.datas.texte          = {}
ns.datas.texte.points   = "....................................................................................................................................."

-- -----------------------------------------------------------------------------
-- ✔︎ COLORS
-- -----------------------------------------------------------------------------

ns.datas.colors         = {}
ns.datas.colors.white   = 'ffffff'
ns.datas.colors.yellow  = 'ffbb00'
ns.datas.colors.red     = 'e60000'
ns.datas.colors.green   = '00ffb7'
ns.datas.colors.sgren   = '1ced6b'
ns.datas.colors.pink    = 'ff00e1'
ns.datas.colors.blue    = '00d5ff'
ns.datas.colors.magenta = 'c054ff'
ns.datas.colors.grey    = 'b8b8b8'

-- -----------------------------------------------------------------------------
-- ✔︎ GAMES
-- -----------------------------------------------------------------------------

ns.datas.game         	= {}
ns.datas.game["IG"] 	= "Interface\\ChatFrame\\UI-ChatIcon-WoW" -- IN GAME
ns.datas.game["CLNT"] 	= "Interface\\ChatFrame\\UI-CHATICON-BLIZZ" --
ns.datas.game["BSAp"] 	= "Interface\\ChatFrame\\UI-ChatIcon-Battlenet" -- Battle.net Mobile App
ns.datas.game["App"] 	= "Interface\\ChatFrame\\UI-ChatIcon-Battlenet" -- Battle.net Desktop App
ns.datas.game["WoW"] 	= "Interface\\ChatFrame\\UI-ChatIcon-WoW" -- World of Warcraft
ns.datas.game["S2"] 	= "Interface\\ChatFrame\\UI-ChatIcon-SC2" -- StarCraft 2
ns.datas.game["D3"] 	= "Interface\\ChatFrame\\UI-ChatIcon-D3" -- Diablo 3
ns.datas.game["WTCG"] 	= "Interface\\ChatFrame\\UI-ChatIcon-WTCG" -- Hearthstone
ns.datas.game["Hero"] 	= "Interface\\ChatFrame\\UI-ChatIcon-HotS" -- Heroes of the Storm
ns.datas.game["Pro"] 	= "Interface\\ChatFrame\\UI-ChatIcon-Overwatch" -- Overwatch
ns.datas.game["S1"] 	= "Interface\\ChatFrame\\UI-ChatIcon-SC" -- StarCraft: Remastered
ns.datas.game["DST2"] 	= "Interface\\ChatFrame\\UI-ChatIcon-Destiny2" -- Destiny 2
ns.datas.game["VIPR"] 	= "Interface\\ChatFrame\\UI-ChatIcon-CallOfDutyBlackOps4" -- Call of Duty: Black Ops 4
ns.datas.game["ODIN"] 	= "Interface\\ChatFrame\\UI-ChatIcon-CallOfDutyMWicon" -- Call of Duty: Modern Warfare
ns.datas.game["LAZR"] 	= "Interface\\ChatFrame\\UI-ChatIcon-CallOfDutyMW2icon" -- Call of Duty: Modern Warfare 2
ns.datas.game["ZEUS"] 	= "Interface\\ChatFrame\\UI-ChatIcon-CallofDutyBlackOpsColdWaricon" -- Call of Duty: Black Ops Cold War
ns.datas.game["W3"] 	= "Interface\\ChatFrame\\UI-ChatIcon-Warcraft3Reforged" -- Warcraft III: Reforged


ns.datas.game["Alliance"] = "Interface\\FriendsFrame\\PlusManz-Alliance"
ns.datas.game["Horde"]    = "Interface\\FriendsFrame\\PlusManz-Horde"

ns.datas.gameic         	= {}
ns.datas.gameic["Alliance"] = 374217
ns.datas.gameic["Horde"]    = 374221

-- -----------------------------------------------------------------------------
-- ✔︎ FONTS
-- -----------------------------------------------------------------------------

ns.datas.fonts = {}

local GameFontTTL = "GameFontNormal"      local _,GameFontTTL_Height,_ = GameFontNormal:GetFont()
local GameFontTXT = "GameFontNormalSmall" local _,GameFontTXT_Height,_ = GameFontNormalSmall:GetFont()

ns.datas.fonts.TTL_F  = GameFontTTL
ns.datas.fonts.TTL    = GameFontTTL_Height
ns.datas.fonts.TTL_01 = ns.datas.fonts.TTL* .04
ns.datas.fonts.TTL_02 = ns.datas.fonts.TTL* .2
ns.datas.fonts.TTL_05 = ns.datas.fonts.TTL* .5
ns.datas.fonts.TTL_07 = ns.datas.fonts.TTL* .7
ns.datas.fonts.TTL_12 = ns.datas.fonts.TTL*1.2
ns.datas.fonts.TTL_14 = ns.datas.fonts.TTL*1.4
ns.datas.fonts.TTL_18 = ns.datas.fonts.TTL*1.8
ns.datas.fonts.TTL_20 = ns.datas.fonts.TTL*2
ns.datas.fonts.TTL_22 = ns.datas.fonts.TTL*2.2

ns.datas.fonts.TXT_F  = GameFontTXT
ns.datas.fonts.TXT    = GameFontTXT_Height
ns.datas.fonts.TXT_01 = ns.datas.fonts.TXT* .04
ns.datas.fonts.TXT_02 = ns.datas.fonts.TXT* .2
ns.datas.fonts.TXT_05 = ns.datas.fonts.TXT* .5
ns.datas.fonts.TXT_07 = ns.datas.fonts.TXT* .7
ns.datas.fonts.TXT_12 = ns.datas.fonts.TXT*1.2
ns.datas.fonts.TXT_14 = ns.datas.fonts.TXT*1.4
ns.datas.fonts.TXT_18 = ns.datas.fonts.TXT*1.8
ns.datas.fonts.TXT_20 = ns.datas.fonts.TXT*2
ns.datas.fonts.TXT_22 = ns.datas.fonts.TXT*2.2

-- -----------------------------------------------------------------------------
-- ✔︎ SIZES
-- -----------------------------------------------------------------------------

ns.datas.sizes = {}

ns.datas.sizes.PANNEL        = 444
ns.datas.sizes.MARGES        = ns.datas.fonts.TXT_07
ns.datas.sizes.MMARGS        = ns.datas.sizes.MARGES/2
ns.datas.sizes.MINWID        = 160

ns.datas.sizes.PANNELINFOS_H = ns.datas.fonts.TXT_22

-- -----------------------------------------------------------------------------

ns.datas.sizes.title_h       = ns.datas.fonts.TXT_14+ns.datas.sizes.MMARGS
ns.datas.sizes.lines_h       = ns.datas.fonts.TXT_18

-- -----------------------------------------------------------------------------
-- ✔︎ POPUP
-- -----------------------------------------------------------------------------

StaticPopupDialogs["WFEZ_CREATEGRP"] = {
	text = "Enter new group name",
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	OnAccept 			  = function(self) local pa = self.editBox:GetParent(); WFEZ_O_CREATEGROUP(pa,pa.data); return end,
	EditBoxOnEnterPressed = function(self) local pa = self:GetParent(); 		WFEZ_O_CREATEGROUP(pa,pa.data); return end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}