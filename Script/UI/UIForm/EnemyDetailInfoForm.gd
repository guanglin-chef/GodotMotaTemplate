class_name EnemyDetailInfoForm extends UIForm

# 怪物技能预制件
@export var EnemySkillPrefab:PackedScene
# 怪物详情框体
@export var EnemyInfoBoard:PanelContainer
# 怪物技能列表
@export var EnemySkillList:VBoxContainer
# 返回按钮
@export var ReturnBtn:Button
# 怪物图片
@export var EnemyHeadIcon:Sprite2D
# 怪物图片容器
@export var EnemyHeadContainer:MarginContainer
# 怪物名
@export var EnemyName:RichTextLabel
# 怪物备注
@export var EnemyRemark:RichTextLabel
# 怪物hp
@export var EnemyHp:Label
# 怪物atk
@export var EnemyAtk:Label
# 怪物def
@export var EnemyDef:Label
# 怪物等级
@export var EnemyLv:RichTextLabel
# 怪物gold
@export var EnemyGold:Label
# 怪物exp
@export var EnemyExp:Label
# 怪物临界
@export var EnemyCritical:Label
# 怪物回合
@export var EnemyTurn:Label
# 伤害值
@export var EnemyDamage:RichTextLabel

## 需要用作额外本地化处理的对象（名称）
@export var localization_texts_1:Array[Node]
## 需要用作额外本地化处理的对象（等级）
@export var localization_texts_2:Array[Node]
## 需要用作额外本地化处理的对象（属性类）
@export var localization_texts_3:Array[Node]
## 需要用作额外本地化处理的对象（等级2）
@export var localization_texts_4:Array[Node]

#----------------------------------------------------------

# 所选怪物ID
var MonsterId:int
# time
var time:float
# 初始帧
var firstindex:int
# 怪物图像
var enemy_texture
# 怪物战斗参数
var enemy_fighter
# 怪物事件
var enemy_event
# 怪物右键详情界面
var EnemyStateMap:EnemyStateFormMap

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	
	self.openAnim(0.2)
	
func onReadyFinished():
	ReturnBtn.grab_focus()
	#当怪物图片过大时，调整图片大小至最大大小（512,512）内
	if EnemyHeadIcon.texture.get_width() > 512:
		var scale_per:float = 512.0 / EnemyHeadIcon.texture.get_width()
		EnemyHeadIcon.scale = Vector2(scale_per,scale_per)
	elif EnemyHeadIcon.texture.get_height() > 512:
		var scale_per:float = 512.0 / EnemyHeadIcon.texture.get_height()
		EnemyHeadIcon.scale = Vector2(scale_per,scale_per)
	EnemyHeadIcon.position.x = EnemyHeadContainer.size.x / 2 - min(enemy_texture.get_width() / 8,64)
	EnemyHeadIcon.position.y = EnemyHeadContainer.size.y / 2 - min(enemy_texture.get_height() / 8,64)
	Utility.changeTextForLocalization(localization_texts_1,35)
	Utility.changeTextForLocalization(localization_texts_2,24)
	Utility.changeTextForLocalization(localization_texts_3,24)
	Utility.changeTextForLocalization(localization_texts_4,24)


func _process(delta):
	if enemy_event.current_page.idleAnim == true:
		time += delta
		var index = floori(time / 0.3)
		while index >= 4:
			index -= 4
			time -= (4 * 0.3)
		EnemyHeadIcon.frame = firstindex / 4 * 4 + index
	
#初始化
func initialize(param):
	enemy_event = param[0]
	enemy_fighter = param[1]
	enemy_texture = param[2]
	firstindex = param[3]
	EnemyStateMap = param[4]
	MonsterId = enemy_fighter.enemy_id
	ReturnBtn.pressed.connect(onBtnReturnClick)
	getMonsterInfo(MonsterId)
	updatePagePanelPosition(EnemyInfoBoard)
	
