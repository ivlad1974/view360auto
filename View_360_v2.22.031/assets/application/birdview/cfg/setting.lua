CameraDistoration = {
    LensSpec = "/sdcard/.Baios360/birdview/res/lens.lua",
    SensorSpec = "/sdcard/.Baios360/birdview/res/sensor.lua",
}

DefaultAnimate = {
    AnimateParam = {
        Animate = 0.0,
    },
    Content = {
        Mesh = 0,
        Model = {
        },
    },
}

Common = {
    AuxPitch = 0,
    SvBv = 0,
    CalibFile = "/custom/calibinfo.lua",
    FOV = 35,
    ShaderPath = "/sdcard/.Baios360/birdview/shaders/",
    ShadowTexture = "/sdcard/.Baios360/birdview/res/bottom.png",
    TrackPrecision = 0.5,
    TrackType = 4,
    ZFar = 200000,
    ZNear = 200,
    MeshBalance = false,
    FollowUp = false,
    BorderBlur = false,
    StreamMode = false,
}

OverlayParam = {
    DefaultPage = "Scene",
    ImagePath = "/sdcard/.Baios360/birdview/overlay/",
    OverlayPath = "/sdcard/.Baios360/birdview/overlay/",
}

SideViewMode = -- 0-(origin mode); 1-(calib mode); 2-()
{
    1,
    0,
    1,
    0,
}

EffectParam = {
    BufferCount = 8,
    BufferHeight = 720,
    BufferWidth = 1280,
    EffectPath = "./effects/",
}

GeometryParam = {
    BAux = true,
    BTrack = true,
    FTrack = true,
    CalibHint = true,
    Radar = true,
    FRRedLine = true,
    FLRedLine = true,
    RLRedLine = true,
    RRRedLine = true,
    SideBorder = true,

}

BsdParam = {
    Enable = false,
    SpeedLimit = 30,
}

DnrParam = {
    Enable = false,
}

DowParam = {
    Enable = false,
    EnableRLDow = true,
}

Side3DParam = {
    Front = {
        Pitch = 90,
        Mirror = false,
        Yaw = 0,
        CarOffset = { 0, 0, 0, },
        EyeDist = 8700,
        CenPos = { 0, 3300, -100, },
        FOV = 32,
        Editable = true,
    },
    Right = {
        Yaw = -30,
        Pitch = 15,
        EyeDist = 7500,
        Mirror = false,
        CenPos = { 0, 500, 500 },
        CarOffset = { 0, 0, 0 },
        FOV = 32,
        Editable = true,
    },
    Rear = {
        Pitch = 90,
        Mirror = false,
        Yaw = 0,
        CarOffset = { 0, 0, 0, },
        EyeDist = 7600,
        CenPos = { 0, -3000, 100, },
        FOV = 32,
        Editable = true,
    },
    Left = {
        Yaw = 30,
        Pitch = 15,
        EyeDist = 7500,
        Mirror = false,
        CenPos = { 0, 500, -500 },
        CarOffset = { 0, 0, 0 },
        FOV = 32,
        Editable = true,
    }
}

SideViewParam = {
    [1] = {
        Rotate = 0.0,
        XOffset = 0.0,
        XScale = 1.38,
        YOffset = 0.15,
        YScale = 1.40,
    },
    [2] = {
        Rotate = 90,
        XOffset = -0.07,
        XScale = 1.45,
        YOffset = 0.0,
        YScale = 1.0,
    },
    [3] = {
        XOffset = 0.0,
        YOffset = 0.0,
        XScale = -1.38,
        YScale = 1.0,
        Rotate = 0,
    },
    [4] = {
        Rotate = -90,
        XOffset = 0.12,
        XScale = 1.45,
        YOffset = 0.0,
        YScale = 1.0,
    },
}

SingleViewParam = {
    {
        AngleBias = 0,
        BottomAlign = true,
        Camera = 1,
        Direction = { 1, 0, 0, },
        FOV = 100,
        Mirror = false,
        Pitch = 0,
        UpDirection = { 0, 1, 0, },
        ZAlign = true,
    },
    {
        AngleBias = 0,
        Camera = 2,
        Direction = { 1.2, -1, 0, },
        FOV = 70,
        Mirror = false,
        Pitch = -10,
        UpDirection = { 1, 1, 0, },
        XBias = 0.4,
        YBias = -0.3,
    },
    {
        AngleBias = 0,
        BottomAlign = true,
        Camera = 3,
        Direction = { -1, 0, 0, },
        FOV = 90,
        Mirror = true,
        Pitch = 0,
        UpDirection = { 0, 1, 0, },
        ZAlign = false,
    },
    {
        AngleBias = 0,
        Camera = 4,
        Direction = { 1.2, -1, 0, },
        FOV = 70,
        Mirror = false,
        Pitch = -10,
        UpDirection = { 1, 1, 0, },
        XBias = -0.4,
        YBias = -0.3,
    },
    W1 = {
        AngleBias = 0,
        BottomAlign = false,
        Camera = 1,
        Direction = { 1, 0, 0, },
        FOV = 95,
        Mirror = false,
        Pitch = 15,
        UpDirection = { 1, 1, 0, },
        ZAlign = false,
    },
    W3 = {
        AngleBias = 0,
        BottomAlign = false,
        Camera = 3,
        Direction = { -1, 0, 0, },
        FOV = 95,
        Mirror = true,
        Pitch = 20,
        UpDirection = { -1, 1, 0, },
        ZAlign = false,
    },
}

