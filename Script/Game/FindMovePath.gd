##==============================================================================
## ■ FindMovePath
##------------------------------------------------------------------------------
## Astar自动寻路公式
##==============================================================================
class_name FindMovePath
##--------------------------------------------------------------------------
## ● 路径数据队列
##--------------------------------------------------------------------------
var open_list     : Array = []
var close_list    : Array = []
var path          : Array = []
var nearest_point : Array = []
##--------------------------------------------------------------------------
## ● 坐标点参数
##--------------------------------------------------------------------------
var point         : Vector2i
var target        : Vector2i
##--------------------------------------------------------------------------
## ● 地图与设置参数
##--------------------------------------------------------------------------
var map           : GameMap
var tag           : Array
##--------------------------------------------------------------------------
## ● 价值参数常量
##--------------------------------------------------------------------------
const radix      = 1                 # 步数与距离价值
const dam_radix  = 100               # 伤害价值
const real_radix = 10                # 真实损耗额外权重
const DoorRate   = {}                # 道具价值
##--------------------------------------------------------------------------
## ● 初始化
##--------------------------------------------------------------------------
func _init(m : GameMap, self_point : Vector2i, target_point : Vector2i, t : Array = []):
	map           = m             # 地图快捷方式
	point         = self_point    # 起点坐标点
	target        = target_point  # 终点坐标点
	tag           = t
	Start()
##--------------------------------------------------------------------------
## ● 遍历寻路循环
##--------------------------------------------------------------------------
func Start():
	var now_point = _FindMoveStruct(point.x, point.y, 5, get_father_xy(point.x, point.y, 5))
	nearest_point = now_point
	open_list.append(now_point)
	while now_point != null:
		if check_around_point(now_point):
			get_path()
			return
		now_point = get_lowest_f_point()
	#return  # 鼠标点击到障碍上的时候不再能自动寻路
	if tag.has("player") && map.EventGrid.has(Vector2i(target.x, target.y)) && nearest_point[4] == 10:
		get_path(nearest_point)
##--------------------------------------------------------------------------
## ● 扩散寻路法
##--------------------------------------------------------------------------
func check_around_point(point):
	var get_new_g_point
	var get_last_g_point
	var xy
	for d in [2, 4, 6, 8]:
		xy = get_d_x_y(point[0] ,point[1],d)
		if tag.has("through") && abs(target.x - xy.x) + abs(target.y - xy.y) > abs(target.x - point[0]) + abs(target.y - point[1]):
			# 寻路可以穿透障碍物时 与目标点相反的方向 直接跳过
			continue
		elif in_list(xy.x, xy.y, close_list):
			# 已关闭列表有前方坐标点 直接跳过
			continue
		elif in_list(xy.x, xy.y):
			# 新坐标点与未计算坐标点重合时 进行代价对比
			get_last_g_point = get_point(xy.x, xy.y)
			# 旧坐标点
			get_new_g_point = _FindMoveStruct(xy.x, xy.y, 10 - d, get_father_xy(xy.x, xy.y, 10 - d))
			# 新坐标点
			open_list[open_list.find(get_last_g_point)] = contrast(get_new_g_point, get_last_g_point)
		elif xy.x >= 0 && xy.x < map.width && xy.y >= 0 && xy.y < map.height && (tag.has("through") || (map.isMapFacePassable(Vector2i(point[0] ,point[1]), (d / 2) - 1) && map.isMapFacePassable(xy, (abs(d - 10) / 2) - 1)) || (xy.x == target.x && xy.y == target.y && !map.isMapPassable(xy) && map.EventGrid.has(xy))):
			# 可通行坐标的情况下
			var start:bool = true
			var father = get_father_xy(xy.x, xy.y, 10 - d)
			# 是否有事件障碍物
			if !tag.has("through") && map.EventGrid.has(xy) && !(xy.x == target.x && xy.y == target.y):
				for ev in map.EventGrid[xy]:
					if !ev.eventPassable && !((ev.current_page is MonsterEvent && !tag.has("enemywall")) || ev.current_page is ComsumableEvent || ev.current_page is ItemEvent):
						# [怪物、宝石、物品]不算在障碍物之内
						if tag.has("player") && (ev.current_page is BarrierEvent || (ev.current_page.trigger == 0 && ev.current_page.onPageFinished > 0) || ev.current_page.findpathPassable):
							# 如果是玩家寻路 则将触摸执行且会切换事件的事件视为平地 大不了触发事件后再寻路一次
							# 怪物寻路则无法无视
							continue
						start = false
						break
			if start:
				# 将其标记为可作为路径的坐标点
				var newpoint = _FindMoveStruct(xy.x, xy.y, 10 - d, get_father_xy(xy.x, xy.y, 10 - d))
				open_list.append(newpoint)
				# 每次出现新的可选路径坐标点 都要 进行优先级对比
				nearest_point = contrast(newpoint, nearest_point, true)
				if xy.x == target.x && xy.y == target.y:
					return true
	close_list.append(point)
	open_list.erase(point)
	return false
