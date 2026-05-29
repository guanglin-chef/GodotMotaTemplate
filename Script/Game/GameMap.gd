class_name GameMap extends Node2D

# key为表中ID
var key:int

# ------------------------

## 标定地图长(单位为格子)
@export var width:int = 15
## 标定地图宽(单位为格子)
@export var height:int = 15

@onready
var tileMap:TileMap = $TileMap
@onready
var events:CanvasItem = $Events

# EnemyReady
var enemyReady:EnemyReady = EnemyReady.new(self)
# 动态创建的事件
var temp_event:Dictionary = {}
# MapData
var data:Dictionary
# 怪物详情场景
var EnemyStateForm

signal cold_refresh
##--------------------------------------------------------------------------
## ● 初始化地图事件
##--------------------------------------------------------------------------
func initMap(mapData:Dictionary):
	# 根据存档内容移动事件至该在的位置
	if mapData.has("alive_ruby"):
		mapData["alive_ruby"] = data["alive_ruby"]
	data = mapData
	if data.has("eventdata"):
		for event:GameEvent in get_node("Events").get_children():
			if data["eventdata"].has(event.name):
				event.initEvent(data["eventdata"][event.name])
			else:
				event.base_dir = floori(event.get_child(event.initialPageIndex).frame / 4)
	if data.has("tempevent"):
		for event in data["tempevent"]:
			create_temp_event(mapData["tempevent"][event])
##--------------------------------------------------------------------------
## ● 初始化地图变更
##--------------------------------------------------------------------------
var initOnEnter:bool = false
func initMapOnEnter():
	if !initOnEnter:
		if data.has("changetile"):
			var tag = {}
			for change in data["changetile"]:
				for k in change:
					change_tile(k,Utility.parseString2Vector2i(change[k]),tag)
		initOnEnter = true
##--------------------------------------------------------------------------
## ● 地图退出场景树 清理节点
##--------------------------------------------------------------------------
func _exit_tree():
	EventGrid = {}
	for i in clear_point:
		i.free()
	clear_point = []
	for i in damage_point.values():
		i.free()
	damage_point = {}
##--------------------------------------------------------------------------
## ● 初始化地图
##--------------------------------------------------------------------------
func onEnterMap():
	# 初始化2
	initMapOnEnter()
	for event:GameEvent in events.get_children():
		event.onEnter()
	# 初始化3
	if !MotaSystem.gameVariables["teleport"]:
		refresh_mapname()
	if !MotaSystem.mapManager.preview:
		set_mapid()
		#bgm
		play_map_bgm()
	# 刷新
	MotaSystem.gameForm.RefreshUI()
	
	# 初始化EventGrid
	EventGrid = {}
##--------------------------------------------------------------------------
## ● 实际设置地图ID
##--------------------------------------------------------------------------
func set_mapid():
	# 记录当前id
	MotaSystem.gameVariables["mapId"] = key
	MotaSystem.gameVariables["towerId"] = DatatableManager.Map.data[key]["towerId"]
	# 地图名称
	refresh_mapname()
##--------------------------------------------------------------------------
## ● 刷新状态栏中的地图名称
##--------------------------------------------------------------------------
func refresh_mapname():
	if DatatableManager.Map.data[key]["tower"] == true:
		var areaname = DatatableManager.Tower.data[DatatableManager.Map.data[key]["towerId"]]["name"]
		MotaSystem.gameForm.area_name.text = areaname
		MotaSystem.gameForm.area_name.visible = true
		var mapname = str(DatatableManager.Map.data[key]["floorId"]) + tr("层")
		MotaSystem.gameForm.map_name.text = mapname
	else:
		MotaSystem.gameForm.area_name.visible = false
		var mapname = DatatableManager.Map.data[key]["mapName"]
		MotaSystem.gameForm.map_name.text = mapname
##--------------------------------------------------------------------------
## ● 计算并返回当前坐标的中心对称坐标
##--------------------------------------------------------------------------
func fly_point(pos : Vector2i = MotaSystem.Player.tilePosition):
	return Vector2i(absi(pos.x - width) - 1, absi(pos.y - height) - 1)
##--------------------------------------------------------------------------
## ● 该坐标面向位置的通行是否被图块的单向阻挡
##--------------------------------------------------------------------------
func isMapFacePassable(pos:Vector2i,face:Defination.direction) -> bool:
	match face:
		Defination.direction.up:
			return isMapUpPassable(pos)
		Defination.direction.down:
			return isMapDownPassable(pos)
		Defination.direction.left:
			return isMapLeftPassable(pos)
		Defination.direction.right:
			return isMapRightPassable(pos)
	return false
