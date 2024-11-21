-- -----------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local WFEZ_D,WFEZ_O,WFEZ_F,L = ns.datas,ns.functions,ns.frames,ns.locales

-- -----------------------------------------------------------------------------
-- ✔︎ MAIN
-- -----------------------------------------------------------------------------

WFEZ_F.main = WFEZ_O:FRAM("WFEZframe","Frame",UIParent,nil,
                                "TOP",0,-200,nil,nil, -- position
                                444,222) -- size
WFEZ_F.main:Hide()
WFEZ_F.main_f = WFEZ_O:FADE("WFEZframefade",WFEZ_F.main,true,.4)
WFEZ_F.main:SetResizable(true)
WFEZ_F.main:SetClampedToScreen(true)
WFEZ_F.main:SetMinResize(GetScreenWidth()*.1,GetScreenHeight()*.1)
WFEZ_F.main:SetMaxResize(GetScreenWidth()*5/8,GetScreenHeight()*18/20)

WFEZ_F.main:SetMovable(true)
WFEZ_F.main:SetScript("OnMouseDown", function() WFEZ_F.main:StartMoving() end)
WFEZ_F.main:SetScript("OnMouseUp"  , function() WFEZ_F.main:StopMovingOrSizing() end)

WFEZ_F.main_rb = WFEZ_O:FRAM("WFEZframeRB","Button",WFEZ_F.main,nil,
                                "BOTTOMRIGHT", 0,0,nil,nil, -- position
                                WFEZ_D.fonts.TXT,WFEZ_D.fonts.TXT) -- size
WFEZ_F.main_rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
WFEZ_F.main_rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
WFEZ_F.main_rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
WFEZ_F.main_rb:SetScript("OnMouseDown", function() WFEZ_F.main:StartSizing("BOTTOMRIGHT")  end)
WFEZ_F.main_rb:SetScript("OnMouseUp"  , function()
    WFEZ_F.main:StopMovingOrSizing()
    WF_ez_DBC.width = WFEZ_F.main:GetWidth()
    WF_ez_DBC.heigh = WFEZ_F.main:GetWidth()
end)
WFEZ_F.main:SetFrameStrata("DIALOG")

tinsert(UISpecialFrames,"WFEZframe")
WFEZ_F.main:SetScript("OnShow", function()
	if WFEZ_D.LDBisOver then WFEZ_O:CLOSE_LDB() end
	WFEZ_D.isOpen = true  WFEZ_O:REFRESH(true)
end)
WFEZ_F.main:SetScript("OnHide", function() WFEZ_D.isOpen = false end)

-- -----------------------------------------------------------------------------
-- ✔︎ BOTTOM
-- -----------------------------------------------------------------------------

WFEZ_F.bottom = WFEZ_O:FRAM("WFEZbottom","Frame",WFEZ_F.main,nil)
WFEZ_F.bottom:SetPoint("TOPLEFT"    ,WFEZ_F.main, "BOTTOMLEFT"  ,  WFEZ_D.sizes.MARGES    ,WFEZ_D.sizes.PANNELINFOS_H+WFEZ_D.sizes.MARGES)
WFEZ_F.bottom:SetPoint("BOTTOMRIGHT",WFEZ_F.main, "BOTTOMRIGHT" ,-(WFEZ_D.sizes.MARGES*11),WFEZ_D.sizes.MARGES)
-- WFEZ_F.bottom_f    = WFEZ_O:FADE("WFEZbottomfade",WFEZ_F.bottom,true,WF_ez_DBC.transparency)

WFEZ_F.bottnc = WFEZ_O:FRAM("WFEZbottom_c","Button",WFEZ_F.bottom,"UIPanelButtonTemplate","LEFT",WFEZ_F.bottom,"LEFT",WFEZ_D.sizes.MMARGS,0, WFEZ_D.fonts.TXT_12*2.3, WFEZ_D.fonts.TXT_12*2.3)
WFEZ_F.bottnc:DisableDrawLayer("BACKGROUND")
WFEZ_F.bottnc:SetHighlightTexture('')
WFEZ_F.bottnc:SetNormalTexture("Interface\\CHARACTERFRAME\\Disconnect-Icon")
WFEZ_F.bottnc:SetPushedTexture("Interface\\CHARACTERFRAME\\Disconnect-Icon")
WFEZ_F.bottnc:SetScript("OnClick", function()
    if WF_ez_DBC.enable_offs == 0 then WF_ez_DBC.enable_offs = 1
                             	  else WF_ez_DBC.enable_offs = 0 end WFEZ_O:REFRESH() end)
