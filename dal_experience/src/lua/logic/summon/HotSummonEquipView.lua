local HotSummonEquipView = class("HotSummonEquipView", BaseLayer)

function HotSummonEquipView:ctor(summonId)
    self.super.ctor(self)
    self:initData(summonId)
    self:init("lua.uiconfig.summon.hotSummonEquipView")
end

function HotSummonEquipView:initData(summonId)
    self.selectTargetIndex = 1
    self.summonId = summonId
    self.equipmentReward = {}
    local summonInfo = SummonDataMgr:getSummonCfg(self.summonId)
    if summonInfo and summonInfo.equipmentReward then
        self.equipmentReward = summonInfo.equipmentReward
    end
    local discreteCfgData = Utils:getKVP(14006)
    self.chooseCnt = discreteCfgData.num
    self.chooseLv = discreteCfgData.level
    self.lastSelectEquipId = nil
end

function HotSummonEquipView:initUI(ui)
	self.super.initUI(self,ui)
	self.ui = ui


    self.Panel_prefab = TFDirector:getChildByPath(self.ui, "Panel_prefab")
    self.Panel_CloneItem = TFDirector:getChildByPath(self.Panel_prefab, "Panel_CloneItem")
    self.Panel_targetItem = TFDirector:getChildByPath(self.Panel_prefab, "Panel_targetItem")
    self.Image_cloneStar = TFDirector:getChildByPath(self.Panel_prefab, "Image_cloneStar")

    self.Image_scrollBarModel = TFDirector:getChildByPath(self.ui, "Image_scrollBarModel")
    self.Image_scrollBarInner = TFDirector:getChildByPath(self.Image_scrollBarModel, "Image_scrollBarInner")
    self.scrollBar = UIScrollBar:create(self.Image_scrollBarModel, self.Image_scrollBarInner)

    self.Panel_target = TFDirector:getChildByPath(self.ui, "Panel_target")
    self.Image_equipPaint = TFDirector:getChildByPath(self.ui, "Image_equipPaint")
    self.Button_view = TFDirector:getChildByPath(self.ui, "Button_view")

    local ScrollView_item = TFDirector:getChildByPath(self.ui, "ScrollView_item")
    self.GridView_item = UIGridView:create(ScrollView_item)
    self.GridView_item:setItemModel(self.Panel_CloneItem)
    self.GridView_item:setColumn(3)
    self.GridView_item:setColumnMargin(5)
    self.GridView_item:setScrollBar(self.scrollBar)

    self.Button_exchange = TFDirector:getChildByPath(self.ui, "Button_exchange")
    self.Label_exchange = TFDirector:getChildByPath(self.Button_exchange, "Label_exchange")

    self.Button_check = TFDirector:getChildByPath(self.ui, "Button_check")
    self.Label_check = TFDirector:getChildByPath(self.Button_check, "Label_check")

    self.Label_tip1 = TFDirector:getChildByPath(self.ui, "Label_tip1")
    self.Label_tip2 = TFDirector:getChildByPath(self.ui, "Label_tip2")
    self.Label_desc = TFDirector:getChildByPath(self.ui, "Label_desc")
    self:uiLogic()
end

function HotSummonEquipView:uiLogic()

    self.Label_tip1:setTextById(1280010)
    self.Label_tip1:setSkewX(15)
    self.Label_tip2:setTextById(1280007)
    self.Label_tip2:setSkewX(15)

    self.Label_check:setTextById(1280006)
    self.Label_exchange:setTextById(1280007)

    local timestamp = SummonDataMgr:getHotSummonEndTime(EC_SummonLoopType.EQUIPMENT)
    local date = TFDate(timestamp):tolocal()
    local timeStr = date:fmt("%Y-%m-%d %H:%M:%S")
    self.Label_desc:setTextById(1200070, timeStr)

    self:showTargetEquip()
    self:showOwnEquip()
end

function HotSummonEquipView:showTargetEquip()

    if not self.equipmentReward then
        return
    end

    self.targetPos = {
        ccp(121,365),
        ccp(276,243),
        ccp(121,178),
    }
    self.targetItem_ = {}
    self.Panel_target:removeAllChildren()
    for i=1,3 do
        self:addTargetEquip(i,self.equipmentReward[i])
    end
    
    self:selectTargetEquip(self.selectTargetIndex,true)
end

