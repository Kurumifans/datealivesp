local SnowDayLittleGame = class("SnowDayLittleGame", BaseLayer)

local Radius = 300
local TipMap = {
	[1]={left=1,right= 6},
	[2]={left=2,right= 1},
	[3]={left=3,right= 2},
	[4]={left=4,right= 3},
	[5]={left=5,right= 4},
	[6]={left=6,right= 5},
}
local DeltaSpeed = 50--旋转速度衰减
local constValue = 50--旋转速度最小值

local Angle_2PI	 = 360
local Angle_PI	 = 180
local Angle_PI61 = 30
local Angle_PI31 = 60

local OriginRotateBy = {2, 0,-2,-4, 6, 4}	--碎花碎片从(0,1)垂直方向转到6个角度需要旋转的角度:60度的倍数


function SnowDayLittleGame:ctor(...)
	self.super.ctor(self)
	self:initData(...)
	self:showPopAnim(true)
	self:init("lua.uiconfig.activity.snowDayLittleGame")
end

function SnowDayLittleGame:initData(extendData)
	self.movePiece = nil
	self.working = false
	self.rotation = 0
	self.rotateDirection = -1
	self.rotateSpeed = 0
	self.piecesModule = {}
	self.piecesSetup = {}
	self.pieceGroup ={}
	self.pieceTips = {}
	self.pieceBg = {}
	self.extendData = extendData or {}
	dump(extendData)
	self.puzzleCfg = TabDataMgr:getData("SnowFesPuzzle", self.extendData.snowMiniGaId or 1)

	self:resetSpeed()

	
end

function SnowDayLittleGame:initUI(ui)
	self.super.initUI(self, ui)
	TFDirector:getChildByPath(ui,"Button_back"):onClick(function() AlertManager:closeLayer(self) end)

	self.Panel_Wheel = TFDirector:getChildByPath(ui, "Panel_Wheel"):show()
	local size = self.Panel_Wheel:getSize()
	local children = self.Panel_Wheel:getChildren()
	for k,child in ipairs(children) do
		child:setPosition(ccp(0,0))
	end

	self.Image_circal_normal = TFDirector:getChildByPath(ui, "Image_circal_normal"):hide()
	self.Image_circal_beat = TFDirector:getChildByPath(ui, "Image_circal_beat"):hide()
	self.Image_circal_win = TFDirector:getChildByPath(ui, "Image_circal_win"):hide()
	
	self.Label_GameName = TFDirector:getChildByPath(ui, "Label_GameName"):show()
	self.Label_GameName:setTextById(self.puzzleCfg.puzzleTitle)

	self.Image_frame = TFDirector:getChildByPath(ui, "Image_frame"):show()
	self.Button_goto = TFDirector:getChildByPath(ui, "Button_goto"):hide()
	self.Button_goto:onClick(function()
		DatingDataMgr:startDating(self.extendData.datingScriptId)
	end)

	self.Spine_win = TFDirector:getChildByPath(ui, "Spine_win"):hide()
	self.Spine_win:addMEListener(TFARMATURE_COMPLETE,function()
 	                   self:runAction(Sequence:create({DelayTime:create(0.5), CallFunc:create(function()
							local datingScriptId = self.extendData.datingScriptId
							AlertManager:closeLayer(self)
							DatingDataMgr:startDating(datingScriptId)							
						end)}))	
  	                end)
	self.Spine_rotate_tip = TFDirector:getChildByPath(ui, "Spine_rotate_tip"):hide()

	self.Panel_left = TFDirector:getChildByPath(ui, "Panel_left"):show()
	self.Panel_left:setTouchEnabled(true)
	self.Panel_left:setSwallowTouch(true)
	--self.Panel_left:onTouch(handler(self.onTouchRotate, self))

	for i=1, 4 do
		local touchRange = TFDirector:getChildByPath(self.Panel_left, "Panel_touch_"..i)
		touchRange:setTouchEnabled(true)
		touchRange:onTouch(handler(self.onTouchRotate, self))
	end

	self.CircleCenter = TFDirector:getChildByPath(ui, "CircleCenter")
	self.CircleCenter.NP = self.CircleCenter:getPosition()
	self.CircleCenter.WP = self.CircleCenter:getParent():convertToWorldSpaceAR(self.CircleCenter.NP)

	self.Prefab_piece = TFDirector:getChildByPath(ui, "Prefab_piece"):hide()

	self.Panel_TouchShield = TFDirector:getChildByPath(ui, "Panel_TouchShield"):hide()
	self.Panel_TouchShield:setTouchEnabled(true)
	self.Panel_TouchShield:setSwallowTouch(true)

	self.Panel_correct_tip = TFDirector:getChildByPath(ui, "Panel_correct_tip")
	for i=1,6 do
		local tip = TFDirector:getChildByPath(self.Panel_correct_tip, "tip"..i):show()
		tip.tipCorrect = TFDirector:getChildByPath(tip, "tipCorrect"):hide()
		tip.tipRight = TFDirector:getChildByPath(tip, "tipRight"):hide()
		table.insert(self.pieceTips, tip)
	end

	self.Panel_pieceBg = TFDirector:getChildByPath(ui, "Panel_pieceBg")
	for i=1,6 do
		local pieceBg = TFDirector:getChildByPath(self.Panel_pieceBg, "bg"..i):show()
		table.insert(self.pieceBg, pieceBg)
	end

	self.Panel_piece = TFDirector:getChildByPath(ui, "Panel_piece")
	local index = 1
	for i=1,6 do
		local pieceGroup = TFDirector:getChildByPath(self.Panel_piece, "Image_piece_item_"..i)
		pieceGroup.groupIndex = i
		pieceGroup.cfg = self.puzzleCfg["group"..pieceGroup.groupIndex.."piece"]
		pieceGroup.pieceCnt = self.puzzleCfg["group"..pieceGroup.groupIndex]
		pieceGroup.pieceCntStr = TFDirector:getChildByPath(pieceGroup, "Label_count")
		
		local sub = {}
		for j=1,2 do
			local piece = TFDirector:getChildByPath(pieceGroup, "Image_piece_"..j)
			if piece then
				piece.groupIndex = pieceGroup.groupIndex
				piece.pieceIndex = index
				piece.cfg = clone(TabDataMgr:getData("SnowFesPuzzlePiece", pieceGroup.cfg[j]))
				piece.root = piece:getParent()
				piece:setTexture(piece.cfg.path)
				piece:setTouchEnabled(true)
				piece:onTouch(handler(self.onTouchFunc, self))
				table.insert(self.piecesModule, piece)
				table.insert(sub, piece)
				index = index + 1
			end		
		end

		table.insert(self.pieceGroup, {subPiece=sub, group=pieceGroup, count=pieceGroup.pieceCnt})
	end

	self:updateGroupInfo()
	self:initWheelRotation(self.puzzleCfg.initialRotation or 0)