##--------------------------------------------------------------------------
## ● 该坐标的通行是否被图块的单向阻挡
##--------------------------------------------------------------------------
func isMapUpPassable(pos:Vector2i) -> bool:  #对某位置的上通行检测
	# 检测地图通行
	var result = true
	for layer in tileMap.get_layers_count():
		var tileData = tileMap.get_cell_tile_data(layer,pos)
		if tileData != null:
			# zindex大于等于2时，高层则不会覆盖之前层result为false的通行判定
			if tileData.z_index >= 2 && result == false:
				pass
			else:
				if tileData.get_custom_data("up_passable"):
					result = true
				else:
					result = false
	return result
##--------------------------------------------------------------------------
## ● 该坐标的通行是否被图块的单向阻挡
##--------------------------------------------------------------------------
func isMapDownPassable(pos:Vector2i) -> bool:  #对某位置的下通行检测
	# 检测地图通行
	var result = true
	for layer in tileMap.get_layers_count():
		var tileData = tileMap.get_cell_tile_data(layer,pos)
		if tileData != null:
			# zindex大于等于2时，高层则不会覆盖之前层result为false的通行判定
			if tileData.z_index >= 2 && result == false:
				pass
			else:
				if tileData.get_custom_data("down_passable"):
					result = true
				else:
					result = false
	return result
##--------------------------------------------------------------------------
## ● 该坐标的通行是否被图块的单向阻挡
##--------------------------------------------------------------------------
func isMapLeftPassable(pos:Vector2i) -> bool:  #对某位置的左通行检测
	# 检测地图通行
	var result = true
	for layer in tileMap.get_layers_count():
		var tileData = tileMap.get_cell_tile_data(layer,pos)
		if tileData != null:
			# zindex大于等于2时，高层则不会覆盖之前层result为false的通行判定
			if tileData.z_index >= 2 && result == false:
				pass
			else:
				if tileData.get_custom_data("left_passable"):
					result = true
				else:
					result = false
	return result
##--------------------------------------------------------------------------
## ● 该坐标的通行是否被图块的单向阻挡
##--------------------------------------------------------------------------
func isMapRightPassable(pos:Vector2i) -> bool:  #对某位置的右通行检测
	# 检测地图通行 
	var result = true
	for layer in tileMap.get_layers_count():
		var tileData = tileMap.get_cell_tile_data(layer,pos)
		if tileData != null:
			# zindex大于等于2时，高层则不会覆盖之前层result为false的通行判定
			if tileData.z_index >= 2 && result == false:
				pass
			else:
				if tileData.get_custom_data("right_passable"):
					result = true
				else:
					result = false
	return result
##--------------------------------------------------------------------------
## ● 该坐标的通行是否被图块阻挡
##--------------------------------------------------------------------------
func isMapPassable(pos:Vector2i) -> bool:
	# 检测地图通行
	var result = true
	# 从低到高查看通行，高层会覆盖之前的判定
	for layer in tileMap.get_layers_count():
		var tileData = tileMap.get_cell_tile_data(layer,pos)
		if tileData != null:
			# zindex大于等于2时，高层则不会覆盖之前层result为false的通行判定
			if tileData.z_index >= 2 && result == false:
				pass
			else:
				if tileData.get_custom_data("passable"):
					result = true
				else:
					result = false
	return result
##--------------------------------------------------------------------------
## ● 该坐标的通行是否被事件阻挡
##--------------------------------------------------------------------------
func isEventPassable(pos:Vector2i,selfEvent = null) -> bool:
	# 检测事件通行
	var result = true
	for event in checkEvent(pos):
		# 视情况排除自身
		if event == selfEvent:
			continue
		if event.visible:
			if !event.eventPassable && !event.isDead:
				result = false
				break
	return result
##--------------------------------------------------------------------------
## ● 坐标是否可通行
##--------------------------------------------------------------------------
func isPassable(pos:Vector2i):
	return isMapPassable(pos) && isEventPassable(pos)
##--------------------------------------------------------------------------
## ● 播放bgm
##--------------------------------------------------------------------------
func play_map_bgm():
	#检测BGM是否为空
	if DatatableManager.Map.data[key].bgmName != "":
		AudioManager.playBGM(DatatableManager.Map.data[key].bgmName,DatatableManager.Map.data[key].bgmOffset)
	#else:
		#AudioManager.stopBGM()
