return {
    ["links"] = {
        ["728A022A0C0D476A9CCFBFFFF52FD250"] = {
            [1] = "C8F145F19BE741768C8C5F7ECD43EEC8",
            [2] = "1BA7A6934141456593E736E481EC892E",
            [3] = "D54EBE2895E247B2B9DC883BC313071E",
        },
        ["F1352CD93AAA4E6CB18CE5274AC77BCE"] = {
            [1] = "728A022A0C0D476A9CCFBFFFF52FD250",
        },
        ["D704D239E4C344C9BFEE4E9BD06EB47F"] = {
            [1] = "F1352CD93AAA4E6CB18CE5274AC77BCE",
        },
        ["698EAF09F9BE46E9A5CF63419F9C637E"] = {
            [1] = "D584F1DAEDA6417D96B6C696DD0B8D6F",
        },
        ["D584F1DAEDA6417D96B6C696DD0B8D6F"] = {
            [1] = "2AF43251303144C5B4F412E30355DF0E",
        },
        ["C96EF13DA34A4AB38F2B1946553979A9"] = {
            [1] = "D704D239E4C344C9BFEE4E9BD06EB47F",
            [2] = "C3A5C27DA02F46C5A1051544C308338A",
        },
        ["C3A5C27DA02F46C5A1051544C308338A"] = {
            [1] = "698EAF09F9BE46E9A5CF63419F9C637E",
        },
    },
    ["nodes"] = {
        ["14FF4FDE3596445B94727BD166E52FD9"] = {
            ["Desc"] = "必杀",
            ["Pos"] = {
                ["y"] = 467,
                ["x"] = 1141,
            },
            ["Weight"] = 1,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "14FF4FDE3596445B94727BD166E52FD9",
            ["ID"] = 101740,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["F1352CD93AAA4E6CB18CE5274AC77BCE"] = {
            ["Pos"] = {
                ["y"] = 294,
                ["x"] = 489,
            },
            ["Class"] = "ConditionTargetDistanceNode",
            ["NodeTag"] = "F1352CD93AAA4E6CB18CE5274AC77BCE",
            ["RangeY"] = {
                [1] = 0,
                [2] = 100,
            },
            ["RangeX"] = {
                [1] = 0,
                [2] = 500,
            },
            ["Static"] = false,
        },
        ["2AF43251303144C5B4F412E30355DF0E"] = {
            ["Desc"] = "行为",
            ["Weight"] = 0,
            ["NodeTag"] = "2AF43251303144C5B4F412E30355DF0E",
            ["RunWeight"] = 0,
            ["WalkDistance"] = 0,
            ["Pos"] = {
                ["y"] = 581,
                ["x"] = 1052,
            },
            ["Class"] = "PatrolBevNode",
            ["WalkWeight"] = 0,
            ["TriggerType"] = 2,
            ["Static"] = false,
            ["Type"] = 9,
        },
        ["C3A5C27DA02F46C5A1051544C308338A"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 500,
            ["NodeTag"] = "C3A5C27DA02F46C5A1051544C308338A",
            ["TriggerType"] = 1,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 575,
                ["x"] = 281,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 1,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["D584F1DAEDA6417D96B6C696DD0B8D6F"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 580,
                ["x"] = 834,
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
                ["y"] = 291,
                ["x"] = 790,
            },
            ["Weight"] = 0,
            ["Class"] = "RandomBevNode",
            ["NodeTag"] = "728A022A0C0D476A9CCFBFFFF52FD250",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["1BA7A6934141456593E736E481EC892E"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 252,
                ["x"] = 1136,
            },
            ["Weight"] = 1,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "1BA7A6934141456593E736E481EC892E",
            ["ID"] = 101720,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["C8F145F19BE741768C8C5F7ECD43EEC8"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 125,
                ["x"] = 1133,
            },
            ["Weight"] = 1,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "C8F145F19BE741768C8C5F7ECD43EEC8",
            ["ID"] = 101710,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["698EAF09F9BE46E9A5CF63419F9C637E"] = {
            ["Pos"] = {
                ["y"] = 583,
                ["x"] = 543,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "698EAF09F9BE46E9A5CF63419F9C637E",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["D704D239E4C344C9BFEE4E9BD06EB47F"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 6000,
            ["NodeTag"] = "D704D239E4C344C9BFEE4E9BD06EB47F",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 291,
                ["x"] = 275,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 2,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["C96EF13DA34A4AB38F2B1946553979A9"] = {
            ["Desc"] = "新的 AI",
            ["Pos"] = {
                ["y"] = 408,
                ["x"] = 45,
            },
            ["Category"] = 1,
            ["Class"] = "RootNode",
            ["NodeTag"] = "C96EF13DA34A4AB38F2B1946553979A9",
            ["ID"] = "999219",
            ["Name"] = "主线12章地狱万由里",
            ["Static"] = true,
        },
        ["D54EBE2895E247B2B9DC883BC313071E"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 352,
                ["x"] = 1144,
            },
            ["Weight"] = 1,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "D54EBE2895E247B2B9DC883BC313071E",
            ["ID"] = 101730,
            ["Type"] = 1,
            ["Static"] = false,
        },
    },
    ["root"] = "C96EF13DA34A4AB38F2B1946553979A9",
}