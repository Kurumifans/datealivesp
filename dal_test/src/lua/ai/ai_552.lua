return {
    ["links"] = {
        ["78B769AAF06442A0ABDCF97C98284F86"] = {
            [1] = "03CEAF2A88794C2CA376D876B0C8379A",
        },
        ["471926B7F4D2415BA42B30D97D303E14"] = {
            [1] = "FF28B0EAF84B4A2793F69536BF0B96A6",
            [2] = "78B769AAF06442A0ABDCF97C98284F86",
        },
        ["5644F4BA74954D329F95F54F74627A4C"] = {
            [1] = "6A8F38DAD60244E289AC2BAE98AD9F54",
        },
        ["4B0A0C6FDB4D4411B7E2C70BEDA2D869"] = {
            [1] = "8CE7E4B7D4AC41FF98B145515D968649",
        },
        ["EA0D18F8EB58419DAB38337AA94567EA"] = {
            [1] = "711396D9C1B34958870908CA364A2153",
        },
        ["EE9BBA98499344558DC43225C7903135"] = {
            [1] = "4B0A0C6FDB4D4411B7E2C70BEDA2D869",
        },
        ["62E5807C789E4F1C858C433E6725520F"] = {
            [1] = "6AB6CD60A95147ADB77E1CE6A24AFE3E",
        },
        ["4804848BEDB645769A946956F518ACFE"] = {
            [1] = "EE9BBA98499344558DC43225C7903135",
        },
        ["12944AA353444237B12AF44E9EE998AF"] = {
            [1] = "94B8FE88F0C44266B1FA5C621662A9C1",
        },
        ["03CEAF2A88794C2CA376D876B0C8379A"] = {
            [1] = "7CF22F243AA2476092C2CCD33F7A550A",
        },
        ["768D2CCA84884A06AF834B3299052885"] = {
            [1] = "4804848BEDB645769A946956F518ACFE",
        },
        ["6A8F38DAD60244E289AC2BAE98AD9F54"] = {
            [1] = "62E5807C789E4F1C858C433E6725520F",
        },
        ["FF28B0EAF84B4A2793F69536BF0B96A6"] = {
            [1] = "03CEAF2A88794C2CA376D876B0C8379A",
        },
        ["8E7A4B66B4A34757883A00276DCCF8C0"] = {
            [1] = "5644F4BA74954D329F95F54F74627A4C",
        },
        ["0E7C6FB79FCB479AACBD03A7A10C9A1E"] = {
            [1] = "EA0D18F8EB58419DAB38337AA94567EA",
        },
        ["5E112D91E800409E8A23B12CCF0B5F29"] = {
            [1] = "67A43E27394C444FA1E601B452B0A543",
        },
        ["711396D9C1B34958870908CA364A2153"] = {
            [1] = "98CD06A449B146918EF02AA0CAE348F0",
        },
        ["BC94AE172DAD4210B73F1EAC9C32338F"] = {
            [1] = "471926B7F4D2415BA42B30D97D303E14",
            [2] = "5E112D91E800409E8A23B12CCF0B5F29",
            [3] = "768D2CCA84884A06AF834B3299052885",
            [4] = "8E7A4B66B4A34757883A00276DCCF8C0",
            [5] = "0E7C6FB79FCB479AACBD03A7A10C9A1E",
        },
        ["67A43E27394C444FA1E601B452B0A543"] = {
            [1] = "12944AA353444237B12AF44E9EE998AF",
        },
    },
    ["nodes"] = {
        ["78B769AAF06442A0ABDCF97C98284F86"] = {
            ["Pos"] = {
                ["y"] = 781,
                ["x"] = 673,
            },
            ["Property"] = 54,
            ["Class"] = "ConditionPropertyNode",
            ["NodeTag"] = "78B769AAF06442A0ABDCF97C98284F86",
            ["Value"] = 0,
            ["Judge"] = 3,
            ["Static"] = false,
        },
        ["471926B7F4D2415BA42B30D97D303E14"] = {
            ["Desc"] = "羁绊buff\
",
            ["Duration"] = 1000,
            ["NodeTag"] = "471926B7F4D2415BA42B30D97D303E14",
            ["TriggerType"] = 1,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 713,
                ["x"] = 397,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Parallel"] = 1,
            ["Priority"] = 5,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["5644F4BA74954D329F95F54F74627A4C"] = {
            ["Pos"] = {
                ["y"] = 195,
                ["x"] = 640,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "5644F4BA74954D329F95F54F74627A4C",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["4B0A0C6FDB4D4411B7E2C70BEDA2D869"] = {
            ["Desc"] = "行为",
            ["LimitArea"] = 150,
            ["Weight"] = 0,
            ["NodeTag"] = "4B0A0C6FDB4D4411B7E2C70BEDA2D869",
            ["RangeOrigin"] = {
                ["y"] = -15,
                ["x"] = -300,
            },
            ["RunWeight"] = 0,
            ["Static"] = false,
            ["FixTarget"] = 0,
            ["Pos"] = {
                ["y"] = 411,
                ["x"] = 1101,
            },
            ["Class"] = "PathfindingBevNode",
            ["WalkWeight"] = 0,
            ["RangeSize"] = {
                ["height"] = 30,
                ["width"] = 600,
            },
            ["WalkDistance"] = 0,
            ["Type"] = 0,
        },
        ["6AB6CD60A95147ADB77E1CE6A24AFE3E"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 158,
                ["x"] = 1225,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "6AB6CD60A95147ADB77E1CE6A24AFE3E",
            ["ID"] = 309910,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["EA0D18F8EB58419DAB38337AA94567EA"] = {
            ["Pos"] = {
                ["y"] = 321,
                ["x"] = 638,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "EA0D18F8EB58419DAB38337AA94567EA",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["EE9BBA98499344558DC43225C7903135"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 428,
                ["x"] = 930,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "EE9BBA98499344558DC43225C7903135",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["62E5807C789E4F1C858C433E6725520F"] = {
            ["Desc"] = "行为",
            ["LimitArea"] = 50,
            ["Weight"] = 10,
            ["NodeTag"] = "62E5807C789E4F1C858C433E6725520F",
            ["RangeOrigin"] = {
                ["y"] = -15,
                ["x"] = -150,
            },
            ["RunWeight"] = 0,
            ["Static"] = false,
            ["FixTarget"] = 0,
            ["Pos"] = {
                ["y"] = 158,
                ["x"] = 1083,
            },
            ["Class"] = "PathfindingBevNode",
            ["WalkWeight"] = 0,
            ["RangeSize"] = {
                ["height"] = 30,
                ["width"] = 300,
            },
            ["WalkDistance"] = 0,
            ["Type"] = 0,
        },
        ["4804848BEDB645769A946956F518ACFE"] = {
            ["Pos"] = {
                ["y"] = 433,
                ["x"] = 633,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "4804848BEDB645769A946956F518ACFE",
            ["Duration"] = 7000,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["94B8FE88F0C44266B1FA5C621662A9C1"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 545,
                ["x"] = 1138,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "94B8FE88F0C44266B1FA5C621662A9C1",
            ["ID"] = 309950,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["0E7C6FB79FCB479AACBD03A7A10C9A1E"] = {
            ["Desc"] = "巡逻\
",
            ["Duration"] = 0,
            ["NodeTag"] = "0E7C6FB79FCB479AACBD03A7A10C9A1E",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 298,
                ["x"] = 414,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 1,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["12944AA353444237B12AF44E9EE998AF"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 546,
                ["x"] = 932,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "12944AA353444237B12AF44E9EE998AF",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["5E112D91E800409E8A23B12CCF0B5F29"] = {
            ["Desc"] = "回血",
            ["Duration"] = 0,
            ["NodeTag"] = "5E112D91E800409E8A23B12CCF0B5F29",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 549,
                ["x"] = 401,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 1,
            ["Parallel"] = 0,
            ["Priority"] = 4,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["03CEAF2A88794C2CA376D876B0C8379A"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 726,
                ["x"] = 1026,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "03CEAF2A88794C2CA376D876B0C8379A",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["768D2CCA84884A06AF834B3299052885"] = {
            ["Desc"] = "滚动\
",
            ["Duration"] = 7000,
            ["NodeTag"] = "768D2CCA84884A06AF834B3299052885",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 414,
                ["x"] = 420,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 3,
            ["DurationInterval"] = {
                [1] = 1000,
                [2] = 1000,
            },
        },
        ["7CF22F243AA2476092C2CCD33F7A550A"] = {
            ["Desc"] = "行为",
            ["Pos"] = {
                ["y"] = 731,
                ["x"] = 1283,
            },
            ["Weight"] = 0,
            ["Class"] = "TriggerBufferBevNode",
            ["NodeTag"] = "7CF22F243AA2476092C2CCD33F7A550A",
            ["Type"] = 0,
            ["BufferID"] = 929,
            ["Static"] = false,
        },
        ["6A8F38DAD60244E289AC2BAE98AD9F54"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 170,
                ["x"] = 889,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "6A8F38DAD60244E289AC2BAE98AD9F54",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["FF28B0EAF84B4A2793F69536BF0B96A6"] = {
            ["Pos"] = {
                ["y"] = 684,
                ["x"] = 694,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "FF28B0EAF84B4A2793F69536BF0B96A6",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["8CE7E4B7D4AC41FF98B145515D968649"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 422,
                ["x"] = 1281,
            },
            ["Weight"] = 10,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "8CE7E4B7D4AC41FF98B145515D968649",
            ["ID"] = 309940,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["98CD06A449B146918EF02AA0CAE348F0"] = {
            ["Desc"] = "行为",
            ["Weight"] = 0,
            ["NodeTag"] = "98CD06A449B146918EF02AA0CAE348F0",
            ["RunWeight"] = 0,
            ["WalkDistance"] = 0,
            ["Pos"] = {
                ["y"] = 312,
                ["x"] = 1078,
            },
            ["Class"] = "PatrolBevNode",
            ["WalkWeight"] = 0,
            ["TriggerType"] = 2,
            ["Static"] = false,
            ["Type"] = 9,
        },
        ["BC94AE172DAD4210B73F1EAC9C32338F"] = {
            ["Desc"] = "新的 AI",
            ["Pos"] = {
                ["y"] = 300,
                ["x"] = 214,
            },
            ["Category"] = 13,
            ["Class"] = "RootNode",
            ["NodeTag"] = "BC94AE172DAD4210B73F1EAC9C32338F",
            ["ID"] = "552",
            ["Name"] = "年兽-年-滚动",
            ["Static"] = true,
        },
        ["711396D9C1B34958870908CA364A2153"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 310,
                ["x"] = 909,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "711396D9C1B34958870908CA364A2153",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["8E7A4B66B4A34757883A00276DCCF8C0"] = {
            ["Desc"] = "普攻",
            ["Duration"] = 1500,
            ["NodeTag"] = "8E7A4B66B4A34757883A00276DCCF8C0",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 192,
                ["x"] = 414,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 2,
            ["DurationInterval"] = {
                [1] = 200,
                [2] = 200,
            },
        },
        ["67A43E27394C444FA1E601B452B0A543"] = {
            ["Pos"] = {
                ["y"] = 548,
                ["x"] = 664,
            },
            ["Class"] = "ConditionSelfHPLessNode",
            ["NodeTag"] = "67A43E27394C444FA1E601B452B0A543",
            ["Percent"] = 30,
            ["Type"] = 4,
            ["Static"] = false,
        },
    },
    ["root"] = "BC94AE172DAD4210B73F1EAC9C32338F",
}