end

function SnowDayLittleGame:initWheelRotation(initAngle)
	self:enabledTouch(true)
	Utils:playSound(8131, false)
	self:preSetupPiece()
	self.Panel_Wheel:runAction(Sequence:create({RotateBy:create(1/180 *initAngle, initAngle),
		CallFunc:create(function()
			self.rotation = -self.Panel_Wheel:getRotation()
			self:enabledTouch(false)
			--self:fixRotation()
			Utils:playSound(8131, false)
		end)
	}))
end

function SnowDayLittleGame:preSetupPiece()
	local Config = self.puzzleCfg.fixedPieces
	print(Config)
	for k, v in pairs(Config) do
		local cfg = clone(TabDataMgr:getData("SnowFesPuzzlePiece", v))
		local piece = self.Prefab_piece:clone():show()
		piece:setPosition(0,0)
		piece:setAnchorPoint(ccp(0.5,0.025))
		piece:setRotation(OriginRotateBy[k] * Angle_PI61)	
		piece:setTexture(cfg.path)
		piece:setTouchEnabled(true)
		piece:setSwallowTouch(true)
		piece:addMEListener(TFWIDGET_CLICK, function()
			--Utils:showTips("该碎片不能移除")
		end)
		self.CircleCenter:addChild(piece)
		self.pieceBg[k]:hide()

		local left = k + 1
		if left > 6 then
			left = 1
		end
		local right = k - 1
		if right < 1 then
			right = 6
		end
		
		self.piecesSetup[k] = {mainPiece=piece, setupIndex=k, leftSetupIndex=left, rightSetupIndex=right, cfg=cfg}
		
	self:showTip(self.piecesSetup[k])
	end	
end

function SnowDayLittleGame:enabledTouch(enbled)
	self.Panel_TouchShield:setVisible(enbled)
	self:updateGroupInfo()
end

