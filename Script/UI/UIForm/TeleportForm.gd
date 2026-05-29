class_name TeleportForm extends UIForm

#楼传界面框体组
@export var TeleportFormBoard:Array[Node]
#返回按钮
@export var ReturnBtn:Button
#箭头
@export var ArrowBtnUp:Button
#箭头
@export var ArrowBtnDown:Button
#箭头
@export var ArrowBtnUp2:Button
#箭头
@export var ArrowBtnDown2:Button
#箭头
@export var TowerBtnUp:Button
#箭头
@export var TowerBtnDown:Button
#楼层按钮
@export var FloorBtns:Array[Button]
#viewport
@export var FloorViewport:Sprite2D
#下边
@export var TowerBoard:BoxContainer
#下边prefab
@export var TowerBtn:PackedScene
#上边
@export var TopLabel:Label

## 需要用作额外本地化处理的对象（塔名按钮）
var localization_texts_1:Array[Node]
## 需要用作额外本地化处理的对象（顶部全称）
@export var localization_texts_2:Array[Node]

# 当前按钮页
var pageStartIndex:int
# 当前页的序号
var mod:int
# 当前魔塔按钮index
var towerIndex : int

var old_map : int

# 楼层们
var floors:Array
# 魔塔们
var towers:Array

func _ready() -> void:
	#处理不同机型页面齐问题
	MotaSystem.mapManager.get_texture_node()
	updateGameScreen()
	old_map = MotaSystem.CurrentMap.key
	MotaSystem.CurrentMap.show_damage_point(true)
	MotaSystem.mapManager.preview_cache = {}
	
	self.openAnim(0.2)
	ReturnBtn.pressed.connect(onBtnReturnClick)
	ArrowBtnUp.pressed.connect(onBtnUpClick)
	ArrowBtnDown.pressed.connect(onBtnDownClick)
	ArrowBtnUp2.pressed.connect(onBtnPageTurn.bind(-1))
	ArrowBtnDown2.pressed.connect(onBtnPageTurn.bind(1))
	TowerBtnUp.pressed.connect(onTowerUp)
	TowerBtnDown.pressed.connect(onTowerDown)
	# 调整塔名按钮字体大小
	for i in TowerBoard.get_children():
		localization_texts_1.append(i.tower_name)
	Utility.changeTextForLocalization(localization_texts_1,30)
	Utility.changeTextForLocalization(localization_texts_2,30)
	
func onReadyFinished():
	pass
	
var input_interval = 0
const default_input_interval = 0.12

func _process(delta: float) -> void:
	if input_interval > 0:
		input_interval -= delta

#region 辅助方法

## 检查输入冷却，若可执行则重置冷却并返回 true
func _try_consume_input() -> bool:
	if input_interval > 0:
		return false
	input_interval = default_input_interval
	return true

## 跳转到末尾位置
func _jump_to_last():
	if floors.size() > FloorBtns.size():
		mod = FloorBtns.size() - 1
		pageStartIndex = floors.size() - FloorBtns.size()
	else:
		mod = floors.size() - 1
		pageStartIndex = 0

## 跳转到首位
func _jump_to_first():
	mod = 0
	pageStartIndex = 0

## 根据 floors 中的绝对索引，计算 mod 和 pageStartIndex
func _set_position_for_index(index: int):
	if index < FloorBtns.size():
		mod = index
		pageStartIndex = 0
	else:
		mod = FloorBtns.size() - 1
		pageStartIndex = index - FloorBtns.size() + 1

## 当前选中的绝对索引
func _current_index() -> int:
	return pageStartIndex + mod

## 单步向上（循环）
func _step_up():
	if mod == 0:
		if pageStartIndex > 0:
			pageStartIndex -= 1
		else:
			_jump_to_last()
	else:
		mod -= 1

## 单步向下（循环）
func _step_down():
	if floors.size() > FloorBtns.size():
		if mod == FloorBtns.size() - 1:
			if pageStartIndex < floors.size() - FloorBtns.size():
				pageStartIndex += 1
			else:
				_jump_to_first()
		else:
			mod += 1
	else:
		if mod == floors.size() - 1:
			_jump_to_first()
		else:
			mod += 1

#endregion

