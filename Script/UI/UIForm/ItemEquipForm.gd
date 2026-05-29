class_name ItemEquipForm extends UIForm

# 道具预制件
@export var Item_Perfab:PackedScene
# 装备栏预制件
@export var Equip_Perfab:PackedScene
# 装备池预制件
@export var EquipPool_Perfab:PackedScene
# 道具栏按钮
@export var ItemBoardBtn:Button
# 道具装备栏主框体
@export var ItemEquipBoard:PanelContainer
# 物品详情主框
@export var ItemInfoMainBoard:PanelContainer
# 装备详情主框
@export var EquipInfoMainBoard:PanelContainer
# 物品详情框体
@export var ItemInfoContainer:MarginContainer
# 装备详情框体
@export var EquipInfoContainer:MarginContainer
# 道具栏可用道具列表框
@export var ItemCanUseListBoard:PanelContainer
# 道具栏不可用道具列表框
@export var ItemCanNotUseListBoard:PanelContainer
# 装备栏装备列表框
@export var EquipListBoard:MarginContainer
# 装备栏装备池列表框
@export var EquipPoolListBoard:PanelContainer
# 可使用类物品表
@export var BoardItemCanUseList:GridContainer
# 不可使用类物品表
@export var BoardItemCanNotUseList:GridContainer
# 装备栏列表
@export var BoardEquipList:GridContainer
# 装备池表
@export var BoardEquipPoolList:GridContainer
# 装备栏按钮
@export var EquipBoardBtn:Button
# 返回按钮
@export var ReturnBtn:Button
# 道具图标
@export var itemInfoIcon:TextureRect
# 道具名称
@export var itemInfoName:RichTextLabel
# 道具可使用类别
@export var itemInfoUse:Label
# 道具类型
@export var itemInfoType:Label
# 道具持有数量
@export var itemInfoCount:Label
# 道具描述
@export var itemInfo:RichTextLabel
# 道具使用按钮
@export var itemUseBtn:Button
# 道具取消使用按钮
@export var itemReturnBtn:Button
# 装备图标
@export var equipInfoIcon:TextureRect
# 装备名称
@export var equipInfoName:RichTextLabel
# 装备类型
@export var equipInfoType:Label
# 装备描述
@export var equipInfo:RichTextLabel
# 装备使用按钮
@export var equipUseBtn:Button
# 装备卸下按钮
@export var equipUnloadBtn:Button
# 装备取消使用按钮
@export var equipReturnBtn:Button

## 需要用作额外本地化处理的对象（道具名称）
@export var localization_texts_1:Array[Node]
## 需要用作额外本地化处理的对象（是否可使用道具）
@export var localization_texts_2:Array[Node]
## 需要用作额外本地化处理的对象（道具类别）
@export var localization_texts_3:Array[Node]
## 需要用作额外本地化处理的对象（道具数量）
@export var localization_texts_4:Array[Node]
## 需要用作额外本地化处理的对象（道具按钮）
@export var localization_texts_5:Array[Node]
## 需要用作额外本地化处理的对象（装备名称）
@export var localization_texts_6:Array[Node]
## 需要用作额外本地化处理的对象（装备类别）
@export var localization_texts_7:Array[Node]
## 需要用作额外本地化处理的对象（装备按钮）
@export var localization_texts_8:Array[Node]

#可使用物品列表
var itemCanUseList:Dictionary
#不可使用物品列表
var itemCanNotUseList:Dictionary
#所选道具id
var focus_item_id:int
#所选道具index
var focus_item_idx:int
#所选道具对象
var focus_item_object:Button
#所锁定道具对象
var lock_item_object:Button
#所选装备id
var focus_equip_id
#所选装备对象
var focus_equip_object:Node
#所锁定装备对象
var lock_equip_object:Node

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	
	self.openAnim(0.2)
	ItemBoardBtn.add_theme_color_override("font_color",Color(1,1,0.5,1))
	ItemBoardBtn.add_theme_color_override("font_focus_color",Color(1,1,0.5,1))
	ItemBoardBtn.add_theme_color_override("font_hover_color",Color(1,1,0.5,1))
	
func onReadyFinished():
	ItemBoardBtn.grab_focus()

var itemForm:bool

