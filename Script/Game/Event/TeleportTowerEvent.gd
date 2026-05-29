class_name TeleportTowerEvent extends EventPage

## 是否下楼
@export var isDownFloor:bool

## 是否无效化
@export var active:bool = true

func start():
	if active:
		MotaSystem.mapManager.changingMap = true
		AudioManager.playSE("Junkomory Transition 08-1.ogg")
		
		var currentdr = DatatableManager.Map.data[MotaSystem.CurrentMap.key]
		if currentdr.tower == false:
			printerr("非楼传类无法使用上下楼传送事件，请使用TeleportEvent")
			return
		var targetFloor = currentdr.floorId
		if isDownFloor:
			targetFloor = currentdr.floorId - 1
		else:
			targetFloor = currentdr.floorId + 1
		# 目标地图id
		var targetMapId = Utility.select(DatatableManager.Map.data,
		func (datarow) -> bool:
			return datarow.towerId == currentdr.towerId && datarow.floorId == targetFloor
		)[0].id
		# 目标坐标
		var targetPosition:Vector2i
		var targetMap = MotaSystem.mapManager.load_map(targetMapId)
		for event in targetMap.get_node("Events").get_children():
			for page in event.get_children():
				if page is TeleportTowerEvent: #只检测上下楼事件
					if (isDownFloor && !page.isDownFloor) || (!isDownFloor && page.isDownFloor):
						targetPosition = Utility.worldPos2TilePos(event.position)
						break
		MotaSystem.Player.setIdle(MotaSystem.gameManager.transferPlayer.bind(targetMapId,targetPosition,4))
		MotaSystem.Player.MovingStack.clear()
		# 完成后处理
		super()
