return {
    ["links"] = {
        ["3505E382A7544EE2B90B4E3CF55A4C03"] = {
            [1] = "A77A97BB5CCB4203AD40A1B1F2A9B27A",
        },
        ["9819F6D899A146C68C5BA9627C8AF861"] = {
            [1] = "177D2999CC624B62864E5BC5AB34D465",
        },
        ["BDC25A6AE24A4592B9F81B8F1190274D"] = {
            [1] = "93DFB855C064456DB9000D9D8F8DF156",
        },
        ["A77A97BB5CCB4203AD40A1B1F2A9B27A"] = {
            [1] = "2EE9DA2F12894C1893E1D973F145F486",
            [2] = "117FAAFF7DB74678AD25C8F97BEF3045",
        },
        ["EB33A5DE88414BD39580766ED5745B34"] = {
            [1] = "6845CF3A9C9F45968CE957B5D4CDF41B",
        },
        ["33924B878C3E4FC8A15E69018F6AB161"] = {
            [1] = "8E24AB6247D4408BBC94D5CFD7B997A4",
        },
        ["85A8873EE9324E589495E14A17C2EBF3"] = {
            [1] = "3505E382A7544EE2B90B4E3CF55A4C03",
        },
        ["75A875274BED4B1AA2CD26DF76FF7D4E"] = {
            [1] = "1989B20E214F45558238612D4CBBE722",
        },
        ["6F5DB412D6454F3EB28231669D26F24C"] = {
            [1] = "BFA22C78BBA24438B74F74F836E0A1BE",
        },
        ["8E24AB6247D4408BBC94D5CFD7B997A4"] = {
            [1] = "088CECE2150D40F6A9C98AE28DCF3524",
        },
        ["B43B308F70F84FF1B6FD61D58B9E632F"] = {
            [1] = "75A875274BED4B1AA2CD26DF76FF7D4E",
        },
        ["F704226FA6C74EC6A3C6BF7A0A01030D"] = {
            [1] = "6F5DB412D6454F3EB28231669D26F24C",
            [2] = "B43B308F70F84FF1B6FD61D58B9E632F",
            [3] = "33924B878C3E4FC8A15E69018F6AB161",
            [4] = "9819F6D899A146C68C5BA9627C8AF861",
            [5] = "2D6EEDDE2CE0484492D4AAA889C5CBF6",
            [6] = "85A8873EE9324E589495E14A17C2EBF3",
        },
        ["BFA22C78BBA24438B74F74F836E0A1BE"] = {
            [1] = "BDC25A6AE24A4592B9F81B8F1190274D",
        },
        ["177D2999CC624B62864E5BC5AB34D465"] = {
            [1] = "6C26242DE73A45DF95446B8DDC6E066B",
        },
        ["2D6EEDDE2CE0484492D4AAA889C5CBF6"] = {
            [1] = "EB33A5DE88414BD39580766ED5745B34",
        },
    },
    ["nodes"] = {
        ["3505E382A7544EE2B90B4E3CF55A4C03"] = {
            ["HurtValue"] = 1,
            ["Pos"] = {
                ["y"] = 8,
                ["x"] = 681,
            },
            ["SkillHurt"] = 1,
            ["Class"] = "CheckHurtTypeBevNode",
            ["NodeTag"] = "3505E382A7544EE2B90B4E3CF55A4C03",
            ["hurtTime"] = 100,
            ["NormalHurt"] = 1,
            ["Static"] = false,
        },
        ["9819F6D899A146C68C5BA9627C8AF861"] = {
            ["Desc"] = "????????????",
            ["Duration"] = 2000,
            ["NodeTag"] = "9819F6D899A146C68C5BA9627C8AF861",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 524,
                ["x"] = 399,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 50,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["A77A97BB5CCB4203AD40A1B1F2A9B27A"] = {
            ["Desc"] = "????????????\
20%??????",
            ["Pos"] = {
                ["y"] = 2,
                ["x"] = 1105,
            },
            ["Weight"] = 0,
            ["Class"] = "RandomBevNode",
            ["NodeTag"] = "A77A97BB5CCB4203AD40A1B1F2A9B27A",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["2D6EEDDE2CE0484492D4AAA889C5CBF6"] = {
            ["Desc"] = "??????",
            ["Duration"] = 0,
            ["NodeTag"] = "2D6EEDDE2CE0484492D4AAA889C5CBF6",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 674,
                ["x"] = 410,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 1,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["6C26242DE73A45DF95446B8DDC6E066B"] = {
            ["Desc"] = "??????",
            ["Pos"] = {
                ["y"] = 529,
                ["x"] = 952,
            },
            ["Weight"] = 100,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "6C26242DE73A45DF95446B8DDC6E066B",
            ["ID"] = 700110,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["6F5DB412D6454F3EB28231669D26F24C"] = {
            ["Desc"] = "????????????",
            ["Duration"] = 10000,
            ["NodeTag"] = "6F5DB412D6454F3EB28231669D26F24C",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 114,
                ["x"] = 387,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Parallel"] = 2,
            ["Priority"] = 100,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["75A875274BED4B1AA2CD26DF76FF7D4E"] = {
            ["Pos"] = {
                ["y"] = 221,
                ["x"] = 636,
            },
            ["Class"] = "ConditionTargetDistanceNode",
            ["NodeTag"] = "75A875274BED4B1AA2CD26DF76FF7D4E",
            ["RangeY"] = {
                [1] = 0,
                [2] = 100,
            },
            ["RangeX"] = {
                [1] = 0,
                [2] = 800,
            },
            ["Static"] = false,
        },
        ["F704226FA6C74EC6A3C6BF7A0A01030D"] = {
            ["Desc"] = "????????????-??????1",
            ["Pos"] = {
                ["y"] = 359,
                ["x"] = 132,
            },
            ["Category"] = 1,
            ["Class"] = "RootNode",
            ["NodeTag"] = "F704226FA6C74EC6A3C6BF7A0A01030D",
            ["ID"] = "999111",
            ["Name"] = "????????????-??????1",
            ["Static"] = true,
        },
        ["177D2999CC624B62864E5BC5AB34D465"] = {
            ["Pos"] = {
                ["y"] = 525,
                ["x"] = 663,
            },
            ["Class"] = "ConditionTargetDistanceNode",
            ["NodeTag"] = "177D2999CC624B62864E5BC5AB34D465",
            ["RangeY"] = {
                [1] = 0,
                [2] = 50,
            },
            ["RangeX"] = {
                [1] = 0,
                [2] = 300,
            },
            ["Static"] = false,
        },
        ["088CECE2150D40F6A9C98AE28DCF3524"] = {
            ["Desc"] = "??????1-??????",
            ["Pos"] = {
                ["y"] = 371,
                ["x"] = 955,
            },
            ["Weight"] = 50,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "088CECE2150D40F6A9C98AE28DCF3524",
            ["ID"] = 700120,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["B43B308F70F84FF1B6FD61D58B9E632F"] = {
            ["Desc"] = "????????????",
            ["Duration"] = 8000,
            ["NodeTag"] = "B43B308F70F84FF1B6FD61D58B9E632F",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 217,
                ["x"] = 390,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 90,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["EB33A5DE88414BD39580766ED5745B34"] = {
            ["Pos"] = {
                ["y"] = 686,
                ["x"] = 644,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "EB33A5DE88414BD39580766ED5745B34",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["8E24AB6247D4408BBC94D5CFD7B997A4"] = {
            ["Pos"] = {
                ["y"] = 377,
                ["x"] = 666,
            },
            ["Class"] = "ConditionTargetDistanceNode",
            ["NodeTag"] = "8E24AB6247D4408BBC94D5CFD7B997A4",
            ["RangeY"] = {
                [1] = 0,
                [2] = 100,
            },
            ["RangeX"] = {
                [1] = 0,
                [2] = 300,
            },
            ["Static"] = false,
        },
        ["85A8873EE9324E589495E14A17C2EBF3"] = {
            ["Desc"] = "????????????",
            ["Duration"] = 100,
            ["NodeTag"] = "85A8873EE9324E589495E14A17C2EBF3",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 0,
                ["x"] = 388,
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
        ["93DFB855C064456DB9000D9D8F8DF156"] = {
            ["Desc"] = "??????",
            ["Pos"] = {
                ["y"] = 115,
                ["x"] = 1065,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "93DFB855C064456DB9000D9D8F8DF156",
            ["ID"] = 700130,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["2EE9DA2F12894C1893E1D973F145F486"] = {
            ["Desc"] = "??????",
            ["Weight"] = 4,
            ["NodeTag"] = "2EE9DA2F12894C1893E1D973F145F486",
            ["Reset"] = 1,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 67,
                ["x"] = 1371,
            },
            ["AddValue"] = 0,
            ["Class"] = "AssociationBevNode",
            ["DelayTime"] = 0,
            ["Key"] = "wuyiyi",
            ["Type"] = 0,
        },
        ["6845CF3A9C9F45968CE957B5D4CDF41B"] = {
            ["Desc"] = "??????",
            ["Weight"] = 0,
            ["NodeTag"] = "6845CF3A9C9F45968CE957B5D4CDF41B",
            ["RunWeight"] = 0,
            ["WalkDistance"] = 0,
            ["Pos"] = {
                ["y"] = 682,
                ["x"] = 932,
            },
            ["Class"] = "PatrolBevNode",
            ["WalkWeight"] = 0,
            ["TriggerType"] = 2,
            ["Static"] = false,
            ["Type"] = 9,
        },
        ["1989B20E214F45558238612D4CBBE722"] = {
            ["Desc"] = "??????2-????????????",
            ["Pos"] = {
                ["y"] = 216,
                ["x"] = 944,
            },
            ["Weight"] = 20,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "1989B20E214F45558238612D4CBBE722",
            ["ID"] = 700140,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["33924B878C3E4FC8A15E69018F6AB161"] = {
            ["Desc"] = "700120-??????k  \
700130-??????i\
700140-????????????l\
700150-??????h\
700160-??????m\
700190-??????u",
            ["Duration"] = 5000,
            ["NodeTag"] = "33924B878C3E4FC8A15E69018F6AB161",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 342,
                ["x"] = 359,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 80,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["BFA22C78BBA24438B74F74F836E0A1BE"] = {
            ["Desc"] = "????????????",
            ["Pos"] = {
                ["y"] = 115,
                ["x"] = 607,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "BFA22C78BBA24438B74F74F836E0A1BE",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["BDC25A6AE24A4592B9F81B8F1190274D"] = {
            ["Desc"] = "??????",
            ["Pos"] = {
                ["y"] = 113,
                ["x"] = 774,
            },
            ["Weight"] = 1,
            ["Class"] = "InterruptAIBevNode",
            ["NodeTag"] = "BDC25A6AE24A4592B9F81B8F1190274D",
            ["Type"] = 0,
            ["InterruptWay"] = 2,
            ["Static"] = false,
        },
        ["117FAAFF7DB74678AD25C8F97BEF3045"] = {
            ["Desc"] = "??????",
            ["Pos"] = {
                ["y"] = -10,
                ["x"] = 1347,
            },
            ["Weight"] = 1,
            ["Class"] = "ChooseAILinkBevNode",
            ["NodeTag"] = "117FAAFF7DB74678AD25C8F97BEF3045",
            ["ChooseLinkId"] = 100,
            ["Type"] = 0,
            ["Static"] = false,
        },
    },
    ["root"] = "F704226FA6C74EC6A3C6BF7A0A01030D",
}