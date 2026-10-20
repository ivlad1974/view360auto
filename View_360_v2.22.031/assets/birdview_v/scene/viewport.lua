ViewportModule = {
}

function ViewportModule:OnInit()
    Viewports = getViewPort()
end

function ViewportModule:OnUpdateSetting(keyString)
    if string.find(keyString, "Common.SvBv") then
        Viewports = getViewPort()
    end
end

function getViewPort()
    local t = {
        { { 0.0, 0.0, 1.0, 1.0 } }, --全屏显示，X,Y, WIDTH,HIGH
        { { 0.15, 0.0, 0.69, 0.54 }, { 0.0, 0.54, 1.0, 0.46 } },
        { { 0.15, 0.0, 0.69, 0.54 }, { 0.0, 0.54, 1.0, 0.46 } },
        { { 0.0, 0.54, 0.5, 0.46 }, { 0.5, 0.54, 0.5, 0.46 }, { 0.15, 0.0, 0.69, 0.54 } },
        { { 0.181, 0.0, 0.638, 0.5 } },
        { { 0.13, 0.0, 0.87, 0.4355 }, }, --酷玩模式显示
        { { 0.0, 0.0, 1.0, 1.0 } }, --全屏显示，X,Y, WIDTH,HIGH
        { { 0.0, 0.0, 1.0, 1.0 } },
        { { 0.0, 0.54, 1.0, 0.46 }, { 0.15, 0.0, 0.69, 0.54 } },
        { { 0, 0, 0.5, 1 }, { 0.5, 0, 0.5, 1 } },
        {
            { 0, 0.5, 0.5, 0.5 }, { 0.5, 0.5, 0.5, 0.5 },
            { 0, 0.0, 0.5, 0.5 }, { 0.5, 0.0, 0.5, 0.5 },
        },
        {
            { 0, 0.5, 0.33, 0.5 }, { 0.33, 0.5, 0.33, 0.5 }, { 0.66, 0.5, 0.34, 0.5 },
            { 0, 0.0, 0.33, 0.5 }, { 0.33, 0.0, 0.33, 0.5 }, { 0.66, 0.0, 0.34, 0.5 },
        },
        { { 0, 0.0, 0.5, 1.0 }, { 0.5, 0.0, 0.5, 1.0 } },
    }
    return t
end

ViewportAnimates = {

}

AllModules["Viewport"] = ViewportModule

