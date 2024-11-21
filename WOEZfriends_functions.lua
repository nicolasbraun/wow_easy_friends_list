-- -----------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local WFEZ_D,WFEZ_O,WFEZ_F,L = ns.datas,ns.functions,ns.frames,ns.locales

-- -----------------------------------------------------------------------------
-- ✔︎ Debug Functions
-- -----------------------------------------------------------------------------

function WFEZ_O:DEBUG(what,more,bug)
	if not WFEZ_D.DEBUG then return end
	local colors = {['VAR']      = WFEZ_D.colors.yellow,
					['CALL']     = WFEZ_D.colors.magenta,
					['REGISTER'] = WFEZ_D.colors.red,
					['FIRE']     = WFEZ_D.colors.green,
					['OPTIONS']  = WFEZ_D.colors.blue,
					['TABLE']    = WFEZ_D.colors.pink }
	local color = (colors[what] or WFEZ_D.colors.yellow)
	if more == nil then more = what end
	if type(more) == "table" then
		WFEZ_O:DEBUG_T(what,more)
	else
		local res = (WFEZ_D.PRINT.."|cff"..color..(more and tostring(more) or '> ').."|r"..(bug and ' '..tostring(bug) or ''))
		if DLAPI then DLAPI.DebugLog('_DebugLog', res) else print(res) end
	end
end
function WFEZ_O:DEBUG_T(name,tabl)
	if not WFEZ_D.DEBUG then return end
	for k,v in pairs(tabl) do
		WFEZ_O:DEBUG('TABLE',name," |cff"..WFEZ_D.colors.magenta..k.." |r "..tostring(v))
		if type(v) == "table" then
			for x,y in pairs(v) do
				WFEZ_O:DEBUG('TABLE',name," |cff"..WFEZ_D.colors.magenta..k.." -> "..x.." |r "..tostring(y))
			end
		end
	end
end

function WFEZ_O:HEX(c)
	c = math.floor(c * 255)
	local hex = string.format("%x", c)
	if (hex:len() == 1) then return "0"..hex; end
	return hex;
end
function WFEZ_O:TRIM(s)
	if not s then return '' end
	return s:gsub('[ \t]+%f[\r\n%z]', '')
	-- return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end
function WFEZ_O:CLEAN(s)
	if not s then return '' end
	return s:lower():gsub('%W','')
end
function WFEZ_O:SPAIRS(t, order)
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end
	if order then table.sort(keys, function(a,b) return order(t, a, b) end)
			 else table.sort(keys) end
	local i = 0
	return function()
		i = i + 1
		if keys[i] then return keys[i], t[keys[i]] end
	end
end
function WFEZ_O:STRIP(str)
	local tableAccents = {}
		--  tableAccents["À"] = "A" --  tableAccents["Á"] = "A" --  tableAccents["Â"] = "A" --  tableAccents["Ã"] = "A" --  tableAccents["Ä"] = "A"
		--  tableAccents["Å"] = "A" --  tableAccents["Æ"] = "AE" --  tableAccents["Ç"] = "C" --  tableAccents["È"] = "E" --  tableAccents["É"] = "E"
		--  tableAccents["Ê"] = "E" --  tableAccents["Ë"] = "E" --  tableAccents["Ì"] = "I" --  tableAccents["Í"] = "I" --  tableAccents["Î"] = "I"
		--  tableAccents["Ï"] = "I" --  tableAccents["Ð"] = "D" --  tableAccents["Ñ"] = "N" --  tableAccents["Ò"] = "O" --  tableAccents["Ó"] = "O"
		--  tableAccents["Ô"] = "O" --  tableAccents["Õ"] = "O" --  tableAccents["Ö"] = "O" --  tableAccents["Ø"] = "O" --  tableAccents["Ù"] = "U"
		--  tableAccents["Ú"] = "U" --  tableAccents["Û"] = "U" --  tableAccents["Ü"] = "U" --  tableAccents["Ý"] = "Y" --  tableAccents["Þ"] = "P"
		  tableAccents["ß"] = "s" tableAccents["à"] = "a" tableAccents["á"] = "a" tableAccents["â"] = "a" tableAccents["ã"] = "a"
		  tableAccents["ä"] = "a" tableAccents["å"] = "a" tableAccents["æ"] = "ae" tableAccents["ç"] = "c" tableAccents["è"] = "e"
		  tableAccents["é"] = "e" tableAccents["ê"] = "e" tableAccents["ë"] = "e" tableAccents["ì"] = "i" tableAccents["í"] = "i"
		  tableAccents["î"] = "i" tableAccents["ï"] = "i" tableAccents["ð"] = "eth"
		  tableAccents["ñ"] = "n" tableAccents["ò"] = "o" tableAccents["ó"] = "o" tableAccents["ô"] = "o"
		  tableAccents["õ"] = "o" tableAccents["ö"] = "o" tableAccents["ø"] = "o" tableAccents["ù"] = "u" tableAccents["ú"] = "u"
		  tableAccents["û"] = "u" tableAccents["ü"] = "u" tableAccents["ý"] = "y" tableAccents["þ"] = "p" tableAccents["ÿ"] = "y"
	return str:gsub("[%z\1-\127\194-\244][\128-\191]*", tableAccents) or ''
end
function WFEZ_O:RXPESC(str) return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1") end

-- -----------------------------------------------------------------------------
-- ✔︎ Create Frame
-- -----------------------------------------------------------------------------

function WFEZ_O:FRAM(name,type,where,opt, 	z,x,y,yy,zz, 	w,h)
	if w == nil then w = WFEZ_D.fonts.TXT_14 end
	if h == nil then h = WFEZ_D.fonts.TXT_14 end
	local obj = name
	local stuff = _G[obj] or CreateFrame(type,obj,where,opt)
	if z then stuff:SetPoint(z,x,y,yy,zz) end
	if w and h then stuff:SetSize(w,h) end
	return stuff
end
function WFEZ_O:BTTN(name,where, 			z,x,y,yy,zz, 	w,h)
	local btn = WFEZ_O:FRAM(name,"Button",where,"UIPanelButtonTemplate", z,x,y,yy,zz,w,h)
		  btn:DisableDrawLayer("BACKGROUND")
		  btn:SetNormalTexture('') btn:SetPushedTexture('') btn:SetHighlightTexture('')
		  local font = btn:GetNormalFontObject();
				font:SetTextColor(1,1,1,.6); btn:SetNormalFontObject(font);
		  local font = btn:GetHighlightFontObject();
				font:SetTextColor(1,1,1,1); btn:SetHighlightFontObject(font);
	return btn
end
function WFEZ_O:FADE(name,where,allpoint,f,w)
	local w = w or "BACKGROUND"
	local f = f or .6
	local obj = name
	local stuff = _G[obj] or where:CreateTexture(obj,w)
	if allpoint then stuff:SetAllPoints(true) end
		  stuff:SetColorTexture(0,0,0,f)
	return stuff
end
function WFEZ_O:ICON(name,where,ico,		z,x,y,		w,h)
	if w == nil then w = WFEZ_D.fonts.TXT_14 end
	if h == nil then h = WFEZ_D.fonts.TXT_14 end
	local obj = name
	local stuff = _G[obj] or where:CreateTexture(obj,"OVERLAY")
	if z then stuff:SetPoint(z,x,y) end
		  stuff:SetSize(w,h)
		  stuff:SetTexture(ico)
	return stuff
end
function WFEZ_O:FONT(name,where,	z,x,y,yy,zz,	w,h,	font,justifyH)
	if font == nil then font = WFEZ_D.fonts.TXT_F end
	if justifyH == nil then justifyH = "LEFT" end
	local obj = name
	local stuff = _G[obj] or where:CreateFontString(obj,nil,font)
	if z then stuff:SetPoint(z,x,y,yy,zz) end
	if w and h then stuff:SetSize(w,h) end
		  stuff:SetJustifyH(justifyH)
		  stuff:SetJustifyV("MIDDLE")
		  stuff:SetWordWrap(false)
	return stuff
end

-- -----------------------------------------------------------------------------
-- ✔︎ Load addon
-- -----------------------------------------------------------------------------

function WFEZ_O:LOAD()
	WF_ez_DBC              = WF_ez_DBC               or {}
	nWF_ez_DBC             = {}
	nWF_ez_DBC.width       = WF_ez_DBC.width         or 444
	nWF_ez_DBC.heigh       = WF_ez_DBC.heigh         or GetScreenHeight()/1.8
	nWF_ez_DBC.grouphidden = WF_ez_DBC.grouphidden   or {}
	nWF_ez_DBC.enable_offs = WF_ez_DBC.enable_offs   or 0
	nWF_ez_DBC.only_ingame = WF_ez_DBC.only_ingame   or 0
	nWF_ez_DBC.only_favori = WF_ez_DBC.only_favori   or 0
	nWF_ez_DBC.showguildie = WF_ez_DBC.showguildie 	 or 1
	nWF_ez_DBC.guildiesLDB = WF_ez_DBC.guildiesLDB 	 or 1
	nWF_ez_DBC.dataobjpos  = WF_ez_DBC.dataobjpos    or { 90 }
	nWF_ez_DBC.transparency= WF_ez_DBC.transparency  or .6
	nWF_ez_DBC.btag_2right = WF_ez_DBC.btag_2right   or false

	WF_ez_DBC = nWF_ez_DBC

	WFEZ_D.Class = WFEZ_D.Class or {}
	for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE)   do WFEZ_D.Class[v] = k end
	for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do WFEZ_D.Class[v] = k end

	WF_ez_DBC.player = {}
	WF_ez_DBC.player.name,WF_ez_DBC.player.realm  = UnitFullName("player") or ''

	if WFEZ_D.FAKE then
		WF_ez_DBC.player.faction = "Horde"
	else
		WF_ez_DBC.player.faction,_ = UnitFactionGroup("player") or ''
	end
	WFEZ_O:GET_GUILDINFOS()

	WFEZ_F.main:SetWidth(WF_ez_DBC.width)	WFEZ_F.main:SetHeight(WF_ez_DBC.heigh)
	WFEZ_O:DEBUG('WF_ez_DBC',WF_ez_DBC)

	WFEZ_F.bottom_f = WFEZ_O:FADE("WFEZbottomfade",WFEZ_F.bottom,true,WF_ez_DBC.transparency)
	WFEZ_F.margbg_f = WFEZ_O:FADE("WFEZmargbgfade",WFEZ_F.margbg,true,WF_ez_DBC.transparency)
	WFEZ_F.search_f = WFEZ_O:FADE("WFEZsearchfade",WFEZ_F.search,true,WF_ez_DBC.transparency)

	C_FriendList.ShowFriends() C_GuildInfo.GuildRoster()

	WFEZ_D.LOAD = true

	if not LibStub then return end
	local ldb  = LibStub:GetLibrary("LibDataBroker-1.1", true)
	if not ldb then return end
	WFEZ_D.LDB = ldb:NewDataObject("WOEZ FRIENDS",{
		type = "launcher",
		text = '...',
		icon = "Interface\\ChatFrame\\UI-ChatIcon-Battlenet",
		OnClick = function() WFEZ_O:CHECK_OPEN() end,
		OnEnter = function(self) WFEZ_O:OPEN_LDB(self) end,
		OnLeave = function(self) WFEZ_O:CLOSE_LDB() end,
	})

	WFEZ_O:UPDATE_MAP()
	WFEZ_O:UPDATE_LDB()