Rotate3DParam = {
    Front = {
        Pitch = 20,
        Mirror = true,
        Yaw = 180,
        CarOffset = { 0, 0, 0, },
        EyeDist = 9600,
        CenPos = { 0, 0, 0, },
        FOV = 35,
        Editable = true,
    },
    Right = {
        Yaw = -175,
        Pitch = 16,
        EyeDist = 7500,
        Mirror = true,
        CenPos = { 0, 700, -1200 },
        CarOffset = { 0, 0, 0 },
        FOV = 32,
        Editable = true,
    },
    Rear = {
        Pitch = 22,
        Mirror = false,
        Yaw = 0,
        CarOffset = { 0, 0, 0, },
        EyeDist = 9500,
        CenPos = { 0, 0, 0, },
        FOV = 33,
        Editable = true,
    },
    Left = {
        Yaw = 175,
        Pitch = 9,
        EyeDist = 7500,
        Mirror = true,
        CenPos = { 0, 700, 1200 },
        CarOffset = { 0, 0, 0 },
        FOV = 32,
        Editable = true,
    }
}

RadarParam = {
    FRONT_RADAR_CNT = 4,
    REAR_RADAR_CNT = 4,
    LEFT_RADAR_CNT = 4,
    RIGHT_RADAR_CNT = 4,
    Generator = 2,
    RADAR_LEVEL_MAX = 0,
    RADAR_RANGE_MAX = 1500,
    RADAR_INTERVAL = 10,
}

SceneStateParam = {
    HiSpeed = 30,
    MiddleSpeed = 10,
    DiveZone = 5,
    FrontSwitch = false,
    LeftRightSwitch = true,
}

Sources = {
    "/sdcard/.Baios360/birdview/scripts/opengl.lua",
    "/sdcard/.Baios360/birdview/scripts/utils.lua",
    "/sdcard/.Baios360/birdview/scripts/render_frame.lua",
    "/sdcard/.Baios360/birdview/scripts/scene_studio.lua",
    "/sdcard/.Baios360/birdview/scripts/mesh_module.lua",
    "/sdcard/.Baios360/birdview/scripts/texture_module.lua",
    "/sdcard/.Baios360/birdview/scripts/model_module.lua",
    "/sdcard/.Baios360/birdview/scripts/radar_module.lua",
    "/sdcard/.Baios360/birdview/scripts/step_module.lua",
    "/sdcard/.Baios360/birdview/scripts/camera_module.lua",
    "/sdcard/.Baios360/birdview/scripts/geometry_module.lua",
    "/sdcard/.Baios360/birdview/scripts/indicator_module.lua",
    "/sdcard/.Baios360/birdview/scripts/state_module.lua",
    "/sdcard/.Baios360/birdview/scripts/view_animate.lua",
    "/sdcard/.Baios360/birdview/scripts/viewport_animate.lua",
    "/sdcard/.Baios360/birdview/scripts/radar_generator.lua",
    "/sdcard/.Baios360/birdview/scene/dist_aux_generator.lua",
    "/sdcard/.Baios360/birdview/scene/geometry_param.lua",
    "/sdcard/.Baios360/birdview/scene/stream_param.lua",
    "/sdcard/.Baios360/birdview/scene/fixview.lua",
    "/sdcard/.Baios360/birdview/scene/viewport.lua",
    "/sdcard/.Baios360/birdview/scene/mesh_param.lua",
    "/sdcard/.Baios360/birdview/scene/scene1.lua",
}

StreamParam = {
    Blank = 5000,
    RealTimeDist = 500,
}

SystemFlag = {
    SystemReinit = true,
}

CalibInfo = {
    CalibRectLength = 200,
}

CalibExtra = {
    FrontOffset = 0,
    RearOffset = 0,
    SideOffset = 0,
}

VehicleInfo = {
    CarLength = 4682,
    CarWidth = 1823,
    MaxSteerAngle = 540,
    MaxWheelAngle = 40,
    RearOverhang = 1432,
    WheelBase = 2689,
    MaxPulseNumber = 255,
    PulsePerRound = 32,
    WheelCycle3 = 5664,
    FrontOverhang = 1003,
    FrontThread = 1489,
    RearThread = 1655,
}

TextParam = {
    GlyphFiles = {
        "/sdcard/.Baios360/birdview/res/text.png",
    },
}

VideoParameters = {
    Brightness = 1.0,
    Contrast = 1.0,
    Saturation = 1.0,
}

VehicleModel = {
    Alpha = 1,
    CarPaint = {
        Ambient = { 105, 105, 105, },
        Diffuse = { 210, 210, 210, },
        Shiness = 1,
        Specular = { 0, 0, 0, },
    },
    License = {
        TextureFile = "/sdcard/.Baios360/birdview/res/NullLicense.png",
    },
    ReflectImage = {
        "/sdcard/.Baios360/birdview/res/reflect/px.png",
        "/sdcard/.Baios360/birdview/res/reflect/nx.png",
        "/sdcard/.Baios360/birdview/res/reflect/py.png",
        "/sdcard/.Baios360/birdview/res/reflect/ny.png",
        "/sdcard/.Baios360/birdview/res/reflect/pz.png",
        "/sdcard/.Baios360/birdview/res/reflect/nz.png",
    },
    ReflectFactor = 0.5,
    ShowShadow = false,
    LogoScale = 0.0,
    SpeedScale = 0.2,
    ModelFile = "/sdcard/.Baios360/birdview/res/SedanA.vmd",
}
ZZZFileEnd = {
    End = true,
}
