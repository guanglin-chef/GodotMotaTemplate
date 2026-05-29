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
1:{ "id":1,  "enemyName":'蝙蝠',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":160,  "enemyAtk":36,  "enemyDef":8,  "enemyExp":1,  "enemyGold":1,  "enemySkill":{'1': '2'},  "enemyRemark":'', },
2:{ "id":2,  "enemyName":'法师',  "enemyLevel":2,  "enemyDisplayedLevel":1001,  "enemyMaxHp":100,  "enemyAtk":30,  "enemyDef":15,  "enemyExp":1,  "enemyGold":2,  "enemySkill":{'2': '100'},  "enemyRemark":'', },
3:{ "id":3,  "enemyName":'剑士',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":120,  "enemyAtk":40,  "enemyDef":20,  "enemyExp":1,  "enemyGold":3,  "enemySkill":{'3': '2'},  "enemyRemark":'', },
4:{ "id":4,  "enemyName":'巨石',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":36,  "enemyAtk":45,  "enemyDef":0,  "enemyExp":1,  "enemyGold":4,  "enemySkill":{'4': '0'},  "enemyRemark":'', },
5:{ "id":5,  "enemyName":'吸血鬼',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":450,  "enemyAtk":80,  "enemyDef":16,  "enemyExp":1,  "enemyGold":5,  "enemySkill":{'5': '100'},  "enemyRemark":'', },
6:{ "id":6,  "enemyName":'幽灵',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":90,  "enemyAtk":55,  "enemyDef":10,  "enemyExp":1,  "enemyGold":6,  "enemySkill":{'6': '50'},  "enemyRemark":'', },
7:{ "id":7,  "enemyName":'灯烛',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":180,  "enemyAtk":50,  "enemyDef":12,  "enemyExp":1,  "enemyGold":7,  "enemySkill":{'7': '3'},  "enemyRemark":'', },
8:{ "id":8,  "enemyName":'牧师',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":270,  "enemyAtk":48,  "enemyDef":24,  "enemyExp":1,  "enemyGold":8,  "enemySkill":{'8': '4'},  "enemyRemark":'', },
9:{ "id":9,  "enemyName":'刺客',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":200,  "enemyAtk":75,  "enemyDef":5,  "enemyExp":1,  "enemyGold":9,  "enemySkill":{'9': '300'},  "enemyRemark":'', },
10:{ "id":10,  "enemyName":'甲胄',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":320,  "enemyAtk":35,  "enemyDef":25,  "enemyExp":1,  "enemyGold":10,  "enemySkill":{'10': '50'},  "enemyRemark":'[color=#ff7777]镇狱神体', },
11:{ "id":11,  "enemyName":'毒尸',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":400,  "enemyAtk":50,  "enemyDef":20,  "enemyExp":1,  "enemyGold":11,  "enemySkill":{'11': '4/30'},  "enemyRemark":'', },
12:{ "id":12,  "enemyName":'腐尸',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":360,  "enemyAtk":70,  "enemyDef":15,  "enemyExp":1,  "enemyGold":12,  "enemySkill":{'12': '4/30'},  "enemyRemark":'', },
13:{ "id":13,  "enemyName":'寒尸',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":240,  "enemyAtk":56,  "enemyDef":25,  "enemyExp":1,  "enemyGold":13,  "enemySkill":{'13': '4/30'},  "enemyRemark":'', },
14:{ "id":14,  "enemyName":'怨尸',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":280,  "enemyAtk":60,  "enemyDef":18,  "enemyExp":1,  "enemyGold":14,  "enemySkill":{'14': '4/30'},  "enemyRemark":'', },
15:{ "id":15,  "enemyName":'骷髅',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":150,  "enemyAtk":80,  "enemyDef":28,  "enemyExp":1,  "enemyGold":15,  "enemySkill":{'15': '20'},  "enemyRemark":'', },
16:{ "id":16,  "enemyName":'冤魂',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":210,  "enemyAtk":64,  "enemyDef":30,  "enemyExp":1,  "enemyGold":16,  "enemySkill":{'16': '25'},  "enemyRemark":'', },
17:{ "id":17,  "enemyName":'骑士',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":500,  "enemyAtk":100,  "enemyDef":40,  "enemyExp":1,  "enemyGold":17,  "enemySkill":{'17': '10', '14': '10/100', '15': '25', '16': '50', '10': '100'},  "enemyRemark":'', },
18:{ "id":18,  "enemyName":'欺诈师',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":400,  "enemyAtk":10,  "enemyDef":1,  "enemyExp":1,  "enemyGold":18,  "enemySkill":{'18': '9'},  "enemyRemark":'', },
19:{ "id":19,  "enemyName":'隐者',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":19,  "enemySkill":{'19': '0', '14': '10/100', '15': '25', '16': '50', '10': '100'},  "enemyRemark":'', },
20:{ "id":20,  "enemyName":'圣徒',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":20,  "enemySkill":{'20': '25'},  "enemyRemark":'', },
21:{ "id":21,  "enemyName":'利刃',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":21,  "enemySkill":{'21': '2/10'},  "enemyRemark":'', },
22:{ "id":22,  "enemyName":'坚盾',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":22,  "enemySkill":{'22': '2/5'},  "enemyRemark":'', },
23:{ "id":23,  "enemyName":'侍从',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":23,  "enemySkill":{'23': '2/20'},  "enemyRemark":'', },
24:{ "id":24,  "enemyName":'卫兵',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":24,  "enemySkill":{'24': ''},  "enemyRemark":'', },
25:{ "id":25,  "enemyName":'术士',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":1000,  "enemyAtk":100,  "enemyDef":0,  "enemyExp":1,  "enemyGold":25,  "enemySkill":{'25': '400'},  "enemyRemark":'', },
26:{ "id":26,  "enemyName":'领主',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":26,  "enemySkill":{'26': '1/200'},  "enemyRemark":'', },
27:{ "id":27,  "enemyName":'教皇',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":27,  "enemySkill":{'27': '2/500/15'},  "enemyRemark":'', },
28:{ "id":28,  "enemyName":'猎手',  "enemyLevel":1,  "enemyDisplayedLevel":1,  "enemyMaxHp":400,  "enemyAtk":1,  "enemyDef":10,  "enemyExp":1,  "enemyGold":28,  "enemySkill":{'28': '0'},  "enemyRemark":'', },
29:{ "id":29,  "enemyName":'军阵哥',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":400,  "enemyAtk":0,  "enemyDef":10,  "enemyExp":1,  "enemyGold":29,  "enemySkill":{'17': '50'},  "enemyRemark":'', },
30:{ "id":30,  "enemyName":'测试1',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":50,  "enemyAtk":105,  "enemyDef":0,  "enemyExp":1,  "enemyGold":30,  "enemySkill":{'11': '5/1000'},  "enemyRemark":'', },
31:{ "id":31,  "enemyName":'测试2',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":50,  "enemyAtk":105,  "enemyDef":0,  "enemyExp":1,  "enemyGold":31,  "enemySkill":{'12': '5/1000'},  "enemyRemark":'', },
32:{ "id":32,  "enemyName":'测试3',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":50,  "enemyAtk":105,  "enemyDef":0,  "enemyExp":1,  "enemyGold":32,  "enemySkill":{'14': '5/1000'},  "enemyRemark":'', },
33:{ "id":33,  "enemyName":'测试4',  "enemyLevel":2,  "enemyDisplayedLevel":2,  "enemyMaxHp":50,  "enemyAtk":105,  "enemyDef":0,  "enemyExp":1,  "enemyGold":33,  "enemySkill":{'33': '500'},  "enemyRemark":'', },
34:{ "id":34,  "enemyName":'测试5',  "enemyLevel":3,  "enemyDisplayedLevel":3,  "enemyMaxHp":400,  "enemyAtk":100,  "enemyDef":10,  "enemyExp":1,  "enemyGold":34,  "enemySkill":{'32': '99'},  "enemyRemark":'', },

}
