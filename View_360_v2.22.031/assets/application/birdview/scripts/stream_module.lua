StreamModule = {
    STRIPE_COUNT = 40,
    FADEOUT_TIME = 2000,
    FADEOUT_DETECT = 5000,
    STRIPE_BLEND = 0.15,
    MIN_MOVE = 100,
    streamCore = nil,
    streamMesh = nil,
    blendAlpha = 0.0,
    blendTimeStamp = 0,
    textureCleared = false,
}

function StreamModule:OnInit()
    self.streamCore = Stream_CreateModule(self.STRIPE_COUNT, Common.ShaderPath, self.STRIPE_BLEND, self.MIN_MOVE)
end

function StreamModule:OnUpdateConfig()
    self.streamMesh = MeshModule:GenerateMesh(StreamMeshParam)
    local configParam = {
        SquareWidth = CalibInfo.CalibRectLength + StreamTextureParam.SquareLengthExtra * 2,
        SquareHeight = CalibInfo.CalibRectLength + StreamTextureParam.SquareLengthExtra * 2,
        StripeWidth = StreamTextureParam.StripeWidth,
        StripeHeight = StreamTextureParam.StripeHeight,
        StripeCenter = CalibInfo.CalibRectLength / 2 + StreamTextureParam.StripeOffset + StreamTextureParam.StripeHeight / 2,
    }
    Stream_UpdateConfig(configParam)
    Stream_ClearTexture()
    self.textureCleared = true
    self.blendAlpha = 1.0
end

function StreamModule:OnUpdateSetting(keyString)
    if string.find(keyString, "StreamParam") then
        StreamMeshParam.BlankDistance = StreamParam.RealTimeDist
        StreamTextureParam.StripeOffset = StreamMeshParam.BlankDistance
        self:RebuildMesh()
    end
end

function StreamModule:RenderToStripe(projMatrix, transformMatrix)
    MeshModule:RenderMeshInst(self.streamMesh, projMatrix, transformMatrix)
end

function StreamModule:OnUpdateSample(timeStamp)
    local speed = StateModule:GetInputState("Speed")
    if math.abs(speed) < 0.005 and StreamParam.Blank >= 0.0 then
        if not self.textureCleared then
            if self.blendTimeStamp == 0 then
                self.blendTimeStamp = timeStamp
            else
                local timePassed = timeStamp - self.blendTimeStamp
                if timePassed > StreamParam.Blank and timePassed < self.FADEOUT_TIME + StreamParam.Blank then
                    self.blendAlpha = (timePassed - StreamParam.Blank) / self.FADEOUT_TIME
                else
                    if timePassed > self.FADEOUT_TIME + StreamParam.Blank and not self.textureCleared then
                        Stream_ClearTexture()
                        self.textureCleared = true
                    end
                end
            end
        end
    else
        self.textureCleared = false
        self.blendAlpha = 0.0
        self.blendTimeStamp = 0
    end
    if not self.textureCleared then
        Stream_UpdateSample(StateModule:GetInputState("Trans"), StateModule:GetInputState("Direction"), self.blendAlpha)
    end
end

function StreamModule:OnRender(sceneContent, currentView, projMatrix, transformMatrix)
    if Common.StreamMode then
        Stream_RenderSquare(projMatrix, transformMatrix)
    end
end

AllModules["Stream"] = StreamModule


