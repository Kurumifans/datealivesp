---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/7/5 0005 14:39
---
local DatingOptionView = class("DatingOptionView", BaseLayer)

function DatingOptionView:initData(scriptTableName,callbackfun)
    self.data = TabDataMgr:getData(scriptTableName)
    self.callback_ = callbackfun
end

function DatingOptionView:ctor(scriptTableName,callbackfun)
    self.super.ctor(self)

    self:initData(scriptTableName,callbackfun)

    self:addMEListener(TFWIDGET_EXIT, handler(self._onCleanUp,self))

    self:init("lua.uiconfig.dating.datingOptionView")
end

function DatingOptionView:initUI(ui)
    self.super.initUI(self,ui)

    self.ui = ui


    self:initOption()
    self:hide()
end

function DatingOptionView:show(data,jumpTable)
    self.ui:setVisible(true)
    self.itemData = data
    self.serverJumpTable = jumpTable or {}
    jumpTable = jumpTable or self.itemData.jump
    if self.itemData.optionType == 5 then
        print("jumpTable======= ",jumpTable)
    end
    local optionType = self.itemData.optionType
    if not optionType or optionType == 0 or optionType == 5 or optionType == 1 then
        TFAudio.playEffect(Utils:getKVP(2001,"date_optionSound"))
    end

    self:setSelectBoard(jumpTable)
end

function DatingOptionView:hide()
    print("隐藏了")
    self.ui:setVisible(false)
end

function DatingOptionView:initOption()
    self.selectBoard = TFDirector:getChildByPath(self.ui,"Panel_select_board")
    self.Panel_mask = TFDirector:getChildByPath(self.selectBoard, "Panel_mask"):hide()
    self:initOption1()
    self:initOption2()
    self:initOption3()
    self:initOption4()
    self:initOption5()
    self:initOption6()
end

function DatingOptionView:initOption1()
    self.Panel_option1 = TFDirector:getChildByPath(self.selectBoard, "Panel_option1")

    self.Image_loadingBar = TFDirector:getChildByPath(self.Panel_option1, "Image_loadingBar"):hide()

    for idx=1,3 do
        local i = idx
        self["button_option_" .. i] = TFDirector:getChildByPath(self.ui, "Button_option_" .. i)
        self["button_option_" .. i].Label_none = self["button_option_" .. i]:getChild("Label_none")
        self["button_option_" .. i].isenable = true
        self["button_option_" .. i].savePos = self["button_option_" .. i]:Pos()
        self["textArea_option_" .. i] = TFDirector:getChildByPath(self.ui,"TextArea_option_" .. i)
        self["textArea_option_" .. i].orgy = self["textArea_option_" .. i]:getPosition().y

        self["button_option_" .. i]:addMEListener(TFWIDGET_CLICK,function()
            --选项点击音效
            TFAudio.playEffect(Utils:getKVP(2002,"date_confirmSound"))

            --local time = 0.3
            --local deyAc = DelayTime:create(time)
            local function clickFun()
                if not self["button_option_" .. i].isenable then
                    Utils:showTips(304012)
                else
                    for index=1,3 do
                        self["button_option_" .. index]:setTouchEnabled(false)
                    end
                    self:onTouchButtonOption(i)
                end
            end
            clickFun()
            --local ac = {
            --    deyAc,
            --    CCCallFunc:create(clickFun)
            --}
            --self.ui:runAction(CCSequence:create(ac))
        end)
    end
end

function DatingOptionView:initOption2()
    self.Panel_option2 = TFDirector:getChildByPath(self.selectBoard, "Panel_option2")
end

function DatingOptionView:initOption3()
    self.Panel_option3 = TFDirector:getChildByPath(self.selectBoard, "Panel_option3")
end

function DatingOptionView:initOption4()
    self.Panel_option4 = TFDirector:getChildByPath(self.selectBoard, "Panel_option4")
end

function DatingOptionView:initOption5()
    self.Panel_option5 = TFDirector:getChildByPath(self.selectBoard, "Panel_option5")
    self.Panel_option5.scroll = TFDirector:getChildByPath(self.ui, "ScrollView_select")
    self.Panel_option5.item = TFDirector:getChildByPath(self.ui, "Panel_item")
end

