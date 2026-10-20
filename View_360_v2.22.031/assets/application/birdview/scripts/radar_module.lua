RadarModule = {
    curRadarGeo = {},
    curRadarCameraGeo = {},
    radarGeos = {},
    radarCameraGeos = {},
    frameCountor = 0,
}

function RadarModule:OnInit()
    StateModule:AttachNotifier("Radar", self, self.OnRadarStateChanged)
end

function RadarModule:OnRadarStateChanged(value, id)
    local radarType = RadarParam.RADAR_RANGE_MAX
    value = value // RadarParam.RADAR_INTERVAL * RadarParam.RADAR_INTERVAL
    if self.radarGeos[id] and value > 0 and value <= radarType then
        if self.radarGeos[id][value] == nil then
            local originData = RadarGenerator[RadarParam.Generator](id, value)
            if originData then
                self.radarGeos[id][value] = GeometryModule:GenerateWorldGeo(originData)
                if id > RadarParam.FRONT_RADAR_CNT then
                    self.radarCameraGeos[id][value] = GeometryModule:GenerateCameraGeo(3, originData)
                else
                    self.radarCameraGeos[id][value] = GeometryModule:GenerateCameraGeo(1, originData)
                end
            end
        end
        self.curRadarGeo[id] = self.radarGeos[id][value]
        self.curRadarCameraGeo[id] = self.radarCameraGeos[id][value]
    elseif value == 0 or value > radarType then
        self.curRadarGeo[id] = nil
        self.curRadarCameraGeo[id] = nil
    end
end

function RadarModule:ClearAll()
    self.curRadarGeo = {}
    self.curRadarCameraGeo = {}
    local totalCnt = RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT
    for i = 1, totalCnt do
        self.radarGeos[i] = {}
        self.radarCameraGeos[i] = {}
    end
end

function RadarModule:OnRender(sceneContent, currentView, projMatrix, transformMatrix)
    local geometries = self.curRadarGeo
    if self.frameCountor // 10 % 5 > 0 then
        if GeometryParam["Radar"] == true and geometries then
            for k, v in pairs(geometries) do
                if k <= RadarParam.FRONT_RADAR_CNT and sceneContent.Front == true or k > RadarParam.FRONT_RADAR_CNT and sceneContent.Rear == true then
                    if type(v) == "table" then
                        for geoIdx, geoObj in ipairs(v) do
                            GeometryModule:RenderWorldObject(geoObj, projMatrix, transformMatrix)
                        end
                    else
                        GeometryModule:RenderWorldObject(v, projMatrix, transformMatrix)
                    end
                end
            end
        end
    end
end

function RadarModule:OnRender2D(cameraIndex, sceneContent, transformMatrix)
    local geometries = self.curRadarCameraGeo
    if self.frameCountor // 10 % 5 > 0 then
        if GeometryParam["Radar"] == true and geometries then
            for k, v in pairs(geometries) do
                if (k <= RadarParam.FRONT_RADAR_CNT and sceneContent.Front == true and cameraIndex == 1) or (k > RadarParam.FRONT_RADAR_CNT and sceneContent.Rear == true and cameraIndex == 3) then
                    if type(v) == "table" then
                        for geoIdx, geoObj in ipairs(v) do
                            GeometryModule:RenderCameraObject(geoObj, transformMatrix)
                        end
                    else
                        GeometryModule:RenderCameraObject(v, transformMatrix)
                    end
                end
            end
        end
    end
end

function RadarModule:OnUpdateConfig()
    self:ClearAll()
    local totalCnt = RadarParam.FRONT_RADAR_CNT + RadarParam.REAR_RADAR_CNT
    for i = 1, totalCnt do
        RadarModule:OnRadarStateChanged(i, 0)
    end
end

function RadarModule:OnUpdateSample()
    self.frameCountor = self.frameCountor + 1
end

AllModules["Radar"] = RadarModule

