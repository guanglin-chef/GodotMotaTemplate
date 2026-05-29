class_name IconTextForm extends UIForm

#道具获取提示panel
@export var iconTextFormPanel:PanelContainer
#文本框主框体
@export var maintextform:Control
#主文本框
@export var textboard:PanelContainer
#主文本
@export var richtextlabel:RichTextLabel
#名称
@export var nametextlabel:RichTextLabel
#icon
@export var IconPicture:TextureRect
#icon
@export var IconPictureBoard:Control

@export var nextBtn:Button

#对话文本字典
var talk_dictionary:Dictionary

# UI初始化
func initialize(dic):
	talk_dictionary = dic

	#主文本
	richtextlabel.text=tr(talk_dictionary["Text"])
	# 名称
	nametextlabel.text=tr(talk_dictionary["Name"])
	#icon
	if talk_dictionary.keys().has("Icon"):
		IconPicture.texture = MotaSystem.resourceManager.loadFile(talk_dictionary["Icon"])
		IconPictureBoard.visible = true
	else:
		IconPictureBoard.visible = false
	
	nextBtn.pressed.connect(onBtnClick)
	updatePagePanelPosition(iconTextFormPanel)

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	nextBtn.size = get_viewport().size
	
	# 对话跳过模式
	if Input.is_action_pressed("fast_text"):
		if Input.is_action_pressed("fast_text_2"):
			var tween = create_tween()
			tween.tween_interval(0.01)
			tween.tween_callback(close)
		else:
			self.modulate = Color(1,1,1,0)
			var tween = create_tween()
			tween.tween_property(self, "modulate", Color.WHITE, 0.075)
			tween.tween_callback(close)
	# 不跳过就正常播淡入动画
	else:	
		openAnim(0.2)

func onBtnClick():
	close()

func _input(event):
	if event.is_action_pressed("fast_text"):
		close()
	# 空格键确认
	if event.is_action_pressed("ui_accept"):
		AudioManager.playSE("UIcertain.wav")
		close()