end

-- -----------------------------------------------------------------------------

function WFEZ_O:GET_GUILDINFOS()
	WF_ez_DBC.player.guild = false
	if WFEZ_D.FAKE then
		WF_ez_DBC.player.guild = 'SUPRATOP NAMEGUILD'
	elseif IsInGuild() then
		WF_ez_DBC.player.guild = GetGuildInfo("player") or false
	end
end
function WFEZ_O:GET_NUMFRIENDS()
	WFEZ_O:DEBUG('REGISTER','GET_NUMFRIENDS')
	if WFEZ_D.FAKE then
		WFEZ_D.NB_BN_friends, WFEZ_D.NB_BN_friends_on = 156,28
		WFEZ_D.NB_IG_Friends, WFEZ_D.NB_IG_Friends_on = 9,4
	else
		WFEZ_D.NB_BN_friends, WFEZ_D.NB_BN_friends_on,_,_ = BNGetNumFriends()
		WFEZ_D.NB_IG_Friends    = C_FriendList.GetNumFriends() or 0
		WFEZ_D.NB_IG_Friends_on = C_FriendList.GetNumOnlineFriends() or 0
	end
	WFEZ_D.NB_friends = WFEZ_D.NB_BN_friends+WFEZ_D.NB_IG_Friends
	WFEZ_D.NB_friends_on = WFEZ_D.NB_BN_friends_on+WFEZ_D.NB_IG_Friends_on
end
function WFEZ_O:GET_NUMGUILDIES()
	WFEZ_D.NB_guildies, WFEZ_D.NB_guildies_on = 0,0
	if WFEZ_D.FAKE then
		WFEZ_D.NB_guildies, WFEZ_D.NB_guildies_on = 138,9
	elseif WF_ez_DBC.player.guild then
		WFEZ_D.NB_guildies, _, WFEZ_D.NB_guildies_on = GetNumGuildMembers();
		WFEZ_D.NB_guildies_on = WFEZ_D.NB_guildies_on or 0
	end
end

-- -----------------------------------------------------------------------------
-- ✔︎ Options
-- -----------------------------------------------------------------------------

function WFEZ_O:SEARCH(text)
	if not WFEZ_D.isOpen then return end
	if text == '' then
		WFEZ_D.search = false
		WFEZ_F.search_t:Show()
		WFEZ_O:REFRESH()
	else
		WFEZ_F.search_t:Hide()
		if not WFEZ_D.search or (WFEZ_D.search and WFEZ_D.search ~= WFEZ_O:STRIP(text:lower())) then
			WFEZ_D.search = WFEZ_O:STRIP(text:lower())
			WFEZ_O:REFRESH()
		end
	end
end

function WFEZ_O:TRANSPARENCY(msg)
	local nb = msg:gsub('alpha ','')
	if tonumber(nb) then
		local n = math.floor(nb)
		  if n > 100 then n = 100 WF_ez_DBC.transparency = 1
		elseif n < 0 then n = 0   WF_ez_DBC.transparency = 0
					 else WF_ez_DBC.transparency = (100-n)/100 end
		local c = _G["WFEZmargbgfade"] if c then c:SetColorTexture(0,0,0,WF_ez_DBC.transparency) end
		local c = _G["WFEZbottomfade"] if c then c:SetColorTexture(0,0,0,WF_ez_DBC.transparency) end
		local c = _G["WFEZsearchfade"] if c then c:SetColorTexture(0,0,0,WF_ez_DBC.transparency) end
		print(WFEZ_D.PRINTS.."Alpha set to "..n.."%")
	else
		print(WFEZ_D.PRINTS.."|cff"..WFEZ_D.colors.red.."Error... |cff"..WFEZ_D.colors.sgren.."use : /wf alpha 40\n:: -> number: 100 is full transparency, 0 is no transparency.")
	end
end
function WFEZ_O:ICON_TOGGL()
	if not LibStub then return end
	local icon = LibStub("LibDBIcon-1.0", true)
	if not icon then return end
	if WF_ez_DBC.dataobjpos.hide == true then
		icon:Show("WOEZ FRIENDS")
		WF_ez_DBC.dataobjpos.hide = false
		print(WFEZ_D.PRINTS.."icon is now visible")
	else
		icon:Hide("WOEZ FRIENDS")
		WF_ez_DBC.dataobjpos.hide = true
		print(WFEZ_D.PRINTS.."icon is now hidden")
	end
end
function WFEZ_O:LDBGUILD_TOGGL()
	if WF_ez_DBC.guildiesLDB == true then
		WF_ez_DBC.guildiesLDB = false
		print(WFEZ_D.PRINTS.."Guildies are now hidden in LDB")
	else
		WF_ez_DBC.guildiesLDB = true
		print(WFEZ_D.PRINTS.."Guildies are now visible in LDB")
	end
	WFEZ_O:UPDATE_LDB()
end
function WFEZ_O:BNET_TOGGL()
	if WF_ez_DBC.btag_2right == true then
		WF_ez_DBC.btag_2right = false
		print(WFEZ_D.PRINTS.."Btag will be show Right side")
	else
		WF_ez_DBC.btag_2right = true
		print(WFEZ_D.PRINTS.."Btag will be show Left side")
	end
	WFEZ_O:SET_PANNEL()
end

-- -----------------------------------------------------------------------------
-- ✔︎ Raider IO
-- -----------------------------------------------------------------------------

function WFEZ_O:SHOW_RIO(tooltip,fullname,realmName,playerFaction)
	if not RaiderIO or not fullname then return end
	local FACTIONS = { Alliance = 1, Horde = 2, Neutral = 3 }
	local playerFactionID = FACTIONS[playerFaction or WF_ez_DBC.player.faction]
	RaiderIO.ShowProfile(tooltip,fullname, realmName, playerFactionID);
end
function WFEZ_O:COLOR_RIO(currentScore)
	if not RaiderIO then return '' end
	local r, g, b = RaiderIO.GetScoreColor(currentScore);
	local hex = WFEZ_O:HEX(r)..WFEZ_O:HEX(g)..WFEZ_O:HEX(b);
	return "|cff"..hex..currentScore.." |r ";
end
function WFEZ_O:GET_SCORE(fullname,realmName,playerFaction)
	if not RaiderIO or WFEZ_D.FAKE then return '' end

	local FACTIONS = { Alliance = 1, Horde = 2, Neutral = 3 }
	local playerFactionID = FACTIONS[playerFaction or WF_ez_DBC.player.faction]
	local playerProfile = RaiderIO.GetProfile(fullname, realmName, playerFactionID);
	local currentScore = '';
	local previousScore = '';

	if playerProfile == nil then return '' end

	if playerProfile.mythicKeystoneProfile ~= nil then
		currentScore = playerProfile.mythicKeystoneProfile.currentScore or '';
		-- previousScore = playerProfile.mythicKeystoneProfile.previousScore or 0;
	end

	if currentScore == '' or currentScore == 0 then return '' end
	return WFEZ_O:COLOR_RIO(currentScore)

	--[[ local data = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit)
	local seasonScore = data and data.currentSeasonScore

	if seasonScore then
		local color = C_ChallengeMode_GetDungeonScoreRarityColor(seasonScore)
		local hex = WFEZ_O:HEX(color.r)..WFEZ_O:HEX(color.g)..WFEZ_O:HEX(color.b);
		return "|cff"..hex..seasonScore.." |r ";
	end ]]

end
function WFEZ_O:GET_COLOR(className)
	local clname = (className and className ~= '') and WFEZ_D.Class[className]
	if RAID_CLASS_COLORS[clname] then
		return RAID_CLASS_COLORS[clname]
	elseif RAID_CLASS_COLORS[className] then
		return RAID_CLASS_COLORS[className]
	else
		return { r=.6, g=.6, b=.6, colorStr = 'FFAAAAAA' }
	end
end

-- -----------------------------------------------------------------------------
-- ✔︎ LDB LibStub
-- -----------------------------------------------------------------------------

function WFEZ_O:UPDATE_MAP()
	if not WFEZ_D.LDB then return end
	WFEZ_O:DEBUG('REGISTER','UPDATE_MAP')
	local icon = LibStub("LibDBIcon-1.0", true)
	if not icon then return end
	icon:Register("WOEZ FRIENDS", WFEZ_D.LDB, WF_ez_DBC.dataobjpos)
end
function WFEZ_O:UPDATE_LDB()
	if not LibStub and not WFEZ_D.isOpen then return end

	WFEZ_O:DEBUG('VAR','UPDATE_LDB')
	local guildies = ""
	WFEZ_O:GET_NUMFRIENDS();

	local datatext = 'FRIENDS |cFFffc600'..(WFEZ_D.NB_friends_on)..'|r'
	WFEZ_D.TXTUP = 'FRIENDS: |cFFB4B4B4'..(WFEZ_D.NB_friends_on)..'|r/'..(WFEZ_D.NB_friends)
	if WF_ez_DBC.player.guild or WFEZ_D.FAKE then
		WFEZ_O:GET_NUMGUILDIES()
		if WFEZ_D.FAKE then
			WFEZ_O:DEBUG('REGISTER','FAKE LDB')
			if WF_ez_DBC.guildiesLDB then guildies = WFEZ_O:FAKE_GUILDIES() end
		else
			if WF_ez_DBC.guildiesLDB then
				for i = 1, WFEZ_D.NB_guildies do
					local name, _, _, _, _, _, _, _, isOnline, _, className, _, _, isMobile, _, _, _ = GetGuildRosterInfo(i)
					if name and (isMobile or isOnline) then
						local player_name,_ = strsplit("-",name,2) or ""
						local c = WFEZ_O:GET_COLOR(className)
						guildies = " |c"..c.colorStr..player_name.."|r"..guildies;
					end
				end
				guildies = "/ "..guildies;
			end
		end
		datatext = 'FRIENDS |cFFffc600'..(WFEZ_D.NB_friends_on)..'|r'
		if WF_ez_DBC.player.guild == "Pull N Wipe"
			then datatext = datatext..'   PNW |cFFffc600'..(WFEZ_D.NB_guildies_on)..'|r '..guildies
			else datatext = datatext..'   GUILD |cFFffc600'..(WFEZ_D.NB_guildies_on)..'|r '..guildies
		end
		if WF_ez_DBC.showguildie == 1 then
			WFEZ_D.TXTUP = 'GUILD: |cFFB4B4B4'..(WFEZ_D.NB_guildies_on)..'|r/'..(WFEZ_D.NB_guildies)..'   '..WFEZ_D.TXTUP end
	else
		datatext = datatext..'/'..(WFEZ_D.NB_friends)
	end
	if WFEZ_D.LDB then WFEZ_D.LDB.text = datatext end
	if _G['WFEZ_TXT'] then _G['WFEZ_TXT']:SetText(WFEZ_D.TXTUP) end
