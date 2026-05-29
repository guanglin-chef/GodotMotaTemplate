##==============================================================================
## ■ MapManager
##------------------------------------------------------------------------------
## 地图管理器
##==============================================================================
class_name MapManager extends Node2D
##--------------------------------------------------------------------------
## ● 一些系统开关
##--------------------------------------------------------------------------
var old_key                          # 地图切换时记录的前一张地图ID
var mapData       : Dictionary = {}  # 存档中的地图数据
var m_Maps        : Dictionary       # 当前所有地图实例缓存
var preview_cache : Dictionary = {}  # 楼传时抓拍的缓存截图
##--------------------------------------------------------------------------
## ● 部分系统参数
##--------------------------------------------------------------------------
var duration      : float = 0.2    # 淡入淡出时间
var changingMap   : bool  = false  # 地图传送硬直
var flytoflooring : bool  = false  # 当前是否为楼层传送（不知道是干嘛的，明明有MotaSystem.gameVariables["teleport"]）
var preview       : bool  :        # 当前是否处于地图预览中或楼层传送中
	get:
		return MotaSystem.gameVariables["ufo"] || MotaSystem.gameVariables["teleport"]
##--------------------------------------------------------------------------
## ● 场景指向
##--------------------------------------------------------------------------
var m_CurrentMap       : GameMap                                # 当前地图
@onready var whiteMask : ColorRect = $TopCanvasLayer/WhiteMask  # 白屏幕布
@onready var camera                = $Camera                    # 卷动用相机
##--------------------------------------------------------------------------
## ● 初始化
##--------------------------------------------------------------------------
func Initialize(save):
	y_sort_enabled = true
	# 地图保存在m_Maps变量中，用到了再加入场景树
	m_Maps = {}
	# 根据传参传进来的数据来判断 读档还是新游戏
	if save == null:
		# 新游戏的初始化
		enableMap(GameFirstData.startMapId)
	else:
		# 读档后进行的初始化
		mapData = save
		# 读取档案资源
		enableMap(mapData.playerData.Player.mapKey)
		# 调用存档中的地图色调
		if mapData.has("map_modulate"):
			self.modulate = Color(mapData.map_modulate)
	# 初始化卷动用相机
	camera.limit_right =  int(m_CurrentMap.width * Defination.tilesize) - 1
	camera.limit_bottom = int(m_CurrentMap.height * Defination.tilesize) - 1
##--------------------------------------------------------------------------
## ● 地图资源实例化加载并进入缓存 （加载地图内节点需要让地图进入场景树）
##--------------------------------------------------------------------------
func load_map(key : int):
	# 若是资源已有缓存就返回缓存
	if m_Maps.has(key):
		return m_Maps[key]
	# 未缓存 从资源管理器中加载
	if !MotaSystem.resourceManager.mapRes.has(key):
		MotaSystem.resourceManager.loadMap(key)
	# 加载进缓存中的地图需要先进行实例化
	var map = MotaSystem.resourceManager.mapRes[key].instantiate()
	map.key = key
	# 初始化地图场景
	var keyT = str(key)
	if !mapData.is_empty():
		# 如果存档数据中有该地图ID的数据
		if mapData.mapData.has(keyT):
			# 则根据存档数据初始化地图场景
			map.initMap(mapData.mapData[keyT])
	# 实例化和初始化已分别完成 将地图实例载入缓存
	m_Maps[key] = map
	return m_Maps[key]
##--------------------------------------------------------------------------
## ● 预加载地图场景 用于地图无缓存时调用其节点的场合
##--------------------------------------------------------------------------
func pre_load_map(key : int):
	var map = load_map(key)
	# 为null时代表缓存未经过预加载 无法调用其节点
	if map.events == null:
		# 为此时需要让实例地图场景进出一次场景才能完成预加载
		add_child(map)
		remove_child(map)
		m_CurrentMap.EventGrid = {}
	return map
##--------------------------------------------------------------------------
## ● 当前地图管理器器即将被free，注销缓存中的地图
##--------------------------------------------------------------------------
func dispose():
	for m in m_Maps.values():
		m.queue_free()
