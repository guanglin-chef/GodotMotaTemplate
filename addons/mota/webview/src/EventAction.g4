// 使用vscode插件 mota-js extension可以正确高亮此文件以及其内部的嵌入
grammar EventAction;

actionArr
    :   '动作列表' BGNL
    actions=actions*
/* actionArr
defaultMap: {}
*/;

actions
    :   showText
    |   showFukiText
    |   showChoice
    |   sleep
    |   script
    |   comment
    |   setValue
    |   ifAction
    |   specialEvent
    |   commonEventP
    |   transferPlayer
    |   nextPage
    |   pageTo
    |   dead
    |   changeMapColor_RGB
    |   changeWhiteMaskColor_RGB
    |   shakeOn
    |   shakeOff
    |   setMapScale
    |   scrollCameraStart
    |   scrollCamera
    |   scrollCameraEnd
    |   startEvent
    |   setEventPage
    |   setEventDead
    |   setEventPosition
    |   setEventDirection
    |   setPlayerPosition
    |   setEventDead_map
    |   setEventFade
    |   setPlayerFade
    |   setPlayerMove
    |   setCharacterMove
    |   setPlayerTexture
    |   setPlayerDirection
    |   setCharacterTexture
    |   setPlayerSpeed
    |   setCharacterSpeed
    |   restorePlayerSpeed
    |   setPlayerJump
    |   setCharacterJump
    |   showAnim
    |   showPlayerAnim
    |   addFollower
    |   delFollower
    |   playSE
    |   getItem
    |   getEquip
    |   callEnemyForm
    |   callSaveForm
    |   refresh
    |   returnMainMenu
    |   passAction
    ;


showText
    :   '显示文章:'
    BGNL
    '人物: ' '名称' name=EvalString? 
    '头像' battlersPicture=EvalString? 
    BGNL
    '文本: ' '位置' textPos=TextPosition_List
    '外框' backGround=Bool
    BGNL
    text=EvalString_Multi
/* showText
defaultMap: {text:'*一段剧情*',name:'',battlersPicture:'',textPos:'Down',backGround:'TRUE'}
menu:[['合并回集成版本','window.convertShowTextDicBack?convertShowTextDicBack(block):0']]
*/;

showFukiText
    :   '显示文章（事件跟随）:' '事件' eventName=EvalString? 
    BGNL
    '人物: ' '名称' name=EvalString? '头像' battlersPicture=EvalString? 
    BGNL
    text=EvalString_Multi
/* showFukiText
defaultMap: {text:'*一段剧情*',name:'',eventName:'',battlersPicture:''}
*/;

showChoice
    :   '显示选择项'
    BGNL
    '人物: ' '名称' name=EvalString? 
    '头像' battlersPicture=EvalString? 
    BGNL
    '文本: ' '位置' textPos=TextPosition_List
    '外框' backGround=Bool
    BGNL
    text=EvalString_Multi? 
    '手动取消' esc=Bool 
    BGNL
    choices=choices+
/* showChoice
defaultMap: {text:'',name:'',battlersPicture:'',textPos:'Down',backGround:'TRUE'}
*/;

choices
    :   '选项' text=EvalString BGNL '执行' actions=actions*
/* choices
defaultMap: {text:'攻击'}
color: this.subColor
*/;

comment
    :   '注释' text=EvalString
/* comment
defaultMap: {text:'可以在这里写添加任何注释内容'}
*/;

sleep
    :   '等待 秒数' time=Number
/* sleep
defaultMap: {time:0.5}
*/;

script
    :   '脚本代码' script=RawEvalString_Multi
/* script
defaultMap: {script:'print(thisobj)'}
*/;

//左值必须是id
setValue
    :   '变量操作' '左侧必须为变量ID' name=idExpr op=SetOP_List value=expr
/* setValue
defaultMap: {}
color: this.setColor
*/;

ifAction
    :   '符合条件(表达式)' condition=expr_order_for_if BGNL trueActions=actions* '不符合' BGNL  falseActions=actions*
/* ifAction
color: this.flowColor
*/;

commonEventP
    :   '公共事件库' BGNL commonEventId=CommonEventP_List
/* commonEventP
defaultMap: {commonEventId:'e1/text1'}
color: this.flowColor
*/;

specialEvent
    :   '特别事件' BGNL eventType=SpecialEvent_List
/* specialEvent
defaultMap: {eventType:''}
color: this.flowColor
*/;

