// 此文件现在仅供阅读和参考,更改不会生效,要更改事件编辑器请改动EventAction.g4


// Generated from EventAction.g4 by antlr-blockly
// 语句集合和表达式集合
EventActionBlocks = {
    "actions": [
        "showText",
        "showFukiText",
        "showChoice",
        "sleep",
        "script",
        "comment",
        "setValue",
        "ifAction",
        "specialEvent",
        "commonEventP",
        "transferPlayer",
        "nextPage",
        "pageTo",
        "dead",
        "changeMapColor_RGB",
        "changeWhiteMaskColor_RGB",
        "shakeOn",
        "shakeOff",
        "setMapScale",
        "scrollCameraStart",
        "scrollCamera",
        "scrollCameraEnd",
        "startEvent",
        "setEventPage",
        "setEventDead",
        "setEventPosition",
        "setEventDirection",
        "setPlayerPosition",
        "setEventDead_map",
        "setEventFade",
        "setPlayerFade",
        "setPlayerMove",
        "setCharacterMove",
        "setPlayerTexture",
        "setPlayerDirection",
        "setCharacterTexture",
        "setPlayerSpeed",
        "setCharacterSpeed",
        "restorePlayerSpeed",
        "setPlayerJump",
        "setCharacterJump",
        "showAnim",
        "showPlayerAnim",
        "addFollower",
        "delFollower",
        "playSE",
        "getItem",
        "getEquip",
        "callEnemyForm",
        "callSaveForm",
        "refresh",
        "returnMainMenu",
        "passAction"
    ],
    "expr": [
        "arithmetic",
        "notExpr",
        "boolExpr",
        "fixedExpr",
        "idRangeExpr",
        "idStringExpr",
        "scriptExpr",
        "evalStringExpr"
    ],
    "expr_order_for_if": [
        "arithmetic",
        "notExpr",
        "boolExpr",
        "fixedExpr",
        "idRangeExpr",
        "idStringExpr",
        "evalStringExpr",
        "scriptExpr"
    ],
    "idExpr": [
        "fixedExpr",
        "idRangeExpr",
        "idStringExpr"
    ]
}


// 所有域的默认行为
Object.assign(EventActionBlocks,{
    "EffectId_List": {
        "type": "field_dropdown",
        "options": function(){return window.EffectId_List_pair||[['加载失败','-1'],['加载失败','-2']]},
        "default": "101"
    },
    "SpecialEvent_List": {
        "type": "field_dropdown",
        "options": [
            ["ItemUsingEvent","ItemUsingEvent"],
            ["GameOverEvent","GameOverEvent"],
            ["ShopEvent","ShopEvent"],
            ["LevelUpEvent","LevelUpEvent"],
            ["ChapterEndEvent","ChapterEndEvent"]
        ],
        "default": "ItemUsingEvent"
    },
    "CommonEventP_List": {
        "type": "field_dropdown",
        "options": function(){return window.CommonEventId_List_pair||[['加载失败','-1'],['加载失败','-2']]},
        "default": "e1/text1"
    },
    "SetOP_List": {
        "type": "field_dropdown",
        "options": [
            ["=","="],
            ["+=","+="],
            ["-=","-="],
            ["*=","*="],
            ["/=","/="]
        ],
        "default": "="
    },
    "FixedId_List": {
        "type": "field_dropdown",
        "options": [
            ["HP","HP"],
            ["MAXHP","MAXHP"],
            ["MP","MP"],
            ["ATK","ATK"],
            ["DEF","DEF"],
            ["MDEF","MDEF"],
            ["SPD","SPD"]
        ],
        "default": "HP"
    },
    "IdRange_List": {
        "type": "field_dropdown",
        "options": [
            ["attribute","attribute"],
            ["gameVariables","gameVariables"]
        ],
        "default": "attribute"
    },
    "Arithmetic_List": {
        "type": "field_dropdown",
        "options": [
            ["+","+"],
            ["-","-"],
            ["*","*"],
            ["/","/"],
            ["^","^"],
            ["==","=="],
            ["!=","!="],
            [">",">"],
            ["<","<"],
            [">=",">="],
            ["<=","<="],
            ["&&","&&"],
            ["||","||"]
        ],
        "default": "+"
    },
    "TextPosition_List": {
        "type": "field_dropdown",
        "options": [
            ["Up","Up"],
            ["Center","Center"],
            ["Down","Down"]
        ],
        "default": "Up"
    },
    "Direction_List": {
        "type": "field_dropdown",
        "options": [
            ["Down","Down"],
            ["Left","Left"],
            ["Right","Right"],
            ["Up","Up"]
        ],
        "default": "Down"
    },
    "RawEvalString": {
        "type": "field_input",
        "text": "RawEvalString_default"
    },
    "RawEvalString_Multi": {
        "type": "field_multilinetext",
        "text": "RawEvalString_Multi_default"
    },
    "JsonEvalString": {
        "type": "field_input",
        "text": "JsonEvalString_default"
    },
    "Colour": {
        "type": "field_colour",
        "colour": "#ff0000"
    },
    "Angle": {
        "type": "field_angle",
        "angle": 90
    },
    "Bool": {
        "type": "field_checkbox",
        "checked": true
    },
    "Int": {
        "type": "field_number",
        "value": 0,
        "min": 0,
        "precision": 1
    },
    "NInt": {
        "type": "field_input",
        "text": "NInt_default"
    },
    "Number": {
        "type": "field_number",
        "value": 0
    },
    "IdString": {
        "type": "field_input",
        "text": "IdString_default"
    },
    "EvalString": {
        "type": "field_input",
        "text": "EvalString_default"
    },
    "EvalString_Multi": {
        "type": "field_multilinetext",
        "text": "EvalString_Multi_default"
    },
    "BGNL": {
        "type": "input_dummy"
    }
});


