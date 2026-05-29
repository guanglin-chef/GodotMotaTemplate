class_name ComsumableEvent extends EventPage

#能力拾取处理（血量，蓝量，攻击，防御，魔防，全能力，金币，自定义）
enum ConsumableType {HP,ATK,DEF,MDEF,ALL,GOLD,CUSTOM}

## 消耗品类型 
@export var type:ConsumableType
## 消耗品增加值
@export var value:int
var total_value:int:
	get:
		var v = value
		match type:
			ConsumableType.HP:
				if v > 0:
					v *= MotaSystem.gameData.hp_get_rate
			ConsumableType.GOLD:
				v *= MotaSystem.gameData.gold_get_rate
		return floor(v)
## 自定义宝物JSON（仅在自定义类型时生效）
@export var text = ""

# 消耗品数值显示
var comsumablevalue : RichTextLabel
var comsumablevalue_path = "res://Scene/Prefab/ValueLabelPrefab/ConsumbleValue.tscn"

#能力值获取显示值
func enter():
	refresh()
	if MotaSystem.CurrentMap != null:
		MotaSystem.CurrentMap.cold_refresh.connect(refresh.bind())
	super()
	 
func _exit_tree():
	if MotaSystem.CurrentMap != null:
		if MotaSystem.CurrentMap.cold_refresh.is_connected(refresh.bind()):
			MotaSystem.CurrentMap.cold_refresh.disconnect(refresh.bind())

var ice_sprite:Sprite2D

func start():
	# 主要逻辑
	if type == ConsumableType.HP:
		MotaSystem.gameData.hp += total_value
		MotaSystem.hintForm.showHint(tr("获得血瓶，生命+{0}").format([total_value]),cutTexture)
		AudioManager.playSE("Water bubble1.wav")
	if type == ConsumableType.ATK:
		MotaSystem.gameData.base_atk += total_value
		MotaSystem.hintForm.showHint(tr("获得红宝石，攻击+{0}").format([total_value]),cutTexture)
		AudioManager.playSE("Cansel1.wav")
	if type == ConsumableType.DEF:
		MotaSystem.gameData.base_def += total_value
		MotaSystem.hintForm.showHint(tr("获得蓝宝石，防御+{0}").format([total_value]),cutTexture)
		AudioManager.playSE("Cansel1.wav")
	if type == ConsumableType.MDEF:
		MotaSystem.gameData.base_mdef += total_value
		MotaSystem.hintForm.showHint(tr("获得绿宝石，护盾+{0}").format([total_value]),cutTexture)
		AudioManager.playSE("Cansel1.wav")
	if type == ConsumableType.ALL:
		MotaSystem.gameData.base_atk += total_value
		MotaSystem.gameData.base_def += total_value
		MotaSystem.gameData.base_mdef += total_value * 3
		MotaSystem.hintForm.showHint(tr("获得黄宝石，攻击防御+{0}，护盾+{1}").format([total_value,total_value * 3]),cutTexture)
		AudioManager.playSE("Cansel1.wav")
	if type == ConsumableType.GOLD:
		MotaSystem.gameData.gold += total_value
		MotaSystem.hintForm.showHint(tr("获得金币，金币+{0}").format([total_value]),cutTexture)
		AudioManager.playSE("Cursor1.wav")
	if type == ConsumableType.CUSTOM:
		var json = JSON.parse_string(text)
		await showTextP(json.text)
		if json.has("hp"):
			MotaSystem.gameData.hp += json.hp * MotaSystem.gameData.hp_get_rate
		if json.has("atk"):
			MotaSystem.gameData.base_atk += json.atk
		if json.has("def"):
			MotaSystem.gameData.base_def += json.def
		if json.has("mdef"):
			MotaSystem.gameData.base_mdef += json.mdef
		MotaSystem.hintForm.showHint(tr(json.text),cutTexture)
		AudioManager.playSE("Cansel1.wav")
	
	load_ability(-1)
	
	if !base.auto_pick:
		await wait(0.05)
	# 完成后处理
	super()
	
func refresh():
	#检测是否存在label，没有则先创建一个
	if( comsumablevalue == null):
		comsumablevalue = MotaSystem.resourceManager.loadFile(comsumablevalue_path).instantiate()
		self.add_child(comsumablevalue)
		load_ability()
	var comsumablevalue_color:String = ""
	if total_value >= 0:
		comsumablevalue_color = "[color=#80ffffff]"#青色字体
	else:
		comsumablevalue_color = "[color=#ff0000ff]"#红色字体
	comsumablevalue.text = comsumablevalue_color + Utility.fuck2(int(total_value)) + "[/color]"
	#是否显伤
	if MotaSystem.config.getValue("MapValueDisplay","mapvaluedisplay") == true:
		comsumablevalue.visible = true
	else:
		comsumablevalue.visible = false

func load_ability(multiple : int = 1):
	match type:
		ConsumableType.HP:
			MotaSystem.enemyReady.value["hp"] += value * multiple
		ConsumableType.ATK:
			MotaSystem.enemyReady.value["atk"] += value * multiple
		ConsumableType.DEF:
			MotaSystem.enemyReady.value["def"] += value * multiple
		ConsumableType.ALL:
			MotaSystem.enemyReady.value["atk"] += value * multiple
			MotaSystem.enemyReady.value["def"] += value * multiple
		ConsumableType.CUSTOM:
			var json = JSON.parse_string(text)
			if json.has("hp"):
				MotaSystem.enemyReady.value["hp"] += value * multiple
			if json.has("atk"):
				MotaSystem.enemyReady.value["atk"] += value * multiple
			if json.has("def"):
				MotaSystem.enemyReady.value["def"] += value * multiple
	if type != ConsumableType.HP:
		if base.get_parent().get_parent().data.has("alive_ruby"):
			base.get_parent().get_parent().data["alive_ruby"] += multiple
		else:
			base.get_parent().get_parent().data["alive_ruby"] = multiple