func initialize(param):
	# 根据变量记录
	towers = MotaSystem.gameVariables["floorRecord"].keys()
	var towerId = DatatableManager.Map.data[MotaSystem.CurrentMap.key].towerId
	# 下边
	for tower in towers:
		var btn = TowerBtn.instantiate()
		TowerBoard.add_child(btn)
		btn.initialize(int(tower),self)
		if towerId == btn.towerId:
			towerIndex = btn.get_index()
	refreshTowers.call_deferred()
	# 当前floor
	floors = MotaSystem.gameVariables["floorRecord"][str(towerId)].filter(func(id): return DatatableManager.Map.data[int(id)].tower)
	# 先算出停留位置
	var index = floors.find(str(MotaSystem.gameVariables["mapId"]))
	if index == -1:
		var currentMapData = DatatableManager.Map.data[MotaSystem.gameVariables["mapId"]]
		if currentMapData.floorId == 0:
			# 意外情况就首位
			_jump_to_first()
		else:
			# 找到同楼层id的非隐藏层
			var sameFloor = Utility.select(DatatableManager.Map.data,
				func(dr):
					return dr.towerId == currentMapData.towerId \
						&& dr.floorId == currentMapData.floorId \
						&& dr.tower
			)
			index = floors.find(str(sameFloor[0].id))
			_set_position_for_index(index)
	else:
		_set_position_for_index(index)
	# 左边
	for btn in FloorBtns:  
		btn.initialize(self)
	for i in TeleportFormBoard:
		updatePagePanelPosition(i)
	refreshBtns.call_deferred()

# 显示楼层
func ShowFloor(id: int):
	var mapData = DatatableManager.Map.data[id]
	# 上边
	TopLabel.text = tr(DatatableManager.Tower.data[mapData.towerId].name) + " " + tr("{0}层").format([mapData.floorId])
	# 屏幕
	MotaSystem.gameVariables["teleport"] = true
	if !MotaSystem.gameVariables["ufo"]:
		MotaSystem.Player.allPass = true
	MotaSystem.gamePlayerManager.visible = false
	if !MotaSystem.mapManager.preview_cache.has(id):
		MotaSystem.mapManager.changeMap(id, false)
		await RenderingServer.frame_post_draw
		MotaSystem.mapManager.preview_cache[id] = ImageTexture.create_from_image(
			MotaSystem.mapManager.get_viewport().get_texture().get_image()
		)
	FloorViewport.texture = MotaSystem.mapManager.preview_cache[id]

func onBtnReturnClick():
	MotaSystem.gameVariables["teleport"] = false
	if !MotaSystem.gameVariables["ufo"]:
		MotaSystem.Player.allPass = false
	MotaSystem.gamePlayerManager.visible = true
	MotaSystem.mapManager.changeMap(old_map,false)
	MotaSystem.CurrentMap.show_damage_point()
	close()

func refresh():
	refreshTowers()
	var towerId = TowerBoard.get_child(towerIndex).towerId
	floors = MotaSystem.gameVariables["floorRecord"][str(towerId)].filter(func(id): return DatatableManager.Map.data[int(id)].tower)
	refreshBtns()

func refreshTowers():
	var children = TowerBoard.get_children()
	for i in range(children.size()):
		if towerIndex == i:
			children[i].onFocused.call_deferred()
			TowerBoard.get_parent().ensure_control_visible.call_deferred(children[i])
		else:
			children[i].onFocusExit()

func refreshBtns():
	# 左边
	for i in range(0, FloorBtns.size()):
		while i < floors.size() && !DatatableManager.Map.data[int(floors[i + pageStartIndex])].tower:
			floors.erase(floors[i + pageStartIndex])
		if i < floors.size():
			FloorBtns[i].visible = true
			FloorBtns[i].refresh(int(floors[i+pageStartIndex]))
		else:
			FloorBtns[i].visible = false
	if FloorBtns[mod].has_focus():
		FloorBtns[mod].release_focus()
	FloorBtns[mod].grab_focus()

const turn_num = 5

# 左右翻页
func onBtnPageTurn(page_num: int):
	if !_try_consume_input():
		return
	if page_num == -1:
		if _current_index() == 0:
			_jump_to_last()
		elif _current_index() - turn_num < 0:
			_jump_to_first()
		else:
			for i in range(turn_num):
				_step_up()
	elif page_num == 1:
		if _current_index() == floors.size() - 1:
			_jump_to_first()
		elif _current_index() + turn_num >= floors.size():
			_jump_to_last()
		else:
			for i in range(turn_num):
				_step_down()
	refreshBtns()

# 点击上一个
func onBtnUpClick():
	if !_try_consume_input():
		return
	_step_up()
	refreshBtns()

# 点击下一个
func onBtnDownClick():
	if !_try_consume_input():
		return
	_step_down()
	refreshBtns()

func onTowerDown():
	if !_try_consume_input():
		return
	var count = TowerBoard.get_children().size()
	towerIndex = (towerIndex - 1 + count) % count
	_jump_to_first()
	refresh()

func onTowerUp():
	if !_try_consume_input():
		return
	towerIndex = (towerIndex + 1) % TowerBoard.get_children().size()
	_jump_to_first()
	refresh()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu") or event.is_action_pressed("call_minimap"):
		onBtnReturnClick()
	if event.is_action("ui_left"):
		onBtnPageTurn(-1)
	if event.is_action("ui_right"):
		onBtnPageTurn(1)
	if event.is_action("ui_down"):
		onBtnDownClick()
	if event.is_action("ui_up"):
		onBtnUpClick()
	if event.is_action("ui_tab"):
		onTowerUp()
