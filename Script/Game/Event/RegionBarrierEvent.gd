class_name RegionBarrierEvent extends EventPage

## 检测的道具ID（0为不检查任何道具）
@export var checkItemID:int
## 数量
@export var checkItemValue:int
## 是否需要消耗道具打开障碍，消耗则会扣除对应数量的道具
@export var costItem:bool
## 点位
@export var checkedPositions:Array[Vector2i]

var open : bool = false

func start():
	# 主要逻辑
	if !checkPositionsHaveMonster() || open:
		if checkAndCostItem():
			MotaSystem.Player.wait_event.append(self)
			AudioManager.playSE("Key & Lock 2-1.wav")
			await playOpen()
			MotaSystem.Player.wait_event.erase(self)
		else:
			return
	else:
		return
	# 完成后处理
	super()

func flash():
	for pos in checkedPositions:
		# 提示特效
		MotaSystem.effectManager.showEffectOnNode(DatatableManager.Effect.data[118]["path"], MotaSystem.CurrentMap, Utility.tilePos2WorldPos(pos), 100)

func checkPositionsHaveMonster() -> bool:
	var result = false
	for pos in checkedPositions:
		if MotaSystem.CurrentMap.EventGrid.has(pos):
			var events = MotaSystem.CurrentMap.EventGrid[pos]
			for event in events:
				if !event.isDead:
					if event.current_page is MonsterEvent:
						result = true
						break
	return result

func checkAndCostItem() -> bool:
	if checkItemID == 0: # 随便开
		return true
	else:
		if MotaSystem.gameData.getItemNum(checkItemID) >= checkItemValue:
			if costItem:
				MotaSystem.gameData.addItem(checkItemID,-checkItemValue)
				MotaSystem.hintForm.showHint(tr("开启门 {0} -{1}").format([DatatableManager.Item.data[checkItemID].itemName,checkItemValue]))
			return true
		else:
			MotaSystem.hintForm.showHint(tr("你没有足够的钥匙！"))
			return false

#播放 开门动画
func playOpen():
	setEventDirection(base.name,Defination.direction.down)
	await wait(0.05)
	if self == null:
		return
	setEventDirection(base.name,Defination.direction.left)
	await wait(0.05)
	if self == null:
		return
	setEventDirection(base.name,Defination.direction.right)
	await wait(0.05)
	if self == null:
		return
	setEventDirection(base.name,Defination.direction.up)
