##==============================================================================
## ■ EnemyReady
##------------------------------------------------------------------------------
## 地图上战斗事件的处理器
##==============================================================================
class_name EnemyReady
##--------------------------------------------------------------------------
## ● 数据集合
##--------------------------------------------------------------------------
var max_mdef    : int
var EnemyList   : Array[EnemyData]    = []               ## 怪物手册内怪物种类列表
var Fighterlist : Array[GameFighter]  = []               ## 装备的排列组合
var equip_type  : Dictionary          = {}               ## 怪物类型临时变量
var value       : Dictionary          = { "area" : [] ,  ## 用于存储特殊种类单位的集
										  "mapskill" : [] ,
										  "hp"  : 0 ,
										  "atk" : 0 ,
										  "def" : 0 }
var EventList   : Array[MonsterEvent] = []               ## 事件集合
var Cache       : Dictionary          = {}               ## 战斗对象缓存
var MapArea     : Dictionary          = {}               ## 当前生效的全图光辉
var MapSkill    : Dictionary          = {}               ## 根据优先级排列的地图技能队列
var AreaName    : Dictionary          = {}               ## 全图光环的状态数据
##--------------------------------------------------------------------------
## ● 快捷方式
##--------------------------------------------------------------------------
var map       : GameMap
##--------------------------------------------------------------------------
## ● 初始化
##--------------------------------------------------------------------------
func _init(m:GameMap):
	map = m
	map.data["alive_ruby"] = 0
##--------------------------------------------------------------------------
## ● 刷新伤害
##--------------------------------------------------------------------------
func refresh():
	##----------------------------------------------------------------------
	## ● 重置当前所有的战斗对象以及缓存相关
	##----------------------------------------------------------------------
	Fighterlist = [GameFighter.new()]
	equip_type  = {}
	MapArea  = {}
	AreaName = {}
	Cache    = {}
	max_mdef = MotaSystem.gameData.mdef
	
	for e in EnemyList:
		e.battleObj = null
	##----------------------------------------------------------------------
	## ● 遍历所有装备的排列组合
	##----------------------------------------------------------------------
	if MotaSystem.config.getValue("Autoswitch","autoswitch"):
		
		for equip_key in MotaSystem.gameData.equip:
			if MotaSystem.gameData.equip[equip_key] != null:
				load_equip(int(MotaSystem.gameData.equip[equip_key]))
		for equip_id in MotaSystem.gameData.equip_pool:
			load_equip(int(equip_id))
			
		for type in equip_type.keys():
			var temp_array = []
			for value in equip_type[type].values():
				temp_array.append_array(value)
			equip_type[type] = temp_array
			
		if !equip_type.is_empty():
			var old_equip = MotaSystem.gameData.equip.duplicate()
			equip_recursion()
			MotaSystem.gameData.m_equip = old_equip
			MotaSystem.gameData.reset_snapshot()
	##----------------------------------------------------------------------
	## ● 重置当前所有缓存的光环与状态
	##----------------------------------------------------------------------
	if !MotaSystem.mapManager.preview:
		map.data["alive_enemy"] = int(EventList.size())
	AreaManager.Map_Area(get_arr_value("area"), MapArea, AreaName)
	##----------------------------------------------------------------------
	## ● 遍历刷新所有敌人单位
	##----------------------------------------------------------------------
	for e in EventList:
		e.get_damage()
##--------------------------------------------------------------------------
## ● 载入特殊技能单位队列
##--------------------------------------------------------------------------
func load_event(event : MonsterEvent , enemyid : int , join : bool = true):
	if EventList.has(event) != join:
		var data = DatatableManager.Enemy.data[enemyid]
		for skill in data.enemySkill:
			match DatatableManager.Skill.data[int(skill)].skillType:
				2:
					add_value("area" , event , join)
				3:
					add_value("mapskill" , event , join)
					add_value(skill , event , join)
		# 特殊技能单位
		if data.enemySkill.has("24") || data.enemySkill.has("32"):
			add_value("jiaji" , event , join)
		# 加入事件单位列表
		if join:
			EventList.append(event)
		else:
			EventList.erase(event)
##--------------------------------------------------------------------------
## ● 载入特殊种类单位队列
##--------------------------------------------------------------------------
func add_value(key : String , event : MonsterEvent , join : bool = true):
	if join:
		if !value.has(key):
			value[key] = []
		value[key].append(event)
	elif value.has(key):
		value[key].erase(event)
