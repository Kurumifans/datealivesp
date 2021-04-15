--[[
    @desc：SupplyMainNewView
    @date: 2020-10-11 11:48:32
]]

local SupplyMainNewView = class("SupplyMainNewView",BaseLayer)

function SupplyMainNewView:initData(defaultLeftIdx, pageSelectId)
    self.tabBtnCfg = {
        [1] = {
            name = 14300377,
            icon = "ui/recharge/gifts/new_1/006.png",
            topBannerDisId = 90038,
        },
        [2] = {
            name = 14300378,
            icon = "ui/recharge/gifts/new_1/015.png",
            topBannerDisId = 90039,
        },
        [3] = {
            name = 14300096,
            icon = "ui/recharge/gifts/new_1/004.png",
        },
        [4] = {
            name = 14300099,
            icon = "ui/recharge/gifts/new_1/005.png",
        },
    }

    self.defaultLeftIdx = defaultLeftIdx or 1
    self.pageSelectId = pageSelectId
    self.selectIndex = nil
    self.pageViews = {}
    self.keepPageSelectIdx = {}
end

function SupplyMainNewView:ctor(...)
    self.super.ctor(self)
    self:initData(...)
    self:init("lua.uiconfig.supplyNew.supplyMainNewView")
end

function SupplyMainNewView:initUI(ui)
    self.super.initUI(self,ui)
    self.leftTabListView = UIListView:create(self._ui.ScrollView_tab_btn)
    self.leftTabListView:setItemsMargin(2)
    self.topTabListView = UIListView:create(self._ui.ScrollView_topBtn)
    self.topTabListView:setItemsMargin(1)

    self:initLeftTabBtns()
    self:selectTabIdx(self.defaultLeftIdx)
end

function SupplyMainNewView:registerEvents()
    EventMgr:addEventListener(self,EV_RECHARGE_UPDATE,handler(self.updateTopTabBtn, self))
end

function SupplyMainNewView:initLeftTabBtns()
    self.leftTabListView:removeAllItems()
    for i, v in ipairs(self.tabBtnCfg) do
        local item = self._ui.Panel_tabItem:clone()
        TFDirector:getChildByPath(item, "img_icon"):setTexture(v.icon)
        TFDirector:getChildByPath(item, "Label_name"):setTextById(v.name)
        item.Image_select = TFDirector:getChildByPath(item, "Image_select")
        item.img_red = TFDirector:getChildByPath(item, "img_red"):hide()
        item:onClick(function()
            self:selectTabIdx(i)
        end)
        self.leftTabListView:pushBackCustomItem(item)
    end
end

function SupplyMainNewView:updateAllRed()
    local items = self.leftTabListView:getItems()
    for idx, v in ipairs(items) do
        local isShwow = false
        if idx == 1 then
            local state4 = TaskDataMgr:getDailyAwardRedShow()
            local state5 = TaskDataMgr:getTrainingShopTipsState()
            if self.selectIndex == idx then
                for i, _item in ipairs(self.topTabListView:getItems()) do
                    local topRedIshow = false
                    if _item.id == 5 then -- 战令商店
                        topRedIshow = state5
                    end
                    if _item.id == 4 then -- 培养专区
                        topRedIshow = state4
                    end
                    _item.img_red:setVisible(topRedIshow)
                end
            end
            isShwow = state5 or state4
        end

        if idx == 2 then
            local isFundRed = RechargeDataMgr:isGrowFundViewShowRed()
            if self.selectIndex == idx then
                for i, _item in ipairs(self.topTabListView:getItems()) do
                    local topRedIshow = false
                    if _item.id == 3 then -- 养成基金
                        topRedIshow = isFundRed
                    end
                    _item.img_red:setVisible(topRedIshow)
                end
            end
            isShwow = isFundRed
        end

        if idx == 3 then   
            local havecard = tobool(RechargeDataMgr:getMonthCardLeftTime() > 0)
            local cansign = RechargeDataMgr:isMonthCardCanSign()
            isShwow = havecard and cansign 
            local weekCardRed = RechargeDataMgr:getWeekCardCanSign()
            isShwow = weekCardRed or isShwow
        end

        if idx == 4 then
            isShwow = SummonDataMgr:getCanGetTask()
        end
        v.img_red:setVisible(isShwow)
    end
    self.leftTabListView:doLayout()
end

function SupplyMainNewView:selectTabIdx(idx)
    if self.selectIndex == idx then
        return
    end
    self.selectIndex = idx
    for i,item in ipairs(self.leftTabListView:getItems()) do
        item.Image_select:setVisible(i == self.selectIndex)
    end

    local topBannerDisId = self.tabBtnCfg[idx] and self.tabBtnCfg[idx].topBannerDisId or nil
    local topData = nil
    if nil ~= topBannerDisId then
        self._ui.Image_topBtn:setVisible(true)
        local _data = self:getCurTopCanShowData()
        topData = _data[1]
        if self.pageSelectId then
            for i, v in ipairs(_data) do
                if self.pageSelectId == v.id then
                    topData = _data[i]
                    if not self.keepPageSelectIdx[self.selectIndex] then
                        self.keepPageSelectIdx[self.selectIndex] = i
                    end
                end
            end
        end
        self:updateTopTabBtn()
        self:updateAllRed()
    else
        self._ui.Image_topBtn:setVisible(false)
    end

    local addPageToContent = {
        [1] = function()
            self.pageViews[idx] = requireNew("lua.logic.supplyNew.RecommondView"):new(topData)
        end,
        [2] = function()
            self.pageViews[idx] = requireNew("lua.logic.supplyNew.DepotView"):new(topData)
        end,
        [3] = function()
            self.pageViews[idx] = requireNew("lua.logic.store.PrivilageCard"):new()
        end,
        [4] = function()
           self.pageViews[idx] = requireNew("lua.logic.summon.SummonContractMainView"):new()
        end
    }
    if not self.pageViews[idx] then
        addPageToContent[idx]()
        self:addLayerToNode(self.pageViews[idx], self._ui.Panel_content)
    end
    for _idx, v in pairs(self.pageViews) do
        v:setVisible(_idx == idx)
    end
