local LeagueHallView = class("LeagueHallView", BaseLayer)
require("lua.logic.common.ChooseMessageBox")

function LeagueHallView:initData(data)
    self.btnConfig_ = {
        {
            txt = 270350,
            idx = 1,
            isShow = true,
            iconImg = "ui/league/ui_24.png",
        },
        {
            txt = 270351,
            idx = 2,
            isShow = true,
            iconImg = "ui/league/ui_25.png",
        },
        {
            txt = 270352,
            idx = 3,
            isShow = true,
            iconImg = "ui/league/ui_23.png",
        },
        {
            txt = 63815,
            idx = 4,
            isShow = false,
            iconImg = "ui/league/ui_62.png",
        },
        {
            txt = 63814,
            idx = 5,
            isShow = false,
            iconImg = "ui/league/ui_63.png",
        },
    }
    self.defaultIdx = data and data.selectIdx or nil
    self.selectIndex_ = nil
    self.loadIndex = 1
    self.notifyTime = 0
    self.impeachTime = 0
    self.panels_ = {}
    self.maxLevel_ = TabDataMgr:getData("DiscreteData",9002).data.pmaxlvl
    local funtionCfg = FunctionDataMgr:getFunctionCfg(101)
    self.minLevel_ = funtionCfg.openLevel
    self.limitLevel_ = LeagueDataMgr:getJoinLimitLevel()
    LeagueDataMgr:setNoticeChangeRedPoint(false)
    LeagueDataMgr:sendReqGetPlayerUnionReCallRank(1)
end

function LeagueHallView:ctor(data)
    self.super.ctor(self,data)

    self:initData(data)
    self:init("lua.uiconfig.league.leagueHallView")
end

