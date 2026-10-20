SceneStudio = {
    RenderOrder = { "Background", "Stream", "Ring", "Mesh", "Geometry", "Mod", "Model", "Radar", "Text" },
    SampleOrder = { "Can", "Stream", "Ring" },

    FramingState = {
        targetSceneIndex = nil,
        currentSceneIndex = 0,
        lastSceneIndex = 0,
        totalSec = 0,
        TransformMatrix = nil,
        ProjectMatrix = nil,
    },
    currentViewParam = {},
    currentViewportParam = {},

    orthoMatrix = nil,
    transMatrix = nil,
    screenWidth = 0,
    screenHeight = 0,
}

function SceneStudio:OnInit()
    self.orthoMatrix = Math_CreateMatrix()
    self.transMatrix = Math_CreateMatrix()
    Math_MatrixIdentify(self.orthoMatrix)
    Math_MatrixOrtho(self.orthoMatrix, 0.0, 0.0, 1.0, 1.0)
    Math_MatrixIdentify(self.transMatrix)
    Math_MatrixTranslate(self.transMatrix, { 0.050, 0.93, 0.1 })
    Math_MatrixScale(self.transMatrix, { 0.03, 0.03, 1.0 })
    self.FramingState.TransformMatrix = Math_CreateMatrix()
    self.FramingState.ProjectMatrix = Math_CreateMatrix()
end

function SceneStudio:OnInitDone()
    self:UpdateCalibFile(Common.CalibFile)
end

function SceneStudio:OnUpdateScreenSize(screenW, screenH)
    self.screenWidth = screenW
    self.screenHeight = screenH
end

function SceneStudio:MatrixTransform(view)
    Math_MatrixTransform(view, self.FramingState.TransformMatrix, Common.ScreenRotation)
end

function SceneStudio:OnUpdateSetting(keyString)
    if string.find(keyString, "Rotate3DParam") then
        for i, v in ipairs(self.currentViewParam) do
            if self.currentViewParam[i].currentView and self.currentViewParam[i].currentView.Yaw and self.currentViewParam[i].currentView.Editable then
                self.currentViewParam[i].currentView = nil
            end
        end
    end
    if string.find(keyString, "Side3DParam") then
        for i, v in ipairs(self.currentViewParam) do
            if self.currentViewParam[i].currentView and self.currentViewParam[i].currentView.Yaw and self.currentViewParam[i].currentView.Editable then
                self.currentViewParam[i].currentView = nil
            end
        end
    end
    if string.find(keyString, "SideViewParam") then
        for i, v in ipairs(self.currentViewParam) do
            if self.currentViewParam[i].currentView and self.currentViewParam[i].currentView.XScale then
                self.currentViewParam[i].currentView = nil
            end
        end
    end
    if string.find(keyString, "SingleViewParam") then
        for i, v in ipairs(self.currentViewParam) do
            if self.currentViewParam[i].currentView and self.currentViewParam[i].currentView.Direction then
                self.currentViewParam[i].currentView = nil
                self.FramingState.targetSceneIndex = self.FramingState.currentSceneIndex
            end
        end
    end
    if string.find(keyString, "SideViewMode") or string.find(keyString, "FollowUp") then
        if type(DefineScene) == "function" then
            Scenes = DefineScene()
            for i, v in ipairs(self.currentViewParam) do
                self.currentViewParam[i].currentView = nil
            end
            self.FramingState.targetSceneIndex = self.FramingState.currentSceneIndex
        end
    end

end

function SceneStudio:UpdateSample(timeStamp)
    local moduleUpdate = {}
    for index, value in ipairs(self.SampleOrder) do
        if AllModules[value] and AllModules[value].OnUpdateSample then
            AllModules[value]:OnUpdateSample(timeStamp)
            moduleUpdate[value] = true
        end
    end
    for key, value in pairs(AllModules) do
        if moduleUpdate[key] == nil and value.OnUpdateSample then
            value:OnUpdateSample(timeStamp)
        end
    end
end

function SceneStudio:UpdateConfig()
    local moduleUpdate = {}
    for index, value in ipairs(InitOrder) do
        if AllModules[value] and AllModules[value].OnUpdateConfig then
            AllModules[value]:OnUpdateConfig()
            moduleUpdate[value] = true
        end
    end
    for key, value in pairs(AllModules) do
        if moduleUpdate[key] == nil and value.OnUpdateConfig then
            value:OnUpdateConfig()
        end
    end
end

function SceneStudio:UpdateCalibFile(calibConfig)
    if Scene_LoadCalib(calibConfig) then
        self:UpdateConfig()
    end
end

function SceneStudio:SelectScene(sceneIdx)
    if SceneState then
        self.FramingState.targetSceneIndex = SceneState:SelectScene(sceneIdx)
    else
        self.FramingState.targetSceneIndex = sceneIdx
    end
end

function SceneStudio:GetCurrentScene()
    return self.FramingState.currentSceneIndex
end

