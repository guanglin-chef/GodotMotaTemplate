extends EventPage

# LevelUpEvent
# 升级事件，由于需要在很多地方的代码中调用因此设置为特别事件

func start():
	if DatatableManager.Level.data[MotaSystem.gameData.level].expmax - MotaSystem.gameData.expe > 0:
		return
	var preLevel = MotaSystem.gameData.level
	MotaSystem.gameData.level += 1
	MotaSystem.gameData.expe -= DatatableManager.Level.data[preLevel]["expmax"]
	
	AudioManager.playSE("lvup.ogg")
	
	await levelUp(preLevel)
		
	# 完成后处理
	super()

func levelUp(level:int):
	await showTextP(tr("成功进阶{0}！").format([tr(DatatableManager.Level.data[MotaSystem.gameData.level]["name"])]))
	await showTextP(tr("增加攻击{0}防御{1}护盾{2}").format([DatatableManager.Level.data[level].atkup,DatatableManager.Level.data[level].defup,DatatableManager.Level.data[level].mdefup]))
	MotaSystem.gameData.base_atk += DatatableManager.Level.data[level].atkup
	MotaSystem.gameData.base_def += DatatableManager.Level.data[level].defup
	MotaSystem.gameData.base_mdef += DatatableManager.Level.data[level].mdefup
	MotaSystem.gameForm.RefreshUI()
