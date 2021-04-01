return {
    ["links"] = {
        ["9962180811B74DBFB0510F310FCDE1E8"] = {
            [1] = "CEFD17AFC3FC4D39BAB5857E6C792924",
        },
        ["9F41A7F8969744A1ABFCEA2203237ECA"] = {
            [1] = "E2E0D8C74F1A4986BCCB5B83758C66F0",
        },
        ["1FD2833DE09447B7A30420B1C348974A"] = {
            [1] = "9F41A7F8969744A1ABFCEA2203237ECA",
        },
        ["DC5E3B11D5BF406EAA77499B0AE79045"] = {
            [1] = "C436020137BD4CB78EFB39D06AC68976",
            [2] = "1FD2833DE09447B7A30420B1C348974A",
            [3] = "C8EE5810DEA446AB93501DB58D9AF25F",
        },
        ["C8EE5810DEA446AB93501DB58D9AF25F"] = {
            [1] = "04A23B988EE543E3A0B515EA67570961",
        },
        ["D69500A525A443938B282C76AA6242D0"] = {
            [1] = "5340A034BD6A40009D1B19A73CB5A108",
        },
        ["04A23B988EE543E3A0B515EA67570961"] = {
            [1] = "D69500A525A443938B282C76AA6242D0",
        },
        ["E2E0D8C74F1A4986BCCB5B83758C66F0"] = {
            [1] = "D42905D19BA6473882068111D5863FFC",
        },
        ["C436020137BD4CB78EFB39D06AC68976"] = {
            [1] = "A9268BDDFE2446FFB49EBFEFB6309D53",
        },
        ["A9268BDDFE2446FFB49EBFEFB6309D53"] = {
            [1] = "9962180811B74DBFB0510F310FCDE1E8",
        },
    },
    ["nodes"] = {
        ["9962180811B74DBFB0510F310FCDE1E8"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 389,
                ["x"] = 991,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "9962180811B74DBFB0510F310FCDE1E8",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["9F41A7F8969744A1ABFCEA2203237ECA"] = {
            ["Pos"] = {
                ["y"] = 578,
                ["x"] = 723,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "9F41A7F8969744A1ABFCEA2203237ECA",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["1FD2833DE09447B7A30420B1C348974A"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 3000,
            ["NodeTag"] = "1FD2833DE09447B7A30420B1C348974A",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 553,
                ["x"] = 480,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Parallel"] = 0,
            ["Priority"] = 0,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["5340A034BD6A40009D1B19A73CB5A108"] = {
            ["Desc"] = "行为",
            ["Weight"] = 0,
            ["NodeTag"] = "5340A034BD6A40009D1B19A73CB5A108",
            ["RunWeight"] = 0,
            ["WalkDistance"] = 0,
            ["Pos"] = {
                ["y"] = 720,
                ["x"] = 1265,
            },
            ["Class"] = "PatrolBevNode",
            ["WalkWeight"] = 0,
            ["TriggerType"] = 2,
            ["Static"] = false,
            ["Type"] = 9,
        },
        ["D69500A525A443938B282C76AA6242D0"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 726,
                ["x"] = 1041,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "D69500A525A443938B282C76AA6242D0",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["DC5E3B11D5BF406EAA77499B0AE79045"] = {
            ["Desc"] = "新的 AI",
            ["Pos"] = {
                ["y"] = 411,
                ["x"] = 273,
            },
            ["Category"] = 1,
            ["Class"] = "RootNode",
            ["NodeTag"] = "DC5E3B11D5BF406EAA77499B0AE79045",
            ["ID"] = "999205",
            ["Name"] = "警备机器人",
            ["Static"] = true,
        },
        ["04A23B988EE543E3A0B515EA67570961"] = {
            ["Pos"] = {
                ["y"] = 737,
                ["x"] = 761,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "04A23B988EE543E3A0B515EA67570961",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["C8EE5810DEA446AB93501DB58D9AF25F"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 0,
            ["NodeTag"] = "C8EE5810DEA446AB93501DB58D9AF25F",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 710,
                ["x"] = 485,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Parallel"] = 0,
            ["Priority"] = 0,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["D42905D19BA6473882068111D5863FFC"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 548,
                ["x"] = 1249,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "D42905D19BA6473882068111D5863FFC",
            ["ID"] = 313111,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["CEFD17AFC3FC4D39BAB5857E6C792924"] = {
            ["Desc"] = "施放技能",
            ["Pos"] = {
                ["y"] = 385,
                ["x"] = 1213,
            },
            ["Weight"] = 0,
            ["Class"] = "ReleaseSkillBevNode",
            ["NodeTag"] = "CEFD17AFC3FC4D39BAB5857E6C792924",
            ["ID"] = 313110,
            ["Type"] = 1,
            ["Static"] = false,
        },
        ["E2E0D8C74F1A4986BCCB5B83758C66F0"] = {
            ["Desc"] = "顺序行为",
            ["Pos"] = {
                ["y"] = 581,
                ["x"] = 1017,
            },
            ["Weight"] = 0,
            ["Class"] = "OrderBevNode",
            ["NodeTag"] = "E2E0D8C74F1A4986BCCB5B83758C66F0",
            ["Type"] = 0,
            ["Static"] = false,
        },
        ["C436020137BD4CB78EFB39D06AC68976"] = {
            ["Desc"] = "子节点",
            ["Duration"] = 5000,
            ["NodeTag"] = "C436020137BD4CB78EFB39D06AC68976",
            ["TriggerType"] = 0,
            ["Static"] = false,
            ["Pos"] = {
                ["y"] = 389,
                ["x"] = 482,
            },
            ["Class"] = "ChildNode",
            ["Loop"] = 0,
            ["Parallel"] = 0,
            ["Priority"] = 0,
            ["DurationInterval"] = {
                [1] = 0,
                [2] = 0,
            },
        },
        ["A9268BDDFE2446FFB49EBFEFB6309D53"] = {
            ["Pos"] = {
                ["y"] = 389,
                ["x"] = 705,
            },
            ["Class"] = "ConditionInFightTimeoutNode",
            ["NodeTag"] = "A9268BDDFE2446FFB49EBFEFB6309D53",
            ["Duration"] = 0,
            ["Type"] = 1,
            ["Static"] = false,
        },
    },
    ["root"] = "DC5E3B11D5BF406EAA77499B0AE79045",
}