function SceneStudio:GetSceneLayout(sceneIdx)
    return sceneIdx and Scenes[sceneIdx] and Scenes[sceneIdx].Viewport or 1
end

function SceneStudio:CalculateMultiPart(fovY, viewport, parts)
    local centerRad = math.rad(fovY)
    local totalH = self.screenHeight * viewport[4]
    local totalW = self.screenWidth * viewport[3]
    local centerFocal = totalH / math.tan(centerRad / 2)
    local sideResult = {}
    local centerIndex = #parts / 2 + 0.5
    local edgeFocal2 = centerFocal * centerFocal
    local edgeBias = 0
    if #parts % 2 == 1 then
        sideResult[centerIndex] = { fovY, 0.0 }
        local centerW = totalW * parts[centerIndex]
        edgeFocal2 = edgeFocal2 + centerW * centerW
        edgeBias = math.atan(centerW / centerFocal)
    end
    local sideBias = -edgeBias
    for i = math.ceil(centerIndex - 1), 1, -1 do
        local sideW = parts[i] * totalW
        local sideFocal = math.sqrt(edgeFocal2 - sideW * sideW)
        local sideFov = math.deg(math.atan(totalH / sideFocal)) * 2
        sideBias = sideBias - math.atan(sideW / sideFocal)
        sideResult[i] = { sideFov, math.deg(sideBias) }
        sideBias = sideBias - math.atan(sideW / sideFocal)
    end
    sideBias = edgeBias
    for i = math.floor(centerIndex + 1), #parts do
        local sideW = parts[i] * totalW
        local sideFocal = math.sqrt(edgeFocal2 - sideW * sideW)
        local sideFov = math.deg(math.atan(totalH / sideFocal)) * 2
        sideBias = sideBias + math.atan(sideW / sideFocal)
        sideResult[i] = { sideFov, math.deg(sideBias) }
        sideBias = sideBias + math.atan(sideW / sideFocal)
    end
    return sideResult
end

function SceneStudio:Render3DViewport(viewport, sceneContent, currentView)
    if currentView == nil then
        return
    end
    if sceneContent.MultiPart and currentView.Direction then
        local startPos = sceneContent.MultiPart.Start * viewport[3] + viewport[1]
        local seperator = sceneContent.MultiPart.Seperator or 0.0
        if currentView.FOV then
            local partViews = self:CalculateMultiPart(currentView.FOV, viewport, sceneContent.MultiPart)
            local partView = table.Clone(currentView)
            partView.Tilt = partView.Pitch
            partView.Pitch = 0
            for i = 1, #partViews do
                partView.FOV = partViews[i][1]
                partView.AngleBias = partView.Mirror and -partViews[i][2] or partViews[i][2]
                local vp = { startPos, viewport[2], viewport[3] * sceneContent.MultiPart[i], viewport[4] }
                RenderFrame.SetViewport(vp[1], vp[2], vp[3], vp[4], Common.ScreenRotation)
                if Common.ScreenRotation == 90 or Common.ScreenRotation == -90 or Common.ScreenRotation == 270 then
                    Math_MatrixProject(vp[3] * self.screenHeight / (vp[4] * self.screenWidth), partView.ZNear or Common.ZNear, partView.ZFar or Common.ZFar, partView.FOV or Common.FOV, self.FramingState.ProjectMatrix, partView.XBias, partView.YBias, partView.AspectScale, Common.ScreenRotation)
                else
                    Math_MatrixProject(vp[3] * self.screenWidth / (vp[4] * self.screenHeight), partView.ZNear or Common.ZNear, partView.ZFar or Common.ZFar, partView.FOV or Common.FOV, self.FramingState.ProjectMatrix, partView.XBias, partView.YBias, partView.AspectScale)
                end
                self:MatrixTransform(partView)
                for index, moduleName in ipairs(self.RenderOrder) do
                    if AllModules[moduleName] and sceneContent[moduleName] and AllModules[moduleName].OnRender then
                        AllModules[moduleName]:OnRender(sceneContent[moduleName], partView, self.FramingState.ProjectMatrix, self.FramingState.TransformMatrix)
                    end
                end
                startPos = startPos + viewport[3] * (sceneContent.MultiPart[i] + seperator)
            end
        end
    else
        RenderFrame.SetViewport(viewport[1], viewport[2], viewport[3], viewport[4], Common.ScreenRotation)
        if Common.ScreenRotation == 90 or Common.ScreenRotation == -90 or Common.ScreenRotation == 270 then
            Math_MatrixProject(viewport[3] * self.screenHeight / (viewport[4] * self.screenWidth), currentView.ZNear or Common.ZNear, currentView.ZFar or Common.ZFar, currentView.FOV or Common.FOV, self.FramingState.ProjectMatrix, currentView.XBias, currentView.YBias, currentView.AspectScale, Common.ScreenRotation)
        else
            Math_MatrixProject(viewport[3] * self.screenWidth / (viewport[4] * self.screenHeight), currentView.ZNear or Common.ZNear, currentView.ZFar or Common.ZFar, currentView.FOV or Common.FOV, self.FramingState.ProjectMatrix, currentView.XBias, currentView.YBias, currentView.AspectScale)
        end
        self:MatrixTransform(currentView)
        for index, moduleName in ipairs(self.RenderOrder) do
            if AllModules[moduleName] and sceneContent[moduleName] and AllModules[moduleName].OnRender then
                AllModules[moduleName]:OnRender(sceneContent[moduleName], currentView, self.FramingState.ProjectMatrix, self.FramingState.TransformMatrix)
            end
        end
    end
