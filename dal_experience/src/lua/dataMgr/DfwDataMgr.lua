
local BaseDataMgr = import(".BaseDataMgr")
local DfwDataMgr = class("DfwDataMgr", BaseDataMgr)

function DfwDataMgr:init()
    TFDirector:addProto(s2c.SACRIFICE_RESP_SPRING_SACRIFICE, self, self.onRecvSpringInfo)
    TFDirector:addProto(s2c.SACRIFICE_RESP_LUCKY_WHEEL, self, self.onRecvLuckyWheelInfo)
    TFDirector:addProto(s2c.SACRIFICE_RESPGET_AWARD_SACRIFICE, self, self.onRecvRollDice)
    TFDirector:addProto(s2c.SACRIFICE_RESP_ADD_BUFF, self, self.onRecvAddBuff)
    TFDirector:addProto(s2c.SACRIFICE_CELL_EVENT, self, self.onRecvSpacialCellEvent)
    TFDirector:addProto(s2c.SACRIFICE_CHANG_CELL_INFO, self, self.onRecvSpacialCellChange)
    TFDirector:addProto(s2c.SACRIFICE_RECORD_BUFF_LIST, self, self.onRecvUsedBuffId)

    self.chessesMap_ = TabDataMgr:getData("Chesses")

    -- 色子
    self.chessesDiceMap_ = TabDataMgr:getData("ChessesDice")
    self.chessesDice_ = {}
    for k, v in pairs(self.chessesDiceMap_) do
        table.insert(self.chessesDice_, k)
    end
    table.sort(self.chessesDice_, function(a, b)
                   local cfgA = self.chessesDiceMap_[a]
                   local cfgB = self.chessesDiceMap_[b]
                   return cfgA.sort < cfgB.sort
    end)

    -- BUFF
    self.chessesBuffMap_ = TabDataMgr:getData("ChessesBuff")
    self.chessesBuff_ = {}
    for k, v in pairs(self.chessesBuffMap_) do
        table.insert(self.chessesBuff_, k)
    end
    table.sort(self.chessesBuff_, function(a, b)
                   local cfgA = self.chessesBuffMap_[a]
                   local cfgB = self.chessesBuffMap_[b]
                   return cfgA.sort < cfgB.sort
    end)

    -- 转盘
    self.turntableMap_ = TabDataMgr:getData("Turntable")
    self.turntable_ = {}
    for k ,v in pairs(self.turntableMap_) do
        table.insert(self.turntable_, k)
    end
    table.sort(self.turntable_, function(a, b)
                   local cfgA = self.turntableMap_[a]
                   local cfgB = self.turntableMap_[b]
                   return cfgA.sort < cfgB.sort
    end)

    -- 手帐
    self.handAccountMap_ = TabDataMgr:getData("HandAccount")
    self.handAccount_ = {}
    local handAccount = {}
    for k, v in pairs(self.handAccountMap_) do
        handAccount[v.type] = handAccount[v.type] or {}
        table.insert(handAccount[v.type], k)
    end

    for k, v in pairs(handAccount) do
        table.sort(v, function(a, b)
                       local cfgA = self.handAccountMap_[a]
                       local cfgB = self.handAccountMap_[b]
                       return cfgA.pageNum < cfgB.pageNum
        end)
    end

    self.handAccount_ = {}
    for k, v in pairs(handAccount) do
        self.handAccount_[k] = v
    end

    -- 事件
    self.chessesEventMap_ = TabDataMgr:getData("ChessesEvent")
end

function DfwDataMgr:reset()

end

function DfwDataMgr:onLogin()

end

function DfwDataMgr:onEnterMain()

end

function DfwDataMgr:getChessesCfg(cid)
    return self.chessesMap_[cid]
end

function DfwDataMgr:getChessesDice()
    return self.chessesDice_
end

function DfwDataMgr:getChessesDiceCfg(cid)
    return self.chessesDiceMap_[cid]
end

function DfwDataMgr:getChessesBuff()
    return self.chessesBuff_
end

function DfwDataMgr:getChessesBuffCfg(cid)
    return self.chessesBuffMap_[cid]
end

function DfwDataMgr:getTurntable()
    return self.turntable_
end

