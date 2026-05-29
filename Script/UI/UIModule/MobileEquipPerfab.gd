class_name MoblieShowEquipPerfab extends Control

#装备图标
@export var EquipIcon:TextureRect
#装备名称
@export var EquipName:Label
#装备下拉框
@export var EquipOptionButton:OptionButton

#装备类型
var EquipType:int
#装备槽位
var EquipSlot:String
#当前装备Id
var EquipId

func initialize(param):
	EquipType = param[0]
	EquipSlot = param[1]
	updateEquipSlot()
	EquipOptionButton.item_selected.connect(EquipOptionSelect)
	updateEquipOptions()
	
# 刷新槽位信息
func updateEquipSlot():
	if MotaSystem.gameData.equip.keys().has(EquipSlot):
		if MotaSystem.gameData.equip[EquipSlot] != null:
			EquipId = MotaSystem.gameData.equip[EquipSlot].to_int()
			EquipIcon.texture = MotaSystem.resourceManager.loadFile("res://Resources/Icon/equip/" + DatatableManager.Equip.data[EquipId]["equipIcon"])
			EquipName.text = tr(DatatableManager.Equip.data[EquipId]["equipName"])
			EquipName.tooltip_text = tr(DatatableManager.Equip.data[EquipId]["equipName"])	
			#EquipOptionButton.tooltip_text = tr(DatatableManager.Equip.data[EquipId]["equipName"])	
		else:
			EquipId = null
			EquipIcon.texture = null
			EquipName.text = tr("无装备")
			EquipName.tooltip_text = tr("无装备")
			EquipOptionButton.tooltip_text = tr("无装备")
			
func updateEquipOptions():
	#可选装备数组
	var items_array:Array[Array]
	# 装备槽有装备则添加
	if MotaSystem.gameData.equip[EquipSlot] != null:
		items_array.append([tr(DatatableManager.Equip.data[EquipId]["equipName"]),EquipId])
	# 来自于装备池可选装备
	for i in MotaSystem.gameData.equip_pool.keys():
		if MotaSystem.gameData.equip_pool[i] > 0 and DatatableManager.Equip.data[i.to_int()]["equipType"] == EquipType:
			items_array.append([tr(DatatableManager.Equip.data[i.to_int()]["equipName"]),i.to_int()])
	# 卸下装备（id固定为0）
	items_array.append([tr("无装备"),0])
	#根据装备id进行排序
	items_array.sort_custom(func(a, b): return a[1] > b[1])
	#对比当前下拉框对象和新的下拉框列表是否一致，一致则不清除，不一致则清除并重新更新
	var now_items:Array
	var new_items:Array
	for i in range(EquipOptionButton.item_count):
		now_items.append(EquipOptionButton.get_item_id(i))
	now_items.sort_custom(func(a, b): return a > b)
	for i in items_array:
		new_items.append(i[1])
	if now_items != new_items:
		if EquipOptionButton.item_count != 0:
			EquipOptionButton.clear()
		for i in items_array:
			EquipOptionButton.add_item(i[0],i[1])
	# 根据是否有装备决定当前聚焦对象
	if MotaSystem.gameData.equip[EquipSlot] != null:
		EquipOptionButton.selected = EquipOptionButton.get_item_index(MotaSystem.gameData.equip[EquipSlot].to_int())
	else:
		EquipOptionButton.selected = EquipOptionButton.get_item_index(0)
	var option_pop:PopupMenu = EquipOptionButton.get_popup()
	var font = load("res://Resources/Font/ChillRoundGothic_Medium.otf")
	option_pop.add_theme_font_override("font",font)
	option_pop.add_theme_font_size_override("font_size",25)
		
# 下拉框选择
func EquipOptionSelect(select_id:int):
	if EquipOptionButton.get_item_id(EquipOptionButton.selected) != 0:
		if MotaSystem.gameData.equip[EquipSlot] != null:
			MotaSystem.gameData.addEquip_pool(EquipOptionButton.get_item_id(EquipOptionButton.selected),-1)
			MotaSystem.gameData.addEquip_pool(EquipId,1)
		else:
			MotaSystem.gameData.addEquip_pool(EquipOptionButton.get_item_id(EquipOptionButton.selected),-1)
		#MotaSystem.gameData.equip[EquipSlot] = str(EquipOptionButton.get_item_id(EquipOptionButton.selected))
		MotaSystem.gameData.updateEquip(EquipSlot,EquipOptionButton.get_item_id(EquipOptionButton.selected))
	else:
		MotaSystem.gameData.addEquip_pool(EquipId,1)
		#MotaSystem.gameData.equip[EquipSlot] = null
		MotaSystem.gameData.updateEquip(EquipSlot,null)
	EquipOptionButton.release_focus()
	MotaSystem.gameForm.RefreshUI()
