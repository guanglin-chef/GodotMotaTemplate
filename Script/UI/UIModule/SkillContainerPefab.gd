class_name SkillContainerPerfab extends Node

#技能名称
@export var skillName:RichTextLabel
#技能类型
@export var skillType:RichTextLabel
#技能详细文本
@export var skillInfo:RichTextLabel

#技能id编号
var skill_id:int

#技能标准参数
var skill_value

#技能实际参数
var skill_practical_value:Dictionary

#技能展示type(0为怪物手册来源，1为右键实际详情来源)
var show_skill_type:int = 0

func initMonsterSkill(SkillId,SkillValues,SkillPracticalValue,SkillShowType):
	skillName.text = ""
	skillType.text = ""
	skillInfo.text = ""
	skill_id = SkillId
	skill_value = SkillValues
	skill_practical_value = SkillPracticalValue
	show_skill_type = SkillShowType
	#技能类型
	var skill_type:int = DatatableManager.Skill.data[skill_id]["skillType"]
	match skill_type:
		0:
			skillType.text += "[color=#ff8080]"
		1:
			skillType.text += "[color=#80ffff]"
		2:
			skillType.text += "[color=#ffff00]"
		3:
			skillType.text += "[color=#ff80c0]"
		4:
			skillType.text += "[color=#80ff80]"
	skillType.text += tr(Defination.Skill_Type[skill_type]) + "[/color]"
	
	#处理带有召唤类技能时，部分参数值转换为召唤对象名称
	#召唤物名称
	var temp_skill_value:Array[String]
	var summon_monster_name:String = ""
	for i in skill_value:
		summon_monster_name = tr(Utility.replaceSummonSkillEnemyName(skill_id,skill_value,i))
		#如果召唤物名称不为空，需要更换显示
		if summon_monster_name != "" and summon_monster_name != null:
			temp_skill_value.append(summon_monster_name)
		else:
			temp_skill_value.append(i)
	#为技能参数添加颜色标识
	var format_SkillValues:Array[String]
	var temp_format_skill_value:String
	for i in temp_skill_value:
		# 判断是否是数字
		if i.is_valid_float() == true:
			# 判断是否近似整数（避免浮点误差）
			var is_integer = snapped(float(i), 0.0001) == floor(float(i))
			var display_value = Utility.fuck(int(i)) if is_integer else Utility.fuck(float(i))
			temp_format_skill_value = "[color=#80ffff]" + display_value + "[/color]"
		else:
			temp_format_skill_value = "[color=#80ffff]" + i + "[/color]"
		format_SkillValues.append(temp_format_skill_value)
	#技能名称
	#处理该技能是否是需要直接显示出来的数值
	#（例如X连击，X%吸血，X层DEBUFF等，通常在Skill表中的skillName中以{0}标识）
	var skill_name:String = ""
	skill_name = tr(DatatableManager.Skill.data[skill_id]["skillName"]).format(format_SkillValues,"{_}")
	skillName.text = skill_name
	
	#技能描述
	var skill_info:String = ""
	skill_info = tr(DatatableManager.Skill.data[skill_id]["skillNote"]).format(format_SkillValues,"{_}")
	
	
	#技能实际数值
	var skill_practical_info:String = skill_info
	if show_skill_type == 1:
		var temp_practical_value:Array[String]
		var skill_actual_value:String = ""
		if skill_practical_value.keys().has(str(skill_id)):
			for i in skill_practical_value[str(skill_id)].values():
				# 判断是否近似整数（避免浮点误差）
				var is_integer = snapped(i, 0.0001) == floor(i)
				var display_value = Utility.fuck(int(i)) if is_integer else Utility.fuck(float(i))
				temp_practical_value.append("[color=#80ffff]" + display_value + "[/color]")
		match skill_id:
			8: # 净化
				skill_actual_value = tr("\n实际净化伤害：{damage}").format([["damage",temp_practical_value[0]]])
			10: # 反弹
				skill_actual_value = tr("\n实际反弹伤害：{damage}  总反弹伤害：{total_damage}").format([["damage",temp_practical_value[0]],["total_damage",temp_practical_value[1]]])
			11: # 中毒
				skill_actual_value = tr("\n实际层数：{total_buff}").format([["total_buff",temp_practical_value[0]]])
			12: # 衰弱
				skill_actual_value = tr("\n实际层数：{total_buff}").format([["total_buff",temp_practical_value[0]]])
			13: # 迟缓
				skill_actual_value = tr("\n实际层数：{total_buff}").format([["total_buff",temp_practical_value[0]]])
			14: # 诅咒
				skill_actual_value = tr("\n实际层数：{total_buff}").format([["total_buff",temp_practical_value[0]]])
			15: # 协同
				skill_actual_value = tr("\n实际生命比例：{hp_percent}%").format([["hp_percent",temp_practical_value[0]]])
			16: # 仇恨
				skill_actual_value = tr("\n实际伤害比例：{damage_percent}%").format([["damage_percent",temp_practical_value[0]]])
			17 , 30: # 军阵 共鸣
				skill_actual_value = tr("\n当前实际增加的攻防：{extra_atk}/{extra_def}").format([["extra_atk",temp_practical_value[0]],["extra_def",temp_practical_value[1]]])
			25: # 阻击
				skill_actual_value = tr("\n实际阻击伤害：{map_damage}").format([["map_damage",temp_practical_value[0]]])
			26: # 领域
				skill_actual_value = tr("\n实际领域伤害：{map_damage}").format([["map_damage",temp_practical_value[0]]])
			27: # 域场
				skill_actual_value = tr("\n实际地图增伤：{map_damage_buff}%").format([["map_damage_buff",temp_practical_value[0]]])
			31: # 孳生
				skill_actual_value = tr("\n当前实际增加的生命：{extra_hp}").format([["extra_hp",temp_practical_value[0]]])
			33: # 射击
				skill_actual_value = tr("\n实际射击伤害：{map_damage}").format([["map_damage",temp_practical_value[0]]])
		skill_practical_info += skill_actual_value
	skillInfo.text = tr(skill_practical_info)
	
