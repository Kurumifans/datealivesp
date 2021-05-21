--[[
    @desc：TaskTrainingExpChooseView
    @date: 2021-04-25 16:48:35
]]

local TaskTrainingExpChooseView = class("TaskTrainingExpChooseView",BaseLayer)

function TaskTrainingExpChooseView:initData()

end

function TaskTrainingExpChooseView:ctor(...)
    self.super.ctor(self)
    self:initData(...)
    self:showPopAnim(true)
    self:init("lua.uiconfig.task.taskTrainingExpChooseView")
end

function TaskTrainingExpChooseView:initUI(ui)
    self.super.initUI(self,ui)
end

function TaskTrainingExpChooseView:registerEvents()
    self._ui.Button_close:onClick(function()
        AlertManager:close(self)
    end)

    self._ui.Slider_levelBefore:addMEListener(
        TFSLIDER_CHANGED,
        function(...)
            local percent = self._ui.Slider_levelBefore:getPercent()
            self._ui.lab_afterLvBefore:setText(percent)
        end
    )

    self._ui.Slider_levelAfter:addMEListener(
        TFSLIDER_CHANGED,
        function(...)
            local percent = self._ui.Slider_levelAfter:getPercent()
            self._ui.lab_afterLvAfter:setText(percent)
        end
    )
end

return TaskTrainingExpChooseView