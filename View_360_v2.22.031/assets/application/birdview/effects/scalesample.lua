EffectScaleSample = 
{
	ShaderInst = {},
}

function EffectScaleSample:InitEffect()
	local shaderInitParam = 
	{
		Uniforms = {
			["inputTexture"] = 1,
		},
	}
	self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectScaleSample:ProcessEffect(sourceTexture, srcW, srcH, params, originW, originH)
	local textures = 
	{
		sourceTexture,
	}
	local uniformValue = 
	{
	}
	local scale = params and params.Scale or 0.5
	local dstW = srcW * scale
	local dstH = srcH * scale
	Effect_ProcessEffect(self.ShaderInst, uniformValue, textures, srcW, srcH, dstW, dstH)
	return dstW, dstH
end

EffectList["ScaleSample"] = EffectScaleSample
