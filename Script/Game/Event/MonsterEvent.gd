##==============================================================================
## ■ MonsterEvent
##------------------------------------------------------------------------------
## 事件中的战斗单位
##==============================================================================
class_name MonsterEvent extends EventPage
##--------------------------------------------------------------------------
## ● 事件页公开参数
##--------------------------------------------------------------------------
## 与此敌人战斗时是否禁止自动存档
@export var no_auto_save : bool = false
## 敌人ID
@export var enemyID : int
## 激活
@export var active : bool = true
##--------------------------------------------------------------------------
## ● 战斗单位ID与事件状态
##--------------------------------------------------------------------------
var buff            : Dictionary
var enemyid         : int :
	get:
		# 留一个转换怪物id的口子
		if debuff.has("eid"):
			return debuff["eid"]
		return enemyID
var temp_state   : Array = []
var event_state  : Dictionary :
	get:
		if temp_state.is_empty():
			return {}
		return temp_state.back()
## 计算用临时坐标
var temp_pos   : Array = []
var event_pos  : Vector2i :
	get:
		if temp_pos.is_empty():
			return base.tilePosition
		return temp_pos.back()
##--------------------------------------------------------------------------
## ● 快捷方式
##--------------------------------------------------------------------------
var map         : GameMap
var area_name   : Dictionary
var battle      : GameBattle
var mapskillObj : GameBattle
var equip_id    : int
var mdef_id     : int
var enemy_data  : EnemyData
var enemy_ready : EnemyReady
var skill       : Dictionary
var fighter     : GameFighter :
	get:
		if battle != null:
			return battle.e_fighter
		return null
##--------------------------------------------------------------------------
## ● 载入初始化
##--------------------------------------------------------------------------
func enter():
	map         = MotaSystem.CurrentMap
	enemy_ready = MotaSystem.enemyReady
	init_monster()
	super()
##--------------------------------------------------------------------------
## ● 离开该事件页
##--------------------------------------------------------------------------
func exit():
	if MotaSystem.CurrentMap != null:
		del_monster()
	super()
##--------------------------------------------------------------------------
## ● 初始化怪物地图对象，写入对应类别
##--------------------------------------------------------------------------
func init_monster():
	if enemy_ready != null && enemy_ready.EventList.has(self):
		return
	var list = enemy_ready.EnemyList.filter(func(data): return data.monsterID == enemyid)
	# 从怪物列表中寻找同类怪物
	if list.size() == 0:
		enemy_ready.EnemyList.append(EnemyData.new(enemyid,texture,frame,idleAnim,modulate))
		enemy_data = enemy_ready.EnemyList[enemy_ready.EnemyList.size() - 1]
	else:
		list[0].number += 1
		enemy_data = list[0]
	# 该单位加入事件列表
	enemy_ready.load_event(self, enemyid)
	skill = DatatableManager.Enemy.data[enemyid].enemySkill.duplicate()
	for s in skill:
		match DatatableManager.Skill.data[int(s)]["skillType"]:
			2:
				refresh_halo()
##--------------------------------------------------------------------------
## ● 释放怪物
##--------------------------------------------------------------------------
func del_monster():
	if enemy_ready != null:
		# 是否已注销过该单位
		if !enemy_ready.EventList.has(self):
			return  # 已注销就跳过
		# 从事件列表中注销该单位
		enemy_ready.load_event(self, enemyid, false)
		enemy_data.number -= 1
		# 当前层同类怪物全灭
		# 从怪物列表中注销该怪物
		if enemy_data.number == 0:
			enemy_ready.EnemyList.erase(enemy_data)
##--------------------------------------------------------------------------
## ● 刷新战斗对象
##--------------------------------------------------------------------------
func get_damage():
	var temp
	##----------------------------------------------------------------------
	## ● 重新加载战斗对象与当前单位被赋予的状态
	##----------------------------------------------------------------------
	# 需要刷新的时候才可以实例化战斗对象
	if enemy_data.battleObj == null:
		temp = GameBattle.traverse_damage(enemyid)
		enemy_data.battleObj = temp[0]
		enemy_data.cache = temp
		enemy_data.fighter = enemy_data.battleObj.e_fighter
	# 加载怪物身上的状态
	get_battle_buff()
	##----------------------------------------------------------------------
	## ● 根据当前单位被赋予的状态计算并显示伤害
	##----------------------------------------------------------------------
	if buff.is_empty():
		battle = enemy_data.battleObj
		mapskillObj = enemy_data.cache[1]
		equip_id = enemy_data.cache[2]
		mdef_id = enemy_data.cache[3]
	else:
		var key = [enemyid, buff]
		# 缓存为空时实例化一次战斗对象并赋值为缓存
		if !enemy_ready.Cache.has(key):
			enemy_ready.Cache[key] = GameBattle.traverse_damage(enemyid, buff)
		# 而后直接调用已有缓存
		battle = enemy_ready.Cache[key][0]
		mapskillObj = enemy_ready.Cache[key][1]
		equip_id = enemy_ready.Cache[key][2]
		mdef_id = enemy_ready.Cache[key][3]
	# 刷新显伤
	refresh_label()
	if enemy_ready.value.has("jiaji") && enemy_ready.value["jiaji"].has(self):
		refresh_jiaji()