func getMonsterInfo(id):
	#怪物数据库基础数据
	var enemy_base_data = DatatableManager.Enemy.data[id]
	#怪物图片
	EnemyHeadIcon.texture = enemy_texture
	#怪物属性
	EnemyName.text = tr(enemy_fighter.name)
	#备注
	if DatatableManager.Enemy.data[MonsterId]["enemyRemark"] == '':
		EnemyRemark.visible = false
	else:
		EnemyRemark.visible = true
		EnemyRemark.text = tr(DatatableManager.Enemy.data[MonsterId]["enemyRemark"])
	EnemyLv.text = "[color=" + DatatableManager.Level.data[DatatableManager.Enemy.data[MonsterId]["enemyDisplayedLevel"]].color + "]"+ tr(DatatableManager.Level.data[DatatableManager.Enemy.data[MonsterId]["enemyDisplayedLevel"]].name) + "[/color]"
	EnemyHp.text = Utility.fuck(enemy_fighter.maxhp)
	EnemyAtk.text = Utility.fuck(enemy_fighter.atk)
	EnemyDef.text = Utility.fuck(enemy_fighter.def)
	EnemyExp.text = Utility.fuck(enemy_fighter.exp)
	EnemyGold.text = Utility.fuck(enemy_fighter.gold)
	# 根据返回的临界值数字类型判定临界点是直接引用还是fuck缩位
	if enemy_event.current_page.battle.get_critical_text().is_valid_int():
		EnemyCritical.text = Utility.fuck(int(enemy_event.current_page.battle.get_critical_text()))
	else:
		EnemyCritical.text = enemy_event.current_page.battle.get_critical_text()
	EnemyTurn.text = enemy_event.current_page.battle.get_turn_text()
	
	#先清空技能列表
	for i in EnemySkillList.get_children():
		EnemySkillList.remove_child(i)
		i.queue_free()
		#i.free()
	#获取怪物技能组并用对应预制件生成
	var skill = enemy_base_data.enemySkill.duplicate()
	for i in skill.size():
		var enemyskill = EnemySkillPrefab.instantiate()
		enemyskill.name = str(DatatableManager.Skill.data[skill.keys()[i].to_int()]["skillName"])
		enemyskill.initMonsterSkill(skill.keys()[i].to_int(),skill[skill.keys()[i]].split("/"),enemy_fighter.value,1)
		EnemySkillList.add_child(enemyskill)
		
	#敌人伤害
	var damage_color:String = ""
	if enemy_event.current_page.battle.result == GameBattle.battlResult.dead:
		#灰色字体
		damage_color = "[color=#bfbfbfff]"
		EnemyDamage.text = damage_color + "???[/color]"
	elif enemy_event.current_page.battle.result == GameBattle.battlResult.invincible:
		#灰色字体
		damage_color = "[color=#bfbfbfff]"
		EnemyDamage.text = damage_color + tr("无敌") + "[/color]"
	elif enemy_event.current_page.battle.result != GameBattle.battlResult.win:
		#红字伤害
		damage_color = "[color=#ff8080ff]"
		EnemyDamage.text = damage_color + enemy_event.current_page.battle.get_text() + "[/color]"
	else:
		if enemy_event.current_page.battle.damage >= MotaSystem.gameData.hp:
			#灰色字体
			damage_color = "[color=#bfbfbfff]"
		elif enemy_event.current_page.battle.damage <= 0:
			#白色字体
			damage_color = "[color=#ffffffff]"
		elif enemy_event.current_page.battle.damage < MotaSystem.gameData.hp:
			#红字伤害
			damage_color = "[color=#ff8080ff]"
		EnemyDamage.text = damage_color + Utility.fuck(enemy_event.current_page.battle.damage) + "[/color]"
	#无法侦测技能处理
	if skill.keys().has("19"):
		EnemyHp.text = "？？？"
		EnemyAtk.text = "？？？"
		EnemyDef.text = "？？？"
		EnemyExp.text = "？？？"
		EnemyGold.text = "？？？"
		EnemyCritical.text = "？？？"
		EnemyTurn.text = "？？？"
		EnemyDamage.text = "[color=#bfbfbfff]？？？[/color]"
	
func onBtnReturnClick():
	close()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu") or event.is_action_pressed("call_handbook"):
		close()
		if EnemyStateMap != null:
			#阻止同时关闭怪物右键详情，阻断esc传播
			get_viewport().set_input_as_handled()
