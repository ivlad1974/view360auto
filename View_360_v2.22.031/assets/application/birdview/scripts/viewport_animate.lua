function ViewportJump(viewport, nextViewPortBegin, timeElaps, animateParam)
    return { 0, 0, 0, 0 }, viewport, true
end

function ViewportInterpolate(lastViewport, nextViewport, timeElaps, animateParam)
    local animateSec = animateParam.AnimateSec or 0
    animateParam.animatingSec = animateParam.animatingSec + timeElaps
    local percent = 0
    if animateParam.animatingSec >= animateSec then
        percent = 1
        animateParam.animatingSec = 0
    else
        percent = animateParam.animatingSec / animateSec
        percent = SPercent(percent, 1)
    end
    local currentViewport = { 0, 0, 0, 0 }
    for i = 1, 4, 1 do
        currentViewport[i] = lastViewport[i] + (nextViewport[i] - lastViewport[i]) * percent
    end
    return currentViewport, percent == 1
end

function ViewportSlide(viewport, timeElaps, animateParam)
    local viewportEnd = table.Clone(viewport)
    viewportEnd[1] = viewportEnd[1] - (animateParam.BeginPort[1] - viewport[1])
    viewportEnd[2] = viewportEnd[2] - (animateParam.BeginPort[2] - viewport[2])
    local animateSec = animateParam.AnimateSec or 0
    animateParam.animatingSec = animateParam.animatingSec + timeElaps
    local percent = 0
    if animateParam.animatingSec >= animateSec then
        percent = 1
        animateParam.animatingSec = 0
    else
        percent = animateParam.animatingSec / animateSec
        percent = SPercent(percent, 1)
    end
    local lastViewport = { 0, 0, 0, 0 }
    local currentViewport = { 0, 0, 0, 0 }
    for i = 1, 4, 1 do
        lastViewport[i] = viewport[i] + (viewportEnd[i] - viewport[i]) * percent
        currentViewport[i] = animateParam.BeginPort[i] + (viewport[i] - animateParam.BeginPort[i]) * percent
    end
    return lastViewport, currentViewport, percent > 0.99
end

function GenerateViewportAnimateParam(targetCamera, vp)

end

FunctionNames[ViewportSlide] = "ViewportSlide"
FunctionNames[ViewportInterpolate] = "ViewportInterpolate"
FunctionNames[ViewportJump] = "ViewportJump"