function LeagueHallView:initUI(ui)
    self.super.initUI(self,ui)
    self.ui = ui
    self.Panel_prefab = TFDirector:getChildByPath(self.ui, "Panel_prefab")
    self.Panel_tabItem = TFDirector:getChildByPath(self.Panel_prefab, "Panel_tabItem")
    self.Panel_member_item = TFDirector:getChildByPath(self.Panel_prefab, "Panel_member_item")
    self.Panel_change_items = TFDirector:getChildByPath(self.Panel_prefab, "Panel_change_items")
    self.Panel_date = TFDirector:getChildByPath(self.Panel_prefab, "Panel_date")

    self.Panel_infos = TFDirector:getChildByPath(self.ui, "Panel_infos")
    self.Button_modify_name = TFDirector:getChildByPath(self.Panel_infos, "Button_modify_name"):hide()
    self.Button_copy = TFDirector:getChildByPath(self.Panel_infos, "Button_copy")
    self.Button_edit_notice = TFDirector:getChildByPath(self.Panel_infos, "Button_edit_notice")
    local ScrollView_changes = TFDirector:getChildByPath(self.Panel_infos, "ScrollView_changes")
    local Image_scrollBar_changes = TFDirector:getChildByPath(self.Panel_infos, "Image_scrollBar_changes")
    local Image_scrollBarInner = TFDirector:getChildByPath(Image_scrollBar_changes, "Image_scrollBarInner")
    self.ScrollView_changes = UIListView:create(ScrollView_changes)
    self.ScrollView_changes:setItemsMargin(2)
    local scrollBar = UIScrollBar:create(Image_scrollBar_changes, Image_scrollBarInner)
    self.ScrollView_changes:setScrollBar(scrollBar)

    self.Panel_members = TFDirector:getChildByPath(self.ui,"Panel_members")
    self.ScrollView_members = TFDirector:getChildByPath(self.Panel_members, "ScrollView_members")
    local Image_scrollBar_member = TFDirector:getChildByPath(self.Panel_members, "Image_scrollBar_member")
    local Image_scrollBarInner1 = TFDirector:getChildByPath(Image_scrollBar_member, "Image_scrollBarInner")
    self.ScrollView_members_list = UIListView:create(self.ScrollView_members)
    self.ScrollView_members_list:setItemsMargin(10)
    local scrollBar1 = UIScrollBar:create(Image_scrollBar_member, Image_scrollBarInner1)
    self.ScrollView_members_list:setScrollBar(scrollBar1)
    self.Button_delate = TFDirector:getChildByPath(self.Panel_members, "Button_delate")
    self.Label_delate = TFDirector:getChildByPath(self.Button_delate, "Label_delate")
    self.Button_aply = TFDirector:getChildByPath(self.Panel_members, "Button_aply")
    self.Image_apply_red = TFDirector:getChildByPath(self.Button_aply, "Image_apply_red")
    self.Button_degree = TFDirector:getChildByPath(self.Panel_members, "Button_degree")
    self.Label_impeach_time = TFDirector:getChildByPath(self.Panel_members, "Label_impeach_time")

    self.Panel_touch = TFDirector:getChildByPath(self.ui, "Panel_touch")
    self.Panel_operate_frame = TFDirector:getChildByPath(self.Panel_members, "Panel_operate_frame")
    self.Panel_operate_frame:setVisible(false)
    self.Button_detail = TFDirector:getChildByPath(self.Panel_operate_frame, "Button_detail")
    self.Button_appoint = TFDirector:getChildByPath(self.Panel_operate_frame, "Button_appoint")
    self.Button_kick = TFDirector:getChildByPath(self.Panel_operate_frame, "Button_kick")

    self.Panel_setting = TFDirector:getChildByPath(self.ui,"Panel_setting")
    self.Panel_left = TFDirector:getChildByPath(self.Panel_setting, "Panel_left")
    self.Panel_right = TFDirector:getChildByPath(self.Panel_setting, "Panel_right")
    self.Label_league_name = TFDirector:getChildByPath(self.Panel_left, "Label_league_name")
    self.Image_flag = TFDirector:getChildByPath(self.Panel_left, "Image_flag")
    self.Label_league_level = TFDirector:getChildByPath(self.Panel_left, "Label_league_level")
    self.Button_change_flag = TFDirector:getChildByPath(self.Panel_left, "Button_change_flag")
    self.Image_flag_tip = TFDirector:getChildByPath(self.Button_change_flag, "Image_flag_tip")
    self.Button_modify = TFDirector:getChildByPath(self.Panel_left, "Button_modify"):hide()
    self.Button_quit = TFDirector:getChildByPath(self.Panel_left, "Button_quit")
    self.Button_disband = TFDirector:getChildByPath(self.Panel_left, "Button_disband")

    self.Panel_right = TFDirector:getChildByPath(self.Panel_right, "Panel_right")
    self.Label_notice = TFDirector:getChildByPath(self.Panel_right, "Label_notice")
    self.Panel_limit_level = TFDirector:getChildByPath(self.Panel_right, "Panel_limit_level")
    self.Label_slider_level = TFDirector:getChildByPath(self.Panel_right, "Label_slider_level")
    self.Slider_level = TFDirector:getChildByPath(self.Panel_right, "Slider_level")
    self.Button_save_level = TFDirector:getChildByPath(self.Panel_right, "Button_save_level")

    self.Button_edit = TFDirector:getChildByPath(self.Panel_right, "Button_edit")
    self.Button_set = TFDirector:getChildByPath(self.Panel_right, "Button_set")
    self.Label_tips = TFDirector:getChildByPath(self.Panel_right, "Label_tips")

    self.change_btns = {}
    self.change_flags = {}
    for i=1,3 do
        local btn = TFDirector:getChildByPath(self.Panel_right, "Button_open"..i)
        local Image_flag = TFDirector:getChildByPath(btn,"Image_flag")
        self.change_btns[#self.change_btns + 1] = btn
        self.change_flags[#self.change_flags + 1] = Image_flag
    end

    self.Panel_reward = TFDirector:getChildByPath(self.ui, "Panel_reward"):hide()
    self.label_title = TFDirector:getChildByPath(self.Panel_reward, "label_title")
    self.label_title:setTextById(63825)
    self.txt_score = TFDirector:getChildByPath(self.Panel_reward, "txt_score")
    self.img_score = TFDirector:getChildByPath(self.Panel_reward, "img_score")
    local reward_scroll = TFDirector:getChildByPath(self.Panel_reward, "reward_scroll")
    self.rewardList = UIListView:create(reward_scroll)
    self.rewardList:setItemsMargin(2)

    self.Panel_rank = TFDirector:getChildByPath(self.ui, "Panel_rank"):hide()
    self.btn_pre = TFDirector:getChildByPath(self.Panel_rank, "btn_pre")
    self.btn_next = TFDirector:getChildByPath(self.Panel_rank, "btn_next")
    self.img_page_bg = TFDirector:getChildByPath(self.Panel_rank, "img_page_bg")
    self.txt_page = TFDirector:getChildByPath(self.Panel_rank, "txt_page")
    self.panel_list = TFDirector:getChildByPath(self.Panel_rank, "panel_list")
    self.label_rank_tip = TFDirector:getChildByPath(self.Panel_rank, "label_rank_tip"):hide()

    self.img_award_item = TFDirector:getChildByPath(self.ui, "img_award_item"):hide()
    self.panel_rank_item = TFDirector:getChildByPath(self.ui, "panel_rank_item"):hide()

    local ScrollView_tab = TFDirector:getChildByPath(self.ui, "ScrollView_tab")
    self.ListView_tab = UIListView:create(ScrollView_tab)
    self.ListView_tab:setItemsMargin(4)

    self:initLeft()
    self:initTabView()

    if self.defaultIdx and self.defaultIdx > 3 then
        self.defaultIdx = 3
    end
    self:selectTabBtn(self.defaultIdx or 1)
end

--初始化列表
function LeagueHallView:initTabView()
    self.tableView = TFTableView:create()
    self.tableView:setTableViewSize(self.panel_list:getContentSize())
    self.tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
    self.tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)

    self.tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
    self.tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
    self.tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)

    self.tableView.logic = self
    self.panel_list:addChild(self.tableView)
end

function LeagueHallView.cellSizeForTable(table, idx)
    local self = table.logic
    local itemSize = self.panel_rank_item:getContentSize()
    return itemSize.height, itemSize.width
end

function LeagueHallView.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local self = table.logic

    if nil == cell then
        cell = TFTableViewCell:create()
        local itemCell = self.panel_rank_item:clone()
        itemCell:show()
        itemCell:setPosition(ccp(0, 0))
        cell.itemCell = itemCell
        cell:addChild(itemCell)
    end

    self:updateRankItem(cell.itemCell, idx + 1)

    return cell
end