##--------------------------------------------------------------------------
## ● 检测某个位置的所有事件
##--------------------------------------------------------------------------
func checkEvent(pos:Vector2i):
	var result = []
	if EventGrid.has(pos):
		return EventGrid[pos]
	#for event:GameEvent in events.get_children():
	#	if event.tilePosition == pos && event.visible:
	#		result.append(event)
	return result
##--------------------------------------------------------------------------
## ● 所有存在事件的一张表，key为坐标，value为事件
##   便于在查询事件时尽可能的减少遍历次数
##   需要一直维护
##--------------------------------------------------------------------------
var eventgrid:Dictionary
var EventGrid:Dictionary:
	get:
		if eventgrid.has(0) == false:
			var result:Dictionary = {}
			for event:GameEvent in events.get_children():
				if !event.isDead && event.visible:
					if result.has(event.tilePosition) == false:
						result[event.tilePosition] = []
						result[event.tilePosition].append(event)
					else:
						if typeof(result[event.tilePosition][0].current_page) == typeof(event.current_page):
							print("{0}地图中出现了同类型事件{1}与{2}重叠的情况，有可能是叠怪或叠门，注意。".format([name,event.name,result[event.tilePosition][0].name]))
						# 对于同一个格子上的多个事件进行排序
						if event.current_page is BarrierEvent || event.current_page is MonsterEvent:
							for i in range(0,result[event.tilePosition].size()):
								if result[event.tilePosition][i].current_page is ComsumableEvent:
									result[event.tilePosition].insert(i,event)
								elif i == result[event.tilePosition].size() - 1:
									result[event.tilePosition].append(event)
						elif  event.current_page is ComsumableEvent || event.current_page is ItemEvent:
							result[event.tilePosition].append(event)
						else:
							result[event.tilePosition].push_front(event)
			eventgrid = result
			eventgrid[0] = true
		return eventgrid
	set(v):
		clear_range_cache()
		eventgrid = v
		line_cache["chase"] = {}
		show_damage_point()

var line_cache : Dictionary = { "shot" : {} , "chase" : {} }
#------------------地图变化---------------------

##--------------------------------------------------------------------------
## ● 地图动态改变处理
##--------------------------------------------------------------------------
func change_tile(type:String,pos:Vector2i,tag:Dictionary = {}) -> bool:
	var val = type.split("/")
	type = val[0]
	line_cache = { "shot" : {} , "chase" : {} }
	match type:
		"allbreak":
			var break_pos:Vector2i
			for bx in range(pos.x - int(val[1]), pos.x + int(val[1]) + 1):
				for by in range(pos.y - int(val[1]),  pos.y + int(val[1]) + 1):
					break_pos = Vector2i(bx, by)
					for layer in tileMap.get_layers_count():
						if tileMap.get_layer_name(layer).contains("wall"):
							tileMap.erase_cell(layer,break_pos)
		"break":
			for layer in tileMap.get_layers_count():
				if tileMap.get_layer_name(layer).contains("wall"):
					var tileData = tileMap.get_cell_tile_data(layer,pos)
					if tileData != null && tileData.get_custom_data("can_break"):
						tileMap.erase_cell(layer,pos)
						show_damage_point()
						return true
			return false
	show_damage_point()
	return true
##--------------------------------------------------------------------------
## ● 动态事件
##--------------------------------------------------------------------------
func create_temp_event(dict:Dictionary,swap_keys:String = ""):
	var newevent = MotaSystem.resourceManager.loadFile(DatatableManager.TempPerfab.data[int(dict["id"])].path).instantiate()
	if dict.has("parameter"):
		newevent.initEvent(dict["parameter"])
	if swap_keys != "":
		newevent.position = temp_event[swap_keys]["node"].position
	else:
		newevent.position = Vector2i(dict["x"] * Defination.tilesize,dict["y"] * Defination.tilesize)
	newevent.TempEvent = true
	get_node("Events").add_child(newevent)
	if swap_keys != "":
		for page in temp_event[swap_keys]["node"].pages:
			if page is MonsterEvent:
				page.del_monster()
		temp_event[swap_keys]["node"].free()
		temp_event[swap_keys]["id"] = dict["id"]
		temp_event[swap_keys]["node"] = newevent
		newevent.TempEventID = swap_keys
	else:
		var i:int = 1
		while temp_event.has(DatatableManager.TempPerfab.data[int(dict["id"])].name + str(i)):
			i += 1
		temp_event[DatatableManager.TempPerfab.data[int(dict["id"])].name + str(i)] = { "id" : dict["id"], "node" : newevent }
		newevent.TempEventID = DatatableManager.TempPerfab.data[int(dict["id"])].name + str(i)
	if newevent.current_page is MonsterEvent:
		newevent.current_page.init_monster()
		newevent.current_page.initialize_fighter()
		newevent.current_page.refresh()
	newevent.onEnter()
	if swap_keys == "":
		if !eventgrid.has(Vector2i(dict["x"], dict["y"])):
			eventgrid[Vector2i(dict["x"], dict["y"])] = []
		eventgrid[Vector2i(dict["x"], dict["y"])].push_front(newevent)
	else:
		var new_x = newevent.position.x / 64
		var new_y = newevent.position.y / 64
		if !eventgrid.has(Vector2i(new_x, new_y)):
			eventgrid[Vector2i(new_x, new_y)] = []
		if !eventgrid[Vector2i(new_x, new_y)].has(newevent):
			eventgrid[Vector2i(new_x, new_y)].push_front(newevent)