function SnowDayLittleGame:onTouchFunc(event)
	local name   = event.name
    local target = event.target
    if name == "began" then
        self.touchPosBegin = target:getTouchStartPos()
        --self._pos          = target:getPosition()
		self._pos = ccp(0,0)
		self.movePiece = target:clone()
		self.movePiece:setPosition(0,0)
		self.movePiece:runAction(ScaleTo:create(0.1, 1.1))
		target:addChild(self.movePiece)

		Utils:playSound(8124, false)
    elseif name == "moved" then 
        local touchMovePos = target:getTouchMovePos()
        local _x = (touchMovePos.x -  self.touchPosBegin.x + self._pos.x)*(1/target:getScale())
        local _y = (touchMovePos.y -  self.touchPosBegin.y + self._pos.y)*(1/target:getScale())
        self.movePiece:setPosition(ccp(_x, _y))

    elseif name == "ended" then
		self:enabledTouch(true)

		local wp = self.movePiece:getParent():convertToWorldSpaceAR(self.movePiece:getPosition())	
		local angle, setupIndex = self:calculateRotation(wp, self.CircleCenter.WP)--计算雪花碎片需要旋转的相对角度
		local dVec = self:rotateVec(angle)--根据旋转的角度计算方向向量
		local distance = ccpDistance(wp, self.CircleCenter.WP)--计算Touch End与旋转中心的距离
		if Radius > distance and self:notExsit(setupIndex) then
			local distRotation = self:getPieceRotation(-Angle_PI61 * 3)--计算旋转后的绝对角度
			local distPos = self.movePiece:getParent():convertToNodeSpaceAR(self.CircleCenter.WP)
			local newDVec = self:rotateVec(-self.rotation, dVec)--计算旋转后的方向向量(因为方向向量也会跟着旋转)
			local offsetPos =  ccpMult(newDVec, self.movePiece:getSize().height *(1- 0.18))--计算一个偏移值,使雪花的尖角对准旋转中心
			local newDistPos = ccpAdd(distPos + offsetPos)--新的目标位置						
			self.movePiece:runAction(Sequence:create({Spawn:create({EaseOut:create(MoveTo:create(0.3, newDistPos),0.15), 
																		RotateTo:create(0.3, -distRotation[setupIndex]), 
																		ScaleTo:create(0.3, 1/target:getScale() * 1.3)}),
													 ScaleTo:create(0.3, 1/target:getScale()),
													 CallFunc:create(function()
														self.pieceGroup[target.groupIndex].count = self.pieceGroup[target.groupIndex].count - 1
														self:updateGroupInfo()

														self:setupPiece(target, angle, dVec, setupIndex)
														if self.movePiece then
															self.movePiece:runAction(FadeOut:create(0.1))
															self.movePiece:removeFromParent(true)
															self.movePiece = nil
														end
														self:enabledTouch(false)
														Utils:playSound(8121, false)
													end)}))
		else
			self.movePiece:runAction(Sequence:create({MoveTo:create(0.3, ccp(0,0)), RemoveSelf:create(), CallFunc:create(function()
				self.movePiece = nil
				self:enabledTouch(false)

				Utils:playSound(8125, false)
			end)}))
		end
	end
end

function SnowDayLittleGame:getPieceRotation(offsetAngle)
	offsetAngle = offsetAngle or 0
	return {
				(self.rotation + Angle_PI61 * 1  + offsetAngle) % Angle_2PI,
				(self.rotation + Angle_PI61 * 3  + offsetAngle) % Angle_2PI,
				(self.rotation + Angle_PI61 * 5  + offsetAngle) % Angle_2PI,
				(self.rotation + Angle_PI61 * 7  + offsetAngle) % Angle_2PI,
				(self.rotation + Angle_PI61 * 9  + offsetAngle) % Angle_2PI,
				(self.rotation + Angle_PI61 * 11 + offsetAngle) % Angle_2PI,
			}
end

