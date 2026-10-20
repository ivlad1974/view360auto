EffectList = {
}

EffectModule = {
    effectCore = nil,
    currentWidth = 0,
    currentHeight = 0,
    RenderPath = {},
}

function EffectModule:OnInit()
    if EffectParam.BufferWidth == 0 or EffectParam.BufferHeight == 0 then
        return
    end
    self.effectCore = Effect_CreateModule(EffectParam.BufferWidth, EffectParam.BufferHeight, EffectParam.BufferCount)
    EffectBase:InitEffect()
    for i, v in ipairs(EffectFileList) do
        local effectFile = EffectParam.EffectPath .. v
        dofile(effectFile)
    end
    for key, value in pairs(EffectList) do
        value:InitEffect()
    end
    EffectList["Base"] = EffectBase
end

function EffectModule:OnUpdateScreenSize(screenW, screenH)
    if EffectParam.BufferWidth == 0 or EffectParam.BufferHeight == 0 then
        EffectParam.BufferWidth = screenW
        EffectParam.BufferHeight = screenH
        self:OnInit()
    end
end

function EffectModule:RenderBegin(renderPass, width, height)
    self.currentWidth = width or EffectParam.BufferWidth
    self.currentHeight = height or EffectParam.BufferHeight
    renderPass = renderPass or (#PostRenderPass > 0 and PostRenderPass or defaultPass)
    Effect_RenderBegin(self.currentWidth, self.currentHeight)
    local defaultPass = {
        { "Base", DEFAULT_TARGET_OPP, {} }
    }
    self.RenderPath = { renderPass }
end

--在原后处理的流程上再加一道流程，比如，全画面bloom之后，车灯需要另外再加一个流程就需要调用这个接口
function EffectModule:BeginNewPass(newRenderPass)
    local currentPass = #self.RenderPath
    Effect_SetTarget(currentPass, { Depth = true, Blend = false, Clear = true })
    local passExist = false
    for i, v in ipairs(self.RenderPath) do
        if self.RenderPath[i] == newRenderPass then
            passExist = true
        end
    end
    if not passExist then
        self.RenderPath[currentPass + 1] = newRenderPass
    end
end
--与上一个接口成对出现
function EffectModule:EndNewPass()
    local currentPass = #self.RenderPath
    Effect_SetTarget(currentPass - 2, { Depth = true, Blend = false, Clear = false })
end

function EffectModule:RenderEnd(originW, originH)
    --从后往前处理每一个流程
    for idx = #self.RenderPath, 1, -1 do
        local lastTexture = idx - 1
        local fbWidth = self.currentWidth
        local fbHeight = self.currentHeight
        lastTexture, fbWidth, fbHeight = self:PerformEffects(self.RenderPath[idx], lastTexture, fbWidth, fbHeight, originW, originH)
    end
end

function EffectModule:PerformEffects(effectPass, beginTexture, areaWidth, areaHeight, originW, originH)
    local lastTexture = beginTexture
    for i, value in ipairs(effectPass) do
        local key = value[1]
        local targetParam = value[2]
        local params = value[3]
        if EffectList[key] then
            local nextTexture = (lastTexture + 1) % EffectParam.BufferCount
            if nextTexture <= beginTexture then
                nextTexture = beginTexture + 1    -- texture 0 is origin output, keep it for combine
            end
            if i == #effectPass then
                nextTexture = beginTexture - 1    -- for the last pass, set the render target to origin target
                Effect_SetTarget(nextTexture, targetParam)
                areaWidth, areaHeight = EffectList[key]:ProcessEffect(lastTexture, areaWidth, areaHeight, params, originW, originH)
            else
                Effect_SetTarget(nextTexture, targetParam)
                areaWidth, areaHeight = EffectList[key]:ProcessEffect(lastTexture, areaWidth, areaHeight, params)
            end
            lastTexture = nextTexture
        end
    end
    return lastTexture, areaWidth, areaHeight
end

function EffectModule:GetFramebufferSize()
    return EffectParam.BufferWidth, EffectParam.BufferHeight
end

AllModules["Effect"] = EffectModule

--[[
	Define Base Effect
]]--

EffectBase = {
    ShaderInst = {},
}

function EffectBase:InitEffect()
    local shaderInitParam = {
        Uniforms = {
            ["inputTexture"] = 1,
        },
    }
    self.ShaderInst = Effect_LoadShader(shaderInitParam)
end

function EffectBase:ProcessEffect(sourceTexture, srcW, srcH, params, originW, originH)
    local textures = {
        sourceTexture,
    }
    local uniformValue = {
    }
    local dstW = originW or srcW
    local dstH = originH or srcH
    Effect_ProcessEffect(self.ShaderInst, uniformValue, textures, srcW, srcH, dstW, dstH)
    return srcW, srcH
end