function DatingOptionView:initOption6()
    self.Panel_option6 = TFDirector:getChildByPath(self.selectBoard, "Panel_option6")

    for idx=1,3 do
        local i = idx
        self["button_option_6_" .. i] = TFDirector:getChildByPath(self.Panel_option6, "Button_option_" .. i)
        self["button_option_6_" .. i].isenable = true
        self["button_option_6_" .. i].savePos = self["button_option_6_" .. i]:Pos()
        self["textArea_option_6_" .. i] = TFDirector:getChildByPath(self.Panel_option6,"TextArea_option_" .. i)
        self["textArea_option_6_" .. i].orgy = self["textArea_option_6_" .. i]:getPosition().y

        self["button_option_6_" .. i]:addMEListener(TFWIDGET_CLICK,function()
            --选项点击音效
            TFAudio.playEffect(Utils:getKVP(2002,"date_confirmSound"))

            --local time = 0.3
            --local deyAc = DelayTime:create(time)
            local function clickFun()
                if not self["button_option_6_" .. i].isenable then
                    Utils:showTips(304012)
                else
                    for index=1,3 do
                        self["button_option_6_" .. index]:setTouchEnabled(false)
                    end
                    self:onTouchButtonOption6(i)
                end
            end
            clickFun()
            --local ac = {
            --    deyAc,
            --    CCCallFunc:create(clickFun)
            --}
            --self.ui:runAction(CCSequence:create(ac))
        end)
    end
end

function DatingOptionView:onTouchButtonOption6(idx)
    local btn = self["button_option_6_"..idx]
    if tolua.isnull(btn) then return end

    local itemData = btn.item;
    local id = btn.id

    if self.callback_ then
        btn:stopAllActions()
        self.ui:stopAllActions()


        local lastPos = btn:Pos()

        local spawnArr = { CCFadeOut:create(0.2),CCMoveBy:create(0.2,ccp(0,-20))}
        local spawn = CCSpawn:create(spawnArr)

        local action = Sequence:create({
                                        CCScaleTo:create(0.1,1.2),
                                        CallFunc:create(function()
                                            btn.select:show()
                                            self.ui:runAnimation(string.format("Action%s",idx-1))
                                        end),
                                        CCScaleTo:create(0.3,1),
                                        CallFunc:create(function()
                                            btn.select:hide()
                                        end)
                                        --CCDelayTime:create(0.2),
                                        --CCMoveTo:create(0.3,ccp(lastPos.x,376)),
                                        --CCDelayTime:create(0.5),
                                        --spawn
        })
        self["button_option_6_" .. idx]:runAction(action)
        --for i = 1, 3 do
        --    if i ~= idx then
        --        self["button_option_"..i]:hide()
        --    end
        --end

        self.ui:timeOut(function()
            self.callback_(id,itemData)
            if not tolua.isnull(btn) then 
                btn:Pos(lastPos)
            end
            if self.itemData and self.itemData.jumpConfig and table.count(self.itemData.jumpConfig)>0 then
                self:hideOptionLoadingBar()
            else
                self:hide()
            end
            for i = 1, 3 do
                if i ~= idx then
                    local lbtn = self["button_option_6_"..i]
                    if not tolua.isnull(lbtn) then 
                        lbtn:show()
                    end
                end
            end
        end,0.5)
    end
end

function DatingOptionView:onTouchButtonOption(idx)
    local btn = self["button_option_"..idx]
    if tolua.isnull(btn) then return end

    local itemData = btn.item;
    local id = btn.id

    if self.callback_ then
        btn:stopAllActions()
        local Image_pro = TFDirector:getChildByPath(self.Image_loadingBar, "Image_pro")
        Image_pro:stopAllActions()
        self.ui:stopAllActions()


        local lastPos = btn:Pos()

        local spawnArr = { CCFadeOut:create(0.2),CCMoveBy:create(0.2,ccp(0,-20))}
        local spawn = CCSpawn:create(spawnArr)

        local action = Sequence:create({
                                        CCScaleTo:create(0.1,1.2),
                                        CallFunc:create(function()
                                            btn.select:show()
                                            btn.select1:show()
                                            self.ui:runAnimation(string.format("Action%s",idx-1))
                                        end),
                                        CCScaleTo:create(0.3,1),
                                        CallFunc:create(function()
                                            btn.select:hide()
                                            btn.select1:hide()
                                        end)
                                        --CCDelayTime:create(0.2),
                                        --CCMoveTo:create(0.3,ccp(lastPos.x,376)),
                                        --CCDelayTime:create(0.5),
                                        --spawn
        })
        self["button_option_" .. idx]:runAction(action)
        --for i = 1, 3 do
        --    if i ~= idx then
        --        self["button_option_"..i]:hide()
        --    end
        --end

        self.ui:timeOut(function()
            self.callback_(id,itemData)
            if not tolua.isnull(btn) then 
                btn:Pos(lastPos)
            end
            if self.itemData and self.itemData.jumpConfig and table.count(self.itemData.jumpConfig)>0 then
                self:hideOptionLoadingBar()
            else
                self:hide()
            end
            for i = 1, 3 do
                if i ~= idx then
                    local lbtn = self["button_option_"..i]
                    if not tolua.isnull(lbtn) then 
                        lbtn:show()
                    end
                end
            end
        end,0.5)
    end
