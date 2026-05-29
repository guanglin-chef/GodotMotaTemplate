extends EffectBase

@onready
var sprite = $TextureRect

func _ready() -> void:
	pass

#func _process(delta: float) -> void:
	#pass

func play():
	# 准备工作
	var duration = 0.2
	# 
	var endPos = MotaSystem.Player.global_position
	# tween动画
	var tween = get_tree().create_tween()
	# 落点有时候会歪
	tween.tween_property(sprite, "modulate", Color(0,0,0,0), duration)
	tween.tween_callback(end)

func end(): 
	effect_end.emit()
