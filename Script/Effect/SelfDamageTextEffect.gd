extends EffectBase

@onready
var label = $Label

var damage:int
# 跳字动画时间
const duration = 1.2

var height = -250

# tween动画
var tween
var tween2

func _ready() -> void:
	pass

#func _process(delta: float) -> void:
	#pass

func play():
	tween2.tween_property(self,"position", position + Vector2(0, height), duration)
	tween.tween_property(self,"modulate", Color(1,1,1,0), duration)
	tween.tween_callback(end)

func end(): 
	effect_end.emit()

func initialize(param = null):
	damage = param[0]
	
	label.text = Utility.fuck(damage).trim_prefix("-")
	
	tween = get_tree().create_tween()
	tween2 = get_tree().create_tween()