function LeagueHallView:updateRankItem(itemCell, idx)
    local data = LeagueDataMgr.leagueBackInfo.playerReCallRank[idx]
    if not data then
        itemCell:hide()
        return
    end
    itemCell:show()
    local img_rank = TFDirector:getChildByPath(itemCell, "img_rank")
    local txt_rank = TFDirector:getChildByPath(itemCell, "txt_rank")
    local img_head_icon = TFDirector:getChildByPath(itemCell, "img_head_icon")
    local img_head_frame = TFDirector:getChildByPath(itemCell, "img_head_frame")
    local img_head_front = TFDirector:getChildByPath(itemCell, "img_head_front")
    local txt_name = TFDirector:getChildByPath(itemCell, "txt_name")
    local txt_level = TFDirector:getChildByPath(itemCell, "txt_level")
    local txt_score = TFDirector:getChildByPath(itemCell, "txt_score")

    if data.rank < 1 then
        img_rank:setVisible(false)
        txt_rank:setVisible(true)
        txt_rank:setTextById(263009)
    elseif data.rank <= 3 then
        img_rank:setVisible(true)
        txt_rank:setVisible(false)
        local num = 37 + data.rank
        img_rank:setTexture("ui/activity/assist/0"..num..".png")
    else
        txt_rank:setText(data.rank)
        img_rank:setVisible(false)
        txt_rank:setVisible(true)
    end
    txt_name:setText(data.playerName)
    txt_score:setText(data.recallScore)
    txt_level:setText("Lv." .. data.level)

    img_head_icon:setTexture(AvatarDataMgr:getAvatarIconPath(data.portraitCid))
    local avatarFrameIcon, avatarFrameEffect = AvatarDataMgr:getAvatarFrameIconPath(data.portraitFrameCid)
    img_head_front:setTexture(avatarFrameIcon)
    local headFrameEffect = img_head_front:getChildByName("headFrameEffect")
    if headFrameEffect then
        headFrameEffect:removeFromParent()
    end
    if avatarFrameEffect ~= "" then
        headFrameEffect = SkeletonAnimation:create(avatarFrameEffect)
        headFrameEffect:setAnchorPoint(ccp(0,0))
        headFrameEffect:setPosition(ccp(0,0))
        headFrameEffect:play("animation", true)
        headFrameEffect:setName("headFrameEffect")
        img_head_front:addChild(headFrameEffect, 1)
    end
end

function LeagueHallView.numberOfCellsInTableView(table)
    if LeagueDataMgr.leagueBackInfo then
        return #LeagueDataMgr.leagueBackInfo.playerReCallRank
    end
    return 0
end

function LeagueHallView:updateBackInfo()
    self:updateLeftTab()
    self:updateRank()
    self:updateMyScore()
    self:updateBackReward()
end

function LeagueHallView:updateLeftTab()
    local isOpen = false
    if LeagueDataMgr.leagueBackInfo then
        isOpen = LeagueDataMgr.leagueBackInfo.open
    end
    self.btnConfig_[4].isShow = isOpen
    self.btnConfig_[5].isShow = isOpen
    self.tabBtn_[4].Panel_tabItem:setVisible(isOpen)
    self.tabBtn_[5].Panel_tabItem:setVisible(isOpen)
end

function LeagueHallView:updateRank()
    self.tableView:reloadData()
    self.tableView:setScrollToBegin(false)
    self.btn_pre:hide()
    self.btn_next:hide()
    if not LeagueDataMgr.leagueBackInfo or #LeagueDataMgr.leagueBackInfo.playerReCallRank == 0 then 
        self.img_page_bg:hide()
        self.label_rank_tip:show()
        return
    end

    self.label_rank_tip:hide()
    self.img_page_bg:setVisible(LeagueDataMgr.leagueBackInfo.total > 1)
    self.txt_page:setText(LeagueDataMgr.leagueBackInfo.index)
    if LeagueDataMgr.leagueBackInfo.index > 1 then
        self.btn_pre:show()
    end

    if LeagueDataMgr.leagueBackInfo.index < LeagueDataMgr.leagueBackInfo.total then
        self.btn_next:show()
    end
end

function LeagueHallView:updateMyScore()
    local score = 0
    if LeagueDataMgr.leagueBackInfo and LeagueDataMgr.leagueBackInfo.score then
        score = LeagueDataMgr.leagueBackInfo.score
    end
    self.txt_score:setText(score)
    self.img_score:setPositionX(self.txt_score:getPositionX() - self.txt_score:getContentSize().width - 3)
end

function LeagueHallView:updateBackReward()
    local awardInfo = {}
    local myScore = 0
    if LeagueDataMgr.leagueBackInfo then
        awardInfo = LeagueDataMgr.leagueBackInfo.awardInfo or {}
        myScore = LeagueDataMgr.leagueBackInfo.score or 0
    end

    local items = self.rewardList:getItems()
    local gap = #awardInfo - #items
    for i = 1, math.abs(gap) do
        if gap > 0 then
            local itemCell = self.img_award_item:clone()
            itemCell:show()
            self.rewardList:pushBackCustomItem(itemCell)
        else
            self.rewardList:removeItem(1)
        end
    end

    for k, v in ipairs(awardInfo) do
        local item = self.rewardList:getItem(k)
        self:updateAwardItem(item, v, myScore)
    end
end

function LeagueHallView:updateAwardItem(item, data, myScore)
    local txt_score = TFDirector:getChildByPath(item, "txt_score")
    local label_state = TFDirector:getChildByPath(item, "label_state")
    local img_got = TFDirector:getChildByPath(item, "img_got"):hide()

    txt_score:setTextById(63817, data.awardScore)
    if myScore >= data.awardScore then
        img_got:show()
        label_state:hide()
    else
        img_got:hide()
        label_state:show()
    end

    local rewards = data.rewards or {}
    for i = 1, 4 do
        local cell = TFDirector:getChildByPath(item, "img_item" .. i)
        if not cell.goodsItem then
            local goodsItem = PrefabDataMgr:getPrefab("Panel_goodsItem"):clone()
            goodsItem:setScale(0.7)
            goodsItem:AddTo(cell):Pos(0,0):ZO(1)
            cell.goodsItem = goodsItem
        end

        cell.goodsItem:hide()
        if i <= #rewards then
            cell.goodsItem:show()
            PrefabDataMgr:setInfo(cell.goodsItem, rewards[i].id, rewards[i].num)
        end
    end
end

function LeagueHallView:onShow()
    self.super.onShow(self)
    self:updateRedPoints()