##--------------------------------------------------------------------------
## ● 实时刷新
##--------------------------------------------------------------------------
func _process(delta: float):
	# 长按计时检测
	if is_button_holding:
		button_hold_timer += delta
		if button_hold_timer >= button_hold_threshold:
			showEnemyStateInMap()  # 长按查看怪物地图实际详情
			is_button_holding = false  # 防止重复触发
##--------------------------------------------------------------------------
## ● 鼠标锁定
##--------------------------------------------------------------------------
var mouse_move:bool = false
var ban_mouse_move:bool = false
##--------------------------------------------------------------------------
## ● 按键处理
##--------------------------------------------------------------------------
var is_button_holding := false      # 是否正在长按
var button_hold_timer := 0.0        # 计时器
const button_hold_threshold := 0.5         # 长按阈值（0.5秒）
func _unhandled_input(e:InputEvent):
	# 鼠标保持按下状态的情况
	if e is InputEventMouseButton && e.pressed:
		var pos = Utility.worldPos2TilePos(get_local_mouse_position())
		match e.button_index:
			MOUSE_BUTTON_RIGHT:
				if EventGrid.has(pos):
					for event in EventGrid[pos]:
						if event.current_page is RegionBarrierEvent:
							event.current_page.flash()
	# 检测触摸屏按下/松开
	if e is InputEventScreenTouch:
		if e.pressed:
			is_button_holding = true
			button_hold_timer = 0.0
		else:
			is_button_holding = false
	# 检测鼠标右键按下/松开
	if e is InputEventMouseButton && !e.pressed:
		ban_mouse_move = false
		mouse_move = true
		match e.button_index:
			MOUSE_BUTTON_RIGHT:
				showEnemyStateInMap()
	elif Input.get_mouse_button_mask() & 1 == 1 && !ban_mouse_move:
		var pos = Utility.worldPos2TilePos(get_local_mouse_position())
		if !mouse_move:
			ban_mouse_move = true
		elif (MotaSystem.Player.MovingStack.is_empty() || MotaSystem.Player.mouse_target != pos) && !MotaSystem.gameEventManager.hasAnyRunningEvent() && !MotaSystem.m_UIManager.hasRunningUI(Defination.UILayer.Main) && (!MotaSystem.Player.moving || !MotaSystem.Player.MovingStack.is_empty()):
			if !MotaSystem.m_UIManager.hasRunningUI(Defination.UILayer.Main) && !MotaSystem.m_UIManager.hasRunningUI(Defination.UILayer.PopUp):
				if MotaSystem.Player.tilePosition != pos:
					mouse_button_move(pos)
				else:
					MotaSystem.Player.playerTurn()
	elif !ban_mouse_move:
		mouse_move = true
# 鼠标右键/触摸屏长按触发查看怪物详情
func showEnemyStateInMap():
	var pos = Utility.worldPos2TilePos(get_local_mouse_position())
	if EventGrid.has(pos):
		for event in EventGrid[pos]:
			if event.current_page is MonsterEvent:
				if EnemyStateForm != null:
					EnemyStateForm.close()
					EnemyStateForm = null
				EnemyStateForm = MotaSystem.uiManager.open(Defination.UIID.EnemyStateFormMap, event)
