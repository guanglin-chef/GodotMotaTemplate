class_name EquipPerfab extends UIForm

#按钮
@export var EquipButton:Button
#图标
@export var EquipIcon:TextureRect
#类型
@export var EquipType:Label

#装备槽位
var equip_slot:String
#装备槽位序号
var equip_slot_index:int
#装备id
var equip_id = null
## 需要用作额外本地化处理的对象（装备类别）
@export var localization_texts:Array[Node]

func initialize(EquipSlot):
	equip_slot = EquipSlot
	equip_slot_index = MotaSystem.gameData.equip_slot.find(equip_slot)
	refresh()
	
func onReadyFinished():
	#更新文本长度
	Utility.changeTextForLocalization(localization_texts,24)
		
func refresh():
	print(MotaSystem.gameData.equip[equip_slot] != null)
	if MotaSystem.gameData.equip[equip_slot] != null:
		equip_id = MotaSystem.gameData.equip[equip_slot].to_int()
	else:
		equip_id = null
	#槽位名称
	EquipType.text = Defination.Equip_Type[equip_slot_index]
	EquipType.tooltip_text = Defination.Equip_Type[equip_slot_index]
	#装备图标
	if equip_id != null:
		EquipIcon.texture = load("res://Resources/Icon/equip/"+DatatableManager.Equip.data[equip_id]["equipIcon"])
	else:
		EquipIcon.texture = null
