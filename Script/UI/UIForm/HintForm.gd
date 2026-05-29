class_name HintForm extends UIForm


@export var hint:Control

@export var label:Label

@export var iconNode:TextureRect

var tween 
var tween2

# 前期动画时长
const duration = 0.25
# 等待时长
const interval =2

# UI初始化
func initialize(param):
	pass

func _ready():
	pass
	#处理不同机型页面齐问题
	#updateGameScreen()
	#updatePagePanelPosition(enemystateform)
	#updatePagePanelPosition(hint)

func showHint(text:String, icon:Texture2D = null):
	if icon:
		iconNode.visible = true
		iconNode.texture = icon
	else:
		iconNode.visible = false
	self.visible = false
	self.visible = true
	label.text = tr(text)
	if tween:
		tween.kill()
	if tween2:
		tween2.kill()
	tween = create_tween()
	tween2 = create_tween()
	#PC端
	if Utility.isPcMode():
		hint.position = Vector2(320, 20)
		tween.tween_property(hint, "position", Vector2(320, 0), duration)
		tween.tween_interval(interval)
		tween.tween_property(hint, "position", Vector2(320, -20), duration)
	#移动端
	else:
		hint.position = Vector2(0, 340)
		tween.tween_property(hint, "position", Vector2(0, 320), duration)
		tween.tween_interval(interval)
		tween.tween_property(hint, "position", Vector2(0, 300), duration)
	hint.modulate = Color(1,1,1,0)
	tween2.tween_property(hint, "modulate" , Color(1,1,1,1), duration)
	tween2.tween_interval(interval)
	tween2.tween_property(hint, "modulate" , Color(1,1,1,0), duration)