function SnowDayLittleGame:setupPiece(target, angle, dVec, setupIndex)
	local piece = self.movePiece:clone():Pos(0,0)
	piece:setAnchorPoint(ccp(0.5,0.025))
	piece:setRotation(angle)
	piece:setScale(1)
	piece:setTouchEnabled(true)
	piece:addMEListener(TFWIDGET_CLICK, function()
		local piece0 = self.piecesModule[target.pieceIndex]

		local wp = piece:getParent():convertToWorldSpaceAR(piece:getPosition())
		local np = piece0.root:convertToNodeSpaceAR(wp)
		local distRotation = self:getPieceRotation(- Angle_PI61 * 3)

		piece:retain()
		piece:removeFromParent(false)				
		piece:setPosition(np)		
		piece:setCascadeColorEnabled(false)		
		piece:setRotation(-distRotation[setupIndex])
		piece0.root:addChild(piece)
		piece:release()
		
		local newWp = self.CircleCenter:convertToWorldSpaceAR(ccpMult(dVec, 70))
		local newNodePos = piece:getParent():convertToNodeSpaceAR(newWp)
		
		piece:runAction(Sequence:create({EaseIn:create(MoveTo:create(0.3, newNodePos), 0.15),
								DelayTime:create(0.1),
								CallFunc:create(function() 
										self.pieceBg[setupIndex]:show()
										self.pieceBg[setupIndex]:setOpacity(0)
										self.pieceBg[setupIndex]:runAction(FadeIn:create(0.3))

										piece:setAnchorPoint(ccp(0.5,0.5))
									end), 
								Spawn:create({EaseIn:create(MoveTo:create(0.4, ccp(0, 0)), 0.15), 
											  RotateTo:create(0.3, 0), ScaleTo:create(0.3, 1)}), 
								ScaleTo:create(0.3,target:getScale()),
								RemoveSelf:create(), 
								CallFunc:create(function()
									self.pieceGroup[target.groupIndex].count = self.pieceGroup[target.groupIndex].count + 1
									self:enabledTouch(false)
																	
									if self.piecesSetup[setupIndex] then
										self.piecesSetup[setupIndex] = nil
									end
									--更新光圈
									self:updateLightRing()

									Utils:playSound(8125,false)
								end)}))

		self:showTip(self.piecesSetup[setupIndex], true)
		
		self:enabledTouch(true)		
	end)

	self.CircleCenter:addChild(piece)
	
	local left = setupIndex + 1
	if left > 6 then
		left = 1
	end
	local right = setupIndex - 1
	if right < 1 then
		right = 6
	end
	
	self.piecesSetup[setupIndex] = {mainPiece=piece, setupIndex=setupIndex, leftSetupIndex=left, rightSetupIndex=right, cfg=clone(target.cfg)}
	print("安装到",setupIndex)

	self.pieceBg[setupIndex]:hide()

	--显示小提示图片
	self:showTip(self.piecesSetup[setupIndex])	

	--更新光圈
	self:updateLightRing()

	--检测是否胜利
	self:checkVectory()
end


function SnowDayLittleGame:updateLightRing()
	self.Image_circal_normal:hide()
	self.Image_circal_beat:hide()
	self.Image_circal_win:hide()
	self.Spine_rotate_tip:hide()

	local setupCount = table.count( self.piecesSetup)
	if setupCount<6 then
		self.Image_circal_normal:show()
	elseif self:checkCorrect() then
		self.Image_circal_win:setOpacity(0)
		self.Image_circal_win:show()
		self.Image_circal_win:runAction(FadeIn:create(1.8))

		self.Spine_rotate_tip:setOpacity(0)	
		self.Spine_rotate_tip:runAction(FadeIn:create(0.8))
		self.Spine_rotate_tip:show()
	else
		self.Image_circal_beat:setOpacity(0)
		self.Image_circal_beat:show()
			
		self.Image_circal_beat:runAction(FadeIn:create(1.8))
	end
end

--[[
	计算碎片即将安装的坐标区间
	参数:(只要wp1和wp2在同一节点坐标系即可)
	wp1:点的世界坐标
	wp2:点的世界坐标
	返回:angle:即将旋转的角度, setupIndex:安装对应区间的索引
]]
function SnowDayLittleGame:calculateRotation(wp1, wp2)
	local d = ccpSub(wp1, wp2)
	local angle = (math.atan2(d.y, d.x) - math.atan2(0, 1)) * Angle_PI / math.pi
	if angle < 0 then
		angle = angle + Angle_2PI
	end	

	local realRatate = math.floor( math.abs(self.rotation) % Angle_2PI)
	if self.rotation > 0 then
		realRatate = Angle_2PI - realRatate
	end

	local step
	if realRatate % Angle_PI31 == 0 then
		step = Angle_PI31
	else
		step = Angle_PI61
	end
		
	local newRotation = self:getPieceRotation()
		
	local rotation = 0
	local setupIndex = 1

	for i=1,6 do
		local min = math.floor(newRotation[i]) - Angle_PI61
		local max = math.floor(newRotation[i]) + Angle_PI61
		
		if 11*Angle_PI61 < angle and angle < Angle_2PI and newRotation[i] == 0 then		
			max = Angle_PI61 + Angle_2PI
		end

		if	min < angle and angle <= max  then
			rotation = Angle_PI61 * OriginRotateBy[i]
			setupIndex = i
			break;
		end
	end

	print("calculateRotation angle:", angle, newRotation,test, rotation, setupIndex)
	return rotation, setupIndex