##--------------------------------------------------------------------------
## ● 重置鼠标锁定
##--------------------------------------------------------------------------
func _notification(what):
	match what:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			mouse_move = true
			ban_mouse_move = true
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			mouse_move = false
##--------------------------------------------------------------------------
## ● 鼠标点击坐标
##--------------------------------------------------------------------------
const speed_max = 7.0  # 最大移动速度
func mouse_button_move(pos : Vector2i):
	var path : Array = []
	if MotaSystem.Player.allPass:
		# 设置玩家坐标实现瞬移
		mouse_teleport(pos)
		MotaSystem.Player.start_pos_event()
		return
	# 试图调用自动拾取的缓存直接抓出路径
	if auto_pick.has(pos) && auto_pick.has(MotaSystem.Player.tilePosition):
		if blink_move:
			mouse_teleport(pos)
			MotaSystem.Player.start_pos_event()
			MotaSystem.effectManager.showEffectOnNode(DatatableManager.Effect.data[113]["path"],self,Utility.tilePos2WorldPos(pos) + Vector2(Defination.tilesize/2,Defination.tilesize/2),5,Defination.UILayer.Game)
			# auto_pick = {}
			# 优化：移动至可以无损到达的地方不需要重新自动拾取，所以把这块注释掉
			return
		elif auto_pick[MotaSystem.Player.tilePosition][1] == null:
			# 当前坐标进行过自动拾取判定
			var next_pos : Vector2i = pos
			# 根据方向参数获取路径 不通过寻路公式 节约效率
			while next_pos != MotaSystem.Player.tilePosition:
				path.push_back(10 - auto_pick[next_pos][1])
				next_pos = MotaSystem.Player.checkFacePos((auto_pick[next_pos][1] / 2) - 1, next_pos)
	if path.is_empty():
		# 首先判断一下目标点的图块是否可通行 避免在无法通行的地方一直寻路 浪费开销
		if isMapPassable(pos):
			# 图块可通行 那么启动寻路公式
			path = FindMovePath.new(self, MotaSystem.Player.tilePosition, pos, ["player"]).path
		if path.is_empty():
			# 如果寻路失败 路径为空
			MotaSystem.effectManager.showEffectOnNode(DatatableManager.Effect.data[114]["path"],self,Utility.tilePos2WorldPos(pos) + Vector2(Defination.tilesize/2,Defination.tilesize/2),5,Defination.UILayer.Game)
			return
		# 动画播放
	MotaSystem.effectManager.showEffectOnNode(DatatableManager.Effect.data[113]["path"],self,Utility.tilePos2WorldPos(pos) + Vector2(Defination.tilesize/2,Defination.tilesize/2),5,Defination.UILayer.Game)
	# 确定路径 设置目标 加速移动
	MotaSystem.Player.mouse_target = pos
	MotaSystem.Player.speed = speed_max
	MotaSystem.Player.resetspeed = true
	if blink_move:
		# 单击瞬移
		var next_pos : Vector2i = pos
		var next_dir : int
		# 倒序加载行动路线 直至找到可直接瞬移的坐标点
		while next_pos != MotaSystem.Player.tilePosition && !path.is_empty():
			# 从正常路径的末尾中抽出朝向（移动栈是先抽最后的朝向 所以这里是抽出首位）
			next_dir = path.pop_front()
			MotaSystem.Player.MovingStack.data.append(next_dir)
			# 倒叙公式在获取下一个坐标点时 需要计算出相反的朝向
			next_pos = MotaSystem.Player.checkFacePos((abs(next_dir - 10) / 2) - 1, next_pos)
			# 自动拾取坐标缓存中有当前坐标 则直接瞬移
			if auto_pick.has(next_pos) && next_pos != MotaSystem.Player.tilePosition:
				# 设置玩家坐标实现瞬移
				mouse_teleport(next_pos)
				MotaSystem.Player.start_pos_event()
				break
	else:
		MotaSystem.Player.MovingStack.data = path.duplicate()