end

function DatingOptionView:hideOption()
    local Image_pro = TFDirector:getChildByPath(self.Image_loadingBar, "Image_pro")
    Image_pro:stopAllActions()
    self.ui:stopAllActions()
    if self.itemData and self.itemData.jumpConfig and table.count(self.itemData.jumpConfig)>0 then
        self:hideOptionLoadingBar()
    else
        self:hide()
    end
end

function DatingOptionView:checkAddOptionItem(id_tab)
    local jumpConfig = self.itemData.jumpConfig
    local addjump = jumpConfig.addjump
    if not addjump then
        return
    end

    print("checkAddOptionItem id_tab ",id_tab)

    local disTime = nil
    for ip, v in ipairs(addjump) do
        local jump = v.jump
        print("jump ",jump)
        local time = v.time
        disTime = disTime or time
        local optionItem
        for i, vd in ipairs(id_tab) do
            if vd == jump then
                optionItem = self["button_option_" .. i]
            end
        end
        if optionItem then
            optionItem:setOpacity(0)
            optionItem:setTouchEnabled(false)
            self.ui:timeOut(function()
                local pos = optionItem.savePos
                print("pos ",pos)
                --optionItem:moveTo(0.1,pos)
                optionItem:Pos(pos)
                optionItem:show()
                optionItem:fadeIn(0.1)
                optionItem:setTouchEnabled(true)
            end,time)
        end
    end
    return disTime
end

function DatingOptionView:checkDelOptionItem()
    local jumpConfig = self.itemData.jumpConfig
    local deljump = jumpConfig.deljump
    if not deljump then
        return
    end

    local disTime = 0
    for ip, v in ipairs(deljump) do
        local jump = v.jump
        local time = v.time
        local optionItem
        for i = 1, 3 do
            if self["button_option_" .. i].id == jump then
                optionItem = self["button_option_" .. i]
            end
        end
        if optionItem then
            optionItem:setOpacity(255)
            optionItem:setTouchEnabled(true)

            local deyAc = DelayTime:create(time-0.9)
            local fadeOut1 = CCFadeOut:create(0.1)
            local fadeIn1 = CCFadeIn:create(0.1)
            local fadeOut2 = CCFadeOut:create(0.1)
            local fadeIn2 = CCFadeIn:create(0.1)
            local fadeOut3 = CCFadeOut:create(0.1)
            local fadeIn3 = CCFadeIn:create(0.1)
            local fadeOut4 = CCFadeOut:create(0.1)
            local fadeIn4 = CCFadeIn:create(0.1)
            local Arc = {
                deyAc,
                fadeOut1,
                fadeIn1,
                fadeOut2,
                fadeIn2,
                fadeOut3,
                fadeIn3,
                fadeOut4,
                fadeIn4,
            }
            optionItem:runAction(CCSequence:create(Arc))

            self.ui:timeOut(function()
                optionItem:fadeOut(0.2)
                optionItem:setTouchEnabled(false)
            end,time)
        end
    end
    return disTime
end

function DatingOptionView:setSelectBoard(jumpTable, callback)
    local optionType = self.itemData.optionType

    print("optionType ",optionType)
    if not optionType or optionType == 0 or optionType == 5 then
        self:showOption(jumpTable, callback)
    elseif optionType == 1 then
        self:showOption1(jumpTable, callback)
    elseif optionType == 2 then
        self:showOption2(jumpTable, callback)
    elseif optionType == 3 then
        self:showOption3(jumpTable, callback)
    elseif optionType == 4 then
        self:showOption4(jumpTable, callback)
    elseif optionType == 6 then
        self:showOption5(jumpTable,callback)
    elseif optionType == 9 then
        self:showOption6(jumpTable,callback)
    end
end

function DatingOptionView:showPanelOption(idx)
    print("showPanelOption idx ",idx)
    self.Panel_option1:setVisible(idx == 1)
    self.Panel_option2:setVisible(idx == 2)
    self.Panel_option3:setVisible(idx == 3)
    self.Panel_option4:setVisible(idx == 4)
    self.Panel_option5:setVisible(idx == 5)
    self.Panel_option6:setVisible(idx == 6)
    --self.Panel_mask:setVisible(idx ~= 2)
end

