class_name EnemyInfoForm extends UIForm

# 所选怪物ID
var MonsterId:int
# 怪物ID数组
var MonsterIds:Array[int]
# 怪物手册数组
var m_Monsters:Array[EnemyData]
# 怪物手册界面
var EnemyHandBook:EnemyHandBookForm
# 怪物技能预制件
@export var EnemySkillPrefab:PackedScene
# 怪物详情框体
@export var EnemyInfoBoard:PanelContainer
# 怪物技能列表
@export var EnemySkillList:VBoxContainer
# 返回按钮
@export var ReturnBtn:Button
# 上一个按钮
@export var BeforeBtn:Button
# 下一个按钮
@export var NextBtn:Button
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
# 怪物详情标题
@export var EnemyInfoTitle:Label

## 需要用作额外本地化处理的对象（名称）
@export var localization_texts_1:Array[Node]
## 需要用作额外本地化处理的对象（等级）
@export var localization_texts_2:Array[Node]
## 需要用作额外本地化处理的对象（属性类）
@export var localization_texts_3:Array[Node]
## 需要用作额外本地化处理的对象（等级2）
@export var localization_texts_4:Array[Node]

#----------------------------------------------------------

# time
var time:float
# 初始帧
var firstindex:int

var dr

var book:EnemyData

#----------------------------------------------------------

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
	EnemyHeadIcon.position.x = EnemyHeadContainer.size.x / 2 - min(book.texture.get_width() / 8,64)
	EnemyHeadIcon.position.y = EnemyHeadContainer.size.y / 2 - min(book.texture.get_height() / 8,64)
	Utility.changeTextForLocalization(localization_texts_1,35)
	Utility.changeTextForLocalization(localization_texts_2,24)
	Utility.changeTextForLocalization(localization_texts_3,24)
	Utility.changeTextForLocalization(localization_texts_4,24)

func _process(delta):
	if book.idleAnim == true:
		time += delta
		var index = floori(time / 0.3)
		while index >= 4:
			index -= 4
			time -= (4 * 0.3)
		EnemyHeadIcon.frame = firstindex / 4 * 4 + index
	
#初始化
func initialize(param):
	EnemyInfoTitle.text = tr("怪物信息详情")
	MonsterId = param[0]
	MonsterIds = param[1]
	m_Monsters = param[2]
	EnemyHandBook = param[3]
	BeforeBtn.pressed.connect(onBtnBeforeClick)
	NextBtn.pressed.connect(onBtnNextClick)
	ReturnBtn.pressed.connect(onBtnReturnClick)
	getMonsterInfo(MonsterId)
	updatePagePanelPosition(EnemyInfoBoard)
	
func onBtnBeforeClick():
	#获取当前所选怪物id位于id组的索引，如果不为0则往前翻一个，为0则跳转至id组最后一位
	if(MonsterIds.find(MonsterId) == 0):
		MonsterId = MonsterIds[-1]
		getMonsterInfo(MonsterId)
	else:
		MonsterId = MonsterIds[MonsterIds.find(MonsterId) - 1]
		getMonsterInfo(MonsterId)
	
func onBtnNextClick():
	#获取当前所选怪物id位于id组的索引，如果不为最大则往后翻一个，为最大则跳转至id组首位
	if(MonsterIds.find(MonsterId) == (MonsterIds.size() - 1)):
		MonsterId = MonsterIds[0]
		getMonsterInfo(MonsterId)
	else:
		MonsterId = MonsterIds[MonsterIds.find(MonsterId) + 1]
		getMonsterInfo(MonsterId)
	
func onBtnReturnClick():
	close()
	if EnemyHandBook != null:
		EnemyHandBook.select_handdbook_btn.grab_focus()
	
func getMonsterInfo(id):
	dr = DatatableManager.Enemy.data[id]
	book = m_Monsters.filter(func(data): return data.monsterID == id)[0]
	#怪物图片
	EnemyHeadIcon.texture = book.texture
	EnemyHeadIcon.frame = book.Frame
	EnemyHeadIcon.modulate = book.modulate
	firstindex = book.Frame
	#怪物属性
	EnemyName.text = tr(dr.enemyName)
	#备注
	if dr.enemyRemark == '':
		EnemyRemark.visible = false
	else:
		EnemyRemark.visible = true
		EnemyRemark.text = tr(dr.enemyRemark)
	
	EnemyLv.text = "[color=" + DatatableManager.Level.data[DatatableManager.Enemy.data[MonsterId]["enemyDisplayedLevel"]].color + "]"+ tr(DatatableManager.Level.data[DatatableManager.Enemy.data[MonsterId]["enemyDisplayedLevel"]].name) + "[/color]"
	EnemyHp.text = Utility.fuck(dr.enemyMaxHp)
	EnemyAtk.text = Utility.fuck(dr.enemyAtk)
	EnemyDef.text = Utility.fuck(dr.enemyDef)
	EnemyExp.text = Utility.fuck(dr.enemyExp)
	EnemyGold.text = Utility.fuck(dr.enemyGold)
	# 根据返回的临界值数字类型判定临界点是直接引用还是fuck缩位
	if book.battleObj.get_critical_text().is_valid_int():
		EnemyCritical.text = Utility.fuck(int(book.battleObj.get_critical_text()))
	else:
		EnemyCritical.text = book.battleObj.get_critical_text()
	EnemyTurn.text = book.battleObj.get_turn_text()
	
	#先清空技能列表
	for i in EnemySkillList.get_children():
		EnemySkillList.remove_child(i)
		i.queue_free()
		#i.free()
	#获取怪物技能组并用对应预制件生成
	var skill = dr.enemySkill.duplicate()
	for i in skill.size():
		var enemyskill = EnemySkillPrefab.instantiate()
		enemyskill.name = str(DatatableManager.Skill.data[skill.keys()[i].to_int()]["skillName"])
		enemyskill.initMonsterSkill(skill.keys()[i].to_int(),skill[skill.keys()[i]].split("/"),book.fighter.value,0)
		EnemySkillList.add_child(enemyskill)
	#敌人伤害
	var damage_color:String = ""
	if book.battleObj.result == GameBattle.battlResult.dead:
		#灰色字体
		damage_color = "[color=#bfbfbfff]"
		EnemyDamage.text = damage_color + "???[/color]"
	elif book.battleObj.result == GameBattle.battlResult.invincible:
		#灰色字体
		damage_color = "[color=#bfbfbfff]"
		EnemyDamage.text = damage_color + tr("无敌") + "[/color]"
	elif book.battleObj.result != GameBattle.battlResult.win:
		#红字伤害
		damage_color = "[color=#ff8080ff]"
		EnemyDamage.text = damage_color + book.battleObj.get_text() + "[/color]"
	else:
		if book.battleObj.damage >= MotaSystem.gameData.hp:
			#灰色字体
			damage_color = "[color=#bfbfbfff]"
		elif book.battleObj.damage <= 0:
			#白色字体
			damage_color = "[color=#ffffffff]"
		elif book.battleObj.damage < MotaSystem.gameData.hp:
			#红字伤害
			damage_color = "[color=#ff8080ff]"
		EnemyDamage.text = damage_color + Utility.fuck(book.battleObj.damage) + "[/color]"
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
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu") or event.is_action_pressed("call_handbook"):
		close()
		if EnemyHandBook != null:
			EnemyHandBook.select_handdbook_btn.grab_focus()
			#阻止同时关闭怪物手册，阻断esc传播
			get_viewport().set_input_as_handled()
