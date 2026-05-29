class_name ItemPerfab extends CommonSelectButton

#按钮
@export var ItemButton:Button
#图标
@export var ItemIcon:TextureRect
#层数
@export var ItemCount:Label

var item_id:int

func initialize(Item_id):
	item_id = Item_id
	#图标
	ItemIcon.texture = load("res://Resources/Icon/item/" + DatatableManager.Item.data[item_id]["itemPictrueName"])
	#数量
	ItemCount.text = "x" + str(MotaSystem.gameData.item[str(item_id)])