##--------------------------------------------------------------------------
## ● 刷新战斗对象状态
##--------------------------------------------------------------------------
func get_battle_buff() -> Dictionary:
	##----------------------------------------------------------------------
	## ● 执行全图光环的调用流程与局域光环的判断流程
	##----------------------------------------------------------------------
	buff      = enemy_ready.MapArea.duplicate()
	area_name = enemy_ready.AreaName.duplicate()
	skill     = enemy_data.battleObj.e_fighter.skill
	
	AreaManager.Event_Area(enemy_ready.get_arr_value("area"), buff, self, area_name)
	##----------------------------------------------------------------------
	## :[协同]: 地图上除自身外每有一只同种该敌人便增加自身{0}%的生命（线性叠加）
	##----------------------------------------------------------------------
	if skill.has("15"):
		AreaManager.AddBuff(buff, "hp%", float(skill["15"]) * (enemy_data.number - 1), area_name, tr("协同"), enemy_data.number - 1)
	##----------------------------------------------------------------------
	## :[仇恨]: 地图上除自身外每有一只同种该敌人便增加自身{0}%的生命（线性叠加）
	##----------------------------------------------------------------------
	if skill.has("16") && enemy_ready.map.data.has("revenge"):
		AreaManager.AddBuff(buff, "damage", enemy_ready.map.data["revenge"] - 100, area_name, tr("仇恨"), int(enemy_ready.map.data["revenge"] - 100))
	##----------------------------------------------------------------------
	## :[共鸣]: 该敌人攻击/防御增加地图上{0}%的攻击/防御
	##----------------------------------------------------------------------
	if skill.has("30"):
		AreaManager.AddBuff(buff, "atk", int(enemy_ready.value["atk"] * float(skill["30"]) / 100), area_name, tr("攻击共鸣"), int(enemy_ready.value["atk"] * float(skill["30"]) / 100))
		AreaManager.AddBuff(buff, "def", int(enemy_ready.value["def"] * float(skill["30"]) / 100), area_name, tr("防御共鸣"), int(enemy_ready.value["def"] * float(skill["30"]) / 100))
	##----------------------------------------------------------------------
	## :[孳生]: 该敌人生命增加地图上{0}%的生命
	##----------------------------------------------------------------------
	if skill.has("31"):
		AreaManager.AddBuff(buff, "hp", int(enemy_ready.value["hp"] * float(skill["31"]) / 100), area_name, tr("滋生"), int(enemy_ready.value["hp"] * float(skill["31"]) / 100))
	return buff
##--------------------------------------------------------------------------
## ● 爷们要战斗
##--------------------------------------------------------------------------
func start():
	if !active:
		return
	##----------------------------------------------------------------------
	## ● 如果在自动清怪的过程中怪物伤害变动 就刹车
	##----------------------------------------------------------------------
	if base.auto_pick:
		MotaSystem.gameForm.RefreshUI() #刷新UI
		base.auto_pick = false
		if battle.damage > 0:
			return
	##----------------------------------------------------------------------
	## ● 是否封锁该战斗的自动存档
	##----------------------------------------------------------------------
	if !no_auto_save && !MotaSystem.CurrentMap.auto_pick_eat.has(base):
		MotaSystem.saveManager.AutoSave()
	##----------------------------------------------------------------------
	## ● 播放动画与等待事件
	##----------------------------------------------------------------------
	playBattleAnim()
	await wait(0.2)
	##----------------------------------------------------------------------
	## ● 结算该场战斗对玩家造成的伤害
	##----------------------------------------------------------------------
	MotaSystem.gameData.hp = snappedi([MotaSystem.gameData.hp - battle.damage,0].max(),1)
	if battle.result != battle.battlResult.win:
		# 不可战胜时血量归零
		MotaSystem.gameData.hp = 0
	##----------------------------------------------------------------------
	## ● 检测玩家是否死亡
	##----------------------------------------------------------------------
	if MotaSystem.gameData.hp <= 0:
		MotaSystem.gameEventManager.pushSpecialEvent(Defination.SpecialEventType.GameOverEvent)
		return
	##----------------------------------------------------------------------
	## ● 战斗胜利后的后续处理
	##----------------------------------------------------------------------
	buff_check()    # 玩家状态结算
	var undead = monster_dead()  # 怪物死亡结算
	if !enemy_ready.Fighterlist.is_empty():
		MotaSystem.gameData.setEquip(battle.p_fighter.equip)
	MotaSystem.CurrentMap.auto_pick_eat.erase(base)
	base.auto_pick = false
	if undead == false:
		super()  # undead为false即怪物死亡，执行父类start的后续项
	else:
		# 不死怪 执行一下父类start中必须的执行项
		if base.auto_pick:
			# 清除该事件身上的的自动拾取标记
			MotaSystem.CurrentMap.auto_pick_eat.erase(base)
			base.auto_pick = false
		# 刷新UI
		MotaSystem.gameForm.RefreshUI()
		# 事件页没有切换 只是更改怪物ID 那么就需要清理缓存
		map.clear_range_cache()
		# 避免变身怪变身为领域怪后没有显示警报
		map.show_damage_point()