end

function SnowDayLittleGame:rotateVec(rotation, vec0)	
	local vec0 = vec0 or ccp(0,1)
	local rad = -rotation * math.pi / Angle_PI
	local vec = ccp( math.cos(rad) *vec0.x - math.sin(rad) *vec0.y, math.sin(rad) *vec0.x + math.cos(rad) *vec0.y)
	return ccpNormalize(vec)
end

function SnowDayLittleGame:notExsit(setupIndex)
	print(setupIndex, self.piecesSetup[setupIndex])
	return self.piecesSetup[setupIndex] == nil
end

function SnowDayLittleGame:checkCorrect()
	local Correct = true
	for _, tip in pairs(self.pieceTips) do
		if not tip.tipRight:isVisible() or tip.tipCorrect:isVisible() then
			Correct = false
			break;
		end
	end
	if Correct then

	end
	return Correct
end

function SnowDayLittleGame:showTip(piece, delete)
	self.pieceTips[TipMap[piece.setupIndex].left].tipRight:hide()
	self.pieceTips[TipMap[piece.setupIndex].right].tipRight:hide()
	self.pieceTips[TipMap[piece.setupIndex].left].tipCorrect:hide()
	self.pieceTips[TipMap[piece.setupIndex].right].tipCorrect:hide()
	if delete then
		return
	end
	
	local cfg = piece.cfg
	local left = piece.leftSetupIndex
	if self.piecesSetup[left] then		
		local cfgLeft = self.piecesSetup[left].cfg
		if cfg.lenthLeft == cfgLeft.lenthRight then
			self.pieceTips[TipMap[piece.setupIndex].left].tipRight:show()
		else
			self.pieceTips[TipMap[piece.setupIndex].left].tipCorrect:show()
		end
	end

	local right = piece.rightSetupIndex
	if self.piecesSetup[right] then
		local cfgRight = self.piecesSetup[right].cfg
		if cfg.lenthRight == cfgRight.lenthLeft then
			self.pieceTips[TipMap[piece.setupIndex].right].tipRight:show()
		else
			self.pieceTips[TipMap[piece.setupIndex].right].tipCorrect:show()
		end
	end
	
end

function SnowDayLittleGame:resetSpeed(speed, directon)
	self.rotateDirection = directon or 1
	self.rotateSpeed = speed or 50
end

function SnowDayLittleGame:launchWheel(speed, directon)
	self.working = true
	self:resetSpeed(speed, directon)
	self:enabledTouch(true)
end

function SnowDayLittleGame:stopWheel()
	self.working = false
	self:resetSpeed()
	self:fixRotation()
end

function SnowDayLittleGame:fixRotation()
	self:enabledTouch(true)

	local fixAngle = 0
	local offsetAngle = 0
	local direction;
	local symbol = self.rotation/ math.abs(self.rotation)
	local mod = math.abs(self.rotation) % (Angle_PI61)
	if mod > Angle_PI61 * 0.5 then
		fixAngle = self.rotation - (mod - (Angle_PI61)) * symbol
		direction = 1
		offsetAngle = (Angle_PI61) - mod
	elseif mod <= Angle_PI61 * 0.5 then
		fixAngle = self.rotation - mod * symbol
		direction = -1
		offsetAngle = -mod
	end
	local rotation = -offsetAngle*symbol
	self.Panel_Wheel:runAction(Sequence:create({RotateBy:create(0.5, rotation),
		CallFunc:create(function()
			self.rotation = -self.Panel_Wheel:getRotation()
			self:enabledTouch(false)
			self:checkVectory()

			Utils:playSound(8131,false)
		end)
	}))
end

function SnowDayLittleGame:playRotationSound(delta)
	local delta = delta or 0
	local nextRotation = self.rotation + delta
		
	--if math.floor(nextRotation)