--普通文字选项
function DatingOptionView:showOption(tab, callback)
    self:showPanelOption(1)

    local id_tab = clone(self.itemData.jump)
    for i = 1,3 do
        self["button_option_"..i].jumpId = nil
        if id_tab[i] then
            self["button_option_"..i].jumpId = id_tab[i]
            self["button_option_"..i].data = self.data[tonumber(id_tab[i])]

            local item = self["button_option_"..i].data;

            local randMaxIdx = 1
            if item.radText1 and #item.radText1 > 0 then
                randMaxIdx = randMaxIdx + 1
            elseif item.radText2 and #item.radText2 > 0 then
                randMaxIdx = randMaxIdx + 1
            end
            local randIdx = math.random(1,randMaxIdx)
            local cText = ""
            if randIdx == 1 then
                cText = item.text
            elseif randIdx == 2 then
                cText = item.radText1
            elseif randIdx == 3 then
                cText = item.radText2
            end

            ---完成了结局的选项增加标志文字
            if item.specTextConfig and item.specTextConfig.textAdd and item.specTextConfig.textAdd.ownEnd1 then
                local isFinish = true
                local finishTextStr = TextDataMgr:getText(item.specTextConfig.textAdd.text)
                for k,v in ipairs(item.specTextConfig.textAdd.ownEnd1) do
                    local isFinishEndIds = DatingDataMgr:isFinishEndIds(v)
                    if not isFinishEndIds then
                        isFinish = false
                        break
                    end
                end
                if isFinish then
                    cText = cText..finishTextStr
                end
            end



            self["textArea_option_"..i]:setString(cText);

            self["button_option_"..i].item = item;
            self["button_option_"..i].id = tonumber(self["button_option_"..i].jumpId)

            local bt = self["button_option_"..i]
            local lb = self["textArea_option_" .. i]
            lb:setPosition(me.p(lb:getPosition().x, lb.orgy))
            bt.Label_none:hide()
            local index = table.indexOf(self.serverJumpTable,self["button_option_"..i].jumpId)
            if index == -1 then
                local configData = self["button_option_"..i].data
                if configData.condition  then
                    if configData.condition.showType == 2 then
                        self["button_option_"..i].Label_none:show()
                        lb:setPosition(me.p(lb:getPosition().x, lb.orgy + bt.Label_none:getSize().height*0.5))
                    end
                end
            end
        end
    end

    local jumpConfig = self.itemData.jumpConfig
    if jumpConfig then
        local rJump = jumpConfig.rJump
        local addjump = jumpConfig.addjump
        local deljump = jumpConfig.deljump
        for i = #id_tab, 1, -1 do
            if (rJump and id_tab[i] == rJump) then
                table.remove(id_tab,i)
            end

            if addjump then
                for idj, v in ipairs(addjump) do
                    if id_tab[i] == v.jump then
                        table.remove(id_tab,i)
                    end
                end
            end
        end
    end

    local num = #id_tab

    print("id_tab ",id_tab)

    for i=1,3 do
        self["button_option_"..i]:setOpacity(255)
        local isHave = false
        for it, v in ipairs(id_tab) do
            if self["button_option_"..i].jumpId == v then
                isHave = true
                break
            end
        end
        self["button_option_"..i].isHave = isHave
        if not isHave then
            self["button_option_"..i]:hide()
        else
            self["button_option_"..i]:show()
            self["button_option_"..i]:setGrayEnabled(false)
            self["button_option_"..i]:setTouchEnabled(true)
            local index = table.indexOf(self.serverJumpTable,self["button_option_"..i].jumpId)
            if index == -1 then
                local configData = self["button_option_"..i].data
                if configData.condition then
                    if configData.condition.showType == 1 then
                        self["button_option_"..i]:hide()
                    elseif configData.condition.showType == 2 then
                        self["button_option_"..i]:setGrayEnabled(true)
                    end
                end
            end
        end


    end

    local optionItemList = {}

    for i = 1, 3 do
        if self["button_option_"..i].isHave then
            local optionItem = self["button_option_"..i]
            table.insert(optionItemList,optionItem)
        end
    end

    if #optionItemList == 1 then
        print("类型1")
        optionItemList[1]:Pos(self["button_option_" .. 2].savePos)
    elseif #optionItemList == 2 then
        print("类型2")
        optionItemList[2]:Pos(self["button_option_" .. 2].savePos.x,326)
        optionItemList[1]:Pos(self["button_option_" .. 1].savePos.x,426)
    elseif #optionItemList == 3 then
        print("类型3")
        optionItemList[3]:Pos(self["button_option_" .. 3].savePos)
        optionItemList[2]:Pos(self["button_option_" .. 2].savePos)
        optionItemList[1]:Pos(self["button_option_" .. 1].savePos)
    else
    end

    local deyTime = 0
    for i=1,3 do
        self["button_option_" .. i].select = TFDirector:getChildByPath(self["button_option_" .. i],"Image_select"):hide()
        self["button_option_" .. i].select1 = TFDirector:getChildByPath(self["button_option_" .. i],"Image_datingOptionView_1"):hide()
        self["button_option_" .. i]:stopAllActions()
        self["button_option_" .. i]:setTouchEnabled(false)
        local toPos = self["button_option_" .. i]:Pos()
        --self["button_option_" .. i]:PosX(toPos.x-1200)
        --local action = Sequence:createWithTwoActions(DelayTime:create(0.1+(0.1*(i-1))), MoveTo:create(0.25,toPos))
        self["button_option_" .. i]:PosY(toPos.y+20)
        self["button_option_" .. i]:setOpacity(0)
        local spawnArr = {MoveTo:create(0.05,toPos),CCFadeIn:create(0.05)}
        local ac = {
            DelayTime:create((0.05*(i-1))),
            CCSpawn:create(spawnArr)
        }
        local action = Sequence:create(ac)
        self["button_option_" .. i]:runAction(action)
    end

    deyTime = deyTime + 0.3
    local function changeTouchState()
        if callback then
            callback()
        else
            for i=1,3 do
                self["button_option_" .. i]:setTouchEnabled(true)
                local jumpId = self["button_option_"..i].jumpId
                if jumpId then
                    local index = table.indexOf(self.serverJumpTable,jumpId)
                    if index == -1 then
                        local configData = self["button_option_"..i].data
                        if configData.condition then
                            if configData.condition.showType == 1 then
                                self["button_option_"..i]:hide()
                            elseif configData.condition.showType == 2 then
                                self["button_option_" .. i]:setTouchEnabled(false)
                            end
                        end
                    end
                end
            end
        end
    end

    local changeTouchAc = {
        DelayTime:create(deyTime),
        CallFunc:create(changeTouchState)
    }

    self.ui:runAction(Sequence:create(changeTouchAc))
