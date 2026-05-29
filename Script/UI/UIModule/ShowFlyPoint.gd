class_name ShowFlyPoint extends Control

# 可飞行点
@export var CanFlyPoint:TextureRect

# 不可飞行点
@export var CanNotFlyPoint:TextureRect

#是否可飞
var can_fly:bool
#飞点坐标
var fly_point:Vector2

func initialize(param):
	fly_point = param[0]
	can_fly = param[1]
	CanFlyPoint.visible = false
	CanNotFlyPoint.visible = false
	updateShowFlyPoint()
	
func updateShowFlyPoint():
	self.position = fly_point * Defination.tilesize
	if can_fly == true:
		CanFlyPoint.visible = true
		CanNotFlyPoint.visible = false
	else:
		CanFlyPoint.visible = false
		CanNotFlyPoint.visible = true
