if battleController then
    return battleController
end
GuideMgr = require("lua.logic.guide.GuideMgr")
require("lua.logic.battle.RandomGenerator")
local BattleConfig   = import(".BattleConfig")
local BattleUtils    = import(".BattleUtils")
local ResLoader      = import(".ResLoader")
local KeyStateMgr    = import(".KeyStateMgr")
local Team       = import(".Team")
local AwakeMgr   = import(".AwakeMgr")
local GameObject  = import(".GameObject")
local BattleMgr   = import(".BattleMgr")
local LockStep   = import(".LockStep")
local enum       = import(".enum")
local eCampType  = enum.eCampType
local eRoleType  = enum.eRoleType
local eEvent     = enum.eEvent
local eStateEvent= enum.eStateEvent
local ePlaceType = enum.ePlaceType
local eHurtType   = enum.eHurtType
local eAttrType  = enum.eAttrType
local eGuideAction = enum.eGuideAction
local eVictoryType = enum.eVictoryType
local eBFState      = enum.eBFState
local eSkillType    = enum.eSkillType
local eMode         = enum.eMode
local eTeamType     = enum.eTeamType
local statistics    = import(".Statistics")
local victoryDecide = import(".VictoryDecide")
local brushMonster = import(".BrushMonster")
local musicMgr = import(".MusicMgr")  --MusicMgr.load(roleID)
local eMonsterType = enum.eMonsterType
local BattleTimerManager   = import(".BattleTimerManager")
local EventTrigger = import(".EventTrigger")
local levelParse   = import(".LevelParse")
local AIAgent      = import(".AIAgent")
local SkillEx       = import(".SkillEx")
local BattleGuide = import(".BattleGuide")
local SimpleHero = import(".SimpleHero")

local eBState =
{
    BS_NOT_INIT   = 0 ,
    BS_NOT_BEGIN  = 1 ,
    BS_RUN        = 2 ,
    BS_END        = 3
}
local _print = print
local print = BattleUtils.print
battleController =  {}

function TONUMBER(value)
    if not value then
        return 0
    end
    return tonumber(value)
end

local this = battleController

-- Box = function( ... )
--     -- body
-- end
function battleController.registerEvents()
    --????????????
    EventMgr:addEventListener(this, EV_SETTING_CHANGE, this._onSettingChange)
    --???????????????
    EventMgr:addEventListener(this, eEvent.EVENT_HERO_DEAD, this._onSlain)
    EventMgr:addEventListener(this, eEvent.EVENT_HERO_REMOVE, this._onHeroRemove)
    EventMgr:addEventListener(this, eEvent.EVENT_ADD_COMBO, this._onComboEvnet)
    --????????????
    EventMgr:addEventListener(this, eEvent.EVENT_NOTICE_HP, this._onNoticeHp)
    EventMgr:addEventListener(this, eEvent.EVENT_HP_CHANGE, this._onHpChange)
    EventMgr:addEventListener(this, eEvent.EVENT_GETHIT, this._onGetHit)
    EventMgr:addEventListener(this, eEvent.EVENT_HIT, this._onHit)
    EventMgr:addEventListener(this, eEvent.EVENT_PICKUP, this._onPickUp)
    EventMgr:addEventListener(this, eEvent.EVENT_FALL, this._onFall)
    EventMgr:addEventListener(this, eEvent.EVENT_SKILL_AWAKE, this._onSkillAwake)
    EventMgr:addEventListener(this, eEvent.EVENT_SKILL_DODGE, this._onSkillDodge)
    EventMgr:addEventListener(this, eEvent.EVENT_SKILL, this._onSkill)
    EventMgr:addEventListener(this, eEvent.EVENT_SKILL_ENTER_KILL, this._onSkillEnterKill)
    EventMgr:addEventListener(this, eEvent.EVENT_SKILL_AWAKE_KILL, this._onSkillAwakeKill)
    EventMgr:addEventListener(this, eEvent.EVENT_HERO_BATTLE, this._onHeroBattle)
    EventMgr:addEventListener(this, EV_BATTLE_END_TRIGGER_EVENT, this.endBattle)
    EventMgr:addEventListener(this, EV_PRACTICE_SET_SKIN, this.setSkin) --??????????????????
    EventMgr:addEventListener(this, eEvent.EVENT_TRIGGER_JUMP, this.onTriggerJump) --??????????????????
    EventMgr:addEventListener(this, EV_RECONECT_EVENT, handler(this.onReconnect))
    -- EventMgr:addEventListener(this, eEvent.EVENT_CHANGE_GUNGEON, this.onChangeDungeon) --??????????????????
    EventMgr:addEventListener(this, eEvent.EVENT_AIR_POINT_CHANGE, handler(this.onAirPointChange))
    


end

-- function battleController.getChildNode()
--     local route      = this.data.route
--     local dungeonCid = this.data.dungeonCid
--     for k, node in pairs(route) do
--         if node.dungeonId  == dungeonCid then 
--             return node
--         end
--     end
-- end

--?????????????????????
function battleController.isLockStepEx()
    if this.isLockStep() then 
        return this.data.dungeonNodes ~= nil
    end
end

--???????????????
function battleController.createJumpPoint()
    if this.isLockStepEx() then
        local npcList = levelParse:getNpcList()
        local node    = this.data.dungeonNodes[this.data.dungeonIndex]
        dump(this.data.dungeonIndex)
        dump(this.data.dungeonNodes)
        for k, v in ipairs(npcList) do
            local index   = tonumber(v.CfgID)
            if node.next[index] ~= 0 then 
                local data    = {}
                data.res      = this.levelCfg_.gateEffect or "effects_gate_01"
                data.index    = index
                data.pos      = me.p(v.Position.X, v.Position.Y)
                local jumpPoint    = GameObject.createJumpPoint(data)
                if node.pass then --???????????????????????????????????? ?????????
                    jumpPoint:setState(1) 
                end
                jumpPoint:active()
                dump({"createJumpPoint:" ,tostring(data.index),data.pos})
            end
        end
    end
end

--????????????
function battleController.changeDungeon(index,resTime)
    index = index + 1 --TODO ????????????????????????
    dump("battleController.changeDungeon"..tostring(index))

    --?????????????????????
    -- local timerHandle
    -- timerHandle = TFDirector:addTimer(3000, 1, nil, function ()
    --     TFDirector:removeTimer(timerHandle)
        this.reEnterTeamBattle(index,resTime)
    -- end) 


end

function battleController.onTriggerJump(posIndex)
    dump("onTriggerJump",posIndex)
    if this.bTriggerJump then 
        return 
    end
    this.bTriggerJump = true
    if this.isLeader() then
        local node  = this.data.dungeonNodes[this.data.dungeonIndex]
        local index = node.next[posIndex]
        --????????????
        local resTime = victoryDecide.nRemainingTime*0.001 --????????????
        resTime       = math.max(1,resTime) --?????????1???
        LockStep.sendChangeDungeon(index-1,resTime)
        dump("sendChangeDungeon"..tostring(index))
        -- local dungeonCid = this.data.dungeonCid
        -- for k, node in pairs(this.data.route) do
        --     if node.dungeonId  == dungeonCid then 
        --         local index  = node.next[posIndex]
        --         --?????????????????????????????????????????? 

        --     end
        -- end
    end
end



--??????????????????
function battleController.setSkin(skinID)
    --????????????????????? ??????????????????????????????
    print("??????skinID???"..tostring(skinID))
    local list = battleController.getBench()
    for i, hero in ipairs(list) do
        if hero:getData().skinCid == skinID then
            if this.getCaptain() ~= hero then 
                hero:setControl()
                if this.view then 
                   if this.view.practice_infinite_toggle then 
                        hero:setPracticeInfinite(true)
                    else
                        hero:setPracticeInfinite(false)
                    end
                end
            end
            return
        end
    end
    printError("??????skinID???"..tostring(skinID).."?????????")
end

function battleController.removeEvents()
    EventMgr:removeEventListenerByTarget(this)
end

function battleController._onMonsterLoseHp(value)
    statistics.loseHPEvent_monster(value)
end

function battleController._onHeroCreate(hero)
    if hero:getCampType() == eCampType.Monster then
        statistics.addMonsterInfo(hero)
    end
end
--????????????
function battleController._onSettingChange()
    BattleConfig.ROKER_FIX_POSTION = SettingDataMgr:getBattleRokeVal()
end

--?????????
function battleController._onFall(hero)
    if hero:getCampType() == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.fallEvent()
        end
    end
end


--????????????
function battleController._onSkill(hero,skill)
    if hero:getCampType() == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.skillCountEvent(skill)
        end
    end
end

function battleController._onSkillDodge(hero)
    if hero:getCampType() == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.skillDodgeEvent()
        end
    end
end

--??????????????????
function battleController._onSkillAwake(hero)
    if hero:getCampType() == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.skillAwakeEvent()
        end
    end
end

--???????????????
function battleController._onSkillAwakeKill(hero)
    if hero:getCampType() == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.skillAwakeKillEvent()
        end
    end
end

--??????????????????
function battleController._onSkillEnterKill(hero)
    if hero:getCampType() == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.skillEnterKillEvent()
        end
    end
end
--????????????
function battleController._onHpChange(hero,hp)
    if hp < 0 then 
        this._onLoseHp(hero,hp)
    end
    EventTrigger:_onChangeHp(hero)
end
--??????
function battleController._onLoseHp(hero,hp)
    local campType = hero:getCampType() 
    if campType == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.loseHPEvent(hp)
            --??????????????????????????????
            musicMgr.playInjured(hp)
        end
    elseif campType == eCampType.Monster then
       -- ??????????????? ???boss????????? 
        if this.isWorldBoss() and hero and not hero:isBoss() then
            return
        end
        if not this.enableAddHurt(hero) then
            return
        end
        statistics.doHurtValue(hp)
        this.fixHitValue()
        EventTrigger:_onMakeDamage()
    end
end

function battleController.enableAddHurt(hero)
    if not hero then
        return false
    end
    local levelCfg = BattleDataMgr:getLevelCfg()
    if levelCfg and levelCfg.damageMonsterType and #levelCfg.damageMonsterType > 0 then
        if table.indexOf(levelCfg.damageMonsterType,hero:getMonsterType()) == -1 then
            return false
        end
    end
    return true
