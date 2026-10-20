
MeshModule = 
{
	meshCore = nil,		-- C++ instance for mesh logic
	defaultMesh = 0,
	singleMesh = {},
	MeshInstances = {},
	sideMatrix = nil,
}

function MeshModule:OnDayChanged(value)
	if value == 2 then
		Mesh_EnableRedScale(true)
	elseif value == 1 then
		Mesh_EnableRedScale(false)
	end
end

function MeshModule:OnInit()
	self.meshCore = Hexa_CreateModule(Common.ShaderPath)
	self.sideMatrix = Math_CreateMatrix()
	Mesh_UpdateVideoParam(VideoParameters)
	StateModule:AttachNotifier("DayTimeFlag", self, MeshModule.OnDayChanged)
end

function MeshModule:GenerateMesh(meshparam, ignoreExtra)
	local MeshGenerators = 
	{
		Circle = Hexa_GenerateCircle,
		Sphere = Mesh_GenerateSphere,
		Dome = Mesh_GenerateDome,
	}
	local extraData = ignoreExtra and {} or CalibExtra
	if type(MeshGenerators[meshparam.Generator]) == "function" then
		return MeshGenerators[meshparam.Generator](meshparam, extraData)
	end
end

function MeshModule:RenderMeshInst(meshInst, projMatrix, transformMatrix)
	Hexa_RenderMesh(meshInst, projMatrix, transformMatrix)
end

function MeshModule:RebuildMesh()
	self.defaultMesh = 0
	self.singleMesh = {}
	for i, v in pairs(MeshParams) do
		if v.Generator == "Circle" and v.HeightSmooth >= 0.0 then
			self.defaultMesh = i
		end
		if v.Generator == "Sphere" or v.Generator == "Dome" then
			self.singleMesh[v.CameraIndex] = i
		end
		self.MeshInstances[i] = MeshModule:GenerateMesh(v)
	end
	collectgarbage()
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
	if string.find(keyString, "VideoParameters") then
		Mesh_UpdateVideoParam(VideoParameters)
	end
end

function MeshModule:OnUpdateSample()
	Mesh_UpdateSample()
end

function MeshModule:OnRender(sceneContent, currentView, projMatrix, transformMatrix)
	if sceneContent == 0 then
		sceneContent = self.defaultMesh
	end
	if currentView.Camera and currentView.MeshBlendFac then
		sceneContent = self.singleMesh[currentView.Camera]
		Math_MatrixTransform(SideViewParam[currentView.Camera], self.sideMatrix, Common.ScreenRotation)
		Mesh_RenderBlendSide(self.MeshInstances[sceneContent], projMatrix, transformMatrix, currentView.Camera, self.sideMatrix, currentView.MeshBlendFac)
	else
		MeshModule:RenderMeshInst(self.MeshInstances[sceneContent], projMatrix, transformMatrix)
	end
end

function MeshModule:OnRender2D(cameraIndex, sceneContent, transformMatrix)
	Mesh_RenderSide(cameraIndex, transformMatrix, type(sceneContent) == "table" and sceneContent.Mapped or true)
end

function MeshModule:GetSingleMeshIndex(singleIndex)
	return self.singleMesh[singleIndex]
end

AllModules["Mesh"] = MeshModule