TextureModule = {
    textureCore = nil,
}

function TextureModule:OnInit()

    self.textCore = Texture_CreateModule(Common.ShaderPath)
end

AllModules["Texture"] = TextureModule