end

function DatingOptionView:showOption6(tab, callback)
    self:showPanelOption(6)

    local id_tab = clone(tab)


    for i = 1,3 do
        self["button_option_6_"..i].jumpId = nil
        if id_tab[i] then
            self["button_option_6_"..i].jumpId = id_tab[i]
            self["button_option_6_"..i].data = self.data[tonumber(id_tab[i])]

            local item = self["button_option_6_"..i].data;

            local randMaxIdx = 1
            if item.radText1 and #item.radText1 > 0 then
                randMaxIdx = randMaxIdx + 1
            elseif item.radText2 and #item.radText2 > 0 then
                randMaxIdx = randMaxIdx + 1
            end
            local randIdx = math.random(1,randMaxIdx)
            local cText = ""
            if randIdx == 1 then
                cText = item.text
            elseif randIdx == 2 then
                cText = item.radText1
            elseif randIdx == 3 then
                cText = item.radText2
            end

            ---完成了结局的选项增加标志文字
            if item.specTextConfig and item.specTextConfig.textAdd and item.specTextConfig.textAdd.ownEnd1 then
                local isFinish = true
                local finishTextStr = TextDataMgr:getText(item.specTextConfig.textAdd.text)
                for k,v in ipairs(item.specTextConfig.textAdd.ownEnd1) do
                    local isFinishEndIds = DatingDataMgr:isFinishEndIds(v)
                    if not isFinishEndIds then
                        isFinish = false
                        break
                    end
                end
                if isFinish then
                    cText = cText..finishTextStr
                end
            end



            self["textArea_option_6_"..i]:setString(cText);
            self["button_option_6_"..i].item = item;
            self["button_option_6_"..i].id = tonumber(self["button_option_6_"..i].jumpId)
        end
    end

    local jumpConfig = self.itemData.jumpConfig
    if jumpConfig then
        local rJump = jumpConfig.rJump
        local addjump = jumpConfig.addjump
        local deljump = jumpConfig.deljump
        for i = #id_tab, 1, -1 do
            if (rJump and id_tab[i] == rJump) then
                table.remove(id_tab,i)
            end

            if addjump then
                for idj, v in ipairs(addjump) do
                    if id_tab[i] == v.jump then
                        table.remove(id_tab,i)
                    end
                end
            end
        end
    end

    local num = #id_tab

    print("id_tab ",id_tab)

    for i=1,3 do
        self["button_option_6_"..i]:setOpacity(255)
        local isHave = false
        for it, v in ipairs(id_tab) do
            if self["button_option_6_"..i].jumpId == v then
                isHave = true
                break
            end
        end
        self["button_option_6_"..i].isHave = isHave
        if not isHave then
            self["button_option_6_"..i]:hide()
        else
            self["button_option_6_"..i]:show()
            self["button_option_6_"..i]:setGrayEnabled(false)
        end
    end

    local optionItemList = {}

    for i = 1, 3 do
        if self["button_option_6_"..i].isHave then
            local optionItem = self["button_option_6_"..i]
            table.insert(optionItemList,optionItem)
        end
    end

    if #optionItemList == 1 then
        optionItemList[1]:Pos(self["button_option_6_" .. 1].savePos)
    elseif #optionItemList == 2 then
        optionItemList[2]:Pos(785,self["button_option_6_" .. 2].savePos.y)
        optionItemList[1]:Pos(301,self["button_option_6_" .. 3].savePos.y)
    elseif #optionItemList == 3 then
        print("类型3")
        optionItemList[3]:Pos(self["button_option_6_" .. 3].savePos)
        optionItemList[2]:Pos(self["button_option_6_" .. 2].savePos)
        optionItemList[1]:Pos(self["button_option_6_" .. 1].savePos)
    else
    end

    local deyTime = 0
    for i=1,3 do
        self["button_option_6_" .. i].select = TFDirector:getChildByPath(self["button_option_6_" .. i],"Image_select"):hide()
        self["button_option_6_" .. i]:stopAllActions()
        self["button_option_6_" .. i]:setTouchEnabled(false)
        local toPos = self["button_option_6_" .. i]:Pos()
        --self["button_option_" .. i]:PosX(toPos.x-1200)
        --local action = Sequence:createWithTwoActions(DelayTime:create(0.1+(0.1*(i-1))), MoveTo:create(0.25,toPos))
        self["button_option_6_" .. i]:PosY(toPos.y+20)
        self["button_option_6_" .. i]:setOpacity(0)
        local spawnArr = {MoveTo:create(0.05,toPos),CCFadeIn:create(0.05)}
        local ac = {
            DelayTime:create((0.05*(i-1))),
            CCSpawn:create(spawnArr)
        }
        local action = Sequence:create(ac)
        self["button_option_6_" .. i]:runAction(action)
    end

    deyTime = deyTime + 0.3
    local function changeTouchState()
        if callback then
            callback()
        else
            for i=1,3 do
                self["button_option_6_" .. i]:setTouchEnabled(true)
            end
        end
    end

    local changeTouchAc = {
        DelayTime:create(deyTime),
        CallFunc:create(changeTouchState)
    }

    self.ui:runAction(Sequence:create(changeTouchAc))
