class_name HightRiskTarget extends Control

# 高危目标框
@export var texture : TextureRect

var tween: Tween

func _ready():
	if tween:
		tween.kill()
		
	tween = create_tween().set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(texture, "modulate", Color(1,0,0,1), 0.75)
	tween.tween_property(texture, "modulate", Color(1,1,1,0), 0.75)
