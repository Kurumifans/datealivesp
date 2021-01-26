
local SettingsView = class("SettingsView", BaseLayer)

local teamPrivacy = {icon = "ui/setting/uires/41.png",name = 15010200}--阵容隐私

function SettingsView:initData(roleCid)
    self.tmsettingData = {dating = {},sound = {},battle = {},push = {},funben = {},other = {}}
    self.tmsettingData.dating.common = SettingDataMgr:getSpeedText()
    self.tmsettingData.dating.speedup = SettingDataMgr:getSpeedSkip()
    self.tmsettingData.dating.auto = SettingDataMgr:getSpeedAuto()
    self.tmsettingData.dating.cgSkip = SettingDataMgr:getCgSkip()
    self.tmsettingData.sound.main = SettingDataMgr:getSoundMain()
    self.tmsettingData.sound.bgm = SettingDataMgr:getSoundBgm()
    self.tmsettingData.sound.effect = SettingDataMgr:getSoundEffect()
    self.tmsettingData.sound.speak = SettingDataMgr:getSoundVoice()
    -- self.tmsettingData.battle.attack = SettingDataMgr:getAttactEffect()
    self.tmsettingData.battle.fps = SettingDataMgr:getBattleFPS()
    self.tmsettingData.battle.roke =  SettingDataMgr:getBattleRoke()
    self.tmsettingData.battle.numberOfScreens = SettingDataMgr:getNumberOfScreens()
    self.tmsettingData.battle.awake = SettingDataMgr:getAwakeEffect()

    self.tmsettingData.other.mainRedPack = SettingDataMgr:getMainRedPack()
    self.tmsettingData.other.battleRedPack =  SettingDataMgr:getBattleRedPack()
    self.tmsettingData.other.datingRedPack = SettingDataMgr:getDatingRedPack()
    self.tmcollectSetting = CollectDataMgr:getShowSetting()

	self.collectList = {}
end

function SettingsView:ctor(...)
    self.super.ctor(self)
    self:initData(...)
    self:showPopAnim(true)
    self:init("lua.uiconfig.settings.settingsView")

    self.root_panel = TFDirector:getChildByPath(self, "Panel_root")
    self.pad_panel = TFDirector:getChildByPath(self.root_panel, "Panel_setting_pad")

    self:initPanelbtns()
    self:initPanelSettings()
    self:initPanelDating()
    self:initPanelSound()
    self:initPanelCollect()
    self:initPanelBattle()
    self:initPanelOther()
    -- self:initPanelFunben()
    self:showPanelDating()
	
	self:initPanelMainPage()
end

function SettingsView:initPanelbtns()
    
    self.close_btn = TFDirector:getChildByPath(self.pad_panel, "Button_close")
    local Panel_btns = TFDirector:getChildByPath(self.pad_panel, "Panel_btns")
    local Button_dating = TFDirector:getChildByPath(Panel_btns, "Button_dating")
    local Button_sound = TFDirector:getChildByPath(Panel_btns, "Button_sound")
    local Button_collect = TFDirector:getChildByPath(Panel_btns, "Button_collect")
    local Button_battle = TFDirector:getChildByPath(Panel_btns, "Button_battle")
	local Button_MainPage = TFDirector:getChildByPath(Panel_btns, "Button_MainPage")
    local Button_other = TFDirector:getChildByPath(Panel_btns, "Button_other")
    -- local Button_fuben = TFDirector:getChildByPath(Panel_btns, "Button_fuben")
    local Button_cancel = TFDirector:getChildByPath(self.pad_panel, "TextButton_cancel")
    local Button_save = TFDirector:getChildByPath(self.pad_panel, "TextButton_save")
    self.btn_list = {dating = Button_dating,sound = Button_sound,battle = Button_battle,collect = Button_collect, mainPage = Button_MainPage, other = Button_other}
    local function saveCurSettingData()
        SettingDataMgr:setSpeedText(self.tmsettingData.dating.common)
        SettingDataMgr:setSpeedSkip(self.tmsettingData.dating.speedup)
        SettingDataMgr:setSpeedAuto(self.tmsettingData.dating.auto)
        SettingDataMgr:setCgSkip(self.tmsettingData.dating.cgSkip)
        SettingDataMgr:setSoundMain(self.tmsettingData.sound.main)
        SettingDataMgr:setSoundBgm(self.tmsettingData.sound.bgm)
        SettingDataMgr:setSoundEffect(self.tmsettingData.sound.effect)
        SettingDataMgr:setSoundVoice(self.tmsettingData.sound.speak)
        -- SettingDataMgr:setAttactEffect(self.tmsettingData.battle.attack)
        SettingDataMgr:setBattleFPS(self.tmsettingData.battle.fps)
        SettingDataMgr:setBattleRoke(self.tmsettingData.battle.roke)
        SettingDataMgr:setAwakeEffect(self.tmsettingData.battle.awake)
        SettingDataMgr:setDatingRedPack(self.tmsettingData.other.datingRedPack)
        SettingDataMgr:setBattleRedPack(self.tmsettingData.other.battleRedPack)
        SettingDataMgr:setMainRedPack(self.tmsettingData.other.mainRedPack)
        SettingDataMgr:setNumberOfScreens(self.tmsettingData.battle.numberOfScreens)

		--判断是否更改了主界面
		if not MainUISettingMgr:CheckSelect(self.selectId) then
			if  MainUISettingMgr:CheckLock(self.selectId) then
				Utils:showTips("选择的主页未解锁")
			else
				print("MainUISettingMgr ReqChangeUiChange==========================" .. self.selectId)
				MainUISettingMgr:ReqChangeUiChange(self.selectId)
			end
		end
		
        --设置变更通知UI刷新
        EventMgr:dispatchEvent(EV_SETTING_CHANGE)
        CollectDataMgr:reqChangeShowSetting(self.tmcollectSetting)
		
		AlertManager:closeLayer(self)
        
    end
    self.close_btn:onClick(function()
        AlertManager:closeLayer(self)
    end)
    self.root_panel:onClick(function()
        AlertManager:closeLayer(self)
    end)
    Button_cancel:onClick(function()
        AlertManager:closeLayer(self)
    end)
    Button_save:onClick(function()   
		saveCurSettingData()
    end)
    Button_dating:onClick(function()
        self:showPanelDating()
        self:changeBtnSelStatus("dating")
    end)

    Button_sound:onClick(function()
        self:showPanelSound()
        self:changeBtnSelStatus("sound")
    end)

    Button_collect:onClick(function()
        self:showPanelCollect()
        self:changeBtnSelStatus("collect")
    end)

    Button_battle:onClick(function()
        self:showPanelBattle()
        self:changeBtnSelStatus("battle")
    end)
	
	Button_MainPage:onClick(function()
         self:showPanelMain()
         self:changeBtnSelStatus("mainPage")
     end)

    Button_other:onClick(function()
         self:showPanelOther()
         self:changeBtnSelStatus("other")
     end)


    -- Button_fuben:onClick(function()
    --     self:showPanelFuben()
    --     self:changeBtnSelStatus("funben")
    -- end)


    self:changeBtnSelStatus("dating")