end

--限时选项
function DatingOptionView:showOption1(id_tab, callback)
    self:showOption(id_tab, callback)
    self:showOptionLoadingBar()
    local addTime = self:checkAddOptionItem(id_tab)
    local delTime = self:checkDelOptionItem()

    local disTime = addTime

    if disTime then
        for i = 1, 3 do
            local optionItem = self["button_option_" .. i]
            if optionItem:isVisible() then
                optionItem:timeOut(function()
                    local pos = optionItem.savePos
                    print("pos ",pos)
                    --optionItem:moveTo(0.1,pos)
                    optionItem:Pos(pos)
                end,disTime-0.5)
            end
        end
    end
end

--看板娘区域选项
function DatingOptionView:showOption2(id_tab, callback)
    self:showPanelOption(2)
    local jumpConfig = self.itemData.jumpConfig or {roleArea = "roleArea1"}
    self.roleAreaView = require("lua.logic.dating.RoleAreaView"):new(jumpConfig.roleArea,
            function(jumpId)
                if self.callback_ then
                    local itemData = self.data[jumpId]
                    self.roleAreaView = nil
                    self.callback_(jumpId,itemData)
                    self:hide()
                end
            end
    )
    self:addLayerToNode(self.roleAreaView,self.Panel_option2)

    local ws = GameConfig.WS
    if ws.width  >= 1386 then
        self.roleAreaView:PosX((1136-1386)/2)
    end

end

