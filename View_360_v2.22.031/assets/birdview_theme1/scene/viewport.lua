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
        { { 0.66766 * Common.SvBv, 0.13, 0.33234, 0.87 }, { 0.33234 * (1 - Common.SvBv), 0.13, 0.66766, 0.87 } },
        { { 0.66766 * Common.SvBv, 0.13, 0.33234, 0.87 }, { 0.66766 * (1 - Common.SvBv), 0.13, 0.33234, 0.87 } },
        {
            { 0.66766 * Common.SvBv, 0.13, 0.33234, 0.87 },
            { 0.33234 * (1 - Common.SvBv), 0.13, 0.33383, 0.87 },
            { 0.33383 + 0.33234 * (1 - Common.SvBv), 0.13, 0.33383, 0.87 }
        },
        { { 0, 0.13, 0.325, 0.87 }, { 0.325, 0.13, 0.35, 0.87 }, { 0.675, 0.13, 0.325, 0.87 } },
        { { 0, 0.13, 0.3, 0.87 }, { 0.3, 0.13, 0.4, 0.87 }, { 0.7, 0.13, 0.3, 0.87 } },
        { { 0.0, 0.0, 0.382, 1.0 } },
        { { 0, 0.13, 1.0, 0.87 } },
        { { 0, 0, 0.5, 1 }, { 0.5, 0, 0.5, 1 } },
        { { 0, 0.5, 0.5, 0.5 }, { 0.5, 0.5, 0.5, 0.5 }, { 0, 0.0, 0.5, 0.5 }, { 0.5, 0.0, 0.5, 0.5 }, },
        { { 0, 0.5, 0.33, 0.5 }, { 0.33, 0.5, 0.33, 0.5 }, { 0.66, 0.5, 0.34, 0.5 }, { 0, 0.0, 0.33, 0.5 }, { 0.33, 0.0, 0.33, 0.5 }, { 0.66, 0.0, 0.34, 0.5 }, },
        { { 0, 0.13, 0.5, 0.87 }, { 0.5, 0.13, 0.5, 0.87 } },
    }
    return t
end

ViewportAnimates = {

}

AllModules["Viewport"] = ViewportModule