end

function LeagueHallView:initLeft()
    self.tabBtn_ = {}
    for i, v in ipairs(self.btnConfig_) do
        local Panel_tabItem = self.Panel_tabItem:clone()
        local item = {}
        Panel_tabItem:setVisible(v.isShow)
        item.Panel_tabItem = Panel_tabItem
        item.Label_name = TFDirector:getChildByPath(Panel_tabItem, "Label_name")
        item.Image_normal = TFDirector:getChildByPath(Panel_tabItem, "Image_normal")
        item.Image_select = TFDirector:getChildByPath(Panel_tabItem, "Image_select")
        item.Image_icon = TFDirector:getChildByPath(Panel_tabItem, "Image_icon")
        item.Image_touch = TFDirector:getChildByPath(Panel_tabItem, "Image_touch")
        item.Image_red_tips = TFDirector:getChildByPath(Panel_tabItem, "Image_red_tips"):hide()
        self.tabBtn_[v.idx] = item
        item.Image_icon:setTexture(v.iconImg)
        item.Label_name:setTextById(v.txt)
        item.Image_touch:setTouchEnabled(true)
        item.Image_touch:onClick(function()
            self:selectTabBtn(i)
        end)

        self.ListView_tab:pushBackCustomItem(Panel_tabItem)
    end
end

function LeagueHallView:selectTabBtn(index)
    if self.selectIndex_ == index then return end
    self.selectIndex_ = index

    for k, v in pairs(self.tabBtn_) do
        local isSelect = (k == index)
        v.Image_normal:setVisible(not isSelect)
        v.Image_select:setVisible(isSelect)
    end
    self:refreshRight()
end

function LeagueHallView:refreshRight()
    if self.selectIndex_ == 1 then
        self.Panel_infos:show()
        self.Panel_members:hide()
        self.Panel_setting:hide()
        self.Panel_reward:hide()
        self.Panel_rank:hide()
        self:refreshPanelInfos()
    elseif self.selectIndex_ == 2 then
        self.Panel_infos:hide()
        self.Panel_members:show()
        self.Panel_setting:hide()
        self.Panel_reward:hide()
        self.Panel_rank:hide()
        self:refreshPanelMembers()
    elseif self.selectIndex_ == 4 then
        self.Panel_infos:hide()
        self.Panel_members:hide()
        self.Panel_setting:hide()
        self.Panel_reward:show()
        self.Panel_rank:hide()
     elseif self.selectIndex_ == 5 then
        self.Panel_infos:hide()
        self.Panel_members:hide()
        self.Panel_setting:hide()
        self.Panel_reward:hide()
        self.Panel_rank:show()
    else
        self.Panel_infos:hide()
        self.Panel_members:hide()
        self.Panel_setting:show()
        self.Panel_reward:hide()
        self.Panel_rank:hide()
        self:refreshPanelSetting()
    end
    self:updateRedPoints()
end

function LeagueHallView:refreshPanelInfos()
    local Image_league_flag = TFDirector:getChildByPath(self.Panel_infos, "Image_league_flag")
    local Label_league_name = TFDirector:getChildByPath(self.Panel_infos, "Label_league_name")
    local Label_league_level_num = TFDirector:getChildByPath(self.Panel_infos, "Label_league_level_num")
    local Label_league_id_num = TFDirector:getChildByPath(self.Panel_infos, "Label_league_id_num")
    local Label_league_member_num = TFDirector:getChildByPath(self.Panel_infos, "Label_league_member_num")
    local Label_league_active_num = TFDirector:getChildByPath(self.Panel_infos, "Label_league_active_num")
    
    local Label_notice_desc = TFDirector:getChildByPath(self.Panel_infos, "Label_notice_desc")
    local unionData = LeagueDataMgr:getMyUnionInfo()
    if not unionData then
        return
    end
    Label_league_name:setText(unionData.name)
    Label_league_level_num:setText("Lv."..unionData.level)
    Label_league_id_num:setText(tostring(unionData.id))
    Label_league_member_num:setText(tostring(unionData.memberCount).."/"..LeagueDataMgr:getUnionMaxMemberCount())
    if unionData.lastWeekActive > 0 then
        Label_league_active_num:setText(tostring(unionData.lastWeekActive).."%")
    else
        Label_league_active_num:setText("--")
    end
    Label_notice_desc:setText(LeagueDataMgr:getUnionNotice())
    local emblemCfg = LeagueDataMgr:getEmblemCfgById(LeagueDataMgr:getUionEmblem())
    Image_league_flag:setTexture(emblemCfg.icon)

    local degree = LeagueDataMgr:getSelfDegree()
    self.Button_edit_notice:setVisible(LeagueDataMgr:checkDegreeOwnPermission(degree, EC_UNION_PERMISSION_Type.EDIT))
    self.Button_modify_name:setVisible(degree == EC_UNION_DEGREE_Type.HEAD)

    local count = #self.ScrollView_changes:getItems()
    local notifys = LeagueDataMgr:getNotifyDataBySortDate()
    if #notifys > count then
        for i = count + 1, 100 do
            local info = notifys[i]
            if not info then break end
            if info.notifyType == -1 then
                local item = self.Panel_date:clone()
                local Label_date = TFDirector:getChildByPath(item, "Label_date")
                Label_date:setText(info.prams)
                self.ScrollView_changes:pushBackCustomItem(item) 
            else
                local item = self.Panel_change_items:clone()
                local labelTime = TFDirector:getChildByPath(item, "Label_time")
                local Label_content = TFDirector:getChildByPath(item, "Label_content")
                Label_content:setDimensions(380, 0)
                local content = LeagueDataMgr:getNotifyContent(info)
                Label_content:setText(content)
                local height = Label_content:getContentSize().height + 20
                item:setContentSize(CCSizeMake(484, height))
                local hour, min, sec = Utils:getTime(math.floor(info.creatTime / 1000), true)
                labelTime:setText(hour..":"..min..":"..sec)
                labelTime:setPositionY(height - 10)
                Label_content:setPositionY(height - 10)
                self.ScrollView_changes:pushBackCustomItem(item) 
            end
            
        end
    end
    self.ScrollView_changes:scrollToBottom(0.1)
    if not self.updateTimer_ then
        self.updateTimer_ = TFDirector:addTimer(1000, -1, nil, handler(self.onUpdatePer, self))
    end
