--[[
    @desc：PlayerRegressLoginView
    @date: 2021-05-18 17:23:03
]]

local PlayerRegressLoginView = class("PlayerRegressLoginView",BaseLayer)
local AwardsPosList = {
    [1] = {{0, 0, 1.0}},
    [2] = {{-50, 0, 0.75}, {50, 0, 0.75}},
    [3] = {{-45, 45, 0.7}, {45, 45, 0.7}, {0, -45, 0.7}},
    [4] = {{-45, 45, 0.7}, {45, 45, 0.7}, {-45, -45, 0.7}, {45, -45, 0.7}}
}

function PlayerRegressLoginView:initData(activityId)
    self.activityId_ = activityId
    self.activityInfo_ = ActivityDataMgr2:getActivityInfo(self.activityId_)
    dump(self.activityInfo_)
end

function PlayerRegressLoginView:ctor(...)
    self.super.ctor(self)
    self:initData(...)
    self:init("lua.uiconfig.activity.playerRegressLoginView")
end

function PlayerRegressLoginView:initUI(ui)
    self.super.initUI(self,ui)

    local year1, month1, day1 = Utils:getDate(self.activityInfo_.showStartTime or 0)
    local year2, month2, day2 = Utils:getDate(self.activityInfo_.endTime or 0)
    self._ui.act_time:setTextById(63917, year1, month1, day1, year2, month2, day2)

    self.gridView = UIGridView:create(self._ui.girdView)
    self.gridView:setItemModel(self._ui.panel_item)
    self.gridView:setColumn(4)
    self.gridView:setRowMargin(10)
    self.gridView:setColumnMargin(15)
    self:refreshGridView()
end


function PlayerRegressLoginView:registerEvents()
    EventMgr:addEventListener(self, EV_ACTIVITY_SUBMIT_SUCCESS, handler(self.onSubmitSuccessEvent, self))
end

function PlayerRegressLoginView:refreshGridView()
    local itemIds = ActivityDataMgr2:getItems(self.activityId_)
    self.gridView:AsyncUpdateItem(itemIds, function (item, itemId, idx)
        local itemInfo = ActivityDataMgr2:getItemInfo(self.activityInfo_.activityType, itemId)
        local status = ActivityDataMgr2:getProgressInfo(self.activityInfo_.activityType, itemId).status

        if not item.awards then
            item.awards = {}
            item.panel_gifts = TFDirector:getChildByPath(item, "panel_gifts")
            item.Label_name = TFDirector:getChildByPath(item, "Label_name")
            item.btn_getReward = TFDirector:getChildByPath(item, "btn_getReward")
            item.img_hadGetted = TFDirector:getChildByPath(item, "img_hadGetted")
            item.img_ing = TFDirector:getChildByPath(item, "img_ing")
        end


        item.Label_name:setText(itemInfo.extendData.des2)
        item.btn_getReward:setVisible(status == EC_TaskStatus.GET)
        item.img_ing:setVisible(status == EC_TaskStatus.ING)
        item.img_hadGetted:setVisible(status == EC_TaskStatus.GETED)
        if item.btn_getReward:isVisible() then
            item.btn_getReward:onClick(function()
                ActivityDataMgr2:send_ACTIVITY_NEW_SUBMIT_ACTIVITY(self.activityId_, itemId)
            end)
        end

        local awardDatas = {}
        for _id, _num in pairs(itemInfo.reward) do
            table.insert(awardDatas, {id = _id, num = _num})
        end

        local reserveNum = #AwardsPosList
        for j = 1, reserveNum do
            local awardData = awardDatas[j]
            local awardNum = #awardDatas > reserveNum and reserveNum or #awardDatas
            local awardGoods = item.awards[j]
            if awardData then
                local posData = AwardsPosList[awardNum][j]
                if not awardGoods then
                    item.awards[j] = PrefabDataMgr:getPrefab("Panel_goodsItem"):clone()
                    item.awards[j]:AddTo(item.panel_gifts)
                end
                item.awards[j]:Scale(posData[3])
                item.awards[j]:Pos(posData[1], posData[2])
                PrefabDataMgr:setInfo(item.awards[j], awardData.id, awardData.num)
                item.awards[j]:show()
            else
                if awardGoods then
                    awardGoods:hide()
                end
            end
        end 

	end)
end

function PlayerRegressLoginView:onSubmitSuccessEvent(activitId, itemId, reward)
    if self.activityId_ == activitId then
        Utils:showReward(reward)
    end
end

function PlayerRegressLoginView:onUpdateProgressEvent()
    self:refreshGridView()
end

return PlayerRegressLoginView