GeometryModule = {
    geometryCore = nil, -- C++ instance for geometry logic
    worldGeometries = {},
    adjustedGeometries = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {},
    },
    cameraGeometries = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {},
    },
}

function GeometryModule:OnInit()
    self.geometryCore = Geometry_CreateGeometryModule(Common.ShaderPath)
end

function GeometryModule:OnUpdateConfig()
end

function GeometryModule:RenderGeo(geoObjects, projMatrix, transformMatrix, translation, rotation, color)
    if type(geoObjects) == "table" then
        for geoIdx, geoObj in ipairs(geoObjects) do
            Geometry_RenderGeoInst(geoObj, projMatrix, transformMatrix, translation, rotation, color)
        end
    else
        Geometry_RenderGeoInst(geoObjects, projMatrix, transformMatrix, translation, rotation, color)
    end
end

function GeometryModule:OnRender(sceneContent, currentView, projMatrix, transformMatrix)
    if currentView.Camera and currentView.MeshBlendFac then
        return
    end
    for index, key in ipairs(sceneContent) do
        if GeometryParam[key] == true then
            local geometries = self.worldGeometries[key]
            if geometries then
                self:RenderGeo(geometries, projMatrix, transformMatrix)
            end
            if currentView.Camera then
                geometries = self.adjustedGeometries[currentView.Camera][key]
                if geometries then
                    self:RenderGeo(geometries, projMatrix, transformMatrix)
                end
            end
        end
    end
end

function GeometryModule:OnRender2D(cameraIndex, sceneContent, transformMatrix)
    for index, key in ipairs(sceneContent) do
        if GeometryParam[key] == true then
            local geometries = self.cameraGeometries[cameraIndex][key]
            if geometries then
                self:RenderGeo(geometries, transformMatrix)
            end
        end
    end
end

function GeometryModule:GenerateWorldGeo(originData)
    if #originData > 0 then
        local geoArray = {}
        for i, v in ipairs(originData) do
            geoArray[i] = Geometry_GenerateWorldGeo(v)
        end
        return geoArray
    else
        return Geometry_GenerateWorldGeo(originData)
    end
end

function GeometryModule:GenerateCameraGeo(cameraIndex, originData)
    if #originData > 0 then
        local geoArray = {}
        for i, v in ipairs(originData) do
            geoArray[i] = Geometry_GenerateCameraGeo(v, cameraIndex)
        end
        return geoArray
    else
        return Geometry_GenerateCameraGeo(originData, cameraIndex)
    end
end

function GeometryModule:SaveGeo(geometries, savePath)
    if type(geometries) == "table" then
        for geoIdx, geoObj in ipairs(geometries) do
            if not Geometry_SaveGeoInst(geoObj, savePath .. geoIdx) then
                return false
            end
        end
        return true
    else
        return Geometry_SaveGeoInst(geometries, savePath)
    end
end

function GeometryModule:LoadGeo(loadPath)
    local geofile = io.open(loadPath)
    if geofile then
        io.close(geofile)
        return Geometry_LoadGeoInst(loadPath)
    else
        local geoArray = {}
        for i = 1, 255, 1 do
            local geofile = io.open(loadPath .. i)
            if geofile then
                io.close(geofile)
                geoArray[i] = Geometry_LoadGeoInst(loadPath .. i)
            else
                break ;
            end
        end
        if #geoArray > 0 then
            return geoArray
        else
            return nil
        end
    end
end

function GeometryModule:AttachWorldGeometry(objname, geoObject, cameraIndex)
    if cameraIndex then
        self.adjustedGeometries[cameraIndex][objname] = geoObject
    else
        self.worldGeometries[objname] = geoObject
    end
end

function GeometryModule:DetachWorldGeometry(objname)
    self.worldGeometries[objname] = nil
end

function GeometryModule:AttachCameraGeometry(cameraIndex, objname, geoObject)
    self.cameraGeometries[cameraIndex][objname] = geoObject
end

function GeometryModule:DetachCameraGeometry(cameraIndex, objname)
    self.cameraGeometries[cameraIndex][objname] = nil
end

function GeometryModule:RenderWorldObject(geometryObject, projMatrix, transformMatrix)
    Geometry_RenderGeoInst(geometryObject, projMatrix, transformMatrix)
end

function GeometryModule:RenderCameraObject(geometryObject, transformMatrix)
    Geometry_RenderGeoInst(geometryObject, transformMatrix)
end

AllModules["Geometry"] = GeometryModule
