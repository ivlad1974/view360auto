local VDILATE_FRAG = [[
//Effect_VDilate_Frag
#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D inputTexture;
uniform float texelHeight;
uniform int footLen;
uniform float strength[6];
varying vec2 v_texcoord;

void main()
{
	vec4 orgPix = texture2D(inputTexture, v_texcoord);
	gl_FragColor = orgPix;
	vec4 texel;
	for(int i = 1; i < footLen; ++i)
	{
		float bias = texelHeight * float(i);
		texel = texture2D(inputTexture, v_texcoord + vec2(0.0, bias));
		if (texel.a > orgPix.a)
		{
			orgPix = texel;
			gl_FragColor = texel;
			gl_FragColor.a *= strength[i];
		}
		texel = texture2D(inputTexture, v_texcoord - vec2(0.0, bias));
		if (texel.a > orgPix.a)
		{
			orgPix = texel;
			gl_FragColor = texel;
			gl_FragColor.a *= strength[i];
		}
	}
}

]]

EffectVDilate = 
{
	ShaderInst = {},
}

function EffectVDilate:InitEffect()
	local shaderInitParam = 
	{
		FragmentSource = VDILATE_FRAG,
		Uniforms = {
			["inputTexture"] = 1,
			["texelHeight"] = 1.0 / EffectParam.BufferHeight,
			["footLen"] = 6,
			["strength"] = {1.0, 0.83, 0.6666, 0.5, 0.333, 0.167},
		},
	}
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectVDilate:ProcessEffect(sourceTexture, srcW, srcH, params)
	local textures = 
	{
		sourceTexture,
	}
	local uniformValue = 
	{
	}
	Effect_ProcessEffect(self.ShaderInst, uniformValue, textures, srcW, srcH, srcW, srcH)
	return srcW, srcH
end

EffectList["VDilate"] = EffectVDilate


