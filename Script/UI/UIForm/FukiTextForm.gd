class_name FukiTextForm extends UIForm

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

@export var nextBtn:Button

#对话文本字典
var talk_dictionary:Dictionary
# 防止触发事件的按键被立即捕获
var _input_ready:bool = false

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
	#头像
	if talk_dictionary.has("face") && talk_dictionary["face"] != "":
		headboard.visible = true
		headPicture.texture = MotaSystem.resourceManager.loadFile("res://Resources/CharacterFace/" + talk_dictionary["face"])
	else:
		headboard.visible = false
		headPicture.texture = null
	#主文本
	richtextlabel.text = tr(talk_dictionary["text"])
	
	nextBtn.pressed.connect(onBtnClick)
	

func _ready():
	#处理不同机型页面齐问题
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
	# 调整按钮大小
	nextBtn.size = Vector2(MotaSystem.CurrentMap.width * Defination.tilesize + 640,MotaSystem.CurrentMap.height * Defination.tilesize + 640)
	#动态调整文本框,主要是主文本框跟名字框+头像框x轴对齐，最长不能超过960，短了要补齐
	if(textboard.size.x < (nameboard.size.x + headboard.size.x)):
		textboard.size.x = max(nameboard.size.x + headboard.size.x, 340)
	headboard.position.x = textboard.size.x - headboard.size.x
	#计算文本框总和的xy大小
	maintextform.size.x = textboard.size.x
	maintextform.size.y = textboard.size.y
	#把nameboard和textboard的positiony强制归0，根据拥有框的内容调整固定y值
	textboard.position.y = 0
	nameboard.position.y = 0
	if nameboard.visible == true:
		maintextform.size.y = textboard.size.y + nameboard.size.y
		nameboard.position.y = 0
		textboard.position.y = 72
	if headboard.visible == true:
		maintextform.size.y = textboard.size.y + headboard.size.y
		nameboard.position.y = 178
		textboard.position.y = 250
	print(maintextform.size.y)
	##相机屏幕中心点坐标（以这个坐标为基础，代表当前屏幕中心格子的坐标系，
	##那么以这个格子上下分别+480代表当前格子的边界值）
	var windows_center_pos_x = MotaSystem.Player.playerCamera.get_screen_center_position().x
	var windows_center_pos_y = MotaSystem.Player.playerCamera.get_screen_center_position().y
	var windows_top_x = windows_center_pos_x - 480
	var windows_buttom_x = windows_center_pos_x + 480
	var windows_top_y = windows_center_pos_y - 480
	var windows_buttom_y = windows_center_pos_y + 480
	#文本框坐标系
	if talk_dictionary["eventName"] != "":
		if(talk_dictionary["eventName"] != "Player"):
			var targetPos = MotaSystem.CurrentMap.events.get_node(talk_dictionary["eventName"]).position
			maintextform.position.x = targetPos.x + 32 - maintextform.size.x / 2
			maintextform.position.y = targetPos.y - maintextform.size.y
			# 检测文本一半长度+事件坐标x位置，如果超过windows_buttom_x意味着fuki会右超界，要回调
			if targetPos.x + 32 + maintextform.size.x / 2 > windows_buttom_x:
				maintextform.position.x = windows_buttom_x - maintextform.size.x
		else:
			maintextform.position.x = MotaSystem.Player.position.x + 32 - maintextform.size.x / 2
			maintextform.position.y = MotaSystem.Player.position.y - maintextform.size.y
			# 检测文本一半长度+事件坐标x位置，如果超过windows_buttom_x意味着fuki会右超界，要回调
			if MotaSystem.Player.position.x + 32 + maintextform.size.x / 2 > windows_buttom_x:
				maintextform.position.x = windows_buttom_x - maintextform.size.x
	# 最终调整如果position坐标系小于windows的xy_top，则意味着上或者左边界超界，要回调
	# 所以fuki要时刻注意主动换行，不然容易形成文本长度本身严重超界的问题，坐标系无论如何都调不回来
	if maintextform.position.x < windows_top_x:
		maintextform.position.x = windows_top_x
	if maintextform.position.y < windows_top_y:
		maintextform.position.y = windows_top_y
	updatePagePanelPosition(maintextform)
	# 等待一帧后才允许接收输入，避免触发事件的空格键立即关闭第一句对话
	await get_tree().process_frame
	_input_ready = true

func onBtnClick():
	close()

func _input(event):
	if not _input_ready:
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("fast_text"):
		get_viewport().set_input_as_handled()
		close()
	# 空格键确认
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		AudioManager.playSE("UIcertain.wav")
		close()
