# warnings-disable
extends RefCounted

@warning_ignore("unused_variable")
var True = true
@warning_ignore("unused_variable")
var False = false
@warning_ignore("unused_variable")
var None = null


var data = \
{
1:{ "id":1,  "equipName":'使徒十字',  "equipNote":'[color=red]攻击+250%。[/color]',  "equipPrice":0,  "equipType":0,  "equipPositionType":0,  "equipLevel":0,  "equipIcon":'Equip1.png',  "equipArr":{'ATKPER': 2.5}, },
2:{ "id":2,  "equipName":'神镜盾',  "equipNote":'防御+200%。\n护盾+250%。',  "equipPrice":0,  "equipType":1,  "equipPositionType":0,  "equipLevel":0,  "equipIcon":'Equip2.png',  "equipArr":{'DEFPER': 2, 'MDEFPER': 2.5}, },
3:{ "id":3,  "equipName":'脚臭鞋',  "equipNote":'你受到的伤害降低40%。',  "equipPrice":0,  "equipType":2,  "equipPositionType":0,  "equipLevel":0,  "equipIcon":'Equip3.png',  "equipArr":{'ALLDAMRES': 40}, },
4:{ "id":4,  "equipName":'奇怪的武学',  "equipNote":'血瓶效果提高100%。\n你造成的伤害提高25%。',  "equipPrice":0,  "equipType":3,  "equipPositionType":0,  "equipLevel":0,  "equipIcon":'Equip4.png',  "equipArr":{'HPGETRAT': 1, 'ALLDAMRAT': 25}, },
5:{ "id":5,  "equipName":'《心灵网络》',  "equipNote":'攻击+100%。\n防御+100%。\n护盾+100%。\n金币获取率+200%。',  "equipPrice":0,  "equipType":4,  "equipPositionType":0,  "equipLevel":1,  "equipIcon":'Equip5.png',  "equipArr":{'ATKPER': 1, 'DEFPER': 1, 'MDEFPER': 1, 'GOLDGETRAT': 2}, },
6:{ "id":6,  "equipName":'《心灵网络∞》',  "equipNote":'攻击+1000%。\n防御+1000%。\n护盾+1000%。\n金币获取率+2000%。',  "equipPrice":0,  "equipType":4,  "equipPositionType":0,  "equipLevel":2,  "equipIcon":'Equip5.png',  "equipArr":{'ATKPER': 10, 'DEFPER': 10, 'MDEFPER': 10, 'GOLDGETRAT': 20}, },
7:{ "id":7,  "equipName":'平A',  "equipNote":'攻击+10%。\n防御+10%。\n护盾+10%。',  "equipPrice":0,  "equipType":4,  "equipPositionType":0,  "equipLevel":0,  "equipIcon":'Equip5.png',  "equipArr":{'ATKPER': 0.1, 'DEFPER': 0.1, 'MDEFPER': 0.1}, },
8:{ "id":8,  "equipName":'抠抠功',  "equipNote":'暂无效果。',  "equipPrice":0,  "equipType":3,  "equipPositionType":1,  "equipLevel":0,  "equipIcon":'Equip4.png',  "equipArr":{}, },
9:{ "id":9,  "equipName":'无光之盾',  "equipNote":'防御-50%。\n护盾+500%。',  "equipPrice":0,  "equipType":1,  "equipPositionType":1,  "equipLevel":0,  "equipIcon":'Equip2.png',  "equipArr":{'DEFPER': -0.5, 'MDEFPER': 5}, },

}

