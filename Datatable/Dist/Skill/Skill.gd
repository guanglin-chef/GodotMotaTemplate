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
1:{ "id":1,  "skillName":'{0}次先攻',  "skillNote":'战斗时，该敌人首先攻击{0}次',  "skillType":1, },
2:{ "id":2,  "skillName":'{0}%魔攻',  "skillNote":'战斗时，该敌人攻击无视角色{0}%的防御',  "skillType":1, },
3:{ "id":3,  "skillName":'{0}连击',  "skillNote":'战斗时，该敌人每回合攻击{0}次',  "skillType":1, },
4:{ "id":4,  "skillName":'坚固',  "skillNote":'该敌人的防御会随着角色的攻击增加，且免疫特殊伤害',  "skillType":1, },
5:{ "id":5,  "skillName":'{0}%吸血',  "skillNote":'战斗时，该敌人每次攻击在击破护盾后造成的伤害{0}%会回复自身生命',  "skillType":1, },
6:{ "id":6,  "skillName":'{0}%虚化',  "skillNote":'战斗时，该敌人受到的伤害减少{0}%',  "skillType":1, },
7:{ "id":7,  "skillName":'{0}倍烈火',  "skillNote":'该敌人第一回合攻击时攻击力为{0}倍',  "skillType":1, },
8:{ "id":8,  "skillName":'{0}倍净化',  "skillNote":'战斗前，该敌人对角色造成角色护盾{0}倍的伤害',  "skillType":1, },
9:{ "id":9,  "skillName":'破甲',  "skillNote":'战斗前，对角色造成{0}点伤害',  "skillType":1, },
10:{ "id":10,  "skillName":'{0}%反弹',  "skillNote":'战斗时，每回合角色攻击时也会对自己也攻击一次，造成{0}%伤害',  "skillType":1, },
11:{ "id":11,  "skillName":'{0}层中毒',  "skillNote":'战斗后获得{0}层【中毒】状态，每层中毒增加10%战斗伤害（线性叠加）\n每{1}点护盾会减少一层实际获得的状态',  "skillType":1, },
12:{ "id":12,  "skillName":'{0}层衰弱',  "skillNote":'战斗后获得{0}层【衰弱】状态，每层衰弱减少角色5%攻防（非线性叠加）\n每{1}点护盾会减少一层实际获得的状态',  "skillType":1, },
13:{ "id":13,  "skillName":'{0}层迟缓',  "skillNote":'战斗后获得{0}层【迟缓】状态，每层迟缓使得战斗时敌人多攻击二回合\n每{1}点护盾会减少一层实际获得的状态',  "skillType":1, },
14:{ "id":14,  "skillName":'{0}层诅咒',  "skillNote":'战斗后获得{0}层【诅咒】状态，每层诅咒减少角色10%护盾（线性叠加）\n每{1}点护盾会减少一层实际获得的状态',  "skillType":1, },
15:{ "id":15,  "skillName":'{0}%协同',  "skillNote":'地图上除自身外每有一只同种该敌人便增加自身{0}%的生命（线性叠加）',  "skillType":1, },
16:{ "id":16,  "skillName":'{0}%仇恨',  "skillNote":'战斗后本地图其他拥有该属性的敌人伤害增加{0}%（非线性叠加）',  "skillType":1, },
17:{ "id":17,  "skillName":'{0}%军阵',  "skillNote":'该敌人攻防小于角色攻防时会额外增加二者差值{0}%的攻防',  "skillType":1, },
18:{ "id":18,  "skillName":'变身',  "skillNote":'该敌人死后原地变成{0}',  "skillType":1, },
19:{ "id":19,  "skillName":'无法侦测',  "skillNote":'？？？',  "skillType":1, },
20:{ "id":20,  "skillName":'{0}%鼓舞',  "skillNote":'使地图上自身种类以外且境界低于自身的所有敌人提升{0}%攻防',  "skillType":2, },
21:{ "id":21,  "skillName":'攻击光环',  "skillNote":'该敌人周围{0}格范围内其他敌人攻击上升{1}%',  "skillType":2, },
22:{ "id":22,  "skillName":'防御光环',  "skillNote":'该敌人周围{0}格范围内其他敌人防御上升{1}%',  "skillType":2, },
23:{ "id":23,  "skillName":'生命光环',  "skillNote":'该敌人周围{0}格范围内其他敌人生命上升{1}%',  "skillType":2, },
24:{ "id":24,  "skillName":'封印',  "skillNote":'经过两只有该属性的同种敌人中间会获得1层【封印】状态（上限10层），每层使得角色受到伤害翻倍。\n传送后移除【封印】状态。',  "skillType":3, },
25:{ "id":25,  "skillName":'阻击',  "skillNote":'角色经过该敌人十字领域时受到{0}点伤害，可被护盾减免\n同时该敌人会后退一格，该后退无法穿过其他敌人和道具',  "skillType":3, },
26:{ "id":26,  "skillName":'{0}格领域',  "skillNote":'角色经过该敌人{0}格范围内时受到{1}点伤害，可被护盾减免',  "skillType":3, },
27:{ "id":27,  "skillName":'域场',  "skillNote":'增加{0}%的本层实际地图伤害，多个可以线性叠加',  "skillType":2, },
28:{ "id":28,  "skillName":'追猎',  "skillNote":'角色经过该敌人四周可见直线上时，该敌人会向角色移动一格，若处于该敌人十字领域内则直接战斗\n该移动可以穿过其他敌人和道具',  "skillType":3, },
29:{ "id":29,  "skillName":'捕捉',  "skillNote":'角色经过该敌人十字领域时直接战斗',  "skillType":3, },
30:{ "id":30,  "skillName":'{0}%共鸣',  "skillNote":'该敌人攻击/防御增加地图上{0}%的攻击/防御',  "skillType":1, },
31:{ "id":31,  "skillName":'{0}%滋生',  "skillNote":'该敌人生命增加地图上{0}%的生命',  "skillType":1, },
32:{ "id":32,  "skillName":'{0}%夹击',  "skillNote":'经过两只有该属性的同种敌人中间会暂时扣除{0}%生命，传送后返还',  "skillType":3, },
33:{ "id":33,  "skillName":'射击',  "skillNote":'角色经过该敌人直线可视范围时受到{0}点伤害，可被护盾减免',  "skillType":3, },

}

