ModelModule = {
    shader = nil,
    model = nil,
    reflectTexture = nil,
    flareTexture = nil,
    invertTrans = nil,
    wheelRotate = 0,
    frameTime = 0.0,
    currentTime = 0.0,
    animatedTime = nil,
    shadow = nil,
    skeleton = {},
    rightSignal = {},
    leftSignal = {},
    dayRunningLight = {},
    breakLight = {},
    doorAngle = { 0.0, 0.0, 0.0, 0.0, 0.0 },
    doorFinal = {},
    doorPos = {},
    doorPrg = {},
    doorEnd = {},
    doorBegin = {},
    currentAlpha = 0.0,
    speedAlpha = VehicleModel.MinSpeedAlpha or 0.2,
    MAX_DOOR_ANGLE = 60.0,
    boundMax = {},
    boundMin = {},
}

local function GenerateAxisShadow(frontAxis, rearAxis, width)
    local rectWidth = CalibInfo.CalibRectWidth / 2
    local rectLength = CalibInfo.CalibRectLength / 2
    local extraFront = CalibExtra and CalibExtra.FrontOffset or 0
    local extraRear = CalibExtra and CalibExtra.RearOffset or 0
    local extraSide = CalibExtra and CalibExtra.SideOffset or 0
    local VertexArrayData = {
        VertexData = { { -rectLength - extraRear, 0.0, -width / 2.0 },
                       { -rectLength - extraRear, 0.0, width / 2.0 },
                       { rearAxis, 0.0, -width / 2.0 },
                       { rearAxis, 0.0, width / 2.0 },
                       { frontAxis, 0.0, -width / 2.0 },
                       { frontAxis, 0.0, width / 2.0 },
                       { rectLength + extraFront, 0.0, -width / 2.0 },
                       { rectLength + extraFront, 0.0, width / 2.0 } },
        TexcoordData = { { 0.0, 0.0 }, { 1.0, 0.0 }, { 0.0, VehicleModel.AxisCoord[1] }, { 1.0, VehicleModel.AxisCoord[1] }, { 0.0, VehicleModel.AxisCoord[2] }, { 1.0, VehicleModel.AxisCoord[2] }, { 0.0, 1.0 }, { 1.0, 1.0 } },
        GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ONE,
        DepthTest = false,
        TextureFile = Common.ShadowTexture,
    }
    return VertexArrayData
end

function ModelModule:UpdateModelBound()
    local rootScale = { 1.0, 1.0, 1.0 }
    local position = { 0.0, 0.0, 0.0 }
    local extraFront = CalibExtra and CalibExtra.FrontOffset or 0
    local extraRear = CalibExtra and CalibExtra.RearOffset or 0
    local extraSide = CalibExtra and CalibExtra.SideOffset or 0
    if self.ModelSize then
        if VehicleModel.RealBound then
            local scaleX = VehicleInfo.CarLength / self.ModelSize[1]
            rootScale[1] = scaleX
            rootScale[2] = scaleX
            rootScale[3] = VehicleInfo.CarWidth / self.ModelSize[3]
            position[1] = (CalibInfo.CalibFrontPosition - VehicleInfo.CarLength / 2)
        else
            local scaleX = (CalibInfo.CalibRectLength + extraFront + extraRear) / self.ModelSize[1]
            rootScale[1] = scaleX
            rootScale[2] = scaleX
            rootScale[3] = (VehicleModel.ScaleWidth and ((CalibInfo.CalibRectWidth + extraSide * 2) / self.ModelSize[3])) or scaleX
            position[1] = (extraFront - extraRear) / 2.0
        end
    end
    if VehicleModel.AdditionalScale then
        rootScale[1] = rootScale[1] * VehicleModel.AdditionalScale[1]
        rootScale[2] = rootScale[2] * VehicleModel.AdditionalScale[2]
        rootScale[3] = rootScale[3] * VehicleModel.AdditionalScale[3]
    end
    self:SetJointTrans("root", position, nil, rootScale)
    self.boundMax, self.boundMin = Model_GetBound(self.model)
    self:UpdateLogoScale()

    if VehicleModel.AxisShadow then
        local frontAxis = nil
        local rearAxis = nil
        for i, v in ipairs(self.skeleton) do
            if v.Name == "rearAxis" then
                rearAxis = v.Position[1]
                break
            end
        end
        for i, v in ipairs(self.skeleton) do
            if v.Name == "frontAxis" then
                frontAxis = v.Position[1]
                break
            end
        end
        if frontAxis and rearAxis then
            self.shadow = GeometryModule:GenerateWorldGeo(GenerateAxisShadow(frontAxis, rearAxis, (self.boundMax[3] - self.boundMin[3]) * 0.9))
        end
    else
        self.shadow = GeometryModule:GenerateWorldGeo(CalibRectShadow())
    end

    if VehicleModel.RealAxis then
        for i, v in ipairs(self.skeleton) do
            if v.Name == "rearAxis" then
                v.Position[1] = CalibInfo.CalibFrontPosition - VehicleInfo.FrontOverhang - VehicleInfo.WheelBase
                self:SetJointTrans("rearAxis", v.Position)
                break
            end
        end
        for i, v in ipairs(self.skeleton) do
            if v.Name == "frontAxis" then
                v.Position[1] = CalibInfo.CalibFrontPosition - VehicleInfo.FrontOverhang
                self:SetJointTrans("frontAxis", v.Position)
                break
            end
        end
    end

    for i, v in ipairs(self.skeleton) do
        if v.Name == "rlSlideBase" then
            self.doorEnd[3] = table.Clone(v.Position)
        end
        if v.Name == "rlSlideEnd" then
            self.doorBegin[3] = table.Clone(v.Position)
        end
        if v.Name == "rrSlideBase" then
            self.doorEnd[4] = table.Clone(v.Position)
        end
        if v.Name == "rrSlideEnd" then
            self.doorBegin[4] = table.Clone(v.Position)
        end
    end