##--------------------------------------------------------------------------
## ● 检查坐标点点是否在关闭列表中
##--------------------------------------------------------------------------
func in_list(x:int, y:int, list:Array = open_list) -> bool:
	for p in list:
		if p[0] == x && p[1] == y:
			return true
	return false
##--------------------------------------------------------------------------
## ● 寻路成功 获取可行路径方向队列
##--------------------------------------------------------------------------
func get_path(now_point = open_list.back()):
	# 触碰寻路
	if now_point[0] != target.x || now_point[1] != target.y:
		# 只有在障碍物上有事件 且有路径可以触碰到这个事件才会触发这条
		if abs(now_point[0] - target.x) > abs(now_point[1] - target.y):
			if now_point[0] < target.x:
				path.append(6)
			else:
				path.append(4)
		else:
			if now_point[1] < target.y:
				path.append(2)
			else:
				path.append(8)
	# 剩余的路径队列
	while now_point[2] != 5:
		path.append(10 - now_point[2])
		now_point = get_father_point(now_point)
##--------------------------------------------------------------------------
## ● 获取坐标点的已知父节点
##--------------------------------------------------------------------------
func get_father_point(now_point : Array):
	var d = now_point[2]
	if d == 5:
		return now_point
	var xy = get_d_x_y(now_point[0], now_point[1], d)
	return get_point(xy.x, xy.y)
##--------------------------------------------------------------------------
## ● 获取坐标点的已知父节点
##--------------------------------------------------------------------------
func get_father_xy(x : int, y : int, d : int):
	if d == 5:
		return null
	var xy = get_d_x_y(x, y, d)
	return get_point(xy.x, xy.y)
##--------------------------------------------------------------------------
## ● 获取代价最小，最接近的节点
##--------------------------------------------------------------------------
func get_lowest_f_point():
	var last_lowest_f_point = open_list.front()
	for p in open_list:
		last_lowest_f_point = contrast(p, last_lowest_f_point)
	return last_lowest_f_point
##--------------------------------------------------------------------------
## ● 根据指定方向取得前方坐标点
##--------------------------------------------------------------------------
func get_d_x_y(x : int, y : int, d : int) -> Vector2i:
	if d == 6:
		x += 1
	elif d == 4:
		x -= 1
	if d == 2:
		y += 1
	elif d == 8:
		y -= 1
	return Vector2i(x, y)
##--------------------------------------------------------------------------
## ● 获取队列中的已知坐标点
##--------------------------------------------------------------------------
func get_point(x : int, y : int):
	for p in open_list:
		if p[0] == x && p[1] == y:
			return p
	for p in close_list:
		if p[0] == x && p[1] == y:
			return p
##--------------------------------------------------------------------------
## ● 数组参数内容说明
##--------------------------------------------------------------------------
## [0] x值 坐标
## [1] y值 坐标
## [2] d值 朝向
## [3] g值 当前走出步数
## [4] h值 离目标的距离
## [5] f值 步数与距离的综合评分
## [6] 鼠标寻路模式下的综合hash
##--------------------------------------------------------------------------
## ● 哈希参数内容说明
##--------------------------------------------------------------------------
## [0]  dead值       为true时优先级降低
## [1]  nokey值      为true时无法通行
## [2]  damage值     当前路线消耗的血量
## [3]  heal值       当前路线的治疗
## [4]  door值     当前路线消耗的钥匙的哈希
## [5]  key值        当前路线获取的钥匙的哈希 用于计算当前路线是否无法开门
## [6]  doorcost值       当前路线开门所消耗的物品的综合价值

