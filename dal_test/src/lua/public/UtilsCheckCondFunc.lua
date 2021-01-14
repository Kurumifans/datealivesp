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
local UtilsCheckCondFunc = class("UtilsCheckCondFunc")

function UtilsCheckCondFunc.check_itemState( parama )
	-- body
	local itemId, num = next(parama)
	return GoodsDataMgr:getItemCount(itemId) >= num
end

function UtilsCheckCondFunc.check_worldActorNumByChildType( parama )
	-- body
	if not WorldRoomDataMgr:getCurControl() or not WorldRoomDataMgr:getCurControl().getActorNumByChildType or #parama < 3 then
		return false
	end

	local  cmpType = parama[3]
	if cmpType == 1 then
		return WorldRoomDataMgr:getCurControl():getActorNumByChildType(parama[1]) <= parama[2]
	elseif cmpType == 2 then
		return WorldRoomDataMgr:getCurControl():getActorNumByChildType(parama[1]) >= parama[2]
	elseif cmpType == 3 then
		return WorldRoomDataMgr:getCurControl():getActorNumByChildType(parama[1]) == parama[2]
	elseif cmpType == 4 then
		return WorldRoomDataMgr:getCurControl():getActorNumByChildType(parama[1]) < parama[2]
	elseif cmpType == 5 then
		return WorldRoomDataMgr:getCurControl():getActorNumByChildType(parama[1]) > parama[2]
	end
	return false
end

function UtilsCheckCondFunc.check_catId( parama )
	-- body
	if not parama then return false end
	local catInfo = MaokaActivityMgr:getCatInfo(parama)
	return catInfo and catInfo.taskId == 0
end

function UtilsCheckCondFunc.check_catToyList( parama )
	-- body
	if not parama then return false end
	return MaokaActivityMgr:getToyInfo(parama) and true or false
end

function UtilsCheckCondFunc.check_catMaidId( parama )
	if not parama then return false end
	return MaokaActivityMgr:getMaidId() == parama
end

return UtilsCheckCondFunc