return {
    ["links"] = {
        ["48659897274D4A6B9611C41C86074A76"] = {
            [1] = "66EDF467E01C4F70959A6BB23B3953F4",
        },
        ["2B48FA53D9B34CCFB0CA8ED06C074D8E"] = {
            [1] = "8ECA0CCCFC074426929DE1048442CAF3",
        },
        ["D4CBC172897C4E08850B47799E755724"] = {
            [1] = "71A1A03AD4584D6EA02447C74C1973A2",
        },
        ["71A1A03AD4584D6EA02447C74C1973A2"] = {
            [1] = "225E29A45DB1439CBEF056F018E1C7E4",
        },
        ["7CE6529555024FD182429DA64677748F"] = {
            [1] = "52C7441327924A3182DDCBE8DB3690CE",
        },
        ["52C7441327924A3182DDCBE8DB3690CE"] = {
            [1] = "62B365A83CE446D5B756A638DB55A801",
        },
        ["66EDF467E01C4F70959A6BB23B3953F4"] = {
            [1] = "8A50D5DC423445079FC0DFB9DBF864F9",
        },
        ["8A50D5DC423445079FC0DFB9DBF864F9"] = {
            [1] = "2D2DE306659945C38744538E401E2A43",
        },
        ["6E7A693C05A646FAB593AF25DBAF7047"] = {
            [1] = "7CE6529555024FD182429DA64677748F",
            [2] = "D4CBC172897C4E08850B47799E755724",
            [3] = "48659897274D4A6B9611C41C86074A76",
        },
        ["225E29A45DB1439CBEF056F018E1C7E4"] = {
            [1] = "2B48FA53D9B34CCFB0CA8ED06C074D8E",
        },
    },
    ["nodes"] = {
        ["48659897274D4A6B9611C41C86074A76"] = {
            ["Desc"] = "释放碰撞体",
            ["Duration"] = 0,
            ["NodeTag"] = "48659897274D4A6B9611C41C86074A76",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 347,
                ["x"] = 467,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 1,
            ["Parallel"] = 0,
            ["Priority"] = 0,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["2D2DE306659945C38744538E401E2A43"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 347,
                ["x"] = 1193,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "2D2DE306659945C38744538E401E2A43",
            ["ID"] = 311122,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["1CA92197E72F4F66A77915141F84035C"] = {
            ["HitState"] = 1,
            ["Pos"] = {
                ["y"] = 438,
                ["x"] = 762,
            },
            ["Class"] = "CheckDamageBevNode",
            ["NodeTag"] = "1CA92197E72F4F66A77915141F84035C",
            ["SkillId"] = 311111,
            ["Static"] = false,
        },
        ["8ECA0CCCFC074426929DE1048442CAF3"] = {
            ["Desc"] = "行为",
            ["Pos"] = {
                ["y"] = 510,
                ["x"] = 1563,
            },
            ["Weight"] = 0,
            ["Class"] = "KillMySelfBevNode",
            ["NodeTag"] = "8ECA0CCCFC074426929DE1048442CAF3",
            ["Type"] = 0,
            ["IsCount"] = 1,
            ["Static"] = false,
        },
        ["2B48FA53D9B34CCFB0CA8ED06C074D8E"] = {
            ["Desc"] = "行为",
            ["Pos"] = {
                ["y"] = 591,
                ["x"] = 1305,
            },
            ["Weight"] = 0,
            ["Class"] = "InterruptAIBevNode",
            ["NodeTag"] = "2B48FA53D9B34CCFB0CA8ED06C074D8E",
            ["Type"] = 0,
            ["InterruptWay"] = 2,
            ["Static"] = false,
        },
        ["D4CBC172897C4E08850B47799E755724"] = {
            ["Desc"] = "道具被拾取后销毁",
            ["Duration"] = 100,
            ["NodeTag"] = "D4CBC172897C4E08850B47799E755724",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 503,
                ["x"] = 389,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Parallel"] = 1,
            ["Priority"] = 0,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["71A1A03AD4584D6EA02447C74C1973A2"] = {
            ["CheckState"] = 1,
            ["Pos"] = {
                ["y"] = 531,
                ["x"] = 786,
            },
            ["MonsterId"] = 0,
            ["Class"] = "CheckStateBevNode",
            ["NodeTag"] = "71A1A03AD4584D6EA02447C74C1973A2",
            ["CheckHero"] = 0,
            ["StateId"] = 73,
            ["Static"] = false,
        },
        ["6E7A693C05A646FAB593AF25DBAF7047"] = {
            ["Desc"] = "减伤道具怪物",
            ["Pos"] = {
                ["y"] = 300,
                ["x"] = 250,
            },
            ["Category"] = 1,
            ["Class"] = "RootNode",
            ["NodeTag"] = "6E7A693C05A646FAB593AF25DBAF7047",
            ["ID"] = "999174",
            ["Name"] = "减伤道具怪物",
            ["Static"] = true,
        },
        ["7CE6529555024FD182429DA64677748F"] = {
            ["Desc"] = "定时销毁\
",
            ["Duration"] = 0,
            ["NodeTag"] = "7CE6529555024FD182429DA64677748F",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 222,
                ["x"] = 461,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Parallel"] = 0,
            ["Priority"] = 100,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["52C7441327924A3182DDCBE8DB3690CE"] = {
            ["Pos"] = {
                ["y"] = 230,
                ["x"] = 723,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "52C7441327924A3182DDCBE8DB3690CE",
            ["Duration"] = 10000,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["66EDF467E01C4F70959A6BB23B3953F4"] = {
            ["Pos"] = {
                ["y"] = 360,
                ["x"] = 711,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "66EDF467E01C4F70959A6BB23B3953F4",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["8A50D5DC423445079FC0DFB9DBF864F9"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 349,
                ["x"] = 978,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "8A50D5DC423445079FC0DFB9DBF864F9",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["62B365A83CE446D5B756A638DB55A801"] = {
            ["Desc"] = "行为",
            ["Pos"] = {
                ["y"] = 223,
                ["x"] = 1031,
            },
            ["Weight"] = 0,
            ["Class"] = "KillMySelfBevNode",
            ["NodeTag"] = "62B365A83CE446D5B756A638DB55A801",
            ["Type"] = 0,
            ["IsCount"] = 1,
            ["Static"] = false,
        },
        ["225E29A45DB1439CBEF056F018E1C7E4"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 504,
                ["x"] = 1177,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "225E29A45DB1439CBEF056F018E1C7E4",
            ["Type"] = 0,
            ["Static"] = false,
        },
    },
    ["root"] = "6E7A693C05A646FAB593AF25DBAF7047",
}