WFEZ_F.bottnc.tooltipText = "VIEW OFFLINE PLAYER";

WFEZ_F.bottnd = WFEZ_O:FRAM("WFEZbottom_d","Button",WFEZ_F.bottom,"UIPanelButtonTemplate","LEFT",WFEZ_F.bottnc,"RIGHT",0,0, WFEZ_D.fonts.TXT_14, WFEZ_D.fonts.TXT_14)
WFEZ_F.bottnd:DisableDrawLayer("BACKGROUND")
WFEZ_F.bottnd:SetHighlightTexture('')
WFEZ_F.bottnd:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIcon-WoW")
WFEZ_F.bottnd:SetPushedTexture("Interface\\CHATFRAME\\UI-ChatIcon-WoW")
WFEZ_F.bottnd:SetScript("OnClick", function()
    if WF_ez_DBC.only_ingame == 0 then WF_ez_DBC.only_ingame = 1
                             	  else WF_ez_DBC.only_ingame = 0 end WFEZ_O:REFRESH() end)
WFEZ_F.bottnd.tooltipText = "VIEW IN GAME PLAYER ONLY";

WFEZ_F.bottne = WFEZ_O:FRAM("WFEZbottom_e","Button",WFEZ_F.bottom,"UIPanelButtonTemplate","LEFT",WFEZ_F.bottnd,"RIGHT",WFEZ_D.sizes.MARGES,0, WFEZ_D.fonts.TXT_14, WFEZ_D.fonts.TXT_14)
WFEZ_F.bottne:DisableDrawLayer("BACKGROUND")
WFEZ_F.bottne:SetHighlightTexture('')
WFEZ_F.bottne:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatConversationIcon")
WFEZ_F.bottne:SetPushedTexture("Interface\\CHATFRAME\\UI-ChatConversationIcon")
WFEZ_F.bottne:SetScript("OnClick", function()
    if WF_ez_DBC.showguildie == 0 then WF_ez_DBC.showguildie = 1
                             	  else WF_ez_DBC.showguildie = 0 end WFEZ_O:REFRESH(true) end)
WFEZ_F.bottne.tooltipText = "VIEW GUILD";

WFEZ_F.bottnf = WFEZ_O:FRAM("WFEZbottom_f","Button",WFEZ_F.bottom,"UIPanelButtonTemplate","LEFT",WFEZ_F.bottne,"RIGHT",WFEZ_D.sizes.MMARGS,-WFEZ_D.fonts.TXT*.3, WFEZ_D.fonts.TXT_12*2.3, WFEZ_D.fonts.TXT_12*2.3)
WFEZ_F.bottnf:DisableDrawLayer("BACKGROUND")
WFEZ_F.bottnf:SetHighlightTexture('')
WFEZ_F.bottnf:SetNormalTexture("Interface\\COMMON\\FavoritesIcon")
WFEZ_F.bottnf:SetPushedTexture("Interface\\COMMON\\FavoritesIcon")
WFEZ_F.bottnf:SetScript("OnClick", function()
    if WF_ez_DBC.only_favori == 0 then WF_ez_DBC.only_favori = 1
                             	  else WF_ez_DBC.only_favori = 0 end WFEZ_O:REFRESH() end)
WFEZ_F.bottnf.tooltipText = "VIEW FAVORITES ONLY";

WFEZ_F.bottom_TXT = WFEZ_O:FONT("WFEZ_TXT",WFEZ_F.bottom, "LEFT",WFEZ_F.bottne,"RIGHT",WFEZ_D.sizes.MARGES*4.4,0)
WFEZ_F.bottom_TXT:SetPoint("RIGHT",WFEZ_F.bottom,"RIGHT",-WFEZ_D.sizes.MARGES,0)
WFEZ_F.bottom_TXT:SetTextColor(.4,.4,.4,1)