end
function SettingsView:changeBtnSelStatus(selname)
    for k,v in pairs(self.btn_list) do
        if k == selname then
            v:setTextureNormal("ui/setting/uires/002.png")
        else
            v:setTextureNormal("")
        end
    end
end

function SettingsView:initPanelSettings()
    local Panel_settings = TFDirector:getChildByPath(self.pad_panel, "Panel_settings")
    local Panel_dating = TFDirector:getChildByPath(Panel_settings, "Panel_dating")
    local Panel_sound = TFDirector:getChildByPath(Panel_settings, "Panel_sound")
    local Panel_collect = TFDirector:getChildByPath(Panel_settings, "Panel_collect")
    local Panel_battle = TFDirector:getChildByPath(Panel_settings, "Panel_battle")
    local Panel_other = TFDirector:getChildByPath(Panel_settings, "Panel_other")
	local Panel_mainPage = TFDirector:getChildByPath(Panel_settings, "Panel_mainPage")
    -- local Panel_fuben = TFDirector:getChildByPath(Panel_settings, "Panel_fuben")

    self.panels = {Panel_dating, Panel_sound, Panel_collect, Panel_battle,Panel_other, Panel_mainPage}

    self.Panel_dating = Panel_dating
    self.Panel_sound = Panel_sound
    self.Panel_collect = Panel_collect
    self.Panel_battle = Panel_battle
    self.Panel_other = Panel_other
	self.Panel_mainPage = Panel_mainPage
    -- self.Panel_fuben = Panel_fuben
    self.Panel_collect:setSwallowTouch(true)
    self.Panel_dating:setSwallowTouch(true)
    self.Panel_sound:setSwallowTouch(true)
    self.Panel_battle:setSwallowTouch(true)
	self.Panel_mainPage:setSwallowTouch(true)
    self.Panel_other:setSwallowTouch(true)
    -- self.Panel_fuben:setSwallowTouch(true)
end

function SettingsView:setSpeedText(speed)
    -- SettingDataMgr:setSpeedText(speed)
    self.tmsettingData.dating.common = speed
    self:updateSpeedText()
end

function SettingsView:setSpeedSkip(speed)
    -- SettingDataMgr:setSpeedSkip(speed)
    self.tmsettingData.dating.speedup = speed
    self:updateSpeedSkip()
end

function SettingsView:setSpeedAuto(speed)
    -- SettingDataMgr:setSpeedAuto(speed)
    self.tmsettingData.dating.auto = speed
    self:updateSpeedAuto()
end

function SettingsView:setCgSkip(value)
    -- SettingDataMgr:getCgSkip(value)
    value = self.tmsettingData.dating.cgSkip + 1
    if value > 2 then
        value = 1
    end
    self.tmsettingData.dating.cgSkip = value
    self:updateCgSkip()
end

