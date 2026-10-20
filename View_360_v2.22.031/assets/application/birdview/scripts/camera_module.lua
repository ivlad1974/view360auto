CameraModule = {
    cameraCore = nil,
    cameraLookat = { {}, {}, {}, {}, {}, {} },
    originPitch = {},
    CAMERA_RIGHT = { { 0.0, 0.0, 1.0 }, { -1.0, 0.0, 0.0 }, { 0.0, 0.0, -1.0 }, { 1.0, 0.0, 0.0 } , { -1.0, 0.0, 0.0 }, { 1.0, 0.0, 0.0 }}
}

SideViewParam["R2"] = {}
SideViewParam["R4"] = {}
SingleViewParam["R2"] = {}
SingleViewParam["R4"] = {}

function CameraModule:OnInit()
    for camIdx = 1, 6 do
		if SingleViewParam[camIdx] then
			self.originPitch[camIdx] = SingleViewParam[camIdx].Pitch
		end
    end
end

function CameraModule:OnUpdateConfig()
    self:OnUpdateSetting("SideViewParam")
    self:OnUpdateSetting("SingleViewParam")
end

function CameraModule:UpdateSideRev()
    local centerX = Camera_GetCameraCenter(2)
    SideViewParam["R2"].XOffset = -(centerX - (SideViewParam[2].XOffset / SideViewParam[2].XScale / 2 + 0.5 - centerX) - 0.5) * SideViewParam[2].XScale * 2
    SideViewParam["R2"].XScale = -SideViewParam[2].XScale
    SideViewParam["R2"].Rotate = SideViewParam[2].Rotate
    SideViewParam["R2"].YOffset = SideViewParam[2].YOffset
    SideViewParam["R2"].YScale = SideViewParam[2].YScale

    local sx = 0.5 + SideViewParam["R2"].XOffset / SideViewParam["R2"].XScale / 2.0
    local sy = 1.0 - (0.5 + SideViewParam["R2"].YOffset / SideViewParam["R2"].YScale / 2.0)
    local x, y, z = Camera_PixelToWorld(sx, sy, 2)
    SideViewParam["R2"].LookAt = { x, y, z }
    local camPos = CalibInfo.Cameras[2].Position
    local rotMatrix = Math_CreateMatrix()
    local cameraDir = { x - camPos[1], y - camPos[2], z - camPos[3] }
    SideViewParam["R2"].UpDirection = table.Clone(CalibInfo.Cameras[2].UpVector)
    Math_MatrixRotate(rotMatrix, -SideViewParam["R2"].Rotate, cameraDir)
    SideViewParam["R2"].UpDirection = Math_TransformVector(rotMatrix, SideViewParam["R2"].UpDirection)

    centerX = Camera_GetCameraCenter(4)
    SideViewParam["R4"].XOffset = -(centerX - (SideViewParam[4].XOffset / SideViewParam[4].XScale / 2 + 0.5 - centerX) - 0.5) * SideViewParam[4].XScale * 2
    SideViewParam["R4"].XScale = -SideViewParam[4].XScale
    SideViewParam["R4"].Rotate = SideViewParam[4].Rotate
    SideViewParam["R4"].YOffset = SideViewParam[4].YOffset
    SideViewParam["R4"].YScale = SideViewParam[4].YScale

    local sx = 0.5 + SideViewParam["R4"].XOffset / SideViewParam["R4"].XScale / 2.0
    local sy = 1.0 - (0.5 + SideViewParam["R4"].YOffset / SideViewParam["R4"].YScale / 2.0)
    local x, y, z = Camera_PixelToWorld(sx, sy, 4)
    SideViewParam["R4"].LookAt = { x, y, z }
    local camPos = CalibInfo.Cameras[4].Position
    local rotMatrix = Math_CreateMatrix()
    local cameraDir = { x - camPos[1], y - camPos[2], z - camPos[3] }
    SideViewParam["R4"].UpDirection = table.Clone(CalibInfo.Cameras[4].UpVector)
    Math_MatrixRotate(rotMatrix, -SideViewParam["R4"].Rotate, cameraDir)
    SideViewParam["R4"].UpDirection = Math_TransformVector(rotMatrix, SideViewParam["R4"].UpDirection)
end

