class_name CommonSelectCheckButton extends CheckButton

var tween: Tween
var tween_2: Tween
var focus_style = StyleBoxFlat.new()

func _ready():
	focus_style.bg_color = Color(0.83,0.92,1,0)
	focus_style.border_color = Color(1,1,1,0)
	focus_style.border_blend = true
	focus_style.border_width_left = 1
	focus_style.border_width_right = 1
	focus_style.border_width_top = 1
	focus_style.border_width_bottom = 1
	focus_style.corner_radius_bottom_left = 4
	focus_style.corner_radius_bottom_right = 4
	focus_style.corner_radius_top_left = 4
	focus_style.corner_radius_top_right = 4
	focus_style.content_margin_bottom = 4
	focus_style.content_margin_left = 4
	focus_style.content_margin_right = 4
	focus_style.content_margin_top = 4
	
	# 应用到控件
	add_theme_stylebox_override("focus", focus_style)
	
	focus_entered.connect(onFocused)
	focus_exited.connect(onFocusExit)
	mouse_entered.connect(cursorOn)
	mouse_exited.connect(cursorOff)
	
func cursorOn():
	grab_focus()

func cursorOff():
	#release_focus()
	pass

func onFocused():
	if tween:
		tween.kill()
	if tween_2:
		tween_2.kill()
	
	tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween_2 = create_tween().set_loops()
	tween_2.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(focus_style, "bg_color", Color(0.83,0.92,1,0.5), 0.75)
	tween.tween_property(focus_style, "bg_color", Color(0.83,0.92,1,0), 0.75)
	tween_2.tween_property(focus_style, "border_color", Color(1,1,1,1), 0.75)
	tween_2.tween_property(focus_style, "border_color", Color(1,1,1,0), 0.75)

func onFocusExit():
	if tween:
		tween.kill()
	if tween_2:
		tween_2.kill()
	focus_style.bg_color.a = 0.0  # 恢复透明
