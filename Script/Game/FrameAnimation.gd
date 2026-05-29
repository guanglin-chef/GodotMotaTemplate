# 所有GameCharacter旗下所用Sprite节点的基类
class_name FrameAnimation extends Sprite2D

## MT插件支持
@export var meta_addon_mt_parse_property = true

## 停止时动画
@export var idleAnim:bool = false
## 移动时动画
@export var movingAnim:bool = true
## 固定朝向
@export var noDirection:bool = false

# GameCharacter
var character:GameCharacter

# --动画用变量--
var isMoving:bool # 和GameCharacter中的moving有微妙的区别
var isPlaying:bool
var stopAnim:bool
#动画帧间隔
var frameTime
# time
var time:float

func _ready():
	# 初始化父节点引用
	character = get_parent()
	# 初始化offset 
	if texture != null:
		self.offset =  Vector2((Defination.tilesize - 1.0* texture.get_width() / vframes) / 2,1.0*(Defination.tilesize - 1.0* texture.get_height() / hframes))
	
	# 初始化动画变量
	isPlaying = false
	time = 0
	# 初始化动画组件
	if (movingAnim || idleAnim):
		if movingAnim:
			frameTime = 0.5 / character.speed
		if idleAnim:
			frameTime = 0.3
			playIdle()
	else:
		frameTime = 0.3

func _process(delta):
	if !isPlaying:
		return
	time += delta
	var index = floori(time/frameTime)
	if idleAnim || (movingAnim && isMoving):
		while index >= 4:
			index -= 4
			time -= (4 * frameTime)
		self.frame = character.dir * 4 + index
		if stopAnim:
			if (index == 0 || index == 2):
				isPlaying = false
				time = 0
				isMoving = false

func playMoving():
	isPlaying = true
	isMoving = true
	stopAnim = false

func playIdle():
	isPlaying = true
	isMoving = false

func stop():
	stopAnim = true