function HotSummonEquipView:addTargetEquip(index,equipId)

    local targetItem = self.Panel_targetItem:clone()
    local foo = {}
    foo.root = targetItem
    foo.Image_select = TFDirector:getChildByPath(foo.root, "Image_select")
    foo.Panel_head = TFDirector:getChildByPath(foo.root, "Panel_head")
    foo.Label_num = TFDirector:getChildByPath(foo.root, "Label_num")
    foo.Image_icon = TFDirector:getChildByPath(foo.root, "Image_icon")

    local ScrollView_star = TFDirector:getChildByPath(foo.root, "ScrollView_star")
    local ListView_star = foo.ListView_star
    if not ListView_star then
        ListView_star = UIListView:create(ScrollView_star)
        ListView_star:setInertiaScrollEnabled(false)
        ListView_star:setItemsMargin(-6)
        foo.ListView_star = ListView_star
    end
    ListView_star:removeAllItems()

    foo.Image_select:setVisible(false)

    --拥有
    local count = GoodsDataMgr:getItemCount(equipId)
    -- foo.Label_num:setText("拥有:%s"..count)
    foo.Label_num:setTextById(100000075,count)

    local cfg = GoodsDataMgr:getItemCfg(equipId)
    if cfg then
        foo.Image_icon:setTexture(cfg.equipPaint)

        for i = 1,cfg.star do
            local starItem = self.Image_cloneStar:clone()
            starItem:ZO(cfg.star - i + 1)
            foo.ListView_star:pushBackCustomItem(starItem)
        end
        Utils:setAliginCenterByListView(foo.ListView_star, true)
    end
    self.targetItem_[index] = foo
    foo.Panel_head:onClick(function()
            self:selectTargetEquip(index)
    end)

    targetItem:setPosition(self.targetPos[index])
    self.Panel_target:addChild(targetItem)
end

function HotSummonEquipView:selectTargetEquip(selectIndex,noShowInfo)
    --self.Button_view:show()
    for k,v in ipairs(self.targetItem_) do
        v.Image_select:setVisible(k == selectIndex)
    end

    self.selectTargetIndex = selectIndex
    local equipId = self.equipmentReward[selectIndex]
    if not equipId then
        return
    end
    local cfg = GoodsDataMgr:getItemCfg(equipId)
    if not cfg then
        return
    end
    self.Image_equipPaint:setPosition(ccp(cfg.summonPosition.x,cfg.summonPosition.y))
    self.Image_equipPaint:setScale(cfg.summonSize)
    self.Image_equipPaint:setTexture(cfg.paint)
    
    if not noShowInfo then
        Utils:showInfo(equipId)
    end
end


function HotSummonEquipView:showOwnEquip()

    self.GridView_item:removeAllItems()
    self.equipMentData_ = {}
    for i=4,#self.equipmentReward do
        local goodsData = GoodsDataMgr:getItemCfg(self.equipmentReward[i]);
        goodsData.cid = self.equipmentReward[i];
        table.insert(self.equipMentData_,goodsData);
    end
    self.loadIndex = 1
    self.equipItem_ = {}
    self.selectEquipItem = {}
    self.selectEquipId = {}
    self.lastSelect = nil
    --self:equipMentSort()
    self:showInEquipItem()
end

--排序
function HotSummonEquipView:equipMentSort()

    table.sort(self.equipMentData_, function(a, b)
        local isEquipA = EquipmentDataMgr:isUesing(a.id) 
        local equipSortA = isEquipA and 1 or 0
        local isEquipB = EquipmentDataMgr:isUesing(b.id)
        local equipSortB = isEquipB and 1 or 0
        if equipSortA == equipSortB then
            return a.cid < b.cid
        end
        return equipSortA > equipSortB
    end)
end

function HotSummonEquipView:showInEquipItem()
    
    local data = self.equipMentData_[self.loadIndex]
    if not data then return end

    local item = self.GridView_item:getItem(self.loadIndex)
    if not item then
        item = self:addEquipItem()
        item:Alpha(0)
    end

    self:updateEquipItem(item, data)
    local fadeInDuration = 0.2
    local delayDuration = 0.05
    item:fadeIn(fadeInDuration)
    local seq = Sequence:create({
            DelayTime:create(delayDuration),
            CallFunc:create(function()
                    self.loadIndex = self.loadIndex + 1
                    self:showInEquipItem()
            end)
    })
    item:runAction(seq)
end