end

function LeagueHallView:onNoticeUpdate()
    local Label_notice_desc = TFDirector:getChildByPath(self.Panel_infos, "Label_notice_desc")
    Label_notice_desc:setText(LeagueDataMgr:getUnionNotice())
    self.Label_notice:setText(LeagueDataMgr:getUnionNotice())
end

function LeagueHallView:refreshPanelMembers()
    self.loadIndex = 1
    self.Panel_operate_frame:setVisible(false)
    self.selectMemberId = nil
    local members = LeagueDataMgr:getSortUnionMembers()
    local items = self.ScrollView_members_list:getItems()
    local gap = #items - #members
    for i = 1, math.abs(gap) do
        if gap > 0 then
            self.ScrollView_members_list:removeItem(1)
        end
    end
    
    local function loadMemberItem()
        if self.loadIndex > #members then
            return
        end
        local item = self.ScrollView_members_list:getItem(self.loadIndex)
        if not item then
            item = self.Panel_member_item:clone()
            self.ScrollView_members_list:pushBackCustomItem(item)
        end
        self:updateMemberItem(item, members[self.loadIndex])
        local seq = Sequence:create({
                DelayTime:create(0.05),
                CallFunc:create(function()
                        self.loadIndex = self.loadIndex + 1
                        loadMemberItem()
                end)
        })
        self.Panel_members:stopAllActions()
        self.Panel_members:runAction(seq)
    end
    loadMemberItem()
    self:refreshImpatchUI()
end

function LeagueHallView:refreshImpatchUI()
    self:updatePreparButtonsState()
    self:onUpdateImpeachTime()
end

function LeagueHallView:updatePreparButtonsState()
    self.Button_delate:setVisible(false)
    self.Button_aply:setVisible(false)
    self.Button_degree:setVisible(true)
    local memberInfo = LeagueDataMgr:getMemberInfoByPlayerId(MainPlayer:getPlayerId())
    if not memberInfo then
        return
    end
    self.Button_aply:setVisible(LeagueDataMgr:checkDegreeOwnPermission(memberInfo.degree, EC_UNION_PERMISSION_Type.APPLY))
    if not self.Button_aply:isVisible() then
        self.Button_delate:setPositionX(self.Button_aply:getPositionX())
    end
    local stage = LeagueDataMgr:getEnableImpatchState()
    if stage == 2 then
        self.Button_delate:setVisible(true)
        self.Label_delate:setTextById(270365)
    elseif stage == 3 then
        self.Button_delate:setVisible(true)
        self.Label_delate:setTextById(270366)
    end
end

function LeagueHallView:updateMemberItem(item, data)
    local Image_hero_icon = TFDirector:getChildByPath(item, "Image_hero_icon")
    local Image_hero_frame_cover = TFDirector:getChildByPath(item, "Image_hero_frame_cover")
    local Label_name = TFDirector:getChildByPath(item, "Label_name")
    local Label_power = TFDirector:getChildByPath(item, "Label_power")
    local Label_degree = TFDirector:getChildByPath(item, "Label_degree")
    local Label_state = TFDirector:getChildByPath(item, "Label_state")
    local Label_level = TFDirector:getChildByPath(item, "Label_level")
    local Label_dedication_num1 = TFDirector:getChildByPath(item, "Label_dedication_num1")
    local Label_dedication_num2 = TFDirector:getChildByPath(item, "Label_dedication_num2")
    local Image_check = TFDirector:getChildByPath(item, "Image_check")

    Image_check:setVisible(MainPlayer:getPlayerId() ~= data.playerId)
    Image_hero_icon:setTexture(AvatarDataMgr:getAvatarIconPath(data.portraitCid))
    local avatarFrameIcon,avatarFrameEffect = AvatarDataMgr:getAvatarFrameIconPath(data.portraitFrameCid)
    Image_hero_frame_cover:setTexture(avatarFrameIcon)
    local headFrameEffect = Image_hero_frame_cover:getChildByName("headFrameEffect")
    if headFrameEffect then
        headFrameEffect:removeFromParent()
    end
    if avatarFrameEffect ~= "" then
        headFrameEffect = SkeletonAnimation:create(avatarFrameEffect)
        headFrameEffect:setAnchorPoint(ccp(0,0))
        headFrameEffect:setPosition(ccp(0,0))
        headFrameEffect:play("animation", true)
        headFrameEffect:setName("headFrameEffect")
        Image_hero_frame_cover:addChild(headFrameEffect, 1)
    end

    Label_name:setText(data.name)
    Label_power:setText(tostring(data.fightPower))
    Label_degree:setVisible(data.degree < EC_UNION_DEGREE_Type.MEMBER)
    Label_degree:setText(LeagueDataMgr:getDegreeName(data.degree))
    if data.online then
        Label_state:setTextById(270446)
    else
        local nowDate = Utils:getUTCDate(ServerDataMgr:getServerTime())
        local lastLoginDate = Utils:getUTCDate(data.lastLoginTime / 1000)
        local diffDate = TFDate.diff(nowDate, lastLoginDate)
        local day = diffDate:spandays()
        local hour = diffDate:spanhours() + day * 24
        local min = diffDate:spanminutes()
        if day >= 1 then
            local year, month, day1 = Utils:getDate(data.lastLoginTime / 1000, true)
            Label_state:setString(year.."-"..month.."-"..day1)
        elseif hour >= 1 then
            Label_state:setTextById(270464, math.floor(hour))
        else
            Label_state:setTextById(270463, math.max(1, math.floor(min)))
        end
    end
    Label_level:setText("Lv "..data.lvl)
    Label_dedication_num1:setText(tostring(data.weekContribution))
    Label_dedication_num2:setText(tostring(data.allContribution))
    
    item:setTouchEnabled(true)
    item:onClick(function()
        if MainPlayer:getPlayerId() == data.playerId then
            self.Panel_operate_frame:setVisible(false)
            Utils:showTips(270444)
            return
        end
        local memberInfo = LeagueDataMgr:getMemberInfoByPlayerId(MainPlayer:getPlayerId())
        if memberInfo and memberInfo.degree >= EC_UNION_DEGREE_Type.ELITE then
            MainPlayer:sendPlayerId(data.playerId)
            return
        end
        self.selectMemberId = data.playerId
        local pos = Image_hero_icon:getParent():convertToWorldSpaceAR(Image_hero_icon:getPosition())
        pos.x = pos.x + 200
        pos.y = math.max(80, pos.y - 180)
        self.Panel_operate_frame:setPosition(ccp(pos.x, pos.y))
        self:updateOperateFrame()
    end)