end
function WFEZ_O:OPEN_LDB(slf)
	if WFEZ_D.isOpen then return end
	WFEZ_D.LDBisOver = true
	WFEZ_F.scrollf:ClearAllPoints()
	WFEZ_F.scrollf:SetParent(slf)
	WFEZ_F.scrollf:SetPoint("TOP",slf, "BOTTOM", 0,-WFEZ_D.sizes.MARGES*2)
	WFEZ_F.scrollf:SetWidth(WF_ez_DBC.width)
	WFEZ_F.scrollf:SetFrameStrata("TOOLTIP")
	WFEZ_F.scrollf_f:Show()
	WFEZ_F.scrollb:Hide()
	WFEZ_F.scrollb:SetValue(0)
	WFEZ_O:REFRESH(true)
end
function WFEZ_O:CLOSE_LDB()
	WFEZ_D.LDBisOver = false
	if WFEZ_D.LDBisOver then return end
	WFEZ_F.scrollf:ClearAllPoints()
	WFEZ_F.scrollf:SetParent(WFEZ_F.main)
	WFEZ_F.scrollf:SetPoint("TOPLEFT"    ,WFEZ_F.margbg, "TOPLEFT"		,0,-WFEZ_D.sizes.MARGES)
	WFEZ_F.scrollf:SetPoint("BOTTOMRIGHT",WFEZ_F.margbg, "BOTTOMRIGHT"  ,0, WFEZ_D.sizes.MARGES)
	WFEZ_F.scrollf_f:Hide()
	WFEZ_F.scrollb:Show()
	if WFEZ_D.isOpen then return end
	WFEZ_O:SET_PANNEL()
end
-- -----------------------------------------------------------------------------
-- ✔︎ BUILD FRIENDS
-- -----------------------------------------------------------------------------

function WFEZ_O:F(group,id)
	local p = false
	if WFEZ_D.All_friends[group] then
		if WFEZ_D.All_friends[group].f[id] then p = WFEZ_D.All_friends[group].f[id]
	elseif WFEZ_D.All_friends[group].a[id] then p = WFEZ_D.All_friends[group].a[id] end
	end
	return p
end
function WFEZ_O:G(name,bnet)
	if bnet then
		local accountID = 0
		for i=1, BNGetNumFriends() do
			local acc = C_BattleNet.GetFriendAccountInfo(i)
			if acc.accountName == name then accountID = acc.bnetAccountID end
		end
		return C_BattleNet.GetAccountInfoByID(accountID)
	else
		return C_FriendList.GetFriendInfo(name)
	end
end
function WFEZ_O:GET_FRIENDS()
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end
	WFEZ_O:DEBUG('VAR','GET_FRIENDS')

	wipe(WFEZ_D.All_friends)
	wipe(WFEZ_D.All_groups) WFEZ_D.All_groups = { g = {}, f = {} }
	if WFEZ_D.FAKE then
		WFEZ_O:DEBUG('REGISTER','FAKEFRIENDS')
		if WF_ez_DBC.showguildie == 1 then WFEZ_O:FAKE_GUILDIES_ALL() end
		WFEZ_O:FAKE_FRIENDS_BNET_ALL()
		WFEZ_O:FAKE_FRIENDS_ALL()
		return
	else
		if WF_ez_DBC.player.guild  	then WFEZ_O:GET_GUILD_TABLE() end
		if WFEZ_D.NB_BN_friends > 0 then WFEZ_O:GET_FRIENDS_TABLE(WFEZ_D.NB_BN_friends,true) end
		if WFEZ_D.NB_IG_Friends > 0 then WFEZ_O:GET_FRIENDS_TABLE(WFEZ_D.NB_IG_Friends,false) end
	end
end
function WFEZ_O:GET_FRIEND_TABLE(nb,bnet)
	if WFEZ_D.FAKE or not nb then return end
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end
	WFEZ_O:DEBUG('VAR','GET_FRIEND_TABLE')
	if bnet then WFEZ_O:GET_FRIENDS_BNET(nb) end
end
function WFEZ_O:GET_FRIENDS_TABLE(nb,bnet)
	if WFEZ_D.FAKE then return end
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end

	-- WFEZ_O:DEBUG('VAR','GET_FRIENDS_TABLE')
	if bnet then
		for i = 1, nb do WFEZ_O:GET_FRIENDS_BNET(i) end
	else
		for i = 1, nb do
			local info = C_FriendList.GetFriendInfoByIndex(i)
			info.app = 'IG'
			info.name, info.realmName = strsplit( "-", info.name, 2 )
			info.faction = WF_ez_DBC.player.faction
			info.realmName = info.realmName or WFEZ_D.playerrlm
			info.search = info.name..' '..(info.note or '')
			if info then WFEZ_O:BUILD_FRIENDS(info,'f_'..info.guid,'IG') end
		end
	end
end
function WFEZ_O:GET_FRIENDS_BNET(i)
	if WFEZ_D.FAKE then return end
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end

	local bnetinfo = C_BattleNet.GetFriendAccountInfo(i)
	if bnetinfo then

		local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(i)

		if numGameAccounts == 0 then ------------------------------- offline
			local build = { connected = false,
								 btag = bnetinfo.accountName, bnetid = bnetinfo.bnetAccountID,
								 name = bnetinfo.accountName,
								isfav = bnetinfo.isFavorite,
								notes = bnetinfo.note,
							   search = bnetinfo.battleTag..' '..(bnetinfo.note or '') }
			WFEZ_O:BUILD_FRIENDS(build,'bnet_'..bnetinfo.bnetAccountID,'')
		else ------------------------------------------------------- online
			isapp = 0
			if numGameAccounts == 1 then
				local game = C_BattleNet.GetFriendGameAccountInfo(i, 1)
				local build = { connected = game.isOnline,
									 btag = bnetinfo.accountName, bnetid = bnetinfo.bnetAccountID,
									 name = game.characterName or bnetinfo.accountName,
								    isfav = bnetinfo.isFavorite,
								className = game.className,
									 race = game.raceName,
								realmName = game.realmName,
									level = game.characterLevel,
									 area = game.richPresence,
									  afk = game.isGameAFK,
									  dnd = game.isGameBusy,
								  faction = game.factionName,
								    notes = bnetinfo.note,
								   search = bnetinfo.battleTag..' '..(game.characterName or bnetinfo.accountName)..' '..(bnetinfo.note or '')  }
				WFEZ_O:BUILD_FRIENDS(build,'bnet_'..bnetinfo.bnetAccountID,game.clientProgram)
			else
				local toShow = {}
				local isApp = false
				local isMob = false
				for y = 1, numGameAccounts do
					local game = C_BattleNet.GetFriendGameAccountInfo(i, y)
						if game.clientProgram == "App"  then isApp = y
					elseif game.clientProgram == "BSAp" then isMob = y
					else tinsert(toShow,y) end
					-- WFEZ_O:DEBUG('VAR',bnetinfo.accountName..' - '..game.clientProgram..' '..(game.characterName or bnetinfo.accountName)..' #'..y)
				end
				if #toShow >= 1 then
					for _, y in pairs(toShow) do
						local game = C_BattleNet.GetFriendGameAccountInfo(i,y)
						local build = { connected = game.isOnline,
										 	 btag = bnetinfo.accountName, bnetid = bnetinfo.bnetAccountID,
											 name = game.characterName or bnetinfo.accountName,
											isfav = bnetinfo.isFavorite,
										className = game.className,
										 	 race = game.raceName,
										realmName = game.realmName,
											level = game.characterLevel,
											 area = game.richPresence,
											  afk = game.isGameAFK,
											  dnd = game.isGameBusy,
										  faction = game.factionName,
											notes = bnetinfo.note,
										   search = bnetinfo.battleTag..' '..(game.characterName or bnetinfo.accountName)..' '..(bnetinfo.note or '')  }
						WFEZ_O:BUILD_FRIENDS(build,'bnet_'..bnetinfo.bnetAccountID..(y > 1 and '-'..y or ''),game.clientProgram)
					end
				elseif isApp then
					local game = C_BattleNet.GetFriendGameAccountInfo(i,isApp)
					local build = { connected = game.isOnline,
										 btag = bnetinfo.accountName, bnetid = bnetinfo.bnetAccountID,
										 name = game.characterName or bnetinfo.accountName,
										isfav = bnetinfo.isFavorite,
									className = game.className,
										 race = game.raceName,
									realmName = game.realmName,
										level = game.characterLevel,
										 area = game.richPresence,
										  afk = game.isGameAFK,
										  dnd = game.isGameBusy,
									  faction = game.factionName,
										notes = bnetinfo.note,
									   search = bnetinfo.battleTag..' '..(game.characterName or bnetinfo.accountName)..' '..(bnetinfo.note or '')  }
					WFEZ_O:BUILD_FRIENDS(build,'bnet_'..bnetinfo.bnetAccountID,game.clientProgram)
				elseif isMob then
					local game = C_BattleNet.GetFriendGameAccountInfo(i,isMob)
					local build = { connected = game.isOnline,
										 btag = bnetinfo.accountName, bnetid = bnetinfo.bnetAccountID,
										 name = game.characterName or bnetinfo.accountName,
										isfav = bnetinfo.isFavorite,
									className = game.className,
										 race = game.raceName,
									realmName = game.realmName,
										level = game.characterLevel,
										 area = game.richPresence,
										  afk = game.isGameAFK,
										  dnd = game.isGameBusy,
									  faction = game.factionName,
										notes = bnetinfo.note,
									   search = bnetinfo.battleTag..' '..(game.characterName or bnetinfo.accountName)..' '..(bnetinfo.note or '')  }
					WFEZ_O:BUILD_FRIENDS(build,'bnet_'..bnetinfo.bnetAccountID,game.clientProgram)
				end
			end
		end
	end
end

function WFEZ_O:GET_GUILD_TABLE()
	if WFEZ_D.FAKE or not WF_ez_DBC.player.guild then return end
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end

	WFEZ_O:DEBUG('VAR','GET_GUILD_TABLE')
	local Guild_RANK = {}
	local RosterGuild = {}
	for i=0, GuildControlGetNumRanks() do
		local NameRank = GuildControlGetRankName(i)
		Guild_RANK[i] = NameRank
	end
	for i = 1, WFEZ_D.NB_guildies do
		local name, rank, rankID, level, class, zone, note, officernote, isOnline, status, _, _, _, isMobile, _, _, guid = GetGuildRosterInfo(i)
		if name then
			local lastOnline = ''
			if not isOnline then
				local years, months, days, hours = GetGuildRosterLastOnline(i)
	  				  years, months, days, hours = years and years or 0, months and months or 0, days and days or 0, hours and hours or 0

				if years  > 0 			  				  then lastOnline = lastOnline..years ..' year' ..(years  > 1 and 's' or '')..' ' end
				if months > 0 			  				  then lastOnline = lastOnline..months..' month'..(months > 1 and 's' or '')..' ' end
				if years < 1 and days > 0 				  then lastOnline = lastOnline..days  ..' day'  ..(days   > 1 and 's' or '')..' ' end
				if years < 1 and months < 1 and hours > 0 then lastOnline = lastOnline..hours ..' hour' ..(hours  > 1 and 's' or '')..' ' end
			end

			local roleid = rankID..'/ '..rank
					if rankID == 0 then roleid = '1/ '..Guild_RANK[2] end
			if WF_ez_DBC.player.guild == "Pull N Wipe" then
					if rankID < 3 then roleid = '1/ '..Guild_RANK[2]
								  else roleid = (rankID-1)..'/ '..Guild_RANK[rankID+1] end
			end
			local playername,playerrealm =  strsplit( "-",name, 2 )
			local build = { connected = isOnline or isMobile,
								 btag = rank,
							   roleid = roleid,
						   guildindex = i,
								 name = playername,
							className = class,
							realmName = playerrealm or WF_ez_DBC.player.realm,
								level = level,
								 area = isOnline and zone or lastOnline,
								  afk = status == 1 and true or false,
								  dnd = status == 2 and true or false,
							  faction = WF_ez_DBC.player.faction,
								notes = note,
						  officernote = officernote,
						  search = (note or '')..' '..(officernote or '')..rank..playername }
			WFEZ_O:BUILD_FRIENDS(build,'g_'..guid,'guild')
		end
	end
