function DefineScene()
    local scene = {
        [1] = {
            Viewport = 1,
            Contents = {
                {
                    Views = { 10, 11 },
                    Mesh = 2,
                    Stream = true,
                    Model = { WheelMode = true },
                },
            },
            SecToNext = 1,
            NextScene = 2,
        },
        [4] = {
            Viewport = 8,
            Contents = {
                {
                    Views = { 10, 51 },
                    Mesh = 2,
                    Stream = true,
                    Model = { WheelMode = true },
                },
            },
        },
        [13] = {
            Viewport = 8,
            Contents = {
                {
                    Mesh = 6,
                    SideView = 1,
                    TransParam = {
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                    Model = {},
                },
            },
        },
        [14] = {
            Viewport = 8,
            Contents = {
                {
                    Mesh = 7,
                    SideView = 3,
                    TransParam = {
                        XOffset = 0.0,
                        YOffset = 0.0,
                        XScale = -1.0,
                        YScale = 1.0,
                        Rotate = 0,
                    },
                    Model = {},
                },
            },
        },
        [15] = {
            Viewport = 8,
            Contents = {
                {
                    Mesh = 5,
                    SideView = 4,
                    TransParam = {
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                    Model = {},
                },
            },
        },
        [16] = {
            Viewport = 8,
            Contents = {
                {
                    Mesh = 3,
                    SideView = 2,
                    TransParam = {
                        Rotate = 0,
                        XOffset = -0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                    Model = {},
                },
            },
        },
        [2] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Mod = { BorderWarn = true, FTrack = true },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    SideView = SideViewMode[1] == 0 and 1 or nil,
                    Views = SideViewMode[1] == 1 and (Common.FollowUp == false and { 71 } or { 31, 31 }) or nil,
                    Mesh = 6,
                    Mod = { FTrack = true },
                    Geometry = { "FTrack", "Mod" },
                }
            },
        },
        [12] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    SideView = SideViewMode[1] == 0 and 1 or nil,
                    Views = SideViewMode[1] == 1 and { 31, 31 } or nil,
                    Mesh = 6,
                    Geometry = { "FTrack", "Mod" },
                    Mod = { FTrack = true },
                }
            },
        },
        [32] = {
            Viewport = 8,
            Contents = {
                {
                    Mesh = 6,
                    Views = { 80, },
                    MultiPart = { Start = 0.0, Seperator = 0.0, 0.25, 0.5, 0.25 },
                },
            },
        },
        [62] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    TransParam = Side3DParam.Front,
                    Mesh = 1,
                    Stream = true,
                    Model = { WheelMode = true, },
                    Geometry = { "FTrack" },
                    Radar = { Front = true },
                    Mod = { FTrack = true },
                }
            },
        },
        [42] = {
            Viewport = 8,
            Contents = {
                {
                    Mesh = 7,
                    Views = { 81, },
                    MultiPart = { Start = 0.0, Seperator = 0.0, 0.25, 0.5, 0.25 },
                },
            },
        },
        [52] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    TransParam = Rotate3DParam.Front,
                    Mesh = 2,
                    Stream = true,
                    Model = { WheelMode = true, },
                    Geometry = { "FTrack" },
                    Mod = { FTrack = true },
                    Radar = { Front = true, Left = true, Right = true, },
                }
            },
        },
        [3] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    TransParam = Side3DParam.Right,
                    Stream = true,
                    Model = { WheelMode = true, RightBlink = true },
                    Geometry = { "FTrack" },
                    Mod = { FTrack = true },
                    Mesh = 2
                },
            },
        },
        [23] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Radar = { Front = true, Left = true, Right = true, },
                    Geometry = { "FTrack", },
                },
                {
                    SideView = SideViewMode[2] == 0 and 2 or nil,
                    Views = { 32 },
                    Geometry = SideViewMode[2] == 1 and { "SideBorder" } or nil,
                    Mesh = 3,
                }
            },
        },
        [33] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    TransParam = Rotate3DParam.Right,
                    Stream = true,
                    Model = { WheelMode = true, RightBlink = true },
                    Geometry = { "FTrack" },
                    Mod = { FTrack = true },
                    Mesh = 2,
                },
            },
        },
        [5] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    TransParam = Side3DParam.Left,
                    Stream = true,
                    Model = { WheelMode = true, LeftBlink = true },
                    Geometry = { "FTrack" },
                    Mod = { FTrack = true },
                    Mesh = 2
                },
            },
        },
        [25] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    SideView = SideViewMode[4] == 0 and 4 or nil,
                    Views = { 34 },
                    Geometry = SideViewMode[4] == 1 and { "SideBorder" } or nil,
                    Mesh = 5,
                }
            },
        },
        [35] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    TransParam = Rotate3DParam.Left,
                    Stream = true,
                    Model = { WheelMode = true, LeftBlink = true },
                    Geometry = { "FTrack" },
                    Mod = { FTrack = true },
                    Mesh = 2
                },
            },
        },
        [6] = {
            Viewport = 7,
            Contents = {
                {
                    Views = { 6, 16 },
                    Model = {}
                },
            },
            NextScene = 6,
        },
        [8] = {
            Viewport = 7,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Model = {},
                    Radar = { Front = true, Rear = true, Left = true, Right = true, }
                },
            },
        },
        [18] = {
            Viewport = 7,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    Model = { WheelMode = true, },
                    Geometry = { "FTrack", "BTrack", "BAux" },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, }
                },
            },
        },
        [28] = {
            Viewport = 1,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    Model = { WheelMode = true, Prerender = (Common.Prerender == nil and true or Common.Prerender) },
                },
            },
        },
        [9] = {
            Viewport = 4,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    Model = {
                        LeftBlink = true,
                        RightBlink = true,
                        Prerender = (Common.Prerender == nil and true or Common.Prerender),
                        WheelMode = true,
                    },
                    Mod = { BorderWarn = true, FTrack = true },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, },
                },
                {
                    Views = { 34 },
                    Geometry = { "SideBorder" },
                    Mesh = 5,
                },
                {
                    Views = { 32 },
                    Geometry = { "SideBorder" },
                    Mesh = 3,
                },
            },
        },
        [19] = {
            Viewport = 4,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = {
                        LeftBlink = true,
                        RightBlink = true,
                        Prerender = (Common.Prerender == nil and true or Common.Prerender),
                        WheelMode = true,
                    },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, },
                },
                {
                    Mesh = 5,
                    Views = { 38 },
                    TransParam = SideViewParam["R4"],
                },
                {
                    Mesh = 3,
                    Views = { 36 },
                    TransParam = SideViewParam["R2"],
                },
            },
        },
        [29] = {
            Viewport = 4,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = {
                        LeftBlink = true,
                        RightBlink = true,
                        Prerender = (Common.Prerender == nil and true or Common.Prerender),
                        WheelMode = true,
                    },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, },
                },
                {
                    SideView = 4,
                    Mesh = 5,
                },
                {
                    SideView = 2,
                    Mesh = 3,
                },
            },
        },
        [39] = {
            Viewport = 4,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    Mod = { BorderWarn = true, FTrack = true },
                    Model = {
                        LeftBlink = true,
                        RightBlink = true,
                        Prerender = (Common.Prerender == nil and true or Common.Prerender),
                        WheelMode = true,
                    },
                    Geometry = { "FTrack", },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, },
                },
                {
                    SideView = 4,
                    Mesh = 5,
                    TransParam = SideViewParam["R4"]
                },
                {
                    SideView = 2,
                    Mesh = 3,
                    TransParam = SideViewParam["R2"],
                },
            },
        },
        [49] = {
            Viewport = 5,
            Contents = {
                {
                    Views = { 34 },
                    Geometry = { "SideBorder" },
                    Mesh = 5,
                },
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    -- Mod = {BorderWarn = true, Track = true},
                    Model = {
                        LeftBlink = true,
                        RightBlink = true,
                        Prerender = (Common.Prerender == nil and true or Common.Prerender),
                        WheelMode = true,
                    },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, },
                },
                {
                    Views = { 32 },
                    Geometry = { "SideBorder" },
                    Mesh = 3,
                },
            },
        },
        [59] = {
            Viewport = 5,
            Contents = {
                {
                    Mesh = 5,
                    Views = { 38 },
                    TransParam = SideViewParam["R4"],
                },
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    -- Mod = {BorderWarn = true, Track = true},
                    Model = {
                        LeftBlink = true,
                        RightBlink = true,
                        Prerender = (Common.Prerender == nil and true or Common.Prerender),
                        WheelMode = true,
                    },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, },
                },
                {
                    Mesh = 3,
                    Views = { 36 },
                    TransParam = SideViewParam["R2"],
                },
            },
        },
        [69] = {
            Viewport = 5,
            Contents = {
                {
                    SideView = 4,
                    Mesh = 5,
                },
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    -- Mod = {BorderWarn = true, Track = true},
                    Model = {
                        LeftBlink = true,
                        RightBlink = true,
                        Prerender = (Common.Prerender == nil and true or Common.Prerender),
                        WheelMode = true,
                    },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, },
                },
                {
                    SideView = 2,
                    Mesh = 3,
                },
            },
        },
        [79] = {
            Viewport = 5,
            Contents = {
                {
                    SideView = 4,
                    Mesh = 5,
                    TransParam = SideViewParam["R4"]
                },
                {
                    Views = { 1 },
                    Mesh = 1,
                    Stream = true,
                    -- Mod = {BorderWarn = true, Track = true},
                    Model = {
                        LeftBlink = true,
                        RightBlink = true,
                        Prerender = (Common.Prerender == nil and true or Common.Prerender),
                        WheelMode = true,
                    },
                    Radar = { Front = true, Rear = true, Left = true, Right = true, },
                },
                {
                    SideView = 2,
                    Mesh = 3,
                    TransParam = SideViewParam["R2"],
                },
            },
        },
        [7] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Mod = { BorderWarn = true, BTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender) },
                    Backward = true,
                    Geometry = { "BAux", "BTrack", },
                    Radar = { Rear = true, Front = true, Left = true, Right = true },
                },
                {
                    SideView = SideViewMode[3] == 0 and 3 or nil,
                    Views = SideViewMode[3] == 1 and (Common.FollowUp == false and { 73 } or { 33, 33 }) or nil,
                    Mesh = 7,
                    Geometry = { "BAux", "BTrack", "Mod" },
                    Mod = { BTrack = true },
                },
            },
        },
        [67] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Mod = { BorderWarn = true, BTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender) },
                    Backward = true,
                    Radar = { Rear = true, Front = true, Left = true, Right = true },
                    Geometry = { "BAux", "BTrack", },
                },
                {
                    TransParam = Side3DParam.Rear,
                    Mesh = 1,
                    Model = {},
                    Geometry = { "BAux", "BTrack" },
                    Mod = { BTrack = true },
                    Radar = { Rear = true, Front = true },
                },
            },
        },
        [17] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Mod = { BorderWarn = true, BTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender) },
                    Backward = true,
                    Geometry = { "BAux", "BTrack", },
                    Radar = { Rear = true, Front = true, Left = true, Right = true },
                },
                {
                    SideView = SideViewMode[3] == 0 and 3 or nil,
                    Views = SideViewMode[3] == 1 and (Common.FollowUp == false and { 73 } or { 33, 33 }) or nil,
                    Mesh = 7,
                    Mod = { BTrack = true },
                    Geometry = { "BAux", "BTrack", "Mod" }
                },
            },
        },
        [27] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Mod = { BorderWarn = true, BTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender) },
                    Backward = true,
                    Geometry = { "BAux", "BTrack", },
                    Radar = { Rear = true, Front = true, Left = true, Right = true },
                },
                {
                    SideView = SideViewMode[3] == 0 and 3 or nil,
                    Views = SideViewMode[3] == 1 and (Common.FollowUp == false and { 73 } or { 33, 33 }) or nil,
                    Mesh = 7,
                    Mod = { BTrack = true },
                    Geometry = { "BAux", "BTrack", "Mod" }
                },
            },
        },
        [37] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Mod = { BorderWarn = true, BTrack = true },
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender) },
                    Backward = true,
                    Radar = { Rear = true, Front = true, Left = true, Right = true },
                    Geometry = { "BAux", "BTrack", },
                },
                {
                    TransParam = Rotate3DParam.Rear,
                    Mesh = 2,
                    Model = {},
                    Geometry = { "BAux", "BTrack" },
                    Mod = { BTrack = true },
                    Radar = { Rear = true, Front = true, Left = true, Right = true },
                },
            },
        },
        [54] = {
            Viewport = 9,
            Contents = {
                {
                    SideView = 1,
                    Mesh = 1,
                    TransParam = {
                        Camera = 1,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
                {
                    SideView = 3,
                    Mesh = 1,
                    TransParam = {
                        Camera = 3,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                }
            },
        },
        [64] = {
            Viewport = 10,
            Contents = {
                {
                    SideView = 1,
                    Mesh = 1,
                    TransParam = {
                        Camera = 1,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
                {
                    SideView = 3,
                    Mesh = 1,
                    TransParam = {
                        Camera = 3,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
                {
                    SideView = 2,
                    Mesh = 1,
                    TransParam = {
                        Camera = 2,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
                {
                    SideView = 4,
                    Mesh = 1,
                    TransParam = {
                        Camera = 4,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
            },
        },
        [74] = {
            Viewport = 11,
            Contents = {
                {
                    SideView = 1,
                    Mesh = 1,
                    TransParam = {
                        Camera = 1,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
                {
                    SideView = 2,
                    Mesh = 1,
                    TransParam = {
                        Camera = 2,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
                {
                    SideView = 4,
                    Mesh = 1,
                    TransParam = {
                        Camera = 4,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
                {
                    SideView = 5,
                    Mesh = 1,
                    TransParam = {
                        Camera = 5,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
                {
                    SideView = 6,
                    Mesh = 1,
                    TransParam = {
                        Camera = 6,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
            },
        },
        [84] = {
            Viewport = 11,
            Contents = {
                {
                    SideView = 1,
                    Mesh = 1,
                    TransParam = {
                        Camera = 1,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },

                {
                    SideView = 3,
                    Mesh = 1,
                    TransParam = {
                        Camera = 3,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },

                {
                    SideView = 5,
                    Mesh = 1,
                    TransParam = {
                        Camera = 5,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },

                {
                    SideView = 2,
                    Mesh = 1,
                    TransParam = {
                        Camera = 2,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },

                {
                    SideView = 4,
                    Mesh = 1,
                    TransParam = {
                        Camera = 4,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },


                {
                    SideView = 6,
                    Mesh = 1,
                    TransParam = {
                        Camera = 6,
                        Rotate = 0,
                        XOffset = 0.0,
                        XScale = 1.0,
                        YOffset = 0.0,
                        YScale = 1.0,
                    },
                },
            },
        },
        [26] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Mod = { BorderWarn = true, FTrack = true },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    SideView = SideViewMode[5] == 0 and 5 or nil,
                    Views = { 76 },
                    Mesh = 3,
                }
            },
        },
        [36] = {
            Viewport = 2,
            Contents = {
                {
                    Views = { 1 },
                    Mesh = 1,
                    Ring = true,
                    Stream = true,
                    Model = { Prerender = (Common.Prerender == nil and true or Common.Prerender), WheelMode = true, },
                    Geometry = { "FTrack", },
                    Mod = { BorderWarn = true, FTrack = true },
                    Radar = { Front = true, Left = true, Right = true, },
                },
                {
                    SideView = SideViewMode[6] == 0 and 6 or nil,
                    Views = { 77 },
                    Mesh = 3,
                }
            },
        },
        [46] = {
            Viewport = 12,
            Contents = {
                {
                    SideView = 5,
                    Mesh = 1,
                    TransParam = SideViewParam[5],
                },
                {
                    SideView = 6,
                    Mesh = 1,
                    TransParam = SideViewParam[6],
                }
            },
        },
        [56] = {
            Viewport = 1,
            Contents = {
                {
                    SideView = SideViewMode[1] == 0 and 1 or nil,
                    Views = SideViewMode[1] == 1 and (Common.FollowUp == false and { 71 } or { 31, 31 }) or nil,
                    Mesh = 6,
                    Geometry = { "FTrack", "RearDist", },
                },
            },
        },
        [66] = {
            Viewport = 1,
            Contents = {
                {
                    Views = { 32 },
                    Geometry = { "SideBorder" },
                    Mesh = 3,
                },
            },
        },
        [76] = {
            Viewport = 1,
            Contents = {
                {
                    SideView = SideViewMode[3] == 0 and 3 or nil,
                    Views = SideViewMode[3] == 1 and (Common.FollowUp == false and { 73 } or { 33, 33 }) or nil,
                    Mesh = 7,
                    Geometry = { "BAux", "BTrack", "Mod" }
                },
            },
        },
        [86] = {
            Viewport = 1,
            Contents = {
                {
                    Views = { 34 },
                    Geometry = { "SideBorder" },
                    Mesh = 5,
                },
            },
        },
        [58] = {
            Viewport = 1,
            Contents = {
                {
                    Views = { 60 },
                    Mesh = 2,
                    Stream = true,
                    Model = { WheelMode = true },
                    Geometry = { "FTrack", "RearDist", },
                },
            },
        },
        [68] = {
            Viewport = 1,
            Contents = {
                {
                    TransParam = Side3DParam.Right,
                    Stream = true,
                    Model = { WheelMode = true, RightBlink = true },
                    Geometry = { "FTrack" },
                    Mesh = 2,
                },
            },
        },
        [78] = {
            Viewport = 1,
            Contents = {
                {
                    Views = { 62 },
                    Mesh = 2,
                    Model = {},
                    Geometry = { "BAux", "BTrack" }
                },
            },
        },
        [88] = {
            Viewport = 1,
            Contents = {
                {
                    TransParam = Side3DParam.Left,
                    Stream = true,
                    Model = { WheelMode = true, LeftBlink = true },
                    Geometry = { "FTrack" },
                    Mesh = 2,
                },
            },
        },
        [89] = {
            Viewport = 1,
            Contents = {
                {
                    TransParam = Rotate3DParam.Right,
                    Stream = true,
                    Model = { WheelMode = true, RightBlink = true },
                    Geometry = { "FTrack" },
                    Mod = { FTrack = true },
                    Mesh = 2,
                },
            },
        },
        [90] = {
            Viewport = 1,
            Contents = {
                {
                    TransParam = Rotate3DParam.Left,
                    Stream = true,
                    Model = { WheelMode = true, LeftBlink = true },
                    Geometry = { "FTrack" },
                    Mod = { FTrack = true },
                    Mesh = 2
                },
            },
        },
        [96] = {
            Viewport = 9,
            Contents = {
                {
                    Views = { 34 },
                    Geometry = { "SideBorder" },
                    Mesh = 5,
                },
                {
                    Views = { 32 },
                    Geometry = { "SideBorder" },
                    Mesh = 3,
                },
            },
        },
    }
    return scene
end
Scenes = DefineScene()
