class_name PopUpChooseForm extends UIForm

@export var mask:Control

@export var label:Label

@export var confirmbtn:Button

@export var cancelbtn:Button

var tween 

# 前期动画时长
const duration = 0.2
# 等待时长
const interval = 2
# 返回值
var result:bool = false

# UI初始化
func initialize(param):
	label.text = param

func _ready():
	confirmbtn.pressed.connect(press_confirm)
	cancelbtn.pressed.connect(press_cancel)
	tween = create_tween()
	tween.tween_property(mask,"size",Vector2(960,960),duration)
	tween.tween_interval(interval)
	#tween.tween_callback(press_cancel)
	cancelbtn.grab_focus.call_deferred()

func onBtnClick():
	result = false
	close()
	
func press_confirm():
	result = true
	close()
	
func press_cancel():
	result = false
	close()
