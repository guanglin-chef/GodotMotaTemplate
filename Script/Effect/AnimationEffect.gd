extends EffectBase

@export var animationName:StringName

@export var animation:AnimationPlayer

## 该动画所属库名，不填默认调用全局库
@export var animation_library:StringName

var anim_path:String

func _ready() -> void:
	pass

func play():
	if animation_library != "":
		anim_path = animation_library + "/" + animationName
	else:
		anim_path = animationName
	animation.play(anim_path)
	
func play_locus():
	var anim = animation.get_animation(animationName)
	var position_path:String = "..:position"
	var position_track_index = anim.find_track(position_path,Animation.TYPE_VALUE)
	anim.track_set_key_value(position_track_index,0,self.position)

	if animation_library != "":
		anim_path = animation_library + "/" + animationName
	else:
		anim_path = animationName
	animation.play(anim_path)
