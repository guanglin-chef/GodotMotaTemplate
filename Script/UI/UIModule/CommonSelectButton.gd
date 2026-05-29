class_name CommonSelectButton extends Button

# 需要搭配SelectButtonTheme使用
# 仅限于选项框中的按钮用，普通按钮先直接使用Button
# 选中特效
var selectedTexture:NinePatchRect
var selectedTextureNodepath = "res://Scene/UI/UIModule/CommonSelectButtonFocusStyle.tscn"

# 闪烁动画
var tween:Tween
var duration = 0.75

# 上级
var board

func _ready():
	# 全自动加入特效
	selectedTexture = MotaSystem.m_ResourceManager.loadFile(selectedTextureNodepath).instantiate()
	add_child(selectedTexture)
	selectedTexture.size = self.size
	selectedTexture.visible = false
	# 链接
	focus_entered.connect(onFocused)
	focus_exited.connect(onFocusExit)
	mouse_entered.connect(cursorOn)
	mouse_exited.connect(cursorOff)

# 光标移上去就直接focus
func cursorOn():
	grab_focus()

# 还是不去掉的好
func cursorOff():
	#release_focus()
	pass

func onFocused():
	selectedTexture.size = self.size
	selectedTexture.visible = true
	selectedTexture.modulate = Color(1,1,1,1)
	tween = create_tween()
	tween.tween_property(selectedTexture, "modulate", Color(1,1,1,0), duration)
	tween.tween_property(selectedTexture, "modulate", Color(1,1,1,1), duration)
	tween.set_loops()

func onFocusExit():
	selectedTexture.visible = false
	tween.kill()
