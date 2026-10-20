IndicatorModule = {
    forwardAux = {},
    backAux = {},
    forwardTrack = {},
    backwardTrack = {},
    sideBorder = {},
    rearDist = {},
    currentAngle = nil,
}

function IndicatorModule:OnWheelAngleChanged(value)
    if value > VehicleInfo.MaxWheelAngle then
        value = VehicleInfo.MaxWheelAngle
    end
    if value < -VehicleInfo.MaxWheelAngle then
        value = -VehicleInfo.MaxWheelAngle
    end
    local trackIndex = value - math.fmod(value, Common.TrackPrecision)
    local trackType = Common.TrackType or 1
    local trackGenerator = TrackGenerators[trackType]
    if self.forwardTrack[trackIndex] == nil then
        local originData = trackGenerator(trackIndex, false)
        if originData then
            self.forwardTrack[trackIndex] = {}
            self.forwardTrack[trackIndex].cameraGeo = GeometryModule:GenerateCameraGeo(1, originData)
            self.forwardTrack[trackIndex].worldGeo = GeometryModule:GenerateWorldGeo(originData)
        end
    end
    GeometryModule:AttachWorldGeometry("FTrack", self.forwardTrack[trackIndex].worldGeo)
    GeometryModule:AttachCameraGeometry(1, "FTrack", self.forwardTrack[trackIndex].cameraGeo)

    if self.backwardTrack[trackIndex] == nil then
        local originData = trackGenerator(trackIndex, true)
        if originData then
            self.backwardTrack[trackIndex] = {}
            self.backwardTrack[trackIndex].cameraGeo = GeometryModule:GenerateCameraGeo(3, originData)
            self.backwardTrack[trackIndex].worldGeo = GeometryModule:GenerateWorldGeo(originData)
        end
    end
    GeometryModule:AttachWorldGeometry("BTrack", self.backwardTrack[trackIndex].worldGeo)
    GeometryModule:AttachCameraGeometry(3, "BTrack", self.backwardTrack[trackIndex].cameraGeo)
    self.currentAngle = value
end

function IndicatorModule:OnInit()
    StateModule:AttachNotifier("WheelAngle", self, IndicatorModule.OnWheelAngleChanged)
end

function IndicatorModule:ClearAll()
    self.forwardAux = {}
    self.backAux = {}
    self.forwardTrack = {}
    self.backwardTrack = {}
    self.sideBorder = {}
    self.rearDist = {}
    GeometryModule:AttachWorldGeometry("FTrack", nil)
    GeometryModule:AttachCameraGeometry(1, "FTrack", nil)
    GeometryModule:AttachWorldGeometry("BTrack", nil)
    GeometryModule:AttachCameraGeometry(3, "BTrack", nil)

end

function IndicatorModule:OnUpdateConfig()
    self:ClearAll()
    local rearBias = CalibInfo.CalibRectLength / 2.0 + CalibInfo.CalibFrontPosition - VehicleInfo.CarLength
    if rearBias < -CalibInfo.CalibLengthUnit * 0.4 or CalibInfo.CalibFrontPosition - VehicleInfo.CarLength > 0.0 then
        VehicleInfo.CarLength = CalibInfo.CalibFrontPosition * 2.0
        VehicleInfo.WheelBase = VehicleInfo.CarLength * 0.7
        VehicleInfo.FrontOverhang = VehicleInfo.CarLength * 0.15
        VehicleInfo.RearOverhang = VehicleInfo.CarLength * 0.15
    end
    if VehicleInfo.CarWidth > CalibInfo.CalibRectWidth + CalibInfo.CalibLengthUnit * 0.2 then
        VehicleInfo.CarWidth = CalibInfo.CalibRectWidth
    end
    local originData = IndicatorParam.BackAuxLine()
    self.backAux.cameraGeo = GeometryModule:GenerateCameraGeo(3, originData)
    self.backAux.worldGeo = GeometryModule:GenerateWorldGeo(originData)
    GeometryModule:AttachWorldGeometry("BAux", self.backAux.worldGeo)
    GeometryModule:AttachCameraGeometry(3, "BAux", self.backAux.cameraGeo)

    if IndicatorParam.ForwardAuxLine then
        local originDataForward = IndicatorParam.ForwardAuxLine()
        self.forwardAux.cameraGeo = GeometryModule:GenerateCameraGeo(1, originDataForward)
        self.forwardAux.worldGeo = GeometryModule:GenerateWorldGeo(originDataForward)
        GeometryModule:AttachWorldGeometry("FAux", self.forwardAux.worldGeo)
        GeometryModule:AttachCameraGeometry(1, "FAux", self.forwardAux.cameraGeo)
    end

    if IndicatorParam.SideBorder then
        originData = IndicatorParam.SideBorder()
        self.sideBorder[2] = GeometryModule:GenerateCameraGeo(2, originData)
        self.sideBorder[4] = GeometryModule:GenerateCameraGeo(4, originData)
        self.sideBorder["World"] = GeometryModule:GenerateWorldGeo(originData)
        GeometryModule:AttachCameraGeometry(2, "SideBorder", self.sideBorder[2])
        GeometryModule:AttachCameraGeometry(4, "SideBorder", self.sideBorder[4])
        GeometryModule:AttachWorldGeometry("SideBorder", self.sideBorder["World"])
    end
    if self.currentAngle then
        self:OnWheelAngleChanged(self.currentAngle)
    end

    if IndicatorParam.RearDistAux then
        originData = IndicatorParam.RearDistAux()
        self.rearDist = GeometryModule:GenerateWorldGeo(originData)
        GeometryModule:AttachWorldGeometry("RearDist", self.rearDist)
    end
end

function IndicatorModule:OnUpdateSetting(keyString)
    if string.find(keyString, "Common.TrackType") then
        if Common.TrackType > #TrackGenerators then
            Common.TrackType = 0
        end
        self:ClearAll()
        self:OnWheelAngleChanged(self.currentAngle)
    end
    if string.find(keyString, "VehicleInfo") then
        self:OnUpdateConfig()
    end
end

AllModules["Indicator"] = IndicatorModule

