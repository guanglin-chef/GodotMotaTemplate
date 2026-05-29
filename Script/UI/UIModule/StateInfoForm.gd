class_name StateInfoForm extends UIForm

#技能详情框
@export
var statemainform:ReferenceRect
#状态名称
@export
var StateName:Label
#状态类型
@export
var StateType:RichTextLabel
#状态描述
@export
var StateText:RichTextLabel
#退出按钮
@export
var closebutton:TextureButton
#状态详情子框
@export
var statechildpanel:Array[PanelContainer]

#状态编号
var state_id:int

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	
	self.openAnim(0.2)
	closebutton.pressed.connect(onBtnCloseClick)
	
func onReadyFinished():
	closebutton.size = get_viewport().size
	updatePagePanelPosition(closebutton)
	#PC端
	if Utility.isPcMode():
		statechildpanel[0].position.x = 1280 - statechildpanel[1].size.x - statechildpanel[0].size.x
		statechildpanel[1].position.x = 1280 - statechildpanel[1].size.x
	#移动端
	else:
		var max_y:float = 0
		max_y = maxf(statechildpanel[0].size.y,statechildpanel[1].size.y)
		statechildpanel[0].position.y = 1280 - max_y
		statechildpanel[1].position.y = 1280 - max_y
	#彻底调完位置后，透明度恢复
	statemainform.modulate=Color(1,1,1,1)	
	
func initialize(param):
	#避免闪现的情况，先把透明度归零
	statemainform.modulate=Color(1,1,1,0)
	state_id = param
	StateName.text = tr(DatatableManager.State.data[state_id]["stateName"])
	# 状态类型
	var state_type_id:int = DatatableManager.State.data[state_id]["stateType"]
	var state_type_string:String = ""
	match state_type_id:
		0:
			state_type_string += "[center][color=#ffff80]"
		1:
			state_type_string += "[center][color=#80ffff]"
		2:
			state_type_string += "[center][color=#ff8080]"
		3:
			state_type_string += "[center][color=#80ffff]"
		4:
			state_type_string += "[center][color=#ff80c0]"
	state_type_string += tr(Defination.State_Type[state_type_id]) + "[/color][/center]"
	StateType.text = state_type_string
	# 描述文本
	var format_skillnote = MotaSystem.m_GameManager.m_GameData.getStateInfo(state_id)
	# 生成文本
	StateText.text = format_skillnote
	
func onBtnCloseClick():
	close()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		onBtnCloseClick()
