extends EventPage

# ShopEvent
# 商店事件，由于需要在很多地方的代码中调用因此设置为特别事件

const hp_times = 500

func start():
	
	var textDic = {}
	textDic["name"] = tr("商店")
	textDic["backGround"] = true
	textDic["textPos"] = "Down"
	textDic["text"] = tr("本次提升能力需要{0}金币").format([int(MotaSystem.gameVariables["shopPrice"])])
	
	var choiceText = [
		tr("提升{0}攻击").format([int(MotaSystem.gameVariables["shopValue"])]),
		tr("提升{0}防御").format([int(MotaSystem.gameVariables["shopValue"])]),
		tr("提升{0}生命").format([int(MotaSystem.gameVariables["shopValue"]) * hp_times])
	]
	var choiceCallback = [addAtk,addDef,addHp]
	var result = await MotaSystem.uiManager.openTillReturn(Defination.UIID.ChoiceForm,[textDic,choiceText,true])
	
	if result != -1:
		var next = await choiceCallback[result].call()
		if next:
			MotaSystem.gameEventManager.pushSpecialEvent.call_deferred(Defination.SpecialEventType.ShopEvent)
	# 完成后处理
	super()

func addAtk():
	if MotaSystem.gameData.gold >= MotaSystem.gameVariables["shopPrice"]:
		MotaSystem.gameData.gold -= int(MotaSystem.gameVariables["shopPrice"])
		MotaSystem.gameData.base_atk += int(MotaSystem.gameVariables["shopValue"])
		MotaSystem.gameVariables["shopPrice"] += MotaSystem.gameVariables["shopIncrease"]
		return true
	else:
		var textDic = {}
		textDic["name"] = tr("商店")
		textDic["backGround"] = true
		textDic["textPos"] = "Down"
		textDic["text"] = tr("没钱是想死吗？")
		await showText(textDic)
		return false

func addDef():
	if MotaSystem.gameData.gold >= MotaSystem.gameVariables["shopPrice"]:
		MotaSystem.gameData.gold -= int(MotaSystem.gameVariables["shopPrice"])
		MotaSystem.gameData.base_def += int(MotaSystem.gameVariables["shopValue"])
		MotaSystem.gameVariables["shopPrice"] += MotaSystem.gameVariables["shopIncrease"]
		return true
	else:
		var textDic = {}
		textDic["name"] = tr("商店")
		textDic["backGround"] = true
		textDic["textPos"] = "Down"
		textDic["text"] = tr("没钱是想死吗？")
		await showText(textDic)
		return false
		
func addHp():
	if MotaSystem.gameData.gold >= MotaSystem.gameVariables["shopPrice"]:
		MotaSystem.gameData.gold -= int(MotaSystem.gameVariables["shopPrice"])
		MotaSystem.gameData.hp += int(MotaSystem.gameVariables["shopValue"]) * hp_times
		MotaSystem.gameVariables["shopPrice"] += MotaSystem.gameVariables["shopIncrease"]
		return true
	else:
		var textDic = {}
		textDic["name"] = tr("商店")
		textDic["backGround"] = true
		textDic["textPos"] = "Down"
		textDic["text"] = tr("没钱是想死吗？")
		await showText(textDic)
		return false
