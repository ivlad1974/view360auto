RadarPosition = --define radar position for type of radars
{
    { { 0.0, 1.0 } }, -- one radar sensor
    { { -0.9, 0.95 }, { 0.9, 0.95 } }, --two radar sensor
    { { -0.9, 0.95 }, { 0.0, 1.0 }, { 0.9, 0.95 } }, --three radar sensor
    { { -0.8, 0.85 }, { -0.3, 1.0 }, { 0.3, 1.0 }, { 0.8, 0.95 } }, -- four radar sensor
    { { -0.9, 0.95 }, { -0.5, 1.0 }, { 0.0, 1.0 }, { 0.5, 1.0 }, { 0.9, 0.95 } } -- five radar sensor
}

function TransformToRadarArc(radarRadius, RadarBase, startPoint, index, maxIndex, radarIndex)
    local L = startPoint[1]
    if (L < 0) then
        L = -L
    end
    local W = startPoint[3]
    if (W < 0) then
        W = -W
    end
    --print("radarRadius -L" ,radarRadius, L )
    local SumArcRadian = math.sqrt((radarRadius - L) * (radarRadius - L) + W * W) / radarRadius
    local tmpArcRAdian = SumArcRadian
    if (startPoint[3] > 0) then
        tmpArcRAdian = SumArcRadian - math.fmod(radarIndex, 2) * SumArcRadian / 2
    else
        tmpArcRAdian = SumArcRadian - math.fmod(radarIndex - 1, 2) * SumArcRadian / 2
    end
    --print("point index", index)
    local arcRadian = 0
    if (tmpArcRAdian > SumArcRadian / 2) then
        arcRadian = tmpArcRAdian - index * tmpArcRAdian / maxIndex / 2 -- TODO /2 is not correct
    else
        arcRadian = index * tmpArcRAdian / maxIndex
    end
    --print("Sum", tmpArcRAdian, arcRadian)
    local cosRadian = math.cos(arcRadian)
    local sinRadian = math.sin(arcRadian)

    local newX = radarRadius * cosRadian
    local newZ = radarRadius * sinRadian
    if (startPoint[3] < 0) then
        newZ = -newZ
    end
    if (startPoint[1] < 0) then
        newX = -newX
    end

    --print("position ", newX, newZ)
    local newTrackPos = { RadarBase[1] + newX, 0.0, RadarBase[3] + newZ }
    return newTrackPos

end

function distance(p1, p2)
    local dx = p2[1] - p1[1]
    local dy = p2[2] - p1[2]
    return math.sqrt(dx * dx + dy * dy)