#初始化
func initialize(param):
	itemForm = true
	#对道具装备主体框做处理
	ItemCanUseListBoard.visible = true
	ItemCanNotUseListBoard.visible = true
	EquipListBoard.visible = false
	EquipPoolListBoard.visible = false
	#对详情框做处理
	ItemInfoContainer.visible = false
	EquipInfoMainBoard.visible = false
	EquipInfoContainer.visible = false
	ReturnBtn.pressed.connect(onBtnReturnClick)
	ItemBoardBtn.pressed.connect(onItemBtnClick)
	ItemBoardBtn.focus_entered.connect(onItemBtnFocus)
	EquipBoardBtn.pressed.connect(onEquipBtnClick)
	EquipBoardBtn.focus_entered.connect(onEquipBtnFocus)
	itemUseBtn.pressed.connect(onBtnItemUseClick)
	itemReturnBtn.pressed.connect(onBtnItemReturn)
	equipUseBtn.pressed.connect(onBtnEquipUse)
	equipUnloadBtn.pressed.connect(onBtnEquipUnload)
	equipReturnBtn.pressed.connect(onBtnEquipReturn)
	getitemlist()
	RefreshItemList()
	createEquipList()
	updateEquipPoolList()
	updatePagePanelPosition(ItemEquipBoard)
	updatePagePanelPosition(ItemInfoMainBoard)
	updatePagePanelPosition(EquipInfoMainBoard)
	
func onItemBtnFocus():
	ItemBoardBtn.add_theme_color_override("font_color",Color(1,1,0.5,1))
	EquipBoardBtn.add_theme_color_override("font_color",Color(1,1,1,1))
	
func onEquipBtnFocus():
	ItemBoardBtn.add_theme_color_override("font_color",Color(1,1,1,1))
	EquipBoardBtn.add_theme_color_override("font_color",Color(1,1,0.5,1))
	
func onItemBtnClick():
	itemForm = true
	ItemBoardBtn.add_theme_color_override("font_color",Color(1,1,0.5,1))
	EquipBoardBtn.add_theme_color_override("font_color",Color(1,1,1,1))
	ItemBoardBtn.add_theme_color_override("font_hover_color",Color(1,1,0.5,1))
	EquipBoardBtn.add_theme_color_override("font_hover_color",Color(0.94,0.94,0.94,1))
	ItemInfoMainBoard.visible = true
	EquipInfoMainBoard.visible = false
	ItemInfoContainer.visible = false
	EquipInfoContainer.visible = false
	ItemCanUseListBoard.visible = true
	ItemCanNotUseListBoard.visible = true
	EquipListBoard.visible = false
	EquipPoolListBoard.visible = false
	
func onEquipBtnClick():
	itemForm = false
	ItemBoardBtn.add_theme_color_override("font_color",Color(1,1,1,1))
	EquipBoardBtn.add_theme_color_override("font_color",Color(1,1,0.5,1))
	ItemBoardBtn.add_theme_color_override("font_hover_color",Color(0.94,0.94,0.94,1))
	EquipBoardBtn.add_theme_color_override("font_hover_color",Color(1,1,0.5,1))
	ItemInfoMainBoard.visible = false
	EquipInfoMainBoard.visible = true
	ItemInfoContainer.visible = false
	EquipInfoContainer.visible = false
	ItemCanUseListBoard.visible = false
	ItemCanNotUseListBoard.visible = false
	EquipListBoard.visible = true
	EquipPoolListBoard.visible = true
	
#遍历当前所有道具，只要数量不为0就计入list
#同时区分可使用和不可使用道具，所有可使用类道具全部排序在最前方
func getitemlist():
	var temp_item_can_use:Dictionary
	var temp_item_cannot_use:Dictionary
	for i in MotaSystem.gameData.item:
		if(MotaSystem.gameData.item[i] != 0):
			# 如果这个物品是可使用类道具，则放入可使用列表
			if DatatableManager.Item.data[i.to_int()]["itemUseAvaliable"] == 1:
				temp_item_can_use[i] = MotaSystem.gameData.item[i]
			# 如果这个物品是不可使用类道具，则放入不可使用列表
			if DatatableManager.Item.data[i.to_int()]["itemUseAvaliable"] == 0:
				temp_item_cannot_use[i] = MotaSystem.gameData.item[i]
	itemCanUseList = temp_item_can_use.duplicate()
	itemCanNotUseList = temp_item_cannot_use.duplicate()
	
func RefreshItemList():
	#先清除所有物品列表，然后重新生成
	for i in BoardItemCanUseList.get_children():
		BoardItemCanUseList.remove_child(i)
		i.queue_free()
		#i.free()
	for i in BoardItemCanNotUseList.get_children():
		BoardItemCanNotUseList.remove_child(i)
		i.queue_free()
		#i.free()
	creatitemlist()
		
