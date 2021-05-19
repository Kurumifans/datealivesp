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

local ExGetItemView = requireNew("lua.logic.bag.GetItemView")
ExGetItemView.__cname = "ExGetItemView"


function refreshView(self)
    --local itemMargin = 10
    --local goodsItemSize = self.Panel_goodsItem_prefab:Size()
    --local goodsItemAp = self.Panel_goodsItem_prefab:AnchorPoint()
    local itemPrefab = TFDirector:getChildByPath(self.Panel_prefab,"Panel_exItem")
    for i, v in ipairs(self.itemList_) do
        local data = v
        local item = itemPrefab:clone()
        local Panel_goodsItem = self.Panel_goodsItem_prefab:clone()
        item:addChild(Panel_goodsItem)
        item:setContentSize(Panel_goodsItem:getContentSize())
        Panel_goodsItem:setPosition(ccp(0,0))
        PrefabDataMgr:setInfo(Panel_goodsItem, data.originId or data.id, data.num)
        item:setScale(2)
        item:setOpacity(0)
        local itemCfg = GoodsDataMgr:getItemCfg(data.id)

        if itemCfg  then
            if EC_ItemQualityEffect[itemCfg.quality] then
                if not Panel_goodsItem.Spine_qualityEffect_bg  then
                    Panel_goodsItem.Spine_qualityEffect_bg = SkeletonAnimation:create("effect/effect_props/effect_props")
                end
                Panel_goodsItem.Spine_qualityEffect_bg:setScale(0.9)
                Panel_goodsItem.Spine_qualityEffect_bg:play(EC_ItemQualityEffect[itemCfg.quality].bg,true)
                Panel_goodsItem:addChild(Panel_goodsItem.Spine_qualityEffect_bg,0)
                if not item.Spine_qualityEffect_up2  then
                    item.Spine_qualityEffect_up2 = SkeletonAnimation:create("effect/effect_props/effect_props")
                end
                item.Spine_qualityEffect_up2:play(EC_ItemQualityEffect[itemCfg.quality].up2,true)
                item.Spine_qualityEffect_up2:setVisible(false)
                Panel_goodsItem:getChildByName("Image_icon"):addChild(item.Spine_qualityEffect_up2,2)
                local pos = ccp(1,-1)
                if itemCfg.quality == EC_ItemQuality.PURPLE then
                    pos = ccp(2,-1)
                elseif itemCfg.quality == EC_ItemQuality.RED then
                    pos = ccp(1,1)
                end
                item.Spine_qualityEffect_up2:setPosition(pos)
            end
            item.quality = itemCfg.quality
        end

        table.insert(self.goodsItem_, item)

        local tag = TFDirector:getChildByPath(item,"tag"):hide()
        if v.tag then
        	tag:show()
	        tag:setTexture("icon/item/exBouns"..v.tag..".png")
	    end
        self.GridView_reward:pushBackCustomItem(item)
    end

    for i,v in ipairs(self.staticItemList_) do
        local data = v
        local Panel_goodsItem = self.Panel_goodsItem_prefab:clone()
        PrefabDataMgr:setInfo(Panel_goodsItem, data.originId or data.id, data.num)
        Panel_goodsItem:setScale(self.itemScale)
        -- Panel_goodsItem:setOpacity(0)
        local itemCfg = GoodsDataMgr:getItemCfg(data.id)

        if itemCfg  then
            if EC_ItemQualityEffect[itemCfg.quality] then
                if not Panel_goodsItem.Spine_qualityEffect_bg  then
                    Panel_goodsItem.Spine_qualityEffect_bg = SkeletonAnimation:create("effect/effect_props/effect_props")
                end
                Panel_goodsItem.Spine_qualityEffect_bg:setScale(0.9)
                Panel_goodsItem.Spine_qualityEffect_bg:play(EC_ItemQualityEffect[itemCfg.quality].bg,true)
                Panel_goodsItem:addChild(Panel_goodsItem.Spine_qualityEffect_bg,0)
                if not Panel_goodsItem.Spine_qualityEffect_up2  then
                    Panel_goodsItem.Spine_qualityEffect_up2 = SkeletonAnimation:create("effect/effect_props/effect_props")
                end
                Panel_goodsItem.Spine_qualityEffect_up2:play(EC_ItemQualityEffect[itemCfg.quality].up2,true)
                Panel_goodsItem.Spine_qualityEffect_up2:setVisible(false)
                Panel_goodsItem:getChildByName("Image_icon"):addChild(Panel_goodsItem.Spine_qualityEffect_up2,2)
                local pos = ccp(1,-1)
                if itemCfg.quality == EC_ItemQuality.PURPLE then
                    pos = ccp(2,-1)
                elseif itemCfg.quality == EC_ItemQuality.RED then
                    pos = ccp(1,1)
                end
                Panel_goodsItem.Spine_qualityEffect_up2:setPosition(pos)
            end
            item.quality = itemCfg.quality
        end
        self.Uilist_staticReward:pushBackCustomItem(Panel_goodsItem)
    end

    if self.Uilist_staticReward then
        Utils:setAliginCenterByListView(self.Uilist_staticReward)
    end
    
    --local row = 0
    --for i = 1, #self.itemList_, self.columnNum_ do
    --    row = row + 1
    --    self.goodsItem_[row] = {}
    --    local Panel_goodsRowItem = self.Panel_goodsRowItem:clone()
    --    local width = 0
    --    for j = i, math.min(i + self.columnNum_ - 1, #self.itemList_) do
    --        local data = self.itemList_[j]
    --        local Panel_goodsItem = Panel_goodsItem_prefab:clone()
    --        PrefabDataMgr:setInfo(Panel_goodsItem, data.id, data.num)
    --        local remain = math.fmod(j, self.columnNum_)
    --        if remain == 0 then remain = 5 end
    --        local x = (goodsItemSize.width + itemMargin) * (remain - 1) + goodsItemSize.width * goodsItemAp.x
    --        local y = 0
    --        Panel_goodsItem:Pos(x, y)
    --        Panel_goodsItem:AddTo(Panel_goodsRowItem)
    --        width = x
    --        table.insert(self.goodsItem_[row], Panel_goodsItem)
    --    end
    --    width = width + goodsItemSize.width * (1 - goodsItemAp.x)
    --    local originSize = Panel_goodsRowItem:Size()
    --    local size = CCSize(width, originSize.height)
    --    Panel_goodsRowItem:Size(size)
    --    self.ListView_reward:pushBackCustomItem(Panel_goodsRowItem)
    --end
    --Utils:setAliginCenterByListView(self.GridView_reward, false)

    self:timeOut(function()
        self:playAni()
    end, 0.1)
end

rawset(ExGetItemView, "refreshView", refreshView)

return ExGetItemView