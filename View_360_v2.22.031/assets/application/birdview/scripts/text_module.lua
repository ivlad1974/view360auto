TextModule = {
    textCore = nil,
    textGlyphs = {},
}

function TextModule:OnInit()
    self.textCore = Text_CreateModule(Common.ShaderPath)
    for i, v in ipairs(TextGlyphs) do
        self.textGlyphs[i] = Text_LoadGlyph(v)
    end
end

function TextModule:RenderString(textString, orthoMatrix, transMatrix, param)
    if param then
        param.Rotation = param.Rotation or 0
        if Common.ScreenRotation then
            param.Rotation = param.Rotation + Common.ScreenRotation
        end
    end
    Text_RenderGlyph(self.textGlyphs[1], textString, orthoMatrix, transMatrix, param)
end

AllModules["Text"] = TextModule