function HotSummonEquipView:addEquipItem()
    local item = self.GridView_item:pushBackDefaultItem()
    local foo = {}
    foo.root = item
    foo.Image_select = TFDirector:getChildByPath(foo.root, "Image_select")
    foo.Image_selected = TFDirector:getChildByPath(foo.root, "Image_selected")
    foo.Image_lock = TFDirector:getChildByPath(foo.root, "Image_lock")
    foo.Panel_head = TFDirector:getChildByPath(foo.root, "Panel_head")
    foo.Image_carry = TFDirector:getChildByPath(foo.root, "Image_carry")
    
    local Panel_goodsItem = PrefabDataMgr:getPrefab("Panel_goodsItem"):clone()
    Panel_goodsItem:setTouchEnabled(false)
    Panel_goodsItem:Pos(0, 0)
    Panel_goodsItem:AddTo(foo.Panel_head)
    Panel_goodsItem:setScale(0.8)
    foo.Panel_goodsItem = Panel_goodsItem
    self.equipItem_[item] = foo
    return item
end

function HotSummonEquipView:updateEquipItem(item, data)
    local itemCfg = GoodsDataMgr:getItemCfg(data.cid)
    local foo = self.equipItem_[item]
    if not foo then
        item = self:addGoodsItem();
        foo = self.equipItem_[item];
    end
    foo.Image_select:hide()
    foo.Image_selected:hide()
    PrefabDataMgr:setInfo(foo.Panel_goodsItem, data.id, data.num)

    local isCarry = EquipmentDataMgr:isUesing(data.id)
    foo.Image_carry:setVisible(isCarry)

    --是否锁定
    foo.Image_lock:setVisible(data.isLock)

    if self.lastSelectEquipId and self.lastSelectEquipId == data.id then
        self:selectGoodsItem(item,data)
    end

    foo.Panel_head:onClick(function()
        self:selectGoodsItem(item,data)
    end)
end

function HotSummonEquipView:selectGoodsItem(item, data)
    local cfg = GoodsDataMgr:getItemCfg(data.cid)
    if not cfg then
        return
    end
    self.Image_equipPaint:setPosition(ccp(cfg.summonPosition.x,cfg.summonPosition.y))
    self.Image_equipPaint:setScale(cfg.summonSize)
    self.Image_equipPaint:setTexture(cfg.paint)

    Utils:showInfo(data.cid)
end

function HotSummonEquipView:onRecvUpdateData()
    self:showTargetEquip()
    self:showOwnEquip()
end

function HotSummonEquipView:registerEvents()
    
    EventMgr:addEventListener(self, EV_SUMMON_UPATE_EQUIP, handler(self.onRecvUpdateData, self))

    self.Button_view:onClick(function()
        local selectTargetId = self.equipmentReward[self.selectTargetIndex]
        if selectTargetId then
            Utils:showInfo(selectTargetId)
        end
    end)

    self.Button_exchange:onClick(function()
       if self.chooseCnt > #self.selectEquipId then
            local tipTx = TextDataMgr:getText(1280005,self.chooseCnt)
            Utils:showTips(tipTx)
            return
        end

        local targetId = self.equipmentReward[self.selectTargetIndex]
        if not targetId then
            return
        end

        local targetconf = TabDataMgr:getData("Equipment", targetId)
        local targetname = ""
        if targetId then
            targetname = TextDataMgr:getText(targetconf.nameTextId)
        end

        local tab = {}
        local equipnamestr = ""
        for i,id in ipairs(self.selectEquipId) do
            local equipcid = EquipmentDataMgr:getEquipCid(id)
            table.insert(tab,tostring(id))
            local equipconf = TabDataMgr:getData("Equipment", tonumber(equipcid))
            if equipconf then
                equipnamestr = equipnamestr .. TextDataMgr:getText(equipconf.nameTextId) .. " "
            end
        end

        local view = Utils:openView("common.ConfirmBoxView")
        view:setCallback(function()
            local msg = {
                tab,
                targetId,
                self.summonId
            }
            SummonDataMgr:send_SUMMON_REQ_EXCHANGE(msg)
        end)
        view:setRContent("r130002", equipnamestr, targetname)
    end)

    self.Button_check:onClick(function()
        if #self.selectEquipId ~= 1 then
            Utils:showTips(1280009)
            return
        end

        local equipid = self.selectEquipId[1]
        local itemInfo = GoodsDataMgr:getSingleItem(equipid)
        if not itemInfo then
            return
        end

        Utils:openView("Equipment.EquipmentInfo", {equipmentId = equipid, fromBag = true})
    end)
end

function HotSummonEquipView:onShow()
    --self:showTargetEquip()
    --self:showOwnEquip()
end

function HotSummonEquipView:onHide()
	self.super.onHide(self)
end

function HotSummonEquipView:removeUI()
	self.super.removeUI(self)
end

return HotSummonEquipView