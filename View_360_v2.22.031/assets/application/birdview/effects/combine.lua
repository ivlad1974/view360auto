local COMBINE_FRAG = [[
//Effect_Combine_Frag
#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D effectTexture;
uniform sampler2D originTexture;
uniform float originWeight;
uniform float effectWeight;

varying vec2 v_texcoord;

void main()
{
	vec4 rgbOrigin = texture2D(originTexture, v_texcoord).rgba * originWeight;
	vec4 rgbEffect = texture2D(effectTexture, v_texcoord).rgba * effectWeight;
	vec4 result = (rgbOrigin + rgbEffect) - (rgbOrigin * rgbEffect);

	gl_FragColor = result;
}
]]

EffectCombine = 
{
	ShaderInst = {},
}

function EffectCombine:InitEffect()
	local shaderInitParam = 
	{
		FragmentSource = COMBINE_FRAG,
		Uniforms = {
			["effectTexture"] = 1,
			["originTexture"] = 2,
			["originWeight"] = 1.0,
			["effectWeight"] = 1.0,
		},
	}
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectCombine:ProcessEffect(sourceTexture, srcW, srcH, params, originW, originH)
	local originTex = params and params.OriginSource or 0
	local textures = 
	{
		sourceTexture,
		originTex,
	}
	local uniformValue = 
	{
		["originWeight"] = params and params.OriginWeight or 1.0,
		["effectWeight"] = params and params.EffectWeight or 1.0,
	}
	
	local dstW = originW or srcW
	local dstH = originH or srcH
	Effect_ProcessEffect(self.ShaderInst, uniformValue, textures, srcW, srcH, dstW, dstH)
	return dstW, dstH
end

EffectList["Combine"] = EffectCombine