end

function SceneStudio:Render2DViewport(viewport, sceneContent, transformParam)
    RenderFrame.SetViewport(viewport[1], viewport[2], viewport[3], viewport[4], Common.ScreenRotation)
    transformParam.Camera = sceneContent.SideView
    self:MatrixTransform(transformParam)
    for index, moduleName in ipairs(self.RenderOrder) do
        if AllModules[moduleName] and sceneContent[moduleName] and AllModules[moduleName].OnRender2D then
            AllModules[moduleName]:OnRender2D(sceneContent.SideView, sceneContent[moduleName], self.FramingState.TransformMatrix)
        end
    end
end

function SceneStudio:RenderSide(sideIndex)
    local localContent = { SideView = sideIndex,
                           Mesh = true,
                           Geometry = {},
    }
    --for key, value in pairs(GeometryParam) do
    --	if value then
    --		table.insert(localContent.Geometry, key)
    --	end
    --end
    local viewport = { 0, 0, 1, 1 }
    self:Render2DViewport(viewport, localContent, SideViewParam[sideIndex])
end

function SceneStudio:RenderSingle(singleIndex)
    local localContent = {
        Mesh = MeshModule:GetSingleMeshIndex(singleIndex),
        Geometry = {},
    }
    -- for key, value in pairs(GeometryParam) do
    -- if value then
    -- table.insert(localContent.Geometry, key)
    -- end
    -- end
    local viewport = { 0, 0, 1, 1 }
    self:Render3DViewport(viewport, localContent, SingleViewParam[singleIndex])
end

function SceneStudio:ShowCameraView(sideIndex)
    if AllModules["Mesh"] == nil then
        return
    end
    local localContent = {
        SideView = sideIndex,
        Mesh = true,
        TransParam = {
            Camera = sideIndex,
            Rotate = 0,
            XOffset = 0.0,
            XScale = 1.0,
            YOffset = 0.0,
            YScale = 1.0,
        },
    }
    RenderFrame.SetViewport(0, 0, 1, 1)
    self:MatrixTransform(localContent.TransParam)
    AllModules["Mesh"]:OnRender2D(sideIndex, false, self.FramingState.TransformMatrix)
end

