class_name CombinedEvent extends EventPage

## MT插件支持
func meta_addon_mt_plain():pass

## 执行的脚本
@export var text = "";

func execAction(action):
	match action.type:
		"comment":
			pass
		"ifAction":
			if calExpression(action.condition):
				await execActionList(action.trueActions)
			else:
				await execActionList(action.falseActions)
		"showText":
			await showText(action)
		"showChoice":
			var choiceText = []
			var choiceCallback = []
			var esc = action.esc
			for choice in action.choices:
				choiceText.append(choice.text)
				choiceCallback.append(choice.actions)
			action.erase("choices")
			action.erase("esc")
			var params = [action,choiceText,esc]
			var result = await MotaSystem.uiManager.openTillReturn(Defination.UIID.ChoiceForm,params)
			if result != -1:
				await execActionList(choiceCallback[result])
		"showFukiText":
			await showFukiText(action)
		"sleep":
			await wait(action.time)
		"script":
			await Utility.eval_code(action.script,self)
		"setValue":
			setValue(action.name,action.op,action.value)
		"specialEvent":
			MotaSystem.gameEventManager.pushSpecialEvent(action.eventType)
		"commonEventP":
			await commonEventP(action.commonEventId)
		"nextPage":
			nextPage()
		"pageTo":
			pageTo(action.index)
		"dead":
			dead()
		"changeMapColor_RGB":
			var color = Color(action.rgb,action.a)
			changeMapColor(color,action.duration)
		"changeWhiteMaskColor_RGB":
			var color = Color(action.rgb,action.a)
			changeWhiteMaskColor(color,action.duration)
		"shakeOn":
			shakeOn(action.strength,action.shakelength)
		"shakeOff":
			shakeOff()
		"setMapScale":
			setMapScale(action.scale)
		"scrollCameraStart":
			scrollCameraStart()
		"scrollCamera":
			scrollCamera(Vector2i(int(action.x),int(action.y)),action.duration)
		"scrollCameraEnd":
			scrollCameraEnd()
		"startEvent":
			startEvent(action.eventId)
		"setEventPage":
			if action.eventId == "self":
				action.eventId = base.name
			setEventPage(action.eventId,action.index)
		"setEventDead":
			if action.eventId == "self":
				action.eventId = base.name
			setEventDead(action.eventId)
		"setEventDead_map":
			setMapEventDead(action.mapkey,action.eventId)
		"setEventPosition":
			if action.eventId == "self":
				action.eventId = base.name
			setEventPosition(action.eventId,Vector2i(action.x,action.y),Utility.parseDirection(action.d))
		"setEventDirection":
			if action.eventId == "self":
				action.eventId = base.name
			setEventDirection(action.eventId,Utility.parseDirection(action.d))
		"setPlayerPosition":
			setPlayerPosition(Vector2i(action.x,action.y),Utility.parseDirection(action.d))
		"transferPlayer":
			transferPlayer.call_deferred(action.mapkey,Vector2i(action.x,action.y),Utility.parseDirection(action.d))
		"setEventFade":
			if action.eventId == "self":
				action.eventId = base.name
			setEventFade(action.eventId,action.target,action.fadeTime)
		"setPlayerFade":
			setPlayerFade(action.target,action.fadeTime)
		"setPlayerMove":
			if action.noAwait:
				setPlayerMove(JSON.parse_string(action.movingArr))
			else:
				await setPlayerMove(JSON.parse_string(action.movingArr))
		"setCharacterMove":
			if action.noAwait:
				setCharacterMove(action.eventId,JSON.parse_string(action.movingArr))
			else:
				await setCharacterMove(action.eventId,JSON.parse_string(action.movingArr))
		"setPlayerSpeed":
			setPlayerSpeed(action.speed)
		"setPlayerTexture":
			setPlayerTexture(action.player_texture)
		"setPlayerDirection":
			setPlayerDirection(Utility.parseDirection(action.d))
		"setCharacterTexture":
			if action.eventId == "self":
				action.eventId = base.name
			setCharacterTexture(action.eventId,action.character_texture)
		"setCharacterSpeed":
			if action.eventId == "self":
				action.eventId = base.name
			setCharacterSpeed(action.eventId,action.speed)
		"restorePlayerSpeed":
			restorePlayerSpeed()
		"setPlayerJump":
			if action.noAwait:
				setPlayerJump(int(action.x),int(action.y))
			else:
				await setPlayerJump(int(action.x),int(action.y))
		"setCharacterJump":
			if action.eventId == "self":
				action.eventId = base.name
			if action.noAwait:
				setCharacterJump(action.eventId,int(action.x),int(action.y))
			else:
				await setCharacterJump(action.eventId,int(action.x),int(action.y))
		"showAnim":
			if action.eventId == "self":
				action.eventId = base.name
			if action.onNode:
				showAnimOnNode(action.eventId,int(action.effectId))
			else:
				showAnim(action.eventId,int(action.effectId))
		"showPlayerAnim":
			showPlayerAnim(int(action.effectId))
		"addFollower":
			addFollower(action.playerId)
		"delFollower":
			delFollower(action.playerId)
		"playSE":
			AudioManager.playSE(action.v)
		"getItem":
			if action.hint:
				await getItem(action.id,action.num)
			else:
				MotaSystem.gameData.addItem(action.id,action.num)
		"getEquip":
			if action.hint:
				await getEquip(action.id,action.num)
			else:
				MotaSystem.gameData.addEquip_pool(action.id,action.num)
		"callEnemyForm":
			refresh()
			await callEnemyForm(action.id)
		"callSaveForm":
			nextPage()
			await callSaveForm()
		"refresh":
			refresh()
		"returnMainMenu":
			returnMainMenu()
		"passAction":
			pass
		_:
			print('未识别的事件类型')
	