end
--?????????
function battleController._onNoticeHp(hero,hp)
    if hero:getCampType() == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.hpEvent(math.abs(hp))
        end
    end
end
--??????
function battleController._onGetHit(hero)
    if hero:getCampType() == eCampType.Hero then
        if hero:getRoleType() ~= eRoleType.Assist then --?????????????????????
            statistics.hitEvent()
            victoryDecide.onHurt()
        end
    end
end

function battleController._onHit(hero,value)
    if hero:getCampType() == eCampType.Hero then
        statistics.doHitEvent(value)
        victoryDecide.onHit()
    end
end

function battleController._onHurtValue(hero,value)
    if hero:getCampType() == eCampType.Monster then
        statistics.doHurtValue(value)
        this.fixHitValue()
    end
end

--????????????
function battleController._onHeroBattle(hero)
    if hero:getCampType() == eCampType.Hero then
        statistics.heroBattleEvent(hero)
    elseif hero:getCampType() == eCampType.Monster then
        --???????????????????????????
        local  monsterType = hero:getMonsterType()
        if monsterType == eMonsterType.MT_ELITE or
            monsterType == eMonsterType.MT_BOSS then
            musicMgr.playEnemySpotted()
        end
        EventTrigger:_onNewHeroJoin()
    end
end

--????????????
function battleController._onPickUp(data)
    statistics.pickUpEvent(data.itemType)
end

function battleController._onHeroRemove(hero)
    local campType = hero:getCampType()
    if campType == eCampType.Monster then
        brushMonster:doSlain(hero)
    end
end

--???????????????
function battleController._onSlain(hero)
    local campType = hero:getCampType()
    if campType == eCampType.Monster then
        statistics.doScoreEvent(hero) --????????????
        --???????????????
        victoryDecide.doSlain(hero)
        brushMonster:doSlain(hero)
        statistics.doSlain(hero:isBoss())
        --??????????????????(??????????????????????????????????????????)
        musicMgr:playKill()
        EventTrigger:_onSlain(hero)
        this.eventCheck(hero)
    elseif campType == eCampType.Hero then
        --????????????????????????
        if hero:getRoleType() ~= eRoleType.Assist then --???????????????????????????
            statistics.deathEvent()
        end
        this.eventCheck(hero)
    elseif campType == eCampType.Call then

    elseif campType == eCampType.Other then
        EventTrigger:_onSlain(hero)
    end
end

--????????????????????????
function battleController._onPenalty(hero)
    

    return 0
end

--?????????????????????
function battleController._eatMonsterItem(hero,monster)
    if monster:getCamp() == 19 then
        statistics.eatMonsterItem(hero,monster)
    end
end

--??????????????????
function battleController.fixComboTime(time)
    statistics.fixComboTime(time)  
end
--????????????
function battleController._onComboEvnet(num)
    num = num or 1
    statistics.comboEvent(num)
    --??????????????????UI
    if statistics.combo > 1 then
        --TODO ????????????????????????
        EventMgr:dispatchEvent(eEvent.EVENT_SHOW_COMBO,statistics.combo,true)
        if this.isLockStep() then
            --TODO ??????????????? ??????????????? ?????????????????????????????????
            local heros = this.team:getMenbers(eCampType.Hero)
            for index , hero in ipairs(heros) do
                hero:onAttrTrigger(eAttrType.ATTR_COMBO ,statistics.combo)
            end
        else
            local hero = this.getCaptain()
            if hero then
                hero:onAttrTrigger(eAttrType.ATTR_COMBO ,statistics.combo)
            end
        end
    end
end

function battleController.getVictoryDecide()
    return victoryDecide
end

function battleController.getStatistics()
    return statistics
end

--?????????????????????
function battleController.getGlobalFixZ()
    if this.data.cameraAmend then
        return this.data.cameraAmend
    end
    return 0
end

function battleController.getTime()
   return statistics.time
end

function battleController.isTiming()
    if this.isRun() then
        if this.isLockStep() then
            return  true
        else
            if this.tmTimeDelayhandle then
                return false
            end
            return this.bTiming
        end
    end
    return false
end

--????????????????????????
function battleController.setTiming(bTime)
    if this.isLockStep() then
        return
    end
    if EventTrigger:isRunning() then
        return
    end
    this.bTiming = bTime
    -- if bTime then
    --     this.adjustSysStartTime()
    -- else
    --     if this.sysStartTime > this.sysTimeLimit then
    --         this.sysStopTime = BattleUtils.gettime()
    --     end
    -- end
    -- BattleMgr.updatePauseState(not bTime)
end

function battleController.pauseOrResume(isPause)
    -- if isPause then
    --     if this.sysStopTime > this.sysTimeLimit then
    --         return
    --     end
    --     if this.sysStartTime > this.sysTimeLimit then
    --         this.sysStopTime = BattleUtils.gettime()
    --     end
    -- else
    --     if this.isTiming() then
    --         this.adjustSysStartTime()
    --     end
    -- end
    -- BattleMgr.updatePauseState(isPause)
end

function battleController.adjustSysStartTime()
    if this.sysStartTime < this.sysTimeLimit then
        return
    end
    if this.sysStopTime > this.sysTimeLimit then
        this.sysStartTime = this.sysStartTime + (BattleUtils.gettime() - this.sysStopTime)
        this.sysStopTime = 0
    end
end

function battleController.getStopTime()
    return this.sysStopTime
end

--??????????????????????????? ???????????????????????????
function battleController.getControlPassTime()
    if this.sysStartTime < this.sysTimeLimit then
        return 0
    end
    if this.sysEndBattleTime > 0 then
        return this.sysEndBattleTime - this.sysStartTime
    end
    local time = 0
    if this.sysStopTime > this.sysTimeLimit then
        time = time + (BattleUtils.gettime() - this.sysStopTime)
    end
    return BattleUtils.gettime() - (this.sysStartTime + time)
end

function battleController.fixTime(time)
    if time > statistics.time then
        statistics.time = time
        --this.sysStartTime = BattleUtils.gettime() - time
        victoryDecide.fixRemainime(time)
    end
end


function battleController.getDungeonNode()
    return this.data.dungeonNodes[this.data.dungeonIndex]
end

--?????????????????????
function battleController.init(data)
    this.isChangeDungeon = false
    this.bTriggerJump = false
    this.cameraPos3D= me.Vertex3F(0, 0, 0)
    -- ????????????
    this.levelCfg_ = BattleDataMgr:getLevelCfg()
    --?????????????????????
    this.timeScale  = 1
    this.data         = data
    this.team      = Team:new()
    this.nStopFrameTime  = 0
    this.nState     = eBState.BS_NOT_BEGIN
    this.bWin      = false
    this.bSlowMotion = false
    this.bSlowMotionTime = 0
    this.sysTimeLimit = 1577811661 --2020???1???1???
    this.sysStartTime = 0  --????????????????????????
    this.sysStopTime = 0   --????????????????????????
    this.sysEndBattleTime = 0  --?????????????????????
    this.captain = nil --???????????????????????????
    KeyStateMgr.setEnable(true)
    --??????????????????
    victoryDecide.init(this.data.victoryCfg, this)
--
    this.bTiming = false --??????????????????
    this.bAiEnabled = true --AI ??????
    statistics.init(this.data.starCfg, this)
    brushMonster:init()
    if this.isLockStepEx() then 
        local nodeData = this.getDungeonNode()
        if nodeData.pass then --???????????????????????????
            brushMonster:setEnabled(false)
        else
            brushMonster:setEnabled(true)
        end
    else
        brushMonster:setEnabled(true)
    end
    GuideMgr:reloadState()

    this.isClearing = false

    --???????????????????????????????????????FPS
    if this.isLockStep() then
        SettingDataMgr:setFPS(LockStep.FPS)
    end
    --TODO ??????????????? ????????????
    -- this.comboTimmer = BattleTimerManager:addTimer(100,-1,nil,this.doComboEvent)
    -- this.showCombo    = 0
    -- this.showComboMax = 0

    --???????????????
    this.cameraMode   = eMode.FOLLOW
    --????????????????????????
    this.focusNode    = nil
    this.registerEvents()
    -- this.delayTest()
    AIAgent:setEnabled(true)
    AIAgent:reset()
    --????????????????????????
    ResLoader.setModalScale(this.levelCfg_.roleSize)
    this._onSettingChange()
    this.tmTimeDelayhandle = nil
    --????????????????????????
    this.bNeedVerifyHurt = false
    local battleType = this.data.battleType
    if battleType == EC_BattleType.COMMON or
        battleType == EC_BattleType.ENDLESS then
        if this.levelCfg_.dungeonType ~= EC_FBLevelType.PRACTICE and this.levelCfg_.dungeonType ~= EC_FBLevelType.MUSIC_GAME then
            this.bNeedVerifyHurt = true
        end
    end
    if BattleDataMgr:isMusicGameLevel() then
        KeyStateMgr.setEnable(false)
    end

    this.skillEx = nil
    this.simpleHeros = {}

    --??????????????????
    this.damageData = {}
end

--???????????????
function battleController.fixHitValue()
    if victoryDecide.nViewType == EC_LevelPassCond.SURVIVAL_HURT then 
        victoryDecide.doRefresh()
        if this.data.victoryCfg[1].victoryParam[2] then
            statistics.hitValue = math.min(statistics.hitValue,this.data.victoryCfg[1].victoryParam[2])
        end
    end
end

function battleController.getHitValue()
    return statistics.hitValue
end

--?????????????????????
function battleController.isDuelMode()
    return this.data.isDuelMod
end
--TODO ??????????????????
function battleController.delayTest()
    local handle
    handle = BattleTimerManager:addTimer(20000,1,function ()
        --?????????????????????
        -- this.cameraMoveTo(3,me.Vertex3F(300,300,600),3,3,function()
        --     -- this.setCameraMode(eMode.FOLLOW)
        --     Box("aas")
        --     end)

        -- ????????????????????????
        this.setCameraMode(eMode.FOLLOW)
        this.setFocusNode(this.team:getHeros()[1]:getActor())
        BattleTimerManager:removeTimer(handle)
        Box("asdfasdf")
    end)
