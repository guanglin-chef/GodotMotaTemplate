class_name MainForm extends UIForm

@export
var MainFormPanel:Panel
@export
var StartButton:Button
@export
var LoadButton:Button
@export
var SetButton:Button
@export
var ExitButton:Button

@export
var Bgm_Name:String = ""
@export
var Bgm_Offset:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	updatePagePanelPosition(MainFormPanel)
	
	StartButton.pressed.connect(onStartButtonClick)
	LoadButton.pressed.connect(onBtnLoadClick)
	SetButton.pressed.connect(onBtnSystemClick)
	ExitButton.pressed.connect(onBtnExitClick)
	
	#检测BGM是否为空
	if(Bgm_Name.is_empty() == false):
		AudioManager.playBGM(Bgm_Name, Bgm_Offset)
	if MotaSystem.saveManager.haveSaveFile():
		LoadButton.grab_focus.call_deferred()
	else:
		StartButton.grab_focus.call_deferred()

func onStartButtonClick():
	await openSubForm_3(Defination.UIID.ChapterChoiceForm)
	StartButton.grab_focus()

func onBtnLoadClick():
	await openSubForm_3(Defination.UIID.SaveForm, false)
	LoadButton.grab_focus()

func onBtnSystemClick():
	await openSubForm_3(Defination.UIID.SystemForm)
	SetButton.grab_focus()
	
func onBtnExitClick():
	# 保存本次游戏时长后再退出
	MotaSystem.savePlayTime()
	PlatformWrapper.restart()
	#get_tree().quit()
