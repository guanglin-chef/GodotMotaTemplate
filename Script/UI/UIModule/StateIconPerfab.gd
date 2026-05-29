class_name StateIconPerfab extends CommonSelectButton

#按钮
@export var StateButton:Button
#图标
@export var StateIcon:TextureRect
#层数
@export var StateLevel:Label

#状态id
var state_id:int
#状态层数
var state_value:int

func initialize(state_id):
	#获取状态图标
	StateIcon.texture = MotaSystem.resourceManager.loadFile("res://Resources/Icon/state/" + DatatableManager.State.data[state_id]["stateIcon"])
	#检索是否存在该状态
	if MotaSystem.m_GameManager.m_GameData.state.has(str(state_id)):
		state_value = MotaSystem.m_GameManager.m_GameData.state[str(state_id)]
	else:
		StateLevel.text = ""
		return
	#获取状态层数
	StateLevel.text = Utility.fuck(state_value)
	if state_value == DatatableManager.State.data[state_id]["stateMax"] and state_value != 0:
		StateLevel.text = "MAX"
		StateLevel.add_theme_color_override("font_color",Color(1,0.92,0,1))
	else:
		StateLevel.add_theme_color_override("font_color",Color(0.5,1,1,1))
