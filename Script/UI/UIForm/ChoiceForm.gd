class_name ChoiceForm extends UIForm

#文本框主框体
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

@export var CardContainer:Container

@export var CardPrefab:PackedScene

# 能否主动取消
var esc:bool = false

# 返回值
var result

# UI初始化
func initialize(param):
	var talk_dictionary = param[0]
	var texts = param[1]
	if param.size()> 2:
		esc = param[2]
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
	#头像
	if talk_dictionary.has("face") && talk_dictionary["face"]!="":
		headboard.visible=true
		headPicture.texture = MotaSystem.resourceManager.loadFile("res://Resources/CharacterFace/"+talk_dictionary["face"])
	else:
		headboard.visible=false
		headPicture.texture = null
	#对话框背景边框
	if talk_dictionary["backGround"] == false:
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
	richtextlabel.visible = richtextlabel.text != ""
	
	# 创建选择项
	for i in range(0,texts.size()):
		var card:ChoiceCard = CardPrefab.instantiate()
		var callback = func():
			self.close.call_deferred()
			result = i
		card.initialize(texts[i],callback)
		CardContainer.add_child(card)
	updatePagePanelPosition(maintextform)

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	
	openAnim(0.2)
	focus.call_deferred()
	
func onReadyFinished():
	pass

func focus():
	CardContainer.get_child(0).btn.grab_focus.call_deferred()

func _input(event):
	# 取消
	if esc:
		if event.is_action_pressed("ui_cancel"):
			result = -1
			close()