end

function LeagueHallView:updateOperateFrame()
    self.Panel_operate_frame:setVisible(true)
    local memberInfo = LeagueDataMgr:getMemberInfoByPlayerId(MainPlayer:getPlayerId())
    if memberInfo then
        self.Button_detail:setVisible(true)
        self.Button_appoint:setVisible(LeagueDataMgr:checkDegreeOwnPermission(memberInfo.degree, EC_UNION_PERMISSION_Type.CHANGE_DEGREE))
        self.Button_kick:setVisible(LeagueDataMgr:checkDegreeOwnPermission(memberInfo.degree, EC_UNION_PERMISSION_Type.KICK))
    else
        self.Panel_operate_frame:setVisible(false)
    end
end

function LeagueHallView:refreshPanelSetting()
    local degree = LeagueDataMgr:getSelfDegree()
    self.Button_edit:setVisible(LeagueDataMgr:checkDegreeOwnPermission(degree, EC_UNION_PERMISSION_Type.EDIT))
    self.Button_change_flag:setVisible(LeagueDataMgr:checkDegreeOwnPermission(degree, EC_UNION_PERMISSION_Type.CHANGE_FLAG))
    self.Button_disband:setVisible(degree == EC_UNION_DEGREE_Type.HEAD)
    self.Button_modify:setVisible(degree == EC_UNION_DEGREE_Type.HEAD)
    self.Button_quit:setVisible(degree > EC_UNION_DEGREE_Type.HEAD)
    local openLimit = LeagueDataMgr:checkDegreeOwnPermission(degree, EC_UNION_PERMISSION_Type.OPEN_LIMIT)
    local openApply = LeagueDataMgr:checkDegreeOwnPermission(degree, EC_UNION_PERMISSION_Type.OPEN_APPLY)
    local openAutoJoin = LeagueDataMgr:checkDegreeOwnPermission(degree, EC_UNION_PERMISSION_Type.OPEN_AUTO_JOIN)
    self.Panel_limit_level:setVisible(openLimit)
    self.Button_save_level:setTouchEnabled(openLimit)
    self.Button_save_level:setGrayEnabled(not openLimit)
    for i=1,3 do
        local btn = self.change_btns[i]
        local image_flag = self.change_flags[i]
        local saveState = LeagueDataMgr:getCurSettingStateByType(i)
        if saveState then
            image_flag:setPositionX(33)
        else
            image_flag:setPositionX(-33)
        end
        if i == 1 then
            btn:setTouchEnabled(openApply)
            image_flag:setGrayEnabled(not openApply)
        elseif i == 2 then
            btn:setTouchEnabled(openLimit)
            image_flag:setGrayEnabled(not openLimit)
        elseif i == 3 then
            btn:setTouchEnabled(openAutoJoin)
            image_flag:setGrayEnabled(not openAutoJoin)
        end
    end
    self.Slider_level:setTouchEnabled(openLimit)

    local saveState = LeagueDataMgr:getCurSettingStateByType(2)
    self.Panel_limit_level:setVisible(saveState)

    local unionData = LeagueDataMgr:getMyUnionInfo()
    self.Label_league_name:setText(unionData.name)
    self.Label_league_level:setText("Lv."..tostring(unionData.level))
    self.Label_notice:setText(LeagueDataMgr:getUnionNotice())
    local emblemCfg = LeagueDataMgr:getEmblemCfgById(LeagueDataMgr:getUionEmblem())
    self.Image_flag:setTexture(emblemCfg.icon)

    self:updateLevelLimit()
end

function LeagueHallView:updateLevelLimit()
    self.Label_slider_level:setTextById(800006, self.limitLevel_)
    local percent = math.floor((self.limitLevel_ - self.minLevel_) / (self.maxLevel_ - self.minLevel_) * 100)
    self.Slider_level:setPercent(percent)
end

