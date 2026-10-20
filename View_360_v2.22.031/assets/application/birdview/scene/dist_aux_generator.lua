local HONDA_SIDE_OFFSET = 250
local HONDA_SIDE_OFFSET_L = 300
local HONDA_LINE_WIDTH = 6

function TransformToTrack(trackRadius, trackBase, trackRoundCenter, straightPoint)
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
	local newTrackPos = {trackRoundCenter[1] + newX, 0.0, trackRoundCenter[3] + newZ}
	return newTrackPos
end

function Generate4StepBackDistAux()
	local VertexArrayData = 
	{
		VertexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ZERO,
		LineWidth = 5.0,
		DepthTest = true,
	}
	local auxPartColor = {{0.80, 0.2, 0.2, 1.0}, {0.88, 0.83, 0.2, 1.0}, {0.16, 0.825, 0.0, 1.0}}
	local auxDist = {0.0, CalibInfo.CalibLengthUnit * 0.5, CalibInfo.CalibLengthUnit * 1.5, }
	local rearLeftBegin = {0.0, 0.0, 0.0}
	rearLeftBegin[1] = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength
	rearLeftBegin[3] = -VehicleInfo.CarWidth / 2
	local rearRightBegin = {rearLeftBegin[1], 0.0, -rearLeftBegin[3]}
	local auxFootLength ={CalibInfo.CalibLengthUnit * 0.1, CalibInfo.CalibLengthUnit * 0.5, CalibInfo.CalibLengthUnit * 0.6, CalibInfo.CalibLengthUnit * 1}
	VertexArrayData.VertexData[1] = {rearRightBegin[1] - 50, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[2] = {rearRightBegin[1] - 250, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[3] = {rearRightBegin[1] - 300, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[4] = {rearRightBegin[1] - 500, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[5] = {rearRightBegin[1] - 500, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[6] = {rearRightBegin[1] - 500, rearRightBegin[2], rearRightBegin[3] - 200}
	VertexArrayData.VertexData[7] = {rearRightBegin[1] - 600, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[8] = {rearRightBegin[1] - 1000, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[9] = {rearRightBegin[1] - 1100, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[10] = {rearRightBegin[1] - 1500, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[11] = {rearRightBegin[1] - 1500, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[12] = {rearRightBegin[1] - 1500, rearRightBegin[2], rearRightBegin[3] - 200}
	VertexArrayData.VertexData[13] = {rearRightBegin[1] - 1600, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[14] = {rearRightBegin[1] - 2200, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[15] = {rearRightBegin[1] - 2300, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[16] = {rearRightBegin[1] - 3000, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[17] = {rearRightBegin[1] - 3000, rearRightBegin[2], rearRightBegin[3]}
	VertexArrayData.VertexData[18] = {rearRightBegin[1] - 3000, rearRightBegin[2], rearRightBegin[3] - 200}
	for i = 1, 18 do
		VertexArrayData.VertexData[18 + i] = {VertexArrayData.VertexData[i][1], VertexArrayData.VertexData[i][2], -VertexArrayData.VertexData[i][3]}
		VertexArrayData.ColorData[i] = auxPartColor[ (i - 1) // 6 + 1]
		VertexArrayData.ColorData[i + 18] = VertexArrayData.ColorData[i]
	end
	return VertexArrayData
end

function GenerateBsdBackDistAux()
	local VertexArrayData = 
	{
		VertexData = {},
		SingleColor = {0.0, 1.0, 0.0, 1.0},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_ONE,
		DstRGBBlend = GL_DEFINES.GL_ZERO,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ZERO,
		LineWidth = 1.0,
		DepthTest = true,
	}
	local auxPartColor = {{1.0, 0.0, 0.0, 1.0}, {1.0, 1.0, 0.0, 1.0}, {0.0, 1.0, 0.0, 1.0}}
	local auxDist = {0.0, CalibInfo.CalibLengthUnit * 1, CalibInfo.CalibLengthUnit * 2}
	local rearLeftBegin = {0.0, 0.0, 0.0}
	rearLeftBegin[1] = -CalibInfo.CalibRectLength / 2 -- + CalibInfo.CalibLengthUnit
	rearLeftBegin[3] = -VehicleInfo.CarWidth
	local rearRightBegin = {rearLeftBegin[1], 0.0, -rearLeftBegin[3]}
	local auxFootLength ={CalibInfo.CalibLengthUnit * 0.1, CalibInfo.CalibLengthUnit * 0.5, CalibInfo.CalibLengthUnit * 0.6, CalibInfo.CalibLengthUnit * 1}
	for i = 1, 6 do      --0, 1, 2, 3, 4, 5m
		VertexArrayData.VertexData[i *4 - 3] = {rearLeftBegin[1] - (i-1) * auxDist[2], rearLeftBegin[2], rearLeftBegin[3]}
        VertexArrayData.VertexData[i *4 - 2] = {rearLeftBegin[1] - (i-1) * auxDist[2], rearLeftBegin[2], rearLeftBegin[3] + VehicleInfo.CarWidth / 2}
        VertexArrayData.VertexData[i *4 - 1] = {rearRightBegin[1] - (i-1) * auxDist[2], rearRightBegin[2], rearRightBegin[3]}
        VertexArrayData.VertexData[i *4    ] = {rearRightBegin[1] - (i-1) * auxDist[2] , rearRightBegin[2], rearRightBegin[3] - VehicleInfo.CarWidth / 2}
	end
	for i = 7, 9 do      --7, 10, 12
    -- -6 -1
    -- -7 - 3
    -- -8 - 5
		VertexArrayData.VertexData[i *4 - 3] = {rearLeftBegin[1] - (i-1) * auxDist[2] - (2 *(i-6) -1) * auxDist[2] , rearLeftBegin[2], rearLeftBegin[3]}
        VertexArrayData.VertexData[i *4 - 2] = {rearLeftBegin[1] - (i-1) * auxDist[2]- (2 *(i-6) -1) * auxDist[2], rearLeftBegin[2], rearLeftBegin[3] + VehicleInfo.CarWidth / 2}
        VertexArrayData.VertexData[i *4 - 1] = {rearRightBegin[1] - (i-1) * auxDist[2]- (2 *(i-6) -1) * auxDist[2], rearRightBegin[2], rearRightBegin[3]}
        VertexArrayData.VertexData[i *4    ] = {rearRightBegin[1] - (i-1) * auxDist[2]- (2 *(i-6) -1) * auxDist[2] , rearRightBegin[2], rearRightBegin[3] - VehicleInfo.CarWidth / 2}
	end
	return VertexArrayData
end

function GenerateLexusTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		-- SingleColor = {1.0, 0.65, 0.25},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = 4,
		DepthTest = true,
	}

	local TRACK_PART_COUNT = 21
	local CENTER_TRACK_LENGTH = 2 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / (TRACK_PART_COUNT - 1)
	local wheelRad = math.rad(wheelAngle)
	
	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength+ VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2}
	local trackLeftBeginR = {0.0, 0.0, -CalibInfo.CalibRectWidth / 2}
	local trackRightBeginR = {0.0, 0.0, CalibInfo.CalibRectWidth / 2}
	local trackCenterBegin = {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	local trackBegin = {trackLeftBegin, trackRightBegin, trackLeftBeginR, trackRightBeginR}
	if backward then
		trackCenterBegin[1][1] = rearCenter[1]
		trackCenterBegin[2][1] = CalibInfo.CalibRectLength / 2
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		trackRightBeginR[1] = CalibInfo.CalibRectLength / 2
		trackLeftBeginR[1] = CalibInfo.CalibRectLength / 2
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1][1] = frontCenter[1]
		trackCenterBegin[2][1] = rearAxisCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
		trackRightBeginR[1] = rearAxisCenter[1]
		trackLeftBeginR[1] = rearAxisCenter[1]
	end
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1][1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[1][3] - trackCircleCenter[3]
	local trackRadius = {0.0, 0.0}
	trackRadius[1] = math.sqrt(xDis * xDis + zDis * zDis)
	xDis = trackCenterBegin[2][1] - trackCircleCenter[1]
	zDis = trackCenterBegin[2][3] - trackCircleCenter[3]
	trackRadius[2] = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	for i = 1, TRACK_PART_COUNT do
		for j = 1, 4 do
			local straightPt = table.Clone(trackBegin[j])
			straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
			if wheelRad == 0 then
				VertexArrayData.VertexData[TRACK_PART_COUNT * (j - 1) + vertexIndex] = straightPt
			else
				VertexArrayData.VertexData[TRACK_PART_COUNT * (j - 1) + vertexIndex] = TransformToTrack(trackRadius[(j + 1) // 2], trackCenterBegin[(j + 1) // 2], trackCircleCenter, straightPt)
			end
			if wheelRad > 0 and j == 3 or wheelRad < 0 and j == 4 then
				VertexArrayData.ColorData[TRACK_PART_COUNT * (j - 1) + vertexIndex] = {0.0, 0.0, 0.0, 0.0}
			else
				VertexArrayData.ColorData[TRACK_PART_COUNT * (j - 1) + vertexIndex] = {1.0, 0.8, 0.25, 1.0}
			end
			if i > 1 then
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 2 + TRACK_PART_COUNT * (j - 1)
				VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1 + TRACK_PART_COUNT * (j - 1)
				indexIndex = indexIndex + 2
			end
		end
		vertexIndex = vertexIndex + 1
	end
	local TRACK_SPLIT = 10
	local trackSplitStep = VehicleInfo.CarWidth / (TRACK_SPLIT - 1)
	local barStep = {5, 10, 20}
	local barColor = { {1.0, 0.0, 0.0, 1.0}, {1.0, 0.8, 0.25, 1.0}, {1.0, 0.8, 0.25, 1.0}}
	for i = 1, 3 do
		local trackBg = table.Clone(trackBegin[1])
		trackBg[1] = trackBg[1] + trackDirection[1] * barStep[i]
		for j = 1, TRACK_SPLIT do
			local straightPt = table.Clone(trackBg)
			straightPt[3] = straightPt[3] + trackSplitStep * (j - 1)
			if wheelRad == 0 then
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = straightPt
			else
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = TransformToTrack(trackRadius[1], trackCenterBegin[1], trackCircleCenter, straightPt)
			end
			VertexArrayData.ColorData[#VertexArrayData.ColorData + 1] = barColor[i]
			if j > 1 then
				VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = #VertexArrayData.VertexData - 2
				VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = #VertexArrayData.VertexData - 1
			end
		end
	end
	return VertexArrayData
end


function GenerateSideBorder()
	local VertexArrayData = 
	{
		VertexData = {},
		SingleColor = {1.0, 0.65, 0.25},
		IndexData = {},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ZERO,
		LineWidth = 4.0,
		DepthTest = true,
	}
	local CROSS_ROOT = 300
	local BORDER_WIDTH = VehicleInfo.CarWidth / 2 + 300
	local LINE_PART = 25
	local REAR_BEGIN = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength
	local FRONT_BEGIN = CalibInfo.CalibFrontPosition
	local LINE_STEP = (FRONT_BEGIN - REAR_BEGIN) / (LINE_PART - 1)
	for j = 1, LINE_PART do
		VertexArrayData.VertexData[j * 2 - 1] = {REAR_BEGIN + LINE_STEP * (j - 1), 0.0, -BORDER_WIDTH}
		VertexArrayData.VertexData[j * 2] = {REAR_BEGIN + LINE_STEP * (j - 1), 0.0, BORDER_WIDTH}
		if j < LINE_PART then
			VertexArrayData.IndexData[j * 4 - 3] = j * 2 - 2
			VertexArrayData.IndexData[j * 4 - 2] = j * 2 - 0
			VertexArrayData.IndexData[j * 4 - 1] = j * 2 - 1
			VertexArrayData.IndexData[j * 4 - 0] = j * 2 + 1
		end
	end
	local CORNER_VERTEX = {1, 2, LINE_PART * 2 - 1, LINE_PART * 2}
	for j = 1, 4 do
		local bias = (math.fmod(j, 2) == 0) and -CROSS_ROOT or CROSS_ROOT
		local cornerIndex = CORNER_VERTEX[j]
		VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {VertexArrayData.VertexData[cornerIndex][1], VertexArrayData.VertexData[cornerIndex][2], VertexArrayData.VertexData[cornerIndex][3] + bias}
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = #VertexArrayData.VertexData - 1
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = cornerIndex - 1
	end
	local DOT_PART = 4
	for j = 1, 4 do
		local zbias = (math.fmod(j, 2) == 0) and CROSS_ROOT or -CROSS_ROOT
		local xbias = (j < 3) and -CROSS_ROOT * 2 or CROSS_ROOT * 2
		local cornerIndex = CORNER_VERTEX[j]
		local half_dotz = zbias / (DOT_PART * 2)
		local half_dotx = xbias / (DOT_PART * 2)
		for i = 1, DOT_PART do
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {VertexArrayData.VertexData[cornerIndex][1], VertexArrayData.VertexData[cornerIndex][2], VertexArrayData.VertexData[cornerIndex][3] + half_dotz * (i * 2 - 1)}
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {VertexArrayData.VertexData[cornerIndex][1], VertexArrayData.VertexData[cornerIndex][2], VertexArrayData.VertexData[cornerIndex][3] + half_dotz * (i * 2)}
			VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = #VertexArrayData.VertexData - 1
			VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = #VertexArrayData.VertexData - 2
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {VertexArrayData.VertexData[cornerIndex][1] + half_dotx * (i * 2 - 1), VertexArrayData.VertexData[cornerIndex][2], VertexArrayData.VertexData[cornerIndex][3]}
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {VertexArrayData.VertexData[cornerIndex][1] + half_dotx * (i * 2), VertexArrayData.VertexData[cornerIndex][2], VertexArrayData.VertexData[cornerIndex][3]}
			VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = #VertexArrayData.VertexData - 1
			VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = #VertexArrayData.VertexData - 2
		end
	end

	return VertexArrayData
end

function GenerateTirePrintTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		SingleColor = {1.0, 0.85, 0.0},
		IndexData = {},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_ONE,
		DstRGBBlend = GL_DEFINES.GL_ZERO,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ZERO,
		DepthTest = false,
	}

	local TRACK_PART_COUNT = 20
	local CENTER_TRACK_LENGTH = 3 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / TRACK_PART_COUNT
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
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
	
	VertexArrayData.VertexData[1] = {trackLeftBegin[1], trackLeftBegin[2], trackLeftBegin[3]}
	VertexArrayData.VertexData[2] = {trackLeftBegin[1], trackLeftBegin[2], trackLeftBegin[3] + CalibInfo.CalibLengthUnit * 0.4}
	VertexArrayData.VertexData[3] = {trackRightBegin[1], trackRightBegin[2], trackRightBegin[3]}
	VertexArrayData.VertexData[4] = {trackRightBegin[1], trackRightBegin[2], trackRightBegin[3] - CalibInfo.CalibLengthUnit * 0.4}
	if wheelRad == 0 then
		for i = 1, TRACK_PART_COUNT do
			for j = 1, 4 do 
				VertexArrayData.VertexData[i * 4 + j] = {VertexArrayData.VertexData[j][1] + trackDirection[1] * i, VertexArrayData.VertexData[j][2], VertexArrayData.VertexData[j][3]}
			end
			VertexArrayData.IndexData[i * 12 - 11] = i * 4 - 4
			VertexArrayData.IndexData[i * 12 - 10] = i * 4
			VertexArrayData.IndexData[i * 12 - 9] = i * 4
			VertexArrayData.IndexData[i * 12 - 8] = i * 4 + 1
			VertexArrayData.IndexData[i * 12 - 7] = i * 4 + 1
			VertexArrayData.IndexData[i * 12 - 6] = i * 4 - 3
			VertexArrayData.IndexData[i * 12 - 5] = i * 4 - 2
			VertexArrayData.IndexData[i * 12 - 4] = i * 4 + 2
			VertexArrayData.IndexData[i * 12 - 3] = i * 4 + 2
			VertexArrayData.IndexData[i * 12 - 2] = i * 4 + 3
			VertexArrayData.IndexData[i * 12 - 1] = i * 4 + 3
			VertexArrayData.IndexData[i * 12 - 0] = i * 4 - 1		
		end
	else
		local trackRearRadius = VehicleInfo.WheelBase / math.tan(wheelRad)
		local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
		local xDis = trackCenterBegin[1] - trackCircleCenter[1]
		local zDis = trackCenterBegin[3] - trackCircleCenter[3]
		local trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
		for i = 1, TRACK_PART_COUNT do
			for j = 1, 4 do
				local straightPt = {VertexArrayData.VertexData[j][1] + trackDirection[1] * i, VertexArrayData.VertexData[j][2], VertexArrayData.VertexData[j][3]}
				VertexArrayData.VertexData[i * 4 + j] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
			end
			VertexArrayData.IndexData[i * 12 - 11] = i * 4 - 4
			VertexArrayData.IndexData[i * 12 - 10] = i * 4
			VertexArrayData.IndexData[i * 12 - 9] = i * 4
			VertexArrayData.IndexData[i * 12 - 8] = i * 4 + 1
			VertexArrayData.IndexData[i * 12 - 7] = i * 4 + 1
			VertexArrayData.IndexData[i * 12 - 6] = i * 4 - 3
			VertexArrayData.IndexData[i * 12 - 5] = i * 4 - 2
			VertexArrayData.IndexData[i * 12 - 4] = i * 4 + 2
			VertexArrayData.IndexData[i * 12 - 3] = i * 4 + 2
			VertexArrayData.IndexData[i * 12 - 2] = i * 4 + 3
			VertexArrayData.IndexData[i * 12 - 1] = i * 4 + 3
			VertexArrayData.IndexData[i * 12 - 0] = i * 4 - 1		
		end
	end
	return VertexArrayData
end

function GenerateAlphaTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		ColorData = {},
		IndexData = {},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = true,
	}

	local COLOR_PART_COUNT = 3
	local COLOR_POINT_COUNT = 9
	local TRACK_PART_COUNT = COLOR_POINT_COUNT * COLOR_PART_COUNT
	local wheelRad = math.rad(wheelAngle)
	
	local auxDist = {CalibInfo.CalibLengthUnit * 0.5, CalibInfo.CalibLengthUnit * 0.5, CalibInfo.CalibLengthUnit * 1}
	local auxBegin = {0.0, CalibInfo.CalibLengthUnit * 0.5, CalibInfo.CalibLengthUnit * 1}
	local CENTER_TRACK_STEP = {auxDist[1] / (COLOR_POINT_COUNT - 1), auxDist[2] / (COLOR_POINT_COUNT - 1), auxDist[3] / (COLOR_POINT_COUNT - 1)}
	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {1.0, 0.0, 0.0}
	local trackBegin = {trackLeftBegin, trackRightBegin}	
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		trackRightBegin[3] = -trackRightBegin[3]
		trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -1.0
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local partColor = {{0.90, 0.60, 0.0, 0.3}, {1.0, 1.0, 0.0, 0.3}, {0.60, 0.60, 0.60, 0.5}}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	for i = 1, 3 do
		for c = 1, COLOR_POINT_COUNT do
			for j = 1, 2 do 
				local straightPt = table.Clone(trackBegin[j])
				straightPt[1] = straightPt[1] + auxBegin[i] * trackDirection[1] + trackDirection[1] * CENTER_TRACK_STEP[i] * (c - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = partColor[i]
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
	end
	return VertexArrayData
end

function GenerateAlphaRadar(index , isRear)
	local VertexArrayData = 
	{
		VertexData = {},
		SingleColor = {},
		IndexData = {},
		GeoMode = GL_DEFINES.GL_LINES,
		LineWidth = 4,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	--straight line radar sign
	local FRONT_RADAR_LINE = RadarModule.FRONT_RADAR_CNT
	local REAR_RADAR_LINE = RadarModule.REAR_RADAR_CNT
	
	local radarLineWidth = {0.0, 0.0}
	radarLineWidth[1] = VehicleInfo.CarWidth / FRONT_RADAR_LINE 
	radarLineWidth[2] = VehicleInfo.CarWidth / REAR_RADAR_LINE

	local frontRadarLeftBegin = {0.0, 0.0, 0.0}
	local frontRadarRightBegin = {0.0, 0.0, 0.0}
	frontRadarLeftBegin[1] = CalibInfo.CalibRectLength / 2
	frontRadarLeftBegin[3] = -VehicleInfo.CarWidth  / 2
	frontRadarRightBegin[1] = CalibInfo.CalibRectLength / 2
	frontRadarRightBegin[3] = VehicleInfo.CarWidth  / 2
	local rearRadarLeftBegin = {0.0, 0.0, 0.0}
	rearRadarLeftBegin[1] = -CalibInfo.CalibRectLength / 2
	rearRadarLeftBegin[3] = -VehicleInfo.CarWidth / 2
	local rearRadarRightBegin = {0.0, 0.0, 0.0}
	rearRadarRightBegin[1] = -CalibInfo.CalibRectLength / 2
	rearRadarRightBegin[3] = VehicleInfo.CarWidth / 2
	local auxPartColor = {{1.0, 0.0, 0.0, 1.0}, {1.0, 1.0, 0.0, 1.0}, {0.0, 1.0, 0.0, 1.0}}
	-- if isRear then
		-- VertexArrayData.VertexData[1] = {rearRadarLeftBegin[1], rearRadarLeftBegin[2], rearRadarLeftBegin[3] + (index -1) * radarLineWidth[2]}
		-- VertexArrayData.VertexData[2] = {rearRadarLeftBegin[1], rearRadarLeftBegin[2], rearRadarLeftBegin[3] + (index) * radarLineWidth[2]}		
		-- VertexArrayData.SingleColor = auxPartColor[3]
	-- else
		-- VertexArrayData.VertexData[1] = {frontRadarLeftBegin[1], frontRadarLeftBegin[2], frontRadarLeftBegin[3] + (index -1) * radarLineWidth[1]}
		-- VertexArrayData.VertexData[2] = {frontRadarLeftBegin[1], frontRadarLeftBegin[2], frontRadarLeftBegin[3] + (index) * radarLineWidth[1]}
		-- VertexArrayData.SingleColor = auxPartColor[3]
	-- end
	
	--TODO arc radar sign
	local radarRadius = {0.0, 0.0}
	--radarRadius[1] = CalibInfo.CalibRectLength / 2
	--radarRadius[2] = CalibInfo.CalibRectLength / 2
	radarRadius[1] = math.sqrt((CalibInfo.CalibRectLength / 2) *(CalibInfo.CalibRectLength / 2) + VehicleInfo.CarWidth * VehicleInfo.CarWidth)
	radarRadius[2] = math.sqrt((CalibInfo.CalibRectLength / 2) *(CalibInfo.CalibRectLength / 2) + VehicleInfo.CarWidth * VehicleInfo.CarWidth)
	
	radarCircleCenter = {0.0, 0.0, 0.0}
	local ARC_POINTS = 16
	
	if isRear then		
		local vertexIndex = 1
		local rearRadarBegin = {0.0, 0.0, 0.0}
		rearRadarBegin[1] = rearRadarRightBegin[1]
		rearRadarBegin[3] = rearRadarRightBegin[3]
		if ( index < RadarModule.REAR_RADAR_CNT/2 +1) then
			rearRadarBegin[3] = rearRadarLeftBegin[3]
		end
		for a = 1, ARC_POINTS do			
			VertexArrayData.VertexData[2 * a -1 ] = TransformToRadarArc( radarRadius[2], radarCircleCenter, rearRadarBegin, vertexIndex, ARC_POINTS, index)			
			--vertexIndex = vertexIndex + 1	
			VertexArrayData.VertexData[2 * a] = TransformToRadarArc( radarRadius[2], radarCircleCenter, rearRadarBegin, vertexIndex+1, ARC_POINTS, index)			
			vertexIndex = vertexIndex + 1	
		end
	else
		local vertexFrontIndex = 1
		local frontRadarBegin = {0.0, 0.0, 0.0}
		frontRadarBegin[1] = frontRadarRightBegin[1]
		frontRadarBegin[3] = frontRadarRightBegin[3]
		if ( index < RadarModule.FRONT_RADAR_CNT /2 +1) then
			frontRadarBegin[3] = frontRadarLeftBegin[3]
		end
		for a = 1, ARC_POINTS do
			VertexArrayData.VertexData[2 * a -1] = TransformToRadarArc( radarRadius[1], radarCircleCenter, frontRadarBegin, vertexFrontIndex, ARC_POINTS, index)			
			--vertexFrontIndex = vertexFrontIndex + 1	
			VertexArrayData.VertexData[2 * a] = TransformToRadarArc( radarRadius[1], radarCircleCenter, frontRadarBegin, vertexFrontIndex+1, ARC_POINTS, index)					
			vertexFrontIndex = vertexFrontIndex + 1	
		end				
	end
	return VertexArrayData
end

function GenerateGeelyTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 80
	local CENTER_TRACK_LENGTH = 3 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH}, trackRightBegin}	

	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	for i = 1, STRIP_PART + 1 do
		for j = 1, 2 do
		local bgIdx = 0
		if backward then
			bgIdx = j == 1 and 4 or j
		else
			bgIdx = j == 1 and j or 4
		end
		local straightPt = table.Clone(trackBegin[bgIdx])
		straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
		if wheelRad == 0 then
			VertexArrayData.VertexData[vertexIndex] = straightPt
		else
			VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
		end
		VertexArrayData.ColorData[vertexIndex] = {0.0, 1.0, 0.0, 0.20}
		VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
		vertexIndex = vertexIndex + 1
		indexIndex = indexIndex + 1
		end
	end
	local STRIPE_CENTER = STRIP_PART / 2 + 1
	for j = 0, 1 do
		for i = 1, STRIP_PART + 1 do
			local greenDeep = math.sqrt(1.0 - math.abs( i - STRIPE_CENTER) / (STRIP_PART / 2))
			for k = 1, 2 do
				local bgIdx = j * 2 + k
				if backward then
					bgIdx = j * 2 + 3 - k
				else
					bgIdx = j * 2 + k
				end
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.0, 1.0, 0.0, greenDeep}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
	end
	local QUAD_COUNT = 10
	local QUAD_DIST = CENTER_TRACK_LENGTH / QUAD_COUNT
	local QUAD_WIDTH = 200
	local QUAD_HEIGHT = 80
	local QUAD_SEP = 15
	local originQuad = {{0.0, 0.0, 0.0}, {0.0, 0.0, QUAD_WIDTH}, {QUAD_HEIGHT, 0.0, 0.0}, {QUAD_HEIGHT, 0.0, QUAD_WIDTH}}
	if backward then
		QUAD_DIST = -QUAD_DIST
		QUAD_HEIGHT = -QUAD_HEIGHT
		originQuad = {{0.0, 0.0, QUAD_WIDTH}, {0.0, 0.0, 0.0}, {QUAD_HEIGHT, 0.0, QUAD_WIDTH}, {QUAD_HEIGHT, 0.0, 0.0}}
	end
	local QUAD_CENTER = QUAD_COUNT / 2
	for j = 0, 1 do
		for i = 1, QUAD_COUNT do		
			local greenDeep = math.sqrt(1.0 - math.abs(i - QUAD_CENTER) / (QUAD_COUNT / 2))
			local quadBegin = table.Clone(trackBegin[2 + j])
			quadBegin[1] = quadBegin[1] + QUAD_DIST * i - QUAD_HEIGHT + 10
			quadBegin[3] = quadBegin[3] - j * QUAD_WIDTH + QUAD_SEP * (1 - 2 * j)
			for k = 1, 4 do
				local straightPt = {quadBegin[1] + originQuad[k][1], quadBegin[2] + originQuad[k][2], quadBegin[3] + originQuad[k][3]}
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.0, 1.0, 0.0, greenDeep}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
			VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
			VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
			indexIndex = indexIndex + 2
		end
	end
	VertexArrayData.VertexData[vertexIndex] = VertexArrayData.VertexData[vertexIndex - 1]
	VertexArrayData.ColorData[vertexIndex] = VertexArrayData.ColorData[vertexIndex - 1]
	return VertexArrayData
end

function GenerateBMWTrackLine(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 80
	local CENTER_TRACK_LENGTH = 3 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH}, trackRightBegin}	

	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	local STRIPE_CENTER = STRIP_PART / 2 + 1
	for j = 0, 1 do
		for i = 1, STRIP_PART + 1 do
			local greenDeep = math.sqrt(1.0 - math.abs( i - STRIPE_CENTER) / (STRIP_PART / 2))
			for k = 1, 2 do
				local bgIdx = j * 2 + k
				if backward then
					bgIdx = j * 2 + 3 - k
				else
					bgIdx = j * 2 + k
				end
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.0, 1.0, 0.0, greenDeep}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
	end
	local QUAD_COUNT = 10
	local QUAD_DIST = CENTER_TRACK_LENGTH / QUAD_COUNT
	local QUAD_WIDTH = 200
	local QUAD_HEIGHT = 80
	local QUAD_SEP = 15
	local originQuad = {{0.0, 0.0, 0.0}, {0.0, 0.0, QUAD_WIDTH}, {QUAD_HEIGHT, 0.0, 0.0}, {QUAD_HEIGHT, 0.0, QUAD_WIDTH}}
	if backward then
		QUAD_DIST = -QUAD_DIST
		QUAD_HEIGHT = -QUAD_HEIGHT
		originQuad = {{0.0, 0.0, QUAD_WIDTH}, {0.0, 0.0, 0.0}, {QUAD_HEIGHT, 0.0, QUAD_WIDTH}, {QUAD_HEIGHT, 0.0, 0.0}}
	end
	local QUAD_CENTER = QUAD_COUNT / 2
	for j = 0, 1 do
		for i = 1, QUAD_COUNT do		
			local greenDeep = math.sqrt(1.0 - math.abs(i - QUAD_CENTER) / (QUAD_COUNT / 2))
			local quadBegin = table.Clone(trackBegin[2 + j])
			quadBegin[1] = quadBegin[1] + QUAD_DIST * i - QUAD_HEIGHT + 10 + (j * -20)
			quadBegin[3] = quadBegin[3] - j * QUAD_WIDTH + QUAD_SEP * (1 - 2 * j)
			for k = 1, 4 do
				local straightPt = {quadBegin[1] + originQuad[k][1], quadBegin[2] + originQuad[k][2], quadBegin[3] + originQuad[k][3]}
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.0, 1.0, 0.0, greenDeep}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
			VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
			VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
			indexIndex = indexIndex + 2
		end
	end
	VertexArrayData.VertexData[vertexIndex] = VertexArrayData.VertexData[vertexIndex - 1]
	VertexArrayData.ColorData[vertexIndex] = VertexArrayData.ColorData[vertexIndex - 1]
	return VertexArrayData
end

function GenerateNXPTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 50
	local CENTER_TRACK_LENGTH = 3 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength+ VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	local SHADOW_LENGTH = 2.5 * CalibInfo.CalibLengthUnit
	local SHADOW_STEP = SHADOW_LENGTH / STRIP_PART
	local SHADOW_BEGIN = 0.5 * CalibInfo.CalibLengthUnit
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
		SHADOW_STEP = -SHADOW_STEP
		SHADOW_BEGIN = -SHADOW_BEGIN
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH}, trackRightBegin}	

	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	for i = 1, STRIP_PART + 1 do
		for j = 1, 2 do
		local bgIdx = 0
		if backward then
			bgIdx = j == 1 and 4 or j
		else
			bgIdx = j == 1 and j or 4
		end
		local straightPt = table.Clone(trackBegin[bgIdx])
		straightPt[1] = straightPt[1] + SHADOW_STEP * (i - 1) + SHADOW_BEGIN
		if wheelRad == 0 then
			VertexArrayData.VertexData[vertexIndex] = straightPt
		else
			VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
		end
		VertexArrayData.ColorData[vertexIndex] = {0.0, 0.2, 1.0, 0.2}
		VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
		vertexIndex = vertexIndex + 1
		indexIndex = indexIndex + 1
		end
	end
	local STRIPE_CENTER = STRIP_PART / 2 + 1
	for j = 0, 1 do
		for i = 1, STRIP_PART + 1 do
			local greenDeep = math.sqrt(1.0 - math.abs( i - STRIPE_CENTER) / (STRIP_PART / 2))
			for k = 1, 2 do
				local bgIdx = j * 2 + k
				if backward then
					bgIdx = j * 2 + 3 - k
				else
					bgIdx = j * 2 + k
				end
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.80, 0.45, 0.0, 1.0}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
	end
	local QUAD_POS = {5, 7.5, 10, 12.5, 15}
	local QUAD_COUNT = 5
	local QUAD_WIDTH = 200
	local QUAD_HEIGHT = 50
	local QUAD_SEP = 15
	local QUAD_DIR = 1
	local originQuad = {{0.0, 0.0, 0.0}, {0.0, 0.0, QUAD_WIDTH}, {QUAD_HEIGHT, 0.0, 0.0}, {QUAD_HEIGHT, 0.0, QUAD_WIDTH}}
	if backward then
		QUAD_DIR = -1
		QUAD_HEIGHT = -QUAD_HEIGHT
		originQuad = {{0.0, 0.0, QUAD_WIDTH}, {0.0, 0.0, 0.0}, {QUAD_HEIGHT, 0.0, QUAD_WIDTH}, {QUAD_HEIGHT, 0.0, 0.0}}
	end
	for j = 0, 1 do
		for i = 1, QUAD_COUNT do		
			local quadBegin = table.Clone(trackBegin[2 + j])
			quadBegin[1] = quadBegin[1] + QUAD_POS[i] * CalibInfo.CalibLengthUnit / 5 * QUAD_DIR - QUAD_HEIGHT + 10
			quadBegin[3] = quadBegin[3] - j * QUAD_WIDTH + QUAD_SEP * (1 - 2 * j)
			for k = 1, 4 do
				local straightPt = {quadBegin[1] + originQuad[k][1], quadBegin[2] + originQuad[k][2], quadBegin[3] + originQuad[k][3]}
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.35, 0.35, 0.35, 1.0}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
			VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
			VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
			indexIndex = indexIndex + 2
		end
	end
	local RED_STEP = (trackBegin[3][3] - trackBegin[2][3]) / (STRIP_PART - 1)
	local RED_HEIGHT = 40
	local RED_COLOR = {0.80, 0.0, 0.0, 0.50}
	local RED_BEGIN = 0.5 * CalibInfo.CalibLengthUnit
	if backward then
		RED_HEIGHT = -RED_HEIGHT
		RED_BEGIN = -RED_BEGIN
	end
	for i = 1, STRIP_PART do		
		local straightPt = {trackBegin[2][1] + RED_BEGIN, trackBegin[2][2], trackBegin[2][3] + RED_STEP * (i - 1)}
		VertexArrayData.VertexData[vertexIndex] = straightPt
		VertexArrayData.VertexData[vertexIndex + 1] = {straightPt[1] - RED_HEIGHT * QUAD_DIR, straightPt[2], straightPt[3]}
		if wheelRad ~= 0 then
			VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, VertexArrayData.VertexData[vertexIndex])
			VertexArrayData.VertexData[vertexIndex + 1] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, VertexArrayData.VertexData[vertexIndex + 1])
		end
		VertexArrayData.ColorData[vertexIndex] = RED_COLOR
		VertexArrayData.ColorData[vertexIndex + 1] = RED_COLOR
		VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
		VertexArrayData.IndexData[indexIndex + 1] = vertexIndex
		vertexIndex = vertexIndex + 2
		indexIndex = indexIndex + 2
	end

	VertexArrayData.VertexData[vertexIndex] = VertexArrayData.VertexData[vertexIndex - 1]
	VertexArrayData.ColorData[vertexIndex] = VertexArrayData.ColorData[vertexIndex - 1]
	return VertexArrayData
end

function GenerateBenzQuadTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 250
	local CENTER_TRACK_LENGTH = 5 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -(VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackRightBegin = {0.0, 0.0, (VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH}, trackRightBegin}
	local shadowBegin = {{trackLeftBegin[1], 0.0, -CalibInfo.CalibRectWidth / 2 + 50}, {trackRightBegin[1], 0.0, CalibInfo.CalibRectWidth / 2 - 50}}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local coupleCenterBegin = {}
	local trackRadius = {0.0, 0.0}
	local corRadius = math.sqrt(xDis * xDis + zDis * zDis)
	if wheelRad > 0 then
		coupleCenterBegin[1] = trackCenterBegin
		if backward then
			coupleCenterBegin[2] = frontCenter
		else
			coupleCenterBegin[2] = rearAxisCenter
		end
		trackRadius[1] = corRadius
		trackRadius[2] = math.abs(zDis)
	else
		coupleCenterBegin[2] = trackCenterBegin
		if backward then
			coupleCenterBegin[1] = frontCenter
		else
			coupleCenterBegin[1] = rearAxisCenter
		end
		trackRadius[2] = corRadius
		trackRadius[1] = math.abs(zDis)
	end
	local vertexIndex = 1
	local indexIndex = 1
	local SHADOW_LENGTH = CENTER_TRACK_LENGTH
	if backward then
		for i = 1, 2 do
			shadowBegin[i][1] = frontCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearCenter[1])
	else
		for i = 1, 2 do
			shadowBegin[i][1] = rearAxisCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearAxisCenter[1])
	end
	local SHADOW_PART = STRIP_PART * 2
	local SHADOW_STEP = SHADOW_LENGTH / SHADOW_PART
	if backward then
		SHADOW_STEP = -SHADOW_STEP
	end
	for i = 1, SHADOW_PART + 1 do
		local greenDeep = math.sqrt(1.0 - i / (SHADOW_PART + 1))
		for j = 1, 2 do
			local revBegin = j
			if backward then
				revBegin = 3 - j
			end
			local straightPt = table.Clone(shadowBegin[revBegin])
			straightPt[1] = straightPt[1] + SHADOW_STEP * (i - 1)
			if wheelRad == 0 or straightPt[1] >= rearCenter[1] and straightPt[1] <= frontCenter[1]  and (wheelRad > 0 and j == 1 or wheelRad < 0 and j == 2) then
				VertexArrayData.VertexData[vertexIndex] = straightPt
			else
				VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius[j], coupleCenterBegin[j], trackCircleCenter, straightPt)
			end
			VertexArrayData.ColorData[vertexIndex] = {0.25, 0.25, 0.25, 0.4 * greenDeep}
			VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
			vertexIndex = vertexIndex + 1
			indexIndex = indexIndex + 1
		end
	end
	VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
	VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
	indexIndex = indexIndex + 2
	for j = 0, 1 do
		for i = 1, STRIP_PART + 1 do
			local greenDeep = math.sqrt(1.0 - i / (STRIP_PART + 1))
			for k = 1, 2 do
				local bgIdx = j * 2 + k
				if backward then
					bgIdx = j * 2 + 3 - k
				end
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(corRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.8, 0.60, 0.16, 0.6 * greenDeep}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
	end
	return VertexArrayData
end

function GenerateTradTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 100
	local CENTER_TRACK_LENGTH = 5 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -(VehicleInfo.CarWidth + LINE_WIDTH) / 2}
	local trackRightBegin = {0.0, 0.0, (VehicleInfo.CarWidth + LINE_WIDTH) / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH}, trackRightBegin}
	local shadowBegin = {{trackLeftBegin[1], 0.0, -CalibInfo.CalibRectWidth / 2 + 50}, {trackRightBegin[1], 0.0, CalibInfo.CalibRectWidth / 2 - 50}}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local coupleCenterBegin = {}
	local trackRadius = {0.0, 0.0}
	local corRadius = math.sqrt(xDis * xDis + zDis * zDis)
	if wheelRad > 0 then
		coupleCenterBegin[1] = trackCenterBegin
		if backward then
			coupleCenterBegin[2] = frontCenter
		else
			coupleCenterBegin[2] = rearAxisCenter
		end
		trackRadius[1] = corRadius
		trackRadius[2] = math.abs(zDis)
	else
		coupleCenterBegin[2] = trackCenterBegin
		if backward then
			coupleCenterBegin[1] = frontCenter
		else
			coupleCenterBegin[1] = rearAxisCenter
		end
		trackRadius[2] = corRadius
		trackRadius[1] = math.abs(zDis)
	end
	local vertexIndex = 1
	local indexIndex = 1
	local SHADOW_LENGTH = CENTER_TRACK_LENGTH
	if backward then
		for i = 1, 2 do
			shadowBegin[i][1] = frontCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearCenter[1])
	else
		for i = 1, 2 do
			shadowBegin[i][1] = rearAxisCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearAxisCenter[1])
	end
	local SHADOW_PART = STRIP_PART * 2
	local SHADOW_STEP = SHADOW_LENGTH / SHADOW_PART
	if backward then
		SHADOW_STEP = -SHADOW_STEP
	end
	for j = 0, 1 do
		for i = 1, STRIP_PART + 1 do
			local greenDeep = math.sqrt(1.0 - i / (STRIP_PART + 1) / 1.1)
			for k = 1, 2 do
				local bgIdx = j * 2 + k
				if backward then
					bgIdx = j * 2 + 3 - k
				end
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(corRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {1.0 * greenDeep, 0.8 * greenDeep, 0.16 * greenDeep, 1.0}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
	end
	return VertexArrayData
end

function GenerateBenzLineTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = 3.0,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 250
	local CENTER_TRACK_LENGTH = 5 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -(VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackRightBegin = {0.0, 0.0, (VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH}, trackRightBegin}
	local shadowBegin = {{trackLeftBegin[1], 0.0, -CalibInfo.CalibRectWidth / 2 + 50}, {trackRightBegin[1], 0.0, CalibInfo.CalibRectWidth / 2 - 50}}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local coupleCenterBegin = {}
	local trackRadius = {0.0, 0.0}
	local corRadius = math.sqrt(xDis * xDis + zDis * zDis)
	if wheelRad > 0 then
		coupleCenterBegin[1] = trackCenterBegin
		if backward then
			coupleCenterBegin[2] = frontCenter
		else
			coupleCenterBegin[2] = rearAxisCenter
		end
		trackRadius[1] = corRadius
		trackRadius[2] = math.abs(zDis)
	else
		coupleCenterBegin[2] = trackCenterBegin
		if backward then
			coupleCenterBegin[1] = frontCenter
		else
			coupleCenterBegin[1] = rearAxisCenter
		end
		trackRadius[2] = corRadius
		trackRadius[1] = math.abs(zDis)
	end
	local vertexIndex = 1
	local indexIndex = 1
	local SHADOW_LENGTH = CENTER_TRACK_LENGTH
	if backward then
		for i = 1, 2 do
			shadowBegin[i][1] = frontCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearCenter[1])
	else
		for i = 1, 2 do
			shadowBegin[i][1] = rearAxisCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearAxisCenter[1])
	end
	local SHADOW_PART = STRIP_PART * 2
	local SHADOW_STEP = SHADOW_LENGTH / SHADOW_PART
	if backward then
		SHADOW_STEP = -SHADOW_STEP
	end
	for i = 1, SHADOW_PART + 1 do
		local greenDeep = math.sqrt(1.0 - i / (SHADOW_PART + 1))
		for j = 1, 2 do
			local revBegin = j
			if backward then
				revBegin = 3 - j
			end
			local straightPt = table.Clone(shadowBegin[revBegin])
			straightPt[1] = straightPt[1] + SHADOW_STEP * (i - 1)
			if wheelRad == 0 or straightPt[1] >= rearCenter[1] and straightPt[1] <= frontCenter[1]  and (wheelRad > 0 and j == 1 or wheelRad < 0 and j == 2) then
				VertexArrayData.VertexData[vertexIndex] = straightPt
			else
				VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius[j], coupleCenterBegin[j], trackCircleCenter, straightPt)
			end
			VertexArrayData.ColorData[vertexIndex] = {1.0, 0.75, 0.40, greenDeep}
			if i > 1 then
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 3
				VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
				indexIndex = indexIndex + 2
			end
			vertexIndex = vertexIndex + 1
		end
	end
	for j = 0, 1 do
		for i = 1, STRIP_PART + 1 do
			local greenDeep = (1.0 - i / (STRIP_PART + 1))
			for k = 1, 2 do
				local bgIdx = j * 2 + k
				if backward then
					bgIdx = j * 2 + 3 - k
				end
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(corRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {1.0, 0.75, 0.40, greenDeep}
				if i > 1 then
					VertexArrayData.IndexData[indexIndex] = vertexIndex - 3
					VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
					indexIndex = indexIndex + 2
				end
				vertexIndex = vertexIndex + 1
			end
		end
	end
	return VertexArrayData
end

function GenerateRedLine(left, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		SingleColor = {1.0, 1.0, 1.0, 1.0},
		ColorData = {},
		TexcoordData = {},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 50
	local CENTER_TRACK_LENGTH = 3 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(left and -VehicleInfo.MaxWheelAngle or VehicleInfo.MaxWheelAngle)

	local rearAxisCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin0 = left and trackRightBegin or trackLeftBegin
	if left then
		trackBegin0[3] = trackBegin0[3] - LINE_WIDTH
	end
	local trackBegin = {}
	if backward then
		trackBegin = {{trackBegin0[1], 0.0, trackBegin0[3] + LINE_WIDTH}, trackBegin0}
	else
		trackBegin = {trackBegin0, {trackBegin0[1], 0.0, trackBegin0[3] + LINE_WIDTH}}
	end
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	local NAG_PART = 5
	local REAL_PART = STRIP_PART + NAG_PART
	local STRIPE_CENTER = REAL_PART / 2 - NAG_PART + 1
	for i = -NAG_PART + 1, STRIP_PART + 1 do
		for j = 1, 2 do
		local straightPt = table.Clone(trackBegin[j])
		straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
		local greenDeep = math.sqrt(1.0 - math.abs( i - STRIPE_CENTER) / (REAL_PART / 2))
		VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
		VertexArrayData.ColorData[vertexIndex] = {1.0, 0.0, 0.0, greenDeep}
		vertexIndex = vertexIndex + 1
		end
	end
	return VertexArrayData
end

function GenerateBMWTrack(wheelAngle, backward)
	BMWTrack = {}
	BMWTrack[1] = BMWTrack[1] or GenerateRedLine(true, false)
	BMWTrack[2] = BMWTrack[2] or GenerateRedLine(true, true)
	BMWTrack[3] = BMWTrack[3] or GenerateRedLine(false, false)
	BMWTrack[4] = BMWTrack[4] or GenerateRedLine(false, true)
	local TrackArray = 
	{
		[1] = GenerateBMWTrackLine(wheelAngle, backward),
		[2] = BMWTrack[1],
		[3] = BMWTrack[2],
		[4] = BMWTrack[3],
		[5] = BMWTrack[4],
	}
	if wheelAngle > 0.0 then
		BMWTrack[1].SingleColor[4] = 1.0 - wheelAngle / VehicleInfo.MaxWheelAngle
		BMWTrack[2].SingleColor[4] = 1.0 - wheelAngle / VehicleInfo.MaxWheelAngle
		BMWTrack[3].SingleColor[4] = 1.0
		BMWTrack[4].SingleColor[4] = 1.0
	elseif wheelAngle < 0.0 then
		BMWTrack[1].SingleColor[4] = 1.0
		BMWTrack[2].SingleColor[4] = 1.0
		BMWTrack[3].SingleColor[4] = 1.0 + wheelAngle / VehicleInfo.MaxWheelAngle
		BMWTrack[4].SingleColor[4] = 1.0 + wheelAngle / VehicleInfo.MaxWheelAngle
	else
		BMWTrack[1].SingleColor[4] = 1.0
		BMWTrack[2].SingleColor[4] = 1.0
		BMWTrack[3].SingleColor[4] = 1.0
		BMWTrack[4].SingleColor[4] = 1.0
	end
	return TrackArray
end

function GenerateBenzTrack(wheelAngle, backward)
	local TrackArray = 
	{
		[1] = GenerateBenzQuadTrack(wheelAngle, backward),
		[2] = GenerateBenzLineTrack(wheelAngle, backward),
	}
	return TrackArray
end

function GenerateCadillacQuadTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 250
	local CENTER_TRACK_LENGTH = 5 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -(VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackRightBegin = {0.0, 0.0, (VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	local axisCenter = {0, 0, 0}
	local axisCenterL = {0, 0, -(VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local axisCenterR = {0, 0, (VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		axisCenter[1] = rearAxisCenter[1]
		axisCenterR[1] = rearAxisCenter[1]
		axisCenterL[1] = rearAxisCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
		axisCenter[1] = frontAxisCenter[1]
		axisCenterR[1] = frontAxisCenter[1]
		axisCenterL[1] = frontAxisCenter[1]
	end
	
	local trackBegin = {axisCenterL, {axisCenterL[1], 0.0, axisCenterL[3] + LINE_WIDTH}, {axisCenterR[1], 0.0, axisCenterR[3] - LINE_WIDTH}, axisCenterR}
	local shadowBegin = {{trackLeftBegin[1], 0.0, -CalibInfo.CalibRectWidth / 2 + 50}, {trackRightBegin[1], 0.0, CalibInfo.CalibRectWidth / 2 - 50}}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local coupleCenterBegin = {}
	local trackRadius = {0.0, 0.0}
	local corRadius = math.sqrt(xDis * xDis + zDis * zDis)
	if wheelRad > 0 then
		coupleCenterBegin[1] = trackCenterBegin
		if backward then
			coupleCenterBegin[2] = frontCenter
		else
			coupleCenterBegin[2] = rearAxisCenter
		end
		trackRadius[1] = corRadius
		trackRadius[2] = math.abs(zDis)
	else
		coupleCenterBegin[2] = trackCenterBegin
		if backward then
			coupleCenterBegin[1] = frontCenter
		else
			coupleCenterBegin[1] = rearAxisCenter
		end
		trackRadius[2] = corRadius
		trackRadius[1] = math.abs(zDis)
	end
	xDis = axisCenter[1] - trackCircleCenter[1]
	zDis = axisCenter[3] - trackCircleCenter[3]

	local axisRadius = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	local SHADOW_LENGTH = CENTER_TRACK_LENGTH
	if backward then
		for i = 1, 2 do
			shadowBegin[i][1] = frontCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearCenter[1])
	else
		for i = 1, 2 do
			shadowBegin[i][1] = rearAxisCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearAxisCenter[1])
	end
	local SHADOW_PART = STRIP_PART * 2
	local SHADOW_STEP = SHADOW_LENGTH / SHADOW_PART
	if backward then
		SHADOW_STEP = -SHADOW_STEP
	end
	for i = 1, SHADOW_PART + 1 do
		local greenDeep = math.sqrt(1.0 - i / (SHADOW_PART + 1))
		for j = 1, 2 do
			local revBegin = j
			if backward then
				revBegin = 3 - j
			end
			local straightPt = table.Clone(shadowBegin[revBegin])
			straightPt[1] = straightPt[1] + SHADOW_STEP * (i - 1)
			if wheelRad == 0 or straightPt[1] >= rearCenter[1] and straightPt[1] <= frontCenter[1]  and (wheelRad > 0 and j == 1 or wheelRad < 0 and j == 2) then
				VertexArrayData.VertexData[vertexIndex] = straightPt
			else
				VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius[j], coupleCenterBegin[j], trackCircleCenter, straightPt)
			end
			VertexArrayData.ColorData[vertexIndex] = {0.25, 0.25, 0.25, 0.4 * greenDeep}
			VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
			vertexIndex = vertexIndex + 1
			indexIndex = indexIndex + 1
		end
	end
	VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
	VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
	indexIndex = indexIndex + 2
	for j = 0, 1 do
		for i = 1, STRIP_PART + 1 do
			local greenDeep = math.sqrt(1.0 - i / (STRIP_PART + 1))
			for k = 1, 2 do
				local bgIdx = j * 2 + k
				if backward then
					bgIdx = j * 2 + 3 - k
				end
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(axisRadius, axisCenter, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.5, 0.5, 0.5, greenDeep}
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
	end
	return VertexArrayData
end

local CADILLAC_ORANGE = {0.8, 0.5, 0.15, 1.0}
function GenerateCadillacLineTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = 3.0,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 250
	local CENTER_TRACK_LENGTH = 5 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -(VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackRightBegin = {0.0, 0.0, (VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	local axisCenter = {0, 0, 0}
	local axisCenterL = {0, 0, -(VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local axisCenterR = {0, 0, (VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
		axisCenter[1] = rearAxisCenter[1]
		axisCenterR[1] = rearAxisCenter[1]
		axisCenterL[1] = rearAxisCenter[1]
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
		axisCenter[1] = frontAxisCenter[1]
		axisCenterR[1] = frontAxisCenter[1]
		axisCenterL[1] = frontAxisCenter[1]
	end
	local trackBegin = {axisCenterL, {axisCenterL[1], 0.0, axisCenterL[3] + LINE_WIDTH}, {axisCenterR[1], 0.0, axisCenterR[3] - LINE_WIDTH}, axisCenterR}
	local shadowBegin = {{trackLeftBegin[1], 0.0, -CalibInfo.CalibRectWidth / 2 + 50}, {trackRightBegin[1], 0.0, CalibInfo.CalibRectWidth / 2 - 50}}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local coupleCenterBegin = {}
	local trackRadius = {0.0, 0.0}
	local corRadius = math.sqrt(xDis * xDis + zDis * zDis)
	if wheelRad > 0 then
		coupleCenterBegin[1] = trackCenterBegin
		if backward then
			coupleCenterBegin[2] = frontCenter
		else
			coupleCenterBegin[2] = rearAxisCenter
		end
		trackRadius[1] = corRadius
		trackRadius[2] = math.abs(zDis)
	else
		coupleCenterBegin[2] = trackCenterBegin
		if backward then
			coupleCenterBegin[1] = frontCenter
		else
			coupleCenterBegin[1] = rearAxisCenter
		end
		trackRadius[2] = corRadius
		trackRadius[1] = math.abs(zDis)
	end
	xDis = axisCenter[1] - trackCircleCenter[1]
	zDis = axisCenter[3] - trackCircleCenter[3]

	local axisRadius = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	local SHADOW_LENGTH = CENTER_TRACK_LENGTH
	if backward then
		for i = 1, 2 do
			shadowBegin[i][1] = frontCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearCenter[1])
	else
		for i = 1, 2 do
			shadowBegin[i][1] = rearAxisCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearAxisCenter[1])
	end
	local SHADOW_PART = STRIP_PART * 2
	local SHADOW_STEP = SHADOW_LENGTH / SHADOW_PART
	if backward then
		SHADOW_STEP = -SHADOW_STEP
	end
	for i = 1, SHADOW_PART + 1 do
		local greenDeep = math.sqrt(1.0 - i / (SHADOW_PART + 1))
		for j = 1, 2 do
			local revBegin = j
			if backward then
				revBegin = 3 - j
			end
			local straightPt = table.Clone(shadowBegin[revBegin])
			straightPt[1] = straightPt[1] + SHADOW_STEP * (i - 1)
			VertexArrayData.ColorData[vertexIndex] = table.Clone(CADILLAC_ORANGE)
			VertexArrayData.ColorData[vertexIndex][4] = greenDeep
			if wheelRad == 0 or straightPt[1] >= rearCenter[1] and straightPt[1] <= frontCenter[1]  and (wheelRad > 0 and j == 1 or wheelRad < 0 and j == 2) then
				VertexArrayData.VertexData[vertexIndex] = straightPt
				if wheelRad ~= 0.0 then
					VertexArrayData.ColorData[vertexIndex] = {1.0, 0.75, 0.40, 0}
				end
			else
				VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius[j], coupleCenterBegin[j], trackCircleCenter, straightPt)
			end
			if i > 1 then
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 3
				VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
				indexIndex = indexIndex + 2
			end
			vertexIndex = vertexIndex + 1
		end
	end
	for j = 0, 1 do
		for i = 1, STRIP_PART + 1 do
			local greenDeep = (1.0 - i / (STRIP_PART + 1))
			for k = 1, 2 do
				local bgIdx = j * 2 + k
				if backward then
					bgIdx = j * 2 + 3 - k
				end
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(axisRadius, axisCenter, trackCircleCenter, straightPt)
				end
				VertexArrayData.ColorData[vertexIndex] = {0.75, 0.75, 0.75, greenDeep}
				if i > 1 then
					VertexArrayData.IndexData[indexIndex] = vertexIndex - 3
					VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
					indexIndex = indexIndex + 2
				end
				vertexIndex = vertexIndex + 1
			end
		end
	end
	return VertexArrayData
end

function GenerateCadillacTrack(wheelAngle, backward)
	local TrackArray = 
	{
		[1] = GenerateCadillacQuadTrack(wheelAngle, backward),
		[2] = GenerateCadillacLineTrack(wheelAngle, backward),
	}
	return TrackArray
end

function GenerateCadillacDistTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = 4.0,
		DepthTest = false,
	}
	local STRIP_PART = 40
	local LINE_WIDTH = 250
	local CENTER_TRACK_LENGTH = 4 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -(VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackRightBegin = {0.0, 0.0, (VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, -LINE_WIDTH / 2}, {trackRightBegin[1], 0.0, LINE_WIDTH / 2}, trackRightBegin}
	local trackBeginR = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3]  + LINE_WIDTH / 2}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH / 2}, trackRightBegin}
	local shadowBegin = {{trackLeftBegin[1], 0.0, -CalibInfo.CalibRectWidth / 2 + 50}, {trackRightBegin[1], 0.0, CalibInfo.CalibRectWidth / 2 - 50}}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local coupleCenterBegin = {}
	local trackRadius = {0.0, 0.0}
	local corRadius = math.sqrt(xDis * xDis + zDis * zDis)
	if wheelRad > 0 then
		coupleCenterBegin[1] = trackCenterBegin
		if backward then
			coupleCenterBegin[2] = frontCenter
		else
			coupleCenterBegin[2] = rearAxisCenter
		end
		trackRadius[1] = corRadius
		trackRadius[2] = math.abs(zDis)
	else
		coupleCenterBegin[2] = trackCenterBegin
		if backward then
			coupleCenterBegin[1] = frontCenter
		else
			coupleCenterBegin[1] = rearAxisCenter
		end
		trackRadius[2] = corRadius
		trackRadius[1] = math.abs(zDis)
	end
	local vertexIndex = 1
	local indexIndex = 1
	local SHADOW_LENGTH = CENTER_TRACK_LENGTH
	if backward then
		for i = 1, 2 do
			shadowBegin[i][1] = frontCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearCenter[1])
	else
		for i = 1, 2 do
			shadowBegin[i][1] = rearAxisCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearAxisCenter[1])
	end
	local SHADOW_PART = STRIP_PART * 2
	local SHADOW_STEP = SHADOW_LENGTH / SHADOW_PART
	if backward then
		SHADOW_STEP = -SHADOW_STEP
	end

	for j = 1, 4, 3 do
		for i = 1, STRIP_PART + 1 do
			-- for k = 1, 2 do
				local bgIdx = j
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(corRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				if i < 7 then
					VertexArrayData.ColorData[vertexIndex] = {1.0, 0.25, 0.1, 1.0}
				
				else
					VertexArrayData.ColorData[vertexIndex] = table.Clone(CADILLAC_ORANGE)
				end
				if i == 6 then
					VertexArrayData.VertexData[vertexIndex + 1] = table.Clone(VertexArrayData.VertexData[vertexIndex])
					VertexArrayData.ColorData[vertexIndex + 1] = table.Clone(CADILLAC_ORANGE)
					if i > 1 then
						VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
						VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
						indexIndex = indexIndex + 2
					end
					vertexIndex = vertexIndex + 1
				end
				if i > 1 then
					VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
					VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
					indexIndex = indexIndex + 2
				end
				vertexIndex = vertexIndex + 1
			-- end
		end
	end
	
	local dists = {0.5, 1.0, 2.0, 3.0, 4.0}
	for j = 1, #dists do
		for i = 1, 4, j == 1 and 1 or 3 do
			local straightPt = table.Clone(trackBegin[i])
			if j == 1 then
				straightPt = table.Clone(trackBeginR[i])
			end
			straightPt[1] = straightPt[1] + dists[j] * CalibInfo.CalibLengthUnit * (trackDirection[1] / math.abs(trackDirection[1]))
			if wheelRad == 0 then
				VertexArrayData.VertexData[vertexIndex] = straightPt
			else
				VertexArrayData.VertexData[vertexIndex] = TransformToTrack(corRadius, trackCenterBegin, trackCircleCenter, straightPt)
			end
			if j < 2 then
				VertexArrayData.ColorData[vertexIndex] = {1.0, 0.25, 0.1, 1.0}
			else
				VertexArrayData.ColorData[vertexIndex] = table.Clone(CADILLAC_ORANGE)
			end
			vertexIndex = vertexIndex + 1
		end
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = vertexIndex - 5
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = vertexIndex - 4
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = vertexIndex - 3
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = vertexIndex - 2
	end
	return VertexArrayData
end

function GenerateCadillacDistSubTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		ColorData = {},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = 3.0,
		DepthTest = false,
	}
	local STRIP_PART = 40
	local LINE_WIDTH = 250
	local CENTER_TRACK_LENGTH = 4 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = { CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -(VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackRightBegin = {0.0, 0.0, (VehicleInfo.FrontThread + LINE_WIDTH) / 2}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3]  + LINE_WIDTH}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH}, trackRightBegin}
	local shadowBegin = {{trackLeftBegin[1], 0.0, -CalibInfo.CalibRectWidth / 2 + 50}, {trackRightBegin[1], 0.0, CalibInfo.CalibRectWidth / 2 - 50}}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local coupleCenterBegin = {}
	local trackRadius = {0.0, 0.0}
	local corRadius = math.sqrt(xDis * xDis + zDis * zDis)
	if wheelRad > 0 then
		coupleCenterBegin[1] = trackCenterBegin
		if backward then
			coupleCenterBegin[2] = frontCenter
		else
			coupleCenterBegin[2] = rearAxisCenter
		end
		trackRadius[1] = corRadius
		trackRadius[2] = math.abs(zDis)
	else
		coupleCenterBegin[2] = trackCenterBegin
		if backward then
			coupleCenterBegin[1] = frontCenter
		else
			coupleCenterBegin[1] = rearAxisCenter
		end
		trackRadius[2] = corRadius
		trackRadius[1] = math.abs(zDis)
	end
	local vertexIndex = 1
	local indexIndex = 1
	local SHADOW_LENGTH = CENTER_TRACK_LENGTH
	if backward then
		for i = 1, 2 do
			shadowBegin[i][1] = frontCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearCenter[1])
	else
		for i = 1, 2 do
			shadowBegin[i][1] = rearAxisCenter[1]
		end
		SHADOW_LENGTH = SHADOW_LENGTH + (frontCenter[1] - rearAxisCenter[1])
	end
	local SHADOW_PART = STRIP_PART * 2
	local SHADOW_STEP = SHADOW_LENGTH / SHADOW_PART
	if backward then
		SHADOW_STEP = -SHADOW_STEP
	end

	for j = 1, 4, 3 do
		for i = 1, STRIP_PART + 1 do
			-- for k = 1, 2 do
				local bgIdx = j
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(corRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				if i < 7 then
					VertexArrayData.ColorData[vertexIndex] = {1.0, 0.25, 0.1, 1.0}
				
				else
					VertexArrayData.ColorData[vertexIndex] = table.Clone(CADILLAC_ORANGE)
				end
				if i == 6 then
					VertexArrayData.VertexData[vertexIndex + 1] = table.Clone(VertexArrayData.VertexData[vertexIndex])
					VertexArrayData.ColorData[vertexIndex + 1] = table.Clone(CADILLAC_ORANGE)
					if i > 1 then
						VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
						VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
						indexIndex = indexIndex + 2
					end
					vertexIndex = vertexIndex + 1
				end
				if i > 1 then
					VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
					VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
					indexIndex = indexIndex + 2
				end
				vertexIndex = vertexIndex + 1
			-- end
		end
	end
	for i = 1, SHADOW_PART + 1 do
		for j = 1, 2 do
			local revBegin = j
			if backward then
				revBegin = 3 - j
			end
			local straightPt = table.Clone(shadowBegin[revBegin])
			straightPt[1] = straightPt[1] + SHADOW_STEP * (i - 1)
			VertexArrayData.ColorData[vertexIndex] = table.Clone(CADILLAC_ORANGE)
			if wheelRad == 0 or straightPt[1] >= rearCenter[1] and straightPt[1] <= frontCenter[1]  and (wheelRad > 0 and j == 1 or wheelRad < 0 and j == 2) then
				VertexArrayData.VertexData[vertexIndex] = straightPt
			else
				VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius[j], coupleCenterBegin[j], trackCircleCenter, straightPt)
			end
			if wheelRad == 0.0 or wheelRad > 0 and j == 1 or wheelRad < 0 and j == 2 then
				VertexArrayData.ColorData[vertexIndex] = {1.0, 0.75, 0.40, 0}
			end

			if i > 1 then
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 3
				VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
				indexIndex = indexIndex + 2
			end
			vertexIndex = vertexIndex + 1
		end
	end


	local dists = {0.5, 1.0, 2.0, 3.0, 4.0}
	for j = 1, #dists do
		for i = 1, 4 do
			local straightPt = table.Clone(trackBegin[i])
			straightPt[1] = straightPt[1] + dists[j] * CalibInfo.CalibLengthUnit * (trackDirection[1] / math.abs(trackDirection[1]))
			if wheelRad == 0 then
				VertexArrayData.VertexData[vertexIndex] = straightPt
			else
				VertexArrayData.VertexData[vertexIndex] = TransformToTrack(corRadius, trackCenterBegin, trackCircleCenter, straightPt)
			end
			if j < 2 then
				VertexArrayData.ColorData[vertexIndex] = {1.0, 0.25, 0.1, 1.0}
			else
				VertexArrayData.ColorData[vertexIndex] = table.Clone(CADILLAC_ORANGE)
			end
			vertexIndex = vertexIndex + 1
		end
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = vertexIndex - 5
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = vertexIndex - 4
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = vertexIndex - 3
		VertexArrayData.IndexData[#VertexArrayData.IndexData + 1] = vertexIndex - 2
	end
	return VertexArrayData
end

function GenerateGLCTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		SingleColor = {1.0, 1.0, 0.25, 1.0},
		GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		DepthTest = false,
	}
	local STRIP_PART = 30
	local LINE_WIDTH = 50
	local CENTER_TRACK_LENGTH = 5 * CalibInfo.CalibLengthUnit
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / STRIP_PART
	local wheelRad = math.rad(wheelAngle)

	local rearAxisCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.WheelBase, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2 - 200}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2 + 200}
	local trackCenterBegin = {0.0, 0.0, 0.0}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	if backward then
		trackCenterBegin[1] = rearCenter[1]
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		-- trackRightBegin[3] = -trackRightBegin[3]
		-- trackLeftBegin[3] = -trackLeftBegin[3]
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1] = frontCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
	end
	local trackBegin = {trackLeftBegin, {trackLeftBegin[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}, {trackRightBegin[1], 0.0, trackRightBegin[3] - LINE_WIDTH}, trackRightBegin}	

	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[3] - trackCircleCenter[3]
	local trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	-- generate line 
	local STRIPE_CENTER = STRIP_PART / 2 + 1
	for j = 0, 1 do
		for i = 0, STRIP_PART + 1 do
			for k = 1, 2 do
				local bgIdx = backward and (j * 2 + 3 - k) or (j * 2 + k)
				local straightPt = table.Clone(trackBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
	end
	
	local QUAD_COUNT = 40
	local QUAD_DIST = CENTER_TRACK_LENGTH / QUAD_COUNT
	local QUAD_WIDTH = 400
	local QUAD_HEIGHT = 50
	local QUAD_SEP = 50
	local originQuad = {{0.0, 0.0, 0.0}, {0.0, 0.0, QUAD_WIDTH}, {QUAD_HEIGHT, 0.0, 0.0}, {QUAD_HEIGHT, 0.0, QUAD_WIDTH}}
	if backward then
		QUAD_DIST = -QUAD_DIST
		QUAD_HEIGHT = -QUAD_HEIGHT
		originQuad = {{0.0, 0.0, QUAD_WIDTH}, {0.0, 0.0, 0.0}, {QUAD_HEIGHT, 0.0, QUAD_WIDTH}, {QUAD_HEIGHT, 0.0, 0.0}}
	end
	-- generate small quads
	local QUAD_CENTER = QUAD_COUNT / 2
	local QUAD_VT = 0.6
	local QUQD_TEXCOORD = {{0.0, QUAD_VT}, {0.0, QUAD_VT}, {1.0, QUAD_VT}, {1.0, QUAD_VT}}
	for j = 0, 1 do
		for i = -1, QUAD_COUNT do
			local quadBegin = table.Clone(trackBegin[2 + j])
			quadBegin[1] = quadBegin[1] + QUAD_DIST * i - QUAD_HEIGHT + 10
			quadBegin[3] = quadBegin[3] - j * QUAD_WIDTH + QUAD_SEP * (1 - 2 * j)
			for k = 1, 4 do
				local straightPt = {quadBegin[1] + originQuad[k][1], quadBegin[2] + originQuad[k][2], quadBegin[3] + originQuad[k][3]}
				if i == QUAD_COUNT or i == 10 then
					if backward ~= (k % 2 == j) then
						straightPt[3] = 0.0
					end
				end
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackCenterBegin, trackCircleCenter, straightPt)
				end
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
			VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
			VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
			indexIndex = indexIndex + 2
		end
	end
	if wheelAngle ~= 0.0 then
		local SHORT_LEN = 2.4 * CalibInfo.CalibLengthUnit
		local trackRevBegin = {}
		local trackRevCenter = {0.0, 0.0, 0.0}

		xDis = trackRevCenter[1] - trackCircleCenter[1]
		zDis = trackRevCenter[3] - trackCircleCenter[3]
		trackRadius = math.sqrt(xDis * xDis + zDis * zDis)
		
		if backward then
			trackRevCenter[1] = frontCenter[1]
			trackRevBegin[1] = {frontCenter[1], 0.0, trackLeftBegin[3]}
			trackRevBegin[2] = {frontCenter[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}
			trackRevBegin[3] = {frontCenter[1], 0.0, trackRightBegin[3] - LINE_WIDTH}
			trackRevBegin[4] = {frontCenter[1], 0.0, trackRightBegin[3]}
		else
			trackRevCenter[1] = rearAxisCenter[1]
			trackRevBegin[1] = {rearAxisCenter[1], 0.0, trackLeftBegin[3]}
			trackRevBegin[2] = {rearAxisCenter[1], 0.0, trackLeftBegin[3] + LINE_WIDTH}
			trackRevBegin[3] = {rearAxisCenter[1], 0.0, trackRightBegin[3] - LINE_WIDTH}
			trackRevBegin[4] = {rearAxisCenter[1], 0.0, trackRightBegin[3]}
		end
		trackDirection[1] = SHORT_LEN / STRIP_PART
		if backward then
			trackDirection[1] = -trackDirection[1]
		end
		local j = wheelAngle > 0.0 and 1 or 0
		if backward then
			j = 1 - j
		end
		for i = 0, STRIP_PART do
			for k = 1, 2 do
				local bgIdx = backward and (j * 2 + 3 - k) or (j * 2 + k)
				local straightPt = table.Clone(trackRevBegin[bgIdx])
				straightPt[1] = straightPt[1] + trackDirection[1] * i
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackRevCenter, trackCircleCenter, straightPt)
				end
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
		end
		local REV_QUAD_COUNT = SHORT_LEN / CENTER_TRACK_LENGTH * QUAD_COUNT
		for i = 0, REV_QUAD_COUNT do
			local quadBegin = table.Clone(trackRevBegin[2 + j])
			quadBegin[1] = quadBegin[1] + QUAD_DIST * i - QUAD_HEIGHT + 10 + (j * -20)
			quadBegin[3] = quadBegin[3] - j * QUAD_WIDTH + QUAD_SEP * (1 - 2 * j)
			for k = 1, 4 do
				local straightPt = {quadBegin[1] + originQuad[k][1], quadBegin[2] + originQuad[k][2], quadBegin[3] + originQuad[k][3]}
				if wheelRad == 0 then
					VertexArrayData.VertexData[vertexIndex] = straightPt
				else
					VertexArrayData.VertexData[vertexIndex] = TransformToTrack(trackRadius, trackRevCenter, trackCircleCenter, straightPt)
				end
				VertexArrayData.IndexData[indexIndex] = vertexIndex - 1
				vertexIndex = vertexIndex + 1
				indexIndex = indexIndex + 1
			end
			VertexArrayData.IndexData[indexIndex] = vertexIndex - 2
			VertexArrayData.IndexData[indexIndex + 1] = vertexIndex - 1
			indexIndex = indexIndex + 2
		end
	end
	VertexArrayData.VertexData[vertexIndex] = VertexArrayData.VertexData[vertexIndex - 1]
	vertexIndex = vertexIndex + 1
	
	return VertexArrayData
end

function GenerateDowDetectArea()
	local VertexArrayData = 
	{
		VertexData = {},
		SingleColor = {1.0, 0.0, 0.0, 1.0},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_ONE,
		DstRGBBlend = GL_DEFINES.GL_ZERO,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ZERO,
		LineWidth = 2.0,
		DepthTest = true,
	}
	local rearDowCfg = {2000,4000,6000,8000,10000,12000,15000,20000,25000,30000}
    local rearHang = CalibInfo.CalibRectLength * -0.5
	local rearLimit = rearHang - DowModule.DETECT_LENGTH

	local auxWidth = CalibInfo.CalibLengthUnit * 0.25
	local rearLeftBegin = {0.0, 0.0, 0.0}
	rearLeftBegin[1] = rearHang
	rearLeftBegin[3] = -DowModule.CENTER_WIDTH / 2
	local rearRightBegin = {rearLeftBegin[1], 0.0, -rearLeftBegin[3]}

    VertexArrayData.VertexData[1] = {rearLeftBegin[1], rearLeftBegin[2], rearLeftBegin[3]}
    VertexArrayData.VertexData[2] = {rearLimit, rearLeftBegin[2], rearLeftBegin[3]}
    VertexArrayData.VertexData[3] = VertexArrayData.VertexData[2]
    VertexArrayData.VertexData[4] = {rearLimit, rearLeftBegin[2], -DowModule.DETECT_WIDTH / 2}
    VertexArrayData.VertexData[5] = VertexArrayData.VertexData[4]
    VertexArrayData.VertexData[6] = {rearLeftBegin[1], rearLeftBegin[2], -DowModule.DETECT_WIDTH / 2}
    VertexArrayData.VertexData[7] = VertexArrayData.VertexData[6]
    VertexArrayData.VertexData[8] = VertexArrayData.VertexData[1]

    VertexArrayData.VertexData[9] = {rearRightBegin[1], rearRightBegin[2], rearRightBegin[3]}
    VertexArrayData.VertexData[10] = {rearLimit, rearRightBegin[2], rearRightBegin[3]}
    VertexArrayData.VertexData[11] = VertexArrayData.VertexData[10]
    VertexArrayData.VertexData[12] = {rearLimit, rearRightBegin[2], DowModule.DETECT_WIDTH / 2}
    VertexArrayData.VertexData[13] = VertexArrayData.VertexData[12]
    VertexArrayData.VertexData[14] = {rearRightBegin[1], rearRightBegin[2], DowModule.DETECT_WIDTH / 2}
    VertexArrayData.VertexData[15] = VertexArrayData.VertexData[14]
    VertexArrayData.VertexData[16] = VertexArrayData.VertexData[9]        
	
	return VertexArrayData
end

function GenerateOdseyGroundTrack(wheelAngle, backward)
	if wheelAngle > -7.0 and wheelAngle < 7.0 then
		if backward then
			return Generate4StepBackDistAuxHorn()
		else
			return Generate4StepFrontAux()
		end
	else
		return GenerateOdseyFrontTrack(wheelAngle, backward)
	end
end

function Generate4StepBackDistAuxHorn()
	local VertexArrayData = 
	{
		VertexData = {},
		SingleColor = {1.0, 0.85, 0.0},
		GeoMode = GL_DEFINES.GL_LINE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ZERO,
		LineWidth = HONDA_LINE_WIDTH,
		DepthTest = true,
	}
	local begin = CalibInfo.CalibFrontPosition - VehicleInfo.CarLength
	local rearSide = VehicleInfo.CarWidth / 2 + HONDA_SIDE_OFFSET
	VertexArrayData.VertexData[1] = {begin, 0, -rearSide}
	for i = 0, 20 do
		VertexArrayData.VertexData[2 + i] = {begin - 1000 , 0, -rearSide + rearSide / 10 * i}
	end
	VertexArrayData.VertexData[23] = {begin, 0, rearSide}
	return VertexArrayData
end

function Generate4StepFrontAux()
	local VertexArrayData = 
	{
		VertexData = {},
		SingleColor = {1.0, 0.85, 0.0},
		GeoMode = GL_DEFINES.GL_LINE_STRIP,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ZERO,
		LineWidth = HONDA_LINE_WIDTH,
		DepthTest = true,
	}
	local begin = CalibInfo.CalibFrontPosition
	local rearSide = VehicleInfo.CarWidth / 2 + HONDA_SIDE_OFFSET
	VertexArrayData.VertexData[1] = {begin, 0, -rearSide}
	for i = 0, 20 do
		VertexArrayData.VertexData[2 + i] = {CalibInfo.CalibFrontPosition + 1000 , 0, -rearSide + rearSide / 10 * i}
	end
	VertexArrayData.VertexData[23] = {begin, 0, rearSide}
	return VertexArrayData
end

function GenerateOdseyFrontTrack(wheelAngle, backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		SingleColor = {1.0, 0.58, 0.0},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = HONDA_LINE_WIDTH,
		DepthTest = true,
	}	
	local TRACK_PART_COUNT = 20
	local CENTER_TRACK_LENGTH = 5000
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / (TRACK_PART_COUNT - 1)
	local wheelRad = math.rad(wheelAngle)
	
	local rearAxisCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength + VehicleInfo.RearOverhang, 0.0, 0.0}
	local rearCenter = {rearAxisCenter[1], 0.0, 0.0}
	local frontCenter = {CalibInfo.CalibFrontPosition, 0.0, 0.0}

	local trackLeftBegin = {0.0, 0.0, -VehicleInfo.CarWidth / 2 - HONDA_SIDE_OFFSET_L}
	local trackRightBegin = {0.0, 0.0, VehicleInfo.CarWidth / 2 + HONDA_SIDE_OFFSET_L}
	local trackLeftBeginR = {0.0, 0.0, -VehicleInfo.CarWidth / 2 - HONDA_SIDE_OFFSET}
	local trackRightBeginR = {0.0, 0.0, VehicleInfo.CarWidth / 2 + HONDA_SIDE_OFFSET}
	local trackCenterBegin = {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	local trackBegin = {trackLeftBegin, trackRightBegin, trackLeftBeginR, trackRightBeginR}
	if backward then
		trackCenterBegin[1][1] = rearAxisCenter[1]
		trackCenterBegin[2][1] = CalibInfo.CalibRectLength / 2
		trackRightBegin[1] = rearAxisCenter[1]
		trackLeftBegin[1] = rearAxisCenter[1]
		trackRightBeginR[1] = CalibInfo.CalibRectLength / 2
		trackLeftBeginR[1] = CalibInfo.CalibRectLength / 2
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1][1] = frontCenter[1]
		trackCenterBegin[2][1] = rearAxisCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
		trackRightBeginR[1] = rearAxisCenter[1]
		trackLeftBeginR[1] = rearAxisCenter[1]
	end
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1][1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[1][3] - trackCircleCenter[3]
	local trackRadius = {0.0, 0.0}
	trackRadius[1] = math.sqrt(xDis * xDis + zDis * zDis)
	xDis = trackCenterBegin[2][1] - trackCircleCenter[1]
	zDis = trackCenterBegin[2][3] - trackCircleCenter[3]
	trackRadius[2] = math.sqrt(xDis * xDis + zDis * zDis)
	local vertexIndex = 1
	local indexIndex = 1
	local TRACK_INDEX = {1, 2}
	if not backward then
		if wheelRad > 0 then
			TRACK_INDEX = {1, 4}
		elseif wheelRad < 0 then
			TRACK_INDEX = {2, 3}
		end
	end
	for k = 1, 2 do
		for i = 1, TRACK_PART_COUNT do
			local j = TRACK_INDEX[k]
			local straightPt = table.Clone(trackBegin[j])
			straightPt[1] = straightPt[1] + trackDirection[1] * (i - 1)
			if wheelRad == 0 then
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = straightPt
			else
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = TransformToTrack(trackRadius[(j + 1) // 2], trackCenterBegin[(j + 1) // 2], trackCircleCenter, straightPt)
			end
			if i > 1 then
				VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
				VertexArrayData.IndexData[indexIndex + 1] = #VertexArrayData.VertexData - 1
				indexIndex = indexIndex + 2
			end
		end
		vertexIndex = vertexIndex + 1
	end
	indexIndex = indexIndex + 2

	return VertexArrayData
end

function GenerateOdseySideTrack(wheelAngle, backward)
	if wheelAngle > -7.0 and wheelAngle < 7.0 then
		--print("==GenerateOdseySideTrack==")
		return GenerateOdseyBackFix()
	else
		return GenerateOdseyBack(wheelAngle,backward)
	end
end

function GenerateOdseyBackFix()
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		SingleColor = {1.0, 0.85, 0.0},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = HONDA_LINE_WIDTH,
		DepthTest = true,
	}
	local wheelAngle = 0
	local TRACK_PART_COUNT = 31
	local CENTER_TRACK_LENGTH = 1800
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / (TRACK_PART_COUNT - 1)
	local wheelRad = math.rad(wheelAngle)
	
	local rearAxisCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local rearSide = VehicleInfo.CarWidth / 2 + HONDA_SIDE_OFFSET
	local trackLeftBegin = {0.0, 0.0, -rearSide}
	local trackRightBegin = {0.0, 0.0, rearSide}
	local trackLeftBeginR = {0.0, 0.0, -rearSide}
	local trackRightBeginR = {0.0, 0.0, rearSide}
	local trackCenterBegin = {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	local trackBegin = {trackLeftBegin, trackRightBegin, trackLeftBeginR, trackRightBeginR}
	local trackBackBegin
	trackCenterBegin[1][1] = rearCenter[1]
	trackCenterBegin[2][1] = CalibInfo.CalibRectLength / 2
	trackRightBegin[1] = rearCenter[1]
	trackLeftBegin[1] = rearCenter[1]
	trackRightBeginR[1] = CalibInfo.CalibRectLength / 2
	trackLeftBeginR[1] = CalibInfo.CalibRectLength / 2
	trackDirection[1] = -CENTER_TRACK_STEP
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1][1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[1][3] - trackCircleCenter[3]
	local trackRadius = {0.0, 0.0}
	trackRadius[1] = math.sqrt(xDis * xDis + zDis * zDis)
	xDis = trackCenterBegin[2][1] - trackCircleCenter[1]
	zDis = trackCenterBegin[2][3] - trackCircleCenter[3]
	trackRadius[2] = math.sqrt(xDis * xDis + zDis * zDis)
	local indexIndex = 1
	for j = 1, 2 do
		for i = 0, TRACK_PART_COUNT -1 do
			local straightPt = table.Clone(trackBegin[j])
			straightPt[1] = straightPt[1] + trackDirection[1] * i
			if wheelRad == 0 then
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = straightPt
			else
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = TransformToTrack(trackRadius[(j + 1) // 2], trackCenterBegin[(j + 1) // 2], trackCircleCenter, straightPt)
			end
			if i > 1 then
				VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
				VertexArrayData.IndexData[indexIndex + 1] = #VertexArrayData.VertexData - 1
				indexIndex = indexIndex + 2
			end
		end
	end
	local BACK_DISTS = {1000, 1800, 3000}
	for k = 1, 2 do
		for i = 0, 20 do
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {rearAxisCenter[1] - BACK_DISTS[k], 0, -rearSide + rearSide / 10 * i}
			if i > 0 then
				VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
				VertexArrayData.IndexData[indexIndex + 1] = #VertexArrayData.VertexData - 1
				indexIndex = indexIndex + 2
			end
		end
	end
	for i = 5, 47 do
		VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {rearAxisCenter[1] - 500, 0, -rearSide + rearSide / 25.5 * i}
		if i > 5 then
			VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
			indexIndex = indexIndex + 1
		end
	end
	return VertexArrayData
end

function GenerateOdseyBack(wheelAngle, backward)
	--print("==GenerateOdseyBack==",wheelAngle,backward)
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		SingleColor = {1.0, 0.58, 0.0},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = HONDA_LINE_WIDTH,
		DepthTest = true,
	}
	local TRACK_PART_COUNT = 31
	local CENTER_TRACK_LENGTH = 3000
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / (TRACK_PART_COUNT - 1)
	local wheelRad = math.rad(wheelAngle)
	
	local rearAxisCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local rearSide = VehicleInfo.CarWidth / 2 + HONDA_SIDE_OFFSET
	local trackLeftBegin = {0.0, 0.0, -rearSide}
	local trackRightBegin = {0.0, 0.0, rearSide}
	local trackLeftBeginR = {0.0, 0.0, -rearSide}
	local trackRightBeginR = {0.0, 0.0, rearSide}
	local trackCenterBegin = {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	local BACK_DISTS = {1000, 2000, 3000}
	local DOT_DIST = 500
	if backward then
		DOT_DIST = -500
		BACK_DISTS = {-1000, -2000, -3000}
		trackCenterBegin[1][1] = rearCenter[1]
		trackCenterBegin[2][1] = CalibInfo.CalibRectLength / 2
		trackRightBegin[1] = rearCenter[1]
		trackLeftBegin[1] = rearCenter[1]
		trackRightBeginR[1] = CalibInfo.CalibRectLength / 2
		trackLeftBeginR[1] = CalibInfo.CalibRectLength / 2
		trackDirection[1] = -CENTER_TRACK_STEP
	else
		trackCenterBegin[1][1] = frontCenter[1]
		trackCenterBegin[2][1] = rearAxisCenter[1]
		trackRightBegin[1] = frontCenter[1]
		trackLeftBegin[1] = frontCenter[1]
		trackRightBeginR[1] = rearAxisCenter[1]
		trackLeftBeginR[1] = rearAxisCenter[1]
	end
	local trackBegin = {trackLeftBegin, trackRightBegin, trackLeftBeginR, trackRightBeginR}
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1][1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[1][3] - trackCircleCenter[3]
	local trackRadius = {0.0, 0.0}
	trackRadius[1] = math.sqrt(xDis * xDis + zDis * zDis)
	xDis = trackCenterBegin[2][1] - trackCircleCenter[1]
	zDis = trackCenterBegin[2][3] - trackCircleCenter[3]
	trackRadius[2] = math.sqrt(xDis * xDis + zDis * zDis)
	local indexIndex = 1
	for j = 1, 2 do
		for i = 0, TRACK_PART_COUNT -1 do
			local straightPt = table.Clone(trackBegin[j])
			straightPt[1] = straightPt[1] + trackDirection[1] * i
			if wheelRad == 0 then
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = straightPt
			else
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = TransformToTrack(trackRadius[(j + 1) // 2], trackCenterBegin[1], trackCircleCenter, straightPt)
			end
			if i > 1 then
				VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
				VertexArrayData.IndexData[indexIndex + 1] = #VertexArrayData.VertexData - 1
				indexIndex = indexIndex + 2
			end
		end
	end
	for k = 1, 2 do
		for c, i in ipairs {0, 1, 19, 20} do
			local straightPt = {trackCenterBegin[1][1] + BACK_DISTS[k], 0, -rearSide + rearSide / 10 * i}
			if wheelRad == 0 then
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = straightPt
			else
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = TransformToTrack(trackRadius[1], trackCenterBegin[1], trackCircleCenter, straightPt)
			end
			VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 1
			indexIndex = indexIndex + 1
		end
	end
	for i = 0, 20 do
		local straightPt = {trackCenterBegin[1][1] + BACK_DISTS[3], 0, -rearSide + rearSide / 10 * i}
		if wheelRad == 0 then
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = straightPt
		else
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = TransformToTrack(trackRadius[1], trackCenterBegin[1], trackCircleCenter, straightPt)
		end
		if i > 0 then
			VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
			VertexArrayData.IndexData[indexIndex + 1] = #VertexArrayData.VertexData - 1
			indexIndex = indexIndex + 2
		end
	end
	for i = 5, 47 do
		local straightPt = {trackCenterBegin[1][1] + DOT_DIST, 0, -rearSide + rearSide / 25.5 * i}
		if wheelRad == 0 then
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = straightPt
		else
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = TransformToTrack(trackRadius[1], trackCenterBegin[1], trackCircleCenter, straightPt)
		end
		if i > 5 then
			VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
			indexIndex = indexIndex + 1
		end
	end
	return VertexArrayData
end

function GenerateOdseyTopRearTrack(wheelAngle, backward)
	return GenerateOdseyBackFixShort()
end
function GenerateOdseyBackFixShort()
	local VertexArrayData = 
	{
		VertexData = {},
		IndexData = {},
		SingleColor = {1.0, 0.85, 0.0},
		GeoMode = GL_DEFINES.GL_LINES,
		SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
		DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
		SrcAlphaBlend = GL_DEFINES.GL_ONE,
		DstAlphaBlend = GL_DEFINES.GL_ONE,
		LineWidth = HONDA_LINE_WIDTH,
		DepthTest = true,
	}
	local wheelAngle = 0
	local TRACK_PART_COUNT = 31
	local CENTER_TRACK_LENGTH = 1000
	local CENTER_TRACK_STEP = CENTER_TRACK_LENGTH / (TRACK_PART_COUNT - 1)
	local wheelRad = math.rad(wheelAngle)
	
	local rearAxisCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontAxisCenter = {rearAxisCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}
	local rearCenter = {CalibInfo.CalibFrontPosition - VehicleInfo.CarLength, 0.0, 0.0}
	local frontCenter = {rearCenter[1] + VehicleInfo.CarLength, 0.0, 0.0}

	local rearSide = VehicleInfo.CarWidth / 2 + HONDA_SIDE_OFFSET
	local trackLeftBegin = {0.0, 0.0, -rearSide}
	local trackRightBegin = {0.0, 0.0, rearSide}
	local trackLeftBeginR = {0.0, 0.0, -rearSide}
	local trackRightBeginR = {0.0, 0.0, rearSide}
	local trackCenterBegin = {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}}
	local trackDirection = {CENTER_TRACK_STEP, 0.0, 0.0}
	local trackBegin = {trackLeftBegin, trackRightBegin, trackLeftBeginR, trackRightBeginR}
	local trackBackBegin
	trackCenterBegin[1][1] = rearCenter[1]
	trackCenterBegin[2][1] = CalibInfo.CalibRectLength / 2
	trackRightBegin[1] = rearCenter[1]
	trackLeftBegin[1] = rearCenter[1]
	trackRightBeginR[1] = CalibInfo.CalibRectLength / 2
	trackLeftBeginR[1] = CalibInfo.CalibRectLength / 2
	trackDirection[1] = -CENTER_TRACK_STEP
	local trackRearRadius = (wheelRad == 0) and 0 or (VehicleInfo.WheelBase / math.tan(wheelRad))
	local trackCircleCenter = {rearAxisCenter[1], 0.0, trackRearRadius}
	local xDis = trackCenterBegin[1][1] - trackCircleCenter[1]
	local zDis = trackCenterBegin[1][3] - trackCircleCenter[3]
	local trackRadius = {0.0, 0.0}
	trackRadius[1] = math.sqrt(xDis * xDis + zDis * zDis)
	xDis = trackCenterBegin[2][1] - trackCircleCenter[1]
	zDis = trackCenterBegin[2][3] - trackCircleCenter[3]
	trackRadius[2] = math.sqrt(xDis * xDis + zDis * zDis)
	local indexIndex = 1
	for j = 1, 2 do
		for i = 0, TRACK_PART_COUNT -1 do
			local straightPt = table.Clone(trackBegin[j])
			straightPt[1] = straightPt[1] + trackDirection[1] * i
			if wheelRad == 0 then
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = straightPt
			else
				VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = TransformToTrack(trackRadius[(j + 1) // 2], trackCenterBegin[(j + 1) // 2], trackCircleCenter, straightPt)
			end
			if i > 1 then
				VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
				VertexArrayData.IndexData[indexIndex + 1] = #VertexArrayData.VertexData - 1
				indexIndex = indexIndex + 2
			end
		end
	end
	local BACK_DISTS = {1000, 1800, 3000}
	for k = 1, 1 do
		for i = 0, 20 do
			VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {rearAxisCenter[1] - BACK_DISTS[k], 0, -rearSide + rearSide / 10 * i}
			if i > 0 then
				VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
				VertexArrayData.IndexData[indexIndex + 1] = #VertexArrayData.VertexData - 1
				indexIndex = indexIndex + 2
			end
		end
	end
	for i = 5, 47 do
		VertexArrayData.VertexData[#VertexArrayData.VertexData + 1] = {rearAxisCenter[1] - 500, 0, -rearSide + rearSide / 25.5 * i}
		if i > 5 then
			VertexArrayData.IndexData[indexIndex] = #VertexArrayData.VertexData - 2
			indexIndex = indexIndex + 1
		end
	end
	return VertexArrayData
end
