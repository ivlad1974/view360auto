ScenePage = BasePage:new({ layouts = nil })

function ScenePage:OnInit(screenW, screenH)
    local elementPath = OverlayParam.OverlayPath .. "scene_page_elements.lua"
    dofile(elementPath)
    self:LoadElements(ScenePageElements, screenW, screenH)

    local layoutPath = OverlayParam.OverlayPath .. "scene_page_layouts.lua"
    dofile(layoutPath)
    self.layouts = {}
    for index, layout in pairs(ScenePageLayouts) do
        self.layouts[index] = self:LoadLayouts(layout)
    end
end

function ScenePage:OnRelease()

end

function ScenePage:OnUpdateSetting(keyString)
    if string.find(keyString, "RecordState") then
        for k, v in pairs(self.layouts) do
            if v.RecState then
                v.RecState.Element = RecordState.Icon
            end
        end
    end
end

function ScenePage:Render(orthoMatrix, transMatrix, frameMSec)
    local currentScene = SceneStudio:GetCurrentScene()
    local currentLayoutIndex = SceneStudio:GetSceneLayout(currentScene)
    local currentLayout = self.layouts[currentLayoutIndex]
    if currentLayout == nil then
        return
    end
    if currentScene ~= self.currentScene and Scenes[currentScene] then
        self.currentScene = currentScene
        if Scenes[currentScene].LayoutElement then
            for key, value in pairs(Scenes[currentScene].LayoutElement) do
                if currentLayout[key] and self.elements[value] then
                    currentLayout[key].Element = value
                end
            end
        end
    end
    if self.elements.DateString then
        self.elements.DateString.Text = os.date("%Y-%m-%d %H:%M:%S")
    end
    if self.elements.DateStringSplit then
        self.elements.DateStringSplit.Text = os.date("%Y-%m-%d\n  %H:%M:%S")
    end
    self:RenderLayout(currentLayout, orthoMatrix, transMatrix)
end

OverlayStudio:AddPage("Scene", ScenePage)

