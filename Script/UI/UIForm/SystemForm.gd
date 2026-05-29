class_name SystemForm extends UIForm

# 系统设置框体
@export var SystemFormBoard:PanelContainer
# 系统设置按钮
@export var SettingBtn:Button
# 按键设置按钮
@export var KeyPressBtn:Button
# 地图预览按钮
@export var MapPreviewBtn:Button
# 退出地图预览按钮
@export var ExitMapPreviewBtn:Button
# 打开存档路径文件夹
@export var OpenSaveBtn:Button
# 返回标题画面按钮
@export var ReturnTitleBtn:Button
# 取消并返回按钮
@export var ReturnBtn:Button

#-----------------------------------------------------------

# 所选中系统按钮
var select_system_btn:Button

#------------------------------------------------------------

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	#调整上下聚焦
	ReturnBtn.focus_neighbor_bottom = SettingBtn.get_path()
	SettingBtn.focus_neighbor_top = ReturnBtn.get_path()
	ReturnBtn.grab_focus.call_deferred()
	self.openAnim(0.15)
	
func initialize(param):
	SettingBtn.pressed.connect(onBtnSettingClick)
	KeyPressBtn.pressed.connect(onBtnKeyPressClick)
	MapPreviewBtn.pressed.connect(onBtnMapPreviewClick)
	ExitMapPreviewBtn.pressed.connect(onBtnMapPreviewClick)
	OpenSaveBtn.pressed.connect(onBtnOpenSaveClick)
	ReturnTitleBtn.pressed.connect(onBtnReturnTitleClick)
	ReturnBtn.pressed.connect(onBtnReturnClick)
	if MotaSystem.m_GameManager != null:
		MapPreviewBtn.visible = true
		ReturnTitleBtn.visible = true
		if MotaSystem.gameVariables["ufo"]:
			MapPreviewBtn.visible = false
			ExitMapPreviewBtn.visible = true
		else:
			MapPreviewBtn.visible = true
			ExitMapPreviewBtn.visible = false
	else:
		MapPreviewBtn.visible = false
		ExitMapPreviewBtn.visible = false
		ReturnTitleBtn.visible = false
	updatePagePanelPosition(SystemFormBoard)
	
func onBtnSettingClick():
	select_system_btn = SettingBtn
	await openSubForm_2(Defination.UIID.SettingForm,self)
	
func onBtnMapPreviewClick():
	select_system_btn = MapPreviewBtn
	if !MotaSystem.gameVariables["ufo"]:
		select_system_btn = MapPreviewBtn
		MotaSystem.gameManager.startUFO()
	else:
		select_system_btn = ExitMapPreviewBtn
		MotaSystem.gameManager.endUFO()
	close()
	
func onBtnOpenSaveClick():
	var os_path = ProjectSettings.globalize_path("user://" + str(GameFirstData.gameIdentifier))
	OS.shell_show_in_file_manager(os_path)
	
func onBtnReturnTitleClick():
	MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainMenu)	
	
func onBtnKeyPressClick():
	select_system_btn = KeyPressBtn
	await openSubForm_2(Defination.UIID.KeySettingForm,self)

func onBtnReturnClick():
	close()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu") or event.is_action_pressed("call_menu"):
		close()
