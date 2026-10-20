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
        { { 0, 0, 1, 1 } },
        { { 0.618 * Common.SvBv, 0.00, 0.382, 1.00 }, { 0.382 * (1 - Common.SvBv), 0.00, 0.618, 1.00 } },
        { { 0.618 * Common.SvBv, 0.00, 0.382, 1.00 }, { 0.618 * (1 - Common.SvBv), 0.00, 0.382, 1.00 } },
        {
            { 0.618 * Common.SvBv, 0.00, 0.382, 1.00 },
            { 0.382 * (1 - Common.SvBv), 0.00, 0.309, 1.00 },
            { 0.309 + 0.382 * (1 - Common.SvBv), 0.00, 0.309, 1.00 }
        },
        { { 0, 0.00, 0.325, 1.00 }, { 0.325, 0.00, 0.35, 1.00 }, { 0.675, 0.00, 0.325, 1.00 } },
        { { 0, 0.00, 0.3, 1.00 }, { 0.3, 0.00, 0.382, 1.00 }, { 0.7, 0.00, 0.3, 1.00 } },
        { { 0.0, 0.0, 0.382, 1.0 } },
        { { 0, 0.00, 1.0, 1.00 } },
        { { 0, 0, 0.5, 1 }, { 0.5, 0, 0.5, 1 } },
        { { 0, 0.5, 0.5, 0.5 }, { 0.5, 0.5, 0.5, 0.5 }, { 0, 0.0, 0.5, 0.5 }, { 0.5, 0.0, 0.5, 0.5 }, },
        { { 0, 0.5, 0.33, 0.5 }, { 0.33, 0.5, 0.33, 0.5 }, { 0.66, 0.5, 0.34, 0.5 }, { 0, 0.0, 0.33, 0.5 }, { 0.33, 0.0, 0.33, 0.5 }, { 0.66, 0.0, 0.34, 0.5 }, },
        { { 0, 0.00, 0.5, 1.00 }, { 0.5, 0.00, 0.5, 1.00 } },
    }
    return t
end

ViewportAnimates = {

}

AllModules["Viewport"] = ViewportModule