##--------------------------------------------------------------------------
## ● 获取某类特殊单位中的队列
##--------------------------------------------------------------------------
func get_arr_value(key : String):
	if value.has(key):
		return value[key]
	return []
##--------------------------------------------------------------------------
## ● 根据部位和类型加载装备 自动切装只参考类型内最高级的装备
##--------------------------------------------------------------------------
func load_equip(id : int):
	var type = DatatableManager.Equip.data[id].equipType
	if !equip_type.has(type):
		equip_type[type] = {}
	if !equip_type[type].has(DatatableManager.Equip.data[id].equipPositionType) || DatatableManager.Equip.data[equip_type[type][DatatableManager.Equip.data[id].equipPositionType][0]].equipLevel < DatatableManager.Equip.data[id].equipLevel:
		equip_type[type][DatatableManager.Equip.data[id].equipPositionType] = [id]
	elif DatatableManager.Equip.data[equip_type[type][DatatableManager.Equip.data[id].equipPositionType][0]].equipLevel == DatatableManager.Equip.data[id].equipLevel:
		# 同级装备并行计算
		equip_type[type][DatatableManager.Equip.data[id].equipPositionType].append(id)
##--------------------------------------------------------------------------
## ● 列出所有装备排序
##--------------------------------------------------------------------------
func equip_recursion(index : int = 0):
	for equip in range(0, equip_type.values()[index].size() + 1):
		if equip == equip_type.values()[index].size():
			MotaSystem.gameData.updateEquip(MotaSystem.gameData.equip_slot[equip_type.keys()[index]], null)
		else:
			MotaSystem.gameData.updateEquip(MotaSystem.gameData.equip_slot[equip_type.keys()[index]], equip_type.values()[index][equip])
		if index + 1 == equip_type.size():
			MotaSystem.gameData.reset_snapshot()
			var fighter = GameFighter.new()
			var temp_index = equip_check(fighter)
			if temp_index >= Fighterlist.size():
				Fighterlist.append(fighter)
			elif temp_index != -1:
				Fighterlist.set(temp_index, fighter)
			max_mdef = max(max_mdef, fighter.mdef)
		else:
			equip_recursion(index + 1)
##--------------------------------------------------------------------------
## ● 检测该装备序列是否有可取之处 防止开销过大
##--------------------------------------------------------------------------
func equip_check(fighter : GameFighter) -> int:
	return Fighterlist.size()
	#var index : int = 0
	#for old_fighter in Fighterlist:
	#	if old_fighter.atk >= fighter.atk && old_fighter.def >= fighter.def && old_fighter.mdef >= fighter.mdef:
	#		return -1
	#	elif fighter.atk > old_fighter.atk && fighter.def > old_fighter.def && fighter.mdef > old_fighter.mdef:
	#		return index
	#	index += 1
	#return index
##--------------------------------------------------------------------------
## ● 移动时触发的地图技能检测
##--------------------------------------------------------------------------
func step_trigger() -> int:
	##----------------------------------------------------------------------
	## ● 已受到伤害，对hp进行增减操作
	##----------------------------------------------------------------------
	if MotaSystem.Player.allPass:
		return 0
	if MotaSystem.gameVariables["debugMode"]:
		if Input.is_action_pressed("debug"):
			return 0
	##----------------------------------------------------------------------
	## ● 遍历所有敌人单位，计算行动受到的地图伤害
	##----------------------------------------------------------------------
	var dam : int = map_skill()
	##----------------------------------------------------------------------
	## ● 已受到伤害，对hp进行增减操作
	##----------------------------------------------------------------------
	if dam != 0:
		MotaSystem.gameData.hp = [ MotaSystem.gameData.hp - dam , 0 ].max()
		MotaSystem.effectManager.showEffectOnNode(DatatableManager.Effect.data[119]["path"], MotaSystem.CurrentMap, Utility.tilePos2WorldPos(MotaSystem.Player.tilePosition), 100, [dam])
		# 执行状态栏刷新
		if MotaSystem.gameForm != null:
			MotaSystem.gameForm.RefreshUI()
			MotaSystem.CurrentMap.auto_pick = {}
	##----------------------------------------------------------------------
	## ● 检测玩家是否死亡
	##----------------------------------------------------------------------
	if MotaSystem.gameData.hp <= 0:
		MotaSystem.gameEventManager.pushSpecialEvent(Defination.SpecialEventType.GameOverEvent)
	return dam