end
--https://www.cnblogs.com/wiki3d/p/4275961.html
--贝塞尔曲线折线拟合
--count为插入点数, outPoints为输出点集合，长度为count + 2(含首尾)
function ParseBezier(startPoint, endPoint, control1, control2, count, outPoints)
    if count < 0 then
        count = 25
    end ;

    outPoints[#outPoints + 1] = startPoint;

    for i = 1, count do
        local index = #outPoints + 1
        local st = i / (count + 1);
        local dt = (1 - st);
        local temp = {}
        --二次项
        local st2 = st * st;
        local dt2 = dt * dt;

        local t0 = dt * dt2;
        local t1 = dt2 * st * 3;
        local t2 = dt * st2 * 3;
        local t3 = st * st2;

        temp[1] = startPoint[1] * t0 + control1[1] * t1 + control2[1] * t2 + endPoint[1] * t3;
        temp[2] = startPoint[2] * t0 + control1[2] * t1 + control2[2] * t2 + endPoint[2] * t3;
        outPoints[index] = temp;
        --outPoints.push_back(start * t0 + control1 * t1 + control2 * t2 + end * t3);
        --print(i,outPoints[i][1],outPoints[i][2])
    end
    outPoints[#outPoints + 1] = endPoint;
    return outPoints
    --outPoints.push_back(end);
end
--取消尾节点方便连线
function _parseBezier(startPoint, endPoint, control1, control2, count, outPoints)
    if count < 0 then
        count = 25
    end ;

    outPoints[#outPoints + 1] = startPoint;

    for i = 1, count do
        local index = #outPoints + 1
        local st = i / (count + 1);
        local dt = (1 - st);
        local temp = {}
        --二次项
        local st2 = st * st;
        local dt2 = dt * dt;

        local t0 = dt * dt2;
        local t1 = dt2 * st * 3;
        local t2 = dt * st2 * 3;
        local t3 = st * st2;
        temp[1] = startPoint[1] * t0 + control1[1] * t1 + control2[1] * t2 + endPoint[1] * t3;
        temp[2] = startPoint[2] * t0 + control1[2] * t1 + control2[2] * t2 + endPoint[2] * t3;
        outPoints[index] = temp
        --outPoints.push_back(start * t0 + control1 * t1 + control2 * t2 + end * t3);
        --print(index,outPoints[index][1],outPoints[index][2])
    end
    return outPoints
end
--控制点生成
function GetControlPoint(pt, p1, p2, ratio)
    local length1 = Math_VectorGetLength({ p1[1] - pt[1], p1[2] - pt[2] })
    local length2 = Math_VectorGetLength({ p2[1] - pt[1], p2[2] - pt[2] })
    local v = length2 / (length1 + 0.000001);
    local delta = { 0, 0 }
    if v > 1.0 then
        delta[1] = p1[1] - (pt[1] + (p2[1] - pt[1]) / (v + 0.000001))
        delta[2] = p1[2] - (pt[2] + (p2[2] - pt[2]) / (v + 0.000001))
    else
        delta[1] = pt[1] + (p1[1] - pt[1]) * v - p2[1]
        delta[2] = pt[2] + (p1[2] - pt[2]) * v - p2[2]
    end
    delta[1] = ratio * delta[1]
    delta[2] = ratio * delta[2]
    control1 = { pt[1] + delta[1], pt[2] + delta[2] }
    control2 = { pt[1] - delta[1], pt[2] - delta[2] }
    return control1, control2
end
--折线生成
function ParsePolyline(points, count, ratio)
    local pointsSize = #points;
    local outPoints = {}
    --插值至少需要三点
    if pointsSize < 3 then
        for i = 0, pointsSize do
            outPoints[#outPoints + 1] = points[i];
        end
    else

        local control1 = {}
        local control2 = {}
        local lastControl = {}
        control1, control2 = GetControlPoint(points[2], points[1], points[3], ratio);
        outPoints = _parseBezier(points[1], points[2], points[1], control1, count, outPoints);

        for i = 2, pointsSize - 1 do
            --根据中间各点生成与前一点连线

            lastControl = control2;
            control1, control2 = getControlPoint(points[i], points[i - 1], points[i + 1], ratio);
            outPoints = _parseBezier(points[i - 1], points[i], lastControl, control1, count, outPoints);
        end

        outPoints = _parseBezier(points[pointsSize - 2], points[pointsSize - 1], control2, points[pointsSize - 1], count, outPoints);

    end
end
--多边形生成
function ParsePolygon(points, count, ratio)
    local pointsSize = #points;
    local outPoints = {}
    --插值至少需要三点
    if pointsSize < 3 then
        for i = 0, pointsSize do
            outPoints[#outPoints + 1] = points[i];
        end
    else
        --顶点对应的前后控制点
        local control1 = {}
        local control2 = {}
        local firstControl = {}
        local lastControl = {}

        --首尾
        firstControl, lastControl = GetControlPoint(points[pointsSize], points[pointsSize - 1], points[1], ratio);
        control1, control2 = GetControlPoint(points[1], points[pointsSize], points[2], ratio);
        control1 = points[pointsSize]
        control2 = points[1]
        outPoints = _parseBezier(points[pointsSize], points[1], control1, control1, count, outPoints);


        --根据中间各点，生成与前一点连线
        for i = 2, pointsSize - 1 do
            lastControl = control2;
            control1, control2 = GetControlPoint(points[i], points[i - 1], points[i + 1], ratio);
            if points[i][1] == points[i + 1][1] then
                control2[1] = points[i + 1][1]
            end
            if points[i][1] == points[i - 1][1] then
                control1[1] = points[i - 1][1]
            end
            if points[i][2] == points[i + 1][2] then
                control2[2] = points[i + 1][2]
            end
            if points[i][2] == points[i - 1][2] then
                control1[2] = points[i - 1][2]
            end
            outPoints = _parseBezier(points[i - 1], points[i], lastControl, control1, count, outPoints);
        end

        outPoints = ParseBezier(points[pointsSize - 1], points[pointsSize], control2, firstControl, count, outPoints); --末端
    end
    return outPoints
end


--初始化坐标 测试 前六个为前面雷达，第一个和第六个为固定点 后面同理
--[[ 实物图
	 ----
	/	 \
	|	 |
	|	 |
	|	 |
	\    /
	 ----
]]--

--保存八个雷达用于重绘
local curRadarPoint = nil

function GetCurRadarPoint()
    --local FRONT_BEGIN = CalibInfo.CalibFrontPosition  --4580 -2310	2270
    --local REAR_BEGIN = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength  --4580 -2310	2270
    local REAR_BEGIN = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength
    local FRONT_BEGIN = CalibInfo.CalibFrontPosition

    curRadarPoint = {
        { -VehicleInfo.CarWidth / 2 - RadarParam.RADAR_RANGE_MAX / 2, FRONT_BEGIN + RadarParam.RADAR_RANGE_MAX * 3 / 8 }, --固定点 左前1
        { -VehicleInfo.CarWidth / 2 - RadarParam.RADAR_RANGE_MAX * 3 / 8, FRONT_BEGIN + RadarParam.RADAR_RANGE_MAX * 7 / 10 }, --固定点 左前2
        { -VehicleInfo.CarWidth / 2, FRONT_BEGIN + RadarParam.RADAR_RANGE_MAX },
        { -VehicleInfo.CarWidth / 2 + VehicleInfo.CarWidth / 3, FRONT_BEGIN + RadarParam.RADAR_RANGE_MAX },
        { -VehicleInfo.CarWidth / 2 + VehicleInfo.CarWidth * 2 / 3, FRONT_BEGIN + RadarParam.RADAR_RANGE_MAX },
        { VehicleInfo.CarWidth / 2, FRONT_BEGIN + RadarParam.RADAR_RANGE_MAX },
        { VehicleInfo.CarWidth / 2 + RadarParam.RADAR_RANGE_MAX * 3 / 8, FRONT_BEGIN + RadarParam.RADAR_RANGE_MAX * 7 / 10 }, --固定点 右前1
        { VehicleInfo.CarWidth / 2 + RadarParam.RADAR_RANGE_MAX / 2, FRONT_BEGIN + RadarParam.RADAR_RANGE_MAX * 3 / 8 }, --固定点 右前2
        { VehicleInfo.CarWidth / 2 + RadarParam.RADAR_RANGE_MAX / 2, REAR_BEGIN - RadarParam.RADAR_RANGE_MAX * 3 / 8 }, --固定点 右后1
        { VehicleInfo.CarWidth / 2 + RadarParam.RADAR_RANGE_MAX * 3 / 8, REAR_BEGIN - RadarParam.RADAR_RANGE_MAX * 7 / 10 }, --固定点 右后2
        { VehicleInfo.CarWidth / 2, REAR_BEGIN - RadarParam.RADAR_RANGE_MAX },
        { VehicleInfo.CarWidth / 2 - VehicleInfo.CarWidth / 3, REAR_BEGIN - RadarParam.RADAR_RANGE_MAX },
        { VehicleInfo.CarWidth / 2 - VehicleInfo.CarWidth * 2 / 3, REAR_BEGIN - RadarParam.RADAR_RANGE_MAX },
        { -VehicleInfo.CarWidth / 2, REAR_BEGIN - RadarParam.RADAR_RANGE_MAX },
        { -VehicleInfo.CarWidth / 2 - RadarParam.RADAR_RANGE_MAX * 3 / 8, REAR_BEGIN - RadarParam.RADAR_RANGE_MAX * 7 / 10 }, --固定点 左后1
        { -VehicleInfo.CarWidth / 2 - RadarParam.RADAR_RANGE_MAX / 2, REAR_BEGIN - RadarParam.RADAR_RANGE_MAX * 3 / 8 }, --固定点 左后2
        ["frontId"] = 2,
        ["frontIdEnd"] = 6,
        ["rearId"] = 10,
        ["rearIdend"] = 14,
    }
end

function GenerateDistanceRadar(radarId, radarValue)
    local VertexArrayData = {
        VertexData = {},
        ColorData = {},
        IndexData = { 2, 0, 3, 1, 7, 5, 6, 4, 2, 0 },
        GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = true,
        CullDisable = true,
    }
    local LineArrayData = {
        VertexData = {},
        ColorData = {},
        IndexData = { 2, 0, 3, 1, 7, 5, 6, 4 },
        GeoMode = GL_DEFINES.GL_LINES,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        LineWidth = 2.0,
        DepthTest = true,
        CullDisable = true,
    }
    local FAREST_COLOR = { 0.0, 1.0, 0.0, 0.3 }
    local NEAREST_COLOR = { 1.0, 0.0, 0.0, 0.3 }
    local ANGLE_MAX = 120
    local AGNLE_MIN = 30

    local RADAR_HEIGHT = CalibInfo.CalibLengthUnit * 0.8
    local ANGLE_LIMIT = math.rad(AGNLE_MIN)
    local RADAR_RANGE = math.rad(ANGLE_MAX)
    local radarCenter = { 0.0, 0.0, 0.0 }
    local radarBaseLen = 0
    local inteFac = radarValue / RadarParam.RADAR_RANGE_MAX

    local radarLen = radarValue
    local centerAngle = 0
    local angleBegin = 0
    local angleEnd = 0
    local PART_ANGLE = 0
    local RADAR_SEP = 1.0

    local CALIB_OFFSET = (CalibInfo.CalibFrontPosition  - VehicleInfo.CarLength / 2)

    local REAR_BEGIN = -(CalibInfo.CalibFrontPosition + CALIB_OFFSET)
    local FRONT_BEGIN = (CalibInfo.CalibFrontPosition + CALIB_OFFSET)
    local LEFT_BEGIN = -VehicleInfo.CarWidth / 2 - RadarParam.LEFT_RADAR_CNT * 100
    local RIGHT_BEGIN = VehicleInfo.CarWidth / 2 + RadarParam.RIGHT_RADAR_CNT * 100
    local LEFT_RADAR_LEN = (VehicleInfo.CarLength - (RadarParam.LEFT_RADAR_CNT - 1) * 100) / RadarParam.LEFT_RADAR_CNT
    local RIGHT_RADAR_LEN = (VehicleInfo.CarLength - (RadarParam.RIGHT_RADAR_CNT - 1) * 100) / RadarParam.RIGHT_RADAR_CNT
    local RADAR_SIDE_BOTTOM = -VehicleInfo.CarLength / 2
    local scaleHY = 1.0

    for p = 1, 8 do
        VertexArrayData.ColorData[p] = {}
        for c = 1, 4 do
            VertexArrayData.ColorData[p][c] = FAREST_COLOR[c] * math.sqrt(inteFac) + NEAREST_COLOR[c] * math.sqrt(1 - inteFac)
        end
    end

    if radarId <= RadarParam.FRONT_RADAR_CNT then
        ANGLE_LIMIT = math.rad((ANGLE_MAX / RadarParam.FRONT_RADAR_CNT))
        local footLen = VehicleInfo.CarLength / 4
        radarCenter[1] = FRONT_BEGIN - footLen
        PART_ANGLE = RADAR_RANGE / RadarParam.FRONT_RADAR_CNT
        local ANGLE_BIAS = 0
        if PART_ANGLE > ANGLE_LIMIT then
            ANGLE_BIAS = (PART_ANGLE - ANGLE_LIMIT) / 2
        end
        radarBaseLen = math.sqrt(footLen * footLen + VehicleInfo.CarWidth * VehicleInfo.CarWidth / 4)
        angleBegin = -RADAR_RANGE / 2 + (radarId - 1) * PART_ANGLE + math.rad(RADAR_SEP) + ANGLE_BIAS
        angleEnd = angleBegin + PART_ANGLE - math.rad(RADAR_SEP * 2) - ANGLE_BIAS * 2

        VertexArrayData.VertexData[1] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[1][1] = math.cos(angleBegin) * (radarBaseLen + radarLen) + radarCenter[1]
        VertexArrayData.VertexData[1][3] = math.sin(angleBegin) * (radarBaseLen + radarLen)
        VertexArrayData.VertexData[2] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[2][1] = math.cos(angleEnd) * (radarBaseLen + radarLen) + radarCenter[1]
        VertexArrayData.VertexData[2][3] = math.sin(angleEnd) * (radarBaseLen + radarLen)

    elseif radarId > RadarParam.FRONT_RADAR_CNT and radarId <= (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT) then
        ANGLE_LIMIT = math.rad((ANGLE_MAX / RadarParam.REAR_RADAR_CNT))
        local footLen = VehicleInfo.CarLength / 4
        radarCenter[1] = REAR_BEGIN + footLen
        PART_ANGLE = RADAR_RANGE / RadarParam.REAR_RADAR_CNT
        local ANGLE_BIAS = 0
        if PART_ANGLE > ANGLE_LIMIT then
            ANGLE_BIAS = (PART_ANGLE - ANGLE_LIMIT) / 2
        end
        radarBaseLen = math.sqrt(footLen * footLen + VehicleInfo.CarWidth * VehicleInfo.CarWidth / 4)
        angleBegin = math.rad(-180) + RADAR_RANGE / 2 - (radarId - RadarParam.FRONT_RADAR_CNT - 1) * PART_ANGLE - math.rad(RADAR_SEP)
        angleEnd = angleBegin - PART_ANGLE + math.rad(RADAR_SEP * 2)

        VertexArrayData.VertexData[1] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[1][1] = math.cos(angleBegin) * (radarBaseLen + radarLen) + radarCenter[1]
        VertexArrayData.VertexData[1][3] = math.sin(angleBegin) * (radarBaseLen + radarLen)
        VertexArrayData.VertexData[2] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[2][1] = math.cos(angleEnd) * (radarBaseLen + radarLen) + radarCenter[1]
        VertexArrayData.VertexData[2][3] = math.sin(angleEnd) * (radarBaseLen + radarLen)

    elseif radarId > (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT) and radarId <= (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT + RadarParam.LEFT_RADAR_CNT) then
        --左雷达
        local index = (radarId - 1 - RadarParam.FRONT_RADAR_CNT - RadarParam.REAR_RADAR_CNT)
        local XPos = RADAR_SIDE_BOTTOM + index * (LEFT_RADAR_LEN + 100)
        local XPosEnd = XPos + LEFT_RADAR_LEN
        local ZPos = LEFT_BEGIN - radarLen - VehicleInfo.CarWidth / 10
        local ZPosEnd = LEFT_BEGIN - radarLen - VehicleInfo.CarWidth / 10
        VertexArrayData.VertexData[1] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[1][1] = XPos
        VertexArrayData.VertexData[1][3] = ZPos
        VertexArrayData.VertexData[2] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[2][1] = XPosEnd
        VertexArrayData.VertexData[2][3] = ZPosEnd

    elseif radarId > (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT + RadarParam.LEFT_RADAR_CNT) and
            radarId <= (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT + RadarParam.LEFT_RADAR_CNT + RadarParam.RIGHT_RADAR_CNT) then
        --右雷达
        local index = (radarId - 1 - RadarParam.FRONT_RADAR_CNT - RadarParam.REAR_RADAR_CNT - RadarParam.LEFT_RADAR_CNT)
        local XPos = RADAR_SIDE_BOTTOM + index * (RIGHT_RADAR_LEN + 100)
        local XPosEnd = XPos + RIGHT_RADAR_LEN
        local ZPos = RIGHT_BEGIN + radarLen
        local ZPosEnd = RIGHT_BEGIN + radarLen
        VertexArrayData.VertexData[1] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[1][1] = XPos
        VertexArrayData.VertexData[1][3] = ZPos
        VertexArrayData.VertexData[2] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[2][1] = XPosEnd
        VertexArrayData.VertexData[2][3] = ZPosEnd

    end

    local vecHori = {}
    for i = 1, 3 do
        vecHori[i] = VertexArrayData.VertexData[2][i] - VertexArrayData.VertexData[1][i]
    end

    RADAR_HEIGHT = Math_VectorGetLength(vecHori) * scaleHY
    VertexArrayData.VertexData[3] = table.Clone(VertexArrayData.VertexData[1])
    VertexArrayData.VertexData[4] = table.Clone(VertexArrayData.VertexData[2])
    VertexArrayData.VertexData[3][2] = RADAR_HEIGHT
    VertexArrayData.VertexData[4][2] = RADAR_HEIGHT
    VertexArrayData.ColorData[3][4] = 0.0
    VertexArrayData.ColorData[4][4] = 0.0

    local normal = Math_VectorGetNormalized(Math_VectorGetCross({ 0.0, 1.0, 0.0 }, vecHori))

    --前雷达
    for i = 1, 3 do
        normal[i] = normal[i] * 100
    end

    --后雷达  --左雷达 --右雷达
    if radarId > RadarParam.FRONT_RADAR_CNT then
        for i = 1, 3 do
            normal[i] = -normal[i]
        end
    end

    --调节左右侧雷达宽度
    if radarId > (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT) then
        normal[3] = VehicleInfo.CarWidth / 10
    end

    for i = 5, 8 do
        VertexArrayData.VertexData[i] = table.Clone(VertexArrayData.VertexData[i - 4])
        for j = 1, 3 do
            VertexArrayData.VertexData[i][j] = VertexArrayData.VertexData[i][j] + normal[j]
        end
    end

    VertexArrayData.ColorData[7][4] = 0.0
    VertexArrayData.ColorData[8][4] = 0.0

    LineArrayData.VertexData = VertexArrayData.VertexData
    for i = 1, 8 do
        LineArrayData.ColorData[i] = table.Clone(VertexArrayData.ColorData[i])
        LineArrayData.ColorData[i][4] = LineArrayData.ColorData[i][4] * 2
    end
    return { VertexArrayData, LineArrayData }
end

function GenerateMzdRadar(radarId, radarValue)
    local VertexArrayData = {
        VertexData = {},
        ColorData = {},
        IndexData = {},
        GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = true,
        CullDisable = true,
    }
    --没有用到
    local LineArrayData = {
        VertexData = {},
        ColorData = {},
        IndexData = { 2, 0, 3, 1, 7, 5, 6, 4 },
        GeoMode = GL_DEFINES.GL_LINES,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        LineWidth = 2.0,
        DepthTest = true,
        CullDisable = true,
    }

    local FAREST_COLOR = { 0.0, 1.0, 0.0, 0.3 }
    local NEAREST_COLOR = { 1.0, 0.0, 0.0, 0.3 }

    local RADAR_HEIGHT = CalibInfo.CalibLengthUnit * 0.8
    local ANGLE_LIMIT = math.rad(25)
    local RADAR_RANGE = math.rad(100)
    local radarCenter = { 0.0, 0.0, 0.0 }
    local radarBaseLen = 0
    local inteFac = radarValue / RadarParam.RADAR_RANGE_MAX

    local radarLen = 0
    local centerAngle = 0
    local angleBegin = 0
    local angleEnd = 0
    local PART_ANGLE = 0
    local RADAR_SEP = 0
    local REAR_BEGIN = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength
    local FRONT_BEGIN = CalibInfo.CalibFrontPosition
    local footLen = VehicleInfo.CarLength / 4 + 100

    --左右雷达
    local LEFT_BEGIN = -VehicleInfo.CarWidth / 2 - RadarParam.LEFT_RADAR_CNT * 100
    local RIGHT_BEGIN = VehicleInfo.CarWidth / 2 + RadarParam.RIGHT_RADAR_CNT * 100
    local LEFT_RADAR_LEN = (VehicleInfo.CarLength - (RadarParam.LEFT_RADAR_CNT - 1) * 100) / RadarParam.LEFT_RADAR_CNT
    local RIGHT_RADAR_LEN = (VehicleInfo.CarLength - (RadarParam.RIGHT_RADAR_CNT - 1) * 100) / RadarParam.RIGHT_RADAR_CNT
    local RADAR_SIDE_BOTTOM = -VehicleInfo.CarLength / 2

    --雷达上色
    for p = 1, 40 do
        VertexArrayData.ColorData[p] = {}
        for c = 1, 4 do
            VertexArrayData.ColorData[p][c] = FAREST_COLOR[c] * math.sqrt(inteFac) + NEAREST_COLOR[c] * math.sqrt(1 - inteFac)
        end
    end

    VertexArrayData.VertexData = {}
    local vecHori = {}
    if radarId <= RadarParam.FRONT_RADAR_CNT then
        radarCenter[1] = FRONT_BEGIN - (footLen * 0.7)
        PART_ANGLE = RADAR_RANGE / RadarParam.FRONT_RADAR_CNT
        local ANGLE_BIAS = 0
        if PART_ANGLE > ANGLE_LIMIT then
            ANGLE_BIAS = (PART_ANGLE - ANGLE_LIMIT) / 2
        end
        radarBaseLen = math.sqrt(footLen * footLen + VehicleInfo.CarWidth * VehicleInfo.CarWidth / 4)
        angleBegin = -RADAR_RANGE / 2 + (radarId - 1) * PART_ANGLE + math.rad(RADAR_SEP) + ANGLE_BIAS
        angleEnd = angleBegin + PART_ANGLE - math.rad(RADAR_SEP * 2) - ANGLE_BIAS * 2
        for i = 1, 10 do
            VertexArrayData.VertexData[i] = { 0.0, 0.0, 0.0 }
            VertexArrayData.VertexData[i][1] = math.cos(angleBegin + (angleEnd - angleBegin) * (i - 1) / 10) * (radarBaseLen + radarLen) + radarCenter[1]
            VertexArrayData.VertexData[i][3] = math.sin(angleBegin + (angleEnd - angleBegin) * (i - 1) / 10) * (radarBaseLen + radarLen)
            VertexArrayData.VertexData[i + 20] = { 0.0, 0.0, 0.0 }
            VertexArrayData.VertexData[i + 20][1] = math.cos(angleBegin + (angleEnd - angleBegin) * (i - 1) / 10) * (radarBaseLen + radarLen + 200) + radarCenter[1]
            VertexArrayData.VertexData[i + 20][3] = math.sin(angleBegin + (angleEnd - angleBegin) * (i - 1) / 10) * (radarBaseLen + radarLen + 200)
        end

        for i = 1, 3 do
            vecHori[i] = VertexArrayData.VertexData[2][i] - VertexArrayData.VertexData[1][i]
        end
        RADAR_HEIGHT = Math_VectorGetLength(vecHori) * 1.2

        for i = 1, 10 do
            VertexArrayData.VertexData[i + 10] = table.Clone(VertexArrayData.VertexData[i])
            VertexArrayData.VertexData[i + 10][2] = RADAR_HEIGHT
            VertexArrayData.VertexData[i + 30] = table.Clone(VertexArrayData.VertexData[i + 20])
            VertexArrayData.VertexData[i + 30][2] = RADAR_HEIGHT
        end

        LineArrayData.VertexData = VertexArrayData.VertexData
        for i = 1, 40 do
            LineArrayData.ColorData[i] = table.Clone(VertexArrayData.ColorData[i])
            LineArrayData.ColorData[i][4] = LineArrayData.ColorData[i][4] * 2
        end

        VertexArrayData.IndexData = {}
        LineArrayData.IndexData = {}

        --空间划线
        for i = 1, 20 do
            local idx = #VertexArrayData.IndexData
            if i <= 10 then
                VertexArrayData.IndexData[idx + 1] = i + 19
                VertexArrayData.IndexData[idx + 2] = i - 1
            else
                VertexArrayData.IndexData[idx + 1] = 40 - (i - 10)
                VertexArrayData.IndexData[idx + 2] = 20 - (i - 10)
                if i == 20 then
                    VertexArrayData.IndexData[idx + 3] = table.Clone(VertexArrayData.IndexData[1])
                    VertexArrayData.IndexData[idx + 4] = table.Clone(VertexArrayData.IndexData[2])
                end
            end
        end

        --线条上色
        for i = 0, 39 do
            local idx = #LineArrayData.IndexData
            if (math.floor(i / 10) % 2) == 0 then
                LineArrayData.IndexData[idx + 1] = i
            else
                LineArrayData.IndexData[idx + 1] = (math.floor(i / 10) + 1) * 10 - i % 10 - 1
            end
        end
        LineArrayData = {}

    elseif radarId > RadarParam.FRONT_RADAR_CNT and radarId <= (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT) then
        radarCenter[1] = REAR_BEGIN + (footLen * 0.5)
        PART_ANGLE = RADAR_RANGE / RadarParam.REAR_RADAR_CNT
        local ANGLE_BIAS = 0
        if PART_ANGLE > ANGLE_LIMIT then
            ANGLE_BIAS = (PART_ANGLE - ANGLE_LIMIT) / 2
        end
        radarBaseLen = math.sqrt(footLen * footLen + VehicleInfo.CarWidth * VehicleInfo.CarWidth / 4)
        angleBegin = math.rad(-180) + RADAR_RANGE / 2 - (radarId - RadarParam.FRONT_RADAR_CNT - 1) * PART_ANGLE - math.rad(RADAR_SEP)
        angleEnd = angleBegin - PART_ANGLE + math.rad(RADAR_SEP * 2)
        for i = 1, 10 do
            VertexArrayData.VertexData[i] = { 0.0, 0.0, 0.0 }
            VertexArrayData.VertexData[i][1] = math.cos(angleBegin + (angleEnd - angleBegin) * (i - 1) / 10) * (radarBaseLen + radarLen) + radarCenter[1]
            VertexArrayData.VertexData[i][3] = math.sin(angleBegin + (angleEnd - angleBegin) * (i - 1) / 10) * (radarBaseLen + radarLen)
            VertexArrayData.VertexData[i + 20] = { 0.0, 0.0, 0.0 }
            VertexArrayData.VertexData[i + 20][1] = math.cos(angleBegin + (angleEnd - angleBegin) * (i - 1) / 10) * (radarBaseLen + radarLen + 200) + radarCenter[1]
            VertexArrayData.VertexData[i + 20][3] = math.sin(angleBegin + (angleEnd - angleBegin) * (i - 1) / 10) * (radarBaseLen + radarLen + 200)
        end

        for i = 1, 3 do
            vecHori[i] = VertexArrayData.VertexData[2][i] - VertexArrayData.VertexData[1][i]
        end
        RADAR_HEIGHT = Math_VectorGetLength(vecHori) * 1.2

        for i = 1, 10 do
            VertexArrayData.VertexData[i + 10] = table.Clone(VertexArrayData.VertexData[i])
            VertexArrayData.VertexData[i + 10][2] = RADAR_HEIGHT
            VertexArrayData.VertexData[i + 30] = table.Clone(VertexArrayData.VertexData[i + 20])
            VertexArrayData.VertexData[i + 30][2] = RADAR_HEIGHT
        end

        LineArrayData.VertexData = VertexArrayData.VertexData
        for i = 1, 40 do
            LineArrayData.ColorData[i] = table.Clone(VertexArrayData.ColorData[i])
            LineArrayData.ColorData[i][4] = LineArrayData.ColorData[i][4] * 2
        end

        VertexArrayData.IndexData = {}
        LineArrayData.IndexData = {}

        --空间划线
        for i = 1, 20 do
            local idx = #VertexArrayData.IndexData
            if i <= 10 then
                VertexArrayData.IndexData[idx + 1] = i + 19
                VertexArrayData.IndexData[idx + 2] = i - 1
            else
                VertexArrayData.IndexData[idx + 1] = 40 - (i - 10)
                VertexArrayData.IndexData[idx + 2] = 20 - (i - 10)
                if i == 20 then
                    VertexArrayData.IndexData[idx + 3] = table.Clone(VertexArrayData.IndexData[1])
                    VertexArrayData.IndexData[idx + 4] = table.Clone(VertexArrayData.IndexData[2])
                end
            end
        end

        --线条上色
        for i = 0, 39 do
            local idx = #LineArrayData.IndexData
            if (math.floor(i / 10) % 2) == 0 then
                LineArrayData.IndexData[idx + 1] = i
            else
                LineArrayData.IndexData[idx + 1] = (math.floor(i / 10) + 1) * 10 - i % 10 - 1
            end
        end
        LineArrayData = {}

    elseif radarId > (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT) and radarId <= (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT + RadarParam.LEFT_RADAR_CNT) then
        --左雷达
        local index = (radarId - 1 - RadarParam.FRONT_RADAR_CNT - RadarParam.REAR_RADAR_CNT)
        local XPos = RADAR_SIDE_BOTTOM + index * (LEFT_RADAR_LEN + 100)
        local XPosEnd = XPos + LEFT_RADAR_LEN
        local ZPos = LEFT_BEGIN - radarLen - VehicleInfo.CarWidth / 10
        local ZPosEnd = LEFT_BEGIN - radarLen - VehicleInfo.CarWidth / 10

        VertexArrayData.VertexData[1] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[1][1] = XPos
        VertexArrayData.VertexData[1][3] = ZPos
        VertexArrayData.VertexData[2] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[2][1] = XPosEnd
        VertexArrayData.VertexData[2][3] = ZPosEnd

        for i = 1, 3 do
            vecHori[i] = VertexArrayData.VertexData[2][i] - VertexArrayData.VertexData[1][i]
        end
        RADAR_HEIGHT = Math_VectorGetLength(vecHori) * 0.5
        VertexArrayData.VertexData[3] = table.Clone(VertexArrayData.VertexData[1])
        VertexArrayData.VertexData[4] = table.Clone(VertexArrayData.VertexData[2])
        VertexArrayData.VertexData[3][2] = RADAR_HEIGHT
        VertexArrayData.VertexData[4][2] = RADAR_HEIGHT

        local normal = Math_VectorGetNormalized(Math_VectorGetCross({ 0.0, 1.0, 0.0 }, vecHori))
        for i = 1, 3 do
            normal[i] = normal[i] * 100
        end
        normal[3] = VehicleInfo.CarWidth / 10

        for i = 5, 8 do
            VertexArrayData.VertexData[i] = table.Clone(VertexArrayData.VertexData[i - 4])
            for j = 1, 3 do
                VertexArrayData.VertexData[i][j] = VertexArrayData.VertexData[i][j] + normal[j]
            end
        end

        VertexArrayData.ColorData[7][4] = 0.0
        VertexArrayData.ColorData[8][4] = 0.0

        LineArrayData.VertexData = VertexArrayData.VertexData
        for i = 1, 40 do
            LineArrayData.ColorData[i] = table.Clone(VertexArrayData.ColorData[i])
            LineArrayData.ColorData[i][4] = LineArrayData.ColorData[i][4] * 2
        end

    elseif radarId > (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT + RadarParam.LEFT_RADAR_CNT) and radarId <= (RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT + RadarParam.LEFT_RADAR_CNT + RadarParam.RIGHT_RADAR_CNT) then
        --右雷达
        local index = (radarId - 1 - RadarParam.FRONT_RADAR_CNT - RadarParam.REAR_RADAR_CNT - RadarParam.LEFT_RADAR_CNT)
        local XPos = RADAR_SIDE_BOTTOM + index * (RIGHT_RADAR_LEN + 100)
        local XPosEnd = XPos + RIGHT_RADAR_LEN
        local ZPos = RIGHT_BEGIN + radarLen
        local ZPosEnd = RIGHT_BEGIN + radarLen

        VertexArrayData.VertexData[1] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[1][1] = XPos
        VertexArrayData.VertexData[1][3] = ZPos

        VertexArrayData.VertexData[2] = { 0.0, 0.0, 0.0 }
        VertexArrayData.VertexData[2][1] = XPosEnd
        VertexArrayData.VertexData[2][3] = ZPosEnd

        for i = 1, 3 do
            vecHori[i] = VertexArrayData.VertexData[2][i] - VertexArrayData.VertexData[1][i]
        end
        RADAR_HEIGHT = Math_VectorGetLength(vecHori) * 0.5

        VertexArrayData.VertexData[3] = table.Clone(VertexArrayData.VertexData[1])
        VertexArrayData.VertexData[4] = table.Clone(VertexArrayData.VertexData[2])
        VertexArrayData.VertexData[3][2] = RADAR_HEIGHT
        VertexArrayData.VertexData[4][2] = RADAR_HEIGHT

        local normal = Math_VectorGetNormalized(Math_VectorGetCross({ 0.0, 1.0, 0.0 }, vecHori))
        for i = 1, 3 do
            normal[i] = normal[i] * 100
        end
        normal[3] = VehicleInfo.CarWidth / 10

        for i = 5, 8 do
            VertexArrayData.VertexData[i] = table.Clone(VertexArrayData.VertexData[i - 4])
            for j = 1, 3 do
                VertexArrayData.VertexData[i][j] = VertexArrayData.VertexData[i][j] + normal[j]
            end
        end

        VertexArrayData.ColorData[7][4] = 0.0
        VertexArrayData.ColorData[8][4] = 0.0

        LineArrayData.VertexData = VertexArrayData.VertexData
        for i = 1, 40 do
            LineArrayData.ColorData[i] = table.Clone(VertexArrayData.ColorData[i])
            LineArrayData.ColorData[i][4] = LineArrayData.ColorData[i][4] * 2
        end

    end

    return { VertexArrayData, LineArrayData }
end

RadarGenerator = {
    GenerateMzdRadar,
    GenerateDistanceRadar,
}