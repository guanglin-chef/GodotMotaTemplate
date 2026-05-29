class_name EnemyBoardPerfab extends Node

# 按钮
@export var EnemyBoardBtn:Button
# 怪物图片容器
@export var EnemyHeadContainer:MarginContainer
# 怪物图片
@export var EnemyHeadIcon:Sprite2D
# 怪物名
@export var EnemyName:RichTextLabel
# 怪物备注
@export var EnemyRemark:RichTextLabel
# 怪物技能
@export var EnemySkill:RichTextLabel
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
## 需要用作额外本地化处理的对象（技能组）
@export var localization_texts_2:Array[Node]
## 需要用作额外本地化处理的对象（等级）
@export var localization_texts_3:Array[Node]
## 需要用作额外本地化处理的对象（属性类）
@export var localization_texts_4:Array[Node]
## 需要用作额外本地化处理的对象（等级2）
@export var localization_texts_5:Array[Node]

#----------------------------------------------------------

# time
var time:float
# 初始帧
var firstindex:int
# 技能类型
var skill_type:int
# 怪物id
var enemy_id:int
# 怪物data
var enemy_data

#----------------------------------------------------------

func _ready() -> void:
	#当怪物图片过大时，调整图片大小至最大大小（512,512）内
	if EnemyHeadIcon.texture.get_width() > 512:
		var scale_per:float = 512.0 / EnemyHeadIcon.texture.get_width()
		EnemyHeadIcon.scale = Vector2(scale_per,scale_per)
	elif EnemyHeadIcon.texture.get_height() > 512:
		var scale_per:float = 512.0 / EnemyHeadIcon.texture.get_height()
		EnemyHeadIcon.scale = Vector2(scale_per,scale_per)
	EnemyHeadIcon.position.x = EnemyHeadContainer.size.x / 2 - min(enemy_data.texture.get_width() / 8,64)
	EnemyHeadIcon.position.y = EnemyHeadContainer.size.y / 2 - min(enemy_data.texture.get_height() / 8,64)
	Utility.changeTextForLocalization(localization_texts_1,25)
	Utility.changeTextForLocalization(localization_texts_2,22)
	Utility.changeTextForLocalization(localization_texts_3,24)
	Utility.changeTextForLocalization(localization_texts_4,24)
	Utility.changeTextForLocalization(localization_texts_5,24)
	
func _process(delta):
	if enemy_data.idleAnim == true:
		time += delta
		var index = floori(time / 0.3)
		while index >= 4:
			index -= 4
			time -= (4 * 0.3)
		EnemyHeadIcon.frame = firstindex / 4 * 4 + index
	
func initMonster(data:):
	enemy_data = data
	enemy_id = data.monsterID
	#怪物图片
	EnemyHeadIcon.texture = data.texture
	EnemyHeadIcon.frame = data.Frame
	EnemyHeadIcon.modulate = data.modulate
	firstindex = data.Frame
	var dr = DatatableManager.Enemy.data[enemy_id]
	if data.summon == true:
		EnemyName.text = tr(dr.enemyName) + tr("(召)")
	else:
		EnemyName.text = tr(dr.enemyName)
	#备注
	if dr.enemyRemark == '':
		EnemyRemark.visible = false
	else:
		EnemyRemark.visible = true
		EnemyRemark.text = tr(dr.enemyRemark)
	#怪物属性
	EnemyLv.text = "[color=" + DatatableManager.Level.data[DatatableManager.Enemy.data[enemy_id]["enemyDisplayedLevel"]].color + "]"+ tr(DatatableManager.Level.data[DatatableManager.Enemy.data[enemy_id]["enemyDisplayedLevel"]].name) + "[/color]"
	EnemyHp.text = Utility.fuck(dr.enemyMaxHp)
	EnemyAtk.text = Utility.fuck(dr.enemyAtk)
	EnemyDef.text = Utility.fuck(dr.enemyDef)
	EnemyExp.text = Utility.fuck(dr.enemyExp)
	EnemyGold.text = Utility.fuck(dr.enemyGold)
	# 根据返回的临界值数字类型判定临界点是直接引用还是fuck缩位
	if data.battleObj.get_critical_text().is_valid_int():
		EnemyCritical.text = Utility.fuck(int(data.battleObj.get_critical_text()))
	else:
		EnemyCritical.text = data.battleObj.get_critical_text()
	EnemyTurn.text = data.battleObj.get_turn_text()
	#敌人技能组
	EnemySkill.text = ""
	var skill = dr.enemySkill.duplicate()
	#超过2个则改为详情
	if(skill.keys().size() > 2):
		EnemySkill.text = "[color=#8080ff]" + tr("技能详情...") + "[/color]"
	elif(skill.keys().size() > 0 && skill.keys().size() <= 2):
		for i in skill.keys().size():
			skill_type = DatatableManager.Skill.data[skill.keys()[i].to_int()]["skillType"]
			match skill_type:
				0:
					EnemySkill.text += "[color=#ff8080]"
				1:
					EnemySkill.text += "[color=#80ffff]"
				2:
					EnemySkill.text += "[color=#ffff00]"
				3:
					EnemySkill.text += "[color=#ff80c0]"
				4:
					EnemySkill.text += "[color=#80ff80]"
			#技能名称
			var skill_name:String = ""
			#处理该技能是否是需要直接显示出来的数值
			#（例如X连击，X%吸血，X层DEBUFF等，通常在Skill表中的skillName中以{0}标识）
			var format_SkillValues:Array = skill[skill.keys()[i]].split("/")
			skill_name = tr(DatatableManager.Skill.data[skill.keys()[i].to_int()]["skillName"]).format(format_SkillValues,"{_}")
			if(i == skill.keys().size() - 1):
				EnemySkill.text += tr(skill_name) + "[/color]"
			else:
				EnemySkill.text += tr(skill_name) + "[/color]\n"
	elif(skill.keys().size()==0):
		EnemySkill.text="[color=#ffffff]" + tr("没有技能") + "[/color]"
	#敌人伤害
	var damage_color:String = ""
	if data.battleObj.result == GameBattle.battlResult.dead:
		#灰色字体
		damage_color = "[color=#bfbfbfff]"
		EnemyDamage.text = damage_color + "???[/color]"
	elif data.battleObj.result == GameBattle.battlResult.invincible:
		#灰色字体
		damage_color = "[color=#bfbfbfff]"
		EnemyDamage.text = damage_color + tr("无敌") + "[/color]"
	elif data.battleObj.result != GameBattle.battlResult.win:
		#红字伤害
		damage_color = "[color=#ff8080ff]"
		EnemyDamage.text = damage_color + data.battleObj.get_text() + "[/color]"
	else:
		if data.battleObj.damage >= MotaSystem.gameData.hp:
			#灰色字体
			damage_color = "[color=#bfbfbfff]"
		elif data.battleObj.damage <= 0:
			#白色字体
			damage_color = "[color=#ffffffff]"
		elif data.battleObj.damage < MotaSystem.gameData.hp:
			#红字伤害
			damage_color = "[color=#ff8080ff]"
		EnemyDamage.text = damage_color + Utility.fuck(data.battleObj.damage) + "[/color]"
	#无法侦测属性单独处理
	if skill.keys().has("19"):
		EnemyHp.text = "？？？"
		EnemyAtk.text = "？？？"
		EnemyDef.text = "？？？"
		EnemyExp.text = "？？？"
		EnemyGold.text = "？？？"
		EnemyCritical.text = "？？？"
		EnemyTurn.text = "？？？"
		EnemySkill.text = "？？？"
		EnemyDamage.text = "[color=#bfbfbfff]？？？[/color]"
