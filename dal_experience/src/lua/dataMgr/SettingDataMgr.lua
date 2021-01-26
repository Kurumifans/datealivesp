local BaseDataMgr = import(".BaseDataMgr")
local SettingDataMgr = class("SettingDataMgr", BaseDataMgr)

local UserDefalt = CCUserDefault:sharedUserDefault()

local TEXT_SPEED_VAL = {
    0.1,
    0.07,
    0.03,
    0.01,
}

local SKIP_SPEED_VAL = {
    0.013,
    0.011,
    0.009,
    0.007,
}

local AUTO_SPEED_VAL = {
    0.2,
    0.1,
    0.05,
    0.01,
}

local SOUND_VAL = {
    0,
    0.3,
    0.6,
    1
}

local BLUR_VAL = {
    0,
    0.3,
    0.6,
    1
}
local FPS_VAL = {
    30,
    60
}

local CGSKIP_VAL = {
    0,
    1
}
local ROKE_VAL = {
    false,
    true,
}
local ATTACK_EFFECT_VAL = {
    true,
    false,
}
-- 0 5 10 20
local NumberOfScreens_VAL = {
    0,
    10,
    20,
    50
}
SettingDataMgr.NumberOfScreens_VAL = NumberOfScreens_VAL
function SettingDataMgr:init()
    self:settingDataWork()
end

function SettingDataMgr:settingDataWork()
    GameConfig.ANIM_FPS = self:getBattleFPSVal()   --动作帧率
    GameConfig.FPS = self:getBattleFPSVal() --游戏帧率
    TFDirector:setFPS(self:getBattleFPSVal())
end

function SettingDataMgr:setSpeedText(speed)
	local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("SpeedText"..id, speed)
end

function SettingDataMgr:getSpeedText()
	local id = MainPlayer:getPlayerId() or ""
    local speed = UserDefalt:getStringForKey("SpeedText"..id)
    if speed == "" then
        return 3
    else
        return tonumber(speed)
    end
end

function SettingDataMgr:getSpeedTextVal()
    return TEXT_SPEED_VAL[self:getSpeedText()]
end

function SettingDataMgr:setSpeedAuto(speed)
	local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("SpeedAuto"..id, speed)
end

function SettingDataMgr:getSpeedAuto()
	local id = MainPlayer:getPlayerId() or ""
    local speed = UserDefalt:getStringForKey("SpeedAuto"..id)
    if speed == "" then
        return 3
    else
        return tonumber(speed)
    end
end

function SettingDataMgr:getSpeedAutoVal()
    return AUTO_SPEED_VAL[self:getSpeedAuto()]
end

function SettingDataMgr:setSpeedSkip(speed)
	local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("SpeedSkip"..id, speed)
end

function SettingDataMgr:getSpeedSkip()
	local id = MainPlayer:getPlayerId() or ""
    local speed = UserDefalt:getStringForKey("SpeedSkip"..id)
    if speed == "" then
        return 4
    else
        return tonumber(speed)
    end
end

function SettingDataMgr:getSpeedSkipVal()
    return SKIP_SPEED_VAL[self:getSpeedSkip()]
end

function SettingDataMgr:setCgSkip(value)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("cgSkip"..id, value)
end

function SettingDataMgr:getCgSkip()
    local id = MainPlayer:getPlayerId() or ""
    local value = UserDefalt:getStringForKey("cgSkip"..id)
    return tonumber(value) or 1
end

function SettingDataMgr:getCgSkipVal()
    return CGSKIP_VAL[self:getCgSkip()]
end

function SettingDataMgr:setSoundMain(sound)
	local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("SoundMain"..id, sound)
    self:updateBgmVolume()
end

function SettingDataMgr:updateBgmVolume()
    local baseVol = self:getSoundMainVal()
    local bgmVol = self:getSoundBgmVal()
    TFAudio.setMusicVolume(baseVol * bgmVol)
    SafeAudioExchangePlay().updateBgmVolume()
end

function SettingDataMgr:updateSoundVolume()
    local baseVol = self:getSoundMainVal()
    local effectVol = self:getSoundEffectVal()
    --TFAudio.setEffectsVolume(baseVol * effectVol)
end

function SettingDataMgr:updateVoiceVolume()
    local baseVol = self:getSoundMainVal()
    local voiceVol = self:getSoundVoiceVal()
    --TFAudio.setEffectsVolume(baseVol * voiceVol)
end

function SettingDataMgr:getSoundMain()
	local id = MainPlayer:getPlayerId() or ""
    local sound = UserDefalt:getStringForKey("SoundMain"..id)
    if sound == "" then
        return 4
    else
        return tonumber(sound)
    end
end

function SettingDataMgr:getSoundMainVal()
    return SOUND_VAL[self:getSoundMain()]
end

function SettingDataMgr:setSoundBgm(sound)
	local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("SoundBgm"..id, sound)
    self:updateBgmVolume()
end

