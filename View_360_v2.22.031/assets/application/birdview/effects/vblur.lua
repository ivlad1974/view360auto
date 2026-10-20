local VBLUR_FRAG = [[
//Effect_VBlur_Frag
#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D inputTexture;
uniform float blurWeight[5];
uniform float texelHeight;
uniform float biasScale;
uniform float resultScale;

varying vec2 v_texcoord;

void main()
{
	vec4 result = texture2D(inputTexture, v_texcoord) * blurWeight[0];
	for(int i = 1; i < 5; ++i)
	{
		float bias = texelHeight * float(i) * biasScale;
		result += texture2D(inputTexture, v_texcoord + vec2(0.0, bias)) * blurWeight[i];
		result += texture2D(inputTexture, v_texcoord - vec2(0.0, bias)) * blurWeight[i];
	}
    gl_FragColor = result * resultScale;
}

]]

EffectVBlur = 
{
	ShaderInst = {},
}

function EffectVBlur:InitEffect()
	local shaderInitParam = 
	{
		FragmentSource = VBLUR_FRAG,
		Uniforms = {
			["inputTexture"] = 1,
			["texelHeight"] = 1.0 / EffectParam.BufferHeight,
			["biasScale"] = 1.0,
			["blurWeight"] = {0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216},
		},
	}
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectVBlur:ProcessEffect(sourceTexture, srcW, srcH, params)
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

EffectList["VBlur"] = EffectVBlur


