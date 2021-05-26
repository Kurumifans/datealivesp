--[[
    @desc：PlayerRegressTaskView
    @date: 2021-05-18 16:30:56
]]

local PlayerRegressTaskView = class("PlayerRegressTaskView",BaseLayer)
local AwardsPosList = {
    [1] = {{0, 0, 1.0}},
    [2] = {{-50, 0, 0.8}, {50, 0, 0.8}},
    [3] = {{-50, 50, 0.8}, {50, 50, 0.8}, {0, -50, 0.8}},
    [4] = {{-50, 50, 0.8}, {50, 50, 0.8}, {-50, -50, 0.8}, {50, -50, 0.8}}
}

function PlayerRegressTaskView:initData(activityId)
    self.activityId_ = activityId
    self.activityInfo_ = ActivityDataMgr2:getActivityInfo(self.activityId_)
    self.expItemId = self.activityInfo_.extendData.expItem
    self.expMax = self.activityInfo_.extendData.expMax
    dump(self.activityInfo_)
    self.progressItems = {}
end

function PlayerRegressTaskView:ctor(...)
    self.super.ctor(self)
    self:initData(...)
    self:init("lua.uiconfig.activity.playerRegressTaskView")
end

function PlayerRegressTaskView:initUI(ui)
    self.super.initUI(self,ui)

    local year1, month1, day1 = Utils:getDate(self.activityInfo_.showStartTime or 0)
    local year2, month2, day2 = Utils:getDate(self.activityInfo_.endTime or 0)
    self._ui.act_time:setTextById(63917, year1, month1, day1, year2, month2, day2)

    self.listView = UIListView:create(self._ui.listView)
    self.listView:setItemModel(self._ui.panel_item)
    self.listView:setItemsMargin(10)

    self:refreshListView()
    self:refreshTopProgress()
end

function PlayerRegressTaskView:registerEvents()
    EventMgr:addEventListener(self, EV_ACTIVITY_SUBMIT_SUCCESS, handler(self.onSubmitSuccessEvent, self))
    EventMgr:addEventListener(self, EV_BAG_ITEM_UPDATE, handler(self.refreshTopProgress, self))
end

function PlayerRegressTaskView:getItemIdsByType(_type)
    local itemIds = {}
    for i, _id in ipairs(ActivityDataMgr2:getItems(self.activityId_)) do
        local _itemInfo = ActivityDataMgr2:getItemInfo(self.activityInfo_.activityType, _id)
        if _itemInfo.extendData.taskType == _type then
            table.insert(itemIds, _id)
        end
    end
    return itemIds
end

function PlayerRegressTaskView:refreshListView()
    local itemIds = self:getItemIdsByType(2)
    self.listView:AsyncUpdateItem(itemIds, 
        function()
            local item = self._ui.panel_item:clone()
            item.awards = {}
            item.panel_gifts = TFDirector:getChildByPath(item, "panel_gifts")
            item.Label_name = TFDirector:getChildByPath(item, "Label_name")
            item.btn_go = TFDirector:getChildByPath(item, "btn_go")
            item.btn_getReward = TFDirector:getChildByPath(item, "btn_getReward")
            item.img_hadGetted = TFDirector:getChildByPath(item, "img_hadGetted")
            item.lab_desc = TFDirector:getChildByPath(item, "lab_desc")
            item.lab_specialId = TFDirector:getChildByPath(item, "lab_specialId")
            return item
        end,

        function(item, itemId, idx)
            local itemInfo = ActivityDataMgr2:getItemInfo(self.activityInfo_.activityType, itemId)
            local status = ActivityDataMgr2:getProgressInfo(self.activityInfo_.activityType, itemId).status

            item.Label_name:setText(itemInfo.extendData.taskTitle)
            item.lab_desc:setText(itemInfo.extendData.des2)
            item.btn_go:setVisible(status == EC_TaskStatus.ING and itemInfo.extendData.jumpInterface)
            item.btn_getReward:setVisible(status == EC_TaskStatus.GET)
            item.img_hadGetted:setVisible(status == EC_TaskStatus.GETED)

            item.btn_getReward:onClick(function()
                ActivityDataMgr2:send_ACTIVITY_NEW_SUBMIT_ACTIVITY(self.activityId_, itemId)
            end)
            item.btn_go:onClick(function()
                local param = itemInfo.extendData.parameter or {}
                FunctionDataMgr:enterByFuncId(itemInfo.extendData.jumpInterface, unpack(param))
            end)

            local awardDatas = {}
            local specialExpNum = nil
            for _id, _num in pairs(itemInfo.reward) do
                if _id == self.expItemId then
                    specialExpNum = _num
                else
                    table.insert(awardDatas, {id = _id, num = _num})
                end
            end

            item.lab_specialId:setVisible(nil ~= specialExpNum)
            if specialExpNum then
                item.lab_specialId:setText(specialExpNum)
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

function PlayerRegressTaskView:refreshTopProgress()
    local itemIds = self:getItemIdsByType(1)
    local gap = #itemIds - #self.progressItems 
    for i = 1, math.abs(gap) do
        if gap > 0 then
            local item = self._ui.panel_progressItem:clone()
            item.img_getted = TFDirector:getChildByPath(item, "img_getted")
            item.img_canGet = TFDirector:getChildByPath(item, "img_canGet")
            item.img_ing = TFDirector:getChildByPath(item, "img_ing")
            item.lab_needNum = TFDirector:getChildByPath(item, "lab_needNum")
            item:AddTo(self._ui.panel_topProgress, 1)
            table.insert(self.progressItems, item)
        else
            self.progressItems[1]:removeFromParent()
            table.remove(self.progressItems, 1)
        end
    end

    local zoPos = self._ui.img_progressBg:getPosition()
    local sumWidth = self._ui.img_progressBg:getContentSize().width
    local perWidth = sumWidth / self.expMax
    for j, item in ipairs(self.progressItems) do
        local itemInfo = ActivityDataMgr2:getItemInfo(self.activityInfo_.activityType, itemIds[j])
        local status = ActivityDataMgr2:getProgressInfo(self.activityInfo_.activityType, itemIds[j]).status
        item.img_getted:setVisible(status == EC_TaskStatus.GETED)
        item.img_canGet:setVisible(status == EC_TaskStatus.GET)
        item.img_ing:setVisible(status == EC_TaskStatus.ING)

        item:setTouchEnabled(true)
        item:onClick(function()
            if status == EC_TaskStatus.GET then
                ActivityDataMgr2:send_ACTIVITY_NEW_SUBMIT_ACTIVITY(self.activityId_, itemIds[j])
            else
                local awards = {}
                for _id, _num in pairs(itemInfo.reward) do
                    table.insert(awards, {id = _id, num = _num})
                end
                Utils:previewReward(nil, awards, 0.6)
            end
        end)
        item.lab_needNum:setText(itemInfo.extendData.taskExp)

        local _x = zoPos.x + itemInfo.extendData.taskExp * perWidth
        local _y = zoPos.y 
        item:setPosition(ccp(_x, _y))
    end
    self._ui.bar_progress:setPercent((GoodsDataMgr:getItemCount(self.expItemId) / self.expMax) * 100)
    self._ui.lab_acyivityNum:setText(GoodsDataMgr:getItemCount(self.expItemId))
end

function PlayerRegressTaskView:onSubmitSuccessEvent(activitId, itemId, reward)
    if self.activityId_ == activitId then
        Utils:showReward(reward)
    end
end

function PlayerRegressTaskView:onUpdateProgressEvent()
    self:refreshListView()
    self:refreshTopProgress()
end

return PlayerRegressTaskView