function CameraModule:UpdateSingleRev()
	local rotateMat = Math_CreateMatrix()

	SingleViewParam["R2"].Camera = SingleViewParam[2].Camera
	SingleViewParam["R2"].FOV = SingleViewParam[2].FOV
	SingleViewParam["R2"].Mirror = not SingleViewParam[2].Mirror
	SingleViewParam["R2"].Pitch = SingleViewParam[2].Pitch
	SingleViewParam["R2"].XBias = SingleViewParam[2].XBias
	SingleViewParam["R2"].AngleBias = SingleViewParam[2].AngleBias
	SingleViewParam["R2"].Position = table.Clone(CalibInfo.Cameras[2].Position)
	SingleViewParam["R2"].UpDirection = table.Clone(SingleViewParam[2].UpDirection)
	SingleViewParam["R2"].UpDirection[1] = -SingleViewParam["R2"].UpDirection[1]

	
	SingleViewParam["R4"].Camera = SingleViewParam[4].Camera
	SingleViewParam["R4"].FOV = SingleViewParam[4].FOV
	SingleViewParam["R4"].Mirror = not SingleViewParam[4].Mirror
	SingleViewParam["R4"].Pitch = SingleViewParam[4].Pitch
	SingleViewParam["R4"].XBias = SingleViewParam[4].XBias
	SingleViewParam["R4"].AngleBias = SingleViewParam[4].AngleBias
	SingleViewParam["R4"].Position = table.Clone(CalibInfo.Cameras[4].Position)
	SingleViewParam["R4"].UpDirection = table.Clone(SingleViewParam[4].UpDirection)
	SingleViewParam["R4"].UpDirection[1] = -SingleViewParam["R4"].UpDirection[1]

	local cameraDirR = table.Clone(CalibInfo.Cameras[2].Direction)
	cameraDirR[3] = 0.0
	local zPlaneAngleR = Math_VectorGetAngle(cameraDirR, SingleViewParam[2].Direction)
	local cameraDirL = table.Clone(CalibInfo.Cameras[4].Direction)
	cameraDirL[3] = 0.0
	local zPlaneAngleL = Math_VectorGetAngle(cameraDirL, SingleViewParam[4].Direction)

	if zPlaneAngleL > zPlaneAngleR then
		Math_MatrixRotate(rotateMat, {0.0, 0.0, zPlaneAngleR})
		SingleViewParam["R2"].Direction = Math_TransformVector(rotateMat, cameraDirR)
		SingleViewParam["R4"].Direction = SingleViewParam["R2"].Direction
	else
		Math_MatrixRotate(rotateMat, {0.0, 0.0, zPlaneAngleL})
		SingleViewParam["R2"].Direction = Math_TransformVector(rotateMat, cameraDirL)
		SingleViewParam["R4"].Direction = SingleViewParam["R2"].Direction
	end
end