## [10] allcost值    当前路线总代价
## [11] damrate值    当前路线受伤比例
## [12] enemy值      怪物状态的hash
##--------------------------------------------------------------------------
## ● 对行动的代价与距离进行评估
##--------------------------------------------------------------------------
func contrast(struct, tar, next:bool = false):
	if tag.has("player"):
		var strnokey = false
		var tarnokey = false
		var strdead = false
		var tardead = false
		var strcost = 0
		var tarcost = 0
		var strdoor = 0
		var tardoor = 0
		if struct.size() > 6:
			strnokey = struct[6].has(0)
			strdead = struct[6].has(1)
			if struct[6].has(10):
				strcost = struct[6][10]
			if struct[6].has(6):
				strdoor = struct[6][6]
		if tar.size() > 6:
			tarnokey = tar[6].has(0)
			tardead = tar[6].has(1)
			if tar[6].has(10):
				tarcost = tar[6][10]
			if tar[6].has(6):
				tardoor = tar[6][6]
		if (strnokey && !tarnokey) || (strdead && !tardead):
			return tar
		if (!strnokey && tarnokey) || (!strdead && tardead):
			return struct
		if tardoor > strdoor:
			return tar
		elif tardoor < strdoor:
			return struct
		if tarcost > strcost:
			return struct
		if tardoor == strdoor && tarcost == strcost && ((!next && tar[5] > struct[5]) || (next && tar[4] > struct[4])):
			return struct
	elif (!next && tar[5] > struct[5]) || (next && tar[4] > struct[4]):
		return struct
	return tar
##--------------------------------------------------------------------------
## ● 进行复杂的代价计算
##--------------------------------------------------------------------------
func _FindMoveStruct(x, y, d, father = null):
	var g = 0
	if father != null:
		g = father[3] + radix
	var h = (abs(target.x - x) + abs(target.y - y)) * radix
	var struct = [x, y, d, g, h, g + h]
	var dam_rate = 1
	if tag.has("player"):
		# 角色的寻路需要参考代价 而非角色寻路可以直接跳过
		var vec = Vector2i(x, y)
		var hash = {}
		# 起始点无需进行有关当前坐标点的代价结算
		if father != null:
			# 拷贝哈希表内的数据
			if father.size() > 6:
				hash = father[6].duplicate(true)
				if hash.has(11):
					dam_rate = hash[11]
			# 路径上的每个行动 都需要 进行单独的 地图技能结算
			var enemy = MapDamageCheck(struct, hash)
			if !enemy.is_empty():
				hash[12] = enemy
		# 非穿透模式时 的行动 撞上已移动的怪物
		if !tag.has("through") && hash.has(12):
			for ev in hash[12]:
				if hash[12][ev].has("pos") && !hash[12][ev].has("dead") && hash[12][ev]["pos"].x == x && hash[12][ev]["pos"].y == y:
					var en = map.events.get_node(str(ev))
					if en != null:
						if en.current_page is MonsterEvent && !en.current_page.is_dead():
							if en.current_page.battle.result == 0:
								struct_set(hash, 2, max((((en.current_page.battle.damage + en.current_page.battle.p_fighter.mdef) * dam_rate) - en.current_page.battle.p_fighter.mdef) * dam_radix,1))
							elif !hash.has(0): 
								struct_set(hash, 0, 1)
							hash[12][ev]["dead"] = true
		# 遍历行动时 撞上的事件
		if map.EventGrid.has(vec):
			for ev in map.EventGrid[vec]:
				if !tag.has("through") && !ev.eventPassable && (!hash.has(12) || !hash[12].has(ev.name) || !hash[12][ev.name].has("pos")):
					# 不可通行的事件 部分
					if ev.current_page is ItemEvent && ev.current_page.type == ItemEvent.ItemType.Item:
						# 取得钥匙 用于判断路径上的钥匙是否足够开门
						if !hash.has(5):
							hash[5] = {}
						if !hash[5].has(ev.current_page.ID):
							hash[5][ev.current_page.ID] = 0
						hash[5][ev.current_page.ID] += ev.current_page.value
					elif ev.current_page is BarrierEvent:
						if ev.current_page.checkItemValue > 0:
							# 门的代价判定 用于判断路径上的钥匙是否足够开门
							if !hash.has(4):
								hash[4] = {}
							if !hash[4].has(ev.current_page.checkItemID):
								hash[4][ev.current_page.checkItemID] = 0
							hash[4][ev.current_page.checkItemID] += 1
							if DoorRate.has(ev.current_page.checkItemID):
								struct_set(hash, 6, -DoorRate[ev.current_page.checkItemValue])
							else:
								struct_set(hash, 6, -ev.current_page.checkItemID ** 3)
							if !hash.has(1):
								if hash.has(5) && hash[5].has(ev.current_page.checkItemID):
									if hash[4][ev.current_page.checkItemID] >  MotaSystem.gameData.getItemNum(ev.current_page.checkItemID) + hash[5][ev.current_page.checkItemID]:
										struct_set(hash, 1, 1)
								elif hash[4][ev.current_page.checkItemID] >  MotaSystem.gameData.getItemNum(ev.current_page.checkItemID):
									struct_set(hash, 1, 1)
							if !hash.has(12):
								hash[12] = {}
							if !hash[12].has(ev.name):
								hash[12][ev.name] = {}
							hash[12][ev.name]["dead"] = true
					elif ev.current_page is MonsterEvent && !ev.current_page.is_dead() && !(ev.current_page.battle == null):
						# 战斗伤害代价计算
						if ev.current_page.battle.result == 0:
							struct_set(hash, 2, max((((ev.current_page.battle.damage + ev.current_page.battle.p_fighter.mdef) * dam_rate) - ev.current_page.battle.p_fighter.mdef) * dam_radix,1))
						elif !hash.has(0): 
							struct_set(hash, 0, 1)
						if !hash.has(12):
							hash[12] = {}
						if !hash[12].has(ev.name):
							hash[12][ev.name] = {}
						hash[12][ev.name]["dead"] = true
					elif ev.current_page is ComsumableEvent && ev.current_page.type == ComsumableEvent.ConsumableType.HP:
						# 血瓶回复生命值 用于判断路径是否会导致角色死亡
						struct_set(hash, 3, ev.current_page.total_value)
					elif ev.current_page.trigger == 0 && ev.current_page.onPageFinished > 0:
						# 如果路径中需要经过不可通行 但可以触摸触发 且会切换事件页的事件 则降低优先级
						struct_set(hash, 2, 1)
				elif !tag.has("through") && ev.current_page is TrapEvent:
					# 陷阱伤害
					struct_set(hash, 2, ev.current_page.damage * dam_radix)
				elif (ev.current_page is TeleportEvent) && vec != target:
					# 如果路径中需要通过传送点 则降低优先级
					struct_set(hash, 2, 1)
		if !tag.has("through"):
			# 穿透模式不评估任何代价 以下是非穿透模式
			if !hash.has(0) && hash.has(2):
				# 判定该路径会不会使角色死亡
				var dam = hash[2] / dam_radix
				# 获取原始伤害
				if hash.has(3):
					dam -= hash[3]
				# 伤害是否超阈值
				if dam >= MotaSystem.gameData.hp:
					struct_set(hash, 0, 1)
			# 路径总代价判断
			var allcost = 0
			# 伤害代价判断
			if hash.has(2):
				allcost += hash[2]
			# 由于是代价判断 所以获得的血瓶不能算在列
			if allcost != 0:
				hash[10] = allcost * radix * real_radix
		if !hash.is_empty():
			struct.append(hash)
	return struct