end

function ModelModule:UpdateLogoScale()
    local logoScale = {
        VehicleModel.LogoScale, VehicleModel.LogoScale, VehicleModel.LogoScale
    }
    self:SetJointTrans("logo", nil, nil, logoScale)
end

function ModelModule:SetJointTrans(jointName, position, rotation, scale)
    scale = scale or { 1.0, 1.0, 1.0 }
    for i, v in ipairs(self.skeleton) do
        if string.sub(v.Name, 1, #jointName) == jointName then
            v.Position = position or v.Position
            v.Rotation = rotation or v.Rotation
            v.Scale = scale or v.Scale
            Model_SetJoint(self.model, v.Name, v)
        end
    end
    self.skeleton = {}
    Model_GetSkeleton(self.model, self.skeleton)
end

function ModelModule:LoadModel(filePath)
    self.model = nil
    collectgarbage()
    self.model = Model_LoadModel(filePath)
    if self.model == nil then
        return
    end
    Model_SetShader(self.model, self.shader)
    if self.reflectTexture then
        Model_SetReflectTexture(self.model, self.reflectTexture.TextureId, VehicleModel.ReflectFactor)
    end
    if VehicleModel.CarPaint then
        Model_SetMaterial(self.model, "Car_Paint", VehicleModel.CarPaint)
    end
    if VehicleModel.License then
        Model_SetMaterial(self.model, "License", VehicleModel.License)
    end
    Model_SetAlpha(self.model, VehicleModel.Alpha)
    self.ModelSize = Model_GetSize(self.model)
    self.skeleton = {}
    Model_GetSkeleton(self.model, self.skeleton)
    local lightParam = {
        LightPos = { 200.0, 1200.0, 1500.0, 0.0 },
        Ambient = { 0.5, 0.5, 0.5 },
        Diffuse = { 0.8, 0.8, 0.8 },
    }
    Model_SetLightParam(self.model, lightParam)
    local modelGroups = Model_GetGroups(self.model)
    self.rightSignal = {}
    self.leftSignal = {}
    self.dayRunningLight = {}
    for i, v in ipairs(modelGroups) do
        if string.sub(v, 1, 6) == "RLight" then
            table.insert(self.rightSignal, i)
        end
        if string.sub(v, 1, 6) == "LLight" then
            table.insert(self.leftSignal, i)
        end
        if string.sub(v, -3) == "DRL" then
            table.insert(self.dayRunningLight, i)
        end
        if string.sub(v, 1, 10) == "BreakLight" then
            table.insert(self.breakLight, i)
        end
    end
    if CalibInfo.CalibRectLength and CalibInfo.CalibRectLength > 0 and CalibInfo.CalibRectWidth and CalibInfo.CalibRectWidth > 0 then
        self:UpdateModelBound()
    end
    self.animatedTime = 0.0
end

function ModelModule:OnDoorStateChanged(value, index)
    value = value and value ~= 0
    local doorAng = value and self.MAX_DOOR_ANGLE or 0
    if index % 2 == 0 then
        doorAng = -doorAng
    end
    self.doorFinal[index] = doorAng
    if value then
        self.doorPrg[index] = 0
    else
        self.doorPrg[index] = -math.pi * 1.5
    end
end

function ModelModule:OnSpeedChanged(value)
    if value >= VehicleModel.AlphaSpeedRange[2] then
        self.speedAlpha = 1.0
    elseif value < VehicleModel.AlphaSpeedRange[1] then
        self.speedAlpha = VehicleModel.MinSpeedAlpha
    else
        self.speedAlpha = (value - VehicleModel.AlphaSpeedRange[1]) / (VehicleModel.AlphaSpeedRange[2] - VehicleModel.AlphaSpeedRange[1]) * (1.0 - VehicleModel.MinSpeedAlpha) + VehicleModel.MinSpeedAlpha
    end
end

function ModelModule:OnInit()
    self.shader = Model_LoadShader(Common.ShaderPath, VehicleModel.PrerenderWidth, VehicleModel.PrerenderHeight, VehicleModel.EnvirementPaint)

    self.reflectTexture = Texture_LoadTexture(VehicleModel.ReflectImage)
    self.flareTexture = Texture_LoadTexture(VehicleModel.FlareImage)

    StateModule:AttachNotifier("Speed", self, self.OnSpeedChanged)
    StateModule:AttachNotifier("Door", self, self.OnDoorStateChanged)

    self.invertTrans = Math_CreateMatrix()

    self:LoadModel(VehicleModel.ModelFile)

    VehicleModel.MinSpeedAlpha = VehicleModel.MinSpeedAlpha or 0.2
    VehicleModel.AlphaSpeedRange = VehicleModel.AlphaSpeedRange or { 5.0, 15.0 }

end

function ModelModule:OnUpdateConfig()
    self:UpdateModelBound()
    Model_UpdateConfig(self.model);
end

function ModelModule:OnUpdateSetting(keyString)
    if string.find(keyString, "VehicleModel") then
        if string.find(keyString, "ModelFile") or keyString == "VehicleModel" then
            self:LoadModel(VehicleModel.ModelFile)
        end
        if string.find(keyString, "CarPaint") or keyString == "VehicleModel" then
            Model_SetMaterial(self.model, "Car_Paint", VehicleModel.CarPaint)
        end
        if string.find(keyString, "License") or keyString == "VehicleModel" then
            Model_SetMaterial(self.model, "License", VehicleModel.License)
        end
        if string.find(keyString, "LogoScale") or keyString == "VehicleModel" then
            self:UpdateLogoScale()
        end
        if string.find(keyString, "Alpha") or keyString == "VehicleModel" then
            Model_SetAlpha(self.model, VehicleModel.Alpha)
        end
        if string.find(keyString, "ReflectFactor") and self.reflectTexture then
            Model_SetReflectTexture(self.model, self.reflectTexture.TextureId, VehicleModel.ReflectFactor)
        end
        if string.find(keyString, "EnvirementPaint") then
            self.shader = Model_LoadShader(Common.ShaderPath, VehicleModel.PrerenderWidth, VehicleModel.PrerenderHeight, VehicleModel.EnvirementPaint)
            self:LoadModel(VehicleModel.ModelFile)
            self:OnUpdateConfig()
        end
    end
    if string.find(keyString, "ShadowTexture") then
        self:UpdateModelBound()
    end
    if VehicleModel.RealBound and string.find(keyString, "VehicleInfo") then
        self:UpdateModelBound()
    end
    if not VehicleModel.RealBound and string.find(keyString, "CalibExtra") then
        self:UpdateModelBound()
    end
end

function ModelModule:OnRender(sceneContent, currentView, projMatrix, transformMatrix)
    if currentView.Camera and currentView.MeshBlendFac then
        return
    end
    local timeElaps = self.frameTime
    if VehicleModel.ShowShadow and (not Common.StreamMode or not sceneContent.WheelMode) then
        GeometryModule:RenderWorldObject(self.shadow, projMatrix, transformMatrix)
    end
    if self.model == nil then
        return
    end
    currentView.CarOffset = currentView.CarOffset or { 0.0, 0.0, 0.0 }
    local extraTrans = {
        CarOffset = currentView.CarOffset,
    }
    local lightScale = math.sin(self.currentTime / 0.4 * math.pi) / 2.0 + 0.5
    if not sceneContent.LeftBlink and not sceneContent.RightBlink or Common.StreamMode then
        lightScale = 0.0
    end
    local renderParam = {
        WheelAngle = StateModule:GetInputState("WheelAngle"),
        Speed = StateModule:GetInputState("Speed") * VehicleModel.SpeedScale,
        WheelRotate = self.wheelRotate,
        Prerender = sceneContent.Prerender and not currentView.animating,
    }
    if sceneContent.SpeedAlpha then
        self.currentAlpha = self.speedAlpha
        Model_SetAlpha(self.model, self.currentAlpha)
    elseif sceneContent.Alpha then
        self.currentAlpha = sceneContent.Alpha
        Model_SetAlpha(self.model, self.currentAlpha)
    elseif self.currentAlpha ~= VehicleModel.Alpha then
        self.currentAlpha = VehicleModel.Alpha
        Model_SetAlpha(self.model, self.currentAlpha)
    end
    local bAlphaChanged = false
    if VehicleModel.NearAlpha or VehicleModel.NearSink then
        Math_MatrixIdentify(self.invertTrans)
        Math_MatrixTranslate(self.invertTrans, currentView.CarOffset)
        Math_MatrixMultiply(self.invertTrans, transformMatrix, self.invertTrans)
        Math_MatrixInvert(self.invertTrans)
        local eyePos = Math_TransformPoint(self.invertTrans, { 0.0, 0.0, -(currentView.ZNear or Common.ZNear) })
        if eyePos[1] > self.boundMin[1] + currentView.CarOffset[1] and
                eyePos[1] < self.boundMax[1] + currentView.CarOffset[1] and
                eyePos[2] > self.boundMin[2] + currentView.CarOffset[2] and
                eyePos[2] < self.boundMax[2] + currentView.CarOffset[2] and
                eyePos[3] > self.boundMin[3] + currentView.CarOffset[3] and
                eyePos[3] < self.boundMax[3] + currentView.CarOffset[3] then
            if VehicleModel.NearSink then
                currentView.CarOffset[2] = currentView.CarOffset[2] - (self.boundMax[2] - eyePos[2])
            end
            if VehicleModel.NearAlpha then
                self.currentAlpha = 0.0
                Model_SetAlpha(self.model, self.currentAlpha)
                bAlphaChanged = true
            end
        end
    end
    if not Common.StreamMode or not sceneContent.WheelMode then
        Model_RenderModel(self.model, projMatrix, transformMatrix, extraTrans, renderParam)
    else
        Model_RenderWheel(self.model, projMatrix, transformMatrix, extraTrans, renderParam)
    end
    local isLight = sceneContent.DRL or sceneContent.LeftBlink or sceneContent.RightBlink or StateModule:GetInputState("HeadLight") and StateModule:GetInputState("HeadLight") > 0 or StateModule:GetInputState("LeftSignal") or StateModule:GetInputState("RightSignal")
    if not sceneContent.Prerender and isLight then
        local SIG_COLOR = { 1.0, 0.85, 0.0, lightScale }
        local DRL_COLOR = { 1.0, 1.0, 1.0, lightScale > 0.0 and 0.4 or 0.8 }
        local BREAK_COLOR = { 0.6, 0.0, 0.0, 0.8 }
        if EffectModule and #ModelLightRenderPass > 0 then
            EffectModule:BeginNewPass(ModelLightRenderPass)
        end
        if (sceneContent.DRL or StateModule:GetInputState("HeadLight") > 0) and #self.dayRunningLight > 0 then
            Model_RenderExtraGroup(self.model, self.dayRunningLight, projMatrix, transformMatrix, extraTrans, DRL_COLOR, true)
            Model_RenderExtraGroup(self.model, self.breakLight, projMatrix, transformMatrix, extraTrans, BREAK_COLOR, true)
        end
        if sceneContent.LeftBlink or StateModule:GetInputState("LeftSignal") then
            Model_RenderExtraGroup(self.model, self.leftSignal, projMatrix, transformMatrix, extraTrans, SIG_COLOR, true, self.flareTexture and self.flareTexture.TextureId or 0)
        end
        if sceneContent.RightBlink or StateModule:GetInputState("RightSignal") then
            Model_RenderExtraGroup(self.model, self.rightSignal, projMatrix, transformMatrix, extraTrans, SIG_COLOR, true, self.flareTexture and self.flareTexture.TextureId or 0)
        end
        if EffectModule and #ModelLightRenderPass > 0 then
            EffectModule:EndNewPass()
        end
    end
end

function ModelModule:OnUpdateSample(timeStamp)
    self.frameTime = timeStamp / 1000.0 - self.currentTime
    if self.frameTime > 1.0 or self.frameTime < 0.0 then
        self.frameTime = 0.0
    end
    self.wheelRotate = self.wheelRotate + self.frameTime * StateModule:GetInputState("Speed") * VehicleModel.SpeedScale
    self.currentTime = timeStamp / 1000.0
    -- process door animate
    local DOOR_NAME = { "flDoor", "frDoor", "rlDoor", "rrDoor", "tailDoor" }
    for i = 1, 5 do
        if self.doorFinal[i] then
            if self.doorAngle[i] < self.doorFinal[i] then
                self.doorAngle[i] = self.doorAngle[i] + self.MAX_DOOR_ANGLE * self.frameTime
                if self.doorAngle[i] >= self.doorFinal[i] then
                    self.doorAngle[i] = self.doorFinal[i]
                    self.doorFinal[i] = nil
                end
            elseif self.doorAngle[i] > self.doorFinal[i] then
                self.doorAngle[i] = self.doorAngle[i] - self.MAX_DOOR_ANGLE * self.frameTime
                if self.doorAngle[i] <= self.doorFinal[i] then
                    self.doorAngle[i] = self.doorFinal[i]
                    self.doorFinal[i] = nil
                end
            end
            local doorRotate = { 0.0, self.doorAngle[i], 0.0 }
            if i == 5 then
                doorRotate = { 0.0, 0.0, self.doorAngle[i] }
            end
            self:SetJointTrans(DOOR_NAME[i], nil, doorRotate, nil)
        end
    end
    local SLIDE_NAME = { "", "", "rlSlideEnd", "rrSlideEnd" }
    for i = 3, 4 do
        if self.doorPrg[i] then
            self.doorPrg[i] = self.doorPrg[i] + self.frameTime * math.pi / 2.0
            local fac = math.sin(self.doorPrg[i])
            if self.doorBegin[i] then
                local doorPos = {}
                doorPos[1] = self.doorBegin[i][1] * (1.0 - fac) + self.doorEnd[i][1] * fac
                doorPos[2] = self.doorBegin[i][2] * (1.0 - fac) + self.doorEnd[i][2] * fac
                doorPos[3] = self.doorBegin[i][3] * (1.0 - fac) + self.doorEnd[i][3] * fac
                local rate = (doorPos[1] - self.doorBegin[i][1]) / (self.doorEnd[i][1] - self.doorBegin[i][1])
                if self.doorPrg[i] < 0.0 then
                    if self.doorPrg[i] > -math.pi then
                        doorPos = table.Clone(self.doorBegin[i])
                        self.doorPrg[i] = nil
                    end
                elseif self.doorPrg[i] > math.pi / 2.0 then
                    doorPos = table.Clone(self.doorEnd[i])
                    self.doorPrg[i] = nil
                end
                self:SetJointTrans(SLIDE_NAME[i], doorPos, nil, nil)
            end
        end
    end

end

AllModules["Model"] = ModelModule

