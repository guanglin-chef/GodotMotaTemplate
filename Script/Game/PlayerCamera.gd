class_name PlayerCamera extends Camera2D

var strength = 10

var shakelength = 3

var count = 0

var shake_switcher = false

var scaleNum = 1

var minScale = 1

var maxScale = 1

var scaleStep = 0.05

func _ready() -> void:
	scaleNum = 1
	updateCamera()

func _process(delta: float) -> void:
	if shake_switcher:
		count += 1
		if count == shakelength:
			self.offset = Vector2(randf_range(-strength,strength),randf_range(-strength,strength))
			count -= shakelength

func shakeOn(strength:int, shakelength:int):
	self.strength = strength
	self.shakelength = shakelength
	shake_switcher = true

func shakeOff():
	shake_switcher = false
	self.offset = Vector2(0,0)

func scaleDown():
	if scaleNum - scaleStep >= minScale:
		scaleNum -= scaleStep
		updateCamera()

func scaleUp():
	if scaleNum + scaleStep <= maxScale:
		scaleNum += scaleStep
		updateCamera()

func updateCamera():
	minScale = min(1,(15.0 / min(MotaSystem.CurrentMap.width, MotaSystem.CurrentMap.height)))
	minScale = max(0.5, minScale)
	
	zoom = Vector2(scaleNum,scaleNum)

func changeMapUpdateCamera(width, height):
	limit_left = 0
	limit_right = width * Defination.tilesize - 1
	limit_bottom = height * Defination.tilesize - 1
	scaleNum = 1
	minScale = min(1,(15.0 / min(width, height)))
	minScale = max(0.5, minScale)
	zoom = Vector2(scaleNum,scaleNum)

func resetScale():
	while scaleNum < 1:
		scaleNum += scaleStep
		updateCamera()
