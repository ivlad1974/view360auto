
function getMeshParams()
local MeshParams =
{
	{
		BlendAngle = 9,
		DivideLevel = 48,
		FrontAngle = 120,
		Generator = "Circle",
		GroundLength = 12500,
		GroundWidth = 7500,
		HeightSmooth = -0.3,
		LengthSmooth = 0,
		RearAngle = 135,
		SingleAngle = 1.5,
		BorderBlur = Common.BorderBlur,
	},
	{
		BlendAngle = 9,
		DivideLevel = 48,
		FrontAngle = 120,
		Generator = "Circle",
		GroundLength = 15000,
		GroundWidth = 10000,
		HeightSmooth = 0.2,
		LengthSmooth = 0.2,
		RearAngle = 90,
		SingleAngle = 1.5,
		BorderBlur = Common.BorderBlur,
	},
	{
		CameraIndex = 2,
		DivideLevel = 48,
		Generator = "Sphere",
		Radius = 5000,
		SingleAngle = 2,
	},
	[5] = {
		CameraIndex = 4,
		DivideLevel = 48,
		Generator = "Sphere",
		Radius = 5000,
		SingleAngle = 2,
	},
	[6] = {
		CameraIndex = 1,
		DivideLevel = 48,
		Generator = "Sphere",
		Radius = 5000,
		SingleAngle = 2,
	},
	[7] = {
		CameraIndex = 3,
		DivideLevel = 48,
		Generator = "Sphere",
		Radius = 5000,
		SingleAngle = 2,
	},
}
	print("mesh_param")
return MeshParams
end

MeshParams = getMeshParams()
