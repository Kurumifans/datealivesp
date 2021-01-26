
-- 配置名称 = {"键名",类型[,默认值[,是否本地缓存]]}

local function make(key, type_, defaultValue, isCache)
    assert(type(key) == "string")
    assert(type_ == "boolean" or type == "string" or type_ == "number")
    return {key, type_, defaultValue, isCache}
end

-- 七日狂欢主界面显示flag
GV_FULI_SEVENSIGNIN_FLAG = make("GV_FULI_SEVENSIGNIN_FLAG", "boolean", false, false)
-- 月卡弹窗红点提示
GV_MONTH_CARD_TIP = make("GV_MONTH_CARD_TIP", "boolean", false, false)
-- 副本准备界面剧情提示
GV_FUBEN_PREPLOT_FLAG = make("GV_FUBEN_PREPLOT_FLAG", "boolean", false, false)
-- 精灵契约提示
GV_ELF_CONTRACT_TIP = make("GV_ELF_CONTRACT_TIP", "boolean", false, false)
-- 是否进入过女仆咖啡厅
GV_COFFEE_IS_FIRSTENTER = make("GV_COFFEE_IS_FIRSTENTER_NEW01", "boolean", true, true)
