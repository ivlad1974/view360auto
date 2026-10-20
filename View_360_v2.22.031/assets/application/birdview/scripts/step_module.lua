StepModule = {
    stepMatrix = nil,
    lastTimeStamp = 0,
}

function StepModule:OnInit()
    self.stepMatrix = Math_CreateMatrix()
end

function StepModule:OnUpdateSample(timeStamp)
    local speed = StateModule:GetInputState("Speed")
    Math_MatrixIdentify(self.stepMatrix)
    if speed < 1 then
        StateModule:SetInputState("Trans", self.stepMatrix)
        self.lastTimeStamp = timeStamp
        return
    end
    local angle = math.rad(StateModule:GetInputState("WheelAngle"))
    local delta = (timeStamp - self.lastTimeStamp) / 1000.0
    local distance = speed * 1000000 / 3600 * delta
    local centerAngle = 0.0
    if angle == 0.0 then
    else
        local rearRadius = VehicleInfo.WheelBase * math.tan(angle)
        local rearArm = math.abs(CalibInfo.CalibFrontPosition - VehicleInfo.FrontOverhang - VehicleInfo.WheelBase)
        centerAngle = math.atan(rearRadius / rearArm)
    end
    Math_MatrixTranslate(self.stepMatrix, { -distance, 0, 0 })
    Math_MatrixRotate(self.stepMatrix, angle, { 0, 1, 0 })
    StateModule:SetInputState("Trans", self.stepMatrix)
    self.lastTimeStamp = timeStamp
end

AllModules["Step"] = StepModule

