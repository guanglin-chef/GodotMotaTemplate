extends EventPage

# ChapterEndEvent
# 过版本事件

func start():
	await showTextP(tr("即将进入新的未知领域，失去所有消耗类道具、金钱。\n生命值归为1，攻防自动平均分配。\n丢弃所有低级装备。"))
	
	# 根据当前地图的章节判断当前章节id
	var chapter = DatatableManager.Map.data[MotaSystem.CurrentMap.key].chapterId
	# 干掉商店
	MotaSystem.gameVariables["shopOpen"] = false
	# 干掉楼传记录
	MotaSystem.mapManager.next_chapter_end(chapter+1)
	# 攻防处理
	var a = MotaSystem.gameData.base_atk
	var b = MotaSystem.gameData.base_def
	MotaSystem.gameData.base_atk = (a + b) / 2
	MotaSystem.gameData.base_def = (a + b) / 2
	MotaSystem.gameData.hp = 1
	# 先扫光所有常用装备道具
	MotaSystem.gameData.gold = 0
	for key in MotaSystem.gameData.equip:
		MotaSystem.gameData.equip[key] = null
	for key in MotaSystem.gameData.equip_pool.duplicate():
		MotaSystem.gameData.addEquip_pool(key,-999)
	MotaSystem.gameData.addItem(1,-999)
	MotaSystem.gameData.addItem(2,-999)
	MotaSystem.gameData.addItem(3,-999)
	MotaSystem.gameData.addItem(5,-999)
	MotaSystem.gameData.addItem(6,-999)
	# 再确定哪些需要（分章节）
	if chapter == 1:
		# 示例
		MotaSystem.gameData.updateEquip(MotaSystem.gameData.equip_slot[0],1)
	# 完成章节完成记录（标准模式才算通关）
	if MotaSystem.gameVariables["gameMode"] == true:
		MotaSystem.config.setValue(GameFirstData.gameIdentifier,"Chapter" + str(chapter),true)
	
	# 完成后处理
	super()
