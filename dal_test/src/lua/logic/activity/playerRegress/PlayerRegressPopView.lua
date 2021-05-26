
local PlayerRegressPopView = class("PlayerRegressPopView", BaseLayer)

function PlayerRegressPopView:initData(returnDay)
    self.returnDay = returnDay
end

function PlayerRegressPopView:ctor(...)
    self.super.ctor(self)
    self:showPopAnim(true)
    self:initData(...)
	self:init("lua.uiconfig.activity.playerRegressPopView")
end

function PlayerRegressPopView:initUI(ui)
    self.super.initUI(self,ui)
    
    self._ui.imgCloseState:show()
    self._ui.imgOpenState:hide()

    self._ui.txt_content:setTextById(295002, self.returnDay)
    self._ui.lab_playerName:setText(MainPlayer:getPlayerName())
    self._ui.txt_content:setLineHeight(30)
	local scrollSize = self._ui.scroll_view:getContentSize()
	local txtHeight = self._ui.txt_content:getContentSize().height
	if txtHeight > scrollSize.height then
		scrollSize.height = txtHeight
	end
	self._ui.scroll_view:setInnerContainerSize(scrollSize)
end

function PlayerRegressPopView:showAnim()
	self._ui.panel_content:show()
	self._ui.panel_content:setOpacity(0)
	self._ui.panel_content:runAction(CCFadeIn:create(1))
end

function PlayerRegressPopView:registerEvents()
    self._ui.btn_open:onClick(function(sender)
        self._ui.imgCloseState:hide()
        self._ui.imgOpenState:show()
        self._ui.imgOpenState:setOpacity(0)
        local _pos = self._ui.imgOpenState:getPosition()
        self._ui.imgOpenState:setPositionY(_pos.y + 400)
        self._ui.imgOpenState:runAction(Spawn:create({
            CCFadeIn:create(1),
            CCMoveTo:create(0.5, _pos)
        }))
    end)

	self._ui.close_btn:onClick(function()
        AlertManager:closeLayer(self)
    end)

	self._ui.go_btn:onClick(function()
        Utils:openView("activity.BackPlayerView")
        AlertManager:closeLayer(self)
    end)
end

return PlayerRegressPopView