function LeagueHallView:updateChangeFlagState(idx)
    for i,image_flag in ipairs(self.change_flags) do
        if i == idx then
            local saveState = LeagueDataMgr:getCurSettingStateByType(i)
            local changeType
            local param = ""
            if saveState then 
                param = "false"
            else
                param = "true"
            end
            if i == 1 then
                changeType = EC_UNION_EDIT_Type.OPEN_APLY
            elseif i == 2 then
                changeType = EC_UNION_EDIT_Type.OPEN_JOIN_LIMIT
                local limitLevel = LeagueDataMgr:getJoinLimitLevel()
                param = param..","..limitLevel
                self.Panel_limit_level:setVisible(not saveState)
                self:updateLevelLimit()
            else 
                changeType = EC_UNION_EDIT_Type.OPEN_AUTO_JOIN
            end
            LeagueDataMgr:UpdateUnionInfo(changeType, param)

            local movepos = me.p(33,0)
            if saveState then
                movepos = me.p(-33,0)
            end
            image_flag:stopAllActions()
            image_flag:runAction(MoveTo:create(0.1,movepos))
            break
        end
    end
end

--玩家信息
function LeagueHallView:onShowPlayerInfoView(playerInfo)
    local PlayerInfoView = require("lua.logic.chat.PlayerInfoView"):new(playerInfo)
    AlertManager:addLayer(PlayerInfoView,AlertManager.BLOCK_AND_GRAY_CLOSE)
    AlertManager:show()
end

function LeagueHallView:onUpdateImpeachTime()
    local suplsTime = LeagueDataMgr:getDelateSuplsTime()
    self.Label_impeach_time:setVisible(suplsTime > 0)
    if suplsTime > 0 then
        local day, hour, min, sec = Utils:getFuzzyDHMS(suplsTime, false)
        self.Label_impeach_time:setTextById(270353, day, hour, min)
        self.impeachTime = self.impeachTime + 1
        if self.impeachTime > 20 then
            self.impeachTime = 0
            LeagueDataMgr:ReqImpeachList()
        end
    end
end

function LeagueHallView:onUpdatePer()
    self.notifyTime = self.notifyTime + 1
    if self.notifyTime > 6 then
        self.notifyTime = 0
        LeagueDataMgr:ReqNotify()
    end
    if self.onUpdateImpeachTime then
        self:onUpdateImpeachTime()
    end
end

function LeagueHallView:removeEvents()
    self:removeUpdateTimer()
end

function LeagueHallView:removeUpdateTimer()
    if self.updateTimer_ then
        TFDirector:removeTimer(self.updateTimer_)
        self.updateTimer_ = nil
    end
end

function LeagueHallView:onQuitUnionBack()
    AlertManager:closeAll()
    AlertManager:changeScene(SceneType.MainScene)
end

function LeagueHallView:onDisbandUnionBack()
    AlertManager:closeAll()
    AlertManager:changeScene(SceneType.MainScene)
end

function LeagueHallView:onInfoChangeRefresh()
    self:refreshRight()
end

function LeagueHallView:updateRedPoints()
    for k, v in pairs(self.tabBtn_) do
        v.Image_red_tips:setVisible(false)
        if k == 2 then
            local redFlag = LeagueDataMgr:getApplyRedPointState()
            v.Image_red_tips:setVisible(redFlag)
            self.Image_apply_red:setVisible(redFlag)
        elseif k == 3 then
            v.Image_red_tips:setVisible(LeagueDataMgr.flagUnlockRed)
            self.Image_flag_tip:setVisible(LeagueDataMgr.flagUnlockRed)
        end
    end
end

function LeagueHallView:onNameUpdate()
    local Label_league_name = TFDirector:getChildByPath(self.Panel_infos, "Label_league_name")
    local unionData = LeagueDataMgr:getMyUnionInfo()
    if not unionData then
        return
    end
    Label_league_name:setText(unionData.name)
    self.Label_league_name:setText(unionData.name)
end

