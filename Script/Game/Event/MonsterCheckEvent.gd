##==============================================================================
## ■ MonsterCheckEvent
##------------------------------------------------------------------------------
## 怪物检测事件
##==============================================================================
class_name MonsterCheckEvent extends EventPage
## 所有进入检测的地图id
@export var checkMapIds:Array[int]
## 所有豁免事件 键为被赦免者所在的地图ID 值为豁免怪物的事件名或装有豁免怪物事件名的数组
@export var PassEventIds:Dictionary
##--------------------------------------------------------------------------
## ● 执行
##--------------------------------------------------------------------------
func start():
	await showTextP(tr("这里是清怪检测，你可以在这里查看先前是否有遗漏怪物。"))
	var textDic = {}
	textDic["name"] = ""
	textDic["backGround"] = true
	textDic["textPos"] = "Down"
	textDic["text"] = tr("要开始查询吗？")
	var choiceText = [
		tr("是"),
		tr("否")
	]
	var result = await MotaSystem.uiManager.openTillReturn(Defination.UIID.ChoiceForm,[textDic,choiceText,true])
	# 弹出UI
	if result == 0:
		await showTextP(tr("请稍候，查询可能耗费几秒的时间。"))
		if check():
			await showTextP(tr("当前尚有遗漏怪物，请根据楼层资源显示自行寻找。"))
		else:
			# 没有漏怪 放行 该事件消失
			await showTextP(tr("当前没有遗漏怪物，请继续前进吧。"))
			# 完成后处理
			super()
	
##--------------------------------------------------------------------------
## ● 开始漏怪检测 遍历所有地图
##--------------------------------------------------------------------------
func check():
	var result = false
	for id in checkMapIds:
		# 获取缓存中的怪物剩余数量
		var mon_num = MotaSystem.mapManager.get_mapdata(id, "alive_enemy", null)
		if mon_num == null:
			# null时则为完全没有进入过这张地图 所以无法从缓存中抓取
			for e in MotaSystem.mapManager.pre_load_map(id).events.get_children():
				# 这时候就要直接加载后遍历所有事件
				if e.current_page is MonsterEvent:
					if PassEventIds.has(id):
						if PassEventIds[id] is String && PassEventIds[id] == e.name:
							# 如果该怪物的事件ID为被赦免者则跳过
							continue
						elif PassEventIds[id] is Array && PassEventIds[id].has(e.name):
							# 如果该怪物的事件ID为被赦免者则跳过
							continue
					# 漏怪弹出
					result = true
					break
		elif mon_num > 0:
			# 该地图有漏怪 接下来判断漏的怪是否为被赦免者
			if PassEventIds.has(id) && ((PassEventIds[id] is Array && mon_num <= PassEventIds[id].size()) || (PassEventIds[id] is String && mon_num == 1)):
				# 具有豁免怪的地图 剩余怪物数量少于豁免怪数量的时候另加处理
				for e in MotaSystem.mapManager.pre_load_map(id).events.get_children():
					# 这时候就要直接加载后遍历所有事件
					if e.current_page is MonsterEvent:
						if PassEventIds[id] is String && PassEventIds[id] == e.name:
							# 如果该怪物的事件ID为被赦免者则跳过
							continue
						elif PassEventIds[id] is Array && PassEventIds[id].has(e.name):
							# 如果该怪物的事件ID为被赦免者则跳过
							continue
						# 漏怪弹出
						result = true
						break
			else:
				# 漏怪数量大于被赦免者总数 直接弹出
				result = true
				break
	return result