##--------------------------------------------------------------------------
## ● 地图技能的类型、优先级与顺序
##--------------------------------------------------------------------------
## 优先级：高         封印  夹击
const top_skill   = ["24","32"]
## 优先级：低         追猎  阻击  捕捉
const low_skill   = ["28","25","29"]
## 战斗类地图技能      追猎  捕捉
const fight_skill = ["28","29"]
##--------------------------------------------------------------------------
## ● 移动时触发的地图技能检测
##--------------------------------------------------------------------------
func map_skill( pos : Vector2i = MotaSystem.Player.tilePosition, param : Dictionary = {}, tag : Array = ["action"] , ban_list : Array = []) -> int:
	# [tag说明]
	# action  : 执行结算
	# get     : 任何技能成功执行都会立刻返回值
	# fight   : 只计算会立刻与角色战斗的地图技能
	##----------------------------------------------------------------------
	## ● 根据当前状态参数决定怪物的坐标与状态
	##----------------------------------------------------------------------
	for e in get_arr_value("mapskill"):
		if param.has(e.base.name) && param[e.base.name].has("pos"):
			# 如果当前状态中有该怪物的新坐标，则将新坐标加入临时坐标队列
			e.temp_pos.append(param[e.base.name]["pos"])
		else:
			# 没有新坐标也必须将当前坐标加入队列，因为涉及退出队列的问题
			e.temp_pos.append(e.base.tilePosition)
		# 将怪物当前状态的地址载入临时状态队列
		e.temp_state.append(param)
	##----------------------------------------------------------------------
	## ● 开始按照优先级和顺序执行怪物的地图技能
	##----------------------------------------------------------------------
	var damage : int = map_skill_queue( pos , param , tag , ban_list )
	##----------------------------------------------------------------------
	## ● 将所有怪物当前记录的临时坐标与临时状态移出队列
	##----------------------------------------------------------------------
	for e in get_arr_value("mapskill"):
		if !e.temp_pos.is_empty():
			if !param.has(e.base.name):
				param[e.base.name] = {}
			param[e.base.name]["pos"] = e.temp_pos.pop_back()
		if !e.temp_state.is_empty():
			e.temp_state.erase(e.temp_state.size() - 1)
	return damage
##--------------------------------------------------------------------------
## ● 根据类别、优先级与顺序执行地图技能
##--------------------------------------------------------------------------
func map_skill_queue( pos : Vector2i = MotaSystem.Player.tilePosition, param : Dictionary = {}, tag : Array = ["action"] , ban_list : Array = []) -> int:
	var damage : float = 0
	##----------------------------------------------------------------------
	## ● 战斗类地图技能，只从fight_skill里爬就行了
	##----------------------------------------------------------------------
	if tag.has("fight"):
		for id in fight_skill:
			for e in get_arr_value(id):
				if param.has(e.base.name) && param[e.base.name].has("dead"):
					continue
				if !ban_list.has(id):
					damage += e.map_skill_single(id , pos , tag)
					if param.has(e.base.name) && param[e.base.name].has("dead"):
						return 1
		return 0
	##----------------------------------------------------------------------
	## ● 执行高优先级的地图技能
	##----------------------------------------------------------------------
	for id in top_skill:
		for e in get_arr_value(id):
			if !ban_list.has(id):
				damage += e.map_skill_single(id , pos , tag)
				if tag.has("get") && (!param.is_empty() || damage > 0):
					return 1
	##----------------------------------------------------------------------
	## ● 执行无优先级的地图技能
	##----------------------------------------------------------------------
	for e in get_arr_value("mapskill"):
		damage += e.map_skill(pos , tag, ban_list)
		if tag.has("get") && (!param.is_empty() || damage > 0):
			return 1
	##----------------------------------------------------------------------
	## ● 执行低优先级的地图技能
	##----------------------------------------------------------------------
	for id in low_skill:
		for e in get_arr_value(id):
			if !ban_list.has(id):
				damage += e.map_skill_single(id , pos , tag)
				if tag.has("get") && (!param.is_empty() || damage > 0):
					return 1
	return damage
