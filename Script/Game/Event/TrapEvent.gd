class_name TrapEvent extends EventPage

# 陷阱类型
enum TrapType {
	HPTrap       = 1, #掉血陷阱
	PoisonTrap   = 2, #中毒陷阱
	WeakenedTrap = 3, #衰弱陷阱
	SlowTrap     = 4, #迟缓陷阱
	CurseTrap    = 5, #诅咒陷阱
}

## 陷阱类型，默认为1
@export var Type:TrapType = 1
## 扣血数值
@export var value:int
var damage:
	get:
		var dam = value
		#dam = floori(dam * MotaSystem.gameData.all_resistance)
		return dam
## 使用动画id
@export var TrapAnimId:int = 107

var trapValue:RichTextLabel
var trapvalue_path = "res://Scene/Prefab/ValueLabelPrefab/TrapValue.tscn"

#能力值获取显示值
func enter():
	refreshTrap()
	if MotaSystem.CurrentMap != null:
		MotaSystem.CurrentMap.cold_refresh.connect(refreshTrap.bind())
	super()

func _exit_tree():
	if MotaSystem.CurrentMap != null:
		if MotaSystem.CurrentMap.cold_refresh.is_connected(refreshTrap.bind()):
			MotaSystem.CurrentMap.cold_refresh.disconnect(refreshTrap.bind())

func start():
	if MotaSystem.Player.moveto < 2:
		# 主要逻辑
		# 动画
		playTrapDamageAnim()
		#根据陷阱类型决定伤害
		match Type:
			1:
				HPTrapStart()
			2:
				buffTrapStart(1)
			3:
				buffTrapStart(2)
			4:
				buffTrapStart(3)
			5:
				buffTrapStart(4)
	# 完成后处理
	super()

func refreshTrap():
	#检测是否存在label，没有则先创建一个
	if(self.get_node_or_null("TrapValue")==null):
		trapValue = MotaSystem.resourceManager.loadFile(trapvalue_path).instantiate()
		self.add_child(trapValue)
	else:
		trapValue=get_node("TrapValue")
	var color:String = ""
	if damage > 0:
		color = "[color=#ff0000ff]"#红色字体
	elif damage <= 0:
		color = "[color=#00ff00ff]"#绿色字体
	trapValue.text = color + Utility.fuck(int(damage)) + "[/color]"
	
	#是否显伤
	if MotaSystem.config.getValue("MapValueDisplay","mapvaluedisplay") == true:
		trapValue.visible = true
	else:
		trapValue.visible = false

func playTrapDamageAnim():
	var dr = DatatableManager.Effect.data[TrapAnimId]
	# 位置
	var pos = Utility.tilePos2WorldPos(base.tilePosition) + Vector2((texture.get_width() / vframes) / 2, (texture.get_height() / hframes) / 2)
	MotaSystem.effectManager.showEffectOnNode(dr["path"],MotaSystem.Player,Vector2(Defination.tilesize/2,Defination.tilesize/2),1)

#掉血陷阱函数	
func HPTrapStart():
	# 扣血
	# 玩家地图减伤抗性
	var final_damage = damage
	MotaSystem.gameData.hp -= final_damage
	MotaSystem.hintForm.showHint(tr("生命值-{0}").format([final_damage]))
	if !MotaSystem.gameData.hpcheck():
		return
	MotaSystem.CurrentMap.auto_pick = {}
#debuff陷阱函数	
func buffTrapStart(id):
	MotaSystem.gameData.addState(id, value)