##--------------------------------------------------------------------------
## ● 怪物是否死亡
##--------------------------------------------------------------------------
func is_dead() -> bool:
	return base.current_page != self
##--------------------------------------------------------------------------
## ● 怪物死亡结算
##--------------------------------------------------------------------------
func monster_dead():
	var undead = false
	##----------------------------------------------------------------------
	## ● 金钱与经验
	##----------------------------------------------------------------------
	MotaSystem.gameData.expe += fighter.exp  * MotaSystem.gameData.exp_get_rate
	MotaSystem.gameData.gold += fighter.gold * MotaSystem.gameData.gold_get_rate
	# 升级
	MotaSystem.gameEventManager.pushSpecialEvent(Defination.SpecialEventType.LevelUpEvent)
	##----------------------------------------------------------------------
	## :[仇恨]: 战斗后本地图其他拥有该属性的敌人伤害增加{0}%（非线性叠加）
	##----------------------------------------------------------------------
	if skill.has("16"):
		if !enemy_ready.map.data.has("revenge"):
			enemy_ready.map.data["revenge"] = 100
		enemy_ready.map.data["revenge"] *= 1.0 + (float(skill["16"]) / 100)
	##----------------------------------------------------------------------
	## ● 结束事件
	##----------------------------------------------------------------------
	if skill.has("18"):
		# 根据下一页是否为怪物页来决定变身后的行走图
		if base.next_page != null && base.next_page is MonsterEvent:
			base.next_page.debuff["eid"] = float(skill["18"])
			base.current_page = base.next_page
		else:
			# 没有下一页或下一页不为怪物页
			del_monster()
			# 赋予怪物页新的怪物ID
			debuff["eid"] = float(skill["18"])
			# 重新初始化
			init_monster()
			# 不要去世
			undead = true
	else:
		if onPageFinished == 0: #Hold
			pass
		if onPageFinished == 1: #Next
			base.current_page = base.next_page
		if onPageFinished == 2: #Dead
			base.dead()
		if onPageFinished == 3: # Customize
			if customizeNextPage < base.pages.size():
				base.current_page = base.pages[customizeNextPage]
			else:
				printerr("CustomizeNextPage outrange!")
	# 清除GameViewport类窗口
	MotaSystem.uiManager.clearForLayer("GameViewport")
	# 清除GameFormLayerTop类窗口
	MotaSystem.uiManager.clearForLayer("GameFormLayerTop")
	if MotaSystem.hintForm != null:
		MotaSystem.hintForm.showHint(tr("战胜{0}，获得{1}金币，{2}经验！").format([tr(DatatableManager.Enemy.data[enemyid].enemyName),DatatableManager.Enemy.data[enemyid].enemyGold,DatatableManager.Enemy.data[enemyid].enemyExp]),cutTexture)
	return undead
##--------------------------------------------------------------------------
## ● 战斗结束后玩家状态结算
##--------------------------------------------------------------------------
func buff_check():
	var keys = MotaSystem.gameData.state.keys().duplicate()
	var state_data
	##----------------------------------------------------------------------
	## ● 检测所有状态，根据stateDisperse来决定是否驱散以及驱散多少层
	##----------------------------------------------------------------------
	for id in keys:
		state_data = DatatableManager.State.data[int(id)]
		match state_data.stateDisperse:
			-1:  # 驱散一半
				MotaSystem.gameData.state[id] = ceili(MotaSystem.gameData.state[id] / 2)
			-2:  # 全部驱散
				MotaSystem.gameData.removeState(id)
			_:
				MotaSystem.gameData.addState(id, -state_data.stateDisperse)
	##----------------------------------------------------------------------
	## :[中毒]: 战斗后获得{0}层【中毒】状态，每{1}点护盾会减少一层实际获得的状态
	##----------------------------------------------------------------------
	if battle.get_skill_value(11, "total_buff") > 0:
		MotaSystem.gameData.addState(1, battle.get_skill_value(11, "total_buff"))
	##----------------------------------------------------------------------
	## :[衰弱]: 战斗后获得{0}层【衰弱】状态，每{1}点护盾会减少一层实际获得的状态
	##----------------------------------------------------------------------
	if battle.get_skill_value(12, "total_buff") > 0:
		MotaSystem.gameData.addState(2, battle.get_skill_value(12, "total_buff"))
	##----------------------------------------------------------------------
	## :[迟缓]: 战斗后获得{0}层【迟缓】状态，每{1}点护盾会减少一层实际获得的状态
	##----------------------------------------------------------------------
	if battle.get_skill_value(13, "total_buff") > 0:
		MotaSystem.gameData.addState(3, battle.get_skill_value(13, "total_buff"))
	##----------------------------------------------------------------------
	## :[诅咒]: 战斗后获得{0}层【诅咒】状态，每{1}点护盾会减少一层实际获得的状态
	##----------------------------------------------------------------------
	if battle.get_skill_value(14, "total_buff") > 0:
		MotaSystem.gameData.addState(4, battle.get_skill_value(14, "total_buff"))