nextPage
    :   '本事件翻至下一页'
/* nextPage
defaultMap: {}
color: this.deadColor
*/;

pageTo
    :   '本事件翻页至' index=Int
/* pageTo
defaultMap: {}
color: this.deadColor
*/;

dead
    :   '本事件结束'
/* dead
defaultMap: {}
color: this.deadColor
*/;

changeMapColor_RGB
    :   '更改画面色调(RGB)' BGNL 'RGB' rgb=Colour 'A' a=Number BGNL '时长 (秒)' duration=Number
/* changeMapColor_RGB
defaultMap: {rgb:'#ffffff',a:1,duration:1.5}
color: this.sceneColor
*/;

changeWhiteMaskColor_RGB
    :   '更改白色幕布色调(RGB)' BGNL 'RGB' rgb=Colour 'A' a=Number BGNL '时长 (秒)' duration=Number
/* changeWhiteMaskColor_RGB
defaultMap: {rgb:'#ffffff',a:1,duration:1.5}
color: this.sceneColor
*/;

shakeOn
    :   '画面震动开始' BGNL '震动幅度' strength=Int '每多少帧震动一次' shakelength=Int
/* shakeOn
defaultMap: {strenth:10,shakelength:3}
color: this.sceneColor
*/;

shakeOff
    :   '画面震动结束'
/* shakeOff
defaultMap: {}
color: this.sceneColor
*/;

setMapScale
    :   '设置大地图缩放(0.5-1.0)' scale=Number
/* setMapScale
defaultMap: {scale:1.0}
color: this.sceneColor
*/;

scrollCameraStart
    :   '画面卷动开始（切换卷动相机）'
/* scrollCameraStart
defaultMap: {}
color: this.sceneColor
*/;

scrollCamera
    :   '画面卷动（需要先切换卷动相机）' BGNL 'x' x=NInt 'y' y=NInt '用时' duration=Number
/* scrollCamera
defaultMap: {x:0,y:0,duration:2}
color: this.sceneColor
*/;

scrollCameraEnd
    :   '画面卷动结束（切换回主角相机）'
/* scrollCameraEnd
defaultMap: {}
color: this.sceneColor
*/;

transferPlayer
    :   '场所移动' BGNL '地图id' mapkey=Int 'x' x=Int 'y' y=Int '方向' d=Direction_List
/* transferPlayer
defaultMap: {}
*/;

startEvent
    :   '立刻触发事件' BGNL '事件id' eventId=IdString
/* startEvent
defaultMap: {}
color: this.setColor
*/;

setEventPage
    :   '立刻切换事件页至' BGNL '事件id' eventId=IdString '事件页index' index=Int
/* setEventPage
defaultMap: {}
color: this.setColor
*/;

setEventDead
    :   '立刻结束事件' BGNL '事件id' eventId=IdString
/* setEventDead
defaultMap: {}
color: this.setColor
*/;

setEventDead_map
    :   '结束指定地图的指定事件' BGNL '地图id' mapkey=IdString '事件id' eventId=IdString
/* setEventDead_map
defaultMap: {}
color: this.setColor
*/;

setEventPosition
    :   '设置事件位置' BGNL eventId=IdString 'x' x=Int 'y' y=Int '方向' d=Direction_List
/* setEventPosition
defaultMap: {}
color: this.setColor
*/;

setEventDirection
    :   '设置事件朝向' BGNL eventId=IdString '方向' d=Direction_List
/* setEventDirection
defaultMap: {}
color: this.setColor
*/;

setPlayerPosition
    :   '直接设置角色位置（同地图）' BGNL 'x' x=Int 'y' y=Int '方向' d=Direction_List
/* setPlayerPosition
defaultMap: {}
color: this.setColor
*/;

setPlayerDirection
    :   '设置主角方向' '方向' d=Direction_List
/* setPlayerDirection
color: this.setColor
*/;

setEventFade
    :   '设置事件淡入淡出' '事件id' eventId=IdString BGNL '目标不透明度' target=Number '动画时长' fadeTime=Number
/* setEventFade
defaultMap: {target:1.0,fadeTime:1.5}
color: this.setColor
*/;

setPlayerFade
    :   '设置玩家淡入淡出' BGNL '目标不透明度' target=Number '动画时长' fadeTime=Number
/* setPlayerFade
defaultMap: {target:1.0,fadeTime:1.5}
color: this.setColor
*/;

