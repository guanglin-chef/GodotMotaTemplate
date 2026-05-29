class_name PopUpForm extends UIForm


@export var mask:Control

@export var label:Label

@export var btn:Button

var tween 

# 前期动画时长
const duration = 0.2
# 等待时长
const interval = 1.5

# UI初始化
func initialize(param):
	label.text = param
	updatePagePanelPosition(mask)

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	btn.size = get_viewport().size
	
	btn.pressed.connect(onBtnClick)
	
	tween = create_tween()
	tween.tween_property(mask,"size",Vector2(960,960),duration)
	tween.tween_interval(interval)
	tween.tween_callback(onBtnClick)

func onBtnClick():
	close()

func _input(event):
	if event.is_action_pressed("fast_text"):
		close()
	# 空格键确认
	if event.is_action_pressed("ui_accept"):
		close()