function SettingsView:updateCommon(Image_speed, speed)
    for i = 1, 4 do 
        local btn = TFDirector:getChildByPath(Image_speed, "Button_common_"..i)
        local speedSign = TFDirector:getChildByPath(Image_speed, "Image_sel_sign")
        -- if speed == i then
        --     btn:setTextureNormal("ui/032.png")
        -- else
        --     btn:setTextureNormal("ui/031.png")
        -- end
        if speed == i then
            speedSign:setPosition(btn:getPosition())
        end
    end
end

function SettingsView:updateSpeedText()
    local Image_speed_text = TFDirector:getChildByPath(self.Panel_dating, "Panel_common")
    local speed = self.tmsettingData.dating.common

    self:updateCommon(Image_speed_text, speed)
end

function SettingsView:updateSpeedSkip()
    local Image_speed_skip = TFDirector:getChildByPath(self.Panel_dating, "Panel_speedup")
    local speed = self.tmsettingData.dating.speedup

    self:updateCommon(Image_speed_skip, speed)
end

function SettingsView:updateSpeedAuto()
    local Image_speed_auto = TFDirector:getChildByPath(self.Panel_dating, "Panel_auto")
    local speed = self.tmsettingData.dating.auto

    self:updateCommon(Image_speed_auto, speed)
end

function SettingsView:updateCgSkip()
    local Panel_cg = TFDirector:getChildByPath(self.Panel_dating, "Panel_cg")
    local value = self.tmsettingData.dating.cgSkip

    for i=1,1 do
        local btn = TFDirector:getChildByPath(Panel_cg, "Button_common_"..i)
        local movepos = me.p(-33,0)
        if value ~= 1 then
            movepos = me.p(33,0)
        end
        btn:getChildByName("Image_btn_sign"):stopAllActions()
        btn:getChildByName("Image_btn_sign"):runAction(MoveTo:create(0.1,movepos))
    end
end

function SettingsView:setDatingRedPack(redPack)
    local value = self.tmsettingData.other.datingRedPack + 1
    if value > 2 then
        value = 1
    end
    self.tmsettingData.other.datingRedPack = value
    self:updateDatingRedPack()
end

function SettingsView:updateDatingRedPack()
    local Panel_dating = TFDirector:getChildByPath(self.Panel_other, "Panel_dating")
    local value = self.tmsettingData.other.datingRedPack

    for i=1,1 do
        local btn = TFDirector:getChildByPath(Panel_dating, "Button_common_"..i)
        local movepos = me.p(-33,0)
        if value == 1 then
            movepos = me.p(33,0)
        end
        btn:getChildByName("Image_btn_sign"):stopAllActions()
        btn:getChildByName("Image_btn_sign"):runAction(MoveTo:create(0.1,movepos))
    end
end

function SettingsView:setSoundMain(sound)
    -- SettingDataMgr:setSoundMain(sound)
    self.tmsettingData.sound.main = sound
    self:updateSoundMain()
end

function SettingsView:setSoundBgm(sound)
    -- SettingDataMgr:setSoundBgm(sound)
    self.tmsettingData.sound.bgm = sound
    self:updateSoundBgm()
end

function SettingsView:setSoundEffect(sound)
    -- SettingDataMgr:setSoundEffect(sound)
    self.tmsettingData.sound.effect = sound
    self:updateSoundEffect()
end

function SettingsView:setSoundVoice(sound)
    -- SettingDataMgr:setSoundVoice(sound)
    self.tmsettingData.sound.speak = sound
    self:updateSoundVoice()
end

function SettingsView:updateSoundMain()
    local Image_sound_main = TFDirector:getChildByPath(self.Panel_sound, "Panel_vol_main")
    local sound = self.tmsettingData.sound.main

    self:updateCommon(Image_sound_main, sound)
end

function SettingsView:updateSoundBgm()
    local Image_sound_bgm = TFDirector:getChildByPath(self.Panel_sound, "Panel_vol_bg")
    local sound = self.tmsettingData.sound.bgm

    self:updateCommon(Image_sound_bgm, sound)
end

function SettingsView:updateSoundEffect()
    local Image_sound_effect = TFDirector:getChildByPath(self.Panel_sound, "Panel_vol_effect")
    local sound = self.tmsettingData.sound.effect

    self:updateCommon(Image_sound_effect, sound)
end

function SettingsView:updateSoundVoice()
    local Image_sound_voice = TFDirector:getChildByPath(self.Panel_sound, "Panel_vol_speak")
    local sound = self.tmsettingData.sound.speak

    self:updateCommon(Image_sound_voice, sound)
end

-- function SettingsView:setAttactEffect(value)
--     self.tmsettingData.battle.attack = value
--     self:updateAttactEffect()
-- end