--物品选项
function DatingOptionView:showOption3(id_tab, callback)
    self:showPanelOption(3)
    local jumpConfig = self.itemData.jumpConfig
    local goods = jumpConfig.image
    if not goods then
        Box("goods 为空")
        return
    end
    local imagePath1 = goods[1].imagePath
    local imagePath2 = goods[2].imagePath
    local jumpId1 = goods[1].jump
    local jumpId2 = goods[2].jump
    local itemData1 = self.data[jumpId1]
    local itemData2 = self.data[jumpId2]

    local Image_option1 = TFDirector:getChildByPath(self.Panel_option3, "Image_option1")
    local Image_option2 = TFDirector:getChildByPath(self.Panel_option3, "Image_option2")

    Image_option1:setTexture(imagePath1)
    Image_option2:setTexture(imagePath2)

    Image_option1:Touchable(true)
    Image_option1:onClick(function()
        if self.callback_ then
            self.callback_(jumpId1,itemData1)
            self:hide()
        end
    end)
    Image_option2:Touchable(true)
    Image_option2:onClick(function()
        if self.callback_ then
            self.callback_(jumpId2,itemData2)
            self:hide()
        end
    end)
end

--cg图片区域选项
function DatingOptionView:showOption4(id_tab, callback)
    self:showPanelOption(4)
    self:showOptionLoadingBarCg()
    self:hideOptionText()
    local jumpConfig = self.itemData.jumpConfig
    self.cgView = require("lua.logic.dating.SpecialCgView"):new(jumpConfig.cg,
            function(jumpId)
                if self.callback_ then
                    local itemData = self.data[jumpId]
                    self:stopOptionTimer()
                    self.cgView = nil
                    self.callback_(jumpId,itemData)
                    self:hide()
                end
            end,
            function(text,name)
                self:showOptionText(0.5,text,name)
            end
        )
    self:addLayerToNode(self.cgView,self.Panel_option4)

    local ws = GameConfig.WS

    if ws.width  >= 1386 then
        self.cgView:PosX((1136-1386)/2)
    end
end

function DatingOptionView:loadingOption5(id_tab,callback)

    --测试配置
    local configTest = {
        props = {
            {id = 535073,optionId = id_tab[1]},
            {id = 535074,optionId = id_tab[1]},
            {id = 535075,optionId = id_tab[1]},
            {text = "等一哈"},
            {text = "好像都没有",optionId = id_tab[2]}
        }
    }

    local jumpConfig = self.itemData.jumpConfig or configTest
    local props = jumpConfig.props or configTest.props
    if not props then
        Box("props 为空")
        return
    end
    print("propspropspropspropspropsprops ",props)

    self.optionListView:removeAllItems()
    self.item_ = {}
    for i, v in ipairs(props) do
        local optionItem = self.Panel_option5.item:clone()
        optionItem.data = v
        self.item_[i] = optionItem
        self:initItem(optionItem,callback)
        self.optionListView:pushBackCustomItem(optionItem)
    end

    for i, v in ipairs(self.item_) do
        local item = v
        item.touch:onClick(function()
            self:hide()
            if callback then
                callback()
            end
            if self.callback_ then
                if item.data.optionId then
                    local itemData = self.data[item.data.optionId]
                    self.callback_(item.data.optionId,itemData)
                else
                    self.callback_(-1)
                end
            end
        end)
    end
end

function DatingOptionView:initItem(item,callback)
    item.touch = TFDirector:getChildByPath(item, "Panel_touch")
    item.touch:setTouchEnabled(true)
    local Panel_prop = TFDirector:getChildByPath(item,"Panel_prop"):hide()
    local starIdx = 1
    local starList = {}
    while true do
        local star = TFDirector:getChildByPath(Panel_prop, "Image_star0" .. starIdx)
        table.insert(starList,star)
        if not star then
            break
        end
        starIdx = starIdx + 1
    end
    local Label_name = TFDirector:getChildByPath(Panel_prop, "Label_name")
    local Label_num = TFDirector:getChildByPath(Panel_prop, "Label_num")
    local Image_prop = TFDirector:getChildByPath(Panel_prop, "Image_prop")

    local Panel_txt = TFDirector:getChildByPath(item,"Panel_txt"):hide()
    local Label_txt = TFDirector:getChildByPath(Panel_txt,"Label_txt")

    if item.data.id then
        Image_prop:setGrayEnabled(false)
        Panel_prop:show()
        Panel_txt:hide()
        local num = GoodsDataMgr:getItemCount(item.data.id)
        Label_num:setText(num)
        if num <= 0 then
            Image_prop:setGrayEnabled(true)
            item.touch:setTouchEnabled(false)
        end
        local itemCfg = GoodsDataMgr:getItemCfg(item.data.id)
        for i, v in ipairs(starList) do
            local visible = i <= itemCfg.star
            v:setVisible(visible)
        end
        Label_name:setTextById(itemCfg.nameTextId)
        Image_prop:setTexture(itemCfg.icon)
    elseif item.data.text then
        Panel_prop:hide()
        Panel_txt:show()
        Label_txt:setText(item.data.text)
    end