// 所有方块的实际内容
Object.assign(EventActionBlocks,{
    "actionArr": {
        "type": "statement",
        "json": {
            "type": "actionArr",
            "message0": "动作列表 %1 %2",
            "args0": [
                {
                    "type": "input_dummy"
                },
                {
                    "type": "input_statement",
                    "name": "actions",
                    "check": EventActionBlocks.actions
                }
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 260
        },
        "generFunc": function(block) {
            var actions = Blockly.JavaScript.statementToCode(block, 'actions');
            var code = EventActionFunctions.defaultCode('actionArr',eval('['+EventActionBlocks['actionArr'].args.join(',')+']'),block);
            return code;
        },
        "args": ["actions"],
        "argsType": ["statement"],
        "argsGrammarName": ["actions"],
        "omitted": [true],
        "multi": [true],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('actionArr',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('actionArr',inputs,next,isShadow,comment,attribute);
        }
    },
    "showText": {
        "type": "statement",
        "json": {
            "type": "showText",
            "message0": "显示文章: %1 人物:  名称 %2 头像 %3 %4 文本:  位置 %5 外框 %6 %7 %8",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "name",
                    "text": ""
                }),
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "battlersPicture",
                    "text": ""
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.TextPosition_List,{
                    "name": "textPos",
                    "default": "Down"
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "backGround",
                    "checked": "TRUE"
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.EvalString_Multi,{
                    "name": "text",
                    "text": "*一段剧情*"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "showText",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var name = block.getFieldValue('name');
            name = EventActionFunctions.pre('EvalString')(name,block,'name','showText');
            var battlersPicture = block.getFieldValue('battlersPicture');
            battlersPicture = EventActionFunctions.pre('EvalString')(battlersPicture,block,'battlersPicture','showText');
            var textPos = block.getFieldValue('textPos');
            textPos = EventActionFunctions.pre('TextPosition_List')(textPos,block,'textPos','showText');
            var backGround = block.getFieldValue('backGround') === 'TRUE';
            backGround = EventActionFunctions.pre('Bool')(backGround,block,'backGround','showText');
            var text = block.getFieldValue('text');
            if (text==='') {
                throw new OmitedError(block,'text','showText');
            }
            text = EventActionFunctions.pre('EvalString_Multi')(text,block,'text','showText');
            var code = EventActionFunctions.defaultCode('showText',eval('['+EventActionBlocks['showText'].args.join(',')+']'),block);
            return code;
        },
        "args": ["name","battlersPicture","textPos","backGround","text"],
        "argsType": ["field","field","field","field","field"],
        "argsGrammarName": ["EvalString","EvalString","TextPosition_List","Bool","EvalString_Multi"],
        "omitted": [true,true,false,false,false],
        "multi": [false,false,false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('showText',keyOrIndex);
        },
        "menu": [['合并回集成版本','window.convertShowTextDicBack?convertShowTextDicBack(block):0']],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('showText',inputs,next,isShadow,comment,attribute);
        }
    },
    "showFukiText": {
        "type": "statement",
        "json": {
            "type": "showFukiText",
            "message0": "显示文章（事件跟随）: 事件 %1 %2 人物:  名称 %3 头像 %4 %5 %6",
            "args0": [
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "eventName",
                    "text": ""
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "name",
                    "text": ""
                }),
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "battlersPicture",
                    "text": ""
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.EvalString_Multi,{
                    "name": "text",
                    "text": "*一段剧情*"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "showFukiText",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventName = block.getFieldValue('eventName');
            eventName = EventActionFunctions.pre('EvalString')(eventName,block,'eventName','showFukiText');
            var name = block.getFieldValue('name');
            name = EventActionFunctions.pre('EvalString')(name,block,'name','showFukiText');
            var battlersPicture = block.getFieldValue('battlersPicture');
            battlersPicture = EventActionFunctions.pre('EvalString')(battlersPicture,block,'battlersPicture','showFukiText');
            var text = block.getFieldValue('text');
            if (text==='') {
                throw new OmitedError(block,'text','showFukiText');
            }
            text = EventActionFunctions.pre('EvalString_Multi')(text,block,'text','showFukiText');
            var code = EventActionFunctions.defaultCode('showFukiText',eval('['+EventActionBlocks['showFukiText'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventName","name","battlersPicture","text"],
        "argsType": ["field","field","field","field"],
        "argsGrammarName": ["EvalString","EvalString","EvalString","EvalString_Multi"],
        "omitted": [true,true,true,false],
        "multi": [false,false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('showFukiText',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('showFukiText',inputs,next,isShadow,comment,attribute);
        }
    },
    "showChoice": {
        "type": "statement",
        "json": {
            "type": "showChoice",
            "message0": "显示选择项 %1 人物:  名称 %2 头像 %3 %4 文本:  位置 %5 外框 %6 %7 %8 手动取消 %9 %10 %11",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "name",
                    "text": ""
                }),
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "battlersPicture",
                    "text": ""
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.TextPosition_List,{
                    "name": "textPos",
                    "default": "Down"
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "backGround",
                    "checked": "TRUE"
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.EvalString_Multi,{
                    "name": "text",
                    "text": ""
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "esc"
                }),
                {
                    "type": "input_dummy"
                },
                {
                    "type": "input_statement",
                    "name": "choices",
                    "check": "choices"
                }
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "showChoice",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var name = block.getFieldValue('name');
            name = EventActionFunctions.pre('EvalString')(name,block,'name','showChoice');
            var battlersPicture = block.getFieldValue('battlersPicture');
            battlersPicture = EventActionFunctions.pre('EvalString')(battlersPicture,block,'battlersPicture','showChoice');
            var textPos = block.getFieldValue('textPos');
            textPos = EventActionFunctions.pre('TextPosition_List')(textPos,block,'textPos','showChoice');
            var backGround = block.getFieldValue('backGround') === 'TRUE';
            backGround = EventActionFunctions.pre('Bool')(backGround,block,'backGround','showChoice');
            var text = block.getFieldValue('text');
            text = EventActionFunctions.pre('EvalString_Multi')(text,block,'text','showChoice');
            var esc = block.getFieldValue('esc') === 'TRUE';
            esc = EventActionFunctions.pre('Bool')(esc,block,'esc','showChoice');
            var choices = Blockly.JavaScript.statementToCode(block, 'choices');
            if (choices==='') {
                throw new OmitedError(block,'choices','showChoice');
            }
            var code = EventActionFunctions.defaultCode('showChoice',eval('['+EventActionBlocks['showChoice'].args.join(',')+']'),block);
            return code;
        },
        "args": ["name","battlersPicture","textPos","backGround","text","esc","choices"],
        "argsType": ["field","field","field","field","field","field","statement"],
        "argsGrammarName": ["EvalString","EvalString","TextPosition_List","Bool","EvalString_Multi","Bool","choices"],
        "omitted": [true,true,false,false,true,false,false],
        "multi": [false,false,false,false,false,false,true],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('showChoice',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('showChoice',inputs,next,isShadow,comment,attribute);
        }
    },
    "choices": {
        "type": "statement",
        "json": {
            "type": "choices",
            "message0": "选项 %1 %2 执行 %3",
            "args0": [
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "text",
                    "text": "攻击"
                }),
                {
                    "type": "input_dummy"
                },
                {
                    "type": "input_statement",
                    "name": "actions",
                    "check": EventActionBlocks.actions
                }
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 80,
            "previousStatement": "choices",
            "nextStatement": "choices"
        },
        "generFunc": function(block) {
            var text = block.getFieldValue('text');
            if (text==='') {
                throw new OmitedError(block,'text','choices');
            }
            text = EventActionFunctions.pre('EvalString')(text,block,'text','choices');
            var actions = Blockly.JavaScript.statementToCode(block, 'actions');
            var code = EventActionFunctions.defaultCode('choices',eval('['+EventActionBlocks['choices'].args.join(',')+']'),block);
            return code;
        },
        "args": ["text","actions"],
        "argsType": ["field","statement"],
        "argsGrammarName": ["EvalString","actions"],
        "omitted": [false,true],
        "multi": [false,true],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('choices',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('choices',inputs,next,isShadow,comment,attribute);
        }
    },
    "comment": {
        "type": "statement",
        "json": {
            "type": "comment",
            "message0": "注释 %1",
            "args0": [
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "text",
                    "text": "可以在这里写添加任何注释内容"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "comment",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var text = block.getFieldValue('text');
            if (text==='') {
                throw new OmitedError(block,'text','comment');
            }
            text = EventActionFunctions.pre('EvalString')(text,block,'text','comment');
            var code = EventActionFunctions.defaultCode('comment',eval('['+EventActionBlocks['comment'].args.join(',')+']'),block);
            return code;
        },
        "args": ["text"],
        "argsType": ["field"],
        "argsGrammarName": ["EvalString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('comment',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('comment',inputs,next,isShadow,comment,attribute);
        }
    },
    "sleep": {
        "type": "statement",
        "json": {
            "type": "sleep",
            "message0": "等待 秒数 %1",
            "args0": [
                Object.assign({},EventActionBlocks.Number,{
                    "name": "time",
                    "value": 0.5
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "sleep",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var time = block.getFieldValue('time');
            time = EventActionFunctions.pre('Number')(time,block,'time','sleep');
            var code = EventActionFunctions.defaultCode('sleep',eval('['+EventActionBlocks['sleep'].args.join(',')+']'),block);
            return code;
        },
        "args": ["time"],
        "argsType": ["field"],
        "argsGrammarName": ["Number"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('sleep',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('sleep',inputs,next,isShadow,comment,attribute);
        }
    },
    "script": {
        "type": "statement",
        "json": {
            "type": "script",
            "message0": "脚本代码 %1",
            "args0": [
                Object.assign({},EventActionBlocks.RawEvalString_Multi,{
                    "name": "script",
                    "text": "print(thisobj)"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "script",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var script = block.getFieldValue('script');
            if (script==='') {
                throw new OmitedError(block,'script','script');
            }
            script = EventActionFunctions.pre('RawEvalString_Multi')(script,block,'script','script');
            var code = EventActionFunctions.defaultCode('script',eval('['+EventActionBlocks['script'].args.join(',')+']'),block);
            return code;
        },
        "args": ["script"],
        "argsType": ["field"],
        "argsGrammarName": ["RawEvalString_Multi"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('script',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('script',inputs,next,isShadow,comment,attribute);
        }
    },
    "setValue": {
        "type": "statement",
        "json": {
            "type": "setValue",
            "message0": "变量操作 左侧必须为变量ID %1 %2 %3",
            "args0": [
                {
                    "type": "input_value",
                    "name": "name",
                    "check": EventActionBlocks.idExpr
                },
                Object.assign({},EventActionBlocks.SetOP_List,{
                    "name": "op"
                }),
                {
                    "type": "input_value",
                    "name": "value",
                    "check": EventActionBlocks.expr
                }
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setValue",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var name = Blockly.JavaScript.valueToCode(block, 'name', 
              Blockly.JavaScript.ORDER_ATOMIC);
            if (name==='') {
                throw new OmitedError(block,'name','setValue');
            }
            var op = block.getFieldValue('op');
            op = EventActionFunctions.pre('SetOP_List')(op,block,'op','setValue');
            var value = Blockly.JavaScript.valueToCode(block, 'value', 
              Blockly.JavaScript.ORDER_ATOMIC);
            if (value==='') {
                throw new OmitedError(block,'value','setValue');
            }
            var code = EventActionFunctions.defaultCode('setValue',eval('['+EventActionBlocks['setValue'].args.join(',')+']'),block);
            return code;
        },
        "args": ["name","op","value"],
        "argsType": ["value","field","value"],
        "argsGrammarName": ["idExpr","SetOP_List","expr"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setValue',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setValue',inputs,next,isShadow,comment,attribute);
        }
    },
    "ifAction": {
        "type": "statement",
        "json": {
            "type": "ifAction",
            "message0": "符合条件(表达式) %1 %2 %3 不符合 %4 %5",
            "args0": [
                {
                    "type": "input_value",
                    "name": "condition",
                    "check": EventActionBlocks.expr_order_for_if
                },
                {
                    "type": "input_dummy"
                },
                {
                    "type": "input_statement",
                    "name": "trueActions",
                    "check": EventActionBlocks.actions
                },
                {
                    "type": "input_dummy"
                },
                {
                    "type": "input_statement",
                    "name": "falseActions",
                    "check": EventActionBlocks.actions
                }
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 220,
            "previousStatement": "ifAction",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var condition = Blockly.JavaScript.valueToCode(block, 'condition', 
              Blockly.JavaScript.ORDER_ATOMIC);
            if (condition==='') {
                throw new OmitedError(block,'condition','ifAction');
            }
            var trueActions = Blockly.JavaScript.statementToCode(block, 'trueActions');
            var falseActions = Blockly.JavaScript.statementToCode(block, 'falseActions');
            var code = EventActionFunctions.defaultCode('ifAction',eval('['+EventActionBlocks['ifAction'].args.join(',')+']'),block);
            return code;
        },
        "args": ["condition","trueActions","falseActions"],
        "argsType": ["value","statement","statement"],
        "argsGrammarName": ["expr_order_for_if","actions","actions"],
        "omitted": [false,true,true],
        "multi": [false,true,true],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('ifAction',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('ifAction',inputs,next,isShadow,comment,attribute);
        }
    },
    "commonEventP": {
        "type": "statement",
        "json": {
            "type": "commonEventP",
            "message0": "公共事件库 %1 %2",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.CommonEventP_List,{
                    "name": "commonEventId",
                    "default": "e1/text1"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 220,
            "previousStatement": "commonEventP",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var commonEventId = block.getFieldValue('commonEventId');
            commonEventId = EventActionFunctions.pre('CommonEventP_List')(commonEventId,block,'commonEventId','commonEventP');
            var code = EventActionFunctions.defaultCode('commonEventP',eval('['+EventActionBlocks['commonEventP'].args.join(',')+']'),block);
            return code;
        },
        "args": ["commonEventId"],
        "argsType": ["field"],
        "argsGrammarName": ["CommonEventP_List"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('commonEventP',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('commonEventP',inputs,next,isShadow,comment,attribute);
        }
    },
    "specialEvent": {
        "type": "statement",
        "json": {
            "type": "specialEvent",
            "message0": "特别事件 %1 %2",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.SpecialEvent_List,{
                    "name": "eventType",
                    "default": ""
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 220,
            "previousStatement": "specialEvent",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventType = block.getFieldValue('eventType');
            eventType = EventActionFunctions.pre('SpecialEvent_List')(eventType,block,'eventType','specialEvent');
            var code = EventActionFunctions.defaultCode('specialEvent',eval('['+EventActionBlocks['specialEvent'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventType"],
        "argsType": ["field"],
        "argsGrammarName": ["SpecialEvent_List"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('specialEvent',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('specialEvent',inputs,next,isShadow,comment,attribute);
        }
    },
    "nextPage": {
        "type": "statement",
        "json": {
            "type": "nextPage",
            "message0": "本事件翻至下一页",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 50,
            "previousStatement": "nextPage",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('nextPage',eval('['+EventActionBlocks['nextPage'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('nextPage',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('nextPage',inputs,next,isShadow,comment,attribute);
        }
    },
    "pageTo": {
        "type": "statement",
        "json": {
            "type": "pageTo",
            "message0": "本事件翻页至 %1",
            "args0": [
                Object.assign({},EventActionBlocks.Int,{
                    "name": "index"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 50,
            "previousStatement": "pageTo",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var index = block.getFieldValue('index');
            index = EventActionFunctions.pre('Int')(index,block,'index','pageTo');
            var code = EventActionFunctions.defaultCode('pageTo',eval('['+EventActionBlocks['pageTo'].args.join(',')+']'),block);
            return code;
        },
        "args": ["index"],
        "argsType": ["field"],
        "argsGrammarName": ["Int"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('pageTo',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('pageTo',inputs,next,isShadow,comment,attribute);
        }
    },
    "dead": {
        "type": "statement",
        "json": {
            "type": "dead",
            "message0": "本事件结束",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 50,
            "previousStatement": "dead",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('dead',eval('['+EventActionBlocks['dead'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('dead',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('dead',inputs,next,isShadow,comment,attribute);
        }
    },
    "changeMapColor_RGB": {
        "type": "statement",
        "json": {
            "type": "changeMapColor_RGB",
            "message0": "更改画面色调(RGB) %1 RGB %2 A %3 %4 时长 (秒) %5",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Colour,{
                    "name": "rgb",
                    "colour": "#ffffff"
                }),
                Object.assign({},EventActionBlocks.Number,{
                    "name": "a",
                    "value": 1
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Number,{
                    "name": "duration",
                    "value": 1.5
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "changeMapColor_RGB",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var rgb = block.getFieldValue('rgb');
            rgb = EventActionFunctions.pre('Colour')(rgb,block,'rgb','changeMapColor_RGB');
            var a = block.getFieldValue('a');
            a = EventActionFunctions.pre('Number')(a,block,'a','changeMapColor_RGB');
            var duration = block.getFieldValue('duration');
            duration = EventActionFunctions.pre('Number')(duration,block,'duration','changeMapColor_RGB');
            var code = EventActionFunctions.defaultCode('changeMapColor_RGB',eval('['+EventActionBlocks['changeMapColor_RGB'].args.join(',')+']'),block);
            return code;
        },
        "args": ["rgb","a","duration"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["Colour","Number","Number"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('changeMapColor_RGB',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('changeMapColor_RGB',inputs,next,isShadow,comment,attribute);
        }
    },
    "changeWhiteMaskColor_RGB": {
        "type": "statement",
        "json": {
            "type": "changeWhiteMaskColor_RGB",
            "message0": "更改白色幕布色调(RGB) %1 RGB %2 A %3 %4 时长 (秒) %5",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Colour,{
                    "name": "rgb",
                    "colour": "#ffffff"
                }),
                Object.assign({},EventActionBlocks.Number,{
                    "name": "a",
                    "value": 1
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Number,{
                    "name": "duration",
                    "value": 1.5
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "changeWhiteMaskColor_RGB",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var rgb = block.getFieldValue('rgb');
            rgb = EventActionFunctions.pre('Colour')(rgb,block,'rgb','changeWhiteMaskColor_RGB');
            var a = block.getFieldValue('a');
            a = EventActionFunctions.pre('Number')(a,block,'a','changeWhiteMaskColor_RGB');
            var duration = block.getFieldValue('duration');
            duration = EventActionFunctions.pre('Number')(duration,block,'duration','changeWhiteMaskColor_RGB');
            var code = EventActionFunctions.defaultCode('changeWhiteMaskColor_RGB',eval('['+EventActionBlocks['changeWhiteMaskColor_RGB'].args.join(',')+']'),block);
            return code;
        },
        "args": ["rgb","a","duration"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["Colour","Number","Number"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('changeWhiteMaskColor_RGB',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('changeWhiteMaskColor_RGB',inputs,next,isShadow,comment,attribute);
        }
    },
    "shakeOn": {
        "type": "statement",
        "json": {
            "type": "shakeOn",
            "message0": "画面震动开始 %1 震动幅度 %2 每多少帧震动一次 %3",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Int,{
                    "name": "strength"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "shakelength",
                    "value": 3
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "shakeOn",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var strength = block.getFieldValue('strength');
            strength = EventActionFunctions.pre('Int')(strength,block,'strength','shakeOn');
            var shakelength = block.getFieldValue('shakelength');
            shakelength = EventActionFunctions.pre('Int')(shakelength,block,'shakelength','shakeOn');
            var code = EventActionFunctions.defaultCode('shakeOn',eval('['+EventActionBlocks['shakeOn'].args.join(',')+']'),block);
            return code;
        },
        "args": ["strength","shakelength"],
        "argsType": ["field","field"],
        "argsGrammarName": ["Int","Int"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('shakeOn',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('shakeOn',inputs,next,isShadow,comment,attribute);
        }
    },
    "shakeOff": {
        "type": "statement",
        "json": {
            "type": "shakeOff",
            "message0": "画面震动结束",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "shakeOff",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('shakeOff',eval('['+EventActionBlocks['shakeOff'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('shakeOff',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('shakeOff',inputs,next,isShadow,comment,attribute);
        }
    },
    "setMapScale": {
        "type": "statement",
        "json": {
            "type": "setMapScale",
            "message0": "设置大地图缩放(0.5-1.0) %1",
            "args0": [
                Object.assign({},EventActionBlocks.Number,{
                    "name": "scale",
                    "value": 1
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "setMapScale",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var scale = block.getFieldValue('scale');
            scale = EventActionFunctions.pre('Number')(scale,block,'scale','setMapScale');
            var code = EventActionFunctions.defaultCode('setMapScale',eval('['+EventActionBlocks['setMapScale'].args.join(',')+']'),block);
            return code;
        },
        "args": ["scale"],
        "argsType": ["field"],
        "argsGrammarName": ["Number"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setMapScale',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setMapScale',inputs,next,isShadow,comment,attribute);
        }
    },
    "scrollCameraStart": {
        "type": "statement",
        "json": {
            "type": "scrollCameraStart",
            "message0": "画面卷动开始（切换卷动相机）",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "scrollCameraStart",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('scrollCameraStart',eval('['+EventActionBlocks['scrollCameraStart'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('scrollCameraStart',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('scrollCameraStart',inputs,next,isShadow,comment,attribute);
        }
    },
    "scrollCamera": {
        "type": "statement",
        "json": {
            "type": "scrollCamera",
            "message0": "画面卷动（需要先切换卷动相机） %1 x %2 y %3 用时 %4",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.NInt,{
                    "name": "x",
                    "text": 0
                }),
                Object.assign({},EventActionBlocks.NInt,{
                    "name": "y",
                    "text": 0
                }),
                Object.assign({},EventActionBlocks.Number,{
                    "name": "duration",
                    "value": 2
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "scrollCamera",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var x = block.getFieldValue('x');
            if (x==='') {
                throw new OmitedError(block,'x','scrollCamera');
            }
            x = EventActionFunctions.pre('NInt')(x,block,'x','scrollCamera');
            var y = block.getFieldValue('y');
            if (y==='') {
                throw new OmitedError(block,'y','scrollCamera');
            }
            y = EventActionFunctions.pre('NInt')(y,block,'y','scrollCamera');
            var duration = block.getFieldValue('duration');
            duration = EventActionFunctions.pre('Number')(duration,block,'duration','scrollCamera');
            var code = EventActionFunctions.defaultCode('scrollCamera',eval('['+EventActionBlocks['scrollCamera'].args.join(',')+']'),block);
            return code;
        },
        "args": ["x","y","duration"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["NInt","NInt","Number"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('scrollCamera',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('scrollCamera',inputs,next,isShadow,comment,attribute);
        }
    },
    "scrollCameraEnd": {
        "type": "statement",
        "json": {
            "type": "scrollCameraEnd",
            "message0": "画面卷动结束（切换回主角相机）",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "scrollCameraEnd",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('scrollCameraEnd',eval('['+EventActionBlocks['scrollCameraEnd'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('scrollCameraEnd',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('scrollCameraEnd',inputs,next,isShadow,comment,attribute);
        }
    },
    "transferPlayer": {
        "type": "statement",
        "json": {
            "type": "transferPlayer",
            "message0": "场所移动 %1 地图id %2 x %3 y %4 方向 %5",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Int,{
                    "name": "mapkey"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "x"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "y"
                }),
                Object.assign({},EventActionBlocks.Direction_List,{
                    "name": "d"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "transferPlayer",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var mapkey = block.getFieldValue('mapkey');
            mapkey = EventActionFunctions.pre('Int')(mapkey,block,'mapkey','transferPlayer');
            var x = block.getFieldValue('x');
            x = EventActionFunctions.pre('Int')(x,block,'x','transferPlayer');
            var y = block.getFieldValue('y');
            y = EventActionFunctions.pre('Int')(y,block,'y','transferPlayer');
            var d = block.getFieldValue('d');
            d = EventActionFunctions.pre('Direction_List')(d,block,'d','transferPlayer');
            var code = EventActionFunctions.defaultCode('transferPlayer',eval('['+EventActionBlocks['transferPlayer'].args.join(',')+']'),block);
            return code;
        },
        "args": ["mapkey","x","y","d"],
        "argsType": ["field","field","field","field"],
        "argsGrammarName": ["Int","Int","Int","Direction_List"],
        "omitted": [false,false,false,false],
        "multi": [false,false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('transferPlayer',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('transferPlayer',inputs,next,isShadow,comment,attribute);
        }
    },
    "startEvent": {
        "type": "statement",
        "json": {
            "type": "startEvent",
            "message0": "立刻触发事件 %1 事件id %2",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "startEvent",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','startEvent');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','startEvent');
            var code = EventActionFunctions.defaultCode('startEvent',eval('['+EventActionBlocks['startEvent'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId"],
        "argsType": ["field"],
        "argsGrammarName": ["IdString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('startEvent',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('startEvent',inputs,next,isShadow,comment,attribute);
        }
    },
    "setEventPage": {
        "type": "statement",
        "json": {
            "type": "setEventPage",
            "message0": "立刻切换事件页至 %1 事件id %2 事件页index %3",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "index"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setEventPage",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setEventPage');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setEventPage');
            var index = block.getFieldValue('index');
            index = EventActionFunctions.pre('Int')(index,block,'index','setEventPage');
            var code = EventActionFunctions.defaultCode('setEventPage',eval('['+EventActionBlocks['setEventPage'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","index"],
        "argsType": ["field","field"],
        "argsGrammarName": ["IdString","Int"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setEventPage',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setEventPage',inputs,next,isShadow,comment,attribute);
        }
    },
    "setEventDead": {
        "type": "statement",
        "json": {
            "type": "setEventDead",
            "message0": "立刻结束事件 %1 事件id %2",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setEventDead",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setEventDead');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setEventDead');
            var code = EventActionFunctions.defaultCode('setEventDead',eval('['+EventActionBlocks['setEventDead'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId"],
        "argsType": ["field"],
        "argsGrammarName": ["IdString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setEventDead',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setEventDead',inputs,next,isShadow,comment,attribute);
        }
    },
    "setEventDead_map": {
        "type": "statement",
        "json": {
            "type": "setEventDead_map",
            "message0": "结束指定地图的指定事件 %1 地图id %2 事件id %3",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "mapkey"
                }),
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setEventDead_map",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var mapkey = block.getFieldValue('mapkey');
            if (mapkey==='') {
                throw new OmitedError(block,'mapkey','setEventDead_map');
            }
            mapkey = EventActionFunctions.pre('IdString')(mapkey,block,'mapkey','setEventDead_map');
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setEventDead_map');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setEventDead_map');
            var code = EventActionFunctions.defaultCode('setEventDead_map',eval('['+EventActionBlocks['setEventDead_map'].args.join(',')+']'),block);
            return code;
        },
        "args": ["mapkey","eventId"],
        "argsType": ["field","field"],
        "argsGrammarName": ["IdString","IdString"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setEventDead_map',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setEventDead_map',inputs,next,isShadow,comment,attribute);
        }
    },
    "setEventPosition": {
        "type": "statement",
        "json": {
            "type": "setEventPosition",
            "message0": "设置事件位置 %1 %2 x %3 y %4 方向 %5",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "x"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "y"
                }),
                Object.assign({},EventActionBlocks.Direction_List,{
                    "name": "d"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setEventPosition",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setEventPosition');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setEventPosition');
            var x = block.getFieldValue('x');
            x = EventActionFunctions.pre('Int')(x,block,'x','setEventPosition');
            var y = block.getFieldValue('y');
            y = EventActionFunctions.pre('Int')(y,block,'y','setEventPosition');
            var d = block.getFieldValue('d');
            d = EventActionFunctions.pre('Direction_List')(d,block,'d','setEventPosition');
            var code = EventActionFunctions.defaultCode('setEventPosition',eval('['+EventActionBlocks['setEventPosition'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","x","y","d"],
        "argsType": ["field","field","field","field"],
        "argsGrammarName": ["IdString","Int","Int","Direction_List"],
        "omitted": [false,false,false,false],
        "multi": [false,false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setEventPosition',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setEventPosition',inputs,next,isShadow,comment,attribute);
        }
    },
    "setEventDirection": {
        "type": "statement",
        "json": {
            "type": "setEventDirection",
            "message0": "设置事件朝向 %1 %2 方向 %3",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                Object.assign({},EventActionBlocks.Direction_List,{
                    "name": "d"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setEventDirection",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setEventDirection');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setEventDirection');
            var d = block.getFieldValue('d');
            d = EventActionFunctions.pre('Direction_List')(d,block,'d','setEventDirection');
            var code = EventActionFunctions.defaultCode('setEventDirection',eval('['+EventActionBlocks['setEventDirection'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","d"],
        "argsType": ["field","field"],
        "argsGrammarName": ["IdString","Direction_List"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setEventDirection',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setEventDirection',inputs,next,isShadow,comment,attribute);
        }
    },
    "setPlayerPosition": {
        "type": "statement",
        "json": {
            "type": "setPlayerPosition",
            "message0": "直接设置角色位置（同地图） %1 x %2 y %3 方向 %4",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Int,{
                    "name": "x"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "y"
                }),
                Object.assign({},EventActionBlocks.Direction_List,{
                    "name": "d"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setPlayerPosition",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var x = block.getFieldValue('x');
            x = EventActionFunctions.pre('Int')(x,block,'x','setPlayerPosition');
            var y = block.getFieldValue('y');
            y = EventActionFunctions.pre('Int')(y,block,'y','setPlayerPosition');
            var d = block.getFieldValue('d');
            d = EventActionFunctions.pre('Direction_List')(d,block,'d','setPlayerPosition');
            var code = EventActionFunctions.defaultCode('setPlayerPosition',eval('['+EventActionBlocks['setPlayerPosition'].args.join(',')+']'),block);
            return code;
        },
        "args": ["x","y","d"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["Int","Int","Direction_List"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setPlayerPosition',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setPlayerPosition',inputs,next,isShadow,comment,attribute);
        }
    },
    "setPlayerDirection": {
        "type": "statement",
        "json": {
            "type": "setPlayerDirection",
            "message0": "设置主角方向 方向 %1",
            "args0": [
                Object.assign({},EventActionBlocks.Direction_List,{
                    "name": "d"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setPlayerDirection",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var d = block.getFieldValue('d');
            d = EventActionFunctions.pre('Direction_List')(d,block,'d','setPlayerDirection');
            var code = EventActionFunctions.defaultCode('setPlayerDirection',eval('['+EventActionBlocks['setPlayerDirection'].args.join(',')+']'),block);
            return code;
        },
        "args": ["d"],
        "argsType": ["field"],
        "argsGrammarName": ["Direction_List"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setPlayerDirection',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setPlayerDirection',inputs,next,isShadow,comment,attribute);
        }
    },
    "setEventFade": {
        "type": "statement",
        "json": {
            "type": "setEventFade",
            "message0": "设置事件淡入淡出 事件id %1 %2 目标不透明度 %3 动画时长 %4",
            "args0": [
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Number,{
                    "name": "target",
                    "value": 1
                }),
                Object.assign({},EventActionBlocks.Number,{
                    "name": "fadeTime",
                    "value": 1.5
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setEventFade",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setEventFade');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setEventFade');
            var target = block.getFieldValue('target');
            target = EventActionFunctions.pre('Number')(target,block,'target','setEventFade');
            var fadeTime = block.getFieldValue('fadeTime');
            fadeTime = EventActionFunctions.pre('Number')(fadeTime,block,'fadeTime','setEventFade');
            var code = EventActionFunctions.defaultCode('setEventFade',eval('['+EventActionBlocks['setEventFade'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","target","fadeTime"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["IdString","Number","Number"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setEventFade',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setEventFade',inputs,next,isShadow,comment,attribute);
        }
    },
    "setPlayerFade": {
        "type": "statement",
        "json": {
            "type": "setPlayerFade",
            "message0": "设置玩家淡入淡出 %1 目标不透明度 %2 动画时长 %3",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.Number,{
                    "name": "target",
                    "value": 1
                }),
                Object.assign({},EventActionBlocks.Number,{
                    "name": "fadeTime",
                    "value": 1.5
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setPlayerFade",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var target = block.getFieldValue('target');
            target = EventActionFunctions.pre('Number')(target,block,'target','setPlayerFade');
            var fadeTime = block.getFieldValue('fadeTime');
            fadeTime = EventActionFunctions.pre('Number')(fadeTime,block,'fadeTime','setPlayerFade');
            var code = EventActionFunctions.defaultCode('setPlayerFade',eval('['+EventActionBlocks['setPlayerFade'].args.join(',')+']'),block);
            return code;
        },
        "args": ["target","fadeTime"],
        "argsType": ["field","field"],
        "argsGrammarName": ["Number","Number"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setPlayerFade',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setPlayerFade',inputs,next,isShadow,comment,attribute);
        }
    },
    "setPlayerMove": {
        "type": "statement",
        "json": {
            "type": "setPlayerMove",
            "message0": "设置主角移动路线(双击方块设置路线) %1 移动路线 %2 不等待 %3",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.RawEvalString_Multi,{
                    "name": "movingArr",
                    "text": "[2,4,6,8]"
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "noAwait",
                    "checked": false
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setPlayerMove",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var movingArr = block.getFieldValue('movingArr');
            if (movingArr==='') {
                throw new OmitedError(block,'movingArr','setPlayerMove');
            }
            movingArr = EventActionFunctions.pre('RawEvalString_Multi')(movingArr,block,'movingArr','setPlayerMove');
            var noAwait = block.getFieldValue('noAwait') === 'TRUE';
            noAwait = EventActionFunctions.pre('Bool')(noAwait,block,'noAwait','setPlayerMove');
            var code = EventActionFunctions.defaultCode('setPlayerMove',eval('['+EventActionBlocks['setPlayerMove'].args.join(',')+']'),block);
            return code;
        },
        "args": ["movingArr","noAwait"],
        "argsType": ["field","field"],
        "argsGrammarName": ["RawEvalString_Multi","Bool"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setPlayerMove',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setPlayerMove',inputs,next,isShadow,comment,attribute);
        }
    },
    "setCharacterMove": {
        "type": "statement",
        "json": {
            "type": "setCharacterMove",
            "message0": "设置角色移动路线(双击方块设置路线) %1 事件id %2 移动路线 %3 不等待 %4",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                Object.assign({},EventActionBlocks.RawEvalString_Multi,{
                    "name": "movingArr",
                    "text": "[2,4,6,8]"
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "noAwait",
                    "checked": false
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setCharacterMove",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setCharacterMove');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setCharacterMove');
            var movingArr = block.getFieldValue('movingArr');
            if (movingArr==='') {
                throw new OmitedError(block,'movingArr','setCharacterMove');
            }
            movingArr = EventActionFunctions.pre('RawEvalString_Multi')(movingArr,block,'movingArr','setCharacterMove');
            var noAwait = block.getFieldValue('noAwait') === 'TRUE';
            noAwait = EventActionFunctions.pre('Bool')(noAwait,block,'noAwait','setCharacterMove');
            var code = EventActionFunctions.defaultCode('setCharacterMove',eval('['+EventActionBlocks['setCharacterMove'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","movingArr","noAwait"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["IdString","RawEvalString_Multi","Bool"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setCharacterMove',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setCharacterMove',inputs,next,isShadow,comment,attribute);
        }
    },
    "setPlayerTexture": {
        "type": "statement",
        "json": {
            "type": "setPlayerTexture",
            "message0": "设置主角行走图 行走图 %1",
            "args0": [
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "player_texture"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setPlayerTexture",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var player_texture = block.getFieldValue('player_texture');
            if (player_texture==='') {
                throw new OmitedError(block,'player_texture','setPlayerTexture');
            }
            player_texture = EventActionFunctions.pre('IdString')(player_texture,block,'player_texture','setPlayerTexture');
            var code = EventActionFunctions.defaultCode('setPlayerTexture',eval('['+EventActionBlocks['setPlayerTexture'].args.join(',')+']'),block);
            return code;
        },
        "args": ["player_texture"],
        "argsType": ["field"],
        "argsGrammarName": ["IdString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setPlayerTexture',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setPlayerTexture',inputs,next,isShadow,comment,attribute);
        }
    },
    "setCharacterTexture": {
        "type": "statement",
        "json": {
            "type": "setCharacterTexture",
            "message0": "设置事件行走图 事件id %1 行走图 %2",
            "args0": [
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "character_texture"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setCharacterTexture",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setCharacterTexture');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setCharacterTexture');
            var character_texture = block.getFieldValue('character_texture');
            if (character_texture==='') {
                throw new OmitedError(block,'character_texture','setCharacterTexture');
            }
            character_texture = EventActionFunctions.pre('IdString')(character_texture,block,'character_texture','setCharacterTexture');
            var code = EventActionFunctions.defaultCode('setCharacterTexture',eval('['+EventActionBlocks['setCharacterTexture'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","character_texture"],
        "argsType": ["field","field"],
        "argsGrammarName": ["IdString","IdString"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setCharacterTexture',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setCharacterTexture',inputs,next,isShadow,comment,attribute);
        }
    },
    "setPlayerSpeed": {
        "type": "statement",
        "json": {
            "type": "setPlayerSpeed",
            "message0": "设置主角速度 速度 %1",
            "args0": [
                Object.assign({},EventActionBlocks.Number,{
                    "name": "speed",
                    "value": 5
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setPlayerSpeed",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var speed = block.getFieldValue('speed');
            speed = EventActionFunctions.pre('Number')(speed,block,'speed','setPlayerSpeed');
            var code = EventActionFunctions.defaultCode('setPlayerSpeed',eval('['+EventActionBlocks['setPlayerSpeed'].args.join(',')+']'),block);
            return code;
        },
        "args": ["speed"],
        "argsType": ["field"],
        "argsGrammarName": ["Number"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setPlayerSpeed',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setPlayerSpeed',inputs,next,isShadow,comment,attribute);
        }
    },
    "setCharacterSpeed": {
        "type": "statement",
        "json": {
            "type": "setCharacterSpeed",
            "message0": "设置角色速度 %1 事件id %2 速度 %3",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                Object.assign({},EventActionBlocks.Number,{
                    "name": "speed",
                    "value": 5
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setCharacterSpeed",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setCharacterSpeed');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setCharacterSpeed');
            var speed = block.getFieldValue('speed');
            speed = EventActionFunctions.pre('Number')(speed,block,'speed','setCharacterSpeed');
            var code = EventActionFunctions.defaultCode('setCharacterSpeed',eval('['+EventActionBlocks['setCharacterSpeed'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","speed"],
        "argsType": ["field","field"],
        "argsGrammarName": ["IdString","Number"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setCharacterSpeed',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setCharacterSpeed',inputs,next,isShadow,comment,attribute);
        }
    },
    "restorePlayerSpeed": {
        "type": "statement",
        "json": {
            "type": "restorePlayerSpeed",
            "message0": "根据配置还原角色速度",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "restorePlayerSpeed",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('restorePlayerSpeed',eval('['+EventActionBlocks['restorePlayerSpeed'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('restorePlayerSpeed',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('restorePlayerSpeed',inputs,next,isShadow,comment,attribute);
        }
    },
    "setPlayerJump": {
        "type": "statement",
        "json": {
            "type": "setPlayerJump",
            "message0": "设置主角跳跃 %1 x %2 y %3 不等待 %4",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.NInt,{
                    "name": "x",
                    "text": 0
                }),
                Object.assign({},EventActionBlocks.NInt,{
                    "name": "y",
                    "text": 0
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "noAwait",
                    "checked": false
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setPlayerJump",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var x = block.getFieldValue('x');
            if (x==='') {
                throw new OmitedError(block,'x','setPlayerJump');
            }
            x = EventActionFunctions.pre('NInt')(x,block,'x','setPlayerJump');
            var y = block.getFieldValue('y');
            if (y==='') {
                throw new OmitedError(block,'y','setPlayerJump');
            }
            y = EventActionFunctions.pre('NInt')(y,block,'y','setPlayerJump');
            var noAwait = block.getFieldValue('noAwait') === 'TRUE';
            noAwait = EventActionFunctions.pre('Bool')(noAwait,block,'noAwait','setPlayerJump');
            var code = EventActionFunctions.defaultCode('setPlayerJump',eval('['+EventActionBlocks['setPlayerJump'].args.join(',')+']'),block);
            return code;
        },
        "args": ["x","y","noAwait"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["NInt","NInt","Bool"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setPlayerJump',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setPlayerJump',inputs,next,isShadow,comment,attribute);
        }
    },
    "setCharacterJump": {
        "type": "statement",
        "json": {
            "type": "setCharacterJump",
            "message0": "设置角色跳跃 事件id %1 %2 x %3 y %4 不等待 %5",
            "args0": [
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.NInt,{
                    "name": "x",
                    "text": 0
                }),
                Object.assign({},EventActionBlocks.NInt,{
                    "name": "y",
                    "text": 0
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "noAwait",
                    "checked": false
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 190,
            "previousStatement": "setCharacterJump",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','setCharacterJump');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','setCharacterJump');
            var x = block.getFieldValue('x');
            if (x==='') {
                throw new OmitedError(block,'x','setCharacterJump');
            }
            x = EventActionFunctions.pre('NInt')(x,block,'x','setCharacterJump');
            var y = block.getFieldValue('y');
            if (y==='') {
                throw new OmitedError(block,'y','setCharacterJump');
            }
            y = EventActionFunctions.pre('NInt')(y,block,'y','setCharacterJump');
            var noAwait = block.getFieldValue('noAwait') === 'TRUE';
            noAwait = EventActionFunctions.pre('Bool')(noAwait,block,'noAwait','setCharacterJump');
            var code = EventActionFunctions.defaultCode('setCharacterJump',eval('['+EventActionBlocks['setCharacterJump'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","x","y","noAwait"],
        "argsType": ["field","field","field","field"],
        "argsGrammarName": ["IdString","NInt","NInt","Bool"],
        "omitted": [false,false,false,false],
        "multi": [false,false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('setCharacterJump',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('setCharacterJump',inputs,next,isShadow,comment,attribute);
        }
    },
    "showAnim": {
        "type": "statement",
        "json": {
            "type": "showAnim",
            "message0": "显示动画于事件 %1 事件id %2 特效id %3 动画跟随 %4",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "eventId"
                }),
                Object.assign({},EventActionBlocks.EffectId_List,{
                    "name": "effectId"
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "onNode"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 30,
            "previousStatement": "showAnim",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var eventId = block.getFieldValue('eventId');
            if (eventId==='') {
                throw new OmitedError(block,'eventId','showAnim');
            }
            eventId = EventActionFunctions.pre('IdString')(eventId,block,'eventId','showAnim');
            var effectId = block.getFieldValue('effectId');
            effectId = EventActionFunctions.pre('EffectId_List')(effectId,block,'effectId','showAnim');
            var onNode = block.getFieldValue('onNode') === 'TRUE';
            onNode = EventActionFunctions.pre('Bool')(onNode,block,'onNode','showAnim');
            var code = EventActionFunctions.defaultCode('showAnim',eval('['+EventActionBlocks['showAnim'].args.join(',')+']'),block);
            return code;
        },
        "args": ["eventId","effectId","onNode"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["IdString","EffectId_List","Bool"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('showAnim',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('showAnim',inputs,next,isShadow,comment,attribute);
        }
    },
    "showPlayerAnim": {
        "type": "statement",
        "json": {
            "type": "showPlayerAnim",
            "message0": "显示动画于角色 %1 特效id %2",
            "args0": [
                {
                    "type": "input_dummy"
                },
                Object.assign({},EventActionBlocks.EffectId_List,{
                    "name": "effectId"
                })
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 30,
            "previousStatement": "showPlayerAnim",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var effectId = block.getFieldValue('effectId');
            effectId = EventActionFunctions.pre('EffectId_List')(effectId,block,'effectId','showPlayerAnim');
            var code = EventActionFunctions.defaultCode('showPlayerAnim',eval('['+EventActionBlocks['showPlayerAnim'].args.join(',')+']'),block);
            return code;
        },
        "args": ["effectId"],
        "argsType": ["field"],
        "argsGrammarName": ["EffectId_List"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('showPlayerAnim',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('showPlayerAnim',inputs,next,isShadow,comment,attribute);
        }
    },
    "addFollower": {
        "type": "statement",
        "json": {
            "type": "addFollower",
            "message0": "添加跟随者 playerId %1",
            "args0": [
                Object.assign({},EventActionBlocks.Int,{
                    "name": "playerId"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "addFollower",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var playerId = block.getFieldValue('playerId');
            playerId = EventActionFunctions.pre('Int')(playerId,block,'playerId','addFollower');
            var code = EventActionFunctions.defaultCode('addFollower',eval('['+EventActionBlocks['addFollower'].args.join(',')+']'),block);
            return code;
        },
        "args": ["playerId"],
        "argsType": ["field"],
        "argsGrammarName": ["Int"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('addFollower',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('addFollower',inputs,next,isShadow,comment,attribute);
        }
    },
    "delFollower": {
        "type": "statement",
        "json": {
            "type": "delFollower",
            "message0": "删除跟随者 playerId %1",
            "args0": [
                Object.assign({},EventActionBlocks.Int,{
                    "name": "playerId"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "delFollower",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var playerId = block.getFieldValue('playerId');
            playerId = EventActionFunctions.pre('Int')(playerId,block,'playerId','delFollower');
            var code = EventActionFunctions.defaultCode('delFollower',eval('['+EventActionBlocks['delFollower'].args.join(',')+']'),block);
            return code;
        },
        "args": ["playerId"],
        "argsType": ["field"],
        "argsGrammarName": ["Int"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('delFollower',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('delFollower',inputs,next,isShadow,comment,attribute);
        }
    },
    "playSE": {
        "type": "statement",
        "json": {
            "type": "playSE",
            "message0": "播放音效 %1",
            "args0": [
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "v"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "playSE",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var v = block.getFieldValue('v');
            if (v==='') {
                throw new OmitedError(block,'v','playSE');
            }
            v = EventActionFunctions.pre('EvalString')(v,block,'v','playSE');
            var code = EventActionFunctions.defaultCode('playSE',eval('['+EventActionBlocks['playSE'].args.join(',')+']'),block);
            return code;
        },
        "args": ["v"],
        "argsType": ["field"],
        "argsGrammarName": ["EvalString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('playSE',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('playSE',inputs,next,isShadow,comment,attribute);
        }
    },
    "getItem": {
        "type": "statement",
        "json": {
            "type": "getItem",
            "message0": "获得道具 itemId %1 数量 %2 显示UI提示 %3",
            "args0": [
                Object.assign({},EventActionBlocks.Int,{
                    "name": "id"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "num"
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "hint"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "getItem",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var id = block.getFieldValue('id');
            id = EventActionFunctions.pre('Int')(id,block,'id','getItem');
            var num = block.getFieldValue('num');
            num = EventActionFunctions.pre('Int')(num,block,'num','getItem');
            var hint = block.getFieldValue('hint') === 'TRUE';
            hint = EventActionFunctions.pre('Bool')(hint,block,'hint','getItem');
            var code = EventActionFunctions.defaultCode('getItem',eval('['+EventActionBlocks['getItem'].args.join(',')+']'),block);
            return code;
        },
        "args": ["id","num","hint"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["Int","Int","Bool"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('getItem',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('getItem',inputs,next,isShadow,comment,attribute);
        }
    },
    "getEquip": {
        "type": "statement",
        "json": {
            "type": "getEquip",
            "message0": "获得装备 equipId %1 数量 %2 显示UI提示 %3",
            "args0": [
                Object.assign({},EventActionBlocks.Int,{
                    "name": "id"
                }),
                Object.assign({},EventActionBlocks.Int,{
                    "name": "num"
                }),
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "hint"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "getEquip",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var id = block.getFieldValue('id');
            id = EventActionFunctions.pre('Int')(id,block,'id','getEquip');
            var num = block.getFieldValue('num');
            num = EventActionFunctions.pre('Int')(num,block,'num','getEquip');
            var hint = block.getFieldValue('hint') === 'TRUE';
            hint = EventActionFunctions.pre('Bool')(hint,block,'hint','getEquip');
            var code = EventActionFunctions.defaultCode('getEquip',eval('['+EventActionBlocks['getEquip'].args.join(',')+']'),block);
            return code;
        },
        "args": ["id","num","hint"],
        "argsType": ["field","field","field"],
        "argsGrammarName": ["Int","Int","Bool"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('getEquip',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('getEquip',inputs,next,isShadow,comment,attribute);
        }
    },
    "refresh": {
        "type": "statement",
        "json": {
            "type": "refresh",
            "message0": "立即刷新",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 10,
            "previousStatement": "refresh",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('refresh',eval('['+EventActionBlocks['refresh'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('refresh',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('refresh',inputs,next,isShadow,comment,attribute);
        }
    },
    "callEnemyForm": {
        "type": "statement",
        "json": {
            "type": "callEnemyForm",
            "message0": "呼叫敌人界面 eventId %1",
            "args0": [
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "id"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 10,
            "previousStatement": "callEnemyForm",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var id = block.getFieldValue('id');
            if (id==='') {
                throw new OmitedError(block,'id','callEnemyForm');
            }
            id = EventActionFunctions.pre('IdString')(id,block,'id','callEnemyForm');
            var code = EventActionFunctions.defaultCode('callEnemyForm',eval('['+EventActionBlocks['callEnemyForm'].args.join(',')+']'),block);
            return code;
        },
        "args": ["id"],
        "argsType": ["field"],
        "argsGrammarName": ["IdString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('callEnemyForm',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('callEnemyForm',inputs,next,isShadow,comment,attribute);
        }
    },
    "callSaveForm": {
        "type": "statement",
        "json": {
            "type": "callSaveForm",
            "message0": "呼叫存档界面",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 10,
            "previousStatement": "callSaveForm",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('callSaveForm',eval('['+EventActionBlocks['callSaveForm'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('callSaveForm',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('callSaveForm',inputs,next,isShadow,comment,attribute);
        }
    },
    "returnMainMenu": {
        "type": "statement",
        "json": {
            "type": "returnMainMenu",
            "message0": "返回标题画面",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 10,
            "previousStatement": "returnMainMenu",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('returnMainMenu',eval('['+EventActionBlocks['returnMainMenu'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('returnMainMenu',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('returnMainMenu',inputs,next,isShadow,comment,attribute);
        }
    },
    "passAction": {
        "type": "statement",
        "json": {
            "type": "passAction",
            "message0": "pass",
            "args0": [],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 160,
            "previousStatement": "passAction",
            "nextStatement": EventActionBlocks.actions
        },
        "generFunc": function(block) {
            var code = EventActionFunctions.defaultCode('passAction',eval('['+EventActionBlocks['passAction'].args.join(',')+']'),block);
            return code;
        },
        "args": [],
        "argsType": [],
        "argsGrammarName": [],
        "omitted": [],
        "multi": [],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('passAction',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('passAction',inputs,next,isShadow,comment,attribute);
        }
    },
    "arithmetic": {
        "type": "value",
        "json": {
            "type": "arithmetic",
            "message0": "%1 %2 %3",
            "args0": [
                {
                    "type": "input_value",
                    "name": "a",
                    "check": EventActionBlocks.expr
                },
                Object.assign({},EventActionBlocks.Arithmetic_List,{
                    "name": "op"
                }),
                {
                    "type": "input_value",
                    "name": "b",
                    "check": EventActionBlocks.expr
                }
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 330,
            "output": "arithmetic"
        },
        "generFunc": function(block) {
            var a = Blockly.JavaScript.valueToCode(block, 'a', 
              Blockly.JavaScript.ORDER_ATOMIC);
            if (a==='') {
                throw new OmitedError(block,'a','arithmetic');
            }
            var op = block.getFieldValue('op');
            op = EventActionFunctions.pre('Arithmetic_List')(op,block,'op','arithmetic');
            var b = Blockly.JavaScript.valueToCode(block, 'b', 
              Blockly.JavaScript.ORDER_ATOMIC);
            if (b==='') {
                throw new OmitedError(block,'b','arithmetic');
            }
            var code = EventActionFunctions.defaultCode('arithmetic',eval('['+EventActionBlocks['arithmetic'].args.join(',')+']'),block);
            return [code, Blockly.JavaScript.ORDER_NONE];
        },
        "args": ["a","op","b"],
        "argsType": ["value","field","value"],
        "argsGrammarName": ["expr","Arithmetic_List","expr"],
        "omitted": [false,false,false],
        "multi": [false,false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('arithmetic',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('arithmetic',inputs,next,isShadow,comment,attribute);
        }
    },
    "notExpr": {
        "type": "value",
        "json": {
            "type": "notExpr",
            "message0": "非 %1",
            "args0": [
                {
                    "type": "input_value",
                    "name": "v",
                    "check": EventActionBlocks.expr
                }
            ],
            "tooltip": "",
            "helpUrl": "",
            "colour": 330,
            "output": "notExpr"
        },
        "generFunc": function(block) {
            var v = Blockly.JavaScript.valueToCode(block, 'v', 
              Blockly.JavaScript.ORDER_ATOMIC);
            if (v==='') {
                throw new OmitedError(block,'v','notExpr');
            }
            var code = EventActionFunctions.defaultCode('notExpr',eval('['+EventActionBlocks['notExpr'].args.join(',')+']'),block);
            return [code, Blockly.JavaScript.ORDER_NONE];
        },
        "args": ["v"],
        "argsType": ["value"],
        "argsGrammarName": ["expr"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('notExpr',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('notExpr',inputs,next,isShadow,comment,attribute);
        }
    },
    "boolExpr": {
        "type": "value",
        "json": {
            "type": "boolExpr",
            "message0": "%1",
            "args0": [
                Object.assign({},EventActionBlocks.Bool,{
                    "name": "v"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 330,
            "output": "boolExpr"
        },
        "generFunc": function(block) {
            var v = block.getFieldValue('v') === 'TRUE';
            v = EventActionFunctions.pre('Bool')(v,block,'v','boolExpr');
            var code = EventActionFunctions.defaultCode('boolExpr',eval('['+EventActionBlocks['boolExpr'].args.join(',')+']'),block);
            return [code, Blockly.JavaScript.ORDER_NONE];
        },
        "args": ["v"],
        "argsType": ["field"],
        "argsGrammarName": ["Bool"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('boolExpr',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('boolExpr',inputs,next,isShadow,comment,attribute);
        }
    },
    "fixedExpr": {
        "type": "value",
        "json": {
            "type": "fixedExpr",
            "message0": "%1",
            "args0": [
                Object.assign({},EventActionBlocks.FixedId_List,{
                    "name": "id"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 10,
            "output": "fixedExpr"
        },
        "generFunc": function(block) {
            var id = block.getFieldValue('id');
            id = EventActionFunctions.pre('FixedId_List')(id,block,'id','fixedExpr');
            var code = EventActionFunctions.defaultCode('fixedExpr',eval('['+EventActionBlocks['fixedExpr'].args.join(',')+']'),block);
            return [code, Blockly.JavaScript.ORDER_NONE];
        },
        "args": ["id"],
        "argsType": ["field"],
        "argsGrammarName": ["FixedId_List"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('fixedExpr',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('fixedExpr',inputs,next,isShadow,comment,attribute);
        }
    },
    "idRangeExpr": {
        "type": "value",
        "json": {
            "type": "idRangeExpr",
            "message0": "%1 : %2",
            "args0": [
                Object.assign({},EventActionBlocks.IdRange_List,{
                    "name": "r"
                }),
                Object.assign({},EventActionBlocks.IdString,{
                    "name": "id",
                    "text": "yellowKey"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 10,
            "output": "idRangeExpr"
        },
        "generFunc": function(block) {
            var r = block.getFieldValue('r');
            r = EventActionFunctions.pre('IdRange_List')(r,block,'r','idRangeExpr');
            var id = block.getFieldValue('id');
            if (id==='') {
                throw new OmitedError(block,'id','idRangeExpr');
            }
            id = EventActionFunctions.pre('IdString')(id,block,'id','idRangeExpr');
            var code = EventActionFunctions.defaultCode('idRangeExpr',eval('['+EventActionBlocks['idRangeExpr'].args.join(',')+']'),block);
            return [code, Blockly.JavaScript.ORDER_NONE];
        },
        "args": ["r","id"],
        "argsType": ["field","field"],
        "argsGrammarName": ["IdRange_List","IdString"],
        "omitted": [false,false],
        "multi": [false,false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('idRangeExpr',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('idRangeExpr',inputs,next,isShadow,comment,attribute);
        }
    },
    "idStringExpr": {
        "type": "value",
        "json": {
            "type": "idStringExpr",
            "message0": "变量ID %1",
            "args0": [
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "id"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 10,
            "output": "idStringExpr"
        },
        "generFunc": function(block) {
            var id = block.getFieldValue('id');
            if (id==='') {
                throw new OmitedError(block,'id','idStringExpr');
            }
            id = EventActionFunctions.pre('EvalString')(id,block,'id','idStringExpr');
            var code = EventActionFunctions.defaultCode('idStringExpr',eval('['+EventActionBlocks['idStringExpr'].args.join(',')+']'),block);
            return [code, Blockly.JavaScript.ORDER_NONE];
        },
        "args": ["id"],
        "argsType": ["field"],
        "argsGrammarName": ["EvalString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('idStringExpr',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('idStringExpr',inputs,next,isShadow,comment,attribute);
        }
    },
    "evalStringExpr": {
        "type": "value",
        "json": {
            "type": "evalStringExpr",
            "message0": "%1",
            "args0": [
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "v"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 330,
            "output": "evalStringExpr"
        },
        "generFunc": function(block) {
            var v = block.getFieldValue('v');
            if (v==='') {
                throw new OmitedError(block,'v','evalStringExpr');
            }
            v = EventActionFunctions.pre('EvalString')(v,block,'v','evalStringExpr');
            var code = EventActionFunctions.defaultCode('evalStringExpr',eval('['+EventActionBlocks['evalStringExpr'].args.join(',')+']'),block);
            return [code, Blockly.JavaScript.ORDER_NONE];
        },
        "args": ["v"],
        "argsType": ["field"],
        "argsGrammarName": ["EvalString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('evalStringExpr',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('evalStringExpr',inputs,next,isShadow,comment,attribute);
        }
    },
    "scriptExpr": {
        "type": "value",
        "json": {
            "type": "scriptExpr",
            "message0": "脚本 %1",
            "args0": [
                Object.assign({},EventActionBlocks.EvalString,{
                    "name": "v"
                })
            ],
            "inputsInline": true,
            "tooltip": "",
            "helpUrl": "",
            "colour": 330,
            "output": "scriptExpr"
        },
        "generFunc": function(block) {
            var v = block.getFieldValue('v');
            if (v==='') {
                throw new OmitedError(block,'v','scriptExpr');
            }
            v = EventActionFunctions.pre('EvalString')(v,block,'v','scriptExpr');
            var code = EventActionFunctions.defaultCode('scriptExpr',eval('['+EventActionBlocks['scriptExpr'].args.join(',')+']'),block);
            return [code, Blockly.JavaScript.ORDER_NONE];
        },
        "args": ["v"],
        "argsType": ["field"],
        "argsGrammarName": ["EvalString"],
        "omitted": [false],
        "multi": [false],
        "fieldDefault": function (keyOrIndex) {
            return EventActionFunctions.fieldDefault('scriptExpr',keyOrIndex);
        },
        "menu": [],
        "xmlText": function (inputs,next,isShadow,comment,attribute) {
            return EventActionFunctions.xmlText('scriptExpr',inputs,next,isShadow,comment,attribute);
        }
    }
});



//生成代码中,当一个不允许省略的值或块省略时,会抛出这个错误
function OmitedError(block, var_, rule, fileName, lineNumber) {
    var message = 'no omitted '+var_+' at '+rule;
    var instance = new Error(message, fileName, lineNumber);
    instance.block = block;
    instance.varName = var_;
    instance.blockName = rule;
    instance.name = 'OmitedError';
    Object.setPrototypeOf(instance, Object.getPrototypeOf(this));
    if (Error.captureStackTrace) {
        Error.captureStackTrace(instance, OmitedError);
    }
    return instance;
}

OmitedError.prototype = Object.create(Error.prototype);
OmitedError.prototype.constructor = OmitedError;
//处理此错误的omitedcheckUpdateFunction定义在下面

//生成代码中,当一个不允许多个语句输入的块放入多语句时,会抛出这个错误
function MultiStatementError(block, var_, rule, fileName, lineNumber) {
    var message = 'no multi-Statement '+var_+' at '+rule;
    var instance = new Error(message, fileName, lineNumber);
    instance.block = block;
    instance.varName = var_;
    instance.blockName = rule;
    instance.name = 'MultiStatementError';
    Object.setPrototypeOf(instance, Object.getPrototypeOf(this));
    if (Error.captureStackTrace) {
        Error.captureStackTrace(instance, MultiStatementError);
    }
    return instance;
}

MultiStatementError.prototype = Object.create(Error.prototype);
MultiStatementError.prototype.constructor = MultiStatementError;
//处理此错误的omitedcheckUpdateFunction定义在下面


EventActionFunctions={}


EventActionFunctions.Int_pre = function(intstr) {
    return parseInt(intstr);
}

EventActionFunctions.Number_pre = function(intstr) {
    return parseFloat(intstr);
}

//返回各LexerRule文本域的预处理函数,方便用来统一转义等等
EventActionFunctions.pre = function(LexerId) {
    if (EventActionFunctions.hasOwnProperty(LexerId+'_pre')) {
        return EventActionFunctions[LexerId+'_pre'];
    }
    return function(obj,block,fieldName,blockType){return obj}
}



// EventActionFunctions.fieldDefault
// 根据输入是整数字符串或null
// 第index个或者名字为key的域的默认值, null时返回所有field默认值的数组
EventActionFunctions.fieldDefault = function (ruleName,keyOrIndex) {
    var rule = EventActionBlocks[ruleName];
    var iskey=typeof keyOrIndex==typeof '';
    var isindex=typeof keyOrIndex==typeof 0;
    function args0_content_to_default(cnt) {
        var key = ({
            'field_input':'text',
            'field_multilinetext':'text',
            'field_number':'value',
            'field_dropdown':'default',
            'field_checkbox':'checked',
            'field_colour':'colour',
            'field_angle':'angle',
            // 'field_image':'src'
        })[cnt.type];
        return cnt[key];
    }
    var allDefault=[];
    for(var ii=0,index=-1,cnt;cnt=rule.json.args0[ii];ii++){
        if (!cnt.name || cnt.type.slice(0,5)!='field' || cnt.type=='field_image') continue;
        index++;
        if (iskey && cnt.name==keyOrIndex)return args0_content_to_default(cnt);
        if (isindex && index==keyOrIndex)return args0_content_to_default(cnt);
        allDefault.push(args0_content_to_default(cnt))
    }
    if (iskey || isindex) return undefined;
    return allDefault;
}



// EventActionFunctions.defaultCode_TEXT
EventActionFunctions.defaultCode_TEXT = function (ruleName,args,block) {
    var rule = EventActionBlocks[ruleName];
    var message=rule.json.message0;
    var args0=rule.json.args0;
    for(var ii=0,jj=0;ii<args0.length;ii++){
        message=message.split(new RegExp('%'+(ii+1)+'\\b'));
        var content='\n';
        if (args0[ii].type==='input_dummy') {
            message[1]=message[1].slice(1);
        } else if(args0[ii].type==='field_image') {
            content=args0[ii].alt;
        } else {
            content=args[jj++];
        }
        if (args0[ii].type=="input_statement") {
            message[0]=message[0]+'\n';
            message[1]=message[1].slice(1);
        }
        message=message.join(content);
    }
    if (rule.type=='statement') {
        message=message+'\n';
    }
    return message;
}

EventActionFunctions.defaultCode_JSON_TYPE='type'

EventActionFunctions.parserPre={}
EventActionFunctions.parserPre.pre = function(LexerId) {
    if (EventActionFunctions.parserPre.hasOwnProperty(LexerId+'_pre')) {
        return EventActionFunctions.parserPre[LexerId+'_pre'];
    }
    return function(obj,blockObj,fieldName,blockType,index){return obj}
}
/** @class */
EventActionFunctions.parserClass = function (params) {
}
EventActionFunctions.parserClass.prototype.parse = function (obj,next) {
    var blockType = obj[EventActionFunctions.defaultCode_JSON_TYPE]
    var rule = EventActionBlocks[blockType]
    if (EventActionFunctions.parserPre.hasOwnProperty(blockType+'_pre')) {
        obj = EventActionFunctions.parserPre[blockType+'_pre'](obj)
    }
    var input = []
    for (var index = 0; index < rule.args.length; index++) {
        var dobj = obj[rule.args[index]];
        if (rule.argsType[index]==='statement') {
            if (!rule.multi[index])dobj=[dobj];
            var snext=null
            while (dobj.length) {
                var ds=dobj.pop()
                snext=this.parse(ds,snext)
            }
            input.push(snext)
        } else if (rule.argsType[index]==='value') {
            input.push(this.parse(dobj))
        } else {
            var LexerId = rule.argsGrammarName[index]
            input.push(EventActionFunctions.parserPre.pre(LexerId)(dobj,obj,rule.args[index],blockType,index))
        }
    }
    return rule.xmlText(input,next)
}
EventActionFunctions.parser=new EventActionFunctions.parserClass()
EventActionFunctions.parse=function(obj){
    var xml_text = EventActionFunctions.parser.parse(obj);
    var xml = Blockly.Xml.textToDom('<xml>'+xml_text+'</xml>');
    EventActionFunctions.workspace().clear();
    Blockly.Xml.domToWorkspace(xml, EventActionFunctions.workspace());
}

// EventActionFunctions.defaultCode_JSON
EventActionFunctions.defaultCode_JSON = function (ruleName,args,block) {
    var rule = EventActionBlocks[ruleName];
    var values=args
    var output={}
    var ret=''
    if (rule.type==='statement'||rule.type==='value') {
        output[EventActionFunctions.defaultCode_JSON_TYPE]=rule.json.type
        ret=block.getNextBlock()==null?'':','
    }
    for (var index = 0; index < values.length; index++) {
        var value = values[index];
        if (rule.argsType[index]==='statement') {
            output[rule.args[index]]=eval('['+value+']')
            if (!rule.multi[index]) output[rule.args[index]]=output[rule.args[index]][0];
        } else if (rule.argsType[index]==='value') {
            output[rule.args[index]]=eval('('+value+')')
        } else {
            output[rule.args[index]]=value
        }
    }
    ret=JSON.stringify(output,null,4)+ret
    return ret
}

// EventActionFunctions.defaultCode
EventActionFunctions.defaultCode=EventActionFunctions.defaultCode_JSON



// EventActionFunctions.xmlText
// 构造这个方法是为了能够不借助workspace,从语法树直接构造图块结构
// inputs的第i个元素是第i个args的xmlText,null或undefined表示空
// next是其下一个语句的xmlText
EventActionFunctions.xmlText = function (ruleName,inputs,next,isShadow,comment,attribute) {
    var rule = EventActionBlocks[ruleName];
    var blocktext = isShadow?'shadow':'block';
    var xmlText = [];
    xmlText.push('<'+blocktext+' type="'+ruleName+'"');
    for (var attr in attribute) {
        xmlText.push(' '+attr+'="'+attribute[attr]+'"');
    }
    xmlText.push('>');
    if(!inputs)inputs=[];
    var inputIsArray = inputs instanceof Array;
    for (var ii=0,inputType;inputType=rule.argsType[ii];ii++) {
        var input = inputIsArray?inputs[ii]:inputs[rule.args[ii]];
        var _input = '';
        var noinput = input==null;
        if(noinput && inputType==='field' && EventActionBlocks[rule.argsGrammarName[ii]].type!=='field_dropdown') continue;
        if(noinput && inputType==='field') {
            noinput = false;
            input = rule.fieldDefault(rule.args[ii])
        }
        if(noinput) input = '';
        if(inputType==='field' && EventActionBlocks[rule.argsGrammarName[ii]].type==='field_checkbox')input=input?'TRUE':'FALSE';
        if(inputType!=='field') {
            var subList = false;
            var subrulename = rule.argsGrammarName[ii];
            var subrule = EventActionBlocks[subrulename];
            if (subrule instanceof Array) {
                subrulename=subrule[subrule.length-1];
                subrule = EventActionBlocks[subrulename];
                subList = true;
            }
            _input = subrule.xmlText([],null,true);
            if(noinput && !subList && !isShadow) {
                //无输入的默认行为是: 如果语句块的备选方块只有一个,直接代入方块
                input = subrule.xmlText();
            }
        }
        xmlText.push('<'+inputType+' name="'+rule.args[ii]+'">');
        xmlText.push(_input+input);
        xmlText.push('</'+inputType+'>');
    }
    if(comment){
        xmlText.push('<comment><![CDATA[');
        xmlText.push(comment.replace(/]]>/g,'] ] >'));
        xmlText.push(']]></comment>');
    }
    if (next) {
        xmlText.push('<next>');
        xmlText.push(next);
        xmlText.push('</next>');
    }
    xmlText.push('</'+blocktext+'>');
    return xmlText.join('');
}



// EventActionFunctions.blocksIniter
// 把各方块的信息注册到Blockly中
EventActionFunctions.blocksIniter = function(){
    var blocksobj = EventActionBlocks;
    for(var key in blocksobj) {
        var value = blocksobj[key];
        if(value instanceof Array)continue;
        if(/^[A-Z].*$/.exec(key))continue;
        (function(key,value){
            if (value.menu && value.menu.length) {
                var menuRegisterMixin={
                    customContextMenu: function(options) {
                        for(var ii=0,op;op=value.menu[ii];ii++){
                            var option = {enabled: true};
                            option.text = op[0];
                            var check = 'function('
                            if (option.text.slice(0,check.length)==check){
                                option.text=eval('('+option.text+')(this)');
                            }
                            (function(block,fstr){
                                option.callback = function(){
                                    eval(fstr)
                                }
                            })(this,op[1]);
                            options.push(option);
                        }
                    }
                };
                value.json.extensions=value.json.extensions||[];
                var mixinName = 'contextMenu_EventAction_'+value.json.type
                value.json.extensions.push(mixinName)
                Blockly.Extensions.registerMixin(mixinName,menuRegisterMixin);
            }
            Blockly.Blocks[key] = {
                init: function() {this.jsonInit(value.json);}
            }
            Blockly.JavaScript[key] = value.generFunc;
        })(key,value);
    }
}


function getToolbox(){
    
    var toolboxXml=document.createElement('xml')

    // 调整这个obj来更改侧边栏和其中的方块
    // 可以直接填 '<block type="xxx">...</block>'
    // 标签 '<label text="标签文本"></label>'
    var toolboxObj = {
        // 每个键值对作为一页
        "statement":Object.keys(EventActionBlocks).filter(k=>{var v=EventActionBlocks[k];return v.type=='statement'}).map(k=>EventActionBlocks[k].xmlText()),
        "value":Object.keys(EventActionBlocks).filter(k=>{var v=EventActionBlocks[k];return v.type=='value'}).map(k=>EventActionBlocks[k].xmlText()).concat([
            EventActionFunctions.parser.parse({"type": "scriptExpr","v": "MotaSystem.gameData.findPlayerEquip(1)"}),
            EventActionFunctions.parser.parse({"type": "scriptExpr","v": "MotaSystem.gameVariables[\"gameProgress\"]>=1"}),
            EventActionFunctions.parser.parse({
                "type": "arithmetic",
                "a": {
                    "type": "idStringExpr",
                    "id": "gameProgress"
                },
                "op": ">=",
                "b": {
                    "type": "evalStringExpr",
                    "v": "2"
                }
            }),
            EventActionFunctions.parser.parse({"type": "scriptExpr","v": "MotaSystem.gameVariables[\"temp\"]>=2"}),
        ]),
        "example":[
            EventActionFunctions.parser.parse(
            {
                "type": "ifAction",
                "condition": {
                    "type": "scriptExpr",
                    "v": "MotaSystem.gameData.findPlayerEquip(1)"
                },
                "trueActions": [
                    {
                        "type": "comment",
                        "text": "装备1号装备时"
                    },
                    {
                        "type": "showText",
                        "name": "",
                        "face": "",
                        "textPos": "Down",
                        "backGround": true,
                        "text": "看起来你装上了装备"
                    }
                ],
                "falseActions": [
                    {
                        "type": "passAction"
                    }
                ]
            }),
            EventActionFunctions.parser.parse({
                "type": "actionArr",
                "actions": [
                    {
                        "type": "comment",
                        "text": "变黑"
                    },
                    {
                        "type": "changeMapColor_RGB",
                        "rgb": "#000000",
                        "a": 1,
                        "duration": 2
                    },
                    {
                        "type": "sleep",
                        "time": 2
                    },
                    {
                        "type": "comment",
                        "text": "恢复"
                    },
                    {
                        "type": "changeMapColor_RGB",
                        "rgb": "#ffffff",
                        "a": 1,
                        "duration": 2
                    },
                    {
                        "type": "sleep",
                        "time": 2
                    }
                ]
            }),
            EventActionFunctions.parser.parse({
                "type": "actionArr",
                "actions": [
                    {
                        "type": "comment",
                        "text": "开门动画"
                    },
                    {
                        "type": "script",
                        "script": "AudioManager.playSE(\"Key & Lock 2-1.wav\")"
                    },
                    {
                        "type": "setEventDirection",
                        "eventId": "self",
                        "d": "Down"
                    },
                    {
                        "type": "sleep",
                        "time": 0.05
                    },
                    {
                        "type": "setEventDirection",
                        "eventId": "self",
                        "d": "Left"
                    },
                    {
                        "type": "sleep",
                        "time": 0.05
                    },
                    {
                        "type": "setEventDirection",
                        "eventId": "self",
                        "d": "Right"
                    },
                    {
                        "type": "sleep",
                        "time": 0.05
                    },
                    {
                        "type": "setEventDirection",
                        "eventId": "self",
                        "d": "Up"
                    },
                    {
                        "type": "sleep",
                        "time": 0.05
                    }
                ]
            }),
            EventActionFunctions.parser.parse({
                "type": "actionArr",
                "actions": [
                    {
                        "type": "comment",
                        "text": "章节结束时通用"
                    },
                    {
                        "type": "showChoice",
                        "name": "",
                        "face": "",
                        "textPos": "Down",
                        "backGround": true,
                        "text": "即将进入新的领域，要继续前进吗？",
                        "esc": true,
                        "choices": [
                            {
                                "type": "choices",
                                "text": "是",
                                "actions": [
                                    {
                                        "type": "specialEvent",
                                        "eventType": "ChapterEndEvent"
                                    }
                                ]
                            },
                            {
                                "type": "choices",
                                "text": "否",
                                "actions": [
                                    {
                                        "type": "passAction"
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }),
            EventActionBlocks["showText"].xmlText(),
            EventActionFunctions.parser.parse({"type": "comment","text": "下一栏是搜索结果以及储存的事件队列内容"}),
        ],
        // "all":Object.keys(EventActionBlocks).filter(k=>{var v=EventActionBlocks[k];return v.json}).map(k=>EventActionBlocks[k].xmlText()),
        "search":['<label text="此处只是占位符,实际定义在searchBlockCategoryCallback中"></label>'],
    }

    var getCategory = function(toolboxXml,name,custom){
        var node = document.createElement('category');
        node.setAttribute('name',name);
        if(custom)node.setAttribute('custom',custom);
        toolboxXml.appendChild(node);
        return node;
    }

    var toolboxGap = '<sep gap="5"></sep>'

    for (var name in toolboxObj){
        var custom = null;
        if(name=='search')custom='searchBlockCategory';
        if(name=='zzzzzz')custom='zzzzzz';
        getCategory(toolboxXml,name,custom).innerHTML = toolboxObj[name].join(toolboxGap);
        var node = document.createElement('sep');
        node.setAttribute('gap',5*3);
        toolboxXml.appendChild(node);
    }

    return toolboxXml;

}

function searchBlockCategoryCallback(workspace){
    var xmlList = [];
    var labels = window.searchBlock();
    for (var i = 0; i < labels.length; i++) {
        var blockText = '<xml>' +
            (labels[i] in EventActionBlocks?EventActionBlocks[labels[i]].xmlText():EventActionFunctions.parser.parse(labels[i])) +
            '</xml>';
        var block = Blockly.Xml.textToDom(blockText).firstChild;
        block.setAttribute("gap", 5);
        xmlList.push(block);
    }
    return xmlList;
}

function callAtEnd(){
    EventActionFunctions.workspace().registerToolboxCategoryCallback('searchBlockCategory', searchBlockCategoryCallback);
}
//需要保留这个分号
;EventActionFunctions.blocksIniter();


var toolbox = (function(){

    var toolboxXml=document.createElement('xml')

    // 调整这个obj来更改侧边栏和其中的方块
    // 可以直接填 '<block type="xxx">...</block>'
    // 标签 '<label text="标签文本"></label>'
    var toolboxObj = {
        // 每个键值对作为一页
        "statement": [
            // 所有语句块
            EventActionBlocks["actionArr"].xmlText(),
            EventActionBlocks["showText"].xmlText(),
            EventActionBlocks["showFukiText"].xmlText(),
            EventActionBlocks["showChoice"].xmlText(),
            EventActionBlocks["choices"].xmlText(),
            EventActionBlocks["comment"].xmlText(),
            EventActionBlocks["sleep"].xmlText(),
            EventActionBlocks["script"].xmlText(),
            EventActionBlocks["setValue"].xmlText(),
            EventActionBlocks["ifAction"].xmlText(),
            EventActionBlocks["commonEventP"].xmlText(),
            EventActionBlocks["specialEvent"].xmlText(),
            EventActionBlocks["nextPage"].xmlText(),
            EventActionBlocks["pageTo"].xmlText(),
            EventActionBlocks["dead"].xmlText(),
            EventActionBlocks["changeMapColor_RGB"].xmlText(),
            EventActionBlocks["changeWhiteMaskColor_RGB"].xmlText(),
            EventActionBlocks["shakeOn"].xmlText(),
            EventActionBlocks["shakeOff"].xmlText(),
            EventActionBlocks["setMapScale"].xmlText(),
            EventActionBlocks["scrollCameraStart"].xmlText(),
            EventActionBlocks["scrollCamera"].xmlText(),
            EventActionBlocks["scrollCameraEnd"].xmlText(),
            EventActionBlocks["transferPlayer"].xmlText(),
            EventActionBlocks["startEvent"].xmlText(),
            EventActionBlocks["setEventPage"].xmlText(),
            EventActionBlocks["setEventDead"].xmlText(),
            EventActionBlocks["setEventDead_map"].xmlText(),
            EventActionBlocks["setEventPosition"].xmlText(),
            EventActionBlocks["setEventDirection"].xmlText(),
            EventActionBlocks["setPlayerPosition"].xmlText(),
            EventActionBlocks["setPlayerDirection"].xmlText(),
            EventActionBlocks["setEventFade"].xmlText(),
            EventActionBlocks["setPlayerFade"].xmlText(),
            EventActionBlocks["setPlayerMove"].xmlText(),
            EventActionBlocks["setCharacterMove"].xmlText(),
            EventActionBlocks["setPlayerTexture"].xmlText(),
            EventActionBlocks["setCharacterTexture"].xmlText(),
            EventActionBlocks["setPlayerSpeed"].xmlText(),
            EventActionBlocks["setCharacterSpeed"].xmlText(),
            EventActionBlocks["restorePlayerSpeed"].xmlText(),
            EventActionBlocks["setPlayerJump"].xmlText(),
            EventActionBlocks["setCharacterJump"].xmlText(),
            EventActionBlocks["showAnim"].xmlText(),
            EventActionBlocks["showPlayerAnim"].xmlText(),
            EventActionBlocks["addFollower"].xmlText(),
            EventActionBlocks["delFollower"].xmlText(),
            EventActionBlocks["playSE"].xmlText(),
            EventActionBlocks["getItem"].xmlText(),
            EventActionBlocks["getEquip"].xmlText(),
            EventActionBlocks["refresh"].xmlText(),
            EventActionBlocks["callEnemyForm"].xmlText(),
            EventActionBlocks["callSaveForm"].xmlText(),
            EventActionBlocks["returnMainMenu"].xmlText(),
            EventActionBlocks["passAction"].xmlText(),
        ],
        "value": [
            // 所有值块
            EventActionBlocks["arithmetic"].xmlText(),
            EventActionBlocks["notExpr"].xmlText(),
            EventActionBlocks["boolExpr"].xmlText(),
            EventActionBlocks["fixedExpr"].xmlText(),
            EventActionBlocks["idRangeExpr"].xmlText(),
            EventActionBlocks["idStringExpr"].xmlText(),
            EventActionBlocks["evalStringExpr"].xmlText(),
            EventActionBlocks["scriptExpr"].xmlText(),
        ]
    }

    var getCategory = function(toolboxXml,name,custom){
        var node = document.createElement('category');
        node.setAttribute('name',name);
        if(custom)node.setAttribute('custom',custom);
        toolboxXml.appendChild(node);
        return node;
    }

    var toolboxGap = '<sep gap="5"></sep>'

    for (var name in toolboxObj){
        var custom = null;
        if(name=='xxxxxx')custom='xxxxxx';
        if(name=='zzzzzz')custom='zzzzzz';
        getCategory(toolboxXml,name,custom).innerHTML = toolboxObj[name].join(toolboxGap);
        var node = document.createElement('sep');
        node.setAttribute('gap',5*3);
        toolboxXml.appendChild(node);
    }

    return toolboxXml;
})();



    
    toolbox = getToolbox()
    
    var workspace = Blockly.inject('blocklyDiv',{
        media: '../antlr-blockly/media/',
        toolbox: toolbox,
        zoom:{
            controls: true,
            wheel: false,//false
            startScale: 0.7,
            maxScale: 1.2,
            minScale: 0.2,
            scaleSpeed: 1.08
        },
        trashcan: false,
    });
    EventActionFunctions.workspace = function(){return workspace}
    
    var doubleClickCheck=[[0,'abc']];
    function omitedcheckUpdateFunction(event) {
        var codeAreaFunc = function(err,data){blocklyinput.value=err?String(err):data;window?.trigger?.call(null,[err,data])}
        try {
            if(event.type==='ui' && event.element == 'click'){
                var newClick = [new Date().getTime(),event.blockId];
                var lastClick = doubleClickCheck.shift();
                doubleClickCheck.push(newClick);
                if(newClick[0]-lastClick[0]<500){
                    if(newClick[1]===lastClick[1]){
                        window?.blocklyDoubleClickBlock?.call(null,newClick[1]);
                    }
                }
              }
            if (["delete","create","move","finished_loading"].indexOf(event.type)!==-1) return;
            var code = Blockly.JavaScript.workspaceToCode(workspace);
            codeAreaFunc(null,code);
        } catch (error) {
            codeAreaFunc(error,null);
            if (error instanceof OmitedError ||error instanceof MultiStatementError){
                var blockName = error.blockName;
                var varName = error.varName;
                var block = error.block;
            }
            console.log(error);
        }
    }
    
    workspace.addChangeListener(omitedcheckUpdateFunction);
    
//自动禁用任何未连接到根块的块
workspace.addChangeListener(Blockly.Events.disableOrphans);


// debugFunctions
function showXML() {
    xml = Blockly.Xml.workspaceToDom(workspace);
    xml_text = Blockly.Xml.domToPrettyText(xml);
    console.log(xml_text);
    xml_text = Blockly.Xml.domToText(xml);
    console.log(xml_text);
    console.log(xml);
}

function runCode() {
    // Generate JavaScript code and run it.
    window.LoopTrap = 1000;
    Blockly.JavaScript.INFINITE_LOOP_TRAP =
        'if (--window.LoopTrap == 0) throw "Infinite loop.";\n';
    code = Blockly.JavaScript.workspaceToCode(workspace);
    Blockly.JavaScript.INFINITE_LOOP_TRAP = null;
    try {
        eval('obj=' + code);
        console.log(obj);
    } catch (e) {
        alert(e);
    }
}

    callAtEnd()
    window.buildBlocks&&window.buildBlocks()
    