##--------------------------------------------------------------------------
## ● 鼠标瞬移（跟position区分开方便做改动）
##--------------------------------------------------------------------------
func mouse_teleport(pos : Vector2i):
	var dir
	var hold : bool = false
	var nodes = MotaSystem.gamePlayerManager.get_children()
	##----------------------------------------------------------------------
	## ● 为了兼顾稳定性以及兼容鼠标瞬移后的跟随者不重叠 更新一下自动拾取缓存
	##----------------------------------------------------------------------
	auto_pick = {}
	AutoPick()
	# 更新后在缓存中找不到这个坐标 那就是点到传送点了
	if !auto_pick.has(pos):
		MotaSystem.Player.setPosition(pos)
		# 反正是直接触发这个传送点 直接return就完事了
		return
	##----------------------------------------------------------------------
	## ● 缓存加载中
	##----------------------------------------------------------------------
	var follow_pos : Array = []
	var follow_dir : Array = []
	var follow_mov : Array = []
	##----------------------------------------------------------------------
	## ● 预先缓存跟随者坐标信息
	##----------------------------------------------------------------------
	if nodes.size() - 1 > step_max - auto_pick[pos][0]:
		for node in nodes:
			if node.name != "Player":
				follow_pos.append(node.tilePosition)
				follow_dir.append(node.dir)
				follow_mov.append(node.followMove)
	##----------------------------------------------------------------------
	## ● 根据自动拾取得出的方向数据写入跟随者的坐标信息与朝向
	##----------------------------------------------------------------------
	for node in nodes:
		node.setPosition(pos)
		##------------------------------------------------------------------
		## ● 更改跟随者坐标与朝向
		##------------------------------------------------------------------
		if hold:
			node.dir = follow_dir.pop_front()
			node.setPosition(follow_pos.pop_front())
			node.followMove = follow_mov.pop_front()
			continue
		elif auto_pick.has(pos) && auto_pick[pos][1] != null:
			node.dir = (abs(auto_pick[pos][1] - 10) / 2) - 1
			pos = MotaSystem.Player.checkFacePos((auto_pick[pos][1] / 2) - 1, pos)
		else:
			hold = true
		##------------------------------------------------------------------
		## ● 跟随者的下一次移动 复用前一个跟随者node的方向
		##------------------------------------------------------------------
		match dir:
			0:
				node.followMove = node.move_down.get_method()
			1:
				node.followMove = node.move_left.get_method()
			2:
				node.followMove = node.move_right.get_method()
			3:
				node.followMove = node.move_up.get_method()
			_:
				node.followMove = null
		dir = node.dir
##--------------------------------------------------------------------------
## ● 判断坐标点是否处于敌人技能范围内
##--------------------------------------------------------------------------
func isMonsterRange(pos : Vector2i, tag : Array = [] , ban_list : Array = []) -> bool:  # 该坐标是否存在地图伤害
	if !monster_range.has(pos) || !tag.is_empty():
		tag.append("get")
		if tag.size() > 1:
			return enemyReady.map_skill(pos, {}, tag, ban_list) == 0
		monster_range[pos] = enemyReady.map_skill(pos, {}, tag, ban_list) == 0
	return monster_range[pos]
##--------------------------------------------------------------------------
## ● 自动拾取相关队列
##--------------------------------------------------------------------------
var auto_pick       : Dictionary = {}    # 自动拾取 坐标点 参数
var auto_pick_floor : Array      = []    # 自动拾取 扩散坐标点 队列
var auto_pick_eat   : Array      = []    # 自动拾取 已触发事件 队列
var auto_pick_bat   : Array      = []    # 自动拾取 已触发战斗 队列

var monster_range   : Dictionary = {}    # 是否处于怪物地图技能范围内 缓存

const step_max      : int        = 128  # 自动拾取极限步数 防止扩散算法 扩散至屏幕外卡住
var auto_pickup     : bool       = true  # 自动拾取是否开启
var auto_battle     : bool       = true  # 自动清怪是否开启
var blink_move      : bool       = true  # 单击瞬移是否开启
##--------------------------------------------------------------------------
## ● 清理自动拾取相关缓存
##--------------------------------------------------------------------------
func clear_range_cache():
	auto_pick = {}
	monster_range = {}
##--------------------------------------------------------------------------
## ● 自动拾取
##--------------------------------------------------------------------------
func AutoPick(pos : Vector2i = MotaSystem.Player.tilePosition):  # 自动拾取
	# UFO模式下无法进行自动拾取
	if MotaSystem.Player.allPass:
		return
	# 关闭自动拾取时无法自动拾取
	auto_pickup = MotaSystem.config.getValue("Autopickup","autopickup")
	auto_battle = MotaSystem.config.getValue("Autoclearmonster","autoclearmonster")
	blink_move  = MotaSystem.config.getValue("Blink","blink")
	if !(auto_pickup || auto_battle || blink_move):
		return
	# 当前是否可以执行自动拾取
	if !can_auto_pick():
		return
	auto_pick       = {}
	auto_pick_eat   = []
	auto_pick_bat   = []
	auto_pick_floor = [[[pos.x,pos.y,null]],[]]
	var amax = step_max  # 自动拾取极限步数 防止扩散算法 扩散至屏幕外卡住
	var index
	# 扩散算法 循环开始
	while auto_pick_floor[0].size() > 0 && amax > 0:
		index = 0
		while index < auto_pick_floor[0].size():
			if spread(auto_pick_floor[0][index]):
				auto_pick[Vector2i(auto_pick_floor[0][index][0], auto_pick_floor[0][index][1])] = [amax,auto_pick_floor[0][index][2]]
			index += 1
		auto_pick_floor.remove_at(0)
		auto_pick_floor.append([])
		amax -= 1
	# 动画
	var event_id = 0
	var e
	auto_pick_eat.append_array(auto_pick_bat)
	while event_id < auto_pick_eat.size():
		e = auto_pick_eat[event_id]
		e.auto_pick = true
		e.startEvent()
		if auto_pick_eat.has(e):
			event_id += 1