func creatitemlist():
	# 创建可使用物品列表
	for i in itemCanUseList.size():
		var can_use_item = Item_Perfab.instantiate()
		can_use_item.name = str(DatatableManager.Item.data[itemCanUseList.keys()[i].to_int()]["id"])
		can_use_item.initialize(DatatableManager.Item.data[itemCanUseList.keys()[i].to_int()]["id"])
		can_use_item.focus_entered.connect(onBtnItemInfo.bind(can_use_item))
		can_use_item.pressed.connect(onBtnItemChoice.bind(can_use_item))
		# 直接放入GridContainer中，自动排
		BoardItemCanUseList.add_child(can_use_item)
	# 创建不可使用物品列表
	for i in itemCanNotUseList.size():
		var can_not_use_item = Item_Perfab.instantiate()
		can_not_use_item.name = str(DatatableManager.Item.data[itemCanNotUseList.keys()[i].to_int()]["id"])
		can_not_use_item.initialize(DatatableManager.Item.data[itemCanNotUseList.keys()[i].to_int()]["id"])
		can_not_use_item.focus_entered.connect(onBtnItemInfo.bind(can_not_use_item))
		# 直接放入GridContainer中，自动排
		BoardItemCanNotUseList.add_child(can_not_use_item)
		
#道具信息
func onBtnItemInfo(focus_button:Button):
	# 如果聚焦的是不同的按钮，则清除锁定对象（切换道具时重置两次点击状态）
	if focus_button != focus_item_object:
		lock_item_object = null
	ItemInfoContainer.visible = true
	focus_item_id = focus_button.item_id
	focus_item_object = focus_button
	#获取被按下按钮的id，作为传输用的物品id
	#图标
	itemInfoIcon.texture=load("res://Resources/Icon/item/"+DatatableManager.Item.data[focus_item_id]["itemPictrueName"])
	#名称
	itemInfoName.text = tr(DatatableManager.Item.data[focus_item_id]["itemName"])
	#可用性
	var item_CanUse_id:int = DatatableManager.Item.data[focus_item_id]["itemUseAvaliable"]
	itemInfoUse.text = "【" + tr(Defination.Item_CanUse[item_CanUse_id]) + "】"
	#类别
	var item_type_id:int = DatatableManager.Item.data[focus_item_id]["itemType"]
	itemInfoType.text = Defination.Item_Type[item_type_id]
	#持有数量
	itemInfoCount.text = str(MotaSystem.gameData.item[str(focus_item_id)])
	#道具描述
	itemInfo.text = tr(DatatableManager.Item.data[focus_item_id]["itemNote"])
	#是否可使用，如果不是可使用道具则禁用按钮
	if DatatableManager.Item.data[focus_item_id]["itemUseAvaliable"] == 0:
		itemUseBtn.disabled = true
		itemReturnBtn.disabled = true
		itemUseBtn.focus_mode = Control.FOCUS_CLICK
		itemReturnBtn.focus_mode = Control.FOCUS_CLICK
	else:
		itemUseBtn.disabled = false
		itemReturnBtn.disabled = false
		itemUseBtn.focus_mode = Control.FOCUS_ALL
		itemReturnBtn.focus_mode = Control.FOCUS_ALL
	#更新文本长度
	Utility.changeTextForLocalization(localization_texts_1,35)
	Utility.changeTextForLocalization(localization_texts_2,35)
	Utility.changeTextForLocalization(localization_texts_3,35)
	Utility.changeTextForLocalization(localization_texts_4,35)
	Utility.changeTextForLocalization(localization_texts_5,40)
	Utility.changeTextForLocalization(localization_texts_6,35)
	Utility.changeTextForLocalization(localization_texts_7,35)
	Utility.changeTextForLocalization(localization_texts_8,40)
		
#选中道具
# PC端：focus_entered已显示信息，第1次pressed直接使用（lock在focus_entered之前为null，focus_entered后lock被清除，pressed时lock!=button→记录lock；但focus_entered和pressed之间lock已被清除）
# 实际上PC端hover→focus_entered清除lock→pressed时lock为null→记录lock不使用；需第2次点击才使用
# 手机端：touch→focus_entered清除lock→pressed时lock为null→记录lock不使用；第2次点击→focus_entered（同按钮不清lock）→pressed时lock==button→使用
# 两端行为统一：第1次点击显示信息，第2次点击使用
func onBtnItemChoice(focus_button:Button):
	if lock_item_object == focus_button:
		onBtnItemUseClick()
		return
	lock_item_object = focus_button
	itemUseBtn.grab_focus.call_deferred()
		
