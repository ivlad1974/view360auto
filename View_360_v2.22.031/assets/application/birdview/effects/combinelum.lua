local COMBINE_LUM_FRAG = [[
//Effect_Combine_Lum_Frag
#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D effectTexture;
uniform sampler2D originTexture;
uniform float originWeight;
uniform float effectWeight;

const vec3 rgb2gray = vec3(0.2125,0.7154,0.0721);

varying vec2 v_texcoord;

void main()
{
	vec4 rgbOrigin = texture2D(originTexture, v_texcoord).rgba * originWeight;
	vec4 rgbEffect = texture2D(effectTexture, v_texcoord).rgba * effectWeight;
	vec4 result = (rgbOrigin + rgbEffect);
	float brit = dot(rgb2gray, result.rgb);
	brit = max(brit, 1.0);
	result.rgb = result.rgb / brit;
	gl_FragColor = result;
}
]]

EffectCombineLum = 
{
	ShaderInst = {},
}

function EffectCombineLum:InitEffect()
	local shaderInitParam = 
	{
		FragmentSource = COMBINE_LUM_FRAG,
		Uniforms = {
			["effectTexture"] = 1,
			["originTexture"] = 2,
			["originWeight"] = 1.0,
			["effectWeight"] = 1.0,
		},
	}
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectCombineLum:ProcessEffect(sourceTexture, srcW, srcH, params)
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
	Effect_ProcessEffect(self.ShaderInst, uniformValue, textures, srcW, srcH, srcW, srcH)
	return srcW, srcH
end

EffectList["CombineLum"] = EffectCombineLum