##--------------------------------------------------------------------------
## ● 战斗特效
##--------------------------------------------------------------------------
func playBattleAnim():
	#默认为原版普攻
	var dr = DatatableManager.Effect.data[101]
	var offset = Vector2(32,32)
	var pos = (self.global_position + offset)
	base.next_effect.append(MotaSystem.effectManager.showEffectOnNode.bind(dr["path"],base,Vector2(Defination.tilesize/2,Defination.tilesize/2),1))
##--------------------------------------------------------------------------
## ● 地图伤害特效
##--------------------------------------------------------------------------
func playMapDamageAnim(dam:float,type:MapSkillType = MapSkillType.sniper):
	var dr
	if dam >= 1:
		match type:
			MapSkillType.sniper:
				dr = DatatableManager.Effect.data[116]
			MapSkillType.area:
				dr = DatatableManager.Effect.data[106]
			MapSkillType.jiaji:
				dr = DatatableManager.Effect.data[111]
	else:
		dr = DatatableManager.Effect.data[103]
	base.next_effect.append(MotaSystem.effectManager.showEffectOnNode.bind(dr["path"],MotaSystem.Player,Vector2(Defination.tilesize/2,Defination.tilesize/2),1))
##--------------------------------------------------------------------------
## ● 地图伤害类别（特效用）
##--------------------------------------------------------------------------
enum MapSkillType
{
	sniper,
	area,
	jiaji,
}
func has_skill(id : String , ban_list : Array = []):
	return DatatableManager.Enemy.data[enemyid].enemySkill.has(id) && !ban_list.has(id)
##--------------------------------------------------------------------------
## ● 地图技能
##--------------------------------------------------------------------------
func map_skill( pos : Vector2i = MotaSystem.Player.tilePosition , tag : Array = [] , ban_list : Array = []):
	var dam       : int = 0
	var temp_dam  : int = 0
	var skill_val : PackedFloat64Array = []
	var data = DatatableManager.Enemy.data[enemyid]
	if event_state.has(base.name) && event_state[base.name].has("dead"):
		return 0
	##----------------------------------------------------------------------
	## :[领域]: 角色经过该敌人{0}格范围内时受到{1}点伤害，可被护盾减免
	##----------------------------------------------------------------------
	if has_skill("26" , ban_list):
		skill_val = data.enemySkill["26"].split_floats("/")
		if has_point(pos , skill_val[0] , skill_val[0], event_pos):
			temp_dam = mapskillObj.get_skill_value(26, "map_damage")
			dam += temp_dam
			if tag.has("action"):
				playMapDamageAnim(temp_dam, MapSkillType.area)
	##----------------------------------------------------------------------
	## :[射击]: 角色经过该敌人直线可视范围时受到{0}点伤害，可被护盾减免
	##----------------------------------------------------------------------
	if has_skill("33" , ban_list):
		if shot_straight(pos):
			temp_dam = mapskillObj.get_skill_value(33, "map_damage")
			dam += temp_dam
			if tag.has("action"):
				playMapDamageAnim(temp_dam, MapSkillType.sniper)
	return dam