function SceneStudio:RenderScene(frameSec)
    local sceneIndex = self.FramingState.targetSceneIndex or self.FramingState.currentSceneIndex
    -- return last scene rendered when there is no table to render the specific scene
    if Scenes[sceneIndex] == nil or Viewports[Scenes[sceneIndex].Viewport] == nil or Scenes[sceneIndex].Contents == nil then
        print("Have No Scene ", sceneIndex)
        self.FramingState.targetSceneIndex = nil
        sceneIndex = self.FramingState.currentSceneIndex
    end
    local originW, originH
    if EffectModule and #PostRenderPass > 0 then
        originW = self.screenWidth
        originH = self.screenHeight
        RenderFrame.SetScreenSize(EffectModule:GetFramebufferSize())
        EffectModule:RenderBegin()
    end

    self.FramingState.totalSec = self.FramingState.totalSec + frameSec

    local sceneSwitched = false
    local sameViewport = false
    -- when scene switched, we need to backup the current view status for view animate
    if self.FramingState.targetSceneIndex and not self.currentViewportParam.animating then
        if self.FramingState.targetSceneIndex == self.FramingState.currentSceneIndex then
            -- if it's the same scene to switch, just reset the scene render by dropping all the current status
            for i, v in ipairs(self.currentViewParam) do
                if v.animateDone then
                    -- when under animating, abort the reset
                    v = {}
                end
            end
        end
        -- param initialize
        self.currentViewportParam = {}
        self.FramingState.lastSceneIndex = self.FramingState.currentSceneIndex
        self.FramingState.currentSceneIndex = self.FramingState.targetSceneIndex
        self.FramingState.targetSceneIndex = nil
        -- check the viewport is different
        sameViewport = Scenes[self.FramingState.lastSceneIndex] and (Scenes[self.FramingState.lastSceneIndex].Viewport == Scenes[sceneIndex].Viewport)
        self.currentViewParam.sceneSwitchSec = 0
        sceneSwitched = true
    end
    -- clear the animating flag
    self.currentViewParam.animating = false
    self.currentViewportParam.animating = false
    -- then iterate the scene contents
    local curScene = Scenes[self.FramingState.currentSceneIndex]

    if curScene == nil then
        print("Has no current Scene ", self.FramingState.currentSceneIndex)
    end

    for i, v in ipairs(Viewports[curScene.Viewport]) do
        -- loop all the sub viewport
        local sceneContent = curScene.Contents[i]
        if sceneContent then
            local vp = v
            RenderFrame.SetScissor(v[1], v[2], v[3], v[4], Common.ScreenRotation)
            -- initialize string index of viewport animate table
            local vpAnimateIndex = "S" .. self.FramingState.lastSceneIndex .. "V" .. i .. "to" .. "S" .. self.FramingState.currentSceneIndex .. "V" .. i
            -- when switching to new scene, backup the last view param and content
            if sceneSwitched then
                self.currentViewParam[i] = self.currentViewParam[i] or {}
                -- only same viewport can process animating
                if sameViewport or ViewportAnimates[vpAnimateIndex] then
                    -- if it's same view port, possible animate
                    self.currentViewParam[i].lastViewParam = table.Clone(self.currentViewParam[i].currentView)
                    self.currentViewParam[i].lastContent = self.currentViewParam[i].contentToShow
                else
                    self.currentViewParam[i] = {}
                end
                self.currentViewParam[i].animateDone = true        --if scene switched, stop the current view-animating for ready to other animating
                self.currentViewParam[i].currentSceneViewIndex = 1
                self.currentViewParam[i].targetViewIndex = sceneContent.Views and sceneContent.Views[1] or (sceneContent.SideView and "S" .. sceneContent.SideView or 0)
            end
            -- auto generate viewport animate param
            if self.currentViewParam[i].lastViewParam and not ViewportAnimates[vpAnimateIndex] and self.currentViewParam[i].lastViewParam.Camera and (sceneContent.SideView or FixViews[self.currentViewParam[i].targetViewIndex] and FixViews[self.currentViewParam[i].targetViewIndex].Camera) then
                local lastCamera = self.currentViewParam[i].lastViewParam.Camera
                local targetCamera = sceneContent.SideView or FixViews[self.currentViewParam[i].targetViewIndex].Camera
                if lastCamera ~= targetCamera then
                    ViewportAnimates[vpAnimateIndex] = GenerateViewportAnimateParam(targetCamera, vp)
                end
            end
            -- if there is viewport animation to do, calculate the last view to show last scene contant and modify vp to affert current scene rendering
            if ViewportAnimates[vpAnimateIndex] and (not self.currentViewportParam[i] or not self.currentViewportParam[i].animateDone) then
                -- initialize time recorder
                if self.currentViewportParam[i] == nil then
                    -- initialize viewport animating param
                    self.currentViewportParam[i] = table.Clone(ViewportAnimates[vpAnimateIndex])
                    self.currentViewportParam[i].animatingSec = 0
                end
                -- get animate function
                local vpFunc = ViewportAnimates[vpAnimateIndex].Move or ViewportJump
                -- calculate the two viewports
                local lastVp = {}
                lastVp, vp, self.currentViewportParam[i].animateDone = vpFunc(vp, frameSec, self.currentViewportParam[i])
                self.currentViewportParam.animating = not self.currentViewportParam[i].animateDone or self.currentViewportParam.animating
                -- then render the last scene contant in lasting viewport
                if not self.currentViewportParam[i].animateDone then
                    if Scenes[self.FramingState.lastSceneIndex].Contents[i] then
                        if Scenes[self.FramingState.lastSceneIndex].Contents[i].SideView and self.currentViewParam[i].lastViewParam.XScale then
                            self:Render2DViewport(lastVp, Scenes[self.FramingState.lastSceneIndex].Contents[i], self.currentViewParam[i].lastViewParam)
                        else
                            self:Render3DViewport(lastVp, self.currentViewParam[i].lastContent, self.currentViewParam[i].lastViewParam)
                        end
                    end
                else
                    -- when view port animating is done, backup the currentView to lastView for next view animation
                    self.currentViewParam[i].lastViewParam = table.Clone(self.currentViewParam[i].currentView)
                end
            end

            if sceneSwitched then
                -- if it's a view port animation, abort the view animating between scenes, and set the current view to new scene view[1]
                if self.currentViewportParam[i] and not self.currentViewportParam[i].animateDone then
                    if FixViews[self.currentViewParam[i].targetViewIndex] then
                        if sceneContent.Views[2] and ViewAnimates["V" .. self.currentViewParam[i].targetViewIndex .. "to" .. sceneContent.Views[2]] then
                            local targetParam = table.Clone(ViewAnimates["V" .. self.currentViewParam[i].targetViewIndex .. "to" .. sceneContent.Views[2]])
                            local targetFunc = targetParam.Move
                            self.currentViewParam[i].currentView = targetFunc(table.Clone(FixViews[self.currentViewParam[i].targetViewIndex]), table.Clone(FixViews[sceneContent.Views[2]]), frameSec, targetParam)
                        else
                            self.currentViewParam[i].currentView = table.Clone(FixViews[self.currentViewParam[i].targetViewIndex])
                        end
                    else
                        self.currentViewParam[i].currentView = table.Clone(sceneContent.TransParam or SideViewParam[sceneContent.SideView])
                    end
                    self.currentViewParam[i].currentViewIndex = self.currentViewParam[i].targetViewIndex
                    self.currentViewParam[i].currentSceneViewIndex = 2
                    self.currentViewParam[i].targetViewIndex = sceneContent.Views and sceneContent.Views[self.currentViewParam[i].currentSceneViewIndex]
                end
                -- if is same camera to animate, abort the animation
                if self.currentViewParam[i].currentView and self.currentViewParam[i].lastContent then
                    -- if switched between side view and signle view
                    if sceneContent.SideView and not self.currentViewParam[i].lastContent.SideView or not sceneContent.SideView and self.currentViewParam[i].lastContent.SideView then
                    else
                        if self.currentViewParam[i].currentView.Camera and self.currentViewParam[i].currentView.Camera == sceneContent.SideView then
                            self.currentViewParam[i].animateDone = true
                            self.currentViewParam[i].currentView = table.Clone(sceneContent.TransParam or SideViewParam[sceneContent.SideView])
                            self.currentViewParam[i].targetViewIndex = nil
                        end
                    end
                end
            end

            self.currentViewParam[i].contentToShow = sceneContent
            -- if is a view to animate-to or is under animating, perform the animating
            if self.currentViewParam[i].targetViewIndex and (not self.currentViewportParam[i] or self.currentViewportParam[i].animateDone) then
                local curViewIdx = self.currentViewParam[i].currentViewIndex or 0
                local dstViewIdx = self.currentViewParam[i].targetViewIndex
                -- perform the animate
                local vaStringIndex = "V" .. curViewIdx .. "to" .. dstViewIdx
                -- if animate is done from last frame, load the new animate param and target view
                if self.currentViewParam[i].animateDone then
                    self.currentViewParam[i].animatingParam = (ViewAnimates[vaStringIndex] and table.Clone(ViewAnimates[vaStringIndex])) or table.Clone(DefaultAnimate.AnimateParam)
                    self.currentViewParam[i].animatingParam.animatingSec = 0
                    if FixViews[dstViewIdx] then
                        -- if target scene has animation to it's View[2], we should perform the animate to get a animated view as a target view
                        if sceneSwitched and sceneContent.Views[2] and ViewAnimates["V" .. dstViewIdx .. "to" .. sceneContent.Views[2]] then
                            local targetParam = table.Clone(ViewAnimates["V" .. dstViewIdx .. "to" .. sceneContent.Views[2]])
                            local targetFunc = targetParam.Move
                            self.currentViewParam[i].targetView = targetFunc(table.Clone(FixViews[dstViewIdx]), table.Clone(FixViews[sceneContent.Views[2]]), frameSec, targetParam)
                        else
                            self.currentViewParam[i].targetView = table.Clone(FixViews[dstViewIdx])
                        end
                    else
                        self.currentViewParam[i].targetView = table.Clone(sceneContent.TransParam or SideViewParam[sceneContent.SideView])
                        if sceneContent.SideView then
                            self.currentViewParam[i].targetView.Camera = sceneContent.SideView
                        end
                    end
                end
                local animateFunc = (ViewAnimates[vaStringIndex] and ViewAnimates[vaStringIndex].Move) or DefaultViewInterpolate    --use default view animate
                -- perform the view blending
                self.currentViewParam[i].currentView, self.currentViewParam[i].animateDone = animateFunc(self.currentViewParam[i].lastViewParam, self.currentViewParam[i].targetView, frameSec, self.currentViewParam[i].animatingParam)
                -- use the most full content for better graphic
                if not self.currentViewParam[i].animateDone then
                    if self.currentViewParam[i].lastViewParam and self.currentViewParam[i].lastViewParam.EyeDist and not self.currentViewParam[i].targetView.EyeDist then
                        self.currentViewParam[i].contentToShow = self.currentViewParam[i].lastContent
                    elseif self.currentViewParam[i].lastViewParam and not self.currentViewParam[i].lastViewParam.EyeDist and not self.currentViewParam[i].targetView.EyeDist then
                        if not ViewAnimates[vaStringIndex] then
                            -- if it's a setted animation for the camera view, just use the origin view
                            self.currentViewParam[i].contentToShow = DefaultAnimate.Content
                        end
                    end
                end
                -- if finish the current animation, make ready to next animation
                if self.currentViewParam[i].animateDone then
                    self.currentViewParam[i].currentSceneViewIndex = self.currentViewParam[i].currentSceneViewIndex + 1    -- increase index to access Scene.Contents.Views
                    self.currentViewParam[i].currentViewIndex = self.currentViewParam[i].targetViewIndex
                    self.currentViewParam[i].targetViewIndex = sceneContent.Views and sceneContent.Views[self.currentViewParam[i].currentSceneViewIndex]
                    self.currentViewParam[i].lastViewParam = table.Clone(self.currentViewParam[i].currentView)
                    if FixViews[dstViewIdx] then
                        -- if it's a next animation, use the current view but not target view
                        if self.currentViewParam[i].currentSceneViewIndex == 2 and self.currentViewParam[i].targetViewIndex and ViewAnimates["V" .. dstViewIdx .. "to" .. self.currentViewParam[i].targetViewIndex] then
                        else
                            self.currentViewParam[i].currentView = table.Clone(FixViews[dstViewIdx])
                        end
                    else
                        self.currentViewParam[i].currentView = table.Clone(sceneContent.TransParam or SideViewParam[sceneContent.SideView])
                    end
                end
            end
            self.currentViewParam.animating = self.currentViewParam[i].targetViewIndex or self.currentViewParam.animating

            if sceneContent.SideView and self.currentViewParam[i].animateDone then
                self.currentViewParam[i].targetViewIndex = nil
                if self.currentViewParam[i].currentView == nil or self.currentViewParam[i].currentView.XScale == nil then
                    self.currentViewParam[i].currentView = sceneContent.TransParam or SideViewParam[sceneContent.SideView]
                end
                self:Render2DViewport(vp, sceneContent, self.currentViewParam[i].currentView)
            else
                if self.currentViewParam[i].currentView == nil then
                    self.currentViewParam[i].currentView = sceneContent.TransParam or FixViews[dstViewIdx]
                end
                -- finally render the mesh
                self:Render3DViewport(vp, self.currentViewParam[i].contentToShow, self.currentViewParam[i].currentView)
            end
        else
            -- else if sceneContent
            if self.currentViewParam[i] then
                self.currentViewParam[i].currentView = nil
            end
        end -- end if sceneContent
    end
    -- if done all the animating and there is a next scene to switch,
    if not self.currentViewportParam.animating and not self.currentViewParam.animating and curScene.NextScene then
        self.currentViewParam.sceneSwitchSec = self.currentViewParam.sceneSwitchSec + frameSec
        if self.currentViewParam.sceneSwitchSec > (curScene.SecToNext or 0) then
            if curScene.NextScene == self.FramingState.currentSceneIndex then
                self.FramingState.currentSceneIndex = 0
            end
            self.FramingState.targetSceneIndex = curScene.NextScene
        end
    end

    if EffectModule and #PostRenderPass > 0 then
        RenderFrame.SetScreenSize(originW, originH)
        EffectModule:RenderEnd(originW, originH)
    end
    return sceneIndex
