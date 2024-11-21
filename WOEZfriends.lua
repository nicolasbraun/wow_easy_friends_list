-- -----------------------------------------------------------------------------
--[[----------------------------------------------------------------------------

                    __    ,- WOEZ FRIENDS LIST
                   /✷_)      Made with ❤ by woOtzee
           _.---._/ /
         /         /
      _/         |/
     /__.-|_|--|_|

                                     Feel free to contact me / hello@wootzee.com
-- -------------------------------------------------------------------------]]--
-- -----------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local WFEZ_D,WFEZ_O,WFEZ_F,L = ns.datas,ns.functions,ns.frames,ns.locales
_G.WFEZ = WFEZ_O

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- ✔︎ EVENTS
-- -----------------------------------------------------------------------------

for _,event in pairs(WFEZ_D.events) do
    WFEZ_O:DEBUG('REGISTER',event)
    WFEZ_F.main:RegisterEvent(event)
end

WFEZ_F.main:SetScript("OnEvent",function(self,event,...)
    local arg = ...
    WFEZ_O:DEBUG('FIRE',event,tostring(arg))
    ----------------------------------------------------------------------------
    if event == "ADDON_LOADED" and arg == ADDON_NAME then
		WFEZ_O:LOAD()
		WFEZ_F.main:UnregisterEvent("ADDON_LOADED")
	else -----------------------------------------------------------------------
		if not WFEZ_D.LOAD then return end
		WFEZ_O:REFRESH(true)
	----------------------------------------------------------------------------
    end return
end)

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- ✔︎ SLASH COMMAND
-- -----------------------------------------------------------------------------

SLASH_WFEZ1 = "/woezfriends"
SLASH_WFEZ2 = "/friends"
SLASH_WFEZ3 = "/wf"

SlashCmdList.WFEZ = function(msg)
	if msg and msg == "icon" then -- /wf icon
		WFEZ_O:ICON_TOGGL()
	elseif msg and msg:find('^alpha ') then -- /wf alpha 40
		WFEZ_O:TRANSPARENCY(msg)
	elseif msg and msg == "guildies" then -- /wf guildies
		WFEZ_O:LDBGUILD_TOGGL()
	elseif msg and (msg == "btagleft" or msg == "btagtoggle" or msg == "btagright") then -- /wf btagtoggle
		WFEZ_O:BNET_TOGGL()
	else
		WFEZ_O:CHECK_OPEN()
	end
end

-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
-- ✔︎ KEYBINDS
-- -----------------------------------------------------------------------------

BINDING_HEADER_WOEZFRIENDS = "WOEZ Friends"
_G["BINDING_NAME_OPENCLOSE"] = "Open / Close pannel"

-- -----------------------------------------------------------------------------


-- local hotkey = select ( 3 , GetBinding(197) );