##--------------------------------------------------------------------------
## ● 玩家是否处于该事件可见范围内
##--------------------------------------------------------------------------
func map_skill_single( skill_id : String , pos : Vector2i = MotaSystem.Player.tilePosition , tag : Array = []):
	var distance  : Vector2i = pos - event_pos
	var facepos   : Vector2i
	var dir       : int = (base.getDirectionByOtherPos(pos) + 1) * 2
	var dam       : int = 0
	var temp_dam  : int = 0
	var skill_val : PackedFloat64Array = []
	var data = DatatableManager.Enemy.data[enemyid]
	if event_state.has(base.name) && event_state[base.name].has("dead"):
		return 0
	if has_skill(skill_id):
		match skill_id:
			##--------------------------------------------------------------
			## :[封印]: 经过两只有该属性的同种敌人中间会获得1层封印状态
			##--------------------------------------------------------------
			"24":
				if distance.max_axis_index() == 1 && distance.length_squared() == 1 && enemy_ready.value["jiaji"].size() > 1:
					var jiaji_pos
					for jiaji in enemy_ready.value["jiaji"]:
						jiaji_pos = jiaji.event_pos
						if event_state.has(jiaji.base.name):
							if event_state[jiaji.base.name].has("dead"):
								continue
							if event_state[jiaji.base.name].has("pos") && event_state[jiaji.base.name]["pos"] != jiaji_pos:
								jiaji_pos = event_state[jiaji.base.name]["pos"]
						if jiaji.enemyid == enemyid && event_pos + (distance * 2) == jiaji_pos:
							if tag.has("action"):
								MotaSystem.gameData.addState(6, 1)
								if MotaSystem.gameForm != null:
									MotaSystem.gameForm.RefreshUI()
								playMapDamageAnim(1, MapSkillType.jiaji)
							else:
								if !event_state.has(base.name):
									event_state[base.name] = {}
								if !event_state[base.name].has("damrate"):
									event_state[base.name]["damrate"] = 1
								event_state[base.name]["damrate"] *= 2
			##--------------------------------------------------------------
			## :[夹击]: 经过两只有该属性的同种敌人中间会暂时减少一半生命
			##--------------------------------------------------------------
			"32":
				if distance.max_axis_index() == 1 && distance.length_squared() == 1 && enemy_ready.value["jiaji"].size() > 1:
					var jiaji_pos
					for jiaji in enemy_ready.value["jiaji"]:
						jiaji_pos = jiaji.event_pos
						if event_state.has(jiaji.base.name):
							if event_state[jiaji.base.name].has("dead"):
								continue
							if event_state[jiaji.base.name].has("pos") && event_state[jiaji.base.name]["pos"] != jiaji_pos:
								jiaji_pos = event_state[jiaji.base.name]["pos"]
						if jiaji.enemyid == enemyid && event_pos + (distance * 2) == jiaji_pos:
							if tag.has("action"):
								temp_dam = ceili(MotaSystem.gameData.hp * float(skill["32"]) / 100)
								MotaSystem.gameData.hp -= temp_dam
								MotaSystem.gameData.addState(5, temp_dam)
								if MotaSystem.gameForm != null:
									MotaSystem.gameForm.RefreshUI()
								playMapDamageAnim(temp_dam, MapSkillType.jiaji)
							else:
								if !event_state.has(base.name):
									event_state[base.name] = {}
								if !event_state[base.name].has("jiaji"):
									event_state[base.name]["jiaji"] = [float(skill["32"]) / 100]
								else:
									event_state[base.name]["jiaji"].append(float(skill["32"]) / 100)
			##--------------------------------------------------------------
			## :[追猎]: 角色经过该敌人四周可见直线上时，该敌人会向角色移动一格
			##--------------------------------------------------------------
			"28":
				if distance.length_squared() > 1:
					if shot_straight(pos, ["chase"]):
						facepos = base.checkFacePos((dir / 2) - 1 , event_pos)
						distance = pos - facepos
						if tag.has("action"):
							base.EventMovingStack.data.push_front(dir)
						else:
							temp_pos[temp_pos.size() - 1] = facepos
							if !event_state.has(base.name):
								event_state[base.name] = {}
							event_state[base.name]["move"] = true
				if distance.length_squared() <= 1:
					if tag.has("action"):
						no_auto_save = true
						base.startEvent()
					else:
						if !event_state.has(base.name):
							event_state[base.name] = {}
						event_state[base.name]["dead"] = true
						if battle.result == GameBattle.battlResult.win:
							dam += battle.damage
						else:
							event_state[base.name]["nowin"] = true
			##--------------------------------------------------------------
			## :[阻击]: 角色经过该敌人十字领域时受到{0}点伤害，同时该敌人会后退一格
			##--------------------------------------------------------------
			"25":
				if distance.length_squared() == 1:
					facepos = base.checkFacePos((absi(dir - 10) / 2) - 1 , event_pos)
					if map.can_fly(facepos):
						distance = pos - facepos
						if tag.has("action"):
							base.EventMovingStack.data.push_front(absi(dir - 10))
						else:
							temp_pos[temp_pos.size() - 1] = facepos
							if !event_state.has(base.name):
								event_state[base.name] = {}
							event_state[base.name]["move"] = true
					temp_dam = mapskillObj.get_skill_value(25, "map_damage")
					dam += temp_dam
					if tag.has("action"):
						playMapDamageAnim(temp_dam, MapSkillType.area)
			##--------------------------------------------------------------
			## :[捕捉]: 角色经过该敌人十字领域时直接战斗
			##--------------------------------------------------------------
			"29":
				if (battle.damage > 0 || battle.result != GameBattle.battlResult.win) && distance.length_squared() <= 1:
					if tag.has("action"):
						no_auto_save = true
						base.startEvent()
					else:
						if !event_state.has(base.name):
							event_state[base.name] = {}
						event_state[base.name]["dead"] = true
						if battle.result == GameBattle.battlResult.win:
							dam += battle.damage
						else:
							event_state[base.name]["nowin"] = true
	return dam