--	local soundAngle =  math.floor( math.abs(self.rotation))
--	if soundAngle % 30 == 0 and self.soundAngle ~= soundAngle then
--		self.soundAngle = soundAngle
--		Utils:playSound(8131, false)
--	end		
end

function SnowDayLittleGame:update(_, dt)
	if self.working == false then
		return
	end
	local delta = self.rotateSpeed * dt * self.rotateDirection	

	self:playRotationSound(delta)

	self.rotation = self.rotation + delta

	self.Panel_Wheel:setRotation(-self.rotation)

	self.rotateSpeed = math.max (self.rotateSpeed - DeltaSpeed * dt * 3, 0)

	if self.rotateSpeed <= 0 then
		self:stopWheel()
		self.soundAngle = nil
	end
end

function SnowDayLittleGame:updateGroupInfo()
	for k,v in ipairs(self.pieceGroup)do
		v.group.pieceCntStr:setTextById(800007,v.count)	
		local opacity = 255	
		local enabled = true
		if v.count == 0 then
			opacity = 80
			enabled = false
		else			
			opacity = 255
			enabled = true
		end

		if v.subPiece[1]then
			v.subPiece[1]:setOpacity(opacity)
			v.subPiece[1]:setTouchEnabled(enabled)
		end
		if v.subPiece[2]then
			v.subPiece[2]:setOpacity(opacity)
			v.subPiece[2]:setTouchEnabled(enabled)
		end
	end
end

function SnowDayLittleGame:onTouchRotate(event)
	local name   = event.name
    local target = event.target
    if name == "began" then
		self.rotatePosBegin = target:getTouchStartPos()
		self.rotateTimeBegin = math.floor(TFTime:clock() *1000)
		self.touchBeginName = target:getName()
	elseif name == "moved" then
		local touchMovePos = target:getTouchMovePos()
        local _x = touchMovePos.x -  self.rotatePosBegin.x
        local _y = touchMovePos.y -  self.rotatePosBegin.y
		local deltaPos = ccp(_x,_y)
		local distance;
		if math.abs(deltaPos.y) >= math.abs(deltaPos.x) then
			distance = deltaPos.y
		else
			distance = deltaPos.x
		end

        --self.movePiece:setPosition(ccp(_x, _y))
	elseif name == "ended" then
		local endPos = target:getTouchEndPos()
		local deltaPos = ccpSub(endPos, self.rotatePosBegin)
		local distance;

		local directon = 1;

		if self.touchBeginName == "Panel_touch_1" then
			distance = deltaPos.y
			directon = directon * -1
		elseif self.touchBeginName == "Panel_touch_2" then
			directon = directon * -1
			distance = deltaPos.x
		elseif self.touchBeginName == "Panel_touch_3" then
			directon = directon * 1
			distance = deltaPos.y

		elseif self.touchBeginName == "Panel_touch_4" then
			directon = directon * 1
			distance = deltaPos.x			
		end

		if math.abs(distance) < 30 then
			return
		end
		directon = directon * (distance > 0 and 1 or -1 )

		local speed = distance * distance / ( math.floor(TFTime:clock() *1000) - self.rotateTimeBegin) * 300
		self.force = math.sqrt( math.abs(speed)) + constValue
		self:launchWheel(self.force, directon)
	end
end