end

function battleController.getCameraMode()
    return this.cameraMode
end

function battleController.getFocusNode()
    if this.focusNode then
        return this.focusNode
    end
    local hero = this.getCaptain()
    if hero then
        return hero.actor
    end
end

function battleController.checkCondSuccess( cond , params )
    -- body
    local result = true
    for k,v in pairs(cond) do
        if k == "event" and params.event then
            if v ~= params.event then
                result = false
            end
        end
    end
    return result
end

function battleController.setFocusNode(focusNode)
    this.focusNode    = focusNode
end

function battleController.setCameraMode(mode)
    this.cameraMode    = mode
end

function battleController.getCameraPos3D()
    return this.cameraPos3D
end

function battleController.setCameraPos3D(pos)
    this.cameraPos3D = pos
end

function battleController.cameraMoveTo(moveTime,position,stayTime,backTime,callFunc)
    this.setCameraMode(eMode.MANUAL)
    EventMgr:dispatchEvent(eEvent.EVENT_CAMERA_EVENT,moveTime,position,stayTime,backTime,callFunc)
end


-- function battleController.doComboEvent()
--     -- _print("____doComboEvent____")
--     -- statistics.combo


--     if statistics.combo > this.showComboMax then
--         this.showComboMax = statistics.combo
--     end

--     if this.showCombo < this.showComboMax then
--         this.showCombo = this.showCombo + 1
--         if this.showCombo > 1 then
--             EventMgr:dispatchEvent(eEvent.EVENT_SHOW_COMBO,this.showCombo,true)
--         end
--     else
--         if this.showComboMax  > statistics.combo  then
--             this.showComboMax = statistics.combo
--             this.showCombo = 0
--         end
--     end
-- end
function battleController.getPlayer(pid)
    local hero = this.team:getHeroWithPID(pid)
    if not hero then 
        for i,v in ipairs(this.simpleHeros) do  
            if v:getData().pid == pid then 
                return v
            end
        end
    end

    return hero
end

--??????CID ????????????(????????????)
function battleController.getHeroWithCid(cid)
    local heros = this.team:getHeros()
    for i , hero in ipairs(heros) do
        if hero:getData().cid == cid then
            return hero
        end
    end
end

--??????pid????????????(??????????????????)
function battleController.getHeroWithPid(pid)
    local heros = this.team:getHeros()
    for i , hero in ipairs(heros) do
        if hero:getPID() == pid then
            return hero
        end
    end
end

--??????????????????????????????
function battleController.isLockStep()
    if this.data then
        return this.data.battleType == EC_BattleType.TEAM_FIGHT
    end
end

--???????????????????????????
function battleController.synchronHp(hero)
    if this.isLockStep() then
        LockStep.synchronHp(hero)
    end
end
function battleController.synchronHurtValue(hero)
    if this.isLockStep() then
        LockStep.syncHeroHurtValue(hero)
    end
end

function battleController:getBattleData()
    return this.data
end

--????????????
function battleController.createProp(data,pos)
    local prop = GameObject.createProp(data)
    prop:setPosition(pos)
    prop:active()
end

function battleController.getCaptain()
    return this.captain
end

--
-- function battleController.resetSyncBossState_hero_pid()
--     -- this.synBoss_pId = 
--     if this.isLockStep() then
--         local heros = this.getMenbers()
--         table.sort(heros,function ( a , b )
--             return a.data.priority > b.data.priority
--         end)
--         for i, hero in ipairs(heros) do
--             if hero:isAlive() then
--                 this.syncBossState_hero_pid =  hero.data.pid
--                 print_(" priority:"..hero.data.priority)
--                 return
--             end
--         end
--     end
-- end

-- function battleController.getSyncBossState_hero_pid()
--     return this.syncBossState_hero_pid
-- end


--???????????????????????????
function battleController.isLeader()
    return this.data.leader == MainPlayer:getPlayerId()
end

--??????PID (?????????????????????)
function battleController.getLeaderPid()
    return this.data.leader
end
--??????ID
function battleController.setLeaderPid(leaderId)
    this.data.leader = leaderId
end
--??????????????????
function battleController.getMenbers()
    return this.team:getMenbers(eCampType.Hero)