##--------------------------------------------------------------------------
## ● 自动拾取 坐标点扩散算法
##--------------------------------------------------------------------------
func spread(arr : Array) -> bool:
	var pos = Vector2i(arr[0], arr[1])
	if isMapPassable(pos) && !auto_pick.has(pos) && pos.x >= 0 && pos.x < width && pos.y >= 0 && pos.y < height:
		if !pick_check(pos, arr[2] == null):
			if arr[2] == null:
				pick_check(Vector2i(pos.x, pos.y - 1))
				pick_check(Vector2i(pos.x, pos.y + 1))
				pick_check(Vector2i(pos.x + 1, pos.y))
				pick_check(Vector2i(pos.x - 1, pos.y))
			return false
		var facepos : Vector2i = Vector2i(pos.x, pos.y - 1)
		if !pick_has(facepos) && isMapUpPassable(pos) && isMapDownPassable(facepos):
			if isMonsterRange(pos) && isMonsterRange(facepos):
				auto_pick_floor[1].append([facepos.x, facepos.y, 2])
			else:
				pick_check(facepos)
		facepos = Vector2i(pos.x, pos.y + 1)
		if !pick_has(facepos) && isMapDownPassable(pos) && isMapUpPassable(facepos):
			if isMonsterRange(pos) && isMonsterRange(facepos):
				auto_pick_floor[1].append([facepos.x, facepos.y, 8])
			else:
				pick_check(facepos)
		facepos = Vector2i(pos.x + 1, pos.y)
		if !pick_has(facepos) && isMapRightPassable(pos) && isMapLeftPassable(facepos):
			if isMonsterRange(pos) && isMonsterRange(facepos):
				auto_pick_floor[1].append([facepos.x, facepos.y, 4])
			else:
				pick_check(facepos)
		facepos = Vector2i(pos.x - 1, pos.y)
		if !pick_has(facepos) && isMapLeftPassable(pos) && isMapRightPassable(facepos):
			if isMonsterRange(pos) && isMonsterRange(facepos):
				auto_pick_floor[1].append([facepos.x, facepos.y, 6])
			else:
				pick_check(facepos)
		return true
	return false
##--------------------------------------------------------------------------
## ● 检查怪物是否拥有无法被护盾完全抵消的debuff技能
## 检查技能：11(中毒)、12(衰弱)、13(迟缓)、14(诅咒)
## 如果玩家护盾不足以抵消debuff，返回true（表示不能自动清怪）
##--------------------------------------------------------------------------
func _has_dangerous_debuff(monster_event: MonsterEvent) -> bool:
	var debuff_skill_ids = [11, 12, 13, 14]  # 需要检查的debuff技能
	var player_shield = MotaSystem.gameData.mdef
	
	for skill_id in debuff_skill_ids:
		var skill_id_str = str(skill_id)
		# 如果怪物拥有该技能
		if monster_event.skill.has(skill_id_str):
			# 获取技能参数，格式如 "4/30"
			# 第一个值是debuff层数，第二个值是每层护盾阈值
			var skill_params = monster_event.skill[skill_id_str].split_floats("/")
			if skill_params.size() >= 2:
				var debuff_layers = int(skill_params[0])
				var shield_per_layer = skill_params[1]
				var total_shield_needed = debuff_layers * shield_per_layer
				# 如果玩家护盾小于总需求，无法完全抵消该debuff，返回true
				if player_shield < total_shield_needed:
					return true
	return false
##--------------------------------------------------------------------------
## ● 自动拾取 坐标点是否在待扩散队列内
##--------------------------------------------------------------------------
func pick_has(pos:Vector2i):
	for i in auto_pick_floor[1]:
		if i[0] == pos.x && i[1] == pos.y:
			return true
	return false
