--[[
    @desc：TaskTrainingChooseView
    @date: 2021-04-25 17:36:46
]]

local TaskTrainingChooseView = class("TaskTrainingChooseView",BaseLayer)

function TaskTrainingChooseView:initData()
    local cfg = TabDataMgr:getData("BattleMemory")
    self.cfgDic = {}
    for i, v in ipairs(cfg) do
        if not self.cfgDic[v.returnnewbleId] then
            self.cfgDic[v.returnnewbleId] = {}
        end
        if v.type == 2 then
            table.insert(self.cfgDic[v.returnnewbleId], v)
        end
    end

    for i, v in pairs(self.cfgDic) do
        table.sort(v, function(a, b)
            return a.id > b.id
        end)
    end
    local activityInfo = ActivityDataMgr2:getWarOrderAcrivityInfo()
    dump(activityInfo)
    self.costGoods = activityInfo.extendData.costitem
    self.tipsTimes = activityInfo.extendData.tipsTime
    self.dress = activityInfo.extendData.dress
end

function TaskTrainingChooseView:ctor(...)
    self.super.ctor(self)
    self:initData(...)
    self:showPopAnim(true)
    self:init("lua.uiconfig.task.taskTrainingChooseView")
end

function TaskTrainingChooseView:initUI(ui)
    self.super.initUI(self,ui)

    self.listView = UIListView:create(self._ui.ScrollView_review)
    self.listView:setItemsMargin(5)
    self.listView:removeAllItems()
    self:refreshListview()
end

function TaskTrainingChooseView:registerEvents()
    self._ui.Button_close:onClick(function()
        AlertManager:close(self)
    end)
end

function TaskTrainingChooseView:refreshListview()
    for warId, cfgs in pairs(self.cfgDic) do
        local item = self._ui.Panel_reviewItem:clone()
        local lab_titleName = item:getChildByName("lab_titleName")
        local img_icon = item:getChildByName("img_icon")
        local btn_open = item:getChildByName("btn_open")
        local lab_complate = item:getChildByName("lab_complate")
        if not item.scrollView_awards then
            item.scrollView_awards = UIListView:create(item:getChildByName("ScrollView_awards"))
            item.scrollView_awards:setItemsMargin(9)
            for i, data in ipairs(cfgs) do
                if i > 8 then   -- 策划说只取后8个
                    break
                end
                local rewardData = data.reward[1]
                local goods = PrefabDataMgr:getPrefab("Panel_goodsItem"):clone()
                PrefabDataMgr:setInfo(goods, rewardData[1], rewardData[2])
                goods:setScale(0.65)
                item.scrollView_awards:pushBackCustomItem(goods)
            end
        end

        local isSuitExist = GoodsDataMgr:currencyIsEnough(self.dress[tostring(warId)], 1)
        lab_complate:setVisible(isSuitExist)
        btn_open:setVisible(not isSuitExist)
        if btn_open:isVisible() then
            btn_open:onClick(function()
                local costId, costNum = next(self.costGoods[tostring(warId)])
                print(GoodsDataMgr:getItemCount(tonumber(costId)))
                print(costId, costNum)
                if not GoodsDataMgr:currencyIsEnough(tonumber(costId), tonumber(costNum)) then
                    Utils:showTips(63935)
                    return 
                end

                self.isConfirmOpen = false
                local costIcon =  GoodsDataMgr:getItemCfg(tonumber(costId)).icon 
                local _txt = TextDataMgr:getText(63936, costNum, costIcon)
                local confirmargs = {
                    tittle = 2107025,
                    content = _txt,
                    confirmCall = function()
                        ActivityDataMgr2:SEND_ACTIVITY2_REQ_CHOICE_NEW_WAR(warId)
                        self.isConfirmOpen = true
                    end,
                }
                local argsTimeTip = {
                    tittle = 2107025,
                    content = TextDataMgr:getText(63932),
                    confirmCall = function()
                        Utils:showReConfirm(confirmargs)
                    end,
                }
                local _, tipTime = Utils:changStrToDate(self.tipsTimes[tostring(warId)])
                if tipTime <= ServerDataMgr:getServerTime()  then
                    Utils:showReConfirm(argsTimeTip)
                else
                    Utils:showReConfirm(confirmargs)
                end
            end)
        end
        local specialCfg = cfgs[1]
        if specialCfg.nameTextId then
            lab_titleName:setTextById(specialCfg.nameTextId)
        end
        if specialCfg.icon ~= "" then
            img_icon:setTexture(specialCfg.icon)
        end
        self.listView:pushBackCustomItem(item)
    end
end

function TaskTrainingChooseView:onShow()
    self.super.onShow(self)
    if self.isConfirmOpen then
        AlertManager:close(self)
    end
end

return TaskTrainingChooseView