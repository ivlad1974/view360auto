OverlayStudio = {
    uiPages = {},
    orthoMatrix = nil,
    transMatrix = nil,
    currentPage = nil,
    screenWidth = 0,
    screenHeight = 0,
}

function OverlayStudio:AddPage(pageName, pageContent)
    self.uiPages[pageName] = pageContent
end

function OverlayStudio:OnInit()
    self.orthoMatrix = Math_CreateMatrix()
    self.transMatrix = Math_CreateMatrix()
    Math_MatrixIdentify(self.orthoMatrix)
    Math_MatrixOrtho(self.orthoMatrix, 0.0, 0.0, 1.0, 1.0)

    local baseElement = {
        VertexData = { { 0.0, 0.0, 0.0 }, { 1.0, 0.0, 0.0 }, { 0.0, 1.0, 0.0 }, { 1.0, 1.0, 0.0 } },
        SingleColor = { 1.0, 1.0, 1.0, 1.0 },
        TexcoordData = { { 0.0, 0.0 }, { 1.0, 0.0 }, { 0.0, 1.0 }, { 1.0, 1.0 } },
        GeoMode = GL_DEFINES.GL_TRIANGLE_STRIP,
        SrcRGBBlend = GL_DEFINES.GL_SRC_ALPHA,
        DstRGBBlend = GL_DEFINES.GL_ONE_MINUS_SRC_ALPHA,
        SrcAlphaBlend = GL_DEFINES.GL_ONE,
        DstAlphaBlend = GL_DEFINES.GL_ZERO,
        DepthTest = false,
    }
    self:ShowPage(OverlayParam.DefaultPage)
end

function OverlayStudio:ShowPage(pageName)
    if self.uiPages[self.currentPage] then
        self.uiPages[self.currentPage]:OnRelease()
    end
    self.uiPages[pageName]:OnInit(self.screenWidth, self.screenHeight)
    self.currentPage = pageName
end

function OverlayStudio:OnUpdateScreenSize(screenW, screenH)
    self.screenWidth = screenW
    self.screenHeight = screenH
    if self.uiPages[self.currentPage] then
        self.uiPages[self.currentPage]:OnUpdateScreenSize(screenW, screenH)
    end
end

function OverlayStudio:OnUpdateSetting(keyString)
    if string.find(keyString, "OverlayParam") then
        self:ShowPage(self.currentPage)
    elseif self.uiPages[self.currentPage].OnUpdateSetting then
        self.uiPages[self.currentPage]:OnUpdateSetting(keyString)
    end
end

function OverlayStudio:RenderPage(frameMSec)
    if self.uiPages[self.currentPage] and self.uiPages[self.currentPage].Render then
        RenderFrame.SetViewport(0, 0, 1, 1)
        RenderFrame.SetScissor(0, 0, 1, 1)
        self.uiPages[self.currentPage]:Render(self.orthoMatrix, self.transMatrix, frameMSec)
    end
end

AllModules["OverlayStudio"] = OverlayStudio

BasePage = {
    elements = {},
}