# 表达式计算核心函数
func calExpression(expr):
	var result
	match expr.type:
		"scriptExpr": # 脚本表达式
			result = Utility.string_to_expression(expr.v).call()
		"evalStringExpr": # 直接输入的量
			result = JSON.parse_string(expr.v)
		"idStringExpr": # 变量名
			result = MotaSystem.gameVariables[expr.id]
		"idRangeExpr": # 变量/属性名
			match expr.r:
				"attribute":
					result = MotaSystem.gameData[expr.id]
				"gameVariables":
					result = MotaSystem.gameVariables[expr.id]
		"fixedExpr": # 简便属性
			match expr.id:
				"HP":
					result = MotaSystem.gameData.hp
				"MAXHP":
					result = MotaSystem.gameData.maxHp
				"MP":
					result = MotaSystem.gameData.mp
				"ATK":
					result = MotaSystem.gameData.atk
				"DEF":
					result = MotaSystem.gameData.def
				"MDEF":
					result = MotaSystem.gameData.mdef
				"SPD":
					result = MotaSystem.gameData.spd
		"boolExpr":
			result = expr.v
		"notExpr":
			result = !calExpression(expr.v)
		"arithmetic":
			var a = calExpression(expr.a)
			var b = calExpression(expr.b)
			var op = expr.op
			match op:
				"+":
					result = a + b
				"-":
					result = a - b
				"*":
					result = a * b
				"/":
					result = a / b
				"^":
					result = a ** b
				"==":
					result = (a == b)
				"!=":
					result = (a != b)
				">":
					result = (a > b)
				"<":
					result = (a < b)
				">=":
					result = (a >= b)
				"<=":
					result = (a <= b)
				"&&":
					result = (a && b)
				"||":
					result = (a || b)
	return result

func setValue(v_name,op,value):
	match op:
		"=":
			MotaSystem.gameVariables[v_name.id] = calExpression(value)
		"+=":
			MotaSystem.gameVariables[v_name.id] += calExpression(value)
		"-=":
			MotaSystem.gameVariables[v_name.id] -= calExpression(value)
		"*=":
			MotaSystem.gameVariables[v_name.id] *= calExpression(value)
		"/=":
			MotaSystem.gameVariables[v_name.id] /= calExpression(value)

func execActionList(actionList):
	for ii in range(actionList.size()):
		await execAction(actionList[ii])

func execChoiceActionList(actionList):
	for ii in range(actionList.size()):
		await execAction(actionList[ii])

func start():
	# 主要逻辑
	if !MotaSystem.Player.MovingStack.is_empty():
		if MotaSystem.Player.resetspeed:
			MotaSystem.Player.speed = MotaSystem.config.getValue("Playerspeed","speed")
			MotaSystem.Player.resetspeed = false
		MotaSystem.Player.MovingStack.clear()
	# 扭头
	if !noDirection:
		# 临时转向，dir变量不变
		frame = (base.getDirectionByOtherPos(MotaSystem.Player.tilePosition) * 4) + (base.startSpriteFrameIndex % 4)
	var actionArr=JSON.parse_string(text)
	await execActionList(actionArr.actions)
	if !noDirection:
		# 触发set函数消除临时转向
		base.dir = base.dir
	# 完成后处理
	super()

# 公共事件
func commonEventP(type:String):
	var res = MotaSystem.resourceManager.loadFile("res://Scene/CommonEvent/CommonEvent.tscn")
	await execActionList(JSON.parse_string(res.instantiate().get_node(type).text).actions)
