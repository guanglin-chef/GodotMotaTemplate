class_name BarrierEvent extends EventPage

## 检测的道具ID（0为不检查任何道具）
@export var checkItemID:int
## 数量
@export var checkItemValue:int
## 是否需要消耗道具打开障碍，消耗则会扣除对应数量的道具
@export var costItem:bool

var checkitemvalue:RichTextLabel
var checkitemvalue_path = "res://Scene/Prefab/ValueLabelPrefab/CheckItemValue.tscn"

#检测道具显示值
func enter():
	#必须是chekitemid有值且costitem为true且消耗量大于1才起效
	if(checkItemID != 0 && costItem == true && checkItemValue > 1):
		#检测是否存在label，没有则先创建一个
		if(self.get_node_or_null("CheckItemValue") == null):
			checkitemvalue = MotaSystem.resourceManager.loadFile(checkitemvalue_path).instantiate()
			self.add_child(checkitemvalue)
		else:
			checkitemvalue = get_node("CheckItemValue")
		checkitemvalue.text = "[color=#ff8080]" + str(checkItemValue) + "[/color]"
		#是否显伤
		if MotaSystem.config.getValue("MapValueDisplay","mapvaluedisplay") == true:
			checkitemvalue.visible = true
		else:
			checkitemvalue.visible = false
	super()

func start():
	# 主要逻辑
	var check_result = checkItem()
	if check_result == true:
		# 先自动存档
		MotaSystem.saveManager.AutoSave()
		# 消耗掉钥匙
		if costItem:
			MotaSystem.gameData.addItem(checkItemID,-checkItemValue)
		AudioManager.playSE("Key & Lock 2-1.wav")
		await playOpen()
	else:
		return
	# 完成后处理
	super()

func checkItem():
	var result = false
	if checkItemID == 0: # 随便开
		result = true
	else:
		if MotaSystem.gameData.getItemNum(checkItemID) >= checkItemValue:
			MotaSystem.hintForm.showHint(tr("开启门 {0} -{1}").format([tr(DatatableManager.Item.data[checkItemID].itemName),checkItemValue]))
			result = true
		else:
			MotaSystem.hintForm.showHint(tr("你没有足够的钥匙！"))
			result = false
	return result

#播放 开门动画
func playOpen():
	noDirection = false
	setEventDirection(base.name,Defination.direction.down)
	await wait(0.05)
	setEventDirection(base.name,Defination.direction.left)
	await wait(0.05)
	setEventDirection(base.name,Defination.direction.right)
	await wait(0.05)
	setEventDirection(base.name,Defination.direction.up)
	await wait(0.05)
	noDirection = true
