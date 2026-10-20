SceneDefine = 
{
	SCENE_START = 1,
	SCENE_FRONT = 2,
	SCENE_RIGHT = 3,
	SCENE_LEFT = 5,
	SCENE_REAR = 7,
	SCENE_FLASH = 9,
	SCENE_REAR_RIGHT = 17,
	SCENE_REAR_LEFT = 27,

	SCENE_HI_FRONT = 32,
	SCENE_ZERO_RIGHT = 23,
	SCENE_ZERO_LEFT = 25,
	SCENE_HI_RIGHT = 33,
	SCENE_HI_LEFT = 35,
	SCENE_HI_FLASH = 39,
	
	SCENE_FLOATING = 28,
	SCENE_FLOATING_HIGH = 38,
}

SceneState = 
{
}

function SceneState:OnDowStateChanged(value, side)
	-- if value == true then
		-- if side == "Left" then
			-- SceneStudio:SelectScene(SceneDefine.SCENE_DOW_LEFT)
		-- end
		-- if side == "Right" then
			-- SceneStudio:SelectScene(SceneDefine.SCENE_DOW_RIGHT)			
		-- end
	-- end
end

function SceneState:OnBsdStateChanged(value, side)
	-- if value == true then
		-- if side == "Left" then
			-- SceneStudio:SelectScene(SceneDefine.SCENE_BSD_LEFT)
		-- end
		-- if side == "Right" then
			-- SceneStudio:SelectScene(SceneDefine.SCENE_BSD_RIGHT)			
		-- end
	-- end
end

function SceneState:OnInit()
	StateModule:AttachNotifier("Speed", self, self.OnSpeedChanged)
end

function SceneState:OnUpdateSetting(keyString)
	if string.find(keyString, "SceneStateParam.FrontSwitch") then
			SceneStudio:SelectScene(SceneDefine.SCENE_FRONT)
	end
end

function SceneState:OnSpeedChanged(value)
	if SceneStateParam.FrontSwitch then
		local curentScene = SceneStudio:GetCurrentScene()
		if curentScene == SceneDefine.SCENE_FRONT and value > SceneStateParam.HiSpeed or curentScene == SceneDefine.SCENE_HI_FRONT and value < SceneStateParam.HiSpeed - SceneStateParam.DiveZone then
			SceneStudio:SelectScene(SceneDefine.SCENE_FRONT)
		end
		if curentScene == SceneDefine.SCENE_FLOATING and value > SceneStateParam.HiSpeed or curentScene == SceneDefine.SCENE_FLOATING_HIGH and value < SceneStateParam.HiSpeed - SceneStateParam.DiveZone then
			SceneStudio:SelectScene(SceneDefine.SCENE_FLOATING)
		end
	end

end

function SceneState:SelectScene(sceneIndex)
	local newIndex = sceneIndex
	if SceneStateParam.FrontSwitch then
		if sceneIndex == SceneDefine.SCENE_FRONT then
			if StateModule:GetInputState("Speed") > SceneStateParam.HiSpeed and Scenes[SceneDefine.SCENE_HI_FRONT] then
				newIndex = SceneDefine.SCENE_HI_FRONT
			end
		end
		if sceneIndex == SceneDefine.SCENE_FLOATING then
			if StateModule:GetInputState("Speed") > SceneStateParam.HiSpeed and Scenes[SceneDefine.SCENE_HI_FRONT] then
				newIndex = SceneDefine.SCENE_FLOATING_HIGH
			end
		end
	end
	if SceneStateParam.LeftRightSwitch then
		if sceneIndex == SceneDefine.SCENE_RIGHT then
			if StateModule:GetInputState("Speed") > SceneStateParam.HiSpeed and Scenes[SceneDefine.SCENE_HI_RIGHT] then
				newIndex = SceneDefine.SCENE_HI_RIGHT
			elseif StateModule:GetInputState("Speed") < SceneStateParam.MiddleSpeed and Scenes[SceneDefine.SCENE_ZERO_RIGHT] then
				newIndex = SceneDefine.SCENE_ZERO_RIGHT
			end
		end
		
		if sceneIndex == SceneDefine.SCENE_LEFT then
			if StateModule:GetInputState("Speed") > SceneStateParam.HiSpeed and Scenes[SceneDefine.SCENE_HI_LEFT] then
				newIndex = SceneDefine.SCENE_HI_LEFT
			elseif StateModule:GetInputState("Speed") < SceneStateParam.MiddleSpeed and Scenes[SceneDefine.SCENE_ZERO_LEFT] then
				newIndex = SceneDefine.SCENE_ZERO_LEFT
			end
		end
		
		if sceneIndex == SceneDefine.SCENE_FLASH then
			if StateModule:GetInputState("Speed") > SceneStateParam.HiSpeed and Scenes[SceneDefine.SCENE_HI_FLASH] then
				newIndex = SceneDefine.SCENE_HI_FLASH
			end
		end
	end
	return newIndex
end

AllModules["SceneState"] = SceneState
