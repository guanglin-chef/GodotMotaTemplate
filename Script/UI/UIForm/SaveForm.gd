class_name SaveForm extends UIForm

var isSave:bool
#存档页面框体
@export var SaveBoards:Array[PanelContainer]
#存档数组
@export var SaveBtns:Array[Node]
#返回按钮
@export var ReturnBtn:Button
#左翻页按钮
@export var PageUpBtn:Button
#右翻页按钮
@export var PageDownBtn:Button
#上一个存档按钮
@export var SaveUpBtn:Button
#下一个存档按钮
@export var SaveDownBtn:Button
#页码
@export var Page:Label
#章节版本
@export var ChapterVersion:Label
#区域名称
@export var AreaName:Label
#地图名称
@export var MapName:Label
#存档时间
@export var SaveTime:Label
#游戏模式
@export var GameMode:Label
#缩略图
@export var Thumbnail:ThumbnailManager

# 存档号
var index:int
# 当前页码
var page:int

var pageMax:int:
	get:
		return Defination.saveMax / onePageBtnMax
# 当前余数
var mod:int
var old_mod
# 被选择按钮
var choice_btn:Button

const onePageBtnMax = 10

func _ready() -> void:
	#处理不同机型页面齐问题
	updateGameScreen()
	
	self.openAnim(0.2)
	ReturnBtn.pressed.connect(onBtnReturnClick)
	PageUpBtn.pressed.connect(onBtnSavePageTurn.bind(1))
	PageDownBtn.pressed.connect(onBtnSavePageTurn.bind(-1))
	SaveUpBtn.pressed.connect(onBtnSaveUpClick)
	SaveDownBtn.pressed.connect(onBtnSaveDownClick)
	
func onReadyFinished():
	SaveBtns[mod].grab_focus()
	SaveBtns[old_mod].disabled = false	
	
var input_interval = 0
const default_input_interval = 0.12

func _process(delta: float) -> void:
	if input_interval > 0:
		input_interval -= delta
		
func initialize(param):
	if MotaSystem.saveManager.m_SaveIndex == -1:
		index = MotaSystem.config.getValue("LastSave","Save")
	else:
		index = MotaSystem.saveManager.m_SaveIndex
		
	# 计算页码
	cal_page(index)
	#存档按钮
	isSave = param
	var count = 0
	for i in range(page * onePageBtnMax,(page+1) * onePageBtnMax):
		SaveBtns[count].initialize(i, self)
		count+=1
	Page.text = str(page+1)
	# 不知道这个是干嘛的，这个会导致lastsave读档格是灰的
	SaveBtns[mod].disabled = true
	for i in SaveBoards:
		updatePagePanelPosition(i)
	
# 计算页码函数	
func cal_page(save_index:int):
	page = floori((save_index) / onePageBtnMax)
	mod = (save_index) % onePageBtnMax
	old_mod = (save_index) % onePageBtnMax
	
# 显示对应存档的预览图等信息
func ShowSaveMsg(index:int):
	var save = MotaSystem.saveManager.getSaveFile(index)
	if save:
		# 图
		Thumbnail.init_thumbnail(save)
		#存档时间
		var bias = Time.get_time_zone_from_system().bias
		var time = Time.get_datetime_dict_from_unix_time(save.time + bias * 60)
		SaveTime.text = tr(Time.get_datetime_string_from_datetime_dict(time,true))
		#游戏模式
		if save.gameData.gameVariables["gameMode"] == true:
			GameMode.label_settings.font_color = Color(1,1,1,1)
			GameMode.text = tr("标准模式")
		else:
			GameMode.label_settings.font_color = Color(0.1,1,1,1)
			GameMode.text = tr("自定义模式")
		#章节版本
		var map_key = int(save["gameData"]["gameVariables"]["mapId"])
		var chapter_id = int(DatatableManager.Map.data[map_key]["chapterId"])
		ChapterVersion.text = str(float(chapter_id))
		#区域名称
		if save.gameData.gameVariables.has("towerId"):
			AreaName.text = tr(DatatableManager.Tower.data[int(save.gameData.gameVariables["towerId"])]["name"])
		else:
			AreaName.text = tr("无")
		#地图名称
		if save.gameData.gameVariables.has("mapId"):
			if DatatableManager.Map.data[int(save.gameData.gameVariables["mapId"])]["tower"]:
				MapName.text = tr("{0}层").format([DatatableManager.Map.data[int(save.gameData.gameVariables["mapId"])].floorId])
			else:
				MapName.text = tr(DatatableManager.Map.data[int(save.gameData.gameVariables["mapId"])]["mapName"])
		else:
			MapName.text = tr("无")
	else:
		Thumbnail.init_thumbnail(null)
		GameMode.text = tr("无")
		SaveTime.text = tr("暂无存档")
		MapName.text = tr("无")
		AreaName.text = tr("无")
		ChapterVersion.text = tr("无")

func refreshBtns():
	var count = 0
	for i in range(page * onePageBtnMax,(page + 1) * onePageBtnMax):
		SaveBtns[count].initialize(i, self)
		count+=1
	Page.text = str(page+1)
	if SaveBtns[mod].has_focus():
		SaveBtns[mod].release_focus()
	SaveBtns[mod].grab_focus()

func onBtnReturnClick():
	close()

# 左右翻页
func onBtnSavePageTurn(page_num:int):
	if input_interval <= 0:
		input_interval = default_input_interval
		page += page_num
		page = (page + pageMax) % pageMax
		refreshBtns()
		
# 点击上一个存档
func onBtnSaveUpClick():
	if input_interval <= 0:
		input_interval = default_input_interval
		if mod == 0:
			page -= 1
			page = (page + pageMax) % pageMax
			mod = onePageBtnMax - 1
			refreshBtns()
		else:
			mod -= 1
			refreshBtns()
# 点击下一个存档
func onBtnSaveDownClick():
	if input_interval <= 0:
		input_interval = default_input_interval
		if mod == onePageBtnMax - 1:
			page += 1
			page = (page + pageMax) % pageMax
			mod = 0
			refreshBtns()
		else:
			mod += 1
			refreshBtns()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu") or event.is_action_pressed("call_save") or event.is_action_pressed("call_load"):
		close()
	if event.is_action("ui_left"):
		onBtnSavePageTurn(-1)
	if event.is_action("ui_right"):
		onBtnSavePageTurn(1)
	if event.is_action("ui_down"):
		onBtnSaveDownClick()
	if event.is_action("ui_up"):
		onBtnSaveUpClick()
	# 鼠标滚轮
	if event.is_action("ui_up_mouse"):
		onBtnSavePageTurn(-1)
	if event.is_action("ui_down_mouse"):
		onBtnSavePageTurn(1)
