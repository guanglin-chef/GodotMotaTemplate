
function g4tojs_main(Converter,grammarFile){
let option = {
    "type": "option",
    "defaultGenerating": "JSON",
    "blocklyRuntime": {
        "type": "blocklyRuntimeStatement",
        "path": "../antlr-blockly/",
        "files": "blockly_compressed.js, blocks_compressed.js, javascript_compressed.js, zh-hans.js"
    },
    "blocklyDiv": {
        "type": "fixedSizeBlocklyDiv",
        "id": "blocklyDiv",
        "height": "550px",
        "width": "450px"
    },
    "toolbox": {
        "type": "toolboxDefault",
        "id": "toolbox",
        "gap": 5
    },
    "codeArea": {
        "type": "codeAreaStatement",
        "output": "function(err,data){blocklyinput.value=err?String(err):data;window?.trigger?.call(null,[err,data])}"
    },
    "target": {
        "type": "independentFile"
        // "type": "keepGrammar"
    }
}
let converter = Converter.withOption(grammarFile, option)

function jsContent(params) {
    // ========== mark for split ==========
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
    // ========== mark for split ==========
    callAtEnd()
    window.buildBlocks&&window.buildBlocks()
    // ========== mark for split ==========
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
    // ========== mark for split ==========
    
    toolbox = getToolbox()
    // ========== mark for split ==========
}

let jsContents = jsContent.toString().split('// ========== mark for split ==========')
converter.js.checkUpdateFunction = jsContents[1]
converter.js.alldone = jsContents[2]
converter.js.BlocklyInject = jsContents[3]
converter.js.toolbox += jsContents[4]
converter.js._text.push('alldone')

return converter
}

if (typeof require !== 'undefined') {
    const fs = require('fs')
    const { Converter } = require('../antlr-blockly')
    let grammarFile = fs.readFileSync('./EventAction.g4', { encoding: 'utf-8' })
    let converter=g4tojs_main(Converter,grammarFile)
    // fs.writeFileSync('../build/blockly.html', converter.html.text(), { encoding: 'utf8' })
    fs.writeFileSync('../build/' + converter.js._name, '// 此文件现在仅供阅读和参考,更改不会生效,要更改事件编辑器请改动EventAction.g4\n\n\n'+converter.js.text(), { encoding: 'utf8' })
    // 生成出来仅供查看, 不再实际使用这个文件 addons/mota/webview/build/EventAction.js
}



////
/*
function rebuild() { // 弹窗粘贴json，还原到积木
    var s = prompt('请粘贴要用于重建积木的json代码:');
    try {
        s = s.replace(/[<>&]/g, c => ({ '<': '&lt;', '>': '&gt;', '&': '&amp;' }[c]));
        aicFunctions.parse({ "type": "prog", "statement_0": JSON.parse(s) });
    } catch (e) {
        alert('重建失败！请检查所粘贴json是否正确。');
    }
}
    editor_blockly.parse = function () {
        MotaActionFunctions.parse(
            eval('obj=' + codeAreaHL.getValue().replace(/[<>&]/g, function (c) {
                return {'<': '&lt;', '>': '&gt;', '&': '&amp;'}[c];
            }).replace(/\\(r|f|i|c|d|e)/g,'\\\\$1')),
            document.getElementById('entryType').value
        );
    }

*/