
EffectFileList = 
{
	"scalesample.lua",
	"mono.lua",
	"fxaa.lua",
	"hblur.lua",
	"vblur.lua",
	"combine.lua",
	"combinelum.lua",
}

DEFAULT_TARGET_OPP = 
{
	Depth = false,
	Blend = false,
	Clear = false,
}

PostRenderPass = 
{
	{"Fxaa", nil, {}},
}

ModelPass = 
{
	-- {"HBlur", nil, {}},
	-- {"VBlur", nil, {}},
	-- {"Combine", nil, {OriginWeight = 1.0, EffectWeight = 1.0}},
	-- {"Fxaa", nil, {}},
}

ModelLightRenderPass = 
{
	-- {"HBlur", DEFAULT_TARGET_OPP, {Strength = 2.50}},
	-- {"VBlur", nil, {}},
	-- {"ScaleSample", {Depth = false, Blend = false, Clear = true}, {Scale = 0.25}},
	-- {"VBlur", nil, {Strength = 2.50}},
	-- {"HBlur", nil, {}},
	-- {"ScaleSample", nil, {Scale = 4}},
	-- {"Combine", nil, {OriginWeight = 1.0, EffectWeight = 1.0, OriginSource = 3}},
	-- {"CombineLum", nil, {OriginWeight = 1.0, EffectWeight = 1.0, OriginSource = 0}},
	-- {"Base", nil, {}}
}

