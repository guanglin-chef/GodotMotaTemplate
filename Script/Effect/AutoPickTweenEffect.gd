extends EffectBase

@onready
var sprite = $Sprite2D

# 跳跃用变量
var jumpPeak = 0
var jumpCount = 0
# 跳跃平移标定变量
var translationPos:Vector2
# jumping?
var jumping:
	get:
		return jumpCount > 0

func _ready() -> void:
	pass

func _process(delta):
	if jumping:
		jump_update(delta)
	else:
		end()

func play():
	# 由于特效并不在地图viewport内，因此不能简单的全用globalposition
	jump(MotaSystem.Player.position.x - self.position.x, MotaSystem.Player.position.y - self.position.y)

func end(): 
	effect_end.emit()

func initialize(param = null):
	if param != null:
		var textureRes = param[0]
		var startFrame = param[1]
		sprite.texture = textureRes
		sprite.frame = startFrame
		
func jump(x_plus,y_plus):
	translationPos = self.position
	# 距计算距离
	var distance = round(sqrt(x_plus * x_plus + y_plus * y_plus) / Defination.tilesize) 
	# 设置跳跃记数
	
	jumpPeak = 10 + distance - 5  #speed
	#print(jumpPeak)
	jumpCount = jumpPeak * 2

func jump_update(delta):
	# 跳跃计数减 1
	jumpCount -= 1
	# 计算新坐标
	translationPos.x = (translationPos.x * jumpCount + MotaSystem.Player.global_position.x) / (jumpCount + 1)
	translationPos.y = (translationPos.y * jumpCount + MotaSystem.Player.global_position.y) / (jumpCount + 1)
	# 取跳跃计数小的 Y 坐标
	var n
	if jumpCount >= jumpPeak:
		n = jumpCount - jumpPeak
	else:
		n = jumpPeak - jumpCount
		
	self.position = Vector2(translationPos.x, translationPos.y - (jumpPeak * jumpPeak - n * n) )# / 2)