end

function SceneStudio:RenderSimpleScene(sceneIndex)
    local originW, originH
    if EffectModule then
        originW = self.screenWidth
        originH = self.screenHeight
        RenderFrame.SetScreenSize(EffectModule:GetFramebufferSize())
        EffectModule:RenderBegin()
    end

    -- then iterate the scene contents
    local curScene = Scenes[sceneIndex]
    for i, v in ipairs(Viewports[curScene.Viewport]) do
        -- loop all the sub viewport
        local sceneContent = curScene.Contents[i]
        if sceneContent then
            local vp = v
            RenderFrame.SetScissor(v[1], v[2], v[3], v[4])
            if sceneContent.SideView then
                local sideView = sceneContent.TransParam or SideViewParam[sceneContent.SideView]
                self:Render2DViewport(vp, sceneContent, sideView)
            else
                local currentView = sceneContent.TransParam or FixViews[sceneContent.Views[1]]
                -- finally render the mesh
                self:Render3DViewport(vp, sceneContent, currentView)
            end
        end -- end if sceneContent
    end

    if EffectModule then
        RenderFrame.SetScreenSize(originW, originH)
        EffectModule:RenderEnd(originW, originH)
    end
    RenderFrame.SetViewport(0, 0, 1, 1, Common.ScreenRotation)
    RenderFrame.SetScissor(0, 0, 1, 1, Common.ScreenRotation)
    TextModule:RenderString(os.date("%Y-%m-%d %H:%M:%S"), self.orthoMatrix, self.transMatrix)
