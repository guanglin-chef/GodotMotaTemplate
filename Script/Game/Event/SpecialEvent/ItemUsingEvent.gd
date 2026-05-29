extends EventPage

# ItemUsingEvent
# 道具使用事件，由于需要在很多地方的代码中调用因此设置为特别事件 
# 各种道具使用的实现都来这里！

func start():
	# 主要逻辑
	var id = MotaSystem.gameVariables["specialEventParam"]
	var dr = DatatableManager.Item.data[id]
	if dr.itemUseAvaliable == 0:
		await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm,tr("该道具无法使用！"))
	else:
		await ItemUsing(id)
	# 完成后处理
	super()

# 道具使用
# 各种道具使用的实现都来这里！
func ItemUsing(id:int):
	if MotaSystem.mapManager.preview:
		await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm,tr("当前状态无法使用道具"))
		return
	var can_use = true
	#道具提升效果
	var hint
	if id == 5:  # 破墙镐
		if MotaSystem.CurrentMap.change_tile("break",MotaSystem.Player.checkFacePos(MotaSystem.Player.dir)):
			if !MotaSystem.CurrentMap.data.has("changetile"):
				MotaSystem.CurrentMap.data["changetile"] = []
			MotaSystem.CurrentMap.data["changetile"].append({"break" : MotaSystem.Player.checkFacePos(MotaSystem.Player.dir)})
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Rock Impact.wav")
		else:
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			hint = tr("眼前没有障碍或是眼前障碍无法被破除！")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm,hint)
			return
	if id == 6: # 中心对飞
		MotaSystem.gameVariables["showFlyPoint"] = false
		MotaSystem.CurrentMap.ShowFlyPointForMap()
		var point = MotaSystem.CurrentMap.fly_point()
		if MotaSystem.CurrentMap.can_fly(point):
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			MotaSystem.effectManager.showEffectOnNode(DatatableManager.Effect.data[104]["path"], MotaSystem.Player, Vector2(Defination.tilesize/2,Defination.tilesize/2), 100)
			await wait(0.6)
			MotaSystem.Player.teleport_position(point)
		else:
			MotaSystem.gameVariables["showFlyPoint"] = true
			MotaSystem.CurrentMap.ShowFlyPointForMap()
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			hint = tr("中心对称点不属于空地！")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm,hint)
			return
	if id == 10: # 上楼器
		# 检查当前楼层否是隐藏层，是则无法使用
		var currentdr = DatatableManager.Map.data[MotaSystem.CurrentMap.key]
		if !currentdr.tower:
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("当前地图无法使用上楼器！"))
			return
		# 检查当前楼层+1是否存在，否则无法使用
		var targetFloor = currentdr.floorId + 1
		var floorMatches = Utility.select(DatatableManager.Map.data, func(dr) -> bool:
			return dr.floorId == targetFloor
		)
		if floorMatches.is_empty():
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("找不到上层楼层，无法上楼！"))
			return
		# 检查楼层+1所属towerid是否与当前楼层一致，否则无法使用
		var towerMatches = floorMatches.filter(func(dr): return dr.towerId == currentdr.towerId)
		if towerMatches.is_empty():
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("没有上一层，无法传送！"))
			return
		# 检查楼层+1所属chapterid是否与当前楼层一致，否则无法跨章节传送
		var targetMaps = towerMatches.filter(func(dr): return dr.chapterId == currentdr.chapterId)
		if targetMaps.is_empty():
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("无法跨章节传送！"))
			return
		# 前几步通过，获取对应地图信息和上下楼梯信息
		var targetMapId = targetMaps[0].id
		var targetMap = MotaSystem.mapManager.load_map(targetMapId)
		var hasTeleportEvent = false
		var targetPosition = Vector2i(-1, -1)
		for event in targetMap.get_node("Events").get_children():
			for page in event.get_children():
				if page is TeleportTowerEvent:
					hasTeleportEvent = true
					if page.isDownFloor:
						targetPosition = Utility.worldPos2TilePos(event.position)
						break
			if targetPosition != Vector2i(-1, -1):
				break
		# 检查是否存在上下楼梯，不存在则无法使用
		if !hasTeleportEvent:
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("目标楼层没有楼梯事件，无法传送！"))
			return
		# 检查是否存在下楼梯，不存在则无法使用
		if targetPosition == Vector2i(-1, -1):
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("目标楼层没有下楼事件，上楼器无法传送！"))
			return
		MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
		AudioManager.playSE("Junkomory Transition 08-1.ogg")
		MotaSystem.mapManager.changingMap = true
		MotaSystem.Player.setIdle(MotaSystem.gameManager.transferPlayer.bind(targetMapId, targetPosition, 4))
		MotaSystem.Player.MovingStack.clear()
	if id == 11: # 下楼器
		# 检查当前楼层否是隐藏层，是则无法使用
		var currentdr = DatatableManager.Map.data[MotaSystem.CurrentMap.key]
		if !currentdr.tower:
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("当前地图无法使用下楼器！"))
			return
		# 检查当前楼层-1是否存在，否则无法使用
		var targetFloor = currentdr.floorId - 1
		var floorMatches = Utility.select(DatatableManager.Map.data, func(dr) -> bool:
			return dr.floorId == targetFloor
		)
		if floorMatches.is_empty():
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("找不到下层楼层，无法下楼！"))
			return
		# 检查楼层-1所属towerid是否与当前楼层一致，否则无法使用
		var towerMatches = floorMatches.filter(func(dr): return dr.towerId == currentdr.towerId)
		if towerMatches.is_empty():
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("没有下一层，无法传送！"))
			return
		# 检查楼层-1所属chapterid是否与当前楼层一致，否则无法跨章节传送
		var targetMaps = towerMatches.filter(func(dr): return dr.chapterId == currentdr.chapterId)
		if targetMaps.is_empty():
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("无法跨章节传送！"))
			return
		# 前几步通过，获取对应地图信息和上下楼梯信息
		var targetMapId = targetMaps[0].id
		var targetMap = MotaSystem.mapManager.load_map(targetMapId)
		var hasTeleportEvent = false
		var targetPosition = Vector2i(-1, -1)
		for event in targetMap.get_node("Events").get_children():
			for page in event.get_children():
				if page is TeleportTowerEvent:
					hasTeleportEvent = true
					if !page.isDownFloor:
						targetPosition = Utility.worldPos2TilePos(event.position)
						break
			if targetPosition != Vector2i(-1, -1):
				break
		# 检查是否存在上下楼梯，不存在则无法使用
		if !hasTeleportEvent:
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("目标楼层没有楼梯事件，无法传送！"))
			return
		# 检查是否存在上楼梯，不存在则无法使用
		if targetPosition == Vector2i(-1, -1):
			MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
			AudioManager.playSE("Negative 10-1.wav")
			await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm, tr("目标楼层没有上楼事件，下楼器无法传送！"))
			return
		MotaSystem.uiManager.remove(Defination.UIID.ItemEquipForm)
		AudioManager.playSE("Junkomory Transition 08-1.ogg")
		MotaSystem.mapManager.changingMap = true
		MotaSystem.Player.setIdle(MotaSystem.gameManager.transferPlayer.bind(targetMapId, targetPosition, 4))
		MotaSystem.Player.MovingStack.clear()
	# 消耗道具
	if DatatableManager.Item.data[id].itemConsume and can_use == true:
		MotaSystem.gameData.addItem(id,-1)
	if hint != null:
		await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm,hint)
