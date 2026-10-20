local HBLUR_FRAG = [[
//Effect_HBlur_Frag
#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D inputTexture;
uniform float blurWeight[5];
uniform float texelWidth;
uniform float biasScale;
uniform float resultScale;

varying vec2 v_texcoord;

void main()
{
	vec4 result = texture2D(inputTexture, v_texcoord) * blurWeight[0];
	for(int i = 1; i < 5; ++i)
	{
		float bias = texelWidth * float(i) * biasScale;
		result += texture2D(inputTexture, v_texcoord + vec2(bias, 0.0)) * blurWeight[i];
		result += texture2D(inputTexture, v_texcoord - vec2(bias, 0.0)) * blurWeight[i];
	}
    gl_FragColor = result * resultScale;
}

]]

EffectHBlur = 
{
	ShaderInst = {},
}

function EffectHBlur:InitEffect()
	local shaderInitParam = 
	{
		FragmentSource = HBLUR_FRAG,
		Uniforms = {
			["inputTexture"] = 1,
			["texelWidth"] = 1.0 / EffectParam.BufferWidth,
			["biasScale"] = 1.0,
			["blurWeight"] = {0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216},
		},
	}
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectHBlur:ProcessEffect(sourceTexture, srcW, srcH, params)
	local textures = 
	{
		sourceTexture,
	}
	local uniformValue = 
	{
		["biasScale"] = params and params.BiasScale or 1.0,
		["resultScale"] = params and params.Strength or 1.0,
	}
	Effect_ProcessEffect(self.ShaderInst, uniformValue, textures, srcW, srcH, srcW, srcH)
	return srcW, srcH
end

EffectList["HBlur"] = EffectHBlur