function SnowDayLittleGame:checkVectory()
	if table.count(self.piecesSetup) < 6 then
		return
	end

	if not self:checkCorrect() then
		return
	end

	local realRatate = math.floor( math.abs(self.rotation) % Angle_2PI)
	if self.rotation > 0 then
		realRatate = Angle_2PI - realRatate
	end

	local step
	if realRatate % Angle_PI31 == 0 then
		step = Angle_PI31
	else
		step = Angle_PI61
	end

	--计算旋转之后的列表及其的位置
	local tab = {}
	for i=1,6 do
		if step == Angle_PI31 then
			tab[i] = {index = i, data = self.piecesSetup[i]}
		else
			local index = 15 - i * 2
			if index > 12 then
				index = 1
			end
			tab[i] = {index = index, data = self.piecesSetup[i]}
		end
	end

	for i=1, realRatate, step do
		for j=1,6 do				
			if step == Angle_PI31 then
				tab[j].index = tab[j].index - 1				
				if tab[j].index < 1 then
					tab[j].index = 6
				end
			else		
				tab[j].index = tab[j].index + 1				
				if tab[j].index > 12 then
					tab[j].index = 1
				end
			end
		end
	end

	local tempTab = {}
	if step == Angle_PI31 then
		for k,v in ipairs(tab) do
			tempTab[v.index] = v.data
		end
		print("转了60度")
		local pieceInfoMidUp		= tempTab[2]
		local pieceInfoMidDown 		= tempTab[5]
		local pieceInfoLeftUp 		= tempTab[3]
		local pieceInfoLeftDown 	= tempTab[4]
		local pieceInfoRightUp		= tempTab[1]
		local pieceInfoRightDown 	= tempTab[6]

		if pieceInfoMidUp.cfg.lenthLeft == pieceInfoMidUp.cfg.lenthRight and 
			pieceInfoMidDown.cfg.lenthLeft == pieceInfoMidDown.cfg.lenthRight and 

			pieceInfoLeftUp.cfg.pieceGroup == pieceInfoRightUp.cfg.pieceGroup and pieceInfoLeftUp.cfg.lenthLeft == pieceInfoRightUp.cfg.lenthRight and
			pieceInfoLeftUp.cfg.lenthRight == pieceInfoRightUp.cfg.lenthLeft and

			pieceInfoLeftDown.cfg.pieceGroup == pieceInfoRightDown.cfg.pieceGroup and pieceInfoLeftDown.cfg.lenthLeft == pieceInfoRightDown.cfg.lenthRight and
			pieceInfoLeftDown.cfg.lenthRight == pieceInfoRightDown.cfg.lenthLeft 
		then
			print("游戏胜利")
			self:gameOver()
		else
			print("游戏失败")	
		end
		
	else
		for k,v in pairs(tab) do
			tempTab[v.index] = v.data
		end
		--print(tempTab)
		print("转了30度")
		if tempTab[8] and tempTab[2] and tempTab[10] and tempTab[6] and tempTab[12] and tempTab[4] then			
			local pieceInfoLeft			= tempTab[8]
			local pieceInfoRight 		= tempTab[2]
			local pieceInfoLeftUp 		= tempTab[10]
			local pieceInfoLeftDown 	= tempTab[6]
			local pieceInfoRightUp		= tempTab[12]
			local pieceInfoRightDown 	= tempTab[4]
			if pieceInfoLeft.cfg.pieceGroup == pieceInfoRight.cfg.pieceGroup and pieceInfoLeft.cfg.lenthLeft == pieceInfoRight.cfg.lenthRight and 
				pieceInfoLeft.cfg.lenthRight == pieceInfoRight.cfg.lenthLeft and 

				pieceInfoLeftUp.cfg.pieceGroup == pieceInfoRightUp.cfg.pieceGroup and pieceInfoLeftUp.cfg.lenthLeft == pieceInfoRightUp.cfg.lenthRight and
				pieceInfoLeftUp.cfg.lenthRight == pieceInfoRightUp.cfg.lenthLeft and

				pieceInfoLeftDown.cfg.pieceGroup == pieceInfoRightDown.cfg.pieceGroup and pieceInfoLeftDown.cfg.lenthLeft == pieceInfoRightDown.cfg.lenthRight and
				pieceInfoLeftDown.cfg.lenthRight == pieceInfoRightDown.cfg.lenthLeft 
			then
				print("游戏胜利")	
				self:gameOver()
			else
				print("游戏失败")
			end
		end
	end
	
end

function SnowDayLittleGame:gameOver()
	self:enabledTouch(true)
	Utils:playSound(8129, false)
	ActivityDataMgr2:sendSnowGameOver(self.extendData.snowMiniGaId)
end

function SnowDayLittleGame:showVectory()
	self.Spine_win:show()
	self.Spine_win:setOpacity(0)
	self.Spine_win:runAction(FadeIn:create(0.5))
	self.Spine_win:play("animation")
	self:enabledTouch(false)
	self.Button_goto:hide()
	self.Image_frame:hide()

	self:runAction(Sequence:create({DelayTime:create(5), CallFunc:create(function()
					self:enabledTouch(false)
				end)}))	
end

function SnowDayLittleGame:registerEvents()
	self.super.ctor(self)
	self:addMEListener(TFWIDGET_ENTERFRAME, handler(self.update, self))

	EventMgr:addEventListener(self, EV_ICE_SNOW_GAME_OVER, handler(self.showVectory, self))

end


return SnowDayLittleGame