end

function SceneStudio:ScaleView(startPos, scale)
    local curScene = Scenes[self.FramingState.currentSceneIndex]
    local vpIdx = nil
    for i, v in ipairs(Viewports[curScene.Viewport]) do
        local vpRect = { v[1], v[2], v[1] + v[3], v[2] + v[4] }
        if startPos[1] < vpRect[3] and startPos[1] > vpRect[1] and startPos[2] < vpRect[4] and startPos[2] > vpRect[2] then
            if not ViewportControl or not ViewportControl[curScene.Viewport] or ViewportControl[curScene.Viewport] and ViewportControl[curScene.Viewport][i].Scale then
                vpIdx = i
            end
            break
        end
    end
    if vpIdx then
        if not self.currentViewParam[vpIdx].currentView.viewEdited then
            self.currentViewParam[vpIdx].currentView.viewEdited = true
            self.currentViewParam[vpIdx].originView = table.Clone(self.currentViewParam[vpIdx].currentView)
        end
        if curScene.Contents[vpIdx].SideView then
            if math.abs(self.currentViewParam[vpIdx].currentView.XScale) > 1.0 and scale < 0.0 or math.abs(self.currentViewParam[vpIdx].currentView.XScale) < 2.0 and scale > 0.0 then
                if self.currentViewParam[vpIdx].currentView.XScale < 0.0 then
                    self.currentViewParam[vpIdx].currentView.XScale = self.currentViewParam[vpIdx].currentView.XScale - scale * 0.05
                else
                    self.currentViewParam[vpIdx].currentView.XScale = self.currentViewParam[vpIdx].currentView.XScale + scale * 0.05
                end
            end
            if math.abs(self.currentViewParam[vpIdx].currentView.YScale) > 1.0 and scale < 0.0 or math.abs(self.currentViewParam[vpIdx].currentView.YScale) < 2.0 and scale > 0.0 then
                if self.currentViewParam[vpIdx].currentView.YScale < 0.0 then
                    self.currentViewParam[vpIdx].currentView.YScale = self.currentViewParam[vpIdx].currentView.YScale - scale * 0.05
                else
                    self.currentViewParam[vpIdx].currentView.YScale = self.currentViewParam[vpIdx].currentView.YScale + scale * 0.05
                end
            end
        elseif self.currentViewParam[vpIdx].currentView.EyeDist then
            local newValue = self.currentViewParam[vpIdx].currentView.EyeDist - scale * 200
            if newValue < self.currentViewParam[vpIdx].originView.EyeDist * 1.5 and newValue > self.currentViewParam[vpIdx].originView.EyeDist * 0.5 then
                self.currentViewParam[vpIdx].currentView.EyeDist = newValue
            end
        elseif self.currentViewParam[vpIdx].currentView.Direction then
            local newFov = self.currentViewParam[vpIdx].currentView.FOV - scale
            if newFov > 45 and newFov < 135 then
                self.currentViewParam[vpIdx].currentView.FOV = newFov
            end
        end
        if self.currentViewParam[vpIdx].targetViewIndex then
            self.currentViewParam[vpIdx].targetViewIndex = nil
        end
    end