#道具取消使用
func onBtnItemReturn():
	ItemInfoContainer.visible = false
	if focus_item_object != null:
		focus_item_object.grab_focus.call_deferred()
		focus_item_object = null
	else:
		BoardItemCanUseList.get_child(0).grab_focus.call_deferred()
		focus_item_object = null
	
#道具主动使用
func onBtnItemUseClick():
	var item_id = focus_item_id
	var item_idx:int = focus_item_idx
	
	MotaSystem.gameVariables["specialEventParam"] = item_id
	MotaSystem.gameEventManager.pushSpecialEvent(Defination.SpecialEventType.ItemUsingEvent)
	
	itemCanUseList.clear()
	itemCanNotUseList.clear()
	getitemlist()
	RefreshItemList()
	ReturnBtn.grab_focus()
	#聚焦回同idx的按钮上，如果位置不足则聚焦在最后一位
	if BoardItemCanUseList.get_child_count() != 0:
		if BoardItemCanUseList.get_child_count() >= item_idx + 1:
			BoardItemCanUseList.get_child(item_idx).grab_focus()
		else:
			BoardItemCanUseList.get_child(-1).grab_focus()
	ItemInfoContainer.visible = false
	MotaSystem.gameForm.RefreshUI()
			
#创建装备栏列表
func createEquipList():
	for i in MotaSystem.gameData.equip_slot:
		var equip_slot = Equip_Perfab.instantiate()
		equip_slot.initialize(i)
		equip_slot.name = Defination.Equip_Type[equip_slot.equip_slot_index]
		equip_slot.EquipButton.focus_entered.connect(onBtnEquipInfo.bind(equip_slot))
		equip_slot.EquipButton.pressed.connect(onBtnEquipChoice.bind(equip_slot))
		# 直接放入GridContainer中，自动排
		BoardEquipList.add_child(equip_slot)
		
# 选中装备
func onBtnEquipChoice(focus_object:Node):
	# 从装备栏来
	if focus_object is EquipPerfab:
		focus_equip_id = focus_object.equip_id
		focus_equip_object = focus_object
		if lock_equip_object == focus_equip_object:
			onBtnEquipUnload()
			return
		lock_equip_object = focus_object
		if focus_equip_id != null:
			equipUnloadBtn.grab_focus.call_deferred()
	# 从装备池来
	if focus_object is EquipPoolPerfab:
		focus_equip_id = focus_object.equip_id
		focus_equip_object = focus_object
		if lock_equip_object == focus_equip_object:
			onBtnEquipUse()
			return
		lock_equip_object = focus_object
		equipUseBtn.grab_focus.call_deferred()
		
#装备槽点击卸下装备
func onBtnEquipUnload():
	var equip_slot = focus_equip_object
	var equip_id = equip_slot.equip_id
	if equip_id != null:
		MotaSystem.gameData.addEquip_pool(equip_id,1)
		#MotaSystem.gameData.equip[equip_slot.equip_slot] = null
		MotaSystem.gameData.updateEquip(equip_slot.equip_slot,null)
		equip_slot.refresh()
		equip_slot.EquipButton.grab_focus.call_deferred()
		updateEquipPoolList()
		
#装备池点击更换装备
func onBtnEquipUse():
	var equip_pool = focus_equip_object
	var equip_pool_index = focus_equip_object.get_index()
	var equip_id:int = equip_pool.equip_id
	var equip_type:int = DatatableManager.Equip.data[equip_id]["equipType"]
	var equip_slot
	# 获取对应的equipslot
	for i in BoardEquipList.get_children():
		if equip_type == i.equip_slot_index:
			equip_slot = i
			break
	if equip_slot.equip_id != null:
		MotaSystem.gameData.addEquip_pool(equip_id,-1)
		MotaSystem.gameData.addEquip_pool(equip_slot.equip_id,1)
	else:
		MotaSystem.gameData.addEquip_pool(equip_id,-1)
	MotaSystem.gameData.updateEquip(equip_slot.equip_slot,equip_id)
	#MotaSystem.gameData.equip[equip_slot.equip_slot] = str(equip_id)
	equip_slot.refresh()
	updateEquipPoolList()
	#聚焦回同idx的按钮上，如果位置不足则聚焦在最后一位
	if BoardEquipPoolList.get_child_count() != 0:
		if BoardEquipPoolList.get_child_count() >= equip_pool_index + 1:
			BoardEquipPoolList.get_child(equip_pool_index).grab_focus.call_deferred()
		else:
			BoardEquipPoolList.get_child(-1).grab_focus.call_deferred()
	else:
		equip_slot.EquipButton.grab_focus.call_deferred()
	EquipInfoContainer.visible = false
	MotaSystem.gameForm.RefreshUI()
		