-- function SettingsView:updateAttactEffect()
--     local Image_battle_blur = TFDirector:getChildByPath(self.Panel_battle, "Panel_attack")
--     local attack = self.tmsettingData.battle.attack
--     for i=1,2 do
--         local btn = TFDirector:getChildByPath(Image_battle_blur, "Button_common_"..i)
--         local btn_bg = TFDirector:getChildByPath(Image_battle_blur, "Image_btn_bg_"..i)
--         if attack == i then
--             btn:setTextureNormal("ui/setting/uires/011.png") 
--             btn_bg:setTexture("ui/setting/uires/009.png")
--         else
--             btn:setTextureNormal("")
--             btn_bg:setTexture("ui/setting/uires/010.png")
--         end
--     end
-- end

function SettingsView:setAwakeEffect(value)
    self.tmsettingData.battle.awake = value
    self:updateAwakeEffect()
end

function SettingsView:updateAwakeEffect()
    local Panel_awake_effect = TFDirector:getChildByPath(self.Panel_battle, "Panel_awake_effect")
    local attack = self.tmsettingData.battle.awake
    for i=1,2 do
        local btn = TFDirector:getChildByPath(Panel_awake_effect, "Button_common_"..i)
        local btn_bg = TFDirector:getChildByPath(Panel_awake_effect, "Image_btn_bg_"..i)
        if attack == i then
            btn:setTextureNormal("ui/setting/uires/011.png") 
            btn_bg:setTexture("ui/setting/uires/009.png")
        else
            btn:setTextureNormal("")
            btn_bg:setTexture("ui/setting/uires/010.png")
        end
    end
end

function SettingsView:setBattleFPS(fps)
    self.tmsettingData.battle.fps = fps
    self:updateBattleFPS()
end

function SettingsView:updateBattleFPS()
    local Image_battle_fps = TFDirector:getChildByPath(self.Panel_battle, "Panel_fps")
    local fps = self.tmsettingData.battle.fps
    for i=1,2 do
        local btn = TFDirector:getChildByPath(Image_battle_fps, "Button_common_"..i)
        local btn_bg = TFDirector:getChildByPath(Image_battle_fps, "Image_btn_bg_"..i)
        if fps == i then
            btn:setTextureNormal("ui/setting/uires/011.png") 
            btn_bg:setTexture("ui/setting/uires/009.png")
        else
            btn:setTextureNormal("")
            btn_bg:setTexture("ui/setting/uires/010.png")
        end
    end
end

function SettingsView:setBattleRoke(roke)
    self.tmsettingData.battle.roke = roke
    self:updateBattleRoke()
end

function SettingsView:updateBattleRoke()
    local Image_battle_roke = TFDirector:getChildByPath(self.Panel_battle, "Panel_roke")
    local roke = self.tmsettingData.battle.roke
    for i=1,2 do
        local btn = TFDirector:getChildByPath(Image_battle_roke, "Button_common_"..i)
        local btn_bg = TFDirector:getChildByPath(Image_battle_roke, "Image_btn_bg_"..i)
        if roke == i then
            btn:setTextureNormal("ui/setting/uires/011.png") 
            btn_bg:setTexture("ui/setting/uires/009.png")
        else
            btn:setTextureNormal("")
            btn_bg:setTexture("ui/setting/uires/010.png")
        end
    end
end

function SettingsView:setBattleRedPack(redPack)
    local value = self.tmsettingData.other.battleRedPack + 1
    if value > 2 then
        value = 1
    end
    self.tmsettingData.other.battleRedPack = value
    self:updateBattleRedPack()
end

function SettingsView:updateBattleRedPack()
    local Panel_fight = TFDirector:getChildByPath(self.Panel_other, "Panel_fight")
    local value = self.tmsettingData.other.battleRedPack

    for i=1,1 do
        local btn = TFDirector:getChildByPath(Panel_fight, "Button_common_"..i)
        local movepos = me.p(-33,0)
        if value == 1 then
            movepos = me.p(33,0)
        end
        btn:getChildByName("Image_btn_sign"):stopAllActions()
        btn:getChildByName("Image_btn_sign"):runAction(MoveTo:create(0.1,movepos))
    end
end

function SettingsView:setMainRedPack(redPack)
    local value = self.tmsettingData.other.mainRedPack + 1
    if value > 2 then
        value = 1
    end
    self.tmsettingData.other.mainRedPack = value
    self:updateMainRedPack()
end

function SettingsView:updateMainRedPack()
    local Panel_mainLayer = TFDirector:getChildByPath(self.Panel_other, "Panel_mainLayer")
    local value = self.tmsettingData.other.mainRedPack

    for i=1,1 do
        local btn = TFDirector:getChildByPath(Panel_mainLayer, "Button_common_"..i)
        local movepos = me.p(-33,0)
        if value == 1 then
            movepos = me.p(33,0)
        end
        btn:getChildByName("Image_btn_sign"):stopAllActions()
        btn:getChildByName("Image_btn_sign"):runAction(MoveTo:create(0.1,movepos))
    end
end

