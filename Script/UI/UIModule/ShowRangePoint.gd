class_name ShowRangePoint extends Control

# 可飞行点
@export var texture : TextureRect

func clear():
	if is_inside_tree():
		var tween = get_tree().create_tween()
		tween.tween_property(texture , "modulate" , Color(texture.modulate, 0.0) , 0.25)
	else:
		texture.modulate = Color(texture.modulate, 0.0)
