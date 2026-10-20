function CalibRectShadow()
    local rectWidth = CalibInfo.CalibRectWidth / 2
    local rectLength = CalibInfo.CalibRectLength / 2
    local extraFront = CalibExtra and CalibExtra.FrontOffset or 0
    local extraRear = CalibExtra and CalibExtra.RearOffset or 0
    local extraSide = CalibExtra and CalibExtra.SideOffset or 0

    local VertexArrayData = {
        VertexData = { { -rectLength - extraRear, 0.0, -rectWidth - extraSide }, { -rectLength - extraRear, 0.0, rectWidth + extraSide }, { rectLength + extraFront, 0.0, -rectWidth - extraSide }, { rectLength + extraFront, 0.0, rectWidth + extraSide } },
        TexcoordData = { { 0.0, 0.0 }, { 1.0, 0.0 }, { 0.0, 1.0 }, { 1.0, 1.0 } },
        GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ZERO,
        DepthTest = false,
        TextureFile = Common.ShadowTexture,
    }
    return VertexArrayData, 4
end

TrackGenerators = {
    GenerateAlphaTrack,
    GenerateGeelyTrack,
    GenerateNXPTrack,
    GenerateBenzTrack,
    GenerateBMWTrack,
    GenerateGLCTrack,
    GenerateLexusTrack,
    GenerateTradTrack,
    GenerateCadillacTrack,
    GenerateCadillacDistTrack,
    GenerateCadillacDistSubTrack,
}

IndicatorParam = {
    BackAuxLine = Generate4StepBackDistAux,
    SideBorder = GenerateSideBorder,
    DowDetectArea = GenerateDowDetectArea,
}