##--------------------------------------------------------------------------
## ● 玩家是否处于该事件可见范围内
##--------------------------------------------------------------------------
func shot_straight(pos:Vector2i = MotaSystem.Player.tilePosition, tag :Array = []) -> bool:
	##----------------------------------------------------------------------
	## ● 初始化局部变量
	##----------------------------------------------------------------------
	var can_shot      : bool = true
	var face_can_shot : bool = true
	var passable      : bool = false
	var face_passable : bool = false
	var shot_end      : bool = false
	var chase_end     : bool = false
	var face          : Callable
	var back          : Callable
	var dir           : int = -1
	var cache         : Array
	var step          : int = 0
	var step_max      : int = 0
	# 如果坐标已经重合 就直接返回true
	if pos == event_pos:  
		return true
	##----------------------------------------------------------------------
	## ● 加载朝向
	##----------------------------------------------------------------------
	var my_pos   : Vector2i = event_pos
	var face_pos : Vector2i
	if pos.x == my_pos.x:
		if pos.y > my_pos.y:
			face = MotaSystem.CurrentMap.isMapDownPassable
			back = MotaSystem.CurrentMap.isMapUpPassable
			dir  = 0
		else:
			face = MotaSystem.CurrentMap.isMapUpPassable
			back = MotaSystem.CurrentMap.isMapDownPassable
			dir  = 3
	if pos.y == my_pos.y:
		if pos.x > my_pos.x:
			face = MotaSystem.CurrentMap.isMapRightPassable
			back = MotaSystem.CurrentMap.isMapLeftPassable
			dir  = 2
		else:
			face = MotaSystem.CurrentMap.isMapLeftPassable
			back = MotaSystem.CurrentMap.isMapRightPassable
			dir  = 1
	# 如果两个坐标没有平行相交 就会无法判定朝向 直接返回false
	if face.is_null():
		return false
	##----------------------------------------------------------------------
	## ● 缓存加载中
	##----------------------------------------------------------------------
	if !map.line_cache["shot"].has(my_pos):
		map.line_cache["shot"][my_pos] = [-1, -1, -1, -1]
	if !map.line_cache["chase"].has(my_pos):
		map.line_cache["chase"][my_pos] = [-1, -1, -1, -1]
	# 根据范围类型调用缓存
	if tag.has("chase"):
		cache = map.line_cache["chase"][my_pos]
	else:
		cache = map.line_cache["shot"][my_pos]
	##----------------------------------------------------------------------
	## ● 当前已有缓存 根据缓存进行初步判定坐标点是否进入直线范围
	##----------------------------------------------------------------------
	if cache[dir] >= (my_pos - pos).length():
		return true
	elif cache[dir] != -1:
		return false
	elif cache[dir] > 0 && !temp_state.is_empty() && tag.has("chase"):
		match face:
			MotaSystem.CurrentMap.isMapRightPassable:
				my_pos.x += cache[dir]
			MotaSystem.CurrentMap.isMapLeftPassable:
				my_pos.x -= cache[dir]
			MotaSystem.CurrentMap.isMapDownPassable:
				my_pos.y += cache[dir]
			MotaSystem.CurrentMap.isMapUpPassable:
				my_pos.y -= cache[dir]
		step = cache[dir]
	elif event_state.is_empty():
		map.line_cache["shot"][event_pos][dir] = step
		map.line_cache["chase"][event_pos][dir] = step
	##----------------------------------------------------------------------
	## ● 判定直线距离是否可以抵达目标点 循环开始
	##----------------------------------------------------------------------
	face_pos = base.checkFacePos(dir, my_pos)
	while my_pos.x >= 0 && my_pos.x < MotaSystem.CurrentMap.width && my_pos.y >= 0 && my_pos.y < MotaSystem.CurrentMap.height:
		##------------------------------------------------------------------
		## ● 判定坐标点的图块是否可通过
		##------------------------------------------------------------------
		passable      = back.call(face_pos)
		face_passable = face.call(my_pos)
		if !(face_passable && passable):
			##--------------------------------------------------------------
			## ● 射击类型 可以穿过河面和低地 具体可在图块数据中开启can_shot选项
			##--------------------------------------------------------------
			if !shot_end:
				if !passable:
					can_shot = false
					# 遍历坐标格上的所有图层 判断障碍物是否为可射击
					for layer in MotaSystem.CurrentMap.tileMap.get_layers_count():
						var tileData = MotaSystem.CurrentMap.tileMap.get_cell_tile_data(layer,face_pos)
						if tileData != null:
							# zindex大于等于2时，高层则不会覆盖之前层result为false的通行判定
							if tileData.z_index < 2:
								if tileData.get_custom_data("can_shot"):
									can_shot = true
				if !face_passable:
					face_can_shot = false
					# 遍历坐标格上的所有图层 判断障碍物是否为可射击
					for layer in MotaSystem.CurrentMap.tileMap.get_layers_count():
						var tileData = MotaSystem.CurrentMap.tileMap.get_cell_tile_data(layer,my_pos)
						if tileData != null:
							# zindex大于等于2时，高层则不会覆盖之前层result为false的通行判定
							if tileData.z_index < 2:
								if tileData.get_custom_data("can_shot"):
									face_can_shot = true
			chase_end = true
			if shot_end || !(can_shot && face_can_shot):
				if event_state.is_empty():
					step = cache[dir]
				return step >= (event_pos - pos).length()
		##------------------------------------------------------------------
		## ● 追猎类型 视门为障碍物
		##------------------------------------------------------------------
		if !chase_end:
			##--------------------------------------------------------------
			## ● 追猎类型 查找坐标上存在的门
			##--------------------------------------------------------------
			if MotaSystem.CurrentMap.EventGrid.has(my_pos):
				for ev in MotaSystem.CurrentMap.EventGrid[my_pos]:
					if (ev.current_page is BarrierEvent || ev.current_page is RegionBarrierEvent):
						# 如果该事件在临时状态队列中被判定为已执行 则无视该事件
						if event_state.is_empty() || !event_state.has(ev.name) || !event_state[ev.name].has("dead"):
							# 如果该事件的临时坐标已更改 则跳过该事件
							if event_state.has(ev.name) && event_state[ev.name].has("pos") && event_state[ev.name]["pos"] != my_pos:
								continue
							# 只有临时状态队列为空的时候 才能将结果载入缓存
							chase_end = true
							if shot_end == chase_end || (!event_state.is_empty() && tag.has("chase")):
								return step >= (event_pos - pos).length()
			##--------------------------------------------------------------
			## ● 追猎类型 遍历所有状态已更改的事件 寻找门
			##--------------------------------------------------------------
			for name in event_state:
				# 遍历临时状态中所有未执行 且坐标为当前判定坐标的事件
				if event_state[name].has("pos") && !event_state[name].has("dead") && event_state[name]["pos"] == my_pos:
					var ev = map.events.get_node_or_null(str(name))
					# 如果找不到该事件或者不为门 则无视
					if ev != null && (ev.current_page is BarrierEvent || ev.current_page is RegionBarrierEvent):
						chase_end = true
						if shot_end == chase_end || (!event_state.is_empty() && tag.has("chase")):
							return step >= (event_pos - pos).length()
		##------------------------------------------------------------------
		## ● 获取下一步坐标 如果下一步坐标点已经进行过直线计算 则直接调用
		##------------------------------------------------------------------
		my_pos = face_pos
		face_pos = base.checkFacePos(dir, my_pos)
		step += 1
		if !shot_end && map.line_cache["shot"].has(my_pos):
			if map.line_cache["shot"][my_pos][dir] >= 0:
				step_max = max(step_max , map.line_cache["shot"][my_pos][dir])
				# 只有临时状态队列为空的时候 才能将结果载入缓存
				if event_state.is_empty():
					map.line_cache["shot"][event_pos][dir] = step + map.line_cache["shot"][my_pos][dir]
		step_max = 0
		if !chase_end && map.line_cache["chase"].has(my_pos):
			if map.line_cache["chase"][my_pos][dir] >= 0:
				step_max = max(step_max , map.line_cache["chase"][my_pos][dir])
				# 只有临时状态队列为空的时候 才能将结果载入缓存
				if event_state.is_empty():
					map.line_cache["chase"][event_pos][dir] = step + map.line_cache["chase"][my_pos][dir]
		if step_max > 0:
			return cache[dir] >= (event_pos - pos).length()
		elif event_state.is_empty():
			# 只有临时状态队列为空的时候 才能将结果载入缓存
			if !shot_end:
				map.line_cache["shot"][event_pos][dir] = step
			if !chase_end:
				map.line_cache["chase"][event_pos][dir] = step
	##----------------------------------------------------------------------
	## ● 循环结束 结算缓存和返回值
	##----------------------------------------------------------------------
	# 只有临时状态队列为空的时候 才能将结果载入缓存
	if event_state.is_empty():
		if !shot_end:
			map.line_cache["shot"][event_pos][dir] = step
		if !chase_end:
			map.line_cache["chase"][event_pos][dir] = step
	return cache[dir] >= (event_pos - pos).length()
