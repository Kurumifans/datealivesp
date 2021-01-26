
local GiftPackMainView = class("GiftPackMainView", BaseLayer)

function GiftPackMainView:ctor(panelId)
    self.super.ctor(self)
    self:initData(panelId)
    self:init("lua.uiconfig.recharge.giftPackMainView")
end

function GiftPackMainView:initData(panelId)
    self.tabBtns    = {}
    self.modelPanel = {}
    self.selectIndex = nil
    self.curPanelId = nil
    self:initTabData()
    if panelId then
        for i, v in ipairs(self.tabData) do
            if v.id == panelId then
                self.selectIndex = i
                break
            end
        end
    end
end

function GiftPackMainView:initTabData()
    self.tabData = {
    {id = 1, name = 14300095,iconRes = "ui/recharge/gifts/new_1/006.png"},
    {id = 2, name = 14300096,iconRes = "ui/recharge/gifts/new_1/004.png"},
    {id = 3, name = 14300348,iconRes = "ui/recharge/gifts/new_1/011.png"},
    {id = 4, name = 14300097,iconRes = "ui/recharge/gifts/new_1/007.png"},
    {id = 5, name = 14300099,iconRes = "ui/recharge/gifts/new_1/005.png"},
    {id = 8, name = 23019,iconRes = "ui/recharge/gifts/new_1/009.png"},
    }

    function checkDateLimit(data)
        local realData = {}
        local serverTime = ServerDataMgr:getServerTime()
        for k,v in ipairs(data) do
            if v.startDate and v.endDate then
                if serverTime >= v.startDate and serverTime < v.endDate then
                    table.insert(realData, v)
                end
            else
                table.insert(realData, v)
            end
        end
        return realData
    end
    

    local backGiftList = checkDateLimit(RechargeDataMgr:getGiftListByType(16))
    if backGiftList and #backGiftList > 0 then
        table.insert(self.tabData, 2, {id = 10, name = 15010168, iconRes = "ui/recharge/gifts/new_1/013.png"})
    end

    local anniversaryPacks = checkDateLimit(RechargeDataMgr:getAnniversary2yearData())
    if anniversaryPacks and #anniversaryPacks > 0 then
        table.insert(self.tabData,1,{id = 9, name = 14071,iconRes = "ui/recharge/gifts/new_1/012.png"})
    end

    local whitePacks = checkDateLimit(RechargeDataMgr:getGiftListByType(17))
    if whitePacks and #whitePacks > 0 then
        table.insert(self.tabData, 1, {id = 11, name = 302209, iconRes = "ui/recharge/gifts/new_1/014.png"})
    end

    local newBirdPacks = RechargeDataMgr:getNewBirdGiftData()
    if newBirdPacks and #newBirdPacks > 0 and RechargeDataMgr:getLeftGiftCnt(11) > 0 then
        table.insert(self.tabData,1,{id = 6, name = 14300098, iconRes = "ui/recharge/gifts/new_1/008.png"})
    end

    -- if limitPacks and #limitPacks > 0 then
    --     table.insert(self.tabData,1,{id = 6, name = 14300094, iconRes = "ui/recharge/gifts/new_1/010.png"})
    -- end
end

function GiftPackMainView:initUI(ui)
    self.super.initUI(self, ui)

    self.ui = ui

    self.Panel_root = TFDirector:getChildByPath(ui, "Panel_root")
    self.Panel_prefab   = TFDirector:getChildByPath(self.ui, "Panel_prefab")
    self.Panel_tabItem  = TFDirector:getChildByPath(self.ui, "Panel_tabItem")
    self.Panel_content = TFDirector:getChildByPath(self.ui, "Panel_content")

    local ScrollView_tab_btn    = TFDirector:getChildByPath(ui,"ScrollView_tab_btn")
    self.ListView_tab_btn = UIListView:create(ScrollView_tab_btn)
    self.ListView_tab_btn:setItemsMargin(2)
    self:initTabList()
end


function GiftPackMainView:initTabList()
    self.ListView_tab_btn:removeAllItems()
    self.tabBtns = {}
    for i,v in ipairs(self.tabData) do
        local item = self.Panel_tabItem:clone()
        self.ListView_tab_btn:pushBackCustomItem(item)
        TFDirector:getChildByPath(item,"Label_name"):setTextById(v.name)
        local img_icon = TFDirector:getChildByPath(item,"img_icon")
        if v.iconRes then
            img_icon:setTexture(v.iconRes)
        end
        item:setTouchEnabled(true)
        item:onClick(function()
            self:selectTabIdx(i)
            if v.id == 8 and not RechargeDataMgr:getDayHadInFundView() then
                RechargeDataMgr:setDayHadInFundView()
                self:showRedPoint()
            end
        end)
        self.tabBtns[i] = item
    end
    self:showRedPoint()
    
    local lastIdx = self.selectIndex
    self.selectIndex = nil
    if lastIdx and lastIdx > #self.tabData then
        lastIdx = #self.tabData
    end
    self:selectTabIdx(lastIdx or 1)
