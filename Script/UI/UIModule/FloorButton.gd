extends CommonSelectButton

var form:TeleportForm

@export var label:Label

@export var consumable:TextureRect

@export var monster:TextureRect

func initialize(form:TeleportForm):
	self.form = form

func refresh(id:int):
	# 显示楼层资源
	if MotaSystem.config.getValue("FloorResourceDisplay","floorresourcedisplay"):
		text = ""
		label.text = tr("{0}层").format([DatatableManager.Map.data[id].floorId])
		label.visible = true
		consumable.visible = true
		monster.visible = true
		if MotaSystem.mapManager.get_mapdata(id, "alive_enemy", 0) > 0:
			monster.modulate = Color(1,1,1,1)
		else:
			monster.modulate = Color(1,1,1,0.4)
		if MotaSystem.mapManager.get_mapdata(id, "alive_ruby", 0) > 0:
			consumable.modulate = Color(1,1,1,1)
		else:
			consumable.modulate = Color(1,1,1,0.4)
	else:
		text = tr("{0}层").format([DatatableManager.Map.data[id].floorId])
		label.visible = false
		consumable.visible = false
		monster.visible = false

	if focus_entered.is_connected(onBtnFocused):
		focus_entered.disconnect(onBtnFocused)
	focus_entered.connect(onBtnFocused.bind(id))
	if pressed.is_connected(onBtnClick):
		pressed.disconnect(onBtnClick)
	pressed.connect(onBtnClick.bind(id))

func onBtnFocused(id:int):
	form.ShowFloor(id)

func onBtnClick(id:int):
	form.close()
	gotoMap.call_deferred(id)

func gotoMap(id:int):
	MotaSystem.gameVariables["teleport"] = false
	if !MotaSystem.gameVariables["ufo"]:
		MotaSystem.Player.allPass = false
	MotaSystem.gamePlayerManager.visible = true
	# 同魔塔编号时按楼层编号决定在上楼口还是下楼口
	# 变量是主角实际所在id， currentMap.key是当前预览id
	var isDown = false
	if DatatableManager.Map.data[MotaSystem.gameVariables["mapId"]].towerId != DatatableManager.Map.data[id].towerId:
		isDown = true
	else:
		if DatatableManager.Map.data[MotaSystem.gameVariables["mapId"]].floorId > DatatableManager.Map.data[id].floorId:
			isDown = false
		elif DatatableManager.Map.data[MotaSystem.gameVariables["mapId"]].floorId == DatatableManager.Map.data[id].floorId:
			if DatatableManager.Map.data[id].floorId < 0:
				isDown = false
			else:
				isDown = true
		else:
			isDown = true
	# 目标坐标
	var targetPosition:Vector2i
	var targetMap = MotaSystem.mapManager.load_map(id)
	for event in targetMap.get_node("Events").get_children():
		for page in event.get_children():
			if page is TeleportTowerEvent: #只检测上下楼事件
				if !isDown:
					# 上楼口
					if !page.isDownFloor:
						targetPosition = Utility.worldPos2TilePos(event.position)
						break
				else:
					# 下楼口
					if page.isDownFloor:
						targetPosition = Utility.worldPos2TilePos(event.position)
						break
	# 为了防止机关门无法自动开，暴力再过一遍
	for event:GameEvent in targetMap.events.get_children():
		if event.get_child(0).trigger == 3 || (event.current_page && event.current_page.trigger == 3): #Process
			event.onEnter()
	# 补上OnEnter2
	targetMap.set_mapid()
	if MotaSystem.config.getValue("Teleportbgm","teleportbgm"):
		targetMap.play_map_bgm()
	MotaSystem.gameManager.transferPlayer(id, targetPosition, Defination.direction.down, false)
	AudioManager.playSE("RPG3_UI_PositiveNotificationv2.wav")
