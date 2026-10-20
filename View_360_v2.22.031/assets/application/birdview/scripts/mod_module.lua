local TYPE_HUMAN = 1
local WARN_AREA_WIDTH = 800
local NEAR_WARN_DIST = 1500
local TRACK_STEP = 50
local ARROW_HEIGHT = 400
local MAX_ARROW_DIST = 3000
local NEAR_WARN_ZDIST = 2000
local MAX_DISTANCE_VALUE = 25000
local FOLLOW_STEP = 200
local FOLLOW_STATE_MAX = 5
local BSD_DETECT_STATE = 4
local LEVEL_COLOR = { { 1.0, 0.3, 0.2, 0.8 }, { 1.0, 1.0, 0.2, 0.8 }, { 0.0, 1.0, 1.0, 0.8 } }

local CAMERA_FUNCTIONIDS = {
    DetectionChannel.FRONT_FISHEYE_BSD_DETECT_CHANNEL,
    DetectionChannel.RIGHT_FISHEYE_BSD_DETECT_CHANNEL,
    DetectionChannel.REAR_FISHEYE_BSD_DETECT_CHANNEL,
    DetectionChannel.LEFT_FISHEYE_BSD_DETECT_CHANNEL,
}

local function TransformToTrackLineBase(trackRadius, trackBase, trackRoundCenter, straightPoint)
    local arcLen = straightPoint[1] - trackBase[1]
    local arcRadian = arcLen / trackRadius
    if trackRoundCenter[3] > 0 then
        arcRadian = -arcRadian
    end
    local cosRadian = math.cos(arcRadian)
    local sinRadian = math.sin(arcRadian)
    local z = straightPoint[3] - trackRoundCenter[3]
    local x = trackBase[1] - trackRoundCenter[1]
    local newX = x * cosRadian + z * sinRadian
    local newZ = x * -sinRadian + z * cosRadian
    local newTrackPos = { trackRoundCenter[1] + newX, 0.0, trackRoundCenter[3] + newZ }
    return newTrackPos
end