end

function WFEZ_O:BUILD_FRIENDS(info,uniqid,app)
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end

	local group = "xx NO GROUP xx"
	local inotes= info.notes or ""
	local nnotes,guild

	if app == 'guild' then
		group = "# "..WF_ez_DBC.player.guild.." .... "..info.roleid
		app    = "IG"
		guild  = info.guildindex
		nnotes = inotes
		group  = WFEZ_O:CREATEGROUP(group,true)
	else
		local reg = inotes:match("#(.*)")
		if reg then group = reg end
		nnotes = inotes:gsub(WFEZ_O:RXPESC("#"..group),'')
		group  = WFEZ_O:CREATEGROUP(group)
	end

	local color = info.className and WFEZ_O:GET_COLOR(info.className) or ((app=='IG' or not info.connected) and { r=.6,g=.6,b=.6 } or { r=.55,g=.8,b=.9 })
	if info.area and info.area:find('WoW Classic') then info.realmName = 'Wow Classic' end

	local player = {
		uniqid 	= uniqid,
		name   	= info.name,
		group   = group,
		guild  	= guild or nil,
		rio 	= info.rio or WFEZ_O:GET_SCORE(info.name,info.realmName or WFEZ_D.playerrlm ,info.faction),
		bnetid 	= info.bnetid or nil,
		app   	= app,
		isfav 	= info.isfav or false,
		btag 	= info.btag,
		online 	= info.connected,
		class   = info.className,
		race    = info.race,
		color  	= color,
		realm  	= (app == 'BSAp' and 'Mobile' or (info.realmName or '')),
		level  	= info.level and (info.level ~= WFEZ_D.maxlvl and (info.level ~= 0 and info.level or '') or '') or '',
		area   	= (info.area == 'Unknown' and 'Offline' or info.area),
		faction = info.faction,
		status 	= (info.afk and 'afk') or (info.dnd and 'dnd') or (info.connected and 'onl') or '',
		notes  	= nnotes,
		ofnotes = info.officernote or nil,
		search 	= info.search or nil

	}
	if not WFEZ_D.All_friends[group] then WFEZ_D.All_friends[group] = {f={},a={}} end


	if info.isfav then
		WFEZ_D.All_friends[group].f[uniqid] = player
	else
		WFEZ_D.All_friends[group].a[uniqid] = player
	end
	-- WFEZ_O:UPDATE_PLAYER(uniqid,player)
end

-- -----------------------------------------------------------------------------
-- ✔︎ PANNEL
-- -----------------------------------------------------------------------------

function WFEZ_O:CHECK_OPEN()
	if WFEZ_D.isOpen then WFEZ_F.main:Hide() else WFEZ_F.main:Show() end
end

function WFEZ_O:REFRESH(x)
	if x then
		WFEZ_O:DEBUG('CALL','REFRESH?')
		WFEZ_O:GET_GUILDINFOS()
		WFEZ_O:UPDATE_LDB()
		WFEZ_O:GET_FRIENDS()
	end
	WFEZ_O:SET_PANNEL()
end

function WFEZ_O:SET_PANNEL()
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end
	WFEZ_O:DEBUG('CALL','SET_PANNEL ??')

	if WFEZ_D.isOpen then
		if WF_ez_DBC.enable_offs == 1 then WFEZ_F.bottnc:SetAlpha( 1)
		 							  else WFEZ_F.bottnc:SetAlpha(.4)  end

		if WF_ez_DBC.only_favori == 1 then WFEZ_F.bottnf:SetAlpha( 1)
		 							  else WFEZ_F.bottnf:SetAlpha(.4)  end

		if WF_ez_DBC.only_ingame == 1 then WFEZ_F.bottnd:SetAlpha( 1)
		 							  else WFEZ_F.bottnd:SetAlpha(.4)  end

		if WF_ez_DBC.player.guild then
		if WF_ez_DBC.showguildie == 1 then WFEZ_F.bottne:SetAlpha( 1)
		 							  else WFEZ_F.bottne:SetAlpha(.4)  end
									   	   WFEZ_F.bottne:SetEnabled(true)
		else WFEZ_F.bottne:SetAlpha(0) 	   WFEZ_F.bottne:SetEnabled(false) end
	end
	----------------------------------------------------------------------------
	-- EMPTY
	----------------------------------------------------------------------------

	local all_groups = { WFEZ_F.child:GetChildren() }
	for _, group in ipairs(all_groups) do
		if group:GetObjectType() == "CheckButton" then
			group:Hide()
			local all_players = { group:GetChildren() }
			for _, player in ipairs(all_players) do
				if player:GetObjectType() == "CheckButton" then player:Hide() end
			end
		end
	end

	----------------------------------------------------------------------------
	-- CREATE GROUPS
	----------------------------------------------------------------------------

	WFEZ_D.play_btag_maxwidth = 0
	WFEZ_D.play_name_maxwidth = 60
	local top = 0

	if WF_ez_DBC.player.guild and WF_ez_DBC.showguildie == 1 then
	top = WFEZ_O:SET_PANNEL_LOOP(WFEZ_D.All_groups.g,top) end ------ GUILDIES --
	top = WFEZ_O:SET_PANNEL_LOOP(WFEZ_D.All_groups.f,top) ----------- FRIENDS --

	if WFEZ_D.isOpen then
		local Phei = WFEZ_F.scrollf:GetHeight()
		WFEZ_F.scrollb:SetMinMaxValues(1, (top-Phei<1 and 1 or top-Phei))
	elseif WFEZ_D.LDBisOver then
		WFEZ_F.scrollf:SetHeight(top)
	end
	WFEZ_F.play_btag_maxwidth:SetWidth(WF_ez_DBC.btag_2right and WFEZ_D.play_btag_maxwidth or 1)
	WFEZ_F.play_name_maxwidth:SetWidth(WFEZ_D.play_name_maxwidth)
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
end
function WFEZ_O:SET_PANNEL_LOOP(arrayGroup,top)
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end

	for groupID,groupName in WFEZ_O:SPAIRS(arrayGroup) do
		WFEZ_O:DEBUG('REGISTER','groupName',groupName)
		local group = WFEZ_O:SET_GROUP(groupID,groupName) ----------------------
		group:SetPoint("TOPLEFT",0,"-"..top)

			  top = top + WFEZ_D.sizes.lines_h
		local top_fromgrp = 0
		local toadd_nb = 0

		for k,p in pairs(WFEZ_D.All_friends[groupID].f) do
			top,top_fromgrp,toadd_nb = WFEZ_O:SET_PLAYER(k,p,group,groupID,top,top_fromgrp,toadd_nb)
		end
		for k,p in pairs(WFEZ_D.All_friends[groupID].a) do
			top,top_fromgrp,toadd_nb = WFEZ_O:SET_PLAYER(k,p,group,groupID,top,top_fromgrp,toadd_nb)
		end

		if toadd_nb and toadd_nb > 0 then
			group:Show()
			group:SetAlpha((not WFEZ_D.search and not WFEZ_D.LDBisOver and WF_ez_DBC.grouphidden[groupID]) and .4 or 1)
			top = top + WFEZ_D.sizes.MMARGS
		else
			group:Hide()
			top = (top and top >= WFEZ_D.sizes.lines_h) and (top - WFEZ_D.sizes.lines_h) or 0
		end
		------------------------------------------------------------------------
	end
	return top
end

-- -----------------------------------------------------------------------------
-- ✔︎ GROUPS
-- -----------------------------------------------------------------------------

function WFEZ_O:CREATEGROUP(name,g)
	local groupID = WFEZ_O:CLEAN(name:gsub('- ','a'))
	if g == true then WFEZ_D.All_groups.g[groupID] = name
				 else WFEZ_D.All_groups.f[groupID] = name end
	return groupID
end
function WFEZ_O:SET_GROUP(id,groupName)
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end
	local x = "WFEZGroup_"..id
	local group,group_txt = _G[x],_G[x.."_txt"]

	if not group then
		-- WFEZ_O:DEBUG('REGISTER','redo',groupName)
		group = WFEZ_O:FRAM(x,"CheckButton",WFEZ_F.child,"ChatConfigCheckButtonTemplate",nil,nil,nil,nil,nil,WFEZ_D.fonts.TXT_14,WFEZ_D.fonts.TXT_14)
		group:DisableDrawLayer("BACKGROUND")
		group:SetNormalTexture('')
		group:SetPushedTexture('')
		group:SetHighlightTexture('')
		group:SetCheckedTexture('')
		group:SetDisabledCheckedTexture('')

		group:SetPoint("RIGHT",WFEZ_F.scrollf,"RIGHT",-WFEZ_D.sizes.MMARGS,0)

		group_txt = WFEZ_O:FONT(x.."_txt",group,"LEFT",group,"LEFT",WFEZ_D.sizes.MARGES,0, nil,nil,WFEZ_D.fonts.TTL_F,"LEFT")
		group_txt:SetPoint("RIGHT",WFEZ_F.scrollf, "RIGHT",-(WFEZ_D.sizes.MARGES),0)
		group_txt:SetTextColor(1,1,1,.7)

		group:SetScript("OnEnter", function() group_txt:SetTextColor(1,1,1, 1) end)
		group:SetScript("OnLeave", function() group_txt:SetTextColor(1,1,1,.7) end)
		group:SetScript("OnClick", function()
			if WF_ez_DBC.grouphidden[id] then WF_ez_DBC.grouphidden[id] = nil
										 else WF_ez_DBC.grouphidden[id] = true end
			WFEZ_O:REFRESH()
		end)
	end
	group_txt:SetText(string.upper(groupName).." "..WFEZ_D.texte.points..WFEZ_D.texte.points..WFEZ_D.texte.points..WFEZ_D.texte.points)

	if WFEZ_D.search then group:SetEnabled(false) else group:SetEnabled(true) end
	group:Hide() return group
end

-- -----------------------------------------------------------------------------
-- ✔︎ PLAYERS
-- -----------------------------------------------------------------------------