#更新装备池列表
func updateEquipPoolList():
	#清空装备池
	for i in BoardEquipPoolList.get_children():
		BoardEquipPoolList.remove_child(i)
		i.queue_free()
		#i.free()
	#创建装备池	
	#先对装备池子进行按照备类型编号排序
	var sort_list:Dictionary
	for i in MotaSystem.gameData.equip_pool.keys():
		sort_list[i] = DatatableManager.Equip.data[i.to_int()]["equipType"]
	var temp_EquipPool_keys = sort_list.keys()
	temp_EquipPool_keys.sort_custom(func(a, b): return sort_list[a] < sort_list[b])
	#以排序过后的装备池来做
	for i in temp_EquipPool_keys:
		if MotaSystem.gameData.equip_pool[i] > 0:
			var equip_id:int = i.to_int()
			var equip_pool = EquipPool_Perfab.instantiate()
			equip_pool.initialize(equip_id)
			equip_pool.name = DatatableManager.Equip.data[equip_id]["equipName"]
			equip_pool.focus_entered.connect(onBtnEquipInfo.bind(equip_pool))
			equip_pool.pressed.connect(onBtnEquipChoice.bind(equip_pool))
			BoardEquipPoolList.add_child(equip_pool)	
	EquipInfoContainer.visible = false
	MotaSystem.gameForm.RefreshUI()
		
#装备信息
func onBtnEquipInfo(focus_object:Node):
	# 根据传进来的node来区分是从装备栏传来的还是装备池传来的
	# 如果聚焦的是不同的对象，则清除锁定对象（切换装备时重置两次点击状态）
	if focus_object != focus_equip_object:
		lock_equip_object = null
	# 从装备栏来
	if focus_object is EquipPerfab:
		focus_equip_id = focus_object.equip_id
		focus_equip_object = focus_object
		equipUseBtn.disabled = true
		equipUnloadBtn.disabled = false
		equipUseBtn.focus_mode = Control.FOCUS_CLICK
		equipUnloadBtn.focus_mode = Control.FOCUS_ALL
	# 从装备池来
	if focus_object is EquipPoolPerfab:
		focus_equip_id = focus_object.equip_id
		focus_equip_object = focus_object
		equipUseBtn.disabled = false
		equipUnloadBtn.disabled = true
		equipUseBtn.focus_mode = Control.FOCUS_ALL
		equipUnloadBtn.focus_mode = Control.FOCUS_CLICK
	EquipInfoContainer.visible = true
	if focus_equip_id != null:
		#图标
		equipInfoIcon.texture = load("res://Resources/Icon/equip/"+DatatableManager.Equip.data[focus_equip_id]["equipIcon"])
		#名称
		equipInfoName.text = tr(DatatableManager.Equip.data[focus_equip_id]["equipName"])
		#类别
		var equip_type_id:int = DatatableManager.Equip.data[focus_equip_id]["equipType"]
		equipInfoType.text = "【" + tr(Defination.Equip_Type[equip_type_id]) + "】"
		#描述
		equipInfo.text = tr(DatatableManager.Equip.data[focus_equip_id]["equipNote"])
	else:
		EquipInfoContainer.visible = false
	#更新文本长度
	Utility.changeTextForLocalization(localization_texts_1,35)
	Utility.changeTextForLocalization(localization_texts_2,35)
	Utility.changeTextForLocalization(localization_texts_3,35)
	Utility.changeTextForLocalization(localization_texts_4,35)
	Utility.changeTextForLocalization(localization_texts_5,40)
	Utility.changeTextForLocalization(localization_texts_6,35)
	Utility.changeTextForLocalization(localization_texts_7,35)
	Utility.changeTextForLocalization(localization_texts_8,40)
		
#装备取消使用
func onBtnEquipReturn():
	EquipInfoContainer.visible = false
	if focus_equip_object != null:
		# 从装备栏来
		if focus_equip_object is EquipPerfab:
			focus_equip_object.EquipButton.grab_focus.call_deferred()
			focus_equip_object = null
		# 从装备池来
		if focus_equip_object is EquipPoolPerfab:
			focus_equip_object.grab_focus.call_deferred()
			focus_equip_object = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu") or event.is_action_pressed("call_equip"):
		close()

func onBtnReturnClick():
	close()