function SettingsView:initPanelSound()
    local Image_sound_main = TFDirector:getChildByPath(self.Panel_sound, "Panel_vol_main")
    local Image_sound_bgm = TFDirector:getChildByPath(self.Panel_sound, "Panel_vol_bg")
    local Image_sound_effect = TFDirector:getChildByPath(self.Panel_sound, "Panel_vol_effect")
    local Image_sound_voice = TFDirector:getChildByPath(self.Panel_sound, "Panel_vol_speak")

    for i = 1, 4 do 
        local btn = TFDirector:getChildByPath(Image_sound_main, "Button_common_"..i)
        btn:onClick(function()
            self:setSoundMain(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Image_sound_main, "Label_title")
        -- local Label_slow = TFDirector:getChildByPath(Image_sound_main, "Label_slow")
        -- local Label_fast = TFDirector:getChildByPath(Image_sound_main, "Label_fast")
        
    end
    TFDirector:getChildByPath(Image_sound_main, "Label_slow"):setSkewX(15)
    TFDirector:getChildByPath(Image_sound_main, "Label_fast"):setSkewX(15)

    for i = 1, 4 do 
        local btn = TFDirector:getChildByPath(Image_sound_bgm, "Button_common_"..i)
        btn:onClick(function()
            self:setSoundBgm(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Image_sound_bgm, "Label_title")
        -- local Label_slow = TFDirector:getChildByPath(Image_sound_bgm, "Label_slow")
        -- local Label_fast = TFDirector:getChildByPath(Image_sound_bgm, "Label_fast")
    end
    TFDirector:getChildByPath(Image_sound_bgm, "Label_slow"):setSkewX(15)
    TFDirector:getChildByPath(Image_sound_bgm, "Label_fast"):setSkewX(15)

    for i = 1, 4 do 
        local btn = TFDirector:getChildByPath(Image_sound_effect, "Button_common_"..i)
        btn:onClick(function()
            self:setSoundEffect(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Image_sound_effect, "Label_title")
        -- local Label_slow = TFDirector:getChildByPath(Image_sound_effect, "Label_slow")
        -- local Label_fast = TFDirector:getChildByPath(Image_sound_effect, "Label_fast")
    end
    TFDirector:getChildByPath(Image_sound_effect, "Label_slow"):setSkewX(15)
    TFDirector:getChildByPath(Image_sound_effect, "Label_fast"):setSkewX(15)

    for i = 1, 4 do 
        local btn = TFDirector:getChildByPath(Image_sound_voice, "Button_common_"..i)
        btn:onClick(function()
            self:setSoundVoice(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Image_sound_voice, "Label_title")
        -- local Label_slow = TFDirector:getChildByPath(Image_sound_voice, "Label_slow")
        -- local Label_fast = TFDirector:getChildByPath(Image_sound_voice, "Label_fast")
    end
    TFDirector:getChildByPath(Image_sound_voice, "Label_slow"):setSkewX(15)
    TFDirector:getChildByPath(Image_sound_voice, "Label_fast"):setSkewX(15)

    self:updateSoundMain()
    self:updateSoundBgm()
    self:updateSoundEffect()
    self:updateSoundVoice()
end

function SettingsView:initPanelDating()
    local Image_speed_text = TFDirector:getChildByPath(self.Panel_dating, "Panel_common")
    local Image_speed_skip = TFDirector:getChildByPath(self, "Panel_speedup")
    local Image_speed_auto = TFDirector:getChildByPath(self, "Panel_auto")
    local Panel_cg = TFDirector:getChildByPath(self, "Panel_cg")

    for i = 1, 4 do 
        local btn = TFDirector:getChildByPath(Image_speed_text, "Button_common_"..i)
        btn:onClick(function()
            self:setSpeedText(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Image_speed_text, "Label_title")
        -- local Label_slow = TFDirector:getChildByPath(Image_speed_text, "Label_slow")
        -- local Label_fast = TFDirector:getChildByPath(Image_speed_text, "Label_fast")
    end
    TFDirector:getChildByPath(Image_speed_text, "Label_slow"):setSkewX(15)
    TFDirector:getChildByPath(Image_speed_text, "Label_fast"):setSkewX(15)

    -- for i = 1, 4 do 
    --     local btn = TFDirector:getChildByPath(Image_speed_skip, "Button_common_"..i)
    --     btn:onClick(function()
    --         self:setSpeedSkip(i)
    --     end)
    --     -- local Label_title = TFDirector:getChildByPath(Image_speed_skip, "Label_title")
    --     -- local Label_slow = TFDirector:getChildByPath(Image_speed_skip, "Label_slow")
    --     -- local Label_fast = TFDirector:getChildByPath(Image_speed_skip, "Label_fast")
    -- end

    -- for i = 1, 4 do 
    --     local btn = TFDirector:getChildByPath(Image_speed_auto, "Button_common_"..i)
    --     btn:onClick(function()
    --         self:setSpeedAuto(i)
    --     -- end)
    --     -- local Label_title = TFDirector:getChildByPath(Image_speed_auto, "Label_title")
    --     -- local Label_slow = TFDirector:getChildByPath(Image_speed_auto, "Label_slow")
    --     -- local Label_fast = TFDirector:getChildByPath(Image_speed_auto, "Label_fast")
    -- end

    for i=1,1 do
        local btn = TFDirector:getChildByPath(Panel_cg, "Button_common_"..i)
        btn:onClick(function()
            self:setCgSkip(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Panel_cg, "Label_title")
        -- local Label_close = TFDirector:getChildByPath(Panel_cg, "Label_close")
        -- local Label_open = TFDirector:getChildByPath(Panel_cg, "Label_open")
    end
    TFDirector:getChildByPath(Panel_cg, "Label_close"):setSkewX(15)
    TFDirector:getChildByPath(Panel_cg, "Label_open"):setSkewX(15)

    self:updateSpeedText()
    -- self:updateSpeedSkip()
    -- self:updateSpeedAuto()
    self:updateCgSkip()
end

function SettingsView:initTeamPrivacy()
	local privacy = MainPlayer:getSwitchByType(EC_SWITCH_TYPE.TEAM_PRIVACY) or 0
	local settingitem = self.collect_listView:pushBackDefaultItem()
    settingitem:setVisible(true)
    settingitem:getChildByName("Image_cell_title_icon"):setTexture(teamPrivacy.icon)
    settingitem:getChildByName("Label_title"):setTextById(teamPrivacy.name)

	local tab = {2,1,0}
	local function updateTeamPrivacy(idx)
		for i=1,3 do
		    local btn = TFDirector:getChildByPath(settingitem, "Button_common_"..i)
			btn.privacyVal = tab[i]
		    local btn_bg = TFDirector:getChildByPath(settingitem, "Image_btn_bg_"..i)
			btn:setTextureNormal("")
		    btn_bg:setTexture("ui/battle/practice/new_002.png")
			if btn.privacyVal == idx then
		        btn:setTextureNormal("ui/setting/uires/011.png") 
		        btn_bg:setTexture("ui/battle/practice/new_001.png")
		    else
		        btn:setTextureNormal("")
		        btn_bg:setTexture("ui/battle/practice/new_002.png")
		    end
			
		end
	end
	for i=1,3 do
		local btn = TFDirector:getChildByPath(settingitem, "Button_common_"..i)
		btn:onClick(function()
		    updateTeamPrivacy(btn.privacyVal)   			
			MainPlayer:sendReqChangeSwitch({{EC_SWITCH_TYPE.TEAM_PRIVACY, btn.privacyVal}})         
		end)
	end
	updateTeamPrivacy(privacy) 
end

function SettingsView:initPanelCollect()
    local scroll_collect = TFDirector:getChildByPath(self.Panel_collect, "ScrollView_collect")
    local collectCell = scroll_collect:getChildByName("Panel_cell")
    collectCell:setVisible(false)
    self.collect_listView = UIListView:create(scroll_collect)
    self.collect_listView:setItemModel(collectCell)
    for k,v in ipairs(self.tmcollectSetting) do
        local itemCfg = EC_CollectSettingCfg[v.key]
        if itemCfg then
            local settingitem = self.collect_listView:pushBackDefaultItem()
            settingitem:setVisible(true)
            settingitem:getChildByName("Image_cell_title_icon"):setTexture(itemCfg.icon)
            settingitem:getChildByName("Label_title"):setTextById(itemCfg.name)
            settingitem.pageidx = v.key
            for i=1,3 do
                settingitem:getChildByName("Button_common_"..i):onClick(function()
                    self.tmcollectSetting[settingitem.pageidx].value = i
                    self:updateCollectPanel()
                end)
            end
			table.insert(self.collectList, settingitem)
        end
    end

	--self:initTeamPrivacy()

    self:updateCollectPanel()
end

function SettingsView:updateCollectPanel()
    local allItems = self.collectList
    for k,v in ipairs(allItems) do
        local pageType = self.tmcollectSetting[v.pageidx].value
        for i=1,3 do
            local btn = TFDirector:getChildByPath(v, "Button_common_"..i)
            local btn_bg = TFDirector:getChildByPath(v, "Image_btn_bg_"..i)
            if pageType == i then
                btn:setTextureNormal("ui/setting/uires/011.png") 
                btn_bg:setTexture("ui/battle/practice/new_001.png")
            else
                btn:setTextureNormal("")
                btn_bg:setTexture("ui/battle/practice/new_002.png")
            end
        end
    end
end

function SettingsView:initPanelBattle()
    local Image_battle_blur = TFDirector:getChildByPath(self.Panel_battle, "Panel_attack")
    Image_battle_blur:hide()
    local panel_battle_fps = TFDirector:getChildByPath(self.Panel_battle, "Panel_fps")
    local panel_battle_roke = TFDirector:getChildByPath(self.Panel_battle, "Panel_roke")
    local Panel_common = TFDirector:getChildByPath(self.Panel_battle, "Panel_common")
    local Panel_redPack = TFDirector:getChildByPath(self.Panel_battle, "Panel_redPack")
    local Panel_awake_effect = TFDirector:getChildByPath(self.Panel_battle, "Panel_awake_effect")

    -- for i = 1, 2 do 
    --     local btn = TFDirector:getChildByPath(Image_battle_blur, "Button_common_"..i)
    --     btn:onClick(function()
    --         self:setAttactEffect(i)
    --     end)
    --     -- local Label_title = TFDirector:getChildByPath(Image_battle_blur, "Label_title")
    --     -- local Label_slow = TFDirector:getChildByPath(Image_battle_blur, "Label_slow")
    --     -- local Label_fast = TFDirector:getChildByPath(Image_battle_blur, "Label_fast")
    -- end
    -- TFDirector:getChildByPath(Image_battle_blur, "Label_slow"):setSkewX(15)
    -- TFDirector:getChildByPath(Image_battle_blur, "Label_fast"):setSkewX(15)
    -- self:updateAttactEffect()
    for i=1,2 do
        local btn = TFDirector:getChildByPath(panel_battle_fps, "Button_common_"..i)
        btn:onClick(function()
            self:setBattleFPS(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(panel_battle_fps, "Label_title")
        -- local Label_hz1 = TFDirector:getChildByPath(panel_battle_fps, "Label_hz1")
        -- local Label_hz2 = TFDirector:getChildByPath(panel_battle_fps, "Label_hz2")
    end
    self:updateBattleFPS()
    -- Panel_roke

    for i=1,2 do
        local btn = TFDirector:getChildByPath(panel_battle_roke, "Button_common_"..i)
        btn:onClick(function()
            self:setBattleRoke(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(panel_battle_roke, "Label_title")
        -- local Label_hz1 = TFDirector:getChildByPath(panel_battle_roke, "Label_hz1")
        -- local Label_hz2 = TFDirector:getChildByPath(panel_battle_roke, "Label_hz2")
    end
    self:updateBattleRoke()

    -- panel 同屏人数

    for i = 1, 4 do 
        local btn = TFDirector:getChildByPath(Panel_common, "Button_common_"..i)
        local label_num = TFDirector:getChildByPath(Panel_common, "Label_num"..i)
        btn:onClick(function()
            self:setNumberOfScreens(i)
        end)
        label_num:setText(SettingDataMgr.NumberOfScreens_VAL[i])
        label_num:setSkewX(15)
    end
    TFDirector:getChildByPath(Panel_common, "Label_slow"):setSkewX(15)
    TFDirector:getChildByPath(Panel_common, "Label_fast"):setSkewX(15)
    self:updateNumberOfScreens()


    for i = 1, 2 do 
        local btn = TFDirector:getChildByPath(Panel_awake_effect, "Button_common_"..i)
        btn:onClick(function()
            self:setAwakeEffect(i)
        end)
    end
    self:updateAwakeEffect()

end


--[[设置主页选项]]
function SettingsView:initPanelMainPage()
	--设置滚动视图
	local ScrollView_mainPage = TFDirector:getChildByPath(self.Panel_mainPage, "ScrollView_settingsView_1")
    self._scrollViewMain = UIListView:create(ScrollView_mainPage)
    self._scrollViewMain:setItemsMargin(10)
	
	self._mainItem = TFDirector:getChildByPath(self.Panel_mainPage, "Panel_MainPageItem")
	
	self.selectName_ = TFDirector:getChildByPath(self.Panel_mainPage, "Label_MainName") 
	self.selectDesc_ = TFDirector:getChildByPath(self.Panel_mainPage, "Label_text") 
	
	self.allItems = {}
	self.selectId = -1
	
	self:updatePanelMainPage()
end

--[[设置其他选项]]
function SettingsView:initPanelOther()
    local Panel_mainLayer = TFDirector:getChildByPath(self.Panel_other, "Panel_mainLayer")
    local Panel_dating = TFDirector:getChildByPath(self.Panel_other, "Panel_dating")
    local Panel_fight = TFDirector:getChildByPath(self.Panel_other, "Panel_fight")

    for i=1,1 do
        local btn = TFDirector:getChildByPath(Panel_mainLayer, "Button_common_"..i)
        btn:onClick(function()
            self:setMainRedPack(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Panel_cg, "Label_title")
        -- local Label_close = TFDirector:getChildByPath(Panel_cg, "Label_close")
        -- local Label_open = TFDirector:getChildByPath(Panel_cg, "Label_open")
    end
    TFDirector:getChildByPath(Panel_mainLayer, "Label_close"):setSkewX(15)
    TFDirector:getChildByPath(Panel_mainLayer, "Label_open"):setSkewX(15)

     for i=1,1 do
        local btn = TFDirector:getChildByPath(Panel_dating, "Button_common_"..i)
        btn:onClick(function()
            self:setDatingRedPack(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Panel_cg, "Label_title")
        -- local Label_close = TFDirector:getChildByPath(Panel_cg, "Label_close")
        -- local Label_open = TFDirector:getChildByPath(Panel_cg, "Label_open")
    end
    TFDirector:getChildByPath(Panel_dating, "Label_close"):setSkewX(15)
    TFDirector:getChildByPath(Panel_dating, "Label_open"):setSkewX(15)

    for i=1,1 do
        local btn = TFDirector:getChildByPath(Panel_fight, "Button_common_"..i)
        btn:onClick(function()
            self:setBattleRedPack(i)
        end)
        -- local Label_title = TFDirector:getChildByPath(Panel_cg, "Label_title")
        -- local Label_close = TFDirector:getChildByPath(Panel_cg, "Label_close")
        -- local Label_open = TFDirector:getChildByPath(Panel_cg, "Label_open")
    end
    TFDirector:getChildByPath(Panel_fight, "Label_close"):setSkewX(15)
    TFDirector:getChildByPath(Panel_fight, "Label_open"):setSkewX(15)

    self:updateMainRedPack()
    self:updateBattleRedPack()
    self:updateDatingRedPack()
end

function SettingsView:selectMainPage(id)
	if self.selectId == id then
		return
	end

	if self.allItems[self.selectId] then
		self.allItems[self.selectId].select:hide()
	end
	
	self.selectId = id
	if  self.allItems[self.selectId] then
		self.allItems[self.selectId].select:show()
		
		self.selectName_ :setTextById(tonumber(self.allItems[self.selectId].data.name))
		self.selectDesc_ :setTextById(tonumber(self.allItems[self.selectId].data.des)) 
	end
	
	

end

function SettingsView:updatePanelMainPage()
	--设置滚动视图
	
	local uichange = TabDataMgr:getData("Uichange")
	local maxCount = 0
	local allData = {}
	
	for k, v in pairs(uichange) do
		maxCount = maxCount + 1
		table.insert(allData, v)
    end
	local maxPage = math.ceil(maxCount / 2)
	self._scrollViewMain:removeAllItems()
	self.allItems = {}
	local selectId = 0
	for i = 1, maxPage do
        local item = self._mainItem:clone()
        self._scrollViewMain:pushBackCustomItem(item)
		
		for index = 1, 2 do
			local nodeItwm = TFDirector:getChildByPath(item, "Panel_MainPageItem" .. index)
			if (i - 1) * 2 + index >  maxCount then
				nodeItwm:hide()
			else
				nodeItwm:show()
				
				--设置所有的数据
				local data = allData[(i - 1) * 2 + index]
				local foo = {}
				
				local name = TFDirector:getChildByPath(nodeItwm, "Label_name")
				name:setTextById(tonumber(data.name))
				
				local icon = TFDirector:getChildByPath(nodeItwm, "Image_icon") 
				icon:setTexture(data.icon)
				
				local lock = TFDirector:getChildByPath(nodeItwm, "Image_lock")
				lock:setVisible(MainUISettingMgr:CheckLock(data.id))
				
				
				local select = TFDirector:getChildByPath(nodeItwm, "Image_select")
				select:setVisible(MainUISettingMgr:CheckSelect(data.id))
				
				if MainUISettingMgr:CheckSelect(data.id) then
					selectId = data.id
				end
				
				foo.select = select
				foo.data = data

				self.allItems[data.id] =foo
				
				nodeItwm:onClick(function()
					--AlertManager:closeLayer(self)
					print("----------------------------------------》")
					self:selectMainPage(data.id)
				end)
				
			end
		end
    end
	
	self:selectMainPage(selectId)
end

function SettingsView:setNumberOfScreens(index)
    self.tmsettingData.battle.numberOfScreens = index
    self:updateNumberOfScreens()
end

function SettingsView:updateNumberOfScreens()
    local numIndex = self.tmsettingData.battle.numberOfScreens
    local Panel_common = TFDirector:getChildByPath(self.Panel_battle, "Panel_common")
    local image_sel_sign = TFDirector:getChildByPath(Panel_common, "Image_sel_sign")
    for i = 1, 4 do 
        local btn = TFDirector:getChildByPath(Panel_common, "Button_common_"..i)
        if numIndex == i then
            image_sel_sign:setPosition(btn:getPosition())
        end
    end

end

function SettingsView:hideAllPanels()
    for _, panel in pairs(self.panels) do
		print("----------------------------------————")
        panel:hide()
    end
end

function SettingsView:showPanelDating()
    self:hideAllPanels()
    self.Panel_dating:show()
end

function SettingsView:showPanelSound()
    self:hideAllPanels()
    self.Panel_sound:show()
end

function SettingsView:showPanelCollect()
    self:hideAllPanels()
    self.Panel_collect:show()
end

function SettingsView:showPanelBattle()
    self:hideAllPanels()
    self.Panel_battle:show()
end


function SettingsView:showPanelMain()
	self:hideAllPanels()
	self.Panel_mainPage:show()
end

function SettingsView:showPanelOther()
    self:hideAllPanels()
    self.Panel_other:show()
end

-- function SettingsView:showPanelFuben()
--     self:hideAllPanels()
--     self.Panel_fuben:show()
-- end

return SettingsView