function WFEZ_O:SET_PLAYER(id,p,group,groupID,t,tg,nb)
	if not WFEZ_D.isOpen and not WFEZ_D.LDBisOver then return end
	local x = "WFEZFrnd_"..id

	local play,play_bg,play_fact,play_sfav,play_bble,play_icon = _G[x],_G[x.."_bg"],_G[x.."_fact"],_G[x.."_sfav"],_G[x.."_conn"],_G[x.."_icon"]
	local play_on,play_name,play_levl,play_srvr,play_btag,play_note = _G[x.."_on"],_G[x.."_name"],_G[x.."_levl"],_G[x.."_srvr"],_G[x.."_btag"],_G[x.."_note"]

	----------------------------------------------------------------------------
	if not play then -----------------------------------------------------------

		play = WFEZ_O:FRAM(x,"CheckButton",WFEZ_F.child,"ChatConfigCheckButtonTemplate")
		play:SetHeight(WFEZ_D.sizes.lines_h)

		play_bg = WFEZ_O:FADE(x.."_bg",play,true,0,"BACKGROUND")

		play:SetNormalTexture('')  play:DisableDrawLayer("BACKGROUND")
		play:SetPushedTexture('')  play:SetHighlightTexture('')
		play:SetCheckedTexture('') play:SetDisabledCheckedTexture('')

		-- ICONES --------------------------------------------------------------

		play_fact = WFEZ_O:ICON(x.."_fact",play,'',"RIGHT",play,"RIGHT")
		play_fact:SetPoint("RIGHT",play,"RIGHT",-WFEZ_D.fonts.TXT_14,0)

		play_sfav = WFEZ_O:ICON(x.."_sfav",play,'Interface\\COMMON\\FavoritesIcon',nil,nil,nil,WFEZ_D.fonts.TTL_18,WFEZ_D.fonts.TTL_18)
		play_sfav:SetPoint("RIGHT",play,"RIGHT",WFEZ_D.fonts.TXT_05,-WFEZ_D.fonts.TXT_02)

		play_bble = WFEZ_O:ICON(x.."_conn",play,WFEZ_D.FOLDR .."round.tga","LEFT",play,"LEFT",WFEZ_D.fonts.TXT,WFEZ_D.fonts.TXT)
		play_bble:SetPoint("LEFT",play,"LEFT",WFEZ_D.sizes.MMARGS,0)
		play_icon = WFEZ_O:ICON(x.."_icon",play,'',"LEFT",play_bble,"RIGHT")
		play_icon:SetPoint("LEFT",play_bble,"RIGHT",WFEZ_D.sizes.MMARGS,0)

		-- NAME + SERVER + LEVEL -----------------------------------------------

		play_on   = WFEZ_O:FONT(x.."_on",play, "LEFT",play_icon,"RIGHT")
		play_on:SetPoint("RIGHT",WFEZ_F.play_name_maxwidth,"RIGHT") play_on:SetAlpha(0)

		play_name = WFEZ_O:FONT(x.."_name",play,"LEFT",play_on,"LEFT",WFEZ_D.sizes.MMARGS,0,nil,nil,WFEZ_D.fonts.TTL_F) -- play_name:SetText(name)
		play_levl = WFEZ_O:FONT(x.."_levl",play,"RIGHT",play_on,"RIGHT",0,0, nil,nil,WFEZ_D.fonts.TXT_F ,"RIGHT")
		play_srvr = WFEZ_O:FONT(x.."_srvr",play,"LEFT",play_name,"RIGHT",WFEZ_D.sizes.MMARGS,0)
		play_srvr:SetPoint("RIGHT",play_levl,"LEFT",-WFEZ_D.sizes.MMARGS,0)

		-- NOTES + AREA + BTAG -------------------------------------------------

		play_btag = WFEZ_O:FONT(x.."_btag",play,"RIGHT",play_fact,"LEFT",0,0, nil,nil,nil,"RIGHT")
		play_note = WFEZ_O:FONT(x.."_note",play,"LEFT",play_on,"RIGHT",WFEZ_D.sizes.MMARGS,0)

	end ------------------------------------------------------------------------
	play_bg:SetAlpha(0)
	play_btag:SetTextColor(1,1,1,.6)
	if WFEZ_D.LDBisOver then play_note:SetTextColor(1,1,1,1)
						else play_note:SetTextColor(1,1,1,.6) end
	----------------------------------------------------------------------------
	if WF_ez_DBC.btag_2right then
		play_btag:SetJustifyH("LEFT")
		play_btag:SetPoint("LEFT" ,play,"LEFT",WFEZ_D.sizes.MMARGS,0)
		play_btag:SetPoint("RIGHT",WFEZ_F.play_btag_maxwidth,"RIGHT")

		play_bble:SetPoint("LEFT" ,play_btag,"RIGHT",WFEZ_D.sizes.MMARGS,0)
		play_note:SetPoint("RIGHT",play_fact,"LEFT")
	else
		play_btag:ClearAllPoints()
		play_btag:SetJustifyH("RIGHT")
		play_btag:SetPoint("RIGHT",play_fact,"LEFT",-WFEZ_D.fonts.TXT_02,0)
		play_note:SetPoint("RIGHT",play_btag,"LEFT",-WFEZ_D.sizes.MMARGS,0)
	end
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	if WFEZ_D.isOpen then

	-- SCRIPT ------------------------------------------------------------------

	play:RegisterForClicks("AnyUp")
	play:SetScript("OnClick", function(self, button) WFEZ_O:SET_CLICK(groupID,id,button) end)
	play:SetScript("OnEnter", function() WFEZ_O:SET_TOOLT(false,groupID,id,x) end)
	play:SetScript("OnLeave", function() WFEZ_O:SET_TOOLT(true ,groupID,id,x) end)

	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	end

	local visible,counton,play_btag_w,play_name_w = false,false,0,0
	if p and p.name then -------------------------------------------------------

		visible,counton = true,true
		if WFEZ_D.LDBisOver then
			if (p.app ~= 'WoW' and p.app ~= 'IG') or not p.online then
				visible = false 	counton = false
			end
		elseif WFEZ_D.search and WFEZ_D.search ~= '' then
			local searchin = WFEZ_O:STRIP(p.search:lower())
			if not searchin:find(WFEZ_D.search) then
					visible = false 	counton = false 	end
		else
			if WF_ez_DBC.only_favori == 1 and not p.isfav then -------- only fav
					visible = false 	counton = false 	end

			if WF_ez_DBC.enable_offs == 0 and not p.online then --- hide offline
					visible = false 	counton = false 	end

			if WF_ez_DBC.only_ingame == 1 and ((p.app ~= 'WoW' and p.app ~= 'IG') or not p.online) then
					visible = false 	counton = false 	end -------- only IG

			if WF_ez_DBC.showguildie == 0 and p.guild then --------- is guildies
					visible = false 	counton = false 	end

			if WF_ez_DBC.grouphidden[groupID] then visible = false end -- hidden


		end
		------------------------------------------------------------------------
		if visible then --------------------------------------------------------

			local invplayer = p.name..(p.realm ~='' and '-'..p.realm or '')

			play:SetAlpha(p.online and 1 or .6)

			play_sfav:SetAlpha(p.isfav and 1 or .1)
			play_bg:SetColorTexture(p.color.r,p.color.g,p.color.b)

			play_name:SetText(p.name)  	play_name:SetTextColor(p.color.r,p.color.g,p.color.b)
			play_srvr:SetText(p.realm) 	play_srvr:SetTextColor(p.color.r,p.color.g,p.color.b,.5)
			play_levl:SetText(p.level)	play_levl:SetTextColor(p.color.r,p.color.g,p.color.b)

			play_btag:SetText(p.btag)
			play_note:SetText(p.rio..WFEZ_O:TRIM(p.notes)..(p.notes ~= '' and ' ' or '')..'|cff999999'..(p.area or ''))

			if WFEZ_D.game[p.app] then play_icon:SetTexture(WFEZ_D.game[p.app])
			 					  else play_icon:SetTexture(WFEZ_D.game["App"]) end

			-- if not p.online and p.app == "IG" then _G[x]:SetAlpha(.3) else _G[x]:SetAlpha(1) end end

			if WFEZ_D.game[p.faction] then play_fact:SetTexture(WFEZ_D.game[p.faction])
									  else play_fact:SetTexture('') end

			if invplayer and (UnitInParty(invplayer) or UnitInRaid(invplayer)) then
										   play_bble:SetVertexColor( 0,.6,.9, 1)
			 elseif p.status == 'mob' then play_bble:SetVertexColor(.8,.4, 0,.4)
			 elseif p.status == 'afk' then play_bble:SetVertexColor(.8,.4, 0, 1)
			 elseif p.status == 'dnd' then play_bble:SetVertexColor( 1, 0, 0, 1)
			 elseif p.status == 'onl' then play_bble:SetVertexColor( 0,.9,.2, 1)
				 					  else play_bble:SetVertexColor( 1, 1, 1,.3) end

		end --------------------------------------------------------------------
	end ------------------------------------------------------------------------

	play:ClearAllPoints()
	if counton then nb = nb+1 end
	if visible then

		t  = t +WFEZ_D.sizes.lines_h
		tg = tg+WFEZ_D.sizes.lines_h

		play_btag_w = play_btag:GetStringWidth()+WFEZ_D.sizes.MARGES*2
		play_name_w = play_name:GetStringWidth()+WFEZ_D.fonts.TXT_20*3
		if play_btag_w > WFEZ_D.play_btag_maxwidth then WFEZ_D.play_btag_maxwidth = play_btag_w end
		if play_name_w > WFEZ_D.play_name_maxwidth then WFEZ_D.play_name_maxwidth = play_name_w end

		play:SetParent(group)
		play:SetPoint("LEFT" ,group,"LEFT" , WFEZ_D.sizes.MARGES,-tg)
		play:SetPoint("RIGHT",group,"RIGHT",-WFEZ_D.sizes.MMARGS,0)
		play:Show()

	end

	return t,tg,nb
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
end
function WFEZ_O:SET_CLICK(groupID,id,button)
	local p = WFEZ_O:F(groupID,id)
	if p and p.name then -------------------------------------------------------
		local invplayer = p.name..(p.realm ~='' and '-'..p.realm or '')
		if button == "LeftButton" then
			if IsShiftKeyDown() then
				if p.online and (p.app=='WoW' or p.app=='IG') and not p.area:find('WoW Classic') and p.faction == WF_ez_DBC.player.faction then
					C_PartyInfo.InviteUnit(invplayer)
				end
			else
				if p.guild then -- wow guild
					local index = p.guild
					_G.ToggleGuildFrame()
				end
				if p.online and p.bnetid then -- bnet friend
					ChatFrame_SendBNetTell(p.btag)
				elseif p.online and not p.area:find('WoW Classic') and p.faction == WF_ez_DBC.player.faction then -- wow IG
					SetItemRef( 'player:'..invplayer, format('|Hplayer:%1$s|h[%1$s]|h',invplayer), 'LeftButton' )
				end
			end
		elseif button == "RightButton" then
			if p.guild then -- wow guild
				local index = p.guild
				_G.GuildRoster_ShowMemberDropDown(p.name, p.online, false, p.guid)
			elseif p.app =='IG' then -- wow friend
				FriendsFrame_ShowDropdown(p.name, p.online, nil, nil, nil, 1);
			elseif p.bnetid then -- bnet friend
				FriendsFrame_ShowBNDropdown(p.btag, p.online, nil, nil, nil, 1, p.bnetid);
			end
		end
	end ------------------------------------------------------------------------