end

function SceneStudio:DragView(startPos, dragDist)
    local curScene = Scenes[self.FramingState.currentSceneIndex]
    local vpIdx = nil
    for i, v in ipairs(Viewports[curScene.Viewport]) do
        local vpRect = { v[1], v[2], v[1] + v[3], v[2] + v[4] }
        if startPos[1] < vpRect[3] and startPos[1] > vpRect[1] and startPos[2] < vpRect[4] and startPos[2] > vpRect[2] then
            if not ViewportControl or not ViewportControl[curScene.Viewport] or ViewportControl[curScene.Viewport] and ViewportControl[curScene.Viewport][i].Drag then
                vpIdx = i
            end
            break
        end
    end
    if vpIdx then
        -- if self.currentViewParam[vpIdx].currentView.Position then
        -- return
        -- else
        if self.currentViewParam[vpIdx].currentView.EyeDist then
            if self.currentViewParam[vpIdx].currentView.Mirror then
                dragDist[1] = -dragDist[1]
            end
            self.currentViewParam[vpIdx].currentView.Yaw = self.currentViewParam[vpIdx].currentView.Yaw + dragDist[1] * 360
            if self.currentViewParam[vpIdx].currentView.Yaw >= 360 then
                self.currentViewParam[vpIdx].currentView.Yaw = self.currentViewParam[vpIdx].currentView.Yaw - 360
            end
            if self.currentViewParam[vpIdx].currentView.Yaw <= -360 then
                self.currentViewParam[vpIdx].currentView.Yaw = self.currentViewParam[vpIdx].currentView.Yaw + 360
            end
            --local pitchMax = math.abs(math.sin(math.rad(self.currentViewParam[vpIdx].currentView.Yaw))) * 25
            local pitchMax = 25
            self.currentViewParam[vpIdx].currentView.Pitch = self.currentViewParam[vpIdx].currentView.Pitch + dragDist[2] * 90
            if self.currentViewParam[vpIdx].currentView.Pitch < pitchMax then
                self.currentViewParam[vpIdx].currentView.Pitch = pitchMax
            end
            if self.currentViewParam[vpIdx].currentView.Pitch > 90 then
                self.currentViewParam[vpIdx].currentView.Pitch = 90
            end
        elseif self.currentViewParam[vpIdx].currentView.Direction then
            if self.currentViewParam[vpIdx].currentView.Mirror then
                self.currentViewParam[vpIdx].currentView.AngleBias = self.currentViewParam[vpIdx].currentView.AngleBias + dragDist[1] * 90
            else
                self.currentViewParam[vpIdx].currentView.AngleBias = self.currentViewParam[vpIdx].currentView.AngleBias - dragDist[1] * 90
            end
            self.currentViewParam[vpIdx].currentView.Pitch = self.currentViewParam[vpIdx].currentView.Pitch + dragDist[2] * 30
            if self.currentViewParam[vpIdx].currentView.Pitch < -50 then
                self.currentViewParam[vpIdx].currentView.Pitch = -50
            end
            if self.currentViewParam[vpIdx].currentView.Pitch > 60 then
                self.currentViewParam[vpIdx].currentView.Pitch = 60
            end
            if self.currentViewParam[vpIdx].currentView.AngleBias > 90 then
                self.currentViewParam[vpIdx].currentView.AngleBias = 90
            end
            if self.currentViewParam[vpIdx].currentView.AngleBias < -90 then
                self.currentViewParam[vpIdx].currentView.AngleBias = -90
            end
        elseif self.currentViewParam[vpIdx].currentView.XScale then
            local xMax = math.abs(self.currentViewParam[vpIdx].currentView.XScale) - 1.0
            local yMax = self.currentViewParam[vpIdx].currentView.YScale - 1.0
            local cosRot = math.cos(math.rad(self.currentViewParam[vpIdx].currentView.Rotate))
            local sinRot = math.sin(math.rad(self.currentViewParam[vpIdx].currentView.Rotate))
            local rotDist = { dragDist[1], dragDist[2] }
            rotDist[1] = dragDist[1] * cosRot - dragDist[2] * sinRot
            rotDist[2] = dragDist[1] * sinRot + dragDist[2] * cosRot
            self.currentViewParam[vpIdx].currentView.XOffset = self.currentViewParam[vpIdx].currentView.XOffset - rotDist[1] * xMax * 5
            self.currentViewParam[vpIdx].currentView.YOffset = self.currentViewParam[vpIdx].currentView.YOffset - rotDist[2] * yMax * 5
            if self.currentViewParam[vpIdx].currentView.XOffset < -xMax then
                self.currentViewParam[vpIdx].currentView.XOffset = -xMax
            end
            if self.currentViewParam[vpIdx].currentView.XOffset > xMax then
                self.currentViewParam[vpIdx].currentView.XOffset = xMax
            end
            if self.currentViewParam[vpIdx].currentView.YOffset < -yMax then
                self.currentViewParam[vpIdx].currentView.YOffset = -yMax
            end
            if self.currentViewParam[vpIdx].currentView.YOffset > yMax then
                self.currentViewParam[vpIdx].currentView.YOffset = yMax
            end
        end
        if self.currentViewParam[vpIdx].targetViewIndex then
            self.currentViewParam[vpIdx].targetViewIndex = nil
        end
    end