end

function DatingOptionView:showOption5(id_tab,callback)
    if not self.Panel_option5.scroll then
        Box("scroll为空！")
        return
    end
    self.optionListView = UIListView:create(self.Panel_option5.scroll)
    self.optionListView:setItemsMargin(40)
    self:loadingOption5(id_tab,callback)
    self:showPanelOption(5)
end

function DatingOptionView:showOptionText(time,text,name)
    local Image_textBg = TFDirector:getChildByPath(self.Panel_option4, "Image_textBg")
    self:hideOptionText()
    if time then
        Image_textBg:setOpacity(0)
        Image_textBg:fadeIn(time)
    else
        Image_textBg:setOpacity(255)
    end

    if text then
        local TextArea_talking = TFDirector:getChildByPath(self.Panel_option4, "TextArea_talking")
        TextArea_talking:setText(text)
        local Image_nameBottom = TFDirector:getChildByPath(self.Panel_option4, "Image_nameBottom")
        if name and #name > 0 then
            Image_nameBottom:show()
            local Label_name = TFDirector:getChildByPath(Image_nameBottom, "Label_name")
            Label_name:setText(name)
        else
            Image_nameBottom:hide()
        end

        self.ui:timeOut(function()
            self:hideOptionText(0.5)
        end,3)
    end
end

function DatingOptionView:hideOptionText(time)
    local Image_textBg = TFDirector:getChildByPath(self.Panel_option4, "Image_textBg")
    if time then
        Image_textBg:setOpacity(255)
        Image_textBg:fadeOut(time)
    else
        Image_textBg:setOpacity(0)
    end
end

function DatingOptionView:showOptionLoadingBar()
    self.Image_loadingBar:show()
    local Image_pro = TFDirector:getChildByPath(self.Image_loadingBar, "Image_pro")
    Image_pro:Scale(1)

    local jumpConfig = self.itemData.jumpConfig
    local rJump = jumpConfig.rJump
    local time = 30
    if jumpConfig.lmtTime then
        time = jumpConfig.lmtTime
    end

    Image_pro:scaleTo(time,0)
    Image_pro:timeOut(function()
        if self.callback_ then
            self.callback_(rJump,self.data[rJump])
            self:hideOptionLoadingBar()
        end
    end,time)
end

function DatingOptionView:hideOptionLoadingBar()
    self.Image_loadingBar:hide()

    if self.itemData.optionType == 1 then
        self:hideOptionEffect1()
    end
end

function DatingOptionView:showOptionLoadingBarCg()
    local Image_pro = TFDirector:getChildByPath(self.Panel_option4, "Image_pro")

    local time = 30
    Image_pro:scaleTo(time,0)
    Image_pro:timeOut(function()
        if self.cgView then
            self.cgView:over()
        end
    end,time)
end

function DatingOptionView:hideOptionEffect1()
    --效果1，选项和倒计时条崩塌，播放【倒计时结束音效1】
    self:hide()
end

function DatingOptionView:hideOptionEffect2()
    --效果2，选项和倒计时条正常收起，播放【倒计时结束音效2】
    self.ui:fadeOut(3)
    self.ui:timeOut(function()
        self:hide()
        self.ui:setOpacity(255)
    end,3)
end

function DatingOptionView:onDatingOptionChoiceStatus(tOption)
    local callbackfun = function ()
        for idx=1,3 do
            local bt = self["button_option_"..idx]
            local lb = self["textArea_option_" .. idx]
            if bt:isVisible() then
                local bvalid = false
                for i,v in ipairs(tOption) do
                    if v == bt.id then
                        bvalid = true
                        lb:setPosition(me.p(lb:getPosition().x, lb.orgy))
                        bt.Label_none:hide()
                        bt.isenable = true
                        break
                    end
                end
                if not bvalid then
                    lb:setPosition(me.p(lb:getPosition().x, lb.orgy + bt.Label_none:getSize().height*0.5))
                    bt.Label_none:show()
                    bt.isenable = false
                end
                bt:setGrayEnabled(not bvalid)
            end
        end
    end
    callbackfun()
    --self:setSelectBoard(self.itemData.jump, callbackfun)
end

function DatingOptionView:registerEvents()
     EventMgr:addEventListener(self, EV_NEWCITY_DATING_EVENT.OptionChoiceStatus, handler(self.onDatingOptionChoiceStatus, self))
end

return DatingOptionView