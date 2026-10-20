MeshModule = {
    meshCore = nil, -- C++ instance for mesh logic
    defaultMesh = 0,
    singleMesh = {},
    MeshInstances = {},
}

function MeshModule:OnDayChanged(value)
    if value == 2 then
        Mesh_EnableRedScale(true)
    elseif value == 1 then
        Mesh_EnableRedScale(false)
    end
end

function MeshModule:OnInit()
    self.meshCore = Mesh_CreateModule(Common.ShaderPath)
    Mesh_UpdateVideoParam(VideoParameters)
    StateModule:AttachNotifier("DayTimeFlag", self, MeshModule.OnDayChanged)
end

function MeshModule:GenerateMesh(meshparam, ignoreExtra)
    local MeshGenerators = {
        Circle = Mesh_GenerateCircle,
        Rectangle = Mesh_GenerateRectangle,
        Sphere = Mesh_GenerateSphere,
        Plane = Mesh_GeneratePlane
    }
    local extraData = ignoreExtra and {} or CalibExtra
    if type(MeshGenerators[meshparam.Generator]) == "function" then
        return MeshGenerators[meshparam.Generator](meshparam, extraData)
    end
end

function MeshModule:RenderMeshInst(meshInst, projMatrix, transformMatrix)
    Mesh_RenderMesh(meshInst, projMatrix, transformMatrix)
end

function MeshModule:RebuildMesh()
    self.defaultMesh = 0
    self.singleMesh = {}
    for i, v in pairs(MeshParams) do
        if v.Generator == "Circle" and v.HeightSmooth >= 0.0 then
            self.defaultMesh = i
        end
        if v.Generator == "Sphere" then
            self.singleMesh[v.CameraIndex] = i
        end
        self.MeshInstances[i] = MeshModule:GenerateMesh(v)
    end
end

function MeshModule:OnUpdateConfig()
    Mesh_UpdateConfig()
    self:RebuildMesh()
end

function MeshModule:OnUpdateSetting(keyString)
    if string.find(keyString, "MeshParams") then
        local index = tonumber(string.match(keyString, "%d"))
        if index then
            self.MeshInstances[index] = MeshModule:GenerateMesh(MeshParams[index])
        end
    end
    if string.find(keyString, "CalibExtra") then
        self:RebuildMesh()
    end
    if string.find(keyString, "Common.BorderBlur") then
        MeshParams = getMeshParams()
        self:RebuildMesh()
    end
    if string.find(keyString, "VideoParameters") then
        Mesh_UpdateVideoParam(VideoParameters)
    end

end

function MeshModule:OnUpdateSample()
    if Common.MeshBalance then
        Mesh_UpdateSample()
    end
end

function MeshModule:OnRender(sceneContent, currentView, projMatrix, transformMatrix)
    if sceneContent == 0 then
        sceneContent = self.defaultMesh
    end
    MeshModule:RenderMeshInst(self.MeshInstances[sceneContent], projMatrix, transformMatrix)
end

function MeshModule:OnRender2D(cameraIndex, sceneContent, transformMatrix)
    Mesh_RenderSide(cameraIndex, transformMatrix, sceneContent and true or false)
end

function MeshModule:GetSingleMeshIndex(singleIndex)
    return self.singleMesh[singleIndex]
end

AllModules["Mesh"] = MeshModule