end
function WFEZ_O:SET_TOOLT(hide,groupID,id,x)
	local p = WFEZ_O:F(groupID,id)
	if p and p.name then -------------------------------------------------------
		if hide and _G[x] then -------------------------------------------------
			GameTooltip:Hide()
			_G[x]:SetAlpha(p.online and 1 or .6)
			_G[x.."_bg"]:SetAlpha(0)
			_G[x.."_note"]:SetAlpha(.7)
			_G[x.."_btag"]:SetTextColor(1,1,1,.6)

		elseif _G[x] then ------------------------------------------------------

			_G[x]:SetAlpha(1)
			_G[x.."_bg"]:SetAlpha(.15)
			_G[x.."_note"]:SetAlpha(1)
			_G[x.."_btag"]:SetTextColor(p.color.r,p.color.g,p.color.b,1)

			GameTooltip:SetOwner(_G[x], "ANCHOR_BOTTOMRIGHT",WFEZ_D.sizes.MARGES*2.2,WFEZ_D.sizes.PANNELINFOS_H*3);
			GameTooltip:AddLine(p.name, p.color.r,p.color.g,p.color.b)
			GameTooltip:AddLine((p.race and p.race..' ' or '')..(p.class and p.class..' ' or ''), p.color.r,p.color.g,p.color.b)

			if WFEZ_D.gameic[p.faction] then GameTooltip:AddTexture(WFEZ_D.gameic[p.faction],{anchor=5}) end

			if p.notes and p.notes ~= '' then
				GameTooltip:AddLine(p.notes  ,1,1,1, true)
				GameTooltip:AddTexture(131129, {anchor=0,vertexColor={r=p.color.r,g=p.color.g,b=p.color.b,a=1},margin={right=2} })
			end
			if p.ofnotes and p.ofnotes ~= '' then
				GameTooltip:AddLine(p.ofnotes,.6,.6,.6, true)
				GameTooltip:AddTexture(131129, {anchor=0,vertexColor={r=1,g=1,b=1,a=.6},margin={right=2} })
			end
			GameTooltip:AddLine('\n')
			GameTooltip:AddDoubleLine(p.realm or ' ',p.area,1,1,1,.6,.6,.6);
			GameTooltip:AddLine('\n')
			if (p.online and p.bnetid) or (p.online and not p.area:find('WoW Classic') and p.faction == WF_ez_DBC.player.faction) then
				GameTooltip:AddLine('> LEFT CLICK: Whisper',.6,.6,.6)
			end
			if p.online and (p.app=='WoW' or p.app=='IG') and not p.area:find('WoW Classic') and p.faction == WF_ez_DBC.player.faction then
				GameTooltip:AddLine('> SHIFT LEFT: Invite',.6,.6,.6)
			end
			if p.guild then GameTooltip:AddLine('> LEFT CLICK: Guild pannel',.6,.6,.6)
					   else GameTooltip:AddLine('> RIGHT CLICK: Menu',.6,.6,.6) end
			GameTooltip:Show()
			WFEZ_O:SHOW_RIO(GameTooltip,p.name,p.realm,p.faction)
		end --------------------------------------------------------------------
	end ------------------------------------------------------------------------
end

-- -----------------------------------------------------------------------------
-- ✔︎ MENUS
-- -----------------------------------------------------------------------------

function WFEZ_O:MOVE2GROUP(name,groupID,bnet)
	local p = WFEZ_O:G(name,bnet)
	local nnote = p.notes or p.note or ""

	local addgroup = WFEZ_D.All_groups.f[groupID] and " #"..WFEZ_D.All_groups.f[groupID] or ""
	if groupID == "xxnogroupxx" then addgroup = "" end

	local newnotes = WFEZ_O:TRIM(nnote:gsub("#(.*)",''))..addgroup
	if bnet then BNSetFriendNote(p.bnetAccountID, newnotes)
	 	    else C_FriendList.SetFriendNotes(name,newnotes) end
end

function WFEZ_O:NEWGROUP(name,bnet)
	StaticPopup_Show("WFEZ_CREATEGRP", nil, nil, {x = name, bnet = bnet})
end

function WFEZ_O_CREATEGROUP(parent,data)

	local p = WFEZ_O:G(data.x,data.bnet)
	local nnote = p.notes or p.note or ""

	local addgroup = parent.editBox and " #"..parent.editBox:GetText() or ''
	local newnotes = WFEZ_O:TRIM(nnote:gsub("#(.*)",''))..addgroup

	if data.bnet then BNSetFriendNote(p.bnetAccountID,   newnotes)
				 else C_FriendList.SetFriendNotes(data.x,newnotes) end

	parent:Hide()
end

function WFEZ_O_ADDMENU(self, level)
	if not WFEZ_D.isOpen then return end
	local addMenu,bnet = false,false
	if UIDROPDOWNMENU_OPEN_MENU.which == "BN_FRIEND" or UIDROPDOWNMENU_OPEN_MENU.which == "BN_FRIEND_OFFLINE" then addMenu = true bnet = true end
	if UIDROPDOWNMENU_OPEN_MENU.which == "FRIEND"    or UIDROPDOWNMENU_OPEN_MENU.which == "FRIEND_OFFLINE"    then addMenu = true end

	if addMenu then
		UIDropDownMenu_AddSeparator(level)
		local name = UIDROPDOWNMENU_OPEN_MENU.name
		local menu = { isTitle = 1, notCheckable = 1, text = "Move to group :" } UIDropDownMenu_AddButton(menu)

		for groupID,groupName in WFEZ_O:SPAIRS(WFEZ_D.All_groups.f) do

			local menu = { text=groupName, notCheckable=true }
				  menu.func = function() WFEZ_O:MOVE2GROUP(name,groupID,bnet) end
				  UIDropDownMenu_AddButton(menu)
		end
			local menu = { text="--> New GROUP", notCheckable=true }
				  menu.func = function() WFEZ_O:NEWGROUP(name,bnet) end
				  UIDropDownMenu_AddButton(menu)
	end
end

WFEZ_O_ADDMENU(self, level)

--

-- -----------------------------------------------------------------------------
-- ✔︎ Fake DATAS
-- -----------------------------------------------------------------------------

-- "HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR", "DEATHKNIGHT", "MONK", "DEMONHUNTER"
-- "The Maw", "Maldraxxus", "Shrine of Two Moons", "Seat of the Primus", "Feralas", "Halls of Atonement", "De other Side", "Torghast", "Torghast", "Vale of Eternal Blossoms", "Orgrimmar", "Theater of Pain", "Oribos", "Oribos", "Oribos", "Oribos"
-- "Pandaren", "Tauren", "Orc", "Goblin", "BloodElf", "Troll Zandalari", "Troll", "Vulpera", "Mag'har Orc"
-- "Dwarf", "Pandaren", "Gnome", "Draenei", "Dwarf"
-- "Draenor","Silvermoon","Kazzak","Kazzak","Kazzak","Kazzak","Kazzak","Kazzak","Tarren Mill","Tarren Mill","Tarren Mill","Twisting Nether","Hyjal","Hyjal","Hyjal","Hyjal","Hyjal","Hyjal","Hyjal","Hyjal","Hyjal","Hyjal","Blackmoore","Blackmoore","Blackmoore","Ragnaros","Ravencrest","Blackrock","Khaz Modan","Burning Legion","Kazzak","Kazzak","Kazzak","Kazzak","Uldum","Un'Goro","Vashj"
-- 17,33,55,57,21,42,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60

function WFEZ_O:FAKE_GUILDIES()
	local guildies = ''
	local clssgul = {"MONK", "DEMONHUNTER", "DEATHKNIGHT", "WARLOCK", "MAGE", "DEATHKNIGHT", "ROGUE", "SHAMAN", "WARRIOR" };
	local namegul = {"Nickname", "Guildie1", "Playerbeta", "Lidia", "Ramírez338", "Colomer", "Belen", "Shamyplayer", "Warhit"};

	for i, y in pairs(clssgul) do
		local c = RAID_CLASS_COLORS[y] or 'FFF4F4F4' -- WFEZ_O:GET_COLOR(className)
		guildies =guildies.." |c"..c.colorStr..namegul[i].."|r ";
	end
	return guildies or ''
end
function WFEZ_O:FAKE_GUILDIES_ALL()
	if not WFEZ_D.isOpen then return end

	local allguildies = {
		{name = "Claire",		on = true, class = "MONK", 			rio= WFEZ_O:COLOR_RIO(1480),	level= 60,	note='TANK 192', area= "Vale of Eternal Blossoms" },
		{name = "Louisette",	on = false, class = "DEATHKNIGHT", 	rio= WFEZ_O:COLOR_RIO(860),		level= 60,	note='Reroll Alba', area= "Oribos" },
		{name = "Donnie",		on = true, class = "DEMONHUNTER",	rio= WFEZ_O:COLOR_RIO(772),		level= 60,	note='MELEE 208', area= "Torghast" },
		{name = "Vasily",		on = true, class = "MAGE", 			rio= '',						level= 33,	note='RANGE ', area= "Orgrimmar" },
		{name = "Dode",			on = true, class = "WARLOCK", 		rio= '',						level= 17,	note='Reroll Alba', area= "Orgrimmar" },
		{name = "Kahaleel",		on = true, class = "ROGUE", 		rio= '',						level= 17,	note='Reroll Alba', area= "Orgrimmar" },
		{name = "Lina",			on = true, class = "SHAMAN", 		rio= WFEZ_O:COLOR_RIO(1860),	level= 60,	note='HEAL 218', area= "Oribos" },
		{name = "Moshe",		on = false, class = "MAGE",			rio= '',						level= 42,	note='RANGE ', area= "" },
		{name = "Rivi",			on = true, class = "HUNTER", 		rio= WFEZ_O:COLOR_RIO(1442),	level= 60,	note='Friends Dode', area= "Theater of Pain" }
	}
	for i, g in pairs(allguildies) do
		local roleid,rankID,rank,afk,dnd = '6/ NameOfRank',6,'NameOfRank',false,false

			if i ==1 then roleid = '1/ Officer';   rankID = 0; rank = 'GuildMaster';
		elseif i < 3 then roleid = '1/ Officer';   rankID = 1; rank = 'Officer';
		elseif i < 5 then roleid = '4/ Guildrank'; rankID = 4; rank = 'Guildrank'; end

		if i == 7 then afk = true end
		if i == 4 then dnd = true end

		local build = { connected = g.on,
							 btag = rank,
						   roleid = roleid,
					   guildindex = i,
							 name = g.name,
						className = g.class,
							  rio = g.rio,
						realmName = '',
							level = g.level,
							 area = g.area,
							  afk = afk,
							  dnd = dnd,
						  faction = "Horde",
							notes = g.note }
		WFEZ_O:BUILD_FRIENDS(build,rankID..'_playerguild'..i,'guild')
	end