##--------------------------------------------------------------------------
## ● 获得哈希内的某个数据
##--------------------------------------------------------------------------
func get_key(father,id:int):
	if father.size() > 6 && !father[6].has(id + 3):
		return father[6][id + 3]
	return 0
##--------------------------------------------------------------------------
## ● 对哈希内的数据进行计算
##--------------------------------------------------------------------------
func struct_set(hash, index, value):
	if !hash.has(index):
		hash[index] = 0
	hash[index] += value
##--------------------------------------------------------------------------
## ● 行动会受到的地图伤害的代价计算
##--------------------------------------------------------------------------
func MapDamageCheck(father, hash):
	var enemy = {}
	if hash.has(12):
		enemy = hash[12]
	struct_set(hash, 2, map.enemyReady.map_skill(Vector2i(father[0], father[1]), enemy, []) * dam_radix)
	for key in enemy:
		if enemy[key].has("jiaji"):
			# 计算当前剩余hp
			var temp_hp = MotaSystem.gameData.hp - (hash[2] / dam_radix)
			if hash.has(3):
				temp_hp += hash[3]
			for jiaji in enemy[key]["jiaji"]:
				var jiaji_hp = ceili(temp_hp * jiaji)
				# 封印其实不能算作正常伤害 因此只计算负血瓶就行了
				struct_set(hash, 3, -jiaji_hp)
				temp_hp -= jiaji_hp
			# 移除状态中的jiaji 否则会一直被封印掉血
			enemy[key].erase("jiaji")
		if enemy[key].has("damrate"):
			# 受到夹击 后续所有战斗伤害翻倍
			if !hash.has(11):
				hash[11] = 1
			hash[11] *= enemy[key]["damrate"]
			# 移除状态中的damrate 否则会重复触发翻倍
			enemy[key].erase("damrate")
		if enemy[key].has("nowin"):
			# 无法战胜当前路径的怪物
			struct_set(hash, 2, MotaSystem.gameData.hp * dam_radix)
			# 勾上dead值
			if !hash.has(0): 
				struct_set(hash, 0, 1)
			# 移除状态中的nowin 否则会结算为反复去世
			enemy[key].erase("nowin")
	return enemy
