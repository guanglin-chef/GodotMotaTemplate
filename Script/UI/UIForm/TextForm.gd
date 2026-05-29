class_name TextForm extends UIForm

#文本界面主框体
@export var TextFormBoard:PanelContainer
#文本框主体
@export var maintextform:Control
#名字框
@export var nameboard:PanelContainer
#名字
@export var namerichtextlabel:RichTextLabel
#小图像行走图
@export var battlerPicuture:TextureRect
#头像框
@export var headboard:PanelContainer
#头像
@export var headPicture:TextureRect
#主文本框
@export var textboard:PanelContainer
#主文本
@export var richtextlabel:RichTextLabel

@export var nextBtn:Button

#对话文本字典
var talk_dictionary:Dictionary

# UI初始化
func initialize(dic):
	if (MotaSystem.CurrentMap.EnemyStateForm != null):
		MotaSystem.CurrentMap.EnemyStateForm.close()
		MotaSystem.CurrentMap.EnemyStateForm = null
	talk_dictionary = dic
	#名字
	if talk_dictionary["name"] != "":
		namerichtextlabel.visible = true
		namerichtextlabel.text = tr(talk_dictionary["name"])
	else:
		namerichtextlabel.visible = false
	#小图像行走图
	if talk_dictionary.has("battlersPicture") && talk_dictionary["battlersPicture"] != "":
		nameboard.visible = true
		battlerPicuture.visible = true
		battlerPicuture.texture = MotaSystem.resourceManager.loadFile("res://Resources/Icon/battler/" + talk_dictionary["battlersPicture"])
	else:
		battlerPicuture.visible = false
		battlerPicuture.texture = null
	# 当名字和小图标都没有对象时，才会关闭整个nameboard
	if namerichtextlabel.visible == false and battlerPicuture.visible == false:
		nameboard.visible = false
	#大头像
	if talk_dictionary.has("face") && talk_dictionary["face"]!="":
		headboard.visible=true
		headPicture.texture = MotaSystem.resourceManager.loadFile("res://Resources/CharacterFace/"+talk_dictionary["face"])
	else:
		headboard.visible=false
		headPicture.texture = null
	#对话框背景边框
	if talk_dictionary.has("backGround") && talk_dictionary["backGround"] == false:
		headboard.self_modulate = Color(1,1,1,0)
		nameboard.self_modulate = Color(1,1,1,0)
		textboard.self_modulate = Color(1,1,1,0)
	#对话框上中下坐标
	if talk_dictionary["textPos"] != "":
		match talk_dictionary["textPos"]:
			"Up":
				maintextform.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
			"Center":
				maintextform.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			"Down":
				maintextform.size_flags_vertical = Control.SIZE_SHRINK_END

	#主文本
	richtextlabel.text=tr(talk_dictionary["text"])
	
	nextBtn.pressed.connect(onBtnClick)
	updatePagePanelPosition(TextFormBoard)

func _ready():
	updateGameScreen()
	nextBtn.size = get_viewport().size
	
	# 对话跳过模式
	if Input.is_action_pressed("fast_text"):
		self.modulate = Color(1,1,1,0)
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 0.075)
		tween.tween_callback(close)
	# 不跳过就正常播淡入动画
	else:	
		openAnim(0.2)
		
func onReadyFinished():
	pass

func onBtnClick():
	close()

func _input(event):
	if event.is_action_pressed("fast_text"):
		get_viewport().set_input_as_handled()
		close()
	# 空格键确认
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		AudioManager.playSE("UIcertain.wav")
		close()
