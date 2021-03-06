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

local AmusementPackScene = class("AmusementPackScene", BaseScene)

function AmusementPackScene:ctor(...)
    self.super.ctor(self, ...)
    
end

function AmusementPackScene:onEnter()
	self.super.onEnter(self)

	self:addView()
end

function AmusementPackScene:addView()
	self.baseView =  WorldRoomDataMgr:getCurWorldMainView()
	self:addLayer(self.baseView)
end

function AmusementPackScene:onExit()
    self.super.onExit(self)
end

return AmusementPackScene