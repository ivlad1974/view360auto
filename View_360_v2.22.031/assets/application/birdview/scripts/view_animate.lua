function ViewJump(currentView, targetView, timeElaps)
    --viewAnimatingSec = 0
    local animateView = table.Clone(targetView)
    return animateView, true
end

function FormatView(inputView)
    if inputView == nil or inputView.Formated then
        return
    end
    if not inputView.Position then
        if inputView.Camera then
            inputView.Position = table.Clone(CalibInfo.Cameras[inputView.Camera].Position)
        elseif inputView.CenPos and inputView.EyeDist then
            inputView.Position = {}
            local pitch = inputView.Tilt or inputView.Pitch or 0.0
            local yaw = inputView.Yaw or 0.0
            local lookatDir = { -inputView.EyeDist, 0, 0 }
            lookatDir = Math_VectorRotate(lookatDir, -pitch, { 0.0, 0.0, 1.0 })
            lookatDir = Math_VectorRotate(lookatDir, -yaw, { 0.0, 1.0, 0.0 })
            local rotatedLookat = Math_VectorRotate(inputView.CenPos, -pitch, { 0.0, 0.0, 1.0 })
            rotatedLookat = Math_VectorRotate(rotatedLookat, -yaw, { 0.0, 1.0, 0.0 })
            inputView.Position = { rotatedLookat[1] + lookatDir[1], rotatedLookat[2] + lookatDir[2], rotatedLookat[3] + lookatDir[3], }
            inputView.CenPos = rotatedLookat
            inputView.UpDirection = Math_VectorRotate(Math_VectorRotate({ 0.0, 1.0, 0.0 }, -pitch, { 0.0, 0.0, 1.0 }), -yaw, { 0.0, 1.0, 0.0 })
        end
    end
    if not inputView.CenPos then
        if inputView.Direction then
            -- Camera view direction effects by the AngleBias and Pitch param, need to find out the real direction simply by rotate the origin one
            local realDirection = Math_VectorRotate(inputView.Direction, -inputView.AngleBias, { 0.0, 1.0, 0.0 })
            -- first perform the yaw rotate
            local cameraRight = Math_VectorGetCross(realDirection, { 0.0, 1.0, 0.0 })
            local lookatLen = CalibInfo.CalibLengthUnit * 4.0
            realDirection = Math_VectorRotate(realDirection, -inputView.Pitch, cameraRight)
            inputView.CenPos = { inputView.Position[1] + realDirection[1] * lookatLen, inputView.Position[2] + realDirection[2] * lookatLen, inputView.Position[3] + realDirection[3] * lookatLen }
            inputView.UpDirection = Math_VectorRotate(inputView.UpDirection, -inputView.AngleBias, { 0.0, 1.0, 0.0 })
            inputView.ZNear = 200
            inputView.ZFar = 30000
        elseif inputView.XScale then
            inputView.CenPos = SideViewParam[inputView.Camera].LookAt
            inputView.FOV = 110 / inputView.YScale
        end
    end
    if not inputView.UpDirection then
        if inputView.EyeDist or inputView.Direction then
            inputView.UpDirection = { 0.0, 1.0, 0.0 }
        elseif inputView.XScale then
            inputView.UpDirection = SideViewParam[inputView.Camera].UpDirection
        end
    end
    inputView.FOV = inputView.FOV or Common.FOV
    inputView.YBias = inputView.YBias or 0.0
    inputView.XBias = inputView.XBias or 0.0
    inputView.CarOffset = inputView.CarOffset or { 0.0, 0.0, 0.0 }
    inputView.Formated = true
end

function RotateView(currentView, targetView, timeElaps, animateArgs)
    if currentView == nil then
        return table.Clone(targetView), true
    end
    local preAnimate = animateArgs.PreAnimate or 0
    local animateSec = animateArgs.Animate or 0
    --print("onRotate", FixViews[10].Yaw, currentView.Yaw)
    currentView.Yaw = currentView.Yaw + timeElaps * 16
    local animateView = table.Clone(currentView)
    return animateView, false
end