function CameraModule:OnUpdateSetting(keyString)
    if string.find(keyString, "SideViewParam") then

        local fakeUp = { 0, 1, 0 }
        local whRate = 0.5625
        -- for camIdx = 1, 4, 2 do
        -- local upVec = CalibInfo.Cameras[camIdx].UpVector
        -- local dir = CalibInfo.Cameras[camIdx].Direction
        -- local fakeRight = Math_VectorGetCross(dir, fakeUp)
        -- local otherUp = Math_VectorGetCross(fakeRight, dir)
        -- local degree = Math_VectorGetAngle(otherUp, upVec)
        -- local degToRight = Math_VectorGetAngle(upVec, fakeRight)
        -- local camRate =  whRate / (math.abs(SideViewParam[camIdx].YScale) / math.abs(SideViewParam[camIdx].XScale))
        -- local tanVal = math.tan(math.rad(degree))
        -- local scaledTan = tanVal / camRate
        -- degree = math.deg(math.atan(scaledTan))
        -- if SideViewParam[camIdx].XScale < 0.0 and degToRight < 90.0 then
        -- degree = -degree
        -- end
        -- if SideViewParam[camIdx].XScale > 0.0 and degToRight > 90.0 then
        -- degree = -degree
        -- end
        -- SideViewParam[camIdx].Rotate = degree
        -- end

        for camIdx = 1, 8 do
            if SideViewParam[camIdx] ~= nil and CalibInfo.Cameras[i] ~= nil then
                local sx = 0.5 + SideViewParam[camIdx].XOffset / SideViewParam[camIdx].XScale / 2.0
                local sy = 1.0 - (0.5 + SideViewParam[camIdx].YOffset / SideViewParam[camIdx].YScale / 2.0)
                local x, y, z = Camera_PixelToWorld(sx, sy, camIdx)
                SideViewParam[camIdx].LookAt = { x, y, z }
                local pixUp = { 0.0, -0.02 }
                pixUp[1] = pixUp[2] * math.sin(math.rad(SideViewParam[camIdx].Rotate)) + sx
                pixUp[2] = pixUp[2] * math.cos(math.rad(SideViewParam[camIdx].Rotate)) + sy

                local ux, uy, uz = Camera_PixelToWorld(pixUp[1], pixUp[2], camIdx)
                local fakeUp = Math_VectorGetNormalized({ ux - x, uy - y, uz - z })
                local camPos = CalibInfo.Cameras[camIdx].Position
                local cameraDir = Math_VectorGetNormalized({ x - camPos[1], y - camPos[2], z - camPos[3] })
                local cameraRight = Math_VectorGetCross(cameraDir, fakeUp)
                SideViewParam[camIdx].UpDirection = Math_VectorGetCross(cameraRight, cameraDir)
            end
        end
        --self:UpdateSideRev()
    end
    if string.find(keyString, "SingleViewParam") then
        local centerPos = { 0, 0, 0 }
        local centerDir = 0

        for camIdx = 1, 8 do
            if SingleViewParam[camIdx] ~= nil and CalibInfo.Cameras[i] ~= nil then
                local pitchStr = "SingleViewParam%[" .. camIdx .. "%].Pitch"
                if string.find(keyString, pitchStr) then
                    self.originPitch[camIdx] = SingleViewParam[camIdx].Pitch
                else
                    SingleViewParam[camIdx].Pitch = self.originPitch[camIdx]
                end
                SingleViewParam[camIdx].Position = table.Clone(CalibInfo.Cameras[camIdx].Position)
                for i = 1, #SingleViewParam[camIdx].Position do
                    SingleViewParam[camIdx].Position[i] = SingleViewParam[camIdx].Position[i] / (CalibInfo.CalibLengthUnit / 1000.0)
                    centerPos[i] = centerPos[i] + SingleViewParam[camIdx].Position[i]
                end
                centerDir = centerDir + CalibInfo.Cameras[camIdx].Direction[2]
                if SingleViewParam[camIdx].ZAlign then
                    SingleViewParam[camIdx].Position[3] = 0.0
                end
                if SingleViewParam[camIdx].BottomAlign then
                    local cx = Camera_GetCameraCenter(camIdx)
                    local bottomAngle = Camera_GetPixelAngle(camIdx, cx, 1.0)
                    local upAngle = Camera_GetPixelAngle(camIdx, cx, 0.0)
                    local camDir = CalibInfo.Cameras[camIdx].Direction
                    local horiDir = { camDir[1], 0.0, camDir[3] }
                    local horiAng = Math_VectorGetAngle(horiDir, camDir)
                    if camDir[2] < 0.0 then
                        horiAng = -horiAng
                    end
                    if SingleViewParam[camIdx].FOV > bottomAngle + upAngle then
                        SingleViewParam[camIdx].FOV = bottomAngle + upAngle
                    end
                    local bottomLimit = bottomAngle - SingleViewParam[camIdx].FOV / 2.0 - horiAng
                    local upLimit = -upAngle + SingleViewParam[camIdx].FOV / 2.0 - horiAng
                    if SingleViewParam[camIdx].Pitch > bottomLimit then
                        SingleViewParam[camIdx].Pitch = bottomLimit
                    elseif SingleViewParam[camIdx].Pitch < upLimit then
                        SingleViewParam[camIdx].Pitch = upLimit
                    end
                    -- SingleViewParam[camIdx].Pitch = self.originPitch[camIdx]
                end
            end
        end
        centerPos = { centerPos[1] / 4.0, centerPos[2] / 4.0, centerPos[3] / 4.0 }
        centerDir = centerDir / 4
        local direction = { math.sqrt(1.0 - centerDir * centerDir), centerDir, 0 }
        if SingleViewParam.Center then
            SingleViewParam.Center.Position = centerPos
            SingleViewParam.Center.CenPos = { centerPos[1] + direction[1], centerPos[2] + direction[2], centerPos[3] + direction[3] }
        end
        self:UpdateSingleRev()
        if type(DefineFixViews) == "function" then
            FixViews = DefineFixViews()
        end
    end
end

AllModules["Camera"] = CameraModule