##--------------------------------------------------------------------------
## ● 自动拾取 坐标点扩散后 可拾取的事件检测
##--------------------------------------------------------------------------
func pick_check(pos : Vector2i, is_base_pos : bool = false) -> bool:
	var passable = true
	var temp_eat = []
	var temp_bat = []
	if EventGrid.has(pos):
		for e in EventGrid[pos]:
			if e.current_page is TrapEvent:
				if e.current_page.damage > 0:
					passable = false
			elif e.current_page is MonsterEvent:
				if e.current_page.battle.result == GameBattle.battlResult.win && e.current_page.battle.damage <= 0 && auto_battle && !_has_dangerous_debuff(e.current_page):
					passable = false
					if !auto_pick_bat.has(e):
						temp_bat.append(e)
				else:
					return false
			elif (e.current_page is TeleportTowerEvent || e.current_page is TeleportEvent) && !is_base_pos:
				return false
			elif !(((e.current_page is ComsumableEvent || e.current_page is ItemEvent) && auto_pickup) || e.current_page is TeleportEvent || e.current_page is TeleportTowerEvent):
				return false
			elif !(e.current_page is TeleportTowerEvent || e.current_page is TeleportEvent):
				if !auto_pick_eat.has(e):
					temp_eat.append(e)
	auto_pick_eat.append_array(temp_eat)
	auto_pick_bat.append_array(temp_bat)
	return passable
##--------------------------------------------------------------------------
## ● 当前是否可以执行自动拾取
##--------------------------------------------------------------------------
func can_auto_pick() -> bool:
	return !MotaSystem.gameEventManager.hasAnyRunningEvent() && (auto_pick.size() == 0 || (auto_pick.size() == 1 && auto_pick.keys()[0] != MotaSystem.Player.tilePosition))
##--------------------------------------------------------------------------
## ● 飞点显示组件变量
##--------------------------------------------------------------------------
var   FlyPointPrefab      : Control
const FlyPointPrefab_path : String  = "res://Scene/UI/UIModule/ShowFlyPoint.tscn"
##--------------------------------------------------------------------------
## ● 检测是否可飞
##--------------------------------------------------------------------------
func can_fly(point : Vector2i = fly_point()):
	return isPassable(point) && checkEvent(point).is_empty()
##--------------------------------------------------------------------------
## ● 飞点显示预制件
##--------------------------------------------------------------------------
func ShowFlyPointForMap():
	# 检测是否存在，存在则先清除掉
	if MotaSystem.gameVariables["showFlyPoint"] == true:
		if FlyPointPrefab == null:
			FlyPointPrefab = MotaSystem.resourceManager.loadFile(FlyPointPrefab_path).instantiate()
			self.add_child(FlyPointPrefab)
		FlyPointPrefab.initialize([fly_point(), can_fly()])
		FlyPointPrefab.name = "MapFlyPoint"
	elif FlyPointPrefab != null:
		FlyPointPrefab.free()
##--------------------------------------------------------------------------
## ● 地图伤害预警
##--------------------------------------------------------------------------
var   damage_point : Dictionary = {}
var   clear_point  : Array      = []
const range_path   : String     = "res://Scene/UI/UIModule/ShowRangePoint.tscn"
const show_range   : int        = 2  # 红框显示的范围
##--------------------------------------------------------------------------
## ● 预警刷新
##--------------------------------------------------------------------------
func show_damage_point(clear : bool = false):
	var i    : int
	var vec  : Vector2i
	var twen : Tween
	var temp : Variant
	var keys : Array = damage_point.keys().duplicate()
	# 预览的时候不显示
	if MotaSystem.Player == null:
		return
	if !clear && !MotaSystem.Player.allPass:
		for xy in range(0, ((show_range * 2) + 1) * ((show_range * 2) + 1)):
			vec = Vector2i((MotaSystem.Player.tilePosition.x - show_range) + fmod(xy, (show_range * 2) + 1) , (MotaSystem.Player.tilePosition.y - show_range) + (xy / ((show_range * 2) + 1)))
			keys.erase(vec)
			if isMapPassable(vec) && !isMonsterRange(vec):
				if !damage_point.has(vec):
					if clear_point.is_empty():
						temp = MotaSystem.resourceManager.loadFile(range_path).instantiate()
						self.add_child(temp)
					else:
						temp = clear_point.pop_front()
					damage_point[vec] = temp
					temp.position = vec * Defination.tilesize
					temp.name = "P{0}-{1}".format([vec.x,vec.y])
					twen = get_tree().create_tween()
					twen.tween_property(temp.texture , "modulate" , Color(temp.texture.modulate, 0.8) , 0.25)
			elif damage_point.has(vec):
				damage_point[vec].clear()
				clear_point.append(damage_point[vec])
				damage_point.erase(vec)
	i = 0
	while i < keys.size():
		damage_point[keys[i]].clear()
		clear_point.append(damage_point[keys[i]])
		damage_point.erase(keys[i])
		i += 1
