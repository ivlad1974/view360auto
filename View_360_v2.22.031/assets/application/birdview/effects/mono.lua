local MONO_FRAG = [[
//Effect_Mono_Frag
#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D inputTexture;

varying vec2 v_texcoord;

const vec3 rgb2gray = vec3(0.2125,0.7154,0.0721);

void main()
{
	vec4 texel = texture2D(inputTexture, v_texcoord);
	float brit = dot(rgb2gray, texel.rgb);
	gl_FragColor = vec4(brit, brit, brit, texel.a);
}
]]

EffectMono = 
{
	ShaderInst = {},
}

function EffectMono:InitEffect()
	local shaderInitParam = 
	{
		FragmentSource = MONO_FRAG,
		Uniforms = {
			["inputTexture"] = 1,
		},
	}
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectMono:ProcessEffect(sourceTexture, srcW, srcH, params, originW, originH)
	local textures = 
	{
		sourceTexture,
	}
	local uniformValue = 
	{
	}
	local dstW = originW or srcW
	local dstH = originH or srcH
	Effect_ProcessEffect(self.ShaderInst, uniformValue, textures, srcW, srcH, dstW, dstH)
	return dstW, dstH
end

EffectList["Mono"] = EffectMono