end
--????????????????????????(?????????????????????)
function battleController.getBench()
    -- local heros = this.team:getHeros()
    -- local retHeros = {}
    -- for i, hero in ipairs(heros) do
    --     if hero:getRoleType() == eRoleType.Hero then
    --         -- if not hero:isActive() then
    --             retHeros[#retHeros + 1] = hero
    --         -- end
    --     end
    -- end
    return this.team:getHeros()
end


--????????????????????????
function battleController.getAssist()
    return this.team:getAssist()
end

--?????????????????????
function battleController.getEnemyMember()
    return this.team:getMenbers(eCampType.Monster)
end

--
function battleController.getEnemyWithCID(cid)
    local enemys = this.getEnemyMember()
    for i, enemy in ipairs(enemys) do
        if enemy:getData().id == cid then
            return enemy
        end
    end
end

--??????maskID????????????
function battleController.getEnemyWithMaskID(maskID)
    local enemys = this.getEnemyMember()
    for i, enemy in ipairs(enemys) do
        if enemy:getData().markID == maskID then
            return enemy
        end
    end
end

--??????maskID????????????(???????????????)
function battleController.getAllEnemyWithMaskID(maskID)
    local enemys = this.team:getMenbers(eCampType.Monster)
    for i, enemy in ipairs(enemys) do
        if enemy:getData().markID == maskID then
            return enemy
        end
    end
    enemys = this.team:getMenbers(eCampType.Other)
    for i, enemy in ipairs(enemys) do
        if enemy:getData().markID == maskID then
            return enemy
        end
    end
    enemys = this.team:getMenbers(eCampType.Call)
    for i, enemy in ipairs(enemys) do
        if enemy:getData().markID == maskID then
            return enemy
        end
    end
end


--???????????????????????????????????????
function battleController.getEnemyMember__()
    return this.team:getMenbers___(eCampType.Monster)
end

--????????????
function battleController.setCaptain(hero)
    local oldCaptain = this.captain
    if this.captain ~= hero then
        if hero then
            musicMgr.load(hero:getData().id,hero)
            if oldCaptain then --??????????????????
                local temp = oldCaptain.headShowIndex
                oldCaptain.headShowIndex = hero.headShowIndex
                hero.headShowIndex = temp
            end
        end
        --??????????????????????????????
        EventMgr:dispatchEvent(eEvent.EVENT_GATHER_BAR_UPDATE,3,hero)
    end
    this.captain = hero
    if oldCaptain ~= this.captain  then
        --??????????????????????????????
        musicMgr.playBorn()
    end
    if this.isLockStep() then --????????????
        KeyStateMgr.setAgent(LockStep)
    else
        KeyStateMgr.setAgent(this.captain)
    end
    EventMgr:dispatchEvent(eEvent.EVENT_CAPTAIN_CHANGE)
end

function battleController.clear()
    this.timeScale    = 1
    this.data         = nil
    this.team         = nil
    this.nState     = eBState.BS_NOT_INIT
    this.bSlowMotion = false
    this.bSlowMotionTime = 0
    -- --????????????
    this.sysStartTime = 0
    this.sysStopTime = 0
    this.sysEndBattleTime = 0
    statistics.clear()
    --??????????????????
    victoryDecide.clear()
    this.bTiming = false --????????????
    this.bAiEnabled = true --AI ??????
    --????????????(?????????????????????)????????????true
    this.bStart = nil

    -- ??????????????????
    this.isClearing = false
    if this.tmTimeDelayhandle then
        BattleTimerManager:removeTimer(this.tmTimeDelayhandle)
        this.tmTimeDelayhandle = nil
    end
    this.removeEndBattleTimer()
    this.specifyMonsters = nil
    this.skillEx = nil
    -- --??????????????????
    -- this.showCombo    = 0
    -- this.showComboMax = 0
    -- if this.comboTimmer then

    --     BattleTimerManager:removeTimer(this.comboTimmer)
    --     this.comboTimmer = nil
    -- end
    this.damageData = {}
end

function battleController:isRun()
    return (this.nState  == eBState.BS_RUN and not this.isClearing)
end

function battleController:needUpdate()
    return this.nState  > eBState.BS_NOT_BEGIN
end

function battleController.getMaxStage()
    local levelCfg = BattleDataMgr:getLevelCfg()
    return levelCfg.victoryParam[1][1]
end

function battleController.getHeroData()
    return this.data.heros
end

function battleController.getTeamHeroData()
    if this.data.teamType == eTeamType.ZLJH then
        local datas = {}
        for i, v in ipairs(this.data.heros) do
            if v.pid == MainPlayer:getPlayerId() then
                table.insert(datas,v)
            end
        end
        return datas
    else
        return this.data.heros 
    end
end

--??????????????????Boss(??????????????????)
function battleController.getBoss()
    local heros = this.team:getHerosEx()
    --Boss ?????????????????????Boss
    local temps = {}
    for i, hero in ipairs(heros) do
        if hero:getRoleType() == eRoleType.Monster then 
            if hero:isBoss() then 
                return hero
            end
            table.insert(temps,hero)
        end
    end
    return temps[1]
end

--??????????????????????????????(????????????) 
function battleController.createInventedResultData()
    local hero = this.getPlayer(MainPlayer:getPlayerId())
    local hurtValue  = hero:getData().hurtValue
    --TODO ???????????????????????????
    local data = 
    {
        invented     = true, --???????????????
        fightTime    = 0,
        isSpecial    = false,
        huntingHonor = math.ceil(hurtValue*0.0001) ,
        results   = {
            [1] = {
                hurt = hurtValue,
                mvp  = false,
                pid  = MainPlayer:getPlayerId(),
                rewards = {}
            }
        }
        ,
        rewards = {
            -- [1] = {id  = 555001,num = 4},
            -- [2] = {id  = 500005,num = 10},
            -- [3] = {id  = 570029,num = 3},
            -- [4] = {id  = 500001,num = 1500},
        }
        ,
        win  = true
    }
    return data
end



function battleController.getSimpleHeros()
    return this.simpleHeros
end
function battleController.removeSimpleHero(hero)
    if this.simpleHeros then 
        table.removeItem(this.simpleHeros,hero)
        this.eventCheck(hero)
    end
end


function battleController.isTeamMemberAllDead()
    if this.isZLJH() then 
        -- Box("isTeamMemberAllDead:"..tostring(#this.simpleHeros))
        dump("isTeamMemberAllDead---------------------------:"..tostring(#this.simpleHeros))
        for i , hero in ipairs(this.simpleHeros) do
            if hero:getData().pid ~=  MainPlayer:getPlayerId() then
                print_(hero:getName()..":"..tostring(hero:isAlive()))
                if hero:isAlive() then 
                    return false  
                end
            end
        end
        dump({"isAllDead:"..tostring(this.team:isAllDead(eRoleType.Team))})
        return this.team:isAllDead(eRoleType.Team)
    else
        if this.team:isAllDead(eRoleType.Team) then
            return true 
        end
    end
end

--????????????????????????(?????????????????????)
function battleController.getTeamMembers()
    if this.data.teamType == eTeamType.ZLJH then
        return this.simpleHeros
    end
    return this.team:getHeros()
end
--?????????????????????(???????????????????????????????????????)
function battleController.isZLJH()
    if this.isLockStep() then
        if this.data.teamType == eTeamType.ZLJH then
            return true
        end
    end
end

--boss??????
function battleController.isBossChallenge()
    if this.isLockStep() then
        if this.data.teamType == eTeamType.BOSS then
            return true
        end
    end
end
-- ????????????????????????
function battleController.isWorldBoss()
    local levelCfg = BattleDataMgr:getLevelCfg()
    if levelCfg.dungeonType == EC_FBLevelType.WORLD_BOSS then
        return true
    end
end
-- ???????????????????????????(???????????????????????? ????????????)
function battleController.isWorldBossFour()
    local type  = LeagueDataMgr:getFightWorldBossType()
    if not type then  
        return false
    end
    if this.isWorldBoss() and type == EC_WorldBossType.World then
        return true
    end
end

function battleController.showCounDown(callFunc)
    if this.levelCfg_.countOpen then
        EventMgr:dispatchEvent(eEvent.EVENT_SHOW_COUNTDOWN, function ()
                if callFunc then
                    callFunc()
                end
            end)
    else
        if callFunc then
            callFunc()
        end
    end
end

function battleController.showWarning(callFunc)
    if not this.levelCfg_.warningTime then
        this.setTiming(false)
        BattleUtils.playEffect(BattleConfig.BOSS_WARNING ,false,1)
        EventMgr:dispatchEvent(eEvent.EVENT_BOSS_WARNING, function ()
                if callFunc then
                    callFunc()
                end
                this.setTiming(true)
            end)
    else
        EventMgr:dispatchEvent(eEvent.EVENT_BOSS_WARNING)
        if callFunc then
            callFunc()
        end
    end
end

--??????????????????GOGO
function battleController.showGo(visible)
    EventMgr:dispatchEvent(eEvent.EVENT_SHOW_GO,visible)
end

function battleController.getTeam()
    return this.team
end

function battleController.start()
    --????????????
    this.setTimeScale( BattleConfig.DEFAULT_TIMESCALE )
    this.nState = eBState.BS_RUN
    this.bTiming = false
    this.startTimer()
    --?????????????????????
    if this.data.teamType == eTeamType.ZLJH then --????????????
        if this.isLockStep() then 
            for i, v in ipairs(this.data.heros) do
                -- if v.pid ~= MainPlayer:getPlayerId() then --??????????????????????????????
                    local hero = SimpleHero:new(v)
                    table.insert(this.simpleHeros,hero)
                -- end
            end
        end
    end
    -- if not this.isLockStep() then
        EventTrigger:prevAct(handler(this.herosEnter,this))
    -- else
    --     this.herosEnter()
    -- end
end

function battleController.herosEnter()
    local data = BattleDataMgr:getBattleData()

    AIAgent:setEnabled(true)
    -- local data = this.getHeroData()
    local data = this.getTeamHeroData() --?????????????????????
    this.team:addMember(data)
    EventMgr:dispatchEvent(eEvent.EVENT_PREWARTIP_SHOW)
    --??????
    this.team:createHeros(function()
        print_("this.team:createHeros")
        if this.nState > eBState.BS_NOT_INIT then
            this.setCameraMode(eMode.FOLLOW)
            if this.isLockStep() then
                this.setCaptain(this.team:getCaptain())
            else
                this.setCaptain(this.captain)
            end
            if this.levelCfg_.delayTime and this.levelCfg_.delayTime ~= 0 then
                this.tmTimeDelayhandle = BattleTimerManager:addTimer(this.levelCfg_.delayTime,1,function()
                    BattleTimerManager:removeTimer(this.tmTimeDelayhandle)
                    this.tmTimeDelayhandle = nil
                    this.setTiming(true)
                end,nil)
            end
            this.showCounDown(function()
                this.setTiming(true)--????????????
                EventTrigger:start()
                local levelCfg_ = BattleDataMgr:getLevelCfg()
                if levelCfg_ and (levelCfg_.dungeonType == EC_FBLevelType.PRACTICE or levelCfg_.dungeonType == EC_FBLevelType.MUSIC_GAME) then
                    AIAgent:setEnabled(false)
                    EventMgr:dispatchEvent(EV_PRACTICE_BRUSH_MONSTER)
                end
            end)
            --?????????????????????
            EventMgr:dispatchEvent(eEvent.EVENT_INITED_TEAM)
            this.checkAndCreateSkillEx()
        end
    end)

end

function battleController.checkLimitHeroAttrExchange()
    local heros = this.team:getMenbers_(1,1,false)
    for i,hero in ipairs(heros) do
        if not hero:isFlag(1) then
            return
        end
    end
    local function exchangeAttr( heroId, attrs)
        local srcHero = nil
        for i,v in ipairs(heros) do
            if v:getData().id == heroId then
                srcHero = v
            end
        end

        if srcHero then
            for i,v in ipairs(heros) do
                if v:getData().id ~= srcHero:getData().id then
                    v:recvExchangeAttr(srcHero,attrs)
                end
            end
        end
    end
    local limitCfgs = TabDataMgr:getData("LimitHeroAttribute")
    local serverTime = ServerDataMgr:getServerTime()
    local changeHeroId = 0
    local changeAttre = {}
    local levelCfg_ = BattleDataMgr:getLevelCfg()
    for k,cfg in pairs(limitCfgs) do
        local openTime = Utils:getTimeByDate(cfg.stime)
        local endTime = Utils:getTimeByDate(cfg.etime)
        if serverTime > openTime and serverTime < endTime then
            local flag = false
            for i,dungeonId in ipairs(cfg.dungeonId) do
                if levelCfg_ and levelCfg_.id == dungeonId then
                    exchangeAttr(cfg.heroId, cfg.activation)
                    flag = true
                    break
                end
            end
            if not flag then
                for i,dungeonType in ipairs(cfg.dungeonType) do
                    if levelCfg_ and levelCfg_.dungeonType == dungeonType then
                        exchangeAttr(cfg.heroId, cfg.activation)
                        break
                    end
                end
            end
        end
    end
end

function battleController.endFight()
    this.setTimeScale(1.0)
    if this.team then
        this.team:clearAllBuff()
        this.team:realeaseHeros()
    end
    BattleMgr.clear()
    this.removeTimer()
end

--?????????????????????
function battleController.setTimeScale(timeScale)
    this.timeScale = timeScale
end

function battleController.getTimeScale()
    return this.timeScale
end
--?????????
function battleController.setSlowMotion(slowMotion)
    this.bSlowMotion = slowMotion
    if this.bSlowMotion then
        this.setTimeScale(BattleConfig.MOTION_TIMESCALE)
        this.bSlowMotionTime = BattleConfig.MOTION_TIME
    else
        this.setTimeScale(BattleConfig.DEFAULT_TIMESCALE)
        this.bSlowMotionTime = 0
    end
    -- printError("setSlowMotion")
end

function battleController.isSlowMotion()
    return this.bSlowMotion
end

function battleController.handlSlowMotion(delta)
    if this.bSlowMotion then
        if this.bSlowMotionTime <= 0 then
            this.setSlowMotion(false)
            return
        end
        this.bSlowMotionTime = this.bSlowMotionTime - delta
    end
end


--????????????????????????
function battleController.isWillEnd()
    return false
    -- return brushMonster:isWillEnd()
end


function battleController.resumeFight()
    this.team:startfight()
end


-- 1????????????
-- 52???????????? 
-- {
        -- [3250]= --??????ID
        -- {
        --     [1] = 20000, --??????ID  ?????????
        --     [52] = 5000,
        -- }
-- }

--??????????????????
function battleController.setSpecifyMonster(data)
    this.specifyMonsters = data
end

--????????????
function battleController.getSpecifyMonsterInfo(cid)
    if this.specifyMonsters then 
        return this.specifyMonsters[cid]
    end
end

function battleController.requestFightStart(...)
    -- dump({...})
    local data = {...}
    FubenDataMgr:send_DUNGEON_FIGHT_START(...)
    FubenDataMgr:saveCurFightParam(...)
    this.specifyMonsters = nil
end

function battleController.stopSynchronizeTimer()
    if this.synchronizeTimerID then
        TFDirector:removeTimer(this.synchronizeTimerID)
        this.synchronizeTimerID  = nil
    end
end

function battleController.requestFightingOver()
    local isWin = this.bWin
    --?????????
    local battleType = BattleDataMgr:getBattleType()
    local levelCfg = BattleDataMgr:getLevelCfg()
    if battleType == EC_BattleType.COMMON then
        local levelId = BattleDataMgr:getPointId()
        local reachStar = statistics.calReachStar()
        local pickUpTypeCount = statistics.pickUpTypeCount
        local pickUpCount     = statistics.pickUpCount
        local maxComboNum     = statistics.maxComboNum
        local killTargets = victoryDecide.getKillTargets()
        local hitValue = statistics.hitValue
        local rating   = victoryDecide.getRating()
        local skillEnemy = {}
        if statistics.skillEnterKill > 0 then
          table.insert(skillEnemy,{eSkillType.ENTER, statistics.skillEnterKill})
        end
        if statistics.skillAwakeKill > 0 then
          table.insert(skillEnemy,{eSkillType.AWAKE, statistics.skillAwakeKill})
        end
        if levelCfg.dungeonType == EC_FBLevelType.PRACTICE or
                levelCfg.dungeonType == EC_FBLevelType.NOOBSUMMON or
                levelCfg.dungeonType == EC_FBLevelType.MUSIC_GAME then
        elseif levelCfg.dungeonType == EC_FBLevelType.MONSTER_TRIAL then
			battleController.sendVerifyFightResult(isWin)
			local costTime = math.floor(this.getTime())
	
			local total = FubenDataMgr:caculationMonsterScore(this.levelCfg_.id, costTime)			
            FubenDataMgr:send_DUNGEON_FIGHT_OVER(levelId, isWin, {total},
                                                 maxComboNum, pickUpTypeCount,
                                                 pickUpCount, killTargets, costTime, hitValue,rating,skillEnemy)
        else
            battleController.sendVerifyFightResult(isWin)
            local costTime = math.floor(this.getTime())
            FubenDataMgr:send_DUNGEON_FIGHT_OVER(levelId, isWin, reachStar,
                                                 maxComboNum, pickUpTypeCount,
                                                 pickUpCount, killTargets, costTime, hitValue,rating,skillEnemy)
        end
    elseif battleType == EC_BattleType.ENDLESS then
        local levelCid = BattleDataMgr:getPointId()
        local levelCfg = BattleDataMgr:getLevelCfg()
        local costTime = math.floor(this.getTime())
        local maxComboNum     = statistics.maxComboNum
        local hitValue = statistics.hitValue
        local hpPercent = {}
        for i, v in ipairs(this.team:getHeros()) do
            local hp = 10000
            if FubenDataMgr:isEndlessRacingMode(levelCid) then
                if costTime < levelCfg.time * 1000 then
                    hp = math.floor(v:getHpPercent())
                    if hp > 0 then
                        hp = math.min(hp + levelCfg.hpRecover, 10000)
                    end
                else
                    hp = FubenDataMgr:getEndlessHeroHpPercent(v.data.id)
                end
            end
            table.insert(hpPercent, {v.data.id, hp})
        end
        battleController.sendVerifyFightResult(isWin)
        FubenDataMgr:send_ENDLESS_CLOISTER_REQ_PASS_STAGE_ENDLESS(levelCid, costTime, hpPercent, isWin, maxComboNum, hitValue)
    elseif battleType == EC_BattleType.TEAM_FIGHT then --????????????
        local memberData = {}
    --????????????
        for i, heroData in ipairs(this.data.heros) do
            table.insert(memberData,{heroData.pid,heroData.hurtValue})
        end
        local data = {
            this.data.randomSeed,
            isWin,
            memberData,
            statistics.time,
            statistics.getMaxComboNum(),
            statistics.killNum,   -- ???????????????
            statistics.killBossNum , --??????Boss??????
        }
        dump(data)
        _print("??????????????????????????????")
        --????????????????????????
        TeamFightDataMgr:requestChasmFight(data)
    end
end
--??????????????????(????????????)
function battleController.enterBattle(data, ...)
    this.lastSceneName = "default"
    local scene = Public:currentScene()
    if scene  then 
        this.lastSceneName = scene.__cname 
    end
    -- ?????????????????????
    if this.bStart then
        this.exitBattle()
    end
    this.bStart = true
    this.nStartTime = BattleUtils.gettime() --??????????????????
    BattleDataMgr:setServerData(data, ...)
    local data = BattleDataMgr:getBattleData()
    if not data.heros or #data.heros < 1 then
        return
    end
    ResLoader.loadAllRes(data , function()
        this.init(data)
        this.changeToBattleScene()
    end)
end

function battleController.stopEnterBattle()
    ResLoader.stopTimer()
end

--
function battleController.changeToBattleScene()
    TFAudio.stopAllEffects()
    BattleUtils.playMusic(this.data.bgm, true)
    AlertManager:changeScene(SceneType.BATTLE)
end

--??????????????????(??????????????????)
function battleController.enterTeamBattle(sData, ...)
    this.lastSceneName = "default"
    local scene = Public:currentScene()
    if scene  then 
        this.lastSceneName = scene.__cname 
    end
    -- ?????????????????????
    if this.bStart then
        this.exitBattle()
    end
    this.bStart = true
    BattleDataMgr:setServerTeamData(sData, ...)
    local data = BattleDataMgr:getBattleData()
    this.init(data)
    --?????????????????????
    LockStep.reset()
    LockStep.setUDPCfg(data.fightServerHost,data.fightServerPort)
    LockStep.connect()--??????KCP??????
    ResLoader.loadAllRes(data , function()
            -- TFAudio.stopAllEffects()
            -- BattleUtils.playMusic(data.bgm, true)
            -- AlertManager:changeScene(SceneType.BATTLE)
            -- LockStep.reset()
            -- LockStep.setUDPCfg(data.fightServerHost,data.fightServerPort)
                    -- this.changeToBattleScene()

    end)
end

function battleController.popLastScence( ... )
    -- body
    if this.lastSceneName == "BaseOSDScene" then 
        local OSDControl = require("lua.logic.osd.OSDControl")
        OSDControl:enterOSD({})
    elseif this.lastSceneName == "AmusementPackScene" then
        WorldRoomDataMgr:enterCurRoom()       
    else
        AlertManager:changeScene(SceneType.MainScene)
    end
end


--TODO????????????????????????
function battleController.reEnterTeamBattle(index,resTime)
    if not this.data then
        return
    end
    this.isChangeDungeon = true
    --????????????????????????
    local node  = this.data.dungeonNodes[this.data.dungeonIndex]
    node.pass   = true --??????
    local sData = BattleDataMgr:getServerData()
    local data = BattleDataMgr:resetServerData(sData,this.data.dungeonNodes,index,this.data.leader)
    data.heros = {}
    local heros = this.team:getHeros()
    for i,hero in ipairs(heros) do
        local heroData = hero:getData()
        local hp = hero:getHp()
        if hp == 0 then
            heroData.__hp = nil
        else
            heroData.__hp = hp
        end
        table.insert(data.heros,heroData)
    end
    --??????????????????
    this.exitBattle()
    levelParse:clean()
    AlertManager:changeScene(SceneType.TRANSITION)
    --???????????????????????????
    local timerHandle = TFDirector:addTimer(500, 1, nil, function ()
        if timerHandle then
            TFDirector:removeTimer(timerHandle)
            timerHandle = nil
        end
        local data = BattleDataMgr:getBattleData()
        if not data then
            return
        end
        local maxComboNum = statistics.maxComboNum
        local killNum     = statistics.killNum   -- ???????????????
        local killBossNum = statistics.killBossNum --??????Boss??????
        local time        = statistics.time        
        this.init(data)
        statistics.maxComboNum = maxComboNum
        statistics.killNum     = killNum  -- ???????????????
        statistics.killBossNum = killBossNum --??????Boss??????
        statistics.time        = time
        victoryDecide.setRemainime(resTime)
        LockStep.discardingUselessframes() --TODO ?????????????????????
        battleController.changeToBattleScene()
    end) 

end



function battleController._endBattle()
    --??????????????????
    musicMgr.playEndOfBattle(this.bWin)
    EventMgr:dispatchEvent(eEvent.EVENT_SHOW__STACE_CLEAR, function ()end)
    HeroDataMgr:changeDataToSelf()
    --?????????????????????????????????
    this.requestFightingOver()
end

--??????
function battleController.removeEndBattleTimer()
    if this.endBattleTimer then
        BattleTimerManager:removeTimer(this.endBattleTimer)
        this.endBattleTimer = nil
    end
end

--????????????
function battleController.endBattle(bWin)
    if this.isZLJH() or this.isWorldBossFour() then 
        bWin = true
    end
    if this.isClearing then return end
    local enemys = this.getEnemyMember()
    for i, enemy in ipairs(enemys) do
        enemy:setAIEnable(false)
    end
    if bWin then 
        if this.isLockStepEx() then 
            local nodeData = this.getDungeonNode()
            if not nodeData.last then
                --??????????????????(?????????????????????????????????????????????)
                local playerId = MainPlayer:getPlayerId()
                local hero     = battleController.getPlayer(playerId)
                if hero:isDead() then 
                    LockStep.sendRelive()
                    EventMgr:dispatchEvent(EV_TEAM_FIGHT_FIGHT_REVIVE)
                end
                --???????????????
                EventMgr:dispatchEvent(eEvent.EVENT_CHANGE_JUMPPOINT_STATE,1) 
                EventMgr:dispatchEvent(eEvent.EVENT_SHOW_CHANGE_DUNGEON)
                return 
            end 
        end
    end

    victoryDecide.doRefresh()
    victoryDecide.stopReduceTimer()
    this.isClearing = true
    this.sysEndBattleTime = BattleUtils.gettime()
    this.bWin = bWin
    KeyStateMgr.setEnable(false)
    this.stopSynchronizeTimer()
    this.team:clearAllBuff()
    if this.bWin == false then
        this._endBattle()
        return false
    end
    local count = 1
    this.removeEndBattleTimer()
    this.endBattleTimer = BattleTimerManager:addTimer(500,-1,nil,function()
        if not this.endBattleTimer then
            return
        end
        if this.team:isPlayedEndAction(eCampType.Hero) or count > 4 then
            this.removeEndBattleTimer()
            this._endBattle()
        end
        count = count + 1
    end)
end

--TODO ????????????????????????
function battleController.forceEndBattle(bWin,callFunc)
    _print("forceEndBattle")
    if this.isClearing then return end
    this.isClearing = true
    this.sysEndBattleTime = BattleUtils.gettime()
    KeyStateMgr.setEnable(false)
    this.stopSynchronizeTimer()
    if bWin then
        --????????????
        musicMgr.playVertigo()
    else
        --????????????
        musicMgr.playDefeat()
    end
    local battleType = BattleDataMgr:getBattleType()
    this.bWin = bWin
    EventMgr:dispatchEvent(eEvent.EVENT_SHOW__STACE_CLEAR, function ()
            if callFunc then
                callFunc()
            end
        end)
    HeroDataMgr:changeDataToSelf()
    this.team:clearAllBuff()
end

function battleController:onReconnect()
    if this.isClearing then
        EventMgr:dispatchEvent(eEvent.EVENT_LEAVE)
    end
end

function battleController.startTimer()
    this.bStartTime = true
end

function battleController.removeTimer()
    this.bStartTime = false
end
--????????????
function battleController.isWin()
    return this.bWin
end

function battleController.pause()
    BattleMgr.pause()
    KeyStateMgr.setEnable(false)
    EventMgr:dispatchEvent(eEvent.EVENT_PAUSE,true)
end

function battleController.resume()
    BattleMgr.resume()
    KeyStateMgr.setEnable(true)
    EventMgr:dispatchEvent(eEvent.EVENT_RESUME)
end
function battleController.skillExUpdate(delta)
    if this.skillEx then 
        this.skillEx:update(delta)
    end
end
function battleController.update(delta)
    -- print("xxxxxxxxxxxbattleCtrl.updatexxxxxxxxx")
    -- delta = delta*1000
    if not this.bStartTime  then
        return
    end
    this.hitMusicNum = {}
    -- this.handlCombo(delta)
    this.team:update(delta)
    levelParse:update(delta)
    BattleTimerManager:update(delta*0.001)
    --????????????
    this.handlSlowMotion(delta)
    this.skillExUpdate(delta)
    if this.isTiming() then
        if this.sysStartTime < this.sysTimeLimit then
            this.sysStartTime = BattleUtils.gettime()
        end
        --??????????????????
        statistics.update(delta)
        --????????????
        victoryDecide.update(delta)
        --????????????
        musicMgr.update(delta)
    end
    BattleMgr.update(delta)
    -- ??????
    brushMonster:update(delta)
    if BattleGuide:isGuideStart() then
        BattleGuide:update(delta)
    end
end
function battleController.handlStopFrame(delta)
    --????????????
    if this.nStopFrameTime > 0  then
        this.nStopFrameTime = this.nStopFrameTime - delta
        return true
    end
end

--??????????????????
function battleController.setStopFrame(time)
    if this.isLockStep() then --TODO ????????????????????????
        return
    end
    this.nStopFrameTime = time
end

function battleController.free()

end

--????????????
function battleController.nextState()
    victoryDecide.nextState()
end

--????????????
function battleController.nextWave()
    victoryDecide.nextWave()
end

--????????????
function battleController.setWave(wave)
    victoryDecide.setWave(wave)
end

function battleController.getWave()
    return victoryDecide.getWave()
end

function battleController:getCurBrushWave()
    return brushMonster:getCurBrushWave()
end

function battleController.eventCheck(hero)
    if not this.isRun() then
        return
    end
    --????????????
    if this.isLockStep() then
        if this.isTeamMemberAllDead() then 
            if this.levelCfg_.dungeonType == EC_FBLevelType.NIANSHOU then
                this.endBattle(victoryDecide.checkLastResult(false))
            else
                this.endBattle(false)
            end
        end
    else
        --???????????????????????????????????????????????????
        if this.levelCfg_.dungeonType == EC_FBLevelType.PRACTICE or this.levelCfg_.dungeonType == EC_FBLevelType.MUSIC_GAME then
            if hero:getCampType() == eCampType.Hero then
                this.endBattle(false)
            end
        else
            if this.team:isAllDestoryByRoleType(eRoleType.Hero,eRoleType.Team) then
                this.endBattle(false)
            end
        end
    end
end


function battleController.getAirwall()
    return levelParse:getCameraRect()
end

--TODO ???????????????
function battleController.getMoveRect()
    return  levelParse:getMoveRect()
end

function battleController.getMaxCameraHeight()
    return levelParse:getSceneHeight()
end

--???????????????????????????
--??????????????????
--TODO ???????????????????????????
function battleController.checkVertical(posy)
    local rect = this.getMoveRect()
    local origin = rect.origin
    local size   = rect.size
    --?????????????????????
    if posy < origin.y then
        -- pos.y = origin.y
        return 1 , posy - origin.y
    elseif posy > origin.y + size.height then
        -- pos.y = origin.y + size.height
        return 2 , origin.y + size.height - posy
    end
    return 0 , 0
end

function battleController.isOverflowAirWall(pos)
    local rect = this.getMoveRect()
    local origin = rect.origin
    local size   = rect.size
    --?????????????????????
    local bottomVertical = pos.y <= origin.y
    local topVertical = pos.y >= origin.y + size.height
    -- ??????????????????
    local leftHorizontal = pos.x <= origin.x + BattleConfig.SPACE_AIRWALL
    local rightHorizontal = pos.x >= origin.x + size.width - BattleConfig.SPACE_AIRWALL
    return leftHorizontal, rightHorizontal, bottomVertical, topVertical
end

function battleController.getMaxComboNum()
    return statistics.maxComboNum
end
--???????????????
function battleController.getComboNum()
    return statistics.combo
end



function battleController.exitBattle()
    this.pause()
    this.endFight()
    this.clear()
    AwakeMgr.clean()
    musicMgr.clean()
    -- BattleMgr:removeScheduleAndActionMgr( )
    if not this.isChangeDungeon then 
        LockStep.clean()
        ResLoader.clean()
    end

    EventTrigger:clearTriggers()
    BattleTimerManager.model:reset()
    this.captain = nil
    this.stopSynchronizeTimer()
    this.removeEvents()
end

--?????????????????????????????????
function battleController.checkAndCreateSkillEx()
    local data = BattleDataMgr:getLevelCfg()
  --??????
    if data.dungeonType == EC_FBLevelType.SKYLADDER then
        local usingCards = SkyLadderDataMgr:getUsingCards()
        for k,v in ipairs(usingCards) do
            local cardInfo = SkyLadderDataMgr:getOwnedCardByID(v)
            local cardCfg  = SkyLadderDataMgr:getRankMatchCardCfg(v)
            if cardCfg and cardInfo then
                if cardCfg.abilityType == 2 then --????????????
                    local buffCid = cardCfg.skill[cardInfo.cardLv]
                    if buffCid then
                        local buffCfg = TabDataMgr:getData("RankMatchBuff", buffCid)
                        this.skillEx = SkillEx:new(cardCfg,clone(buffCfg.buffId))
                    end

                    return
                end
            end
        end
    end
end

--?????????buff??????
function battleController.getExtBuffList(hero)
    local bufferIds = {}
    local data = BattleDataMgr:getLevelCfg()

	--????????????????????????buff
     if data.dungeonType == EC_FBLevelType.MONSTER_TRIAL then
		local buff = FubenDataMgr:getMonsterBuffByHeroId(hero.data.id)
		table.insert(bufferIds, buff)
     end

    --??????buff
    local actBuff = BattleDataMgr:getServerData().actBuffId or {}
    for i,v in ipairs(actBuff) do
        table.insert(bufferIds, v)  
    end

    --??????plus
    if data.dungeonType == EC_FBLevelType.ENDLESS_PLUSS then
        local buffCid = FubenEndlessPlusDataMgr:getSelectBuffCid()        
        if buffCid then
            local buffCfg = TabDataMgr:getData("FloorBuff", buffCid)
            if buffCfg and buffCfg.limitTargetId then
                for i,v in ipairs(buffCfg.limitTargetId) do
                    if v == hero.data.id then
                        table.insertTo(bufferIds, buffCfg.buffId)
                    end
                end          
            end
        end
    end

    
    -- ??????itemBuff(???????????????????????????)
    if data.dungeonType == EC_FBLevelType.SNOW_FESTIVAL then
        local itemBuff = BattleDataMgr:getServerData().itemBuff or {}
        for i,v in ipairs(itemBuff) do
            local playerPid = v.pid
            local itemBuffIds = v.buffId or {}
            for i, itemBuffId in ipairs(itemBuffIds) do
                if itemBuffId ~= 0 then
                    local buffIds = TabDataMgr:getData("ItemOfBattleBuff", itemBuffId).buffIds
                    for j, _buffId in ipairs(buffIds) do
                        local buffCfg = TabDataMgr:getData("CombatModuleBuffMgr", _buffId)
                        local targetType = buffCfg.targetType

                        local isReachTrue = false
                        if targetType == EC_ItemBuffTargetType.SELF then
                            if hero.data.pid == playerPid then
                                isReachTrue = true
                            end
                        elseif targetType == EC_ItemBuffTargetType.ALL_TEAM then
                            if hero:getCampType() == eCampType.Hero then
                                isReachTrue = true
                            end
                        elseif targetType == EC_ItemBuffTargetType.ALL_MONSTER then
                            if hero:getCampType() ~= eCampType.Hero then
                                isReachTrue = true
                            end
                        elseif targetType == EC_ItemBuffTargetType.ALL_SPIRIT then
                            isReachTrue = true
                        elseif targetType == EC_ItemBuffTargetType.ALL_ELITE_MONSTER then
                            if hero:getCampType() == eCampType.Monster and hero:getMonsterType() == eMonsterType.MT_BOSS then
                                isReachTrue = true
                            end
                        end

                        if isReachTrue then
                            table.insertTo(bufferIds, buffCfg.buffId)
                        end
                    end
                end
            end
        end 
    end

    return bufferIds
end

function battleController.getAdditionBuff(hero)
    local bufferIds = {}
    local data = BattleDataMgr:getLevelCfg()
    --??????????????????buff
    local addtionMap = TabDataMgr:getData("Addition")
    for k,cfg in pairs(addtionMap) do
        if cfg.type < 1000 then
            local flag = true
            for ptype,value in pairs(cfg.condition) do
                if ptype == 1 then
                    local count = 0
                    for i,equipId in ipairs(value.equipList) do
                        if EquipmentDataMgr:checkIsusing(hero.data.id,equipId) then
                            count = count + 1
                        end
                    end
                    if count ~= value.equipNum then
                        flag = false
                    end
                elseif ptype == 2 then
                    local heros = BattleDataMgr:getBattleData().heros
                    local subFlag = false
                    local count = 0
                    for i,id in ipairs(value.heroFightList) do
                        for j,heroData in ipairs(heros) do
                            if heroData.id == id then
                                count = count + 1
                            end
                        end
                    end
                    if count ~= value.heroFightNum then
                        flag = false
                    end
                elseif ptype == 3 then
                    local heros = BattleDataMgr:getBattleData().heros
                    local subFlag = false
                    for i,id in ipairs(value) do
                        for j,heroData in ipairs(heros) do
                            if heroData.roleType == eRoleType.Assist and heroData.id == id then
                                subFlag = true
                            end
                        end
                    end
                    if not subFlag then
                        flag = false
                    end
                elseif ptype == 4 then
                    if TitleDataMgr:getEquipedTitleId() ~= value then
                        flag = false
                    end
                elseif ptype == 5 then
                    local havecard = tobool(RechargeDataMgr:getMonthCardLeftTime() > 0)
                    flag = havecard
                elseif ptype == 6 then
                    flag = MainPlayer:getPlayerLv() >= value
                elseif ptype == 7 then
                    for i,medalId in ipairs(value) do
                        local info = MedalDataMgr:getMedelInfoById(medalId)
                        if not info then
                            flag = false
                        end
                    end
                elseif ptype == 8 then
                    for i,taskId in ipairs(value) do
                        local taskInfo = TaskDataMgr:getTaskInfo(taskId)
                        if taskInfo and taskInfo.status == EC_TaskStatus.ING then
                            flag = false
                        end
                    end
                elseif ptype == 9 then
                    for i,levelCid in ipairs(value) do
                        if not FubenDataMgr:isPassPlotLevel(levelCid) then
                            flag = false
                        end
                    end
                elseif ptype == 10 then
                    flag = false
                    for i,levelType in ipairs(value) do
                        local levelCfg = BattleDataMgr:getLevelCfg()
                        if levelCfg.dungeonType == levelType then
                            flag = true
                        end
                    end
                elseif ptype == 11 then
                    flag = false
                    for i,levelId in ipairs(value) do
                        local levelCfg = BattleDataMgr:getLevelCfg()
                        if levelCfg.id == levelId then
                            flag = true
                        end
                    end
                end
            end
            if flag then
                local buffData = cfg.effect[3] or {}
                if buffData.buffid then
                    for i,buffid in ipairs(buffData.buffid) do
                        if buffData.heroid then
                            if table.indexOf(buffData.heroid,hero.data.id) ~= -1 then
                                table.insert(bufferIds, buffid)  
                            end
                        elseif buffData.campid then
                            if table.indexOf(buffData.campid,hero:getCamp()) ~= -1 then
                                table.insert(bufferIds, buffid)  
                            end
                        end
                    end
                end
            end
        end
    end
    return bufferIds
end

--??????????????????buffer
function battleController.getPointBuffer(targetType)
    local bufferIds = {}
    local data = BattleDataMgr:getLevelCfg()
    for index , _targetType in ipairs(data.limitTargetType) do
        if _targetType == targetType then
            table.insert(bufferIds,data.limitAttributes[index])
        end
    end

    -- ??????????????????buff
    local endlessBuff = BattleDataMgr:getRacingEndlessBuff()
    for i, v in ipairs(endlessBuff) do
        local buffCfg = TabDataMgr:getData("EndlessBuff", v)
        if buffCfg.limitTargetType == targetType then
            table.insertTo(bufferIds, buffCfg.buffId)
        end
    end

    --?????????buff
    if data.dungeonType == EC_FBLevelType.KABALATREE then
        local kabalaBuffs = KabalaTreeDataMgr:getKabalaBuffs()
        for k,v in ipairs(kabalaBuffs) do
            local buffCfg = TabDataMgr:getData("Kabalabuff", v.buffCid)
            if buffCfg.limitTargetType == targetType then
                if buffCfg.timerType == 2 and buffCfg.timerTypeParam - v.useCount > 0 then
                    table.insertTo(bufferIds, buffCfg.buffID)
                elseif buffCfg.timerType == 1 then
                    table.insertTo(bufferIds, buffCfg.buffID)
                end
            end
        end
    end
	--????????????
	if data.dungeonType == EC_FBLevelType.MONSTER_TRIAL then
		local buffCfgList = FubenDataMgr:getMonsterTrialBuffListByLvId(data.id)
        for k, v in ipairs(buffCfgList) do
            if v.limitTargetType and v.limitTargetType[1] == targetType then
                table.insert(bufferIds, v.affixId)
            end
        end
	end

    --??????
    if data.dungeonType == EC_FBLevelType.SKYLADDER then
        local skyLadderbuff = SkyLadderDataMgr:getSkyLadderBuff()
        for k,v in ipairs(skyLadderbuff) do
            local buffCfg = TabDataMgr:getData("RankMatchBuff", v)
            if buffCfg.limitTargetType == targetType then
                table.insertTo(bufferIds, buffCfg.buffId)
            end
        end
    end

    --??????plus
    if data.dungeonType == EC_FBLevelType.ENDLESS_PLUSS then
        --local endlessPlusbuff = FubenEndlessPlusDataMgr:getBuff(data.id)
        --for k,v in ipairs(endlessPlusbuff) do
        --    local buffCfg = TabDataMgr:getData("FloorBuff", v)
        --    if buffCfg.limitTargetType == targetType then
        --        table.insertTo(bufferIds, buffCfg.buffId)
        --    end
        --end

        local buffCid = FubenEndlessPlusDataMgr:getSelectBuffCid()        
        if buffCid then
            local buffCfg = TabDataMgr:getData("FloorBuff", buffCid)
            if buffCfg.limitTargetType == targetType then                
               table.insertTo(bufferIds, buffCfg.buffId)
            end
        end

    end

    --?????????Buff
    if data.dungeonType == EC_FBLevelType.HWX_TOWER then

        ---??????buff
        local activeBuff_ = LinkageHwxDataMgr:getActiveBuffInfo()
        for k,v in pairs(activeBuff_) do
            local buffCfg = LinkageHwxDataMgr:getHwxBuffManageCfg(v)
            if buffCfg and buffCfg.limitTargetType == targetType then
                table.insertTo(bufferIds, buffCfg.buffId)
            end
        end

        ---??????buff
        local towerInfo = LinkageHwxDataMgr:getTowerInfo()
        if towerInfo  then
            for k,v in ipairs(towerInfo.roundBuff) do
                local buffCfg = LinkageHwxDataMgr:getHwxBuffManageCfg(v)
                if buffCfg and buffCfg.limitTargetType == targetType then
                    table.insertTo(bufferIds, buffCfg.buffId)
                end
            end
        end
    end

    local halloweenBuffs = ActivityDataMgr2:getHalloweenBuffIsActivity(data.id)
    for k,v in pairs(halloweenBuffs) do
        local buffCfg = TabDataMgr:getData("HalloweenBuff", v)
        if buffCfg.limitTargetType == targetType then
            table.insertTo(bufferIds, buffCfg.buffId)
        end
    end

    --????????????????????????
    if this.isZLJH() then
        local menbers = #this.data.heros
        local buffers = LeagueDataMgr:getBuffers(menbers)
        for i, v in ipairs(buffers) do
            local buffCfg = TabDataMgr:getData("HuntingBuff", v)
            if buffCfg.limitTargetType == targetType then
                table.insertTo(bufferIds, buffCfg.buffId)
            end
        end
    end
    
    --???????????????
    if this.isLockStep() and TeamFightDataMgr.nTeamType == 9 then 
        local cfg = TeamFightDataMgr:getBattleCfg()
        local unableIds = ActivityDataMgr2:getHalloweenUnableSuperBuffIds()
        local realIds = {}
        for i,v in ipairs(cfg.buffID) do
            if table.indexOf(unableIds,v) == -1 then
                table.insert(realIds,v)
            end
        end
        for k,v in pairs(realIds) do
            local buffCfg = TabDataMgr:getData("HalloweenBuff", v)
            if buffCfg.limitTargetType == targetType then
                table.insertTo(bufferIds, buffCfg.buffId)
            end
        end
    end
    return bufferIds
end

function battleController.useCustomAttrModle(hero)
    local data = BattleDataMgr:getLevelCfg()
    if data.dungeonType == EC_FBLevelType.NIANSHOU then
        return true
    end
    return false
end

function battleController.isHurtDataVaild(hurtData)
    local data = BattleDataMgr:getLevelCfg()
    if hurtData.dungeonType and hurtData.dungeonType == data.dungeonType then
        return true
    end
    return false
end

function battleController.getCustomSkills(skills, hero)
    local data = BattleDataMgr:getLevelCfg()
    if data.dungeonType == EC_FBLevelType.NIANSHOU then
        if hero:getCampType() == eCampType.Hero then
            local realSkills = {}
            for k,id in pairs(skills) do
                local skillCfg = BattleDataMgr:getSkillData(id)
                if skillCfg.skillType  ==  eSkillType.DODGE 
                    or skillCfg.skillType  ==  eSkillType.DOWN
                    or skillCfg.skillType  ==  eSkillType.STANDUP then
                    table.insert(realSkills,id)
                end
            end
            local cfg = TeamFightDataMgr:getBattleCfg()
            if cfg and cfg.fixSkills then
                for i,id in ipairs(cfg.fixSkills) do
                    table.insert(realSkills,id)
                end
            end
            local itemBuff = BattleDataMgr:getServerData().itemBuff or {}
            for i,v in ipairs(itemBuff) do
                if v.pid == hero.data.pid then
                    local itemBuffIds = v.buffId or {}
                    for i, itemBuffId in ipairs(itemBuffIds) do
                        local itemBuffCfg = TabDataMgr:getData("ItemOfBattleBuff", itemBuffId)
                        if itemBuffCfg.skillId > 0  then
                            table.insert(realSkills,itemBuffCfg.skillId)
                        end
                    end
                end
            end
            return realSkills
        end
    end
    return skills
end

function battleController.initEndless()
    statistics.resetEndless()
end
--??????????????????
function battleController.getBlastLevel()
    return SettingDataMgr:getBattleBlurVal()
end

--??????????????????
function battleController.getBlurLevel()
    return SettingDataMgr:getBattleBlurVal()
end

--????????????????????????CD
function battleController.setSwitchCaptainGlobalCD()
    local heros = this.team:getMenbers(eCampType.Hero) --????????????????????????
    for k , hero in ipairs(heros) do
        if hero.countDown then
            hero.countDown:addGlobalCD(1500)
        end
    end
end

--??????
function battleController.findPath(hero,postion)
    local start = hero:getPosition()
    -- _print("_findPath:",start ,postion)
    return levelParse:find(start, postion)
end

--???????????????????????????
function battleController.canMove(x,y)
    return levelParse:canMove(x,y)
end
--??????????????????????????????
function battleController.randomPos(rect)
    return levelParse:randomPos(rect)
end

--????????????
function battleController.activateAssit()
    local captain = this.getCaptain()
    local hero = this.team:getAssist()
    if hero and hero:isAlive() and not hero:isBattle() then
        hero:addToBattle()
        local tarPos = captain:getPosition()
        hero:setPosition3D(tarPos.x,tarPos.y,tarPos.y)
        -- hero:setDir(dir)
        hero.actor:show()
        hero.actor:setOpacity(255)
        hero.actor.skeletonNode:show()
        hero:castByType(eSkillType.ENTER)
        --????????????
        EventMgr:dispatchEvent(eEvent.EVENT_SHOW_ASSIT,hero)
    end
end

--????????????
function battleController.preCastMixSkill(campType,skillIds,moveDistance)
    local heros = this.team:getMenbers(campType)
    for k,hero in pairs(heros) do
        hero:preCastSkill(moveDistance,skillIds)
    end
end

local eSummonType =
{
    RandomPos   = "RandomPos",
    OrderPoint  = "OrderPoint",
    RandomPoint = "RandomPoint"
}
--???????????????
function battleController.onCreateObstacle(data,params)
    local points = {}
    local obstacleIds = {}
    if data.DestroiableID and #data.DestroiableID > 0 then
        obstacleIds = string.split(data.DestroiableID, ",")
    end
    local summonType  = data.SummonType

    dump(data)
    dump(params)
    dump(obstacleIds)

    if summonType == eSummonType.RandomPos then --????????????
        points = {}
        for index = 1 , #obstacleIds do
            points[index] = levelParse:randomBonePos() --??????????????????????????????
        end
    elseif summonType == eSummonType.OrderPoint then
        --??????????????????
        points = params[1]
    elseif summonType == eSummonType.RandomPoint then
        points = BattleUtils.shuffle(params[1])
    end
    for index , id in ipairs(obstacleIds) do
        -- local node = ResLoader.createEffect("fight_2011",0.5)  --Node:create()
        -- node:play("born", 1)
        -- node:setPosition(points[index])

        local data     = TabDataMgr:getData("MapBarrier",tonumber(id))
        if not data then
            Box("ASDFSD::"..tostring(id))
        end
        local obstacle = GameObject.createObstacle(data)
        obstacle:setPosition(points[index])
        obstacle:active()
    end
end


--????????????????????????
function battleController.isNeedVerifyHurt( )
    return this.bNeedVerifyHurt
end

--??????????????????
function battleController.sendVerifyHurt(data) 
    -- dump(data)   
    TFDirector:send(c2s.DUNGEON_REQ_VERIFY_HURT, data)
end

function battleController.sendVerifyFightResult(isWin)
    if not isWin then
        return
    end
    if victoryDecide.nViewType ~= EC_LevelPassCond.SURVIVAL then
        local data = {}
        data[1] ={}
        for k,v in pairs(statistics.skillCountTab) do
            table.insert(data[1],{k,v})
        end
        data[2] = {}--??????
        for k ,v in pairs(statistics.monsterInfos) do
            for level ,num in pairs(v) do
                table.insert(data[2],{k,level ,num})
            end
        end  
   
        if this.isDuelMode() then
            data[3] = (statistics.monsterLoseHp*2)   --?????????????????????
            data[4] = statistics.hitIimes  --'int64':hurtCount [???????????????]
            data[5] = (statistics.hitValue*2) --'int64':hurt  [?????????]
        else
            data[3] = statistics.monsterLoseHp   --?????????????????????
            data[4] = statistics.hitIimes  --'int64':hurtCount [???????????????]
            data[5] = statistics.hitValue  --'int64':hurt  [?????????]
        end
        -- dump(data)
        -- Box("????????????????????????")
        TFDirector:send(c2s.DUNGEON_REQ_VERIFY_FIGHT_RESULT, data)
    end
end

function battleController.isShowAttackEffect(hero)
    if hero:getRoleType() == eRoleType.Team then 
        if battleController.getCaptain() ~= hero then
            return SettingDataMgr:getAttactEffectVal()
        end
    end
    return true
end

--????????????????????????
function battleController.isCreateEffect(hero)
    -- if hero:getRoleType() == eRoleType.Team then 
    --     if battleController.getCaptain() ~= hero then
    --         return SettingDataMgr:getAttactEffectVal()
    --     end
    -- end
    return true
end

function battleController.isShowFixHurt()
    if this.data and this.data.teamType ~= 5 then --??????????????????
        return not SettingDataMgr:getAttactEffectVal()
    end
end

--AI????????????
function battleController.checkAISyncHost()
    if this.isZLJH() then
        return true
    end
    local hostPid = LockStep.getAISyncHostPid()
    return tonumber(hostPid) == MainPlayer:getPlayerId()
end

function battleController.syncAIStepData(markID, lastIdx, cruIdx, params)
    if this.isLockStep() then
        LockStep.syncAIStepData(markID, lastIdx, cruIdx, params)
    end
end
--AI??????????????????



--??????????????????
function battleController.setDamageData(srcHero, hurtValue, hurtData, hurtType, buffId)
    if not BattleConfig.DAMAGE_TEST then
        return
    end
    local cid
    if srcHero:getCampType() == eCampType.Hero then
        cid = srcHero:getData().id
    elseif srcHero:getCampType() == eCampType.Call then
        local host = srcHero:getHost()
        if host and host:getCampType() == eCampType.Hero then
            cid = host:getData().id
        end
    end
    if not cid then
        return
    end
    this.damageData[cid] = this.damageData[cid] or {}

    local hurtType1 = battleController.getDamageHurtType(hurtType)
    this.damageData[cid][hurtType1] = this.damageData[cid][hurtType1] or {}
    this.damageData[cid][hurtType1].value = this.damageData[cid][hurtType1].value and (this.damageData[cid][hurtType1].value + hurtValue) or hurtValue
    if hurtValue > 0 then
        this.damageData[cid][hurtType1].times = this.damageData[cid][hurtType1].times and (this.damageData[cid][hurtType1].times + 1) or 1
    end
    local damageAttr = battleController.getDamageAttrType(hurtData)
    this.damageData[cid][damageAttr] = this.damageData[cid][damageAttr] or {}
    this.damageData[cid][damageAttr].value = this.damageData[cid][damageAttr].value and (this.damageData[cid][damageAttr].value + hurtValue) or hurtValue
    if hurtValue > 0 then
        this.damageData[cid][damageAttr].times = this.damageData[cid][damageAttr].times and (this.damageData[cid][damageAttr].times + 1) or 1
    end

    this.damageData[cid][100] = this.damageData[cid][100] and (this.damageData[cid][100] + hurtValue) or hurtValue

    local data = this.damageData[cid][99] or {}
    local damageData
    if hurtData then
        damageData = data[hurtData.damageType] or {}
        local subData = damageData[hurtData.id] or {}
        subData.value = subData.value and (subData.value + hurtValue) or hurtValue
        if hurtValue > 0 then
            subData.times = subData.times and (subData.times + 1) or 1
        end
        subData.hurtData = subData.hurtData or {}
        local hType = battleController.getDamageHurtType(hurtType, true)
        subData.hurtData[hType] = subData.hurtData[hType] or {}
        subData.hurtData[hType].value = subData.hurtData[hType].value and (subData.hurtData[hType].value + hurtValue) or hurtValue
        subData.hurtData[hType].times = subData.hurtData[hType].times and (subData.hurtData[hType].times + 1) or 1
        damageData[hurtData.id] = subData
        data[hurtData.damageType] = damageData
    else
        damageData = data[888] or {}
        buffId = buffId or 99999999
        local subData = damageData[buffId] or {}
        subData.value = subData.value and (subData.value + hurtValue) or hurtValue
        subData.times = subData.times and (subData.times + 1) or 1
        subData.hurtData = subData.hurtData or {}
        local hType = battleController.getDamageHurtType(nil, true)
        subData.hurtData[hType] = subData.hurtData[hType] or {}
        subData.hurtData[hType].value = subData.hurtData[hType].value and (subData.hurtData[hType].value + hurtValue) or hurtValue
        subData.hurtData[hType].times = subData.hurtData[hType].times and (subData.hurtData[hType].times + 1) or 1
        damageData[buffId] = subData
        data[888] = damageData
    end

    this.damageData[cid][99] = data
end

function battleController.getDamageAttrType(hurtData)
    if hurtData then
        if hurtData.damageAttr == 1 then
            return 1
        else
            return 2
        end        
    end
    return 3
end

function battleController.getDamageHurtType(hurtType, checkDodge)
    if hurtType then
        if hurtType == eHurtType.CRIT then
            return 12
        elseif hurtType == eHurtType.PREICE then
            return 13
        elseif hurtType == eHurtType.CRIT_PREICE then
            return 14
        end
        if checkDodge and (hurtType == eHurtType.DODGE or hurtType == eHurtType.PARRY) then
            return 15
        end
    end
    return 11
end

function battleController.getDamageData()
    return this.damageData
end

function battleController.clearDamageData()
    this.damageData = {}
end

function battleController.onAirPointChange()
    if this.isRun() then
        local heroList = this.getTeam():getMenbers(eCampType.Call)
        for i, hero in ipairs(heroList) do
            local host = hero:getHost()
            if host then
                if host.data and host.data.follow and host:isAlive() then
                    local curPos = hero:getPosition()
                    if not this.canMove(curPos.x,curPos.y) then
                        local hostPos = host:getPosition()
                        if hostPos and hostPos.x then
                            hero:moveToPosAction(hostPos)
                        end
                    end
                end
            end
        end
    end
end

--?????????????????????????????????
TFDirector:addMEGlobalListener("applicationDidEnterBackground", function()
    EventMgr:dispatchEvent("applicationDidEnterBackground")
end)
--????????????
return battleController