end

function GiftPackMainView:selectTabIdx(idx)
    if self.selectIndex == idx then
        return
    end
    self.selectIndex = idx
    for i,item in ipairs(self.tabBtns) do
        if i == self.selectIndex then
            TFDirector:getChildByPath(item,"Image_select"):setVisible(true)
        else
            TFDirector:getChildByPath(item,"Image_select"):setVisible(false)
        end
    end
    self:updateUI()
end

function GiftPackMainView:updateUI()
    for k, model in pairs(self.modelPanel) do
        model:hide()
    end
    local panelId = self.tabData[self.selectIndex].id
    self.curPanelId = panelId
    if self["updatePanelView"..panelId] then
        local model = self["updatePanelView"..panelId](self)
        model:show()
        if model.updateContentView then
            model:updateContentView()
        end
    end
end

function GiftPackMainView:updatePanelView1()
    local model = self.modelPanel[1]
    if not model then
        model = requireNew("lua.logic.store.HotMallView"):new()
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[1] = model
    end
    return model
end

function GiftPackMainView:updatePanelView2()
    local model = self.modelPanel[2]
    if not model then
        model = requireNew("lua.logic.activity.MonthCardView"):new()
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[2] = model
    end
    return model
end

function GiftPackMainView:updatePanelView4()
    local model = self.modelPanel[4]
    if not model then
        local flag = ActivityDataMgr:getSevenExCurDayTag() <= 0
        model = requireNew("lua.logic.activity.SupportStoreView"):new(flag)
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[4] = model
    end
    return model
end

function GiftPackMainView:updatePanelView5()
    local model = self.modelPanel[5]
    if not model then
        model = requireNew("lua.logic.summon.SummonContractMainView"):new()
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[5] = model
    end
    return model
end

function GiftPackMainView:updatePanelView6()
    local model = self.modelPanel[6]
    if not model then
        model = requireNew("lua.logic.store.NewBirdGiftView"):new()
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[6] = model
    end
    return model
end

function GiftPackMainView:updatePanelView7()
    local model = self.modelPanel[7]
    if not model then
        model = requireNew("lua.logic.store.LimitGiftPackView"):new()
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[7] = model
    end
    return model
end

function GiftPackMainView:updatePanelView8()
    local model = self.modelPanel[8]
    if not model then
        model = requireNew("lua.logic.store.FundGrowView"):new()
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[8] = model
    end
    return model
end

function GiftPackMainView:updatePanelView3()
    local model = self.modelPanel[3]
    if not model then
        model = requireNew("lua.logic.store.WeekCardView"):new()
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[3] = model
    end
    return model
end

function GiftPackMainView:updatePanelView9()
    local model = self.modelPanel[9]
    if not model then
        model = requireNew("lua.logic.store.Anniversary2YearView"):new()
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[9] = model
    end
    return model
end

function GiftPackMainView:updatePanelView10()
    local model = self.modelPanel[10]
    if not model then
        model = requireNew("lua.logic.store.GiftListView"):new(16)
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[10] = model
    end
    return model
end

function GiftPackMainView:updatePanelView11()
    local model = self.modelPanel[11]
    if not model then
        model = requireNew("lua.logic.store.GiftListView"):new(17)
        self:addLayerToNode(model, self.Panel_content)
        self.modelPanel[11] = model
    end
    return model
end

function GiftPackMainView:onShow()
    self.super.onShow(self)
    self:showRedPoint()
end

function GiftPackMainView:showRedPoint()
    for i, v in ipairs(self.tabBtns) do
        local redTip = v:getChildByName("img_red")
        redTip:setVisible(false)
        local info = self.tabData[i]
        local _isShow = false
        if info.id == 8 then
            if RechargeDataMgr:isGrowFundViewShowRed() then
                _isShow = true
            end
        end
        if info.id == 2 then
            local havecard = tobool(RechargeDataMgr:getMonthCardLeftTime() > 0)
            local cansign = RechargeDataMgr:isMonthCardCanSign()
            _isShow =  havecard and cansign
        end
        if info.id == 3 then
            _isShow = RechargeDataMgr:getWeekCardCanSign()
         end
        if info.id == 5 then
            local canGetTask = SummonDataMgr:getCanGetTask()
            _isShow =  canGetTask
        end
        if info.id == 11 then
            _isShow =  RechargeDataMgr:checkSpecialGiftId(51120)
        end
        redTip:setVisible(_isShow)
    end
end

function GiftPackMainView:reloadUI()
    self:timeOut(function()
        self:initTabData()
        self:initTabList()
    end,1)
end

function GiftPackMainView:registerEvents()
    EventMgr:addEventListener(self,EV_RECHARGE_UPDATE,handler(self.reloadUI, self))
    EventMgr:addEventListener(self,EV_LIMIT_GIFT_PUSH,handler(self.reloadUI, self))
end


return GiftPackMainView
