return {
    ["links"] = {
        ["2158BDD84512466C9CA40868378AC21F"] = {
            [1] = "1BA7A6934141456593E736E481EC892E",
        },
        ["84AB46CD6CD745C5A69F994BBBC58001"] = {
            [1] = "D54EBE2895E247B2B9DC883BC313071E",
        },
        ["C68990A683934CE3A49F607D5734FC3F"] = {
            [1] = "D597AED933DB40B18AC4EB171D911A02",
        },
        ["D704D239E4C344C9BFEE4E9BD06EB47F"] = {
            [1] = "4F74DC1CAB7A43758A737A67F2159D16",
        },
        ["B93FC49D0C0943E2B1B037AF3BC0016B"] = {
            [1] = "C8F145F19BE741768C8C5F7ECD43EEC8",
        },
        ["728A022A0C0D476A9CCFBFFFF52FD250"] = {
            [1] = "B93FC49D0C0943E2B1B037AF3BC0016B",
            [2] = "2158BDD84512466C9CA40868378AC21F",
            [3] = "84AB46CD6CD745C5A69F994BBBC58001",
            [4] = "C68990A683934CE3A49F607D5734FC3F",
        },
        ["4027C3866F304000AFA7D35A2B2C6E27"] = {
            [1] = "D584F1DAEDA6417D96B6C696DD0B8D6F",
        },
        ["C96EF13DA34A4AB38F2B1946553979A9"] = {
            [1] = "C3A5C27DA02F46C5A1051544C308338A",
            [2] = "D704D239E4C344C9BFEE4E9BD06EB47F",
        },
        ["C3A5C27DA02F46C5A1051544C308338A"] = {
            [1] = "B8E848856C9E436D98185232AED87BAE",
            [2] = "4027C3866F304000AFA7D35A2B2C6E27",
        },
        ["B8E848856C9E436D98185232AED87BAE"] = {
            [1] = "D584F1DAEDA6417D96B6C696DD0B8D6F",
        },
        ["D584F1DAEDA6417D96B6C696DD0B8D6F"] = {
            [1] = "18666D84035C457E830B779A5D952B80",
        },
        ["4F74DC1CAB7A43758A737A67F2159D16"] = {
            [1] = "728A022A0C0D476A9CCFBFFFF52FD250",
        },
    },
    ["nodes"] = {
        ["C68990A683934CE3A49F607D5734FC3F"] = {
            ["Desc"] = "行为",
            ["LimitArea"] = 200,
            ["Weight"] = 10,
            ["NodeTag"] = "C68990A683934CE3A49F607D5734FC3F",
            ["RangeOrigin"] = {
                ["y"] = -20,
                ["x"] = -500,
            },
            ["RunWeight"] = 0,
            ["Static"] = false,
            ["FixTarget"] = 0,
            ["Pos"] = {
                ["y"] = 461,
                ["x"] = 992,
            },
            ["Class"] = "PathfindingBevNode",
            ["WalkWeight"] = 0,
            ["RangeSize"] = {
                ["height"] = 40,
                ["width"] = 1000,
            },
            ["WalkDistance"] = 0,
            ["Type"] = 0,
        },
        ["4027C3866F304000AFA7D35A2B2C6E27"] = {
            ["OperatorY"] = 2,
            ["Pos"] = {
                ["y"] = 658,
                ["x"] = 555,
            },
            ["OperatorX"] = 2,
            ["Class"] = "ConditionPlayerDistanceNode",
            ["NodeTag"] = "4027C3866F304000AFA7D35A2B2C6E27",
            ["DistanceY"] = 10,
            ["DistanceX"] = 100,
            ["Static"] = false,
        },
        ["18666D84035C457E830B779A5D952B80"] = {
            ["Desc"] = "行为",
            ["Pos"] = {
                ["y"] = 580,
                ["x"] = 1066,
            },
            ["Weight"] = 0,
            ["Class"] = "FollowBevNode",
            ["NodeTag"] = "18666D84035C457E830B779A5D952B80",
            ["Distance"] = 100,
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["C96EF13DA34A4AB38F2B1946553979A9"] = {
            ["Desc"] = "新的 AI",
            ["Pos"] = {
                ["y"] = 322,
                ["x"] = 52,
            },
            ["Category"] = 6,
            ["Class"] = "RootNode",
            ["NodeTag"] = "C96EF13DA34A4AB38F2B1946553979A9",
            ["ID"] = "110801",
            ["Name"] = "助战夕弦",
            ["Static"] = true,
        },
        ["D54EBE2895E247B2B9DC883BC313071E"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 362,
                ["x"] = 1137,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "D54EBE2895E247B2B9DC883BC313071E",
            ["ID"] = 100880,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["D597AED933DB40B18AC4EB171D911A02"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 457,
                ["x"] = 1142,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "D597AED933DB40B18AC4EB171D911A02",
            ["ID"] = 100820,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["D584F1DAEDA6417D96B6C696DD0B8D6F"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 580,
                ["x"] = 865,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "D584F1DAEDA6417D96B6C696DD0B8D6F",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["728A022A0C0D476A9CCFBFFFF52FD250"] = {
            ["Desc"] = "随机行为",
            ["Pos"] = {
                ["y"] = 252,
                ["x"] = 814,
            },
            ["Weight"] = 0,
            ["Class"] = "RandomBevNode",
            ["NodeTag"] = "728A022A0C0D476A9CCFBFFFF52FD250",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["D704D239E4C344C9BFEE4E9BD06EB47F"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 1000,
            ["NodeTag"] = "D704D239E4C344C9BFEE4E9BD06EB47F",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 323,
                ["x"] = 299,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 1,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["4F74DC1CAB7A43758A737A67F2159D16"] = {
            ["Pos"] = {
                ["y"] = 330,
                ["x"] = 540,
            },
            ["EnemyNum"] = 1,
            ["Class"] = "ConditionEnemyAliveNode",
            ["NodeTag"] = "4F74DC1CAB7A43758A737A67F2159D16",
            ["Operator"] = 2,
            ["Static"] = false,
        },
        ["84AB46CD6CD745C5A69F994BBBC58001"] = {
            ["Desc"] = "行为",
            ["LimitArea"] = 200,
            ["Weight"] = 20,
            ["NodeTag"] = "84AB46CD6CD745C5A69F994BBBC58001",
            ["RangeOrigin"] = {
                ["y"] = -20,
                ["x"] = -500,
            },
            ["RunWeight"] = 0,
            ["Static"] = false,
            ["FixTarget"] = 0,
            ["Pos"] = {
                ["y"] = 366,
                ["x"] = 989,
            },
            ["Class"] = "PathfindingBevNode",
            ["WalkWeight"] = 0,
            ["RangeSize"] = {
                ["height"] = 40,
                ["width"] = 1000,
            },
            ["WalkDistance"] = 0,
            ["Type"] = 0,
        },
        ["2158BDD84512466C9CA40868378AC21F"] = {
            ["Desc"] = "行为",
            ["LimitArea"] = 200,
            ["Weight"] = 30,
            ["NodeTag"] = "2158BDD84512466C9CA40868378AC21F",
            ["RangeOrigin"] = {
                ["y"] = -20,
                ["x"] = -500,
            },
            ["RunWeight"] = 0,
            ["Static"] = false,
            ["FixTarget"] = 0,
            ["Pos"] = {
                ["y"] = 246,
                ["x"] = 990,
            },
            ["Class"] = "PathfindingBevNode",
            ["WalkWeight"] = 0,
            ["RangeSize"] = {
                ["height"] = 40,
                ["width"] = 1000,
            },
            ["WalkDistance"] = 0,
            ["Type"] = 0,
        },
        ["B8E848856C9E436D98185232AED87BAE"] = {
            ["Pos"] = {
                ["y"] = 509,
                ["x"] = 550,
            },
            ["EnemyNum"] = 1,
            ["Class"] = "ConditionEnemyAliveNode",
            ["NodeTag"] = "B8E848856C9E436D98185232AED87BAE",
            ["Operator"] = 1,
            ["Static"] = false,
        },
        ["C8F145F19BE741768C8C5F7ECD43EEC8"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 125,
                ["x"] = 1133,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "C8F145F19BE741768C8C5F7ECD43EEC8",
            ["ID"] = 100810,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["B93FC49D0C0943E2B1B037AF3BC0016B"] = {
            ["Desc"] = "行为",
            ["LimitArea"] = 200,
            ["Weight"] = 10,
            ["NodeTag"] = "B93FC49D0C0943E2B1B037AF3BC0016B",
            ["RangeOrigin"] = {
                ["y"] = -20,
                ["x"] = -500,
            },
            ["RunWeight"] = 0,
            ["Static"] = false,
            ["FixTarget"] = 0,
            ["Pos"] = {
                ["y"] = 128,
                ["x"] = 990,
            },
            ["Class"] = "PathfindingBevNode",
            ["WalkWeight"] = 0,
            ["RangeSize"] = {
                ["height"] = 40,
                ["width"] = 1000,
            },
            ["WalkDistance"] = 0,
            ["Type"] = 0,
        },
        ["C3A5C27DA02F46C5A1051544C308338A"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 2000,
            ["NodeTag"] = "C3A5C27DA02F46C5A1051544C308338A",
            ["TriggerType"] = 1,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 575,
                ["x"] = 281,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 2,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["1BA7A6934141456593E736E481EC892E"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 252,
                ["x"] = 1136,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "1BA7A6934141456593E736E481EC892E",
            ["ID"] = 100870,
            ["Type"] = 1,
            ["Static"] = false,
        },
    },
    ["root"] = "C96EF13DA34A4AB38F2B1946553979A9",
}