end

function SceneStudio:MoveView(startPos, dragDist)
    local curScene = Scenes[self.FramingState.currentSceneIndex]
    local vpIdx = nil
    for i, v in ipairs(Viewports[curScene.Viewport]) do
        local vpRect = { v[1], v[2], v[1] + v[3], v[2] + v[4] }
        if startPos[1] < vpRect[3] and startPos[1] > vpRect[1] and startPos[2] < vpRect[4] and startPos[2] > vpRect[2] then
            if not ViewportControl or not ViewportControl[curScene.Viewport] or ViewportControl[curScene.Viewport] and ViewportControl[curScene.Viewport][i].Drag then
                vpIdx = i
            end
            break
        end
    end
    if vpIdx then

        if self.currentViewParam[vpIdx].currentView.EyeDist then
            if self.currentViewParam[vpIdx].currentView.Mirror then
                dragDist[1] = -dragDist[1]
            end
            self.currentViewParam[vpIdx].currentView.CenPos[3] = self.currentViewParam[vpIdx].currentView.CenPos[3] - dragDist[1] * 1000
            self.currentViewParam[vpIdx].currentView.CenPos[2] = self.currentViewParam[vpIdx].currentView.CenPos[2] - dragDist[2] * 1000
        elseif self.currentViewParam[vpIdx].currentView.Direction then
            self.currentViewParam[vpIdx].currentView.XBias = self.currentViewParam[vpIdx].currentView.XBias - dragDist[1]
            self.currentViewParam[vpIdx].currentView.YBias = self.currentViewParam[vpIdx].currentView.YBias - dragDist[2]
        elseif self.currentViewParam[vpIdx].currentView.XScale then
            self.currentViewParam[vpIdx].currentView.Rotate = self.currentViewParam[vpIdx].currentView.Rotate + dragDist[1] * 100
        end
        if self.currentViewParam[vpIdx].targetViewIndex then
            self.currentViewParam[vpIdx].targetViewIndex = nil
        end
    end
end

function SceneStudio:SaveFrameState(fileToSave)
    io.output(fileToSave)
    io.write("self.FramingState.currentSceneIndex = ", self.FramingState.currentSceneIndex, "\n\n")
    table.Serialize(self.currentViewParam, "self.currentViewParam = ", 0)
    io.flush()
    io.close()
    io.output(io.stdout)
end

function SceneStudio:LoadFrameState(fileToLoad)
    dofile(fileToLoad)
end

function SceneStudio:OnBackup()
    LastSceneIndex = self.FramingState.currentSceneIndex
end

function SceneStudio:OnRestore()
    if LastSceneIndex then
        self:SelectScene(LastSceneIndex)
        LastSceneIndex = nil
    end
end

AllModules["SceneStudio"] = SceneStudio