setPlayerMove
    :   '设置主角移动路线(双击方块设置路线)' BGNL '移动路线' movingArr=RawEvalString_Multi '不等待' noAwait=Bool
/* setPlayerMove
defaultMap: {movingArr:'[2,4,6,8]',noAwait:false}
color: this.setColor
*/;

setCharacterMove
    :   '设置角色移动路线(双击方块设置路线)' BGNL '事件id' eventId=IdString '移动路线' movingArr=RawEvalString_Multi '不等待' noAwait=Bool
/* setCharacterMove
defaultMap: {movingArr:'[2,4,6,8]',noAwait:false}
color: this.setColor
*/;

setPlayerTexture
    :   '设置主角行走图' '行走图' player_texture=IdString
/* setPlayerTexture
color: this.setColor
*/;


setCharacterTexture
    :   '设置事件行走图' '事件id' eventId=IdString '行走图' character_texture=IdString
/* setCharacterTexture
color: this.setColor
*/;

setPlayerSpeed
    :   '设置主角速度' '速度' speed=Number
/* setPlayerSpeed
defaultMap: {speed:5.0}
color: this.setColor
*/;

setCharacterSpeed
    :   '设置角色速度' BGNL '事件id' eventId=IdString '速度' speed=Number
/* setCharacterSpeed
defaultMap: {speed:5.0}
color: this.setColor
*/;

restorePlayerSpeed
    :   '根据配置还原角色速度'
/* restorePlayerSpeed
defaultMap: {}
color: this.setColor
*/;

setPlayerJump
    :   '设置主角跳跃' BGNL 'x' x=NInt 'y' y=NInt '不等待' noAwait=Bool
/* setPlayerJump
defaultMap: {x:0,y:0,noAwait:false}
color: this.setColor
*/;

setCharacterJump
    :   '设置角色跳跃' '事件id' eventId=IdString BGNL 'x' x=NInt 'y' y=NInt '不等待' noAwait=Bool
/* setCharacterJump
defaultMap: {x:0,y:0,noAwait:false}
color: this.setColor
*/;

showAnim
    :   '显示动画于事件' BGNL '事件id' eventId=IdString '特效id' effectId=EffectId_List '动画跟随' onNode=Bool
/* showAnim
defaultMap: {}
color: this.animColor
*/;

showPlayerAnim
    :   '显示动画于角色' BGNL '特效id' effectId=EffectId_List
/* showPlayerAnim
defaultMap: {}
color: this.animColor
*/;

addFollower
    :   '添加跟随者' 'playerId' playerId=Int
/* addFollower
defaultMap: {}
*/;

delFollower
    :   '删除跟随者' 'playerId' playerId=Int
/* delFollower
defaultMap: {}
*/;

playSE
    :   '播放音效' v=EvalString
/* playSE
defaultMap: {}
*/;

getItem
    :   '获得道具' 'itemId' id=Int '数量' num=Int '显示UI提示' hint=Bool
/* getItem
defaultMap: {}
*/;

getEquip
    :   '获得装备' 'equipId' id=Int '数量' num=Int '显示UI提示' hint=Bool
/* getEquip
defaultMap: {}
*/;

refresh
    :   '立即刷新'
/* refresh
color: this.specialColor
*/;

callEnemyForm
    :   '呼叫敌人界面' 'eventId' id=IdString
/* callEnemyForm
color: this.specialColor
*/;

callSaveForm
    :   '呼叫存档界面'
/* callSaveForm
color: this.specialColor
*/;

returnMainMenu
    :   '返回标题画面'
/* returnMainMenu
color: this.specialColor
*/;

passAction
    :   'pass'
/* passAction
defaultMap: {}
*/;

statExprSplit : '=== statement ^ === expression v ===' ;
//===blockly表达式===

arithmetic : a=expr op=Arithmetic_List b=expr ;
notExpr : '非' v=expr ;
boolExpr : v=Bool ;
fixedExpr : id=FixedId_List ;
idRangeExpr : r=IdRange_List ':' id=IdString 
/* idRangeExpr
defaultMap: {id:'yellowKey'}
*/;
idStringExpr : '变量ID' id=EvalString ;
evalStringExpr : v=EvalString ;
scriptExpr : '脚本' v=EvalString ;

expr
    :   arithmetic
    |   notExpr
    |   boolExpr
    |   fixedExpr
    |   idRangeExpr
    |   idStringExpr
    |   scriptExpr
    |   evalStringExpr
    ;

