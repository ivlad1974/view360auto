local HDILATE_FRAG = [[
//Effect_HDilate_Frag
#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D inputTexture;
uniform float texelWidth;
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
		float bias = texelWidth * float(i);
		texel = texture2D(inputTexture, v_texcoord + vec2(bias, 0.0));
		if (texel.a > orgPix.a)
		{
			orgPix = texel;
			gl_FragColor = texel;
			gl_FragColor.a *= strength[i];
		}
		texel = texture2D(inputTexture, v_texcoord - vec2(bias, 0.0));
		if (texel.a > orgPix.a)
		{
			orgPix = texel;
			gl_FragColor = texel;
			gl_FragColor.a *= strength[i];
		}
	}
}
]]

EffectHDilate = 
{
	ShaderInst = {},
}

function EffectHDilate:InitEffect()
	local shaderInitParam = 
	{
		FragmentSource = HDILATE_FRAG,
		Uniforms = {
			["inputTexture"] = 1,
			["texelWidth"] = 1.0 / EffectParam.BufferWidth,
			["footLen"] = 6,
			["strength"] = {1.0, 0.83, 0.6666, 0.5, 0.333, 0.167},
		},
	}
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectHDilate:ProcessEffect(sourceTexture, srcW, srcH, params)
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

EffectList["HDilate"] = EffectHDilate