WFEZ_F.clsbtn = WFEZ_O:FRAM("WFEZ_clsbtn","Button",WFEZ_F.main,"UIPanelButtonTemplate","BOTTOMRIGHT",WFEZ_F.main,"TOPRIGHT",WFEZ_D.sizes.MARGES*3.25,-(WFEZ_D.sizes.PANNELINFOS_H*.9),WFEZ_D.sizes.PANNELINFOS_H*1.1,WFEZ_D.sizes.PANNELINFOS_H*1.1)
WFEZ_F.clsbtn:DisableDrawLayer("BACKGROUND")
WFEZ_F.clsbtn:SetHighlightTexture('')
WFEZ_F.clsbtn:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
WFEZ_F.clsbtn:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
WFEZ_F.clsbtn:SetScript("OnClick", function() WFEZ_F.main:Hide() end)
WFEZ_F.clsbtn.tooltipText = "CLOSE";

-- -----------------------------------------------------------------------------
-- ✔︎ SEARCH
-- -----------------------------------------------------------------------------

WFEZ_F.search = WFEZ_O:FRAM("WFEZsearch","EditBox",WFEZ_F.main,nil,"BOTTOMRIGHT",WFEZ_F.main, "BOTTOMRIGHT" ,-(WFEZ_D.sizes.MARGES),WFEZ_D.sizes.MARGES)
WFEZ_F.search:SetPoint("TOPLEFT",WFEZ_F.bottom, "TOPRIGHT" ,WFEZ_D.sizes.MMARGS,0)
WFEZ_F.search:SetFontObject(GameFontNormalSmall)
WFEZ_F.search:SetJustifyH("CENTER")
WFEZ_F.search:SetAutoFocus(false)
WFEZ_F.search:SetTextColor(1,.7,0,1)

WFEZ_F.search:SetScript("OnLeave", function(self) if not WFEZ_D.search then WFEZ_F.search_t:Show() end end)
WFEZ_F.search:SetScript("OnEnter", function(self) WFEZ_F.search_t:Hide() end)
WFEZ_F.search:SetScript("OnKeyUp", function(self) WFEZ_O:SEARCH(self:GetText()) end)
-- WFEZ_F.search_f = WFEZ_O:FADE("WFEZsearchfade",WFEZ_F.search,true,.6)

WFEZ_F.search_t = WFEZ_O:FONT("WFEZsearch_TXT",WFEZ_F.search, "CENTER",WFEZ_F.search,"CENTER")
WFEZ_F.search_t:SetText("Search")
WFEZ_F.search_t:SetTextColor(1,1,1,.4)

-- -----------------------------------------------------------------------------
-- ✔︎ BACKGROUND
-- -----------------------------------------------------------------------------

WFEZ_F.margbg = WFEZ_O:FRAM("WFEZmargbg","Frame",WFEZ_F.main,nil)
WFEZ_F.margbg:SetPoint("TOPLEFT"     ,WFEZ_F.main  , "TOPLEFT" , WFEZ_D.sizes.MARGES,-(WFEZ_D.sizes.MARGES))
WFEZ_F.margbg:SetPoint("BOTTOMRIGHT" ,WFEZ_F.search, "TOPRIGHT",0,WFEZ_D.sizes.MMARGS)
-- WFEZ_F.margbg_f   = WFEZ_O:FADE("WFEZmargbgfade",WFEZ_F.margbg,true,WF_ez_DBC.transparency)

-- -----------------------------------------------------------------------------
-- ✔︎ SCROLL FRAME
-- -----------------------------------------------------------------------------

WFEZ_F.scrollf = WFEZ_O:FRAM("WFEZscrollf","ScrollFrame",WFEZ_F.main,nil)
WFEZ_F.scrollf:SetPoint("TOPLEFT"    ,WFEZ_F.margbg, "TOPLEFT"		,0,-WFEZ_D.sizes.MARGES)
WFEZ_F.scrollf:SetPoint("BOTTOMRIGHT",WFEZ_F.margbg, "BOTTOMRIGHT"  ,0, WFEZ_D.sizes.MARGES)
WFEZ_F.scrollf:SetClampedToScreen(true)