expr_order_for_if
    :   arithmetic
    |   notExpr
    |   boolExpr
    |   fixedExpr
    |   idRangeExpr
    |   idStringExpr
    |   evalStringExpr
    |   scriptExpr
    ;

idExpr
    :   fixedExpr
    |   idRangeExpr
    |   idStringExpr
    ;

//===============lexer===============

EffectId_List
    :   'dynamic'|'101' /*EffectId_List function(){return window.EffectId_List_pair||[['加载失败','-1'],['加载失败','-2']]}*/
    ;

SpecialEvent_List
    :   'ItemUsingEvent'|'GameOverEvent'|'ShopEvent'|'LevelUpEvent'|'ChapterEndEvent'
    ;

CommonEventP_List
    :   'dynamic'|'e1/text1' /*CommonEventP_List function(){return window.CommonEventId_List_pair||[['加载失败','-1'],['加载失败','-2']]}*/
    ;

SetOP_List
    :   '='|'+='|'-='|'*='|'/='
    ;

FixedId_List
    :   'HP'|'MAXHP'|'MP'|'ATK'|'DEF'|'MDEF'|'SPD'
    ;

IdRange_List
    :   'attribute'|'gameVariables'
    ;

Arithmetic_List
    :   '+'|'-'|'*'|'/'|'^'|'=='|'!='|'>'|'<'|'>='|'<='|'&&'|'||'
    ;

TextPosition_List
    :   'Up'|'Center'|'Down'
    ;

Direction_List
    :   'Down'|'Left'|'Right'|'Up'
    ;

RawEvalString
    :   'sdeirughvuiyasdbe'+ //为了被识别为复杂词法规则
    ;

RawEvalString_Multi
    :   'sdeirughvuiyasdbe'+ //为了被识别为复杂词法规则
    ;

JsonEvalString
    :   'sdeirughvuiyasdbe'+ //为了被识别为复杂词法规则
    ;  

Colour
    :   'sdeirughvuiyasdeb'+ //为了被识别为复杂词法规则
    ;

Angle
    :   'sdeirughvuiyasdeb'+ //为了被识别为复杂词法规则
    ;

Bool:   'TRUE' 
    |   'FALSE'
    ;

Int :   '0' | [1-9][0-9]* ; // no leading zeros

NInt : '0' | '-'? [1-9][0-9]* ;

Number
    :   '-'? Int '.' Int EXP?   // 1.35, 1.35E-9, 0.3, -4.5
    |   '-'? Int EXP            // 1e10 -3e4
    |   '-'? Int                // -3, 45
    ;
fragment EXP : [Ee] [+\-]? Int ; // \- since - means "range" inside [...]

IdString
    :   [0-9a-zA-Z_][0-9a-zA-Z_:]*
    ;

EvalString
    :   Equote_double (ESC_double | ~["\\])* Equote_double
    ;

EvalString_Multi
    :   Equote_double (ESC_double | ~["\\])* Equote_double
    ;

fragment ESC_double :   '\\' (["\\/bfnrt] | UNICODE) ;
fragment UNICODE : 'u' HEX HEX HEX HEX ;
fragment HEX : [0-9a-fA-F] ;

BGNL
    :   'BGNLaergayergfuybgv'
    ;

MeaningfulSplit : '=== meaningful ^ ===' ;

fragment Equote_double : '"' ;

BSTART
    :   '开始'
    ;

BEND:   '结束'
    ;

Newline
    :   ('\r' '\n'?| '\n')// -> skip
    ;

WhiteSpace
    :   [ \t]+ -> skip
    ;

BlockComment
    :   '/*' .*? '*/' -> skip
    ;

LineComment
    :   '//' ~[\r\n]* -> skip
    ;

/* Call_BeforeType
this.evisitor.flowColor = 220;
this.evisitor.setColor = 190;
this.evisitor.sceneColor = 160;
this.evisitor.subColor = 80;
this.evisitor.animColor = 30;
this.evisitor.deadColor = 50;
this.evisitor.specialColor = 10;
*/


/* Call_BeforeBlock
// this.block('setValue').inputsInline=true;
delete(this.block('notExpr').inputsInline);
// this.block('idString_1_e').output='idString_e';
// this.block('idString_2_e').output='idString_e';
this.evisitor.expressionRules['idExpr'].check.forEach(blockname => {
    this.block(blockname).colour=10;
})
*/

/* Insert_BeforeCallIniter

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
;

*/
