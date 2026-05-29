extends EventPage

# GameOverEvent
# 用于打怪死亡的事件，由于需要在很多地方的代码中调用因此设置为特别事件

func start():
	# 主要逻辑
	await showTextP(tr("结局一：你暴毙了"))
	
	var textDic = {}
	textDic["name"] = ""
	textDic["backGround"] = true
	textDic["textPos"] = "Down"
	textDic["text"] = tr("是否撤回？")
	
	var choiceText = [
		tr("是"),
		tr("否")
	]
	var result = await MotaSystem.uiManager.openTillReturn(Defination.UIID.ChoiceForm,[textDic,choiceText,false])
	
	if result != -1:
		if result == 0:
			AudioManager.playSE("RPG3_UI_PositiveAlert01.wav")
			if MotaSystem.saveManager.AutoLoad() == false:
				await showTextP(tr("没有可用的自动存档，即将返回标题"))
				MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainMenu)	
		else:
			MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainMenu)	
	# 完成后处理
	super()
