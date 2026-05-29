class_name ItemEvent extends EventPage

#处理道具、装备、状态获取类
enum ItemType {Item,Equip}

## 类型 
@export var type:ItemType
## 序号
@export var ID:int
## 数量
@export var value:int

var itemvalue:RichTextLabel
var itemvalue_path = "res://Scene/Prefab/ValueLabelPrefab/ItemValue.tscn"

#道具获取显示值
func enter():
	#目前仅限Type=Item类型才需要显示实际获取个数，并且数量要大于1才会显示
	if(type==ItemType.Item && value>1):
		#检测是否存在label，没有则先创建一个
		if(self.get_node_or_null("ItemValue") == null):
			itemvalue = MotaSystem.resourceManager.loadFile(itemvalue_path).instantiate()
			self.add_child(itemvalue)
		else:
			itemvalue = get_node("ItemValue")
		
		itemvalue.text = "[color=#80ffff]" + str(value) + "[/color]"
		
		#是否显伤
		if MotaSystem.config.getValue("MapValueDisplay","mapvaluedisplay") == true:
			itemvalue.visible = true
		else:
			itemvalue.visible = false
	super()

func start():
	# 主要逻辑
	if type == ItemType.Item:
		MotaSystem.gameData.addItem(ID,value)
		MotaSystem.hintForm.showHint(tr("获得{0} *{1}").format([tr(DatatableManager.Item.data[ID].itemName) , value]),cutTexture)
		AudioManager.playSE("Cursor1.wav")
	if type == ItemType.Equip:
		await getEquip(ID,value)
	# 完成后处理
	super()