# 这项等删
func flytofloorend():
	await get_tree().create_timer(0.16).timeout
	flytoflooring = false
##--------------------------------------------------------------------------
## ● 地图进入场景树前的处理
##--------------------------------------------------------------------------
func getIntoMap(mapKey:int, fade:bool = true):
	var map = load_map(mapKey)
	# 记录来过的地图
	if !MotaSystem.gameVariables["ufo"]:
		var towerId = str(DatatableManager.Map.data[mapKey].towerId)
		var key = str(mapKey)
		floor_record([key])
	# 重置玩家速度
	if MotaSystem.Player.resetspeed:
		MotaSystem.Player.speed = MotaSystem.config.getValue("Playerspeed","speed")
		MotaSystem.Player.resetspeed = false
		MotaSystem.Player.MovingStack.clear()
	# 根据地图大小更改摄像机
	MotaSystem.Player.get_node("Camera2D").changeMapUpdateCamera(map.width, map.height)
	# 卷动摄像机同理.
	camera.limit_right = map.width * Defination.tilesize - 1
	camera.limit_bottom = map.height * Defination.tilesize - 1
	# 淡入淡出
	if fade && !preview:
		enableMap(mapKey)
		var tempModulate:Color = map.modulate
		map.modulate = Color(tempModulate.r,tempModulate.g,tempModulate.b,0)
		var tween = create_tween()
		tween.tween_property(map, "modulate", Color(tempModulate.r,tempModulate.g,tempModulate.b,1), duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(duration).timeout
	else:
		enableMap(mapKey)
	changingMap = false
##--------------------------------------------------------------------------
## ● 地图进入前台 将地图实例加入场景树
##--------------------------------------------------------------------------
func enableMap(mapKey:int):
	var map = load_map(mapKey)
	
	if $BackgroundCanvasLayer/BackgroundNode.get_child_count() > 0:
		$BackgroundCanvasLayer/BackgroundNode.get_child(0).free()
	# 添加非跟随式背景预制
	if DatatableManager.Map.data[mapKey]["backgroundPrefabPath"] != "":
		var bg = MotaSystem.resourceManager.loadFile(DatatableManager.Map.data[mapKey]["backgroundPrefabPath"]).instantiate()
		$BackgroundCanvasLayer/BackgroundNode.add_child(bg)
	
	camera.add_sibling(map)
	
	m_CurrentMap = map
	if MotaSystem.Player == null || !MotaSystem.Player.allPass:
		old_key = map.key
	map.onEnterMap()
##--------------------------------------------------------------------------
## ● 地图离开场景树前的处理
##--------------------------------------------------------------------------
func getOutofMap(mapKey:int, fade:bool = true):
	var map = load_map(mapKey)
	if fade && !preview:
		# 临时建一个sprite2D当做截图容器
		var texture = get_image()
		var temp = TextureRect.new()
		temp.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		temp.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		temp.position = Vector2i(0,0)
		temp.size = Vector2i(1600,960)
		get_node("TopCanvasLayer").add_child(temp)
		# 放入截图后再disableMap
		temp.texture = texture
		disableMap(mapKey)
		# 创建淡出动画
		var tempModulate:Color = map.modulate
		var tween = create_tween()
		tween.tween_property(temp, "modulate", Color(tempModulate.r,tempModulate.g,tempModulate.b,0), duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_callback(func():
			temp.queue_free()
		)
	else:
		disableMap(mapKey)
##--------------------------------------------------------------------------
## ● 获取地图当前定格画面
##--------------------------------------------------------------------------
func get_image():
	return ImageTexture.create_from_image(get_viewport().get_texture().get_image())
##--------------------------------------------------------------------------
## ● 定格当前画面 并返回显示当前画面的Node对象
##--------------------------------------------------------------------------
func get_texture_node(delta = 0.2):
	var texture = get_image()
	var temp = TextureRect.new()
	temp.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	temp.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	temp.position = Vector2i(0,0)
	temp.size = Vector2i(1600,960)
	MotaSystem.gameManager.root.get_node("Canvas").add_child(temp)
	temp.texture = texture
	var tween = create_tween()
	tween.tween_callback(func():
		temp.queue_free()
	).set_delay(delta)
	return temp
##--------------------------------------------------------------------------
## ● 地图退入后台 将地图实例加入场景树
##--------------------------------------------------------------------------
func disableMap(mapKey:int):
	if m_Maps.has(mapKey):
		var map = load_map(mapKey)
		# 刷新状态栏
		MotaSystem.gameForm.RefreshUI()
		# 将地图移出场景树
		remove_child(map)
		# 进入新地图后将鼠标移动锁定 首次点击后解锁 防止鼠标移动误触
		map.mouse_move = false
##--------------------------------------------------------------------------
## ● 切换地图
##--------------------------------------------------------------------------
func changeMap(mapKey:int, fade = true):
	var refreshstate = false
	# 原地TP 且 无渐变的情况下 不需要执行地图进出场景树
	if m_CurrentMap.key != mapKey || fade:
		self.getOutofMap(m_CurrentMap.key,fade)
		self.getIntoMap(mapKey,fade)
	# 刷新State的状态栏
	if refreshstate:
		MotaSystem.gameForm.createStateButtons()
##--------------------------------------------------------------------------
## ● 将楼层记录进楼层传送器里
##--------------------------------------------------------------------------
func floor_record(id : Array):
	for mapid in id:
		var towerId = str(DatatableManager.Map.data[int(mapid)].towerId)
		if !MotaSystem.gameVariables["floorRecord"].has(towerId):
			MotaSystem.gameVariables["floorRecord"][towerId] = []
		if !MotaSystem.gameVariables["floorRecord"][towerId].has(mapid):
			# 保证按照楼层编号顺序排列
			var insert = false
			for i in range(0,MotaSystem.gameVariables["floorRecord"][towerId].size()):
				if DatatableManager.Map.data[int(MotaSystem.gameVariables["floorRecord"][towerId][i])].floorId > DatatableManager.Map.data[int(mapid)].floorId:
					MotaSystem.gameVariables["floorRecord"][towerId].insert(i,mapid)
					insert = true
					break
			if !insert:
				MotaSystem.gameVariables["floorRecord"][towerId].append(mapid)
##--------------------------------------------------------------------------
## ● 将指定楼层从楼传记录中删除
##--------------------------------------------------------------------------
func floor_erase(id :Array):
	for mapid in id:
		var towerId = str(DatatableManager.Map.data[int(mapid)].towerId)
		if MotaSystem.gameVariables["floorRecord"].has(towerId):
			MotaSystem.gameVariables["floorRecord"][towerId].erase(mapid)
##--------------------------------------------------------------------------
## ● 将数组内的所有楼层备份并从楼层传送中暂时移除
##--------------------------------------------------------------------------
func floor_backup(key : String, id :Array):
	var hide_floor : Array = []
	for mapid in id:
		var towerId = str(DatatableManager.Map.data[int(mapid)].towerId)
		if MotaSystem.gameVariables["floorRecord"].has(towerId):
			MotaSystem.gameVariables["floorRecord"][towerId].erase(mapid)
			hide_floor.append(mapid)
	MotaSystem.gameVariables["floorBackup"][key] = hide_floor
##--------------------------------------------------------------------------
## ● 将指定楼层从楼传记录中删除
##--------------------------------------------------------------------------
func floor_restore(key : String):
	if MotaSystem.gameVariables["floorBackup"].has(key):
		floor_record(MotaSystem.gameVariables["floorBackup"][key])
		MotaSystem.gameVariables["floorBackup"].erase(key)
##--------------------------------------------------------------------------
## ● 进入新章节 释放地图数据 删除楼传记录
## **输入的参数是你将要到达的章节id而非想要清除的章节id！
##--------------------------------------------------------------------------
func next_chapter_end(id : int):
	clear_tower_data(id, true, false)
	var towerid : int = 0
	var mapid   : int = 0
	while towerid < MotaSystem.gameVariables["floorRecord"].size():
		mapid = 0
		var key   = MotaSystem.gameVariables["floorRecord"].keys()[towerid]
		var value = MotaSystem.gameVariables["floorRecord"][key]
		while mapid < value.size():
			if DatatableManager.Map.data[int(value[mapid])].chapterId != id:
				value.remove_at(mapid)
			else:
				mapid += 1
		if value.is_empty():
			MotaSystem.gameVariables["floorRecord"].erase(key)
		else:
			towerid += 1
	MotaSystem.gameVariables["chapterId"] = id
##--------------------------------------------------------------------------
## ● 按章节或副本释放地图数据 缩减存档大小
##--------------------------------------------------------------------------
func clear_tower_data(id : int , is_chapter : bool = false, id_equal : bool = true):
	var i     : int = 0
	var mapid : int = 0
	# 首先确认是否有存档数据
	if mapData.has("mapData"):
		# 遍历当前存档中所有记录了数据的地图
		while i < mapData["mapData"].size():
			mapid = int(mapData["mapData"].keys()[i])
			if is_chapter:
				# 根据章节来释放地图数据
				if (DatatableManager.Map.data[mapid].chapterId == id) == id_equal:
					# 移除该地图的存档数据
					mapData["mapData"].erase(str(mapid))
					continue
			else:
				# 根据副本来释放地图数据
				if (DatatableManager.Map.data[mapid].towerId == id) == id_equal:
					# 移除该地图的存档数据
					mapData["mapData"].erase(str(mapid))
					continue
			i += 1
		i = 0
	# 再注销所有符合条件的 已缓存的 地图实例
	while i < m_Maps.size():
		mapid = m_Maps.keys()[i]
		if is_chapter:
			# 根据章节来释放地图数据
			if (DatatableManager.Map.data[mapid].chapterId == id) == id_equal:
				# 如果就是当前地图 则放过
				if m_CurrentMap.key != mapid:
					# 释放该地图的缓存
					m_Maps[mapid].queue_free()
					m_Maps.erase(mapid)
		else:
			# 根据副本来释放地图数据
			if (DatatableManager.Map.data[mapid].towerId == id) == id_equal:
				# 如果就是当前地图 则放过
				if m_CurrentMap.key != mapid:
					# 释放该地图的缓存
					m_Maps[mapid].queue_free()
					m_Maps.erase(mapid)
		i += 1
##--------------------------------------------------------------------------
## ● 释放单张地图的地图数据 缩减存档大小
##--------------------------------------------------------------------------
func clear_map_data(mapid : int):
	# 移除该地图的存档数据
	if mapData.has("mapData"):
		mapData["mapData"].erase(str(mapid))
	# 释放该地图的缓存
	m_Maps[mapid].queue_free()
	m_Maps.erase(mapid)
	# 如果就是当前地图 则重新加载一次地图
	if m_CurrentMap == m_Maps[mapid]:
		# 重置地图
		changeMap(mapid, false)
##--------------------------------------------------------------------------
## ● 获取地图缓存中的某项数据
##--------------------------------------------------------------------------
func get_mapdata(mapid, key, null_value):
	# 如果该地图处于缓存内
	if m_Maps.has(mapid) && m_Maps[mapid].data.has(key):
		# 如果该地图在缓存里 没有进行过预加载
		if m_Maps[mapid].events == null:
			# 进行预加载
			pre_load_map(mapid)
		# 输出缓存中的数据
		return m_Maps[mapid].data[key]
	mapid = str(mapid)
	# 如果存档数据中记录下了该地图的数据
	if mapData.has("mapData") && mapData["mapData"].has(mapid) && mapData["mapData"][mapid].has(key):
		# 输出存档中的地图数据
		return mapData["mapData"][mapid][key]
	# 如果地图不在缓存内也没有数据的情况下 即完全没有进入过该地图
	return null_value