function SettingDataMgr:getSoundBgm()
	local id = MainPlayer:getPlayerId() or ""
    local sound = UserDefalt:getStringForKey("SoundBgm"..id)
    if sound == "" then
        return 3
    else
        return tonumber(sound)
    end
end

function SettingDataMgr:bgmFade(to, step, duration, useCurFade)
	step = step or 10

	duration = duration or 50

	if not useCurFade then
		self.fadeVolume = self:getSoundBgmVal() * 100
	else
		self.fadeVolume = self.fadeVolume or 0
	end

	local counts = math.abs( math.floor((to- self.fadeVolume) / step))

	local perStep = to > self.fadeVolume and 1 or -1

	local function setVol_(vol)
		AudioEngine:setVolume(AudioExchangePlay.oldId, vol)
	end

	local timer;

	local function removeTimer_()
		if timer~= nil then
			TFDirector:stopTimer(timer)
			TFDirector:removeTimer(timer)
			timer = nil
		end
	end
	
	if timer == nil then
		timer = TFDirector:addTimer(duration,counts,function()
				setVol_(to / 100)
				removeTimer_()
			end, 
			function ( ... )
				local baseVol = self:getSoundMainVal()
				self.fadeVolume = self.fadeVolume + step * perStep
				setVol_(self.fadeVolume / 100 * baseVol)
			end)
	end
end


function SettingDataMgr:getSoundBgmVal()
    return SOUND_VAL[self:getSoundBgm()]
end

function SettingDataMgr:setSoundEffect(sound)
	local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("SoundEffect"..id, sound)
end

function SettingDataMgr:getSoundEffect()
	local id = MainPlayer:getPlayerId() or ""
    local sound = UserDefalt:getStringForKey("SoundEffect"..id)
    if sound == "" then
        return 4
    else
        return tonumber(sound)
    end
end

function SettingDataMgr:getSoundEffectVal()
    return SOUND_VAL[self:getSoundEffect()]
end

function SettingDataMgr:setSoundVoice(sound)
	local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("SoundVoice"..id, sound)
end

function SettingDataMgr:getSoundVoice()
	local id = MainPlayer:getPlayerId() or ""
    local sound = UserDefalt:getStringForKey("SoundVoice"..id)
    if sound == "" then
        return 4
    else
        return tonumber(sound)
    end
end

function SettingDataMgr:getSoundVoiceVal()
    return SOUND_VAL[self:getSoundVoice()]
end

function SettingDataMgr:setBattleBlur(blur)
	local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("BattleBlur"..id, blur)
end

function SettingDataMgr:getBattleBlur()
	local id = MainPlayer:getPlayerId() or ""
    local blur = UserDefalt:getStringForKey("BattleBlur"..id)
    if blur == "" then
        return 1
    else
        return tonumber(blur)
    end
end

function SettingDataMgr:getBattleBlurVal()
    return BLUR_VAL[self:getBattleBlur()]
end

--是否显示队友特效
function SettingDataMgr:setAttactEffect(value)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("AttactEffect"..id, value)
    EventMgr:dispatchEvent(EV_UPDATE_TEAM_HANDLE)

end

function SettingDataMgr:getAttactEffect()
    local id = MainPlayer:getPlayerId() or ""
    local value = UserDefalt:getStringForKey("AttactEffect"..id)
    if value == "" then
        return 1
    else
        return tonumber(value)
    end
end

--是否显示觉醒特效
function SettingDataMgr:setAwakeEffect(value)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("AwakeEffect"..id, value)
end

function SettingDataMgr:getAwakeEffect()
    local id = MainPlayer:getPlayerId() or ""
    local value = UserDefalt:getStringForKey("AwakeEffect"..id)
    if value == "" then
        return 1
    else
        return tonumber(value)
    end
end

function SettingDataMgr:getAttactEffectVal()
    return ATTACK_EFFECT_VAL[self:getAttactEffect()]
end

function SettingDataMgr:setBattleFPS(fps)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("BattleFPS"..id, fps)
    local battleController = require("lua.logic.battle.BattleController") 
    if battleController.isLockStep() then --组队模式下静止设置帧率
        return
    end
    GameConfig.ANIM_FPS = self:getBattleFPSVal()   --动作帧率
    GameConfig.FPS = self:getBattleFPSVal() --游戏帧率
    TFDirector:setFPS(self:getBattleFPSVal())
end

function SettingDataMgr:getBattleFPS()
    local id = MainPlayer:getPlayerId() or ""
    local fps = UserDefalt:getStringForKey("BattleFPS"..id)
    if fps == "" then
        return 2
    else
        return tonumber(fps)
    end
end

function SettingDataMgr:getBattleFPSVal()
    return FPS_VAL[self:getBattleFPS()]
end

--自定义FPS(组队战斗中需要保证玩家一致时调用)
function SettingDataMgr:setFPS(fps)
    GameConfig.FPS      = fps
    GameConfig.ANIM_FPS = fps
    TFDirector:setFPS(fps)
end

--还原原始FPS
function SettingDataMgr:resetFPS()
    GameConfig.FPS      = self:getBattleFPSVal()
    GameConfig.ANIM_FPS = GameConfig.FPS
    TFDirector:setFPS(GameConfig.FPS)