function DfwDataMgr:getTurntableCfg(cid)
    return self.turntableMap_[cid]
end

function DfwDataMgr:getHandAccountCfg(cid)
    return self.handAccountMap_[cid]
end

function DfwDataMgr:getHandAccount(type)
    return self.handAccount_[type]
end

function DfwDataMgr:getTurnInfo()
    return self.turnInfo_
end

function DfwDataMgr:getCellInfo()
    return self.cellInfo_
end

function DfwDataMgr:getTurntableTimes(cid)
    local times = 0
    if self.turnInfo_.turnTimes then
        times = self.turnInfo_.turnTimes[cid] or 0
    end
    return times
end

function DfwDataMgr:getChessesEventCfg(cid)
    return self.chessesEventMap_[cid]
end

function DfwDataMgr:send_SACRIFICE_REQ_SPRING_SACRIFICE()
    TFDirector:send(c2s.SACRIFICE_REQ_SPRING_SACRIFICE, {})
end

function DfwDataMgr:send_SACRIFICE_REQ_LUCKY_WHEEL(times)
    TFDirector:send(c2s.SACRIFICE_REQ_LUCKY_WHEEL, {times})
end

function DfwDataMgr:send_SACRIFICE_REQGET_AWARD_SACRIFICE(itemId, step)
    TFDirector:send(c2s.SACRIFICE_REQGET_AWARD_SACRIFICE, {itemId, step})
end

function DfwDataMgr:send_SACRIFICE_REQ_ADD_BUFF(itemId, param)
    TFDirector:send(c2s.SACRIFICE_REQ_ADD_BUFF, {itemId,param})
end

function DfwDataMgr:__turnInfoHandle()
    if self.turnInfo_ and self.turnInfo_.turnTimes then
        local turnTimes = {}
        local turnEffects = {}
        for i, v in ipairs(self.turnInfo_.turnTimes) do
            turnTimes[v.turnId] = v.times or 0
            turnEffects[v.turnId] = v.effectId
        end
        self.turnInfo_.turnTimes = turnTimes
        self.turnInfo_.turnEffects = turnEffects
    end
end

function DfwDataMgr:onRecvSpringInfo(event)
    local data = event.data

    self.turnInfo_ = data.turnInfo
    self:__turnInfoHandle()

    self.cellInfo_ = data.cellInfo

    EventMgr:dispatchEvent(EV_DFW_ENTER_MAIN)
end

function DfwDataMgr:onRecvLuckyWheelInfo(event)
    local data = event.data
    self.turnInfo_ = data.turnInfo
    self:__turnInfoHandle()
    EventMgr:dispatchEvent(EV_DFW_LUCKY_WHEEL, data, data.rewards)
end

function DfwDataMgr:onRecvRollDice(event)
    local data = event.data

    local cellInfo = self.cellInfo_
    self.cellInfo_ = data.cellInfo

    EventMgr:dispatchEvent(EV_DFW_ROLL_DICE, cellInfo.location, data.awardStep, data.buffStep, data.awardInfo, data.eventAward)
end

function DfwDataMgr:onRecvAddBuff(event)
    local data = event.data

    self.cellInfo_.buffIds = data.buffIds
    EventMgr:dispatchEvent(EV_DFW_UPDATE_BUFF)
end

function DfwDataMgr:setUseItemStatus( specialItemId )
    -- body
    if not self.specialItemId or  not specialItemId then
        self.specialItemId = specialItemId
        EventMgr:dispatchEvent(EV_DFW_USE_SPECIAL_ITEM)
    end
end

function DfwDataMgr:getUseItemStatus(  )
    -- body
    return self.specialItemId 
end

function DfwDataMgr:onRecvSpacialCellEvent(event)
    -- body
    local data = event.data
    self.cellInfo_.event = data
end

function DfwDataMgr:onRecvSpacialCellChange(event)
    -- body
    local data = event.data
    self.cellInfo_.cellIds[data.location + self.cellInfo_.location] = data.chessesId
    EventMgr:dispatchEvent(EV_DFW_USE_SPECIAL_ITEM)
end

function DfwDataMgr:onRecvUsedBuffId(event)
    local data = event.data
    self.cellInfo_.list = buffId
end

return DfwDataMgr:new()
