--[[
    @desc：PlayerRegressGiftView
    @date: 2021-05-18 17:23:33
]]

local PlayerRegressGiftView = class("PlayerRegressGiftView",BaseLayer)
local AwardsPosList = {
    [1] = {{0, 0, 1.0}},
    [2] = {{-60, 0, 0.85}, {60, 0, 0.85}},
    [3] = {{-55, 55, 0.85}, {55, 55, 0.85}, {0, -55, 0.85}},
    [4] = {{-55, 55, 0.85}, {55, 55, 0.85}, {-55, -55, 0.85}, {55, -55, 0.85}}
}

function PlayerRegressGiftView:initData(activityId)
    self.activityId_ = activityId
    self.activityInfo_ = ActivityDataMgr2:getActivityInfo(self.activityId_)
    self.rechargeGoodsIds = self.activityInfo_.extendData.showRechargeList or {}
    dump(self.activityInfo_)
end

function PlayerRegressGiftView:ctor(...)
    self.super.ctor(self)
    self:initData(...)
    self:init("lua.uiconfig.activity.playerRegressGiftView")
end

function PlayerRegressGiftView:initUI(ui)
    self.super.initUI(self,ui)

    local year1, month1, day1 = Utils:getDate(self.activityInfo_.showStartTime or 0)
    local year2, month2, day2 = Utils:getDate(self.activityInfo_.endTime or 0)
    self._ui.act_time:setTextById(63917, year1, month1, day1, year2, month2, day2)

    self.listView = UIListView:create(self._ui.listView)
    self.listView:setItemsMargin(15)

    self:updateGoodsList()
end

function PlayerRegressGiftView:registerEvents()
    EventMgr:addEventListener(self,EV_RECHARGE_UPDATE,handler(self.updateGoodsList, self))
    self._ui.btn_jump:onClick(function()
        FunctionDataMgr:jGiftPacks(1, 3)
    end)
end

function PlayerRegressGiftView:updateGoodsList()
    self.listView:AsyncUpdateItem(self.rechargeGoodsIds, 
        function()
            local item = self._ui.panel_item:clone()
            item.awards = {}
            item.panel_gifts = TFDirector:getChildByPath(item, "panel_gifts")
            item.Label_name = TFDirector:getChildByPath(item, "Label_name")
            item.btn_buy = TFDirector:getChildByPath(item, "btn_buy")
            item.Label_tips = TFDirector:getChildByPath(item, "Label_tips")
            item.Label_leftTime = TFDirector:getChildByPath(item, "Label_leftTime")
            item.Label_price = TFDirector:getChildByPath(item, "Label_price")
            item.Image_exchange = TFDirector:getChildByPath(item.Label_price, "Image_exchange")
            item.img_hadGetted = TFDirector:getChildByPath(item, "img_hadGetted")
            return item
        end,
        function(item, id, idx)
            local rechargeData = RechargeDataMgr:getGiftSingleData(id)
            if not rechargeData then
                return
            end
            item.Label_tips:setVisible(rechargeData.buyCount ~= 0)
            item.Label_leftTime:setString(rechargeData.buyCount - RechargeDataMgr:getBuyCount(rechargeData.rechargeCfg.id).."/"..rechargeData.buyCount)
            item.Label_leftTime:setVisible(rechargeData.buyCount ~= 0)
            item.Label_name:setText(rechargeData.name) 
            item.Label_price:setString("￥"..rechargeData.rechargeCfg.price)
            if rechargeData.buyType == 1 then
                local exchangeCfg = GoodsDataMgr:getItemCfg(rechargeData.exchangeCost[1].id)
                item.Image_exchange:show();
                item.Image_exchange:setTexture(exchangeCfg.icon)
                item.Image_exchange:setSize(CCSizeMake(40,40))
                item.Label_price:setString(rechargeData.exchangeCost[1].num);
            else
                item.Image_exchange:hide()
            end

            local isCanBuy = true
            if rechargeData.buyCount ~= 0 and rechargeData.buyCount - RechargeDataMgr:getBuyCount(rechargeData.rechargeCfg.id) <= 0 then
                isCanBuy = false
            end
            item.btn_buy:setGrayEnabled(not isCanBuy)
            item.btn_buy:setTouchEnabled(isCanBuy)
            item.btn_buy:onClick(function()
                if rechargeData.buyCount ~= 0 and rechargeData.buyCount - RechargeDataMgr:getBuyCount(rechargeData.rechargeCfg.id) <= 0 then
                    Utils:showTips(800117)
                    return
                end
                RechargeDataMgr:getOrderNO(rechargeData.rechargeCfg.id)
            end)

            local reserveNum = #AwardsPosList
            for j = 1, reserveNum do
                local awardData = rechargeData.item[j]
                local awardNum = #(rechargeData.item) > reserveNum and reserveNum or #(rechargeData.item)
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

        end
    )
    
end

return PlayerRegressGiftView