end

--摇杆固定位置
function SettingDataMgr:setBattleRoke(roke)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("BattleRoke"..id, roke)
end

function SettingDataMgr:getBattleRoke()
    local id = MainPlayer:getPlayerId() or ""
    local roke = UserDefalt:getStringForKey("BattleRoke"..id)
    if roke == "" then
        return 1
    else
        return tonumber(roke)
    end
end

function SettingDataMgr:setBattleRedPack(redPack)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("BattleRedPack"..id, redPack)
end

function SettingDataMgr:getBattleRedPack()
    local id = MainPlayer:getPlayerId() or ""
    local redPack = UserDefalt:getStringForKey("BattleRedPack"..id)
    if redPack == "" then
        return 1
    else
        return tonumber(redPack)
    end
end

function SettingDataMgr:setMainRedPack(redPack)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("mainRedPack"..id, redPack)
end

function SettingDataMgr:getMainRedPack()
    local id = MainPlayer:getPlayerId() or ""
    local redPack = UserDefalt:getStringForKey("mainRedPack"..id)
    if redPack == "" then
        return 1
    else
        return tonumber(redPack)
    end
end

function SettingDataMgr:setDatingRedPack(redPack)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("DatingRedPack"..id, redPack)
end

function SettingDataMgr:getDatingRedPack()
    local id = MainPlayer:getPlayerId() or ""
    local redPack = UserDefalt:getStringForKey("DatingRedPack"..id)
    if redPack == "" then
        return 1
    else
        return tonumber(redPack)
    end
end

function SettingDataMgr:getBattleRokeVal()
    return ROKE_VAL[self:getBattleRoke()]
end
--同屏人数
function SettingDataMgr:getNumberOfScreens()
    local id  = MainPlayer:getPlayerId() or ""
    local numIndex = UserDefalt:getStringForKey("NumberOfScreens"..id)
    if numIndex == "" then
        return 3
    else
        return tonumber(numIndex)
    end
end
--同屏人数
function SettingDataMgr:setNumberOfScreens(index)
    local id = MainPlayer:getPlayerId() or ""
    UserDefalt:setStringForKey("NumberOfScreens"..id, index)
end

function SettingDataMgr:getNumberOfScreensVal()
    return NumberOfScreens_VAL[self:getNumberOfScreens()]
end

--获取终焉难度筛选设置
function SettingDataMgr:getBlackAndWhiteDifficultyChoice()
	local difficultys = {}
	for i = 1, 5 do
		local value = UserDefalt:getStringForKey("BlackAndWhiteDifficulty"..i)
        difficultys[i] = value == "" and "1" or value
	end
	return difficultys
end

--设置终焉难度筛选设置
function SettingDataMgr:setBlackAndWhiteDifficultyChoice(difficultys)
    for i=1,5 do
        local value = difficultys[i] or 0
        UserDefalt:setStringForKey("BlackAndWhiteDifficulty"..i,tostring(value))
    end
end



function SettingDataMgr:getDifficultyChoice()
    local difficultys = {}
    for i=1,6 do
        local value = UserDefalt:getStringForKey("Difficulty"..i)
        difficultys[i] = value == "" and "1" or value
    end
    return difficultys
end

function SettingDataMgr:setDifficultyChoice(difficultys)
    for i=1,6 do
        local value = difficultys[i] or 0
        UserDefalt:setStringForKey("Difficulty"..i,tostring(value))
    end
end

function SettingDataMgr:encodeAllConfig()
    local config = {}
    config.SpeedText = self:getSpeedText()
    config.SpeedAuto = self:getSpeedAuto()
    config.SpeedSkip = self:getSpeedSkip()
    config.CgSkip = self:getCgSkip()
    config.SoundMain = self:getSoundMain()
    config.SoundBgm = self:getSoundBgm()
    config.SoundEffect = self:getSoundEffect()
    config.SoundVoice = self:getSoundVoice()
    config.BattleBlur = self:getBattleBlur()
    config.BattleFPS = self:getBattleFPS()
    config.BattleRoke = self:getBattleRoke()
    print(json.encode(config))
end

function SettingDataMgr:getWorldShowName(  )
    -- body
    local value = UserDefalt:getStringForKey("WorldShowOtherName")
    return value ~= "FALSE"
end

function SettingDataMgr:setWorldShowName( value )
    -- body
    UserDefalt:setStringForKey("WorldShowOtherName",value)
    EventMgr:dispatchEvent(EV_WORLD_ROOM_SETTING_CHANGE)
end

function SettingDataMgr:getWorldShowEffect(  )
    -- body
    local value = UserDefalt:getStringForKey("WorldShowOtherEffect")
    return value ~= "FALSE"
end

function SettingDataMgr:setWorldShowEffect( value )
    UserDefalt:setStringForKey("WorldShowOtherEffect",value)
    EventMgr:dispatchEvent(EV_WORLD_ROOM_SETTING_CHANGE)
end


return SettingDataMgr:new()