function LeagueHallView:registerEvents()
    EventMgr:addEventListener(self, EV_UNION_BASE_INFO_UPDATE, handler(self.refreshPanelInfos, self))
    EventMgr:addEventListener(self, EV_UNION_NOTIFY_UPDATE, handler(self.refreshPanelInfos, self))
    EventMgr:addEventListener(self, EV_UNION_MEMBER_UPDATE, handler(self.refreshPanelMembers, self))
    EventMgr:addEventListener(self, EV_RECV_PLAYERINFO, handler(self.onShowPlayerInfoView, self))
    EventMgr:addEventListener(self, EV_UNION_KICK_MEMBER, handler(self.refreshPanelMembers, self))
    EventMgr:addEventListener(self, EV_UNION_NOTICE_CHANGE, handler(self.onNoticeUpdate, self))
    EventMgr:addEventListener(self, EV_UNION_QUIT_UNION, handler(self.onQuitUnionBack, self))
    EventMgr:addEventListener(self, EV_UNION_DELATE_TIME_UPDATE, handler(self.refreshImpatchUI, self))
    EventMgr:addEventListener(self, EV_UNION_DIABAND_UNION, handler(self.onDisbandUnionBack, self))
    EventMgr:addEventListener(self, EV_UNION_FLAG_CHANGE, handler(self.onInfoChangeRefresh, self))
    EventMgr:addEventListener(self, EV_UNION_APPLY_UPDATE, handler(self.updateRedPoints, self))
    EventMgr:addEventListener(self, EV_UNION_INFO_RESET, handler(self.onInfoChangeRefresh, self))
    EventMgr:addEventListener(self, EV_UNION_MODIFY_NAME, handler(self.onNameUpdate, self))

    EventMgr:addEventListener(self, EV_LEAGUE_BACK_ALL_INFO, handler(self.updateBackInfo, self))
    EventMgr:addEventListener(self, EV_LEAGUE_BACK_SCORE_UPDATE, handler(self.updateMyScore, self))
    
    self.Slider_level:addMEListener(
        TFSLIDER_CHANGED,
        function(...)
            local percent = self.Slider_level:getPercent()
            local level = self.minLevel_ + math.floor((self.maxLevel_ - self.minLevel_) * percent / 100)
            self.limitLevel_ = clamp(level, self.minLevel_, self.maxLevel_)
            self.Label_slider_level:setTextById(800006, self.limitLevel_)
        end
    )

    self.Button_copy:onClick(function()
        local content = tostring(LeagueDataMgr:getSelfUnionId())
        TFDeviceInfo:copyToPasteBord(content)
        Utils:showTips(600010)
    end)

    self.Button_edit_notice:onClick(function() 
        if not FunctionDataMgr:getModifyFuncIsOpen() then
            Utils:showTips(63826)
            return
        end
        Utils:openView("league.EditNoticeView")
    end)

    self.Button_delate:onClick(function()
        self.Panel_operate_frame:setVisible(false)
        local stage = LeagueDataMgr:getEnableImpatchState()
        if stage == 2 then
            showChooseMessageBox(TextDataMgr:getText(270448), TextDataMgr:getText(270449), function()
                AlertManager:close()
                LeagueDataMgr:operateUnionMember(EC_UNIONType.IMPEACH_LEADER)
            end)
        elseif stage == 3 then
            Utils:openView("league.LeagueDelateInfoView")
        end
    end)

    self.Button_aply:onClick(function()
        self.Panel_operate_frame:setVisible(false)
        Utils:openView("league.LeagueApliesInfoView")
    end)

    self.Button_degree:onClick(function()
        self.Panel_operate_frame:setVisible(false)
        Utils:openView("league.LeagueDegreeView")
    end)

    self.Button_detail:onClick(function()
        MainPlayer:sendPlayerId(self.selectMemberId)
    end)

    self.Button_appoint:onClick(function()
        Utils:openView("league.LeagueDegreeView", {playerId = self.selectMemberId})
    end)

    self.Button_kick:onClick(function()
        local name = ""
        local info = LeagueDataMgr:getMemberInfoByPlayerId(self.selectMemberId)
        if info and info.name then
            name = info.name
        end
        showChooseMessageBox(TextDataMgr:getText(270450), TextDataMgr:getText(270451, name), function()
            print("showChooseMessageBox-----------", self.selectMemberId)
            AlertManager:close()
            LeagueDataMgr:operateUnionMember(EC_UNIONType.KICK, {self.selectMemberId})
        end)
    end)

    self.Button_change_flag:onClick(function()
        Utils:openView("league.LeagueFlagChangeView")
    end)

    self.Button_quit:onClick(function()
        showChooseMessageBox(TextDataMgr:getText(270460), TextDataMgr:getText(270461), function()
            AlertManager:close()
            LeagueDataMgr:operateUnionMember(EC_UNIONType.QUIT)
        end)
    end)

    self.Button_disband:onClick(function()
        showChooseMessageBox(TextDataMgr:getText(270452), TextDataMgr:getText(270453), function()
            AlertManager:close()
            LeagueDataMgr:DestroyUnion()
        end)
    end)

    self.Button_edit:onClick(function()
        if not FunctionDataMgr:getModifyFuncIsOpen() then
            Utils:showTips(63826)
            return
        end
        Utils:openView("league.EditNoticeView")
    end)

    self.Button_save_level:onClick(function()
        LeagueDataMgr:UpdateUnionInfo(EC_UNION_EDIT_Type.OPEN_JOIN_LIMIT, "true,"..self.limitLevel_)
        Utils:showTips(270454)
    end)

    self.Button_set:onClick(function()
        Utils:openView("league.EditJoinLimitView")
    end)

    for i,btn in ipairs(self.change_btns) do
        btn:onClick(function()
            self:updateChangeFlagState(i)
        end)
    end

    self.btn_pre:onClick(function()
        local index = 1
        if LeagueDataMgr.leagueBackInfo and LeagueDataMgr.leagueBackInfo.index then 
            index = LeagueDataMgr.leagueBackInfo.index
        end
        if index <= 1 then
            return
        end
        LeagueDataMgr:sendReqGetPlayerUnionReCallRank(index - 1)
    end)

    self.btn_next:onClick(function()
        local index = 1
        local total = 1
        if LeagueDataMgr.leagueBackInfo and LeagueDataMgr.leagueBackInfo.index then 
            index = LeagueDataMgr.leagueBackInfo.index
            total = LeagueDataMgr.leagueBackInfo.total
        end
        if index >= total then
            return
        end
        LeagueDataMgr:sendReqGetPlayerUnionReCallRank(index + 1)
    end)

    self.Button_modify:onClick(handler(self.modifyNameHandle, self))
    self.Button_modify_name:onClick(handler(self.modifyNameHandle, self))

    local function onTouchBegan(touch, location)
        if self.Panel_operate_frame:isVisible() then
            self.Panel_operate_frame:setVisible(false)
        end
        return true
    end

    local function onTouchMove(touch, location)
        
    end
    local function onTouchUp(touch, location)
       
    end
    self.Panel_touch:setTouchEnabled(true)
    self.Panel_touch:setSwallowTouch(false)
    self.Panel_touch:addMEListener(TFWIDGET_TOUCHBEGAN, onTouchBegan)
    self.Panel_touch:addMEListener(TFWIDGET_TOUCHMOVED, onTouchMove)
    self.Panel_touch:addMEListener(TFWIDGET_TOUCHENDED, onTouchUp)
end

function LeagueHallView:modifyNameHandle(sender)
      
    if not FunctionDataMgr:getModifyFuncIsOpen() then
        Utils:showTips(63826)
        return
    end
    Utils:openView("league.LeagueModifyName")
end

return LeagueHallView
