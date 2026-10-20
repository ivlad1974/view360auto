local ROTATE_VERT = [[
//Effect_Rotate_Vert
#version 100
uniform mat4 rotate;
attribute vec4 a_position;
attribute vec2 a_texcoord;
varying vec2 v_texcoord;
void main(void)
{
	gl_Position = rotate * a_position;
	v_texcoord = a_texcoord;
}
]]



EffectRotate = 
{
	ShaderInst = {},
}

function EffectRotate:InitEffect()
	local shaderInitParam = 
	{
		VertexSource = ROTATE_VERT,
		Uniforms = {
			["inputTexture"] = 1,
			["rotate"] = math.rad(Common.ScreenRotation or 0.0),
		},
	}
	local matrix = Math_CreateMatrix()
	Math_MatrixRotate(matrix, {0.0, 0.0, Common.ScreenRotation})
	shaderInitParam.Uniforms.rotate = matrix
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectRotate:ProcessEffect(sourceTexture, srcW, srcH, params, destW, destH)
	local textures = 
	{
		sourceTexture,
	}
	local uniformValue = 
	{

	}
	Effect_ProcessEffect(self.ShaderInst, uniformValue, textures, srcW, srcH, destW, destH)
	return destW, destH
end

EffectList["Rotate"] = EffectRotate

