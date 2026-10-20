InitOrder = { "State", "Geometry", "Mesh", "Adas", "Model" }
AllModules = {}

RenderFrame = RenderFrame or {}

function SystemInitialize()
    RenderFrame:InitAllModules()
    collectgarbage()
end

function SystemRelease()
    AllModules = {}
    collectgarbage()
end

CalibExtraMeta = {
    Origin = {},
    CollectValue = function(index, value)
        if index == 'SideOffset' then
            if value < -CalibInfo.CalibRectWidth * 0.45 then
                value = -CalibInfo.CalibRectWidth * 0.45
            end
        end
        if index == 'FrontOffset' then
            if value < -CalibInfo.CalibRectLength * 0.45 then
                value = -CalibInfo.CalibRectLength * 0.45
            end
        end
        if index == 'RearOffset' then
            if value < -CalibInfo.CalibRectLength * 0.45 then
                value = -CalibInfo.CalibRectLength * 0.45
            end
        end
        return value
    end,

    __index = function(tab, ind)
        local val = CalibExtraMeta.Origin[ind]
        if val and CalibInfo then
            val = CalibExtraMeta.CollectValue(ind, val)
        end
        return val
    end,

    __newindex = function(tab, ind, val)
        if val and CalibInfo then
            val = CalibExtraMeta.CollectValue(ind, val)
        end
        CalibExtraMeta.Origin[ind] = val
    end
}

function RenderFrame:InitAllModules()
    local moduleInited = {}
    for index, value in ipairs(InitOrder) do
        if AllModules[value] then
            AllModules[value]:OnInit()
            moduleInited[value] = true
        end
    end
    for key, value in pairs(AllModules) do
        if moduleInited[key] == nil then
            value:OnInit()
        end
    end
    for key, value in pairs(AllModules) do
        if type(value) == "table" and value.OnInitDone then
            value:OnInitDone()
        end
    end

    if getmetatable(CalibExtra) == nil then
        CalibExtraMeta.Origin = CalibExtra
        CalibExtra = {}
        setmetatable(CalibExtra, CalibExtraMeta)
    end
end

function RenderFrame:UpdateSetting(keyString)
    for key, value in pairs(AllModules) do
        if type(value) == "table" and value.OnUpdateSetting then
            value:OnUpdateSetting(keyString)
        end
    end
end

function RenderFrame:UpdateScreenSize(scrW, scrH)
    for key, value in pairs(AllModules) do
        if type(value) == "table" and value.OnUpdateScreenSize then
            value:OnUpdateScreenSize(scrW, scrH)
        end
    end
end

function RenderFrame:SystemBackup()
    for key, value in pairs(AllModules) do
        if type(value) == "table" and value.OnBackup then
            value:OnBackup()
        end
    end
end

function RenderFrame:SystemRestore()
    for key, value in pairs(AllModules) do
        if value.OnRestore then
            value:OnRestore()
        end
    end
end


