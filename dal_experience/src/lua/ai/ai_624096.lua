return {
    ["links"] = {
        ["E43A81468E80470099FD15BD19163DEF"] = {
            [1] = "7587C276F0BD4A478265C83CA8F8D51C",
        },
        ["DE070475ED7A4FF7B1200F41941C89AE"] = {
            [1] = "B9C7900EB08C41739A4BF9F085EF33D1",
        },
        ["7587C276F0BD4A478265C83CA8F8D51C"] = {
            [1] = "20A6A6E94E234041A88C83F25DFE80F6",
        },
        ["DAEF690CD617462CA569426EE6683456"] = {
            [1] = "97044CCCF2D54A579FAF3FFF305AE477",
        },
        ["F704226FA6C74EC6A3C6BF7A0A01030D"] = {
            [1] = "DAEF690CD617462CA569426EE6683456",
            [2] = "E43A81468E80470099FD15BD19163DEF",
        },
        ["C9CD74B571814BFF872778A53F511446"] = {
            [1] = "7CC78038272846AAB146A0A5F289363B",
        },
        ["20A6A6E94E234041A88C83F25DFE80F6"] = {
            [1] = "C9CD74B571814BFF872778A53F511446",
        },
        ["97044CCCF2D54A579FAF3FFF305AE477"] = {
            [1] = "DE070475ED7A4FF7B1200F41941C89AE",
        },
    },
    ["nodes"] = {
        ["7587C276F0BD4A478265C83CA8F8D51C"] = {
            ["Pos"] = {
                ["y"] = 394,
                ["x"] = 669,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "7587C276F0BD4A478265C83CA8F8D51C",
            ["Duration"] = 5000,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["E43A81468E80470099FD15BD19163DEF"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 0,
            ["NodeTag"] = "E43A81468E80470099FD15BD19163DEF",
            ["Force"] = 0,
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 395,
                ["x"] = 335,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 0,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["20A6A6E94E234041A88C83F25DFE80F6"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 337,
                ["x"] = 940,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "20A6A6E94E234041A88C83F25DFE80F6",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["97044CCCF2D54A579FAF3FFF305AE477"] = {
            ["Pos"] = {
                ["y"] = 560,
                ["x"] = 633,
            },
            ["Property"] = 51,
            ["Class"] = "ConditionPropertyNode",
            ["NodeTag"] = "97044CCCF2D54A579FAF3FFF305AE477",
            ["Value"] = 10000,
            ["Judge"] = 2,
            ["Static"] = false,
        },
        ["B9C7900EB08C41739A4BF9F085EF33D1"] = {
            ["Desc"] = "行为",
            ["Pos"] = {
                ["y"] = 553,
                ["x"] = 1237,
            },
            ["Weight"] = 0,
            ["Class"] = "KillMySelfBevNode",
            ["NodeTag"] = "B9C7900EB08C41739A4BF9F085EF33D1",
            ["Type"] = 0,
            ["IsCount"] = 2,
            ["Static"] = false,
        },
        ["FF324D583A7C48FEBAF32EC9C1B04A9F"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 198,
                ["x"] = 1504,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "FF324D583A7C48FEBAF32EC9C1B04A9F",
            ["ID"] = 103820,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["7CC78038272846AAB146A0A5F289363B"] = {
            ["Desc"] = "行为",
            ["Pos"] = {
                ["y"] = 332,
                ["x"] = 1263,
            },
            ["Weight"] = 0,
            ["Class"] = "KillMySelfBevNode",
            ["NodeTag"] = "7CC78038272846AAB146A0A5F289363B",
            ["Type"] = 0,
            ["IsCount"] = 2,
            ["Static"] = false,
        },
        ["F704226FA6C74EC6A3C6BF7A0A01030D"] = {
            ["Desc"] = "贝露",
            ["Pos"] = {
                ["y"] = 425,
                ["x"] = 44,
            },
            ["Category"] = 1,
            ["Class"] = "RootNode",
            ["NodeTag"] = "F704226FA6C74EC6A3C6BF7A0A01030D",
            ["ID"] = "624096",
            ["Name"] = "贝露能量球",
            ["Static"] = true,
        },
        ["C9CD74B571814BFF872778A53F511446"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 433,
                ["x"] = 1067,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "C9CD74B571814BFF872778A53F511446",
            ["ID"] = 103991,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["DAEF690CD617462CA569426EE6683456"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 0,
            ["NodeTag"] = "DAEF690CD617462CA569426EE6683456",
            ["Force"] = 0,
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 573,
                ["x"] = 328,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Priority"] = 0,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["DE070475ED7A4FF7B1200F41941C89AE"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 625,
                ["x"] = 1044,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "DE070475ED7A4FF7B1200F41941C89AE",
            ["Type"] = 0,
            ["Static"] = false,
        },
    },
    ["root"] = "F704226FA6C74EC6A3C6BF7A0A01030D",
}