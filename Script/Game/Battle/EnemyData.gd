##==============================================================================
## ■ EnemyData
##------------------------------------------------------------------------------
## 地图上战斗事件的数据集
##==============================================================================
class_name EnemyData

var monsterID : int
var battleObj : GameBattle
var cache     : Array
var texture   : Texture2D
var Frame     : int
var idleAnim  : bool
var number    : int = 1
var summon    : bool
var modulate  : Color
var fighter   : GameFighter :
	get:
		if battleObj != null:
			return battleObj.e_fighter
		return null

func _init(monsterID,texture,Frame,idleAnim,modulate):
	self.monsterID = monsterID
	self.texture   = texture
	self.Frame     = Frame
	self.idleAnim  = idleAnim
	self.modulate  = modulate