function BasePage:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function BasePage:LoadElements(elementsTable, screenW, screenH)
    for key, value in pairs(elementsTable) do
        if value.Geometry then
            local newElement = {
                Geometry = nil,
                Size = {},
            }
            if value.Image then
                value.Geometry.TextureFile = OverlayParam.ImagePath .. value.Image
            end
            newElement.Geometry = GeometryModule:GenerateWorldGeo(value.Geometry)
            newElement.Size[1] = value.Width
            newElement.Size[2] = value.Height
            newElement.Size[3] = 1.0
            self.elements[key] = newElement

        elseif value.Image then
            local newElement = {
                Texture = nil,
                Size = {},
            }
            local texturePath = OverlayParam.ImagePath .. value.Image
            newElement.Texture = Texture_LoadTexture(texturePath)
            if newElement.Texture then
                newElement.OriginWidth = value.Width
                newElement.OriginHeight = value.Height
                newElement.Size[1] = value.Width
                newElement.Size[2] = value.Height
                if newElement.Size[1] == nil and newElement.Size[2] == nil then
                    newElement.Size[2] = newElement.Texture.TextureHeight / screenH
                    newElement.Size[1] = newElement.Texture.TextureWidth / screenW
                elseif newElement.Size[1] == nil and newElement.Size[2] ~= nil then
                    local pixelRate = newElement.Size[2] / (newElement.Texture.TextureHeight / screenH)
                    newElement.Size[1] = newElement.Texture.TextureWidth / screenW * pixelRate
                elseif newElement.Size[1] ~= nil and newElement.Size[2] == nil then
                    local pixelRate = newElement.Size[1] / (newElement.Texture.TextureWidth / screenW)
                    newElement.Size[2] = newElement.Texture.TextureHeight / screenH * pixelRate
                end
                newElement.Size[3] = 1.0
                self.elements[key] = newElement
            end
        elseif value.Text then
            local newElement = {
                Text = value.Text,
                Size = { value.Height * (screenH / screenW), value.Height, 1.0 },
            }
            self.elements[key] = newElement
        end
    end
end

function BasePage:OnUpdateScreenSize(screenW, screenH)
    for key, value in pairs(self.elements) do
        if value.Text then
            value.Size[1] = value.Size[2] * (screenH / screenW)
        elseif value.Texture then
            value.Size[1] = nil
            value.Size[2] = nil
            value.Size[1] = value.OriginWidth
            value.Size[2] = value.OriginHeight
            if value.Size[1] == nil and value.Size[2] == nil then
                value.Size[2] = value.Texture.TextureHeight / screenH
                value.Size[1] = value.Texture.TextureWidth / screenW
            elseif value.Size[1] == nil and value.Size[2] ~= nil then
                local pixelRate = value.Size[2] / (value.Texture.TextureHeight / screenH)
                value.Size[1] = value.Texture.TextureWidth / screenW * pixelRate
            elseif value.Size[1] ~= nil and value.Size[2] == nil then
                local pixelRate = value.Size[1] / (value.Texture.TextureWidth / screenW)
                value.Size[2] = value.Texture.TextureHeight / screenH * pixelRate
            end
        end
    end
end

function BasePage:LoadLayouts(layoutTable)
    local layout = {
        ZOrder = {},
    }
    local ZOrders = {}
    for key, value in pairs(layoutTable) do
        ZOrders[value.Position[3]] = ZOrders[value.Position[3]] or {}
        table.insert(ZOrders[value.Position[3]], key)
    end
    local ZValues = {}
    for key, z in pairs(ZOrders) do
        table.insert(ZValues, key)
    end
    table.sort(ZValues)
    for key, z in ipairs(ZValues) do
        for i, elName in ipairs(ZOrders[z]) do
            layout[elName] = layoutTable[elName]
            table.insert(layout.ZOrder, elName)
        end
    end
    return layout
end

function BasePage:RenderLayout(layout, orthoMatrix, transMatrix)
    if layout and layout.ZOrder then
        for key, value in ipairs(layout.ZOrder) do
            if self.elements[layout[value].Element] then
                Math_MatrixIdentify(transMatrix)
                Math_MatrixTranslate(transMatrix, layout[value].Position)
                Math_MatrixRotate(transMatrix, layout[value].Rotation)
                Math_MatrixScale(transMatrix, self.elements[layout[value].Element].Size)
                if self.elements[layout[value].Element].Texture then
                    Texture_DrawTexture(self.elements[layout[value].Element].Texture.TextureId, orthoMatrix, transMatrix)
                elseif self.elements[layout[value].Element].Text then
                    TextModule:RenderString(self.elements[layout[value].Element].Text, orthoMatrix, transMatrix)
                elseif self.elements[layout[value].Element].Geometry then
                    GeometryModule:RenderWorldObject(self.elements[layout[value].Element].Geometry, orthoMatrix, transMatrix)
                end
            end
        end
    end
end