local function GenerateAdasTrack(wheelAngle, backward)
    local leftLine = {
        VertexData = {},
        SingleColor = { 1.0, 1.0, 1.0, 0.8 },
        GeoMode = GL_DEFINES.GL_LINE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = true,
        LineWidth = 2.0,
    }
    local rightLine = {
        VertexData = {},
        SingleColor = { 1.0, 1.0, 1.0, 0.8 },
        GeoMode = GL_DEFINES.GL_LINE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = true,
        LineWidth = 2.0,
    }
    local transArea = {
        VertexData = {},
        ColorData = {},
        GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = true,
        CullDisable = true,
    }

    local tracks = { transArea, leftLine, rightLine }

    local CENTER_TRACK_LENGTH = 5 * CalibInfo.CalibLengthUnit
    local CENTER_TRACK_STEP = TRACK_STEP
    local STRIP_PART = CENTER_TRACK_LENGTH / TRACK_STEP
    local wheelRad = math.rad(wheelAngle)

    local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0 }
    local rearCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0 }
    local frontCenter = { rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0 }

    local trackLeftBegin = { 0.0, 0.0, -VehicleInfo.CarWidth / 2 }
    local trackRightBegin = { 0.0, 0.0, VehicleInfo.CarWidth / 2 }
    local trackCenterBegin = { 0.0, 0.0, 0.0 }
    local trackDirection = { CENTER_TRACK_STEP, 0.0, 0.0 }
    if backward then
        trackCenterBegin[1] = rearCenter[1]
        trackRightBegin[1] = rearCenter[1]
        trackLeftBegin[1] = rearCenter[1]
        trackDirection[1] = -CENTER_TRACK_STEP
    else
        trackCenterBegin[1] = frontCenter[1]
        trackRightBegin[1] = frontCenter[1]
        trackLeftBegin[1] = frontCenter[1]
    end
    local trackBegin = { trackLeftBegin, trackRightBegin }

    local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
    local trackCircleCenter = { rearAxisCenter[1], 0.0, trackRearRadius }
    local xDis = trackCenterBegin[1] - trackCircleCenter[1]
    local zDis = trackCenterBegin[3] - trackCircleCenter[3]
    local trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
    local vertexIndex = 1
    -- generate line
    for i = 0, STRIP_PART do
        local straightPt = table.Clone(trackLeftBegin)
        straightPt[1] = straightPt[1] + trackDirection[1] * i
        leftLine.VertexData[vertexIndex] = straightPt
        straightPt = table.Clone(trackRightBegin)
        straightPt[1] = straightPt[1] + trackDirection[1] * i
        rightLine.VertexData[vertexIndex] = straightPt
        vertexIndex = vertexIndex + 1
    end
    if wheelAngle ~= 0.0 then
        for i = 1, #leftLine.VertexData do
            leftLine.VertexData[i] = TransformToTrackLineBase(trackRadius, trackLeftBegin, trackCircleCenter, leftLine.VertexData[i])
            rightLine.VertexData[i] = TransformToTrackLineBase(trackRadius, trackRightBegin, trackCircleCenter, rightLine.VertexData[i])
        end
    end
    --generate area
    local TRANS_PARTS = STRIP_PART * 0.3
    for i = 0, TRANS_PARTS do
        transArea.VertexData[#transArea.VertexData + 1] = table.Clone(leftLine.VertexData[i + 1])
        transArea.VertexData[#transArea.VertexData + 1] = table.Clone(rightLine.VertexData[i + 1])
        local color = { 1.0, 1.0, 1.0, (TRANS_PARTS - i) / TRANS_PARTS * 0.3 }
        transArea.ColorData[#transArea.ColorData + 1] = color
        transArea.ColorData[#transArea.ColorData + 1] = color
    end
    return tracks
end

local function GenerateModRect(max_point)
    local VertexArrayData = {
        VertexData = {},
        ColorData = {},
        LabelData = {},
        GeoMode = GL_DEFINES.GL_LINES,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = false,
        LineWidth = 4.0,
    }
    for i = 1, max_point do
        VertexArrayData.VertexData[i] = { 2.0, 2.0, 0.0 }
        VertexArrayData.ColorData[i] = { 0.0, 1.0, 0.0, 1.0 }
    end
    for i = 1, max_point / 16 do
        VertexArrayData.LabelData[#VertexArrayData.LabelData + 1] = { FixSize = true, Text = "", Height = 0.04, Position = { 0, 0, 0 }, Color = { 1.0, 0.0, 0.0, 1.0 }, Align = "HCenter VCenter" }
    end

    return VertexArrayData
end

local function GenerateBorderWarn(yside, ywidth)
    local VertexArrayData = {
        VertexData = {},
        ColorData = {},
        GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = false,
        CullDisable = true,
    }
    -- first draw border line
    local LINE_WIDTH = 6
    local ylineWidth = LINE_WIDTH / ywidth
    local middleLen = 0.3

    -- first draw border line
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { -middleLen, 1.0, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { -middleLen, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { -middleLen + 0.1, 1.0, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { -middleLen + 0.1, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen - 0.1, 1.0, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen - 0.1, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen, 1.0, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    --transparent area
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { -middleLen, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { -middleLen + 0.1, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { -middleLen + 0.1, 1.0 - ylineWidth * 3, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.5 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen - 0.1, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen - 0.1, 1.0 - ylineWidth * 3, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.5 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    for i = 1, #VertexArrayData.VertexData do
        VertexArrayData.VertexData[i][2] = VertexArrayData.VertexData[i][2] * yside
    end
    return VertexArrayData
end

local function GenerateCornerWarn(xside, yside, xwidth, ywidth)
    local VertexArrayData = {
        VertexData = {},
        ColorData = {},
        GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = false,
        CullDisable = true,
    }
    -- first draw border line
    local LINE_WIDTH = 6
    local xlineWidth = LINE_WIDTH / xwidth
    local ylineWidth = LINE_WIDTH / ywidth
    local middleLen = 0.3
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0, 0.0, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0 - xlineWidth, 0.0, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0, 0.2, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0 - xlineWidth, 0.2, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0, 1.0, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0 - xlineWidth, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen + 0.2, 1.0, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen + 0.2, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 1.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen, 1.0, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    --transparent area
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen + 0.2, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { middleLen + 0.2, 1.0 - ylineWidth * 3, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.5 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0 - xlineWidth, 1.0 - ylineWidth, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0 - xlineWidth * 3, 1.0 - ylineWidth * 3, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.5 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0 - xlineWidth, 0.2, 0.0 }
    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0 - xlineWidth * 3, 0.2, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.5 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = { 1.0 - xlineWidth, 0.0, 0.0 }
    VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = { 1.0, 1.0, 1.0, 0.0 }

    for i = 1, #VertexArrayData.VertexData do
        VertexArrayData.VertexData[i][1] = VertexArrayData.VertexData[i][1] * xside
        VertexArrayData.VertexData[i][2] = VertexArrayData.VertexData[i][2] * yside
    end
    return VertexArrayData
end

local function GenerateArrow(width, height, back)
    local arrow = {
        VertexData = {},
        SingleColor = { 1.0, 1.0, 1.0, 0.8 },
        GeoMode = GL_DEFINES.GL_LINE_LOOP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = true,
        LineWidth = 2.0,
    }
    arrow.VertexData[1] = { 0, 0, 0 }
    arrow.VertexData[2] = { -height / 2, 0, width / 2 }
    arrow.VertexData[3] = { -height, 0, width / 2 }
    arrow.VertexData[4] = { -height / 2, 0, 0 }
    arrow.VertexData[5] = { -height, 0, -width / 2 }
    arrow.VertexData[6] = { -height / 2, 0, -width / 2 }
    if back then
        for i = 1, 6 do
            arrow.VertexData[i][1] = -arrow.VertexData[i][1]
        end
    end
    return arrow
end

local function GenerateCameraArrow(width, height, back)
    local arrow = GenerateArrow(width, height, back)
    if back then
        for i = 1, 6 do
            arrow.VertexData[i][1] = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + arrow.VertexData[i][1] - MAX_ARROW_DIST
        end
    else
        for i = 1, 6 do
            arrow.VertexData[i][1] = CalibInfo.CalibFrontPosition + arrow.VertexData[i][1] + MAX_ARROW_DIST
        end
    end
    return arrow
end

ModModule = {
    MAX_POINT = 480,
    followState = 0,
    rearState = { 0, 0, 0 },
    rearStartDist = { MAX_DISTANCE_VALUE, MAX_DISTANCE_VALUE, MAX_DISTANCE_VALUE },
    rearDist = { MAX_DISTANCE_VALUE, MAX_DISTANCE_VALUE, MAX_DISTANCE_VALUE },
    blindComingState = { 0.0, 0.0, 0.0 },
    currentAngle = 0.0,
    radiusCenter = {},
    frontRadiusBase = 0.0,
    rearRadiusBase = 0.0,
    forwardTrack = {},
    backwardTrack = {},
    forwardArrow = nil,
    backwardArrow = nil,
    forwardArrowC = nil,
    backwardArrowC = nil,
    forwardArrowCSize = {},
    backwardArrowCSize = {},
    forwardArrowTransW = { {}, {} },
    forwardArrowTransC = { {}, {} },
    backwardArrowTransW = { {}, {} },
    backwardArrowTransC = { {}, {} },
    forwardTrackLevel = { 3, 3, 3, 3 },
    backwardTrackLevel = { 3, 3, 3, 3 },
    preWarnLevel = { {}, {}, {}, {}, {}, {} },
    worldRect = {},
    cameraRect = {},
    frontLineWarn = {},
    rearLineWarn = {},
    frontWarnLevel = {},
    rearWarnLevel = {},
    doorState = {},
    speed = 0.0,
    idenMatrix = nil
}

function ModModule:OnInit()
    ModParam = ModParam or {}
    ModParam.BsdLevel = ModParam.BsdLevel or { 1000, 2000, 3000 }
    local originData = GenerateModRect(self.MAX_POINT)
    if originData then
        for i = 1, 6 do
            self.worldRect[i] = GeometryModule:GenerateWorldGeo(originData)
            GeometryModule:AttachWorldGeometry("Mod", self.worldRect[i], i)
            self.cameraRect[i] = GeometryModule:GenerateWorldGeo(originData)
            GeometryModule:AttachCameraGeometry(i, "Mod", self.cameraRect[i])
        end
    end

    local cameraGeos = {
        Geometry_UnpackGeoInst(self.cameraRect[1]),
        Geometry_UnpackGeoInst(self.cameraRect[2]),
        Geometry_UnpackGeoInst(self.cameraRect[3]),
        Geometry_UnpackGeoInst(self.cameraRect[4]),
        Geometry_UnpackGeoInst(self.cameraRect[5]),
        Geometry_UnpackGeoInst(self.cameraRect[6])
    }

    local worldGeos = {
        Geometry_UnpackGeoInst(self.worldRect[1]),
        Geometry_UnpackGeoInst(self.worldRect[2]),
        Geometry_UnpackGeoInst(self.worldRect[3]),
        Geometry_UnpackGeoInst(self.worldRect[4]),
        Geometry_UnpackGeoInst(self.worldRect[5]),
        Geometry_UnpackGeoInst(self.worldRect[6])
    }

    self.forwardArrow = GeometryModule:GenerateWorldGeo(GenerateArrow(1000, ARROW_HEIGHT, false))
    self.backwardArrow = GeometryModule:GenerateWorldGeo(GenerateArrow(1000, ARROW_HEIGHT, true))

    Mod_CreateModule(self.MAX_POINT, worldGeos, cameraGeos)
    Mod_UpdateSetting(ModParam)

    self.idenMatrix = Math_CreateMatrix()

    StateModule:AttachNotifier("Speed", self, ModModule.OnSpeedChanged)
    StateModule:AttachNotifier("WheelAngle", self, ModModule.OnWheelAngleChanged)
    StateModule:AttachNotifier("Door", self, ModModule.OnDoorStateChanged)
end

function ModModule:OnSpeedChanged(value)
    self.speed = value
    if self.followState > 0 and value > 5.0 then
        self.followState = 0
    end
end

function ModModule:OnDoorStateChanged(value, index)
    if self.speed == 0.0 then
        if (index == 1 or index == 3) and value == 1 and self.doorState[index] == 0 and self.rearState[1] >= BSD_DETECT_STATE then
            Mod_Callback(DetectionChannel.REAR_FISHEYE_BSD_DETECT_CHANNEL, DetectionEvent.EVENT_BLIND, 0, self.preWarnLevel[3][1])
        end
        if (index == 2 or index == 4) and value == 1 and self.doorState[index] == 0 and self.rearState[3] >= BSD_DETECT_STATE then
            Mod_Callback(DetectionChannel.REAR_FISHEYE_BSD_DETECT_CHANNEL, DetectionEvent.EVENT_BLIND, 2, self.preWarnLevel[3][3])
        end
    end
    self.doorState[index] = value
end

function ModModule:OnWheelAngleChanged(value)
    if value > VehicleInfo.MaxWheelAngle then
        value = VehicleInfo.MaxWheelAngle
    end
    if value < -VehicleInfo.MaxWheelAngle then
        value = -VehicleInfo.MaxWheelAngle
    end
    local trackIndex = value - math.fmod(value, Common.TrackPrecision)
    local trackRearRadius = (trackIndex == 0) and 0 or (VehicleInfo.WheelBase / math.tan(math.rad(trackIndex)))
    self.radiusCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, trackRearRadius }
    self.frontRadiusBase = Math_VectorGetLength({ self.radiusCenter[1] - CalibInfo.CalibFrontPosition, 0.0, self.radiusCenter[3] })
    self.rearRadiusBase = Math_VectorGetLength({ self.radiusCenter[1] - (CalibInfo.CalibFrontPosition - VehicleInfo.CarLength), 0.0, self.radiusCenter[3] })

    if self.forwardTrack[trackIndex] == nil then
        local originData = GenerateAdasTrack(trackIndex, false)
        self.forwardTrack[trackIndex] = {}
        self.forwardTrack[trackIndex].cameraGeo = GeometryModule:GenerateCameraGeo(1, originData)
        self.forwardTrack[trackIndex].worldGeo = GeometryModule:GenerateWorldGeo(originData)
        if value == 0 then
            originData = GenerateCameraArrow(1000, ARROW_HEIGHT, false)
            self.forwardArrowC = GeometryModule:GenerateCameraGeo(1, originData)
            local trackPtIndex = MAX_ARROW_DIST / TRACK_STEP
            local layerIndex = ARROW_HEIGHT / TRACK_STEP
            local pointL = Geometry_GetGeoPoint(self.forwardTrack[trackIndex].cameraGeo[2], trackPtIndex)
            local pointR = Geometry_GetGeoPoint(self.forwardTrack[trackIndex].cameraGeo[3], trackPtIndex)
            local pointLB = Geometry_GetGeoPoint(self.forwardTrack[trackIndex].cameraGeo[2], trackPtIndex - layerIndex)
            local pointRB = Geometry_GetGeoPoint(self.forwardTrack[trackIndex].cameraGeo[3], trackPtIndex - layerIndex)
            local distL = Math_VectorGetLength({ pointL[1] - pointLB[1], pointL[2] - pointLB[2], 0 })
            local distR = Math_VectorGetLength({ pointR[1] - pointRB[1], pointR[2] - pointRB[2], 0 })
            self.forwardArrowCSize[1] = Math_VectorGetLength({ pointL[1] - pointR[1], pointL[2] - pointR[2], 0 })
            self.forwardArrowCSize[2] = (distR + distL) / 2.0
            self.forwardArrowCSize[3] = { (pointL[1] + pointR[1]) / 2, (pointL[2] + pointR[2]) / 2, (pointL[3] + pointR[3]) / 2 }
        end
    end

    if self.backwardTrack[trackIndex] == nil then
        local originData = GenerateAdasTrack(trackIndex, true)
        self.backwardTrack[trackIndex] = {}
        self.backwardTrack[trackIndex].cameraGeo = GeometryModule:GenerateCameraGeo(3, originData)
        self.backwardTrack[trackIndex].worldGeo = GeometryModule:GenerateWorldGeo(originData)
        if value == 0 then
            originData = GenerateCameraArrow(1000, ARROW_HEIGHT, true)
            self.backwardArrowC = GeometryModule:GenerateCameraGeo(3, originData)
            local trackPtIndex = MAX_ARROW_DIST / TRACK_STEP
            local layerIndex = ARROW_HEIGHT / TRACK_STEP
            local pointL = Geometry_GetGeoPoint(self.backwardTrack[trackIndex].cameraGeo[2], trackPtIndex)
            local pointR = Geometry_GetGeoPoint(self.backwardTrack[trackIndex].cameraGeo[3], trackPtIndex)
            local pointLB = Geometry_GetGeoPoint(self.backwardTrack[trackIndex].cameraGeo[2], trackPtIndex - layerIndex)
            local pointRB = Geometry_GetGeoPoint(self.backwardTrack[trackIndex].cameraGeo[3], trackPtIndex - layerIndex)
            local distL = Math_VectorGetLength({ pointL[1] - pointLB[1], pointL[2] - pointLB[2], 0 })
            local distR = Math_VectorGetLength({ pointR[1] - pointRB[1], pointR[2] - pointRB[2], 0 })
            self.backwardArrowCSize[1] = Math_VectorGetLength({ pointL[1] - pointR[1], pointL[2] - pointR[2], 0 })
            self.backwardArrowCSize[2] = (distR + distL) / 2.0
            self.backwardArrowCSize[3] = { (pointL[1] + pointR[1]) / 2, (pointL[2] + pointR[2]) / 2, (pointL[3] + pointR[3]) / 2 }
        end
    end
    self.currentAngle = trackIndex
    self:UpdateAdasTrack(1, Mod_GetObjects(1))
    self:UpdateAdasTrack(3, Mod_GetObjects(3))
end

function ModModule:OnUpdateScreenSize(vpWidth, vpHeight)
    vpWidth = vpWidth * Viewports[2][1][3]
    vpHeight = vpHeight * Viewports[2][1][4]

    self.frontLineWarn[1] = GeometryModule:GenerateWorldGeo(GenerateCornerWarn(-1, 1, vpWidth, vpHeight))
    self.frontLineWarn[2] = GeometryModule:GenerateWorldGeo(GenerateBorderWarn(1, vpHeight))
    self.frontLineWarn[3] = GeometryModule:GenerateWorldGeo(GenerateCornerWarn(1, 1, vpWidth, vpHeight))

    self.rearLineWarn[1] = GeometryModule:GenerateWorldGeo(GenerateCornerWarn(-1, -1, vpWidth, vpHeight))
    self.rearLineWarn[2] = GeometryModule:GenerateWorldGeo(GenerateBorderWarn(-1, vpHeight))
    self.rearLineWarn[3] = GeometryModule:GenerateWorldGeo(GenerateCornerWarn(1, -1, vpWidth, vpHeight))
end

function ModModule:OnUpdateSetting(keyString)
    if string.find(keyString, "VehicleInfo") then
        Mod_UpdateConfig()
    end
    if string.find(keyString, "CalibExtra") then
        self:OnUpdateConfig()
    end
end

function ModModule:UpdateAdasTrack(camIdx, objects)
    if camIdx ~= 1 and camIdx ~= 3 then
        return
    end
    local nearestCenterDist = MAX_ARROW_DIST
    for ii, v in ipairs(objects) do
        -- calculate adas track level
        local objDistZ = 0.0
        local objDistX = 0.0
        local crossCenter = false
        if self.radiusCenter[3] == 0.0 then
            if camIdx == 1 then
                objDistX = v.Position[1] - CalibInfo.CalibFrontPosition
            elseif camIdx == 3 then
                objDistX = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength - v.Position[1]
            end
            if camIdx == 1 then
                if v.Right[3] < -VehicleInfo.CarWidth / 2 then
                    objDistZ = v.Right[3] + VehicleInfo.CarWidth / 2
                elseif v.Left[3] > VehicleInfo.CarWidth / 2 then
                    objDistZ = v.Left[3] - VehicleInfo.CarWidth / 2
                elseif v.Right[3] > 0.0 and v.Right[3] < VehicleInfo.CarWidth / 2 or v.Left[3] < 0.0 and v.Left[3] > -VehicleInfo.CarWidth / 2 then
                    crossCenter = true
                end
            elseif camIdx == 3 then
                if v.Left[3] < -VehicleInfo.CarWidth / 2 then
                    objDistZ = v.Left[3] + VehicleInfo.CarWidth / 2
                elseif v.Right[3] > VehicleInfo.CarWidth / 2 then
                    objDistZ = v.Right[3] - VehicleInfo.CarWidth / 2
                elseif v.Left[3] > 0.0 and v.Left[3] < VehicleInfo.CarWidth / 2 or v.Right[3] < 0.0 and v.Right[3] > -VehicleInfo.CarWidth / 2 then
                    crossCenter = true
                end
            end
        else
            local position = Math_VectorGetNormalized({ v.Position[1] - self.radiusCenter[1], 0.0, v.Position[3] - self.radiusCenter[3] })
            local rightDist = Math_VectorGetLength({ v.Right[1] - self.radiusCenter[1], 0.0, v.Right[3] - self.radiusCenter[3] })
            local leftDist = Math_VectorGetLength({ v.Left[1] - self.radiusCenter[1], 0.0, v.Left[3] - self.radiusCenter[3] })

            if camIdx == 1 then
                position = { position[1] * self.frontRadiusBase + self.radiusCenter[1], 0.0, position[3] * self.frontRadiusBase + self.radiusCenter[3] }
                local posDist = Math_VectorGetLength({ position[1] - CalibInfo.CalibFrontPosition, 0.0, position[3] })
                objDistX = math.asin(posDist / 2.0 / self.frontRadiusBase) * 2 * self.frontRadiusBase
                rightDist = rightDist - self.frontRadiusBase
                leftDist = leftDist - self.frontRadiusBase
                if self.radiusCenter[3] < 0.0 then
                    if rightDist < -VehicleInfo.CarWidth / 2 then
                        objDistZ = rightDist + VehicleInfo.CarWidth / 2
                    elseif leftDist > VehicleInfo.CarWidth / 2 then
                        objDistZ = leftDist - VehicleInfo.CarWidth / 2
                    elseif rightDist > 0 and rightDist < VehicleInfo.CarWidth / 2 or leftDist < 0 and leftDist > -VehicleInfo.CarWidth / 2 then
                        crossCenter = true
                    end
                else
                    if rightDist > VehicleInfo.CarWidth / 2 then
                        objDistZ = VehicleInfo.CarWidth / 2 - rightDist
                    elseif leftDist < -VehicleInfo.CarWidth / 2 then
                        objDistZ = -VehicleInfo.CarWidth / 2 - leftDist
                    elseif leftDist > 0 and leftDist < VehicleInfo.CarWidth / 2 or rightDist < 0 and rightDist > -VehicleInfo.CarWidth / 2 then
                        crossCenter = true
                    end
                end
            elseif camIdx == 3 then
                position = { position[1] * self.rearRadiusBase + self.radiusCenter[1], 0.0, position[3] * self.rearRadiusBase + self.radiusCenter[3] }
                local posDist = Math_VectorGetLength({ position[1] - (CalibInfo.CalibFrontPosition - VehicleInfo.CarLength), 0.0, position[3] })
                objDistX = math.asin(posDist / 2.0 / self.rearRadiusBase) * 2 * self.rearRadiusBase
                rightDist = rightDist - self.rearRadiusBase
                leftDist = leftDist - self.rearRadiusBase
                if self.radiusCenter[3] < 0.0 then
                    if rightDist > VehicleInfo.CarWidth / 2 then
                        objDistZ = rightDist - VehicleInfo.CarWidth / 2
                    elseif leftDist < -VehicleInfo.CarWidth / 2 then
                        objDistZ = leftDist + VehicleInfo.CarWidth / 2
                    elseif leftDist > 0 and leftDist < VehicleInfo.CarWidth / 2 or rightDist < 0 and rightDist > -VehicleInfo.CarWidth / 2 then
                        crossCenter = true
                    end
                else
                    if rightDist < -VehicleInfo.CarWidth / 2 then
                        objDistZ = -(rightDist + VehicleInfo.CarWidth / 2)
                    elseif leftDist > VehicleInfo.CarWidth / 2 then
                        objDistZ = VehicleInfo.CarWidth / 2 - leftDist
                    elseif rightDist > 0 and rightDist < VehicleInfo.CarWidth / 2 or leftDist < 0 and leftDist > -VehicleInfo.CarWidth / 2 then
                        crossCenter = true
                    end
                end
            end
        end
        local newLevel = { 3, 3, 3, 3 }
        if objDistZ == 0.0 then
            if objDistX < 1500 then
                newLevel = { crossCenter and 1 or 3, 1, 1, 1 }
            elseif objDistX < 3000 then
                newLevel = { crossCenter and 2 or 3, 2, 2, 2 }
            else
                newLevel = { 3, 2, 2, 3 }
            end
            if objDistX < nearestCenterDist then
                nearestCenterDist = objDistX
            end
        elseif math.abs(objDistZ) < 300 then
            local levelIndex = objDistZ < 0 and 2 or 3
            if objDistX < 1500 then
                newLevel[levelIndex] = 1
            else
                newLevel[levelIndex] = 2
            end
        end
        local pLevel = nil
        if camIdx == 1 then
            pLevel = self.forwardTrackLevel
        elseif camIdx == 3 then
            pLevel = self.backwardTrackLevel
        end
        for i = 1, 4 do
            if newLevel[i] < pLevel[i] then
                pLevel[i] = newLevel[i]
            end
        end
    end
    nearestCenterDist = nearestCenterDist - math.fmod(nearestCenterDist, 50)
    if nearestCenterDist < 500 then
        nearestCenterDist = 500
    end
    -- calculate world arrow trans
    -- local trackPtIndex = nearestCenterDist / TRACK_STEP
    -- local pTrack = camIdx == 1 and self.forwardTrack[self.currentAngle].worldGeo or self.backwardTrack[self.currentAngle].worldGeo
    -- local pTrans = camIdx == 1 and self.forwardArrowTransW or self.backwardArrowTransW

    -- local leftPoint = Geometry_GetGeoPoint(pTrack[2], trackPtIndex)
    -- local rightPoint = Geometry_GetGeoPoint(pTrack[3], trackPtIndex)

    -- pTrans[1].Position = {(leftPoint[1] + rightPoint[1]) / 2, (leftPoint[2] + rightPoint[2]) / 2, (leftPoint[3] + rightPoint[3]) / 2}
    -- pTrans[1].Rotation = {0, -math.deg(math.atan(rightPoint[1] - leftPoint[1], rightPoint[3] - leftPoint[3])), 0}

    -- trackPtIndex = math.floor(trackPtIndex * 0.6)
    -- leftPoint = Geometry_GetGeoPoint(pTrack[2], trackPtIndex)
    -- rightPoint = Geometry_GetGeoPoint(pTrack[3], trackPtIndex)

    -- pTrans[2].Position = {(leftPoint[1] + rightPoint[1]) / 2, (leftPoint[2] + rightPoint[2]) / 2, (leftPoint[3] + rightPoint[3]) / 2}
    -- pTrans[2].Rotation = {0, -math.deg(math.atan(rightPoint[1] - leftPoint[1], rightPoint[3] - leftPoint[3])), 0}

    -- calculate camera arrow trans
    -- local layerIndex = ARROW_HEIGHT / TRACK_STEP
    -- trackPtIndex = nearestCenterDist / TRACK_STEP
    -- pTrack = camIdx == 1 and self.forwardTrack[self.currentAngle].cameraGeo or self.backwardTrack[self.currentAngle].cameraGeo
    -- pTrans = camIdx == 1 and self.forwardArrowTransC or self.backwardArrowTransC
    -- local pSize = camIdx == 1 and self.forwardArrowCSize or self.backwardArrowCSize

    -- local lIdx = camIdx == 1 and 2 or 3
    -- local rIdx = camIdx == 1 and 3 or 2

    -- leftPoint = Geometry_GetGeoPoint(pTrack[lIdx], trackPtIndex)
    -- rightPoint = Geometry_GetGeoPoint(pTrack[rIdx], trackPtIndex)

    -- local leftLayerPoint = Geometry_GetGeoPoint(pTrack[lIdx], trackPtIndex - layerIndex)
    -- local rightLayerPoint = Geometry_GetGeoPoint(pTrack[rIdx], trackPtIndex - layerIndex)
    -- local lengthScale = (Math_VectorGetLength({leftLayerPoint[1] - leftPoint[1], leftLayerPoint[2] - leftPoint[2], 0}) + Math_VectorGetLength({rightLayerPoint[1] - rightPoint[1], rightLayerPoint[2] - rightPoint[2], 0})) / 2

    -- local widthScale = Math_VectorGetLength({rightPoint[1] - leftPoint[1], rightPoint[2] - leftPoint[2], 0}) / pSize[1]

    -- pTrans[1].Position = {(leftPoint[1] + rightPoint[1]) / 2 - pSize[3][1], (leftPoint[2] + rightPoint[2]) / 2 - pSize[3][2], (leftPoint[3] + rightPoint[3]) / 2 - pSize[3][3]}
    -- pTrans[1].Rotation = {0, 0, -math.deg(math.atan(rightPoint[2] - leftPoint[2], rightPoint[1] - leftPoint[1]))}
    -- -- pTrans[1].Scale = { widthScale, lengthScale / pSize[2], 0.0}

    -- trackPtIndex = math.floor(trackPtIndex * 0.6)
    -- leftPoint = Geometry_GetGeoPoint(pTrack[lIdx], trackPtIndex)
    -- rightPoint = Geometry_GetGeoPoint(pTrack[rIdx], trackPtIndex)

    -- leftLayerPoint = Geometry_GetGeoPoint(pTrack[lIdx], trackPtIndex - layerIndex)
    -- rightLayerPoint = Geometry_GetGeoPoint(pTrack[rIdx], trackPtIndex - layerIndex)
    -- lengthScale = (Math_VectorGetLength({leftLayerPoint[1] - leftPoint[1], leftLayerPoint[2] - leftPoint[2], 0}) + Math_VectorGetLength({rightLayerPoint[1] - rightPoint[1], rightLayerPoint[2] - rightPoint[2], 0})) / 2
    -- widthScale = Math_VectorGetLength({rightPoint[1] - leftPoint[1], rightPoint[2] - leftPoint[2], 0}) / pSize[1]

    -- pTrans[2].Position = {(leftPoint[1] + rightPoint[1]) / 2 - pSize[3][1], (leftPoint[2] + rightPoint[2]) / 2 - pSize[3][2], (leftPoint[3] + rightPoint[3]) / 2 - pSize[3][3]}
    -- pTrans[2].Rotation = {0, 0, -math.deg(math.atan(rightPoint[2] - leftPoint[2], rightPoint[1] - leftPoint[1]))}
    -- -- pTrans[2].Scale = {widthScale, lengthScale / pSize[2], 0.0}
end

function ModModule:OnUpdateSample()
    local worldUpdated, cameraUpdated = Mod_UpdateSample()
    if worldUpdated then
        local frontPos = CalibInfo.CalibFrontPosition
        local rearPos = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength
        for i = 1, 6 do
            if cameraUpdated[i] then
                local objects = Mod_GetObjects(i)
                local camIdx = i
                if camIdx == 5 then
                    camIdx = 2
                elseif camIdx == 6 then
                    camIdx = 4
                end
                if camIdx == 1 then
                    self.frontWarnLevel = {}
                    self.forwardTrackLevel = { 3, 3, 3, 3 }
                else
                    self.rearWarnLevel = {}
                    self.backwardTrackLevel = { 3, 3, 3, 3 }
                end

                local warnLevel = { 0, 0, 0 }
                local nearestDist = { MAX_DISTANCE_VALUE, MAX_DISTANCE_VALUE, MAX_DISTANCE_VALUE }
                for ii, v in ipairs(objects) do
                    local dist = 0
                    if camIdx == 1 then
                        dist = v.Position[1] - frontPos
                        -- elseif camIdx == 2 then
                        -- 	dist = v.Position[3] - rectWidth
                    elseif camIdx == 3 then
                        dist = rearPos - v.Position[1]
                        -- elseif camIdx == 4 then
                        -- 	dist = -rectWidth - v.Position[3]
                    end
                    local zDist = math.abs(v.Position[3]) - VehicleInfo.CarWidth / 2.0;

                    -- calculate border warn level
                    local index = 2
                    if v.Position[3] < -VehicleInfo.CarWidth / 2 then
                        index = 1
                    elseif v.Position[3] > VehicleInfo.CarWidth / 2 then
                        index = 3
                    end

                    if dist < nearestDist[index] and zDist < NEAR_WARN_ZDIST then
                        nearestDist[index] = dist
                    end

                    if dist < NEAR_WARN_DIST then
                        warnLevel[index] = 1
                    elseif dist < NEAR_WARN_DIST * 3 and (warnLevel[index] == 0 or warnLevel[index] > 2) then
                        warnLevel[index] = 2
                    else
                        warnLevel[index] = 3
                    end
                end

                local pWarnLevel = (camIdx == 1) and self.frontWarnLevel or self.rearWarnLevel
                for j = 1, 3 do
                    if warnLevel[j] == 1 or warnLevel[j] == 2 then
                        pWarnLevel[j] = warnLevel[j]
                    end
                    if self.preWarnLevel[camIdx][j] ~= warnLevel[j] then
                        self.preWarnLevel[camIdx][j] = warnLevel[j]
                        Mod_Callback(CAMERA_FUNCTIONIDS[camIdx], DetectionEvent.EVENT_PCW + DetectionEvent.EVENT_HMW, j - 1, warnLevel[j])
                    end
                end
                self:UpdateAdasTrack(camIdx, objects)

                if camIdx == 1 and self.speed == 0.0 and nearestDist[2] < MAX_DISTANCE_VALUE then
                    if self.followState == 0 or nearestDist[2] < 8000 then
                        local dist = nearestDist[2] - nearestDist[2] % FOLLOW_STEP
                        if self.followState == 0 then
                            self.followDist = dist
                            self.followStartDist = dist
                            self.followState = 1
                        else
                            if dist < self.followStartDist then
                                self.followDist = dist
                                self.followStartDist = dist
                                self.followState = 1;
                            elseif dist > self.followDist then
                                self.followState = self.followState + 1
                                self.followDist = dist
                                if self.followState == FOLLOW_STATE_MAX then
                                    Mod_Callback(DetectionChannel.FRONT_FISHEYE_BSD_DETECT_CHANNEL, DetectionEvent.EVENT_FOLLOW_FRONT, 0, self.followDist);
                                end
                            end
                        end
                    end
                end
                if camIdx == 3 then
                    for j = 1, 3 do
                        if nearestDist[j] < MAX_DISTANCE_VALUE then
                            local dist = nearestDist[j] - nearestDist[j] % FOLLOW_STEP
                            if self.rearState[j] == 0 then
                                self.rearStartDist[j] = dist
                                self.rearDist[j] = dist
                                self.rearState[j] = 1
                            else
                                if dist > self.rearStartDist[j] then
                                    self.rearStartDist[j] = dist
                                    self.rearDist[j] = dist
                                    self.rearState[j] = 1;
                                elseif dist < self.rearDist[j] then
                                    self.rearState[j] = self.rearState[j] + 1
                                    self.rearDist[j] = dist
                                    if self.rearState[j] == BSD_DETECT_STATE then
                                        if self.speed == 0 and j ~= 2 then
                                            local doorIndexB = (j == 1 and 1 or 2)
                                            if self.doorState[doorIndexB] or self.doorState[doorIndexB + 2] then
                                                Mod_Callback(DetectionChannel.REAR_FISHEYE_BSD_DETECT_CHANNEL, DetectionEvent.EVENT_BLIND, j - 1, self.preWarnLevel[camIdx][j])
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if self.rearState[j] >= BSD_DETECT_STATE then
                                self.rearState[j] = self.rearState[j] + 1
                                if self.rearState[j] == 30 then
                                    self.rearState[j] = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function ModModule:OnUpdateConfig()
    Mod_UpdateConfig()
    self.forwardTrack = {}
    self.backwardTrack = {}
    self:OnWheelAngleChanged(self.currentAngle)
end

function ModModule:OnRender(sceneContent, currentView, projMatrix, transformMatrix)
    if sceneContent.BorderWarn then
        for i = 1, 3 do
            if self.frontWarnLevel[i] then
                Geometry_RenderGeoInst(self.frontLineWarn[i], self.idenMatrix, self.idenMatrix, {}, LEVEL_COLOR[self.frontWarnLevel[i]])
            end
            if self.rearWarnLevel[i] then
                local color = table.Clone(LEVEL_COLOR[self.rearWarnLevel[i]])
                Geometry_RenderGeoInst(self.rearLineWarn[i], self.idenMatrix, self.idenMatrix, {}, color)
            end
        end
    end
    if sceneContent.FTrack then
        for i, v in ipairs(self.forwardTrack[self.currentAngle].worldGeo) do
            Geometry_RenderGeoInst(v, projMatrix, transformMatrix, {}, LEVEL_COLOR[self.forwardTrackLevel[i]])
        end
        -- Geometry_RenderGeoInst(self.forwardArrow, projMatrix, transformMatrix, self.forwardArrowTransW[1], LEVEL_COLOR[self.forwardTrackLevel[4]])
        -- Geometry_RenderGeoInst(self.forwardArrow, projMatrix, transformMatrix, self.forwardArrowTransW[2], LEVEL_COLOR[self.forwardTrackLevel[4]])
    end
    if sceneContent.BTrack then
        for i, v in ipairs(self.backwardTrack[self.currentAngle].worldGeo) do
            Geometry_RenderGeoInst(v, projMatrix, transformMatrix, {}, LEVEL_COLOR[self.backwardTrackLevel[i]])
        end
        -- Geometry_RenderGeoInst(self.backwardArrow, projMatrix, transformMatrix, self.backwardArrowTransW[1], LEVEL_COLOR[self.backwardTrackLevel[4]])
        -- Geometry_RenderGeoInst(self.backwardArrow, projMatrix, transformMatrix, self.backwardArrowTransW[2], LEVEL_COLOR[self.backwardTrackLevel[4]])
    end
end

function ModModule:OnRender2D(cameraIndex, sceneContent, transformMatrix)
    if sceneContent.FTrack then
        for i, v in ipairs(self.forwardTrack[self.currentAngle].cameraGeo) do
            Geometry_RenderGeoInst(v, transformMatrix, nil, {}, LEVEL_COLOR[self.forwardTrackLevel[i]])
        end
        -- Geometry_RenderGeoInst(self.forwardArrowC, transformMatrix, nil, self.forwardArrowTransC[1], LEVEL_COLOR[self.forwardTrackLevel[4]])
        -- Geometry_RenderGeoInst(self.forwardArrowC, transformMatrix, nil, self.forwardArrowTransC[2], LEVEL_COLOR[self.forwardTrackLevel[4]])
    end
    if sceneContent.BTrack then
        for i, v in ipairs(self.backwardTrack[self.currentAngle].cameraGeo) do
            Geometry_RenderGeoInst(v, transformMatrix, nil, {}, LEVEL_COLOR[self.backwardTrackLevel[i]])
        end
        -- Geometry_RenderGeoInst(self.backwardArrowC, transformMatrix, nil, self.backwardArrowTransC[1], LEVEL_COLOR[self.backwardTrackLevel[4]])
        -- Geometry_RenderGeoInst(self.backwardArrowC, transformMatrix, nil, self.backwardArrowTransC[2], LEVEL_COLOR[self.backwardTrackLevel[4]])
    end
end

AllModules["Mod"] = ModModule