WFEZ_F.scrollb = WFEZ_O:FRAM("WFEZscrollb","Slider",WFEZ_F.scrollf,"UIPanelScrollBarTemplate",
                        "TOPLEFT"	, WFEZ_F.main, "TOPRIGHT"	,4,-(WFEZ_D.sizes.PANNELINFOS_H*1.5))
WFEZ_F.scrollb:SetPoint("BOTTOMLEFT", WFEZ_F.main, "BOTTOMRIGHT",0,  WFEZ_D.fonts.TXT_14)
WFEZ_F.scrollb:SetMinMaxValues(1, 200)
WFEZ_F.scrollb:SetValueStep(10)
WFEZ_F.scrollb:SetValue(0)
WFEZ_F.scrollb.scrollStep = 10

WFEZ_F.scrollb:SetScript("OnValueChanged",function (self, value) self:GetParent():SetVerticalScroll(value) end)

WFEZ_F.scrollb                  :SetWidth( WFEZ_D.fonts.TXT_14)
WFEZ_F.scrollb.ThumbTexture     :SetWidth( WFEZ_D.fonts.TXT_14)
WFEZ_F.scrollb.ThumbTexture     :SetHeight(WFEZ_D.fonts.TXT_14)
WFEZ_F.scrollb.ScrollDownButton :SetWidth( WFEZ_D.fonts.TXT_14)
WFEZ_F.scrollb.ScrollDownButton :SetHeight(WFEZ_D.fonts.TXT_14)
WFEZ_F.scrollb.ScrollUpButton   :SetWidth( WFEZ_D.fonts.TXT_14)
WFEZ_F.scrollb.ScrollUpButton   :SetHeight(WFEZ_D.fonts.TXT_14)

-- -----------------------------------------------------------------------------
-- ✔︎ CHILD
-- -----------------------------------------------------------------------------

WFEZ_F.child = WFEZ_O:FRAM("WFEZchild","Frame",WFEZ_F.scrollf)
WFEZ_F.child:SetSize(1,1)

WFEZ_F.play_btag_maxwidth = WFEZ_O:FRAM("WFEZfr_play_btag","Frame",WFEZ_F.child,nil,"TOPLEFT",WFEZ_F.child,"TOPLEFT",nil,nil,0,1)
WFEZ_F.play_name_maxwidth = WFEZ_O:FRAM("WFEZfr_play_name","Frame",WFEZ_F.child,nil,"TOPLEFT",WFEZ_F.play_btag_maxwidth,"TOPRIGHT",nil,nil,80,100)
-- WFEZ_F.play_btag_maxwidth_f = WFEZ_O:FADE("WFEZfr_play_namef",WFEZ_F.play_name_maxwidth,true,1)

WFEZ_F.scrollf:SetScrollChild(WFEZ_F.child)
WFEZ_F.scrollf:SetScript("OnMouseWheel", function (self, value) value = value*-1 val = WFEZ_F.scrollb:GetValue()+value*10 WFEZ_F.scrollb:SetValue(val) end)
WFEZ_F.scrollb:SetScript("OnMouseWheel", function (self, value) value = value*-1 val = WFEZ_F.scrollb:GetValue()+value*10 WFEZ_F.scrollb:SetValue(val) end)

WFEZ_F.scrollf_f = WFEZ_O:FADE("WFEZscrollff",WFEZ_F.scrollf,true,.9)
WFEZ_F.scrollf_f:SetPoint("TOPLEFT"    ,WFEZ_F.scrollf, "TOPLEFT"   ,-WFEZ_D.sizes.MARGES, WFEZ_D.sizes.MARGES*1.5)
WFEZ_F.scrollf_f:SetPoint("BOTTOMRIGHT",WFEZ_F.scrollf, "BOTTOMRIGHT",WFEZ_D.sizes.MARGES,-WFEZ_D.sizes.MARGES)
WFEZ_F.scrollf_f:Hide();

-- -----------------------------------------------------------------------------