function ViewInterpolate(currentView, targetView, timeElaps, animateArgs)
    local preAnimate = animateArgs.PreAnimate or 0
    local animateSec = animateArgs.Animate or 0
    local animateView = table.Clone(currentView)
    targetView.FOV = targetView.FOV or Common.FOV
    currentView.FOV = currentView.FOV or Common.FOV
    animateArgs.animatingSec = animateArgs.animatingSec or 0
    if animateArgs.animatingSec <= (animateSec + preAnimate) then
        animateArgs.animatingSec = animateArgs.animatingSec + timeElaps
    end
    if animateArgs.animatingSec <= preAnimate then
        animateView.animating = true
        return animateView, false
    elseif animateArgs.animatingSec > preAnimate and animateArgs.animatingSec < (animateSec + preAnimate) then
        local percent = (animateArgs.animatingSec - preAnimate) / animateSec
        if animateArgs.SAccel then
            percent = SPercent(percent, animateSec > 2 and 2 or 1)
        end
        animateView.Yaw = (targetView.Yaw - currentView.Yaw) * percent + currentView.Yaw
        animateView.Pitch = (targetView.Pitch - currentView.Pitch) * percent + currentView.Pitch
        animateView.EyeDist = (targetView.EyeDist - currentView.EyeDist) * percent + currentView.EyeDist
        animateView.FOV = (targetView.FOV - currentView.FOV) * percent + currentView.FOV
        for i = 1, 3 do
            animateView.CenPos[i] = (targetView.CenPos[i] - currentView.CenPos[i]) * percent + currentView.CenPos[i]
            animateView.CarOffset[i] = (targetView.CarOffset[i] - currentView.CarOffset[i]) * percent + currentView.CarOffset[i]
        end
        animateView.animating = true
        return animateView, false
    else
        animateArgs.animatingSec = 0
        animateView = table.Clone(targetView)
        return animateView, true
    end
end

function EclipsView(currentView, targetView, timeElaps, animateArgs)
    local preAnimate = animateArgs.PreAnimate or 0
    local animateSec = animateArgs.Animate or 0
    local animateView = table.Clone(currentView)
    animateArgs.animatingSec = animateArgs.animatingSec or 0
    local xOffset = animateArgs.DistOffset
    if animateArgs.animatingSec <= (animateSec + preAnimate) then
        animateArgs.animatingSec = animateArgs.animatingSec + timeElaps
    end
    if animateArgs.animatingSec <= preAnimate then
        animateView.animating = true
        return animateView, false
    elseif animateArgs.animatingSec > preAnimate and animateArgs.animatingSec < (animateSec + preAnimate) then
        local percent = (animateArgs.animatingSec - preAnimate) / animateSec
        animateView.Yaw = (targetView.Yaw - currentView.Yaw) * percent + currentView.Yaw
        animateView.Pitch = (targetView.Pitch - currentView.Pitch) * percent + currentView.Pitch
        animateView.EyeDist = (targetView.EyeDist - currentView.EyeDist) * percent + currentView.EyeDist
        for i = 1, 3 do
            animateView.CenPos[i] = (targetView.CenPos[i] - currentView.CenPos[i]) * percent + currentView.CenPos[i]
            animateView.CarOffset[i] = (targetView.CarOffset[i] - currentView.CarOffset[i]) * percent + currentView.CarOffset[i]
        end
        local calYaw = math.rad(animateView.Yaw * 2 - 90)

        -- local bias =  (math.sin(math.sin(calYaw)) + math.cos(math.cos(calYaw) * 2)) * 600
        -- print("Bias ", animateView.Yaw, bias)
        -- animateView.CenPos[1] = animateView.CenPos[1] + bias

        animateView.CenPos[1] = animateView.CenPos[1] + (math.sin(calYaw) + 1.0) * xOffset
        animateView.animating = true
        return animateView, false
    else
        animateArgs.animatingSec = 0
        animateView = table.Clone(targetView)
        return animateView, true
    end
end