end
function WFEZ_O:FAKE_FRIENDS_BNET_ALL()
	if not WFEZ_D.isOpen then return end

	local allfriends = {
		 { on=1,note="Fake note contact #MM+ SL",client="WTCG",account ="Seana",name ="Seana",class ="PRIEST",level =60,rio ="",area ="Torghast",guid ="538343131-4",raceh ="Pandaren",racea ="Dwarf",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #Friends",client="WTCG",account ="Darb",name ="Darb",class ="WARRIOR",level =60,rio ="",area ="Halls of Atonement",guid ="231648492-1",raceh ="Goblin",racea ="Draenei",realm ="Kazzak"}
		,{ isfav=true, on=1,note="Fake note contact #Friends",client="BSAp",account ="Hamlen",name ="Hamlen",class ="DEATHKNIGHT",level =60,rio ="",area ="",guid ="342052922-8",raceh ="Pandaren",racea ="Dwarf",realm ="Hyjal"}
		,{ isfav=true, on=1,note="Fake note contact #Friends",client="Pro",account ="Bobbette",name ="Bobbette",class ="DRUID",level =60,rio ="",area ="",guid ="724898939-8",raceh ="Goblin",racea ="Pandaren",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #Friends",client="ODIN",account ="Adria",name ="Adria",class ="MAGE",level =17,rio ="",area ="Halls of Atonement",guid ="018579619-2",raceh ="Troll",racea ="Draenei",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #Friends",client="WoW",account ="Marrilee",name ="Burt",class ="DEMONHUNTER",level =60,rio ="",area ="Oribos",guid ="601654491-4",raceh ="Mag'har Orc",racea ="Pandaren",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #Friends",client="WoW",account ="Graham",name ="Trey",class ="MONK",level =60,rio ="",area ="Theater of Pain",guid ="494711833-4",raceh ="Goblin",racea ="Dwarf",realm ="Hyjal"}
		,{ note="Fake note contact #Friends",client="WoW",account ="Dirk",name ="Elnar",class ="PRIEST",level =60,rio ="",area ="Shrine of Two Moons",guid ="663208011-1",raceh ="Goblin",racea ="Dwarf",realm ="Blackmoore"}
		,{ isfav=true, note="Fake note contact #Friends",client="WoW",account ="Hammad",name ="Perle",class ="DEATHKNIGHT",level =55,rio ="",area ="Feralas",guid ="471519233-0",raceh ="Troll Zandalari",racea ="Gnome",realm ="Kazzak"}
		,{ note="Fake note contact #Friends",client="WoW",account ="Cordelie",name ="Wilbur",class ="DEATHKNIGHT",level =60,rio ="",area ="The Maw",guid ="532789560-2",raceh ="Vulpera",racea ="Draenei",realm ="Burning Legion"}
		,{ note="Fake note contact #Friends",client="WoW",account ="Clair",name ="Brinn",class ="PALADIN",level =60,rio ="",area ="Torghast",guid ="408504784-1",raceh ="BloodElf",racea ="Dwarf",realm ="Tarren Mill"}
		,{ isfav=true, on=1,note="Fake note contact #Friends",client="WoW",account ="Chrystal",name ="Renae",class ="MAGE",level =60,rio ="",area ="Torghast",guid ="853008693-7",raceh ="Pandaren",racea ="Gnome",realm ="Twisting Nether"}
		,{ isfav=true, on=1,note="Fake note contact #Friends",client="WoW",account ="Lauree",name ="Linc",class ="PALADIN",level =60,rio ="",area ="De other Side",guid ="062289343-2",raceh ="Orc",racea ="Pandaren",realm ="Blackrock"}
		,{ isfav=true, on=1,note="Fake note contact #Friends",client="BSAp",account ="Vernor",name ="Rodge",class ="ROGUE",level =21,rio ="",area ="De other Side",guid ="658382314-4",raceh ="BloodElf",racea ="Pandaren",realm ="Ragnaros"}
		,{ isfav=true, note="Fake note contact #Friends",client="BSAp",account ="Prisca",name ="Orly",class ="PALADIN",level =60,rio ="",area ="Oribos",guid ="649268657-8",raceh ="Tauren",racea ="Dwarf",realm ="Tarren Mill"}
		,{ isfav=true, note="Fake note contact #Friends",client="BSAp",account ="Tad",name ="Edgardo",class ="WARRIOR",level =60,rio ="",area ="Oribos",guid ="740242460-X",raceh ="Troll",racea ="Gnome",realm ="Kazzak"}
		,{ isfav=true, note="Fake note contact #Friends",client="WoW",account ="Durand",name ="Mattie",class ="DRUID",level =60,rio ="",area ="Feralas",guid ="265936622-5",afk =24,dnd =24,raceh ="BloodElf",racea ="Draenei",side ="a",realm ="Hyjal"}
		,{ isfav=true, note="Fake note contact #Friends",client="WoW",account ="Ardath",name ="Daniella",class ="SHAMAN",level =60,rio ="",area ="Oribos",guid ="730073685-8",afk =25,dnd =25,raceh ="Pandaren",racea ="Dwarf",side ="a",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #MM+ SL",client="WoW",account ="Devin",name ="Annmaria",class ="ROGUE",level =33,rio ="",area ="Maldraxxus",guid ="430868591-5",raceh ="Troll",racea ="Dwarf",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #MM+ SL",client="WoW",account ="Reuven",name ="Minnaminnie",class ="MONK",level =21,rio ="",area ="Torghast",guid ="522314866-5",raceh ="Troll",racea ="Pandaren",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #MM+ SL",client="WoW",account ="Roth",name ="Danila",class ="MONK",level =60,rio ="",area ="De other Side",guid ="754138037-7",raceh ="Vulpera",racea ="Pandaren",realm ="Hyjal"}
		,{ note="Fake note contact #MM+ SL",client="App",account ="Hillery",name ="Christie",class ="PALADIN",level =60,rio ="",area ="The Maw",guid ="777980787-8",raceh ="Mag'har Orc",racea ="Pandaren",realm ="Hyjal"}
		,{ note="Fake note contact #MM+ SL",client="App",account ="Gaile",name ="Morie",class ="SHAMAN",level =60,rio ="",area ="Seat of the Primus",guid ="010292452-X",raceh ="Orc",racea ="Draenei",realm ="Draenor"}
		,{ isfav=true, note="Fake note contact #MM+ SL",client="App",account ="Shelagh",name ="Demetria",class ="HUNTER",level =55,rio ="",area ="Orgrimmar",guid ="912001289-6",raceh ="Tauren",racea ="Draenei",realm ="Hyjal"}
		,{ isfav=true, on=1,note="Fake note contact #MM+ SL",client="App",account ="Rusty",name ="Elysha",class ="DRUID",level =60,rio ="",area ="De other Side",guid ="924858035-1",raceh ="Troll Zandalari",racea ="Dwarf",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #MM+ SL",client="WoW",account ="Roarke",name ="Tris",class ="PRIEST",level =60,rio ="",area ="Feralas",guid ="364522870-5",afk =41,dnd =41,raceh ="BloodElf",racea ="Dwarf",side ="a",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #MM+ SL",client="WoW",account ="Curt",name ="Sara-ann",class ="DEATHKNIGHT",level =42,rio ="",area ="Halls of Atonement",guid ="405701001-7",raceh ="Troll Zandalari",racea ="Dwarf",realm ="Blackmoore"}
		,{ on=1,note="Fake note contact #MM+ SL",client="WoW",account ="Zaneta",name ="Frazer",class ="ROGUE",level =60,rio ="",area ="Oribos",guid ="534068491-1",raceh ="BloodElf",racea ="Gnome",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #MM+ SL",client="WoW",account ="Dare",name ="Clayborn",class ="PALADIN",level =60,rio ="",area ="Halls of Atonement",guid ="373260974-X",afk =45,dnd =45,raceh ="Tauren",racea ="Gnome",side ="a",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #MM+ SL",client="WoW",account ="Reinaldos",name ="Trixy",class ="SHAMAN",level =60,rio ="",area ="Maldraxxus",guid ="928871221-6",raceh ="Mag'har Orc",racea ="Dwarf",realm ="Kazzak"}
		,{ note="Fake note contact #MM+ SL",client="BSAp",account ="Adda",name ="Jodee",class ="WARLOCK",level =60,rio ="",area ="Shrine of Two Moons",guid ="480312428-0",raceh ="Orc",racea ="Dwarf",realm ="Hyjal"}
		,{ note="Fake note contact #MM+ SL",client="BSAp",account ="Bettye",name ="Skyler",class ="HUNTER",level =60,rio ="",area ="Feralas",guid ="655801741-5",afk =52,dnd =52,raceh ="BloodElf",racea ="Gnome",side ="a",realm ="Hyjal"}
		,{ note="Fake note contact #MM+ SL",client="BSAp",account ="Stephen",name ="Deanna",class ="PRIEST",level =60,rio ="",area ="The Maw",guid ="417854740-2",afk =53,dnd =53,raceh ="Tauren",racea ="Dwarf",side ="a",realm ="Hyjal"}
		,{ isfav=true, note="Fake note contact #MM+ SL",client="BSAp",account ="Kassey",name ="Nikki",class ="MONK",level =60,rio ="",area ="Torghast",guid ="591955346-4",afk =54,dnd =54,raceh ="Vulpera",racea ="Dwarf",side ="a",realm ="Hyjal"}
		,{ isfav=true, on=1,note="Fake note contact #MM+ BFA",client="BSAp",account ="Poppy",name ="Johann",class ="WARRIOR",level =33,rio ="",area ="Maldraxxus",guid ="084179849-4",raceh ="Troll Zandalari",racea ="Dwarf",realm ="Draenor"}
		,{ on=1,note="Fake note contact #MM+ BFA",client="BSAp",account ="Agretha",name ="Jena",class ="PALADIN",level =60,rio ="",area ="Torghast",guid ="390434032-8",raceh ="Pandaren",racea ="Dwarf",realm ="Hyjal"}
		,{ note="Fake note contact #MM+ BFA",client="BSAp",account ="Drusy",name ="Towney",class ="ROGUE",level =33,rio ="",area ="Orgrimmar",guid ="797244496-X",raceh ="Troll Zandalari",racea ="Gnome",realm ="Khaz Modan"}
		,{ note="Fake note contact #MM+ BFA",client="BSAp",account ="Clim",name ="Dom",class ="DRUID",level =60,rio ="",area ="Vale of Eternal Blossoms",guid ="761894023-1",raceh ="Troll",racea ="Gnome",realm ="Kazzak"}
		,{ note="Fake note contact #MM+ BFA",client="BSAp",account ="Dulcy",name ="Flin",class ="SHAMAN",level =60,rio ="",area ="Oribos",guid ="682194673-6",raceh ="BloodElf",racea ="Dwarf",realm ="Khaz Modan"}
		,{ note="Fake note contact #MM+ BFA",client="App",account ="Frederique",name ="Papagena",class ="PALADIN",level =60,rio ="",area ="Maldraxxus",guid ="620037941-6",raceh ="Goblin",racea ="Dwarf",realm ="Kazzak"}
		,{ note="Fake note contact #MM+ BFA",client="WoW",account ="Spenser",name ="Tamera",class ="DEATHKNIGHT",level =60,rio ="",area ="Torghast",guid ="347629283-5",raceh ="Goblin",racea ="Dwarf",realm ="Hyjal"}
		,{ note="Fake note contact #MM+ BFA",client="WoW",account ="Hewett",name ="Cortie",class ="SHAMAN",level =60,rio ="",area ="Torghast",guid ="842749098-4",raceh ="Pandaren",racea ="Dwarf",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #MM+ BFA",client="WoW",account ="Brook",name ="Silvain",class ="ROGUE",level =60,rio ="",area ="The Maw",guid ="066874644-0",raceh ="Troll",racea ="Dwarf",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #MM+ BFA",client="WoW",account ="Gena",name ="Talbert",class ="DEMONHUNTER",level =60,rio ="",area ="Maldraxxus",guid ="790671362-1",raceh ="Orc",racea ="Dwarf",realm ="Blackmoore"}
		,{ on=1,note="Fake note contact #MM+ BFA",client="WoW",account ="Lew",name ="Eric",class ="MONK",level =57,rio ="",area ="Halls of Atonement",guid ="628541796-2",raceh ="BloodElf",racea ="Pandaren",realm ="Hyjal"}
		,{ note="Fake note contact #MM+ BFA",client="App",account ="Aundrea",name ="Zena",class ="ROGUE",level =33,rio ="",area ="Orgrimmar",guid ="971781054-0",raceh ="Pandaren",racea ="Draenei",realm ="Kazzak"}
		,{ note="Fake note contact #MM+ BFA",client="App",account ="Allina",name ="Antonius",class ="PRIEST",level =60,rio ="",area ="Seat of the Primus",guid ="036017046-3",raceh ="Pandaren",racea ="Pandaren",realm ="Kazzak"}
		,{ note="Fake note contact #MM+ BFA",client="App",account ="Karen",name ="Jaime",class ="DEATHKNIGHT",level =60,rio ="",area ="Feralas",guid ="363266615-6",raceh ="Troll",racea ="Draenei",realm ="Blackmoore"}
		,{ note="Fake note contact #MM+ BFA",client="ODIN",account ="Dorree",name ="Sampson",class ="MONK",level =60,rio ="",area ="Maldraxxus",guid ="890680189-0",raceh ="Pandaren",racea ="Gnome",realm ="Vashj"}
		,{ note="Fake note contact #MM+ BFA",client="App",account ="Gifford",name ="Charity",class ="PALADIN",level =60,rio ="",area ="Maldraxxus",guid ="874967216-9",raceh ="Goblin",racea ="Dwarf",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #MM+ BFA",client="App",account ="Carmella",name ="Del",class ="ROGUE",level =60,rio ="",area ="The Maw",guid ="315589055-X",raceh ="Troll",racea ="Dwarf",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #PVP",client="WoW",account ="Ad",name ="Zara",class ="PALADIN",level =57,rio ="",area ="Vale of Eternal Blossoms",guid ="753854780-0",raceh ="BloodElf",racea ="Dwarf",realm ="Draenor"}
		,{ isfav=true, on=1,note="Fake note contact #PVP",client="App",account ="Roley",name ="Freddy",class ="PRIEST",level =60,rio ="",area ="Orgrimmar",guid ="706934611-5",raceh ="Mag'har Orc",racea ="Draenei",realm ="Kazzak"}
		,{ isfav=true, note="Fake note contact #PVP",client="BSAp",account ="Bernadina",name ="Janetta",class ="PALADIN",level =60,rio ="",area ="Torghast",guid ="259559210-6",raceh ="Troll Zandalari",racea ="Gnome",realm ="Draenor"}
		,{ note="Fake note contact #PVP",client="App",account ="Nolie",name ="Freeman",class ="HUNTER",level =60,rio ="",area ="Feralas",guid ="111135740-4",raceh ="Troll Zandalari",racea ="Draenei",realm ="Hyjal"}
		,{ note="Fake note contact #PVP",client="App",account ="Wash",name ="Nolana",class ="DRUID",level =60,rio ="",area ="Seat of the Primus",guid ="149611122-2",raceh ="Troll Zandalari",racea ="Dwarf",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #PU - Raid",client="WoW",account ="Sander",name ="Merrilee",class ="ROGUE",level =60,rio ="",area ="Seat of the Primus",guid ="745571992-2",raceh ="Troll",racea ="Gnome",realm ="Kazzak"}
		,{ on=1,note="Fake note contact #PU - Raid",client="WoW",account ="Tore",name ="Timoteo",class ="WARLOCK",level =60,rio ="",area ="Oribos",guid ="306570561-3",raceh ="Pandaren",racea ="Dwarf",realm ="Ragnaros"}
		,{ on=1,note="Fake note contact #PU - Raid",client="WoW",account ="Dorelle",name ="Coleen",class ="DEMONHUNTER",level =57,rio ="",area ="Theater of Pain",guid ="749486993-X",raceh ="Orc",racea ="Dwarf",realm ="Tarren Mill"}
		,{ on=1,note="Fake note contact #PU - Raid",client="App",account ="Bernadine",name ="Heather",class ="WARRIOR",level =60,rio ="",area ="Oribos",guid ="050745181-3",raceh ="Tauren",racea ="Dwarf",realm ="Hyjal"}
		,{ on=1,note="Fake note contact #PU - Raid",client="BSAp",account ="Alexandro",name ="Alysia",class ="PALADIN",level =60,rio ="",area ="Oribos",guid ="191550339-6",afk =96,dnd =96,raceh ="Orc",racea ="Gnome",side ="a",realm ="Blackmoore"}
		,{ note="Fake note contact #PU - Raid",client="App",account ="Adda",name ="Marylou",class ="WARLOCK",level =17,rio ="",area ="Vale of Eternal Blossoms",guid ="059312957-1",raceh ="Mag'har Orc",racea ="Gnome",realm ="Twisting Nether"}
		,{ note="Fake note contact #PU - Raid",client="App",account ="Jordon",name ="Franklin",class ="SHAMAN",level =60,rio ="",area ="Orgrimmar",guid ="976719717-6",raceh ="Pandaren",racea ="Dwarf",realm ="Kazzak"}
		,{ note="Fake note contact #PU - Raid",client="App",account ="Nobie",name ="Becca",class ="DRUID",level =60,rio ="",area ="Shrine of Two Moons",guid ="748326203-6",raceh ="Troll",racea ="Gnome",realm ="Uldum"}
	}

	for i, g in pairs(allfriends) do
		local connected = true
		local accountName = g.account
		local name = g.name
		local race = g.raceh
		local faction = "Horde"

		if g.side == "a" then
			faction = "Alliance"
			race = g.racea
		end
		if not g.on then
			connected = false
			name = g.account
			g.class = nil
			race = nil
			faction = nil
			g.client = 'App'
			g.area = nil
			g.afk = nil
			g.dnd = nil
		end
		if g.client ~= 'WoW' then
			g.class = nil
			race = nil
			faction = nil
			g.realm = nil
			g.level = nil
		end
		if g.client == 'App' or g.client == 'BSAp' then
			g.area = nil
		end
		if g.client =="WTCG" then
			g.area = "Doing battle in Play Mode!"
		end
		if g.client =="ODIN" then
			g.area = "playing Warzone in Rebirth Island"
		end

		local player = {connected = connected,
							 btag = g.account,
						   bnetid = g.account,
							 name = name,
							 isfav = g.isfav,
						className = g.class,
							 race = race,
						realmName = g.realm,
							level = g.level,
							 area = g.area,
							  afk = (g.afk and true or false),
							  dnd = (g.dnd and true or false),
						  faction = faction,
							notes = g.note
		}

		WFEZ_O:BUILD_FRIENDS(player,i..g.guid,g.client)
	end

end
function WFEZ_O:FAKE_FRIENDS_ALL()
	if not WFEZ_D.isOpen then return end

	local allfriends = {
		 { on=1,note="Fake note IG player #Friends", account= "Millicent",realm="Hyjal", name= "Adelice",class= "DRUID",level= 60,rio= "",area= "Halls of Atonement",guid= "441971632-0",raceh= "Pandaren",racea= "Dwarf"}
		,{ on=1,note="Fake note IG player", account= "Eddy",realm="Hyjal", name= "Drusilla",class= "DEATHKNIGHT",level= 60,rio= "",area= "The Maw",guid= "632375719-2",raceh= "Troll Zandalari",racea= "Dwarf"}
		,{ on=1,note="Fake note IG player #PVP", account= "Vergil",realm="Hyjal", name= "Gregoor",class= "MONK",level= 55,rio= "",area= "Halls of Atonement",guid= "072327053-8",raceh= "Tauren",racea= "Gnome"}
		,{ on=1,note="Another fake note #PVP", account= "Martina",realm="Hyjal", name= "Giuditta",class= "DRUID",level= 60,rio= "",area= "Theater of Pain",guid= "604749592-3",afk= 5,dnd= 5,raceh= "Troll",racea= "Dwarf"}
		,{ note="HEAL CR 2k4 #PVP", account= "Gregorius",realm="Kazzak", name= "Angelica",class= "PALADIN",level= 60,rio= "",area= "Offline",guid= "152787705-1",raceh= "Orc",racea= "Dwarf"}
		,{ on=1,note="Fake note IG player", account= "Otho",realm="Hyjal", name= "Lonni",class= "MAGE",level= 60,rio= "",area= "Vale of Eternal Blossoms",guid= "904083168-8",raceh= "Troll",racea= "Dwarf"}
		,{ note="Fake note IG player", account= "Jozef",realm="Hyjal", name= "Rip",class= "DRUID",level= 60,rio= "",area= "Seat of the Primus",guid= "935995084-X",raceh= "Orc",racea= "Gnome"}
		,{ note="Fake note IG player", account= "Mavra",realm="Hyjal", name= "Raynard",class= "WARRIOR",level= 60,rio= "",area= "Offline",guid= "142731967-7",raceh= "Goblin",racea= "Dwarf"}
	}
	for i, g in pairs(allfriends) do

		local connected = true
		local accountName = g.account
		local name = g.name
		local className = g.class
		local race = g.raceh
		local faction = "Horde"

		if g.side == "a" then
			faction = "Alliance"
			race = g.racea
		end
		if not g.on then
			connected = false
			name = g.account
			className = ''
			race = ''
			faction = ''
		end

		local player = {connected = connected,
							 btag = '',
							 name = name,
						className = className,
							 race = race,
						realmName = WFEZ_D.playerrlm,
							level = g.level,
							 area = g.area,
							  afk = (g.afk and true or false),
							  dnd = (g.dnd and true or false),
						  faction = faction,
							notes = g.note
		}

		WFEZ_O:BUILD_FRIENDS(player,i..g.guid,'IG')
	end
end