##--------------------------------------------------------------------------
## ● 高危目标显示组件
##--------------------------------------------------------------------------
var HighRiskTarget_Monster_path = "res://Scene/UI/UIModule/HighRiskTarget.tscn"
func refresh_HighRiskTargetMonster():
	# 检测是否存在，没有则先创建一个
	if(self.get_node_or_null("HighRiskTargetMonster") == null):
		var HighRiskTargetMonster = MotaSystem.resourceManager.loadFile(HighRiskTarget_Monster_path).instantiate()
		HighRiskTargetMonster.name = "HighRiskTargetMonster"
		self.add_child(HighRiskTargetMonster)
##--------------------------------------------------------------------------
## ● 伤害显示组件变量
##--------------------------------------------------------------------------
var MonsterDamValue : RichTextLabel
var MonsterDamValue_path = "res://Scene/Prefab/ValueLabelPrefab/MonsterDamValue.tscn"
##--------------------------------------------------------------------------
## ● 伤害显示
##--------------------------------------------------------------------------
func refresh_label():
	# 检测是否存在label，没有则先创建一个
	if(self.get_node_or_null("MonsterDamValue") == null):
		MonsterDamValue = MotaSystem.resourceManager.loadFile(MonsterDamValue_path).instantiate()
		MonsterDamValue.name = "MonsterDamValue"
		self.add_child(MonsterDamValue)
	else:
		MonsterDamValue = get_node("MonsterDamValue")
	# 显伤颜色
	var mapDamagevalue_color:String = ""
	# 无法战胜
	if battle.result != GameBattle.battlResult.win:
		mapDamagevalue_color = "[color=#ff0000]"#红字伤害
	elif(int(battle.get_text()) >= MotaSystem.gameData.hp):
		mapDamagevalue_color = "[color=#ff0000]"#红字伤害
	elif(int(battle.get_text()) >= MotaSystem.gameData.hp * 0.67 && int(battle.get_text()) < MotaSystem.gameData.hp):
		mapDamagevalue_color = "[color=#ff8000]"#橙字伤害
	elif(int(battle.get_text()) >= MotaSystem.gameData.hp * 0.33 && int(battle.get_text()) < MotaSystem.gameData.hp * 0.67):
		mapDamagevalue_color = "[color=#ffff00]"#黄字伤害
	elif(int(battle.get_text()) > 0 && int(battle.get_text()) < MotaSystem.gameData.hp * 0.33):
		mapDamagevalue_color = "[color=#ffffff]"#白字伤害
	elif(int(battle.get_text()) <= 0):
		mapDamagevalue_color = "[color=#00ff00]"#绿字伤害
	if battle.result != GameBattle.battlResult.win:
		MonsterDamValue.text = mapDamagevalue_color + battle.get_text() + "[/color]"
	else:
		MonsterDamValue.text = mapDamagevalue_color + Utility.fuck2(int(battle.get_text())) + "[/color]"
	#是否显伤
	if MotaSystem.config.getValue("MapValueDisplay","mapvaluedisplay") == true:
		MonsterDamValue.visible = true
	else:
		MonsterDamValue.visible = false
##--------------------------------------------------------------------------
## ● 刷新光环特效
##--------------------------------------------------------------------------
func refresh_halo():
	#以动画形式播放效果
	if(self.get_node_or_null("Monsterarea") == null):
		var halo_anim:Node2D = MotaSystem.resourceManager.loadFile(DatatableManager.Effect.data[108]["path"]).instantiate()
		halo_anim.name = "Monsterarea"
		halo_anim.position = Vector2(32,32)
		self.add_child(halo_anim)
##--------------------------------------------------------------------------
## ● 夹击特效组件变量
##--------------------------------------------------------------------------
var jiajianim : String = DatatableManager.Effect.data[109].path
var jiaji_x   : EffectBase
var jiaji_y   : EffectBase
##--------------------------------------------------------------------------
## ● 刷新夹击特效
##--------------------------------------------------------------------------
func refresh_jiaji():
	var jiajix = false
	var jiajiy = false
	var resource
	var can_jia
	for jiaji in enemy_ready.value["jiaji"]:
		if !jiajiy && jiaji.enemyid == enemyid &&jiaji.base.tilePosition.x == base.tilePosition.x && jiaji.base.tilePosition.y == base.tilePosition.y + 2:
			can_jia = true
			for layer in MotaSystem.CurrentMap.tileMap.get_layers_count():
				var tileData = MotaSystem.CurrentMap.tileMap.get_cell_tile_data(layer,Vector2i(base.tilePosition.x,base.tilePosition.y + 1))
				if tileData != null:
					can_jia = true
					if tileData.z_index < 2 && !tileData.get_custom_data("passable"):
						if !tileData.get_custom_data("can_shot"):
							can_jia = false
			if can_jia:
				jiajiy = true
		if !jiajix && jiaji.enemyid == enemyid && jiaji.base.tilePosition.y == base.tilePosition.y && jiaji.base.tilePosition.x == base.tilePosition.x + 2:
			can_jia = true
			for layer in MotaSystem.CurrentMap.tileMap.get_layers_count():
				var tileData = MotaSystem.CurrentMap.tileMap.get_cell_tile_data(layer,Vector2i(base.tilePosition.x + 1,base.tilePosition.y))
				if tileData != null:
					can_jia = true
					if tileData.z_index < 2 && !tileData.get_custom_data("passable"):
						if !tileData.get_custom_data("can_shot"):
							can_jia = false
			if can_jia:
				jiajix = true
		if jiajix == true && jiajiy == true:
			break
	if jiajix:
		if self.get_node_or_null("jiaji_x") == null:
			resource = load(jiajianim)
			jiaji_x = resource.instantiate()
			jiaji_x.initialize(null)
			jiaji_x.name = "jiaji_x"
			jiaji_x.position = Vector2(112,32)
			jiaji_x.rotation_degrees = 90
			jiaji_x.z_index = -4
			jiaji_x.z_as_relative = false
			self.add_child(jiaji_x)
		else:
			jiaji_x.visible = true
	elif self.get_node_or_null("jiaji_x") != null:
		jiaji_x.visible = false
	if jiajiy:
		if self.get_node_or_null("jiaji_y") == null:
			resource = load(jiajianim)
			jiaji_y = resource.instantiate()
			jiaji_y.initialize(null)
			jiaji_y.name = "jiaji_y"
			jiaji_y.position = Vector2(32,80)
			jiaji_y.z_index = -4
			jiaji_y.z_as_relative = false
			self.add_child(jiaji_y)
		else:
			jiaji_y.visible = true
	elif self.get_node_or_null("jiaji_y") != null:
			jiaji_y.visible = false