function DefaultViewInterpolate(currentView, targetView, timeElaps, animateArgs)
    if currentView == nil then
        return table.Clone(targetView), true
    end
    if currentView.EyeDist and targetView.EyeDist then
        return ViewInterpolate(currentView, targetView, timeElaps, animateArgs)
    end
    if currentView.Camera == targetView.Camera and (currentView.Direction and targetView.XScale or currentView.XScale and targetView.Direction) then
        return MeshBlend(currentView, targetView, timeElaps, animateArgs)
    end
    FormatView(currentView)
    FormatView(targetView)
    local preAnimate = animateArgs.PreAnimate or 0
    local animateSec = animateArgs.Animate or 0
    local defaultHeight = animateArgs.MinHeight or 3500
    local animateView = {
        CenPos = {},
        Position = {},
        CarOffset = {},
        UpDirection = {},
    }
    if animateArgs.animatingSec < (animateSec + preAnimate) then
        animateArgs.animatingSec = animateArgs.animatingSec + timeElaps
    end
    if currentView.ArcMove == nil and currentView.Direction and targetView.Direction then
        currentView.ArcMove = (currentView.Mirror ~= targetView.Mirror)
    end
    if animateArgs.animatingSec < preAnimate then
        animateView.animating = true
        return animateView, false
    elseif animateArgs.animatingSec >= preAnimate and animateArgs.animatingSec < (animateSec + preAnimate) then
        local percent = (animateArgs.animatingSec - preAnimate) / animateSec
        if animateArgs.SAccel then
            percent = SPercent(percent, animateSec > 2 and 2 or 1)
        end
        local p2 = percent ^ 1.25
        local pV = percent ^ 0.8
        local cenPercent = currentView.ArcMove and p2 or percent
        local posPercent = currentView.ArcMove and pV or percent
        local sinArc = math.sin(percent * math.pi * 2 - math.pi / 2.0) / 2.0 + 0.5
        if currentView.ArcMove then
            local defaultUp = { 0.0, 1.0, 0.0 }
            local currentHeight = Math_VectorGetLength({ currentView.Position[1] - currentView.CenPos[1], currentView.Position[2] - currentView.CenPos[2], currentView.Position[3] - currentView.CenPos[3] })
            local targetHeight = Math_VectorGetLength({ targetView.Position[1] - targetView.CenPos[1], targetView.Position[2] - targetView.CenPos[2], targetView.Position[3] - targetView.CenPos[3] })
            local middleHeight = (currentHeight + targetHeight) * 1.5
            local middlePosition = { 0.0, middleHeight, 0.0 }
            if percent > 0.5 then
                for i = 1, 3 do
                    animateView.CenPos[i] = targetView.CenPos[i] * (percent * 2.0 - 1.0)
                    animateView.Position[i] = (targetView.Position[i] - middlePosition[i]) * (percent * 2.0 - 1.0) + middlePosition[i]
                    animateView.CarOffset[i] = targetView.CarOffset[i] * (percent * 2.0 - 1.0)
                    animateView.UpDirection[i] = (targetView.UpDirection[i] - defaultUp[i]) * (percent * 2.0 - 1.0) + defaultUp[i]
                end
                animateView.Mirror = targetView.Mirror
            else
                for i = 1, 3 do
                    animateView.CenPos[i] = currentView.CenPos[i] * (1.0 - percent * 2.0)
                    animateView.Position[i] = (middlePosition[i] - currentView.Position[i]) * percent * 2.0 + currentView.Position[i]
                    animateView.CarOffset[i] = currentView.CarOffset[i] * (1.0 - percent * 2.0)
                    animateView.UpDirection[i] = (defaultUp[i] - currentView.UpDirection[i]) * percent * 2.0 + currentView.UpDirection[i]
                end
                animateView.Mirror = currentView.Mirror
            end
        else
            for i = 1, 3 do
                animateView.CenPos[i] = (targetView.CenPos[i] - currentView.CenPos[i]) * cenPercent + currentView.CenPos[i]
                animateView.Position[i] = (targetView.Position[i] - currentView.Position[i]) * posPercent + currentView.Position[i]
                animateView.CarOffset[i] = (targetView.CarOffset[i] - currentView.CarOffset[i]) * percent + currentView.CarOffset[i]
                animateView.UpDirection[i] = (targetView.UpDirection[i] - currentView.UpDirection[i]) * percent + currentView.UpDirection[i]
            end
            if (targetView.Camera and not currentView.Camera) or (not targetView.Camera and currentView.Camera) then
                local startNormal = Math_VectorGetNormalized(currentView.Position)
                local endNormal = Math_VectorGetNormalized(targetView.Position)
                local angle = Math_VectorGetAngle(startNormal, endNormal)
                local normal = Math_VectorGetNormalized(Math_VectorGetCross(startNormal, endNormal))
                local begintLen = Math_VectorGetLength(currentView.Position)
                local targetLen = Math_VectorGetLength(targetView.Position)
                local currentLength = (targetLen - begintLen) * percent + begintLen
                currentLength = currentLength * (1.0 - math.sin(math.pi * percent) * 0.25)
                local angleStep = angle * percent
                local vet = Math_VectorRotate(startNormal, angleStep, normal)
                animateView.Position = { vet[1] * currentLength, vet[2] * currentLength, vet[3] * currentLength }
            end
            if targetView.Camera and currentView.Camera then
                local targetHeight = defaultHeight - (targetView.Position[2] + currentView.Position[2]) * 0.5
                animateView.Position[2] = animateView.Position[2] + sinArc * targetHeight
            end
        end
        animateView.FOV = (targetView.FOV - currentView.FOV) * percent + currentView.FOV
        animateView.ZNear = targetView.ZNear or currentView.ZNear or Common.ZNear
        animateView.ZFar = targetView.ZFar or currentView.ZFar or Common.ZFar
        animateView.XBias = (targetView.XBias - currentView.XBias) * percent + currentView.XBias
        animateView.YBias = (targetView.YBias - currentView.YBias) * percent + currentView.YBias
        animateView.animating = true
        return animateView, false
    else
        animateArgs.animatingSec = 0
        animateView = table.Clone(targetView)
        return animateView, true
    end
