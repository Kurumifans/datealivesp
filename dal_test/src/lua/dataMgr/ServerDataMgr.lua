
local BaseDataMgr = import(".BaseDataMgr")
local ServerDataMgr = class("ServerDataMgr", BaseDataMgr)

function ServerDataMgr:init()
    self.serverTime_ = 0
    self.onlineTime_ = 0
    self.localTime_ = 0
    self.server_ = {
        ["chengxu"] = {
            sort = 1,
            name = "内网-程序",
            list = {
                "liuziao",
                "ouyangcheng",
                "lanlin",
                "lihongji",
                "wanghongfu",
                "hujutao",
                "wanghongfu1",
                "xuzhishun",
            }
        },
        ["week"] = {
            sort = 2,
            name = "内网-week",
        },
        ["temp"] = {
            sort = 3,
            name = "内网-临时服",
            list = {
                "temp1",
                "temp2",
                "temp3",
            }
        },
        ["cehua"] = {
            sort = 4,
            name = "内网-策划服",
        },
        ["ceshi"] = {
            sort = 5,
            name = "内网-测试服(QA)",
        },
        ["develop"] = {
            sort = 6,
            name = "开发服务器",
        },
        ['tiyan'] = {
            sort = 18,
            name = "内网-体验服",
        },
        ["publish"] = {
            sort = 15,
            name = "内网-已发布",
        },
        ["cehua_ext"] = {
            sort = 14,
            name = "外网-预发布",
            url = "http://49.233.184.62:10001/account/login"
        },
        ["pub_test"] = {
            sort = 7,
            name = "外网-压测服",
            url = "http://140.143.181.116:8081/account/login"
        },
        ["tiyan_ext"] = {
            sort = 19,
            name = "外网-体验服",
            url = "http://uce.datealive.com:8081/account/login"
        },
        ["official"] = {
            sort = 9,
            name = "正式服-官网-腾讯",
            url = "https://uc.datealive.com:8082/account/login"
        },
        ["huawei"] = {
            sort = 13,
            name = "正式服-渠道-华为",
            url = "http://43.254.2.141:8081/account/login"
        },
    }
    self.gameSeverList = {}
    TFDirector:addProto(s2c.LOGIN_RESP_SERVER_TIME, self, self.onRecvServerTime)
end
-- [[登录服开始]]--
function ServerDataMgr:reset()

end

function ServerDataMgr:onLoginOut()

end

function ServerDataMgr:onLogin()
    self:timerOnlineFunc()
end

function ServerDataMgr:initServerTime(time)
    self.serverTime_ = time
    self.localTime_ = os.time()
end

function ServerDataMgr:getServerTime()
    local serverTime = self.serverTime_ + (os.time() - self.localTime_)
    return serverTime
end

function ServerDataMgr:getOnlineTime()
    return self.onlineTime_
end
    
function ServerDataMgr:timerOnlineFunc()
    if not self.timer_ then
        self.timer_ = TFDirector:addTimer(1000, -1, nil, function()
            self.onlineTime_ = self.onlineTime_ + 1
        end)
    end
end

function ServerDataMgr:onRecvServerTime(event)
    local data = event.data
    self:initServerTime(data.serverTime)
end

function ServerDataMgr:getServerList(serverGroup)
    if serverGroup then
        return self.server_[serverGroup]
    else
        return self.server_
    end
end
-- [[登录服结束]]--

-- [[游戏服开始]]--

function ServerDataMgr:setGameServerList(serverData)
    if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
        self.gameSeverList = {}
        serverData[2]= clone(serverData[1])
        serverData[2].groupName = serverData[1].groupName.."2"
        table.insert(self.gameSeverList,serverData[1]);
        table.insert(self.gameSeverList,serverData[2]);
        return
    end

    self.gameSeverList = serverData or {}
end

function ServerDataMgr:getGameServerList()
    return self.gameSeverList;
end

function ServerDataMgr:setCurrentServerIndex(index)
    self.currentServerIndex = index;
    local serverData = self.gameSeverList[index]
    CCUserDefault:sharedUserDefault():setIntegerForKey((TFDeviceInfo:getMachineOnlyID() or "serverKey"),index);

    local account,password = nil,nil;
    if CC_PLATFORM_WIN32 == CC_TARGET_PLATFORM then
        account,password = SaveManager:getUserInfoDemo();
    end

    SaveManager:saveUserInfoDemo(account,password,serverData.token,serverData.gameServerIp,serverData.gameServerPort);
end

function ServerDataMgr:getCurrentServerIndex()
    self.currentServerIndex = CCUserDefault:sharedUserDefault():getIntegerForKey((TFDeviceInfo:getMachineOnlyID() or "serverKey"));
    if self.currentServerIndex <= 0 then
        self.currentServerIndex = 1
    end

    return self.currentServerIndex or 1;
end

function ServerDataMgr:getCurrentServerName()
    local serverIndex = self:getCurrentServerIndex();
    if serverIndex > #self.gameSeverList then
        serverIndex = #self.gameSeverList;
    end
    return self.gameSeverList[serverIndex].groupName;
end

function ServerDataMgr:getCurrentServerInfo()
    local serverIndex = self:getCurrentServerIndex();
    if serverIndex > #self.gameSeverList then
        serverIndex = #self.gameSeverList;
    end
    return self.gameSeverList[serverIndex];
end

function ServerDataMgr:getCurrentServerID()
    local serverIndex = self:getCurrentServerIndex();
    if serverIndex > #self.gameSeverList then
        serverIndex = #self.gameSeverList;
    end
    return self.gameSeverList[serverIndex].serverId;
end

function ServerDataMgr:getServerGroupID(index)
    local serverIndex = index or self:getCurrentServerIndex();
    if serverIndex > #self.gameSeverList then
        serverIndex = #self.gameSeverList;
    end
    return self.gameSeverList[serverIndex].group_id or 0;
end

function ServerDataMgr:getCurrentServerHasRole(index)
    local serverIndex = index or self:getCurrentServerIndex();
    if serverIndex > #self.gameSeverList then
        serverIndex = #self.gameSeverList;
    end
    return self.gameSeverList[serverIndex].hasRole;
end
-- [[游戏服结束]]--

return ServerDataMgr:new()