end

function SupplyMainNewView:updateTopTabBtn()
    local topBannerDisId = self.tabBtnCfg[self.selectIndex].topBannerDisId
    if not topBannerDisId then
        return
    end

    self.topTabListView:removeAllItems()
    for i, v in ipairs(self:getCurTopCanShowData()) do
        local normalSrcImg = "ui/supplyNew/%s1.png"
        local imgIcon = v.icon
        local item = self._ui.Panel_topItem:clone()
        TFDirector:getChildByPath(item, "Label_name"):setTextById(tonumber(v.name))
        item.Image_select = TFDirector:getChildByPath(item, "Image_select")
        item.img_red = TFDirector:getChildByPath(item, "img_red")
        item.img_icon = TFDirector:getChildByPath(item, "img_icon")

        if self.selectIndex == 2 and v.id == 4 then -- 特权支援图片改为服务器下发
            local storeData = StoreDataMgr:getOpenStore(EC_StoreType.NEW_SUPPORT)
            if storeData[1] then
                local srcPic = StoreDataMgr:getStoreInfo(storeData[1]).pic
                if srcPic and srcPic ~= "" then
                    imgIcon = srcPic
                end
            end
        end

        item.img_icon:setTexture(string.format(normalSrcImg, imgIcon))
        item.id = v.id
        item:onClick(function()
            self:topBtnClickFunc(i)
            if self.selectIndex == 2 then
                if v.id == 3 then
                    local playerId = MainPlayer:getPlayerId()
                    CCUserDefault:sharedUserDefault():setBoolForKey("GrowFundNewFlag"..playerId,true)
                    if not RechargeDataMgr:getDayHadInFundView() then
                        RechargeDataMgr:setDayHadInFundView()
                    end
                    self:updateAllRed()
                end
            end
        end)
        self.topTabListView:pushBackCustomItem(item)
    end
    self:topBtnClickFunc(self.keepPageSelectIdx[self.selectIndex] or 1)
end

function SupplyMainNewView:getCurTopCanShowData()
    local _data = {}
    local topBannerDisId = self.tabBtnCfg[self.selectIndex].topBannerDisId
    local data = Utils:getKVP(topBannerDisId)
    if self.selectIndex == 2 then -- 补给站固定
        return data
    end
    for i, v in ipairs(data) do
        if RechargeDataMgr:getLeftGiftCnt(tonumber(v.interface)) > 0 then
            table.insert(_data ,v)
        else
            -- 特殊处理添加
            if v.id == 5 or v.id == 4 then
                local needIn = false
                
                if v.id == 5 then
                    local warOrderActivity = ActivityDataMgr2:getWarOrderAcrivityInfo()
                    if warOrderActivity and warOrderActivity.id then
                        local trainingTaskData = ActivityDataMgr2:getItems(warOrderActivity.id)
                        for i, _id in ipairs(trainingTaskData) do
                            if tonumber(warOrderActivity.extendData.daytask) == _id then
                                if ActivityDataMgr2:getItemInfo(warOrderActivity.activityType, _id) then
                                    needIn = true
                                    break
                                end
                            end
                        end
                    end
                end

                if v.id == 4 then
                    local taskList = TaskDataMgr:getTask(EC_TaskType.DAY_GETAWARD)
                    if taskList and table.count(taskList) > 0 then
                        needIn = true
                    end
                end

                if needIn then
                    table.insert(_data ,v)
                end
            end
        end
    end

    return _data
end

function SupplyMainNewView:topBtnClickFunc(idx)
    local data = self:getCurTopCanShowData()
    if not data[idx] then
        idx = 1
    end
    for i, item in ipairs(self.topTabListView:getItems()) do
        local normalSrcImg = "ui/supplyNew/"..data[i].icon.."1.png"
        local pressSrcImg = "ui/supplyNew/"..data[i].icon.."2.png"
        item.Image_select:setVisible(idx == i)
        if idx == i then
            item.img_icon:setTexture(pressSrcImg)
        else
            item.img_icon:setTexture(normalSrcImg)
        end
    end
    self.keepPageSelectIdx[self.selectIndex] = idx

    local page = self.pageViews[self.selectIndex]
    if page and page.refreshView then
        page:initData(data[idx])
        page:refreshView()
    end
end

function SupplyMainNewView:onShow()
    self.super.onShow(self)
    self:updateAllRed()
end

return SupplyMainNewView