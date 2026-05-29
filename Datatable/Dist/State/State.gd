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
1:{ "id":1,  "stateName":'中毒',  "stateNote":'每一层该状态会使你受到的战斗伤害提高10%，线性。',  "stateType":2,  "stateIcon":'state1.png',  "stateDisperse":1,  "stateMax":-1, },
2:{ "id":2,  "stateName":'衰弱',  "stateNote":'每一层该状态会使你攻击、防御降低5%，非线性。',  "stateType":2,  "stateIcon":'state2.png',  "stateDisperse":1,  "stateMax":-1, },
3:{ "id":3,  "stateName":'迟缓',  "stateNote":'每一层该状态会使你在战斗中被敌人先攻2回合。',  "stateType":2,  "stateIcon":'state3.png',  "stateDisperse":1,  "stateMax":-1, },
4:{ "id":4,  "stateName":'诅咒',  "stateNote":'每一层该状态会使你护盾降低10%，线性。',  "stateType":2,  "stateIcon":'state4.png',  "stateDisperse":1,  "stateMax":-1, },
5:{ "id":5,  "stateName":'夹击',  "stateNote":'传送后返回生命。',  "stateType":0,  "stateIcon":'state5.png',  "stateDisperse":0,  "stateMax":-1, },
6:{ "id":6,  "stateName":'封印',  "stateNote":'每一层使角色受到的伤害翻倍。（上限10层）\n传送后移除。',  "stateType":0,  "stateIcon":'state6.png',  "stateDisperse":0,  "stateMax":10, },

}

