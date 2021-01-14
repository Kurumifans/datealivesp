--[[
*                       .::::.
*                     .::::::::.
*                    :::::::::::
*                 ..:::::::::::'
*              '::::::::::::'
*                .::::::::::
*           '::::::::::::::..
*                ..::::::::::::.
*              ``::::::::::::::::
*               ::::``:::::::::'        .:::.
*              ::::'   ':::::'       .::::::::.
*            .::::'      ::::     .:::::::'::::.
*           .:::'       :::::  .:::::::::' ':::::.
*          .::'        :::::.:::::::::'      ':::::.
*         .::'         ::::::::::::::'         ``::::.
*     ...:::           ::::::::::::'              ``::.
*    ```` ':.          ':::::::::'                  ::::..
*                       '.:::::'                    ':'````..
*
* 
]]
local MapUtils = import("lua.logic.osd.MapUtils")
local SingleAIBehave = class("SingleAIBehave")

function SingleAIBehave:ctor(param)
	self.tarNode = param.tarNode
	self.AIEnable = false
	self.life = param.life or -1
	self.life = self.life == 0 and -1 or self.life
	self:initData()
end

function SingleAIBehave:initData()
	self.timerhandleList = {}
	self.talkGroup = {}
end

function SingleAIBehave:setAIEnabled(isEnable)
	
	if self.AIEnable ~= isEnable then
		self.AIEnable = isEnable
		if isEnable == true then
			self:getMapInfo()
			self:runAI()
		else
			self:removeAI()
		end
	end
end

function SingleAIBehave:getSpecialEmoj()
	local specialEmojList = {"special1","special2"}
	return specialEmojList
end


function SingleAIBehave:getTalk()
	local idx = math.floor(math.random(1,#self.talkGroup))
	local talklist = self.talkGroup[idx]
	return talklist
end

function SingleAIBehave:removeAI()
	self.timerhandleList = {}
	self.tarNode:playStand()
end

function SingleAIBehave:runAI()
	self.tarNode:aiAction()
	if self.willDelete then
		self:removeAI()
		self:deleteAI()
		return
	end

	self:addAITimer(math.random(1000,2000),function()
		self:runRandomBehave()
	end)
end
function SingleAIBehave:getBehaveList()
	--临时行为列表
	local behaveList = {
		"freemove",
		"idle",
	}
	return behaveList
end
function SingleAIBehave:reportBornPos(pos)
	self.bornPos = pos
end
function SingleAIBehave:getMapInfo()
	self.mapInfo = MapUtils:getMapParse()
end

function SingleAIBehave:runRandomBehave()
	local behavelist = self:getBehaveList()
	local idx = math.random(1,#behavelist)
	local mbehave = behavelist[idx]
	print(mbehave)
	if mbehave == "freemove" then
		self:moveToPos()
	elseif mbehave == "freetalk" then
		self:showTalk()
	elseif mbehave == "idle" then
		self.tarNode:playStand()
		self:addAITimer(math.random(1000,3000),function()
			self:onBehaveComplete()
		end)
	elseif mbehave == "randomEmoj" then
		self:randomEmoj()
	else

	end 
end

function SingleAIBehave:randomEmoj()
	if not self.tarNode.skeletonNode then return end
	local emojlist = self:getSpecialEmoj()
	local emojidx = math.random(1,#emojlist)
	local emoj = emojlist[emojidx]
	self.tarNode.skeletonNode:addMEListener(TFARMATURE_COMPLETE,function(sklete)
		self.tarNode.skeletonNode:removeMEListener(TFARMATURE_COMPLETE)
		self:onBehaveComplete()
	end)
	self.tarNode:playAni(emoj,false)
end

function SingleAIBehave:moveToPos(tarpos,callback,endDir)
	
	local curpos = self.tarNode:getPosition()
	if tarpos == nil then
    	tarpos = self.mapInfo:getRandomDP(curpos,200,200)
    end
    if tarpos == nil then
        print("没有目的地")
        if callback then
        	callback()
        else
        	self:addAITimer(2000,function()
        		self:onBehaveComplete()
        	end)
        end
        return nil
    end
	if callback then
		if not self.tarNode:moveTo(tarpos,callback) then
			callback()
		end
	else
		if not self.tarNode:moveTo(tarpos,handler(self.onMoveComplete,self)) then
			self:onMoveComplete()
		end
	end
	
end

function SingleAIBehave:onMoveComplete()
	self:addAITimer(500,function()
		self:onBehaveComplete()
	end)
end

function SingleAIBehave:onBehaveComplete()
	self:removeAI()
	if self.AIEnable == true then
		self:runAI()
	end
end

function SingleAIBehave:showTalk()
	local talklist = self:getTalk()
	if self.tarNode.isTalking or not talklist then
		self:onBehaveComplete()
		do return end
	end
	local talknum = 1
	local function popTalk(talkId)
		local talknode = self.tarNode:aiTalk(talkId)
		talknode:setOpacity(0)
	    local actionArr = {FadeIn:create(0.5),DelayTime:create(5),FadeOut:create(0.5),CallFunc:create(function()
	    	self:addAITimer(500,function()
	    		talknum = talknum + 1
	    		if talklist[talknum] then
	    			popTalk(talklist[talknum])
	    		else
					self.tarNode.isTalking = false
					self:onBehaveComplete()
				end
			end)
			talknode:hide()
	    end)}
		talknode:runAction(Sequence:create(actionArr))
	end
	popTalk(talklist[talknum])
end

function SingleAIBehave:addAITimer(timelong,callback)
	local timerid = 10000
	while self.timerhandleList[timerid] do
		timerid = timerid + 1
	end
	local tmtimer = {needtime = timelong,callback = callback,curtime = 0}
	self.timerhandleList[timerid] = tmtimer
end

function SingleAIBehave:onRoleClicked()
	
end

function SingleAIBehave:deleteAI( ... )
	-- body
	if self.tarNode.aiDeleteCallBack then
		self.tarNode:aiDeleteCallBack()
		return
	end
end

function SingleAIBehave:update(dt)
	self.enableLife = self.enableLife or 0
	self.enableLife = self.enableLife + (dt)

	if self.life ~= -1 and self.life <= self.enableLife then
		self.willDelete = true -- ai生命周期结束预留足够时间等待其他动作完成
		self.enableLife = self.enableLife + 10
		self:addAITimer(10000,function() 
			self:runAI()
		end)
	end

	for k,v in pairs(self.timerhandleList) do
		v.curtime = v.curtime + (dt*1000)
		if v.curtime >= v.needtime then
			if v.callback then
				local tmtimer = clone(v)
				self.timerhandleList[k] = nil
				tmtimer.callback()
			end
		end
	end
end
return SingleAIBehave