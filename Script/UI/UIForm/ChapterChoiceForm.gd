class_name ChapterChoiceForm extends UIForm

# 章节选择框体
@export var ChapterChoiceFormBoard:PanelContainer
## 章节按钮组
@export var ChapterBtns:Array[Button]
# 返回标题画面按钮
@export var ReturnBtn:Button

var chapter_names:Array[String] = []
	
func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	ChapterBtns[0].grab_focus.call_deferred()
	self.openAnim(0.15)
	
func initialize(param):
	createChapterNames()
	ReturnBtn.pressed.connect(onBtnReturnClick)
	ChapterBtns[0].pressed.connect(onChapterC1ButtonClick)
	
	## 这块用来写章节是否解锁的条件
	## 实例
	for i in chapter_names.size():
		if i != 0:
			if GameFirstData.test == true:
				ChapterBtns[i].pressed.connect(onChapterLoadButtonClick.bind(chapter_names[i]))
			else:
				ChapterBtns[i].text = tr("章节未解锁")
				ChapterBtns[i].modulate = Color(0.5,0.5,0.5)
				ChapterBtns[i].remove_theme_constant_override("outline_size")
				ChapterBtns[i].disabled = true
	# config中存有的章节和bool值代表章节是否通关，通关的话会给这个章节前加一个标记
	for i in chapter_names.size():
		if MotaSystem.config.getValue(GameFirstData.gameIdentifier,chapter_names[i]) == true:
			if ChapterBtns[i].disabled == false:
				ChapterBtns[i].get_child(0).texture = MotaSystem.resourceManager.loadFile("res://Resources/Icon/equip/Equip1.png")
	updatePagePanelPosition(ChapterChoiceFormBoard)
	
# 创建章节数量
func createChapterNames():
	for i in range(GameFirstData.gameChapters):
		chapter_names.append("Chapter" + str(i + 1))
	
func onBtnReturnClick():
	close()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		onBtnReturnClick()
		
func onChapterC1ButtonClick():
	AudioManager.stopBGM()
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.2)
	tween.tween_callback(func():
		MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainGame)
	)

func onChapterLoadButtonClick(chapter_name:String):
	var chapterName:String = GameFirstData.gameIdentifier + chapter_name
	var save = MotaSystem.saveManager.getChapterSaveFile(chapterName)
	if save:
		MotaSystem.saveManager.ChapterSaveLoad(chapterName)
	else:
		await MotaSystem.uiManager.openTillClose(Defination.UIID.PopUpForm,tr("未检测到相应章节存档，无法读取！"))