end

function RotateStep(currentView, targetView, timeElaps, animateArgs)
    if currentView == nil then
        return table.Clone(targetView), true
    end
    local animateSec = animateArgs.Animate or 1
    local animateView = table.Clone(currentView)
    animateView.Yaw = animateView.Yaw + timeElaps / animateSec * 360
    return animateView, false
end

function WheelSingleView(currentView, targetView, timeElaps, animateArgs)
    local animateView = table.Clone(targetView)
    if animateView.Mirror then
        animateView.AngleBias = -StateModule:GetInputState("WheelAngle") * (75 / animateView.FOV)
    else
        animateView.AngleBias = StateModule:GetInputState("WheelAngle") * (75 / animateView.FOV)
    end
    return animateView, false
end

function MeshBlend(currentView, targetView, timeElaps, animateArgs)
    local animateSec = animateArgs.Animate or 0
    local animateView = table.Clone(currentView.XScale and targetView or currentView)
    animateArgs.animatingSec = animateArgs.animatingSec or 0
    if animateArgs.animatingSec <= animateSec then
        animateArgs.animatingSec = animateArgs.animatingSec + timeElaps
    end
    if animateArgs.animatingSec < animateSec then
        local percent = animateArgs.animatingSec / animateSec
        percent = SPercent(percent, animateSec > 2 and 2 or 1)
        animateView.MeshBlendFac = currentView.XScale and 1.0 - percent or percent
        return animateView, false
    else
        animateArgs.animatingSec = 0
        animateView = table.Clone(targetView)
        return animateView, true
    end
end

function SpeedInterpolate(currentView, targetView, timeElaps, animateArgs)
    local minSpeed = animateArgs.MinSpeed or 0
    local maxSpeed = animateArgs.MaxSpeed or 10
    local animateView = table.Clone(currentView)
    local speed = StateModule:GetInputState("Speed")

    if speed < minSpeed then
        speed = minSpeed
    elseif speed > maxSpeed then
        speed = maxSpeed
    end
    local percent = (speed - minSpeed) / (maxSpeed - minSpeed)
    animateView.Yaw = StateModule:GetInputState("WheelAngle") --(targetView.Yaw - currentView.Yaw) * percent + currentView.Yaw
    animateView.Pitch = (targetView.Pitch - currentView.Pitch) * percent + currentView.Pitch
    animateView.EyeDist = (targetView.EyeDist - currentView.EyeDist) * (percent ^ 0.5) + currentView.EyeDist
    for i = 1, 3 do
        animateView.CenPos[i] = (targetView.CenPos[i] - currentView.CenPos[i]) * percent + currentView.CenPos[i]
        animateView.CarOffset[i] = (targetView.CarOffset[i] - currentView.CarOffset[i]) * percent + currentView.CarOffset[i]
    end
    return animateView, false
end

FunctionNames[ViewJump] = "ViewJump"
FunctionNames[ViewInterpolate] = "ViewInterpolate"
FunctionNames[WheelSingleView] = "WheelSingleView"
FunctionNames[DefaultViewInterpolate] = "Default"
FunctionNames[RotateStep] = "RotateStep"


