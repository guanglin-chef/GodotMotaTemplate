class_name EquipPoolPerfab extends CommonSelectButton

#按钮
@export var EquipPoolButton:Button
#图标
@export var EquipPoolIcon:TextureRect

var equip_id:int

func initialize(Equip_id):
	equip_id = Equip_id
	#图标
	EquipPoolIcon.texture = load("res://Resources/Icon/equip/" + DatatableManager.Equip.data[equip_id]["equipIcon"])
