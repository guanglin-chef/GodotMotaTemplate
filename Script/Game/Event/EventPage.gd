# 事件页的基类，所有自己写的事件都要继承这里
class_name EventPage extends FrameAnimation

## 触发条件
@export_enum("Touch","Auto","AutoAsync","Process") var trigger = 0
## 是否允许通行
@export var eventPassable: bool = false
@export var findpathPassable: bool = false
## 事件结束后动作
@export_enum("Hold","Next","Dead","Customize") var onPageFinished = 0
## 指定的结束后下一页index，只有在onPageFinished为Customize时才会有效
@export var customizeNextPage:int

# GameEvent
var base : GameEvent
var debuff:Dictionary = { }

func init(baseEvent:GameEvent):
	self.base = baseEvent

# 离开事件页时
func exit():
	visible = false
	set_process(false)
	set_process_input(false)

# 进入事件页时
func enter():
	visible = true
	base.sprite = self
	set_process(true)
	set_process_input(true)
	call_deferred("onEnter")

func onEnter():
	# UFO模式不自动执行
	if !MotaSystem.Player.allPass:
		# 需要在切换地图后能够自动执行不是加载进去就自动执行
		if trigger == 1: # Auto
			startSync()
		if trigger == 2: # AutoAsync
			startAsync()

# 事件开始后所执行的
func start():
	# 实际逻辑需要在具体的脚本中覆盖函数并在最后super()
	# 执行完后的逻辑
	if base.auto_pick:
		if !(self is MonsterEvent):
			MotaSystem.effectManager.showEffectOnNode(DatatableManager.Effect.data[117]["path"],MotaSystem.CurrentMap,global_position,100,[texture,frame])
		MotaSystem.CurrentMap.auto_pick_eat.erase(base)
		base.auto_pick = false
	if base.current_page == self:
		if onPageFinished == 0: #Hold
			pass
		if onPageFinished == 1: #Next
			base.current_page = base.next_page
		if onPageFinished == 2: #Dead
			base.dead()
		if onPageFinished == 3: # Customize
			if customizeNextPage < base.pages.size():
				base.current_page = base.pages[customizeNextPage]
			else:
				printerr("CustomizeNextPage outrange!")
	if base.current_page == null && (self is BarrierEvent || self is RegionBarrierEvent) && player_can_move():
		MotaSystem.CurrentMap.AutoPick(MotaSystem.Player.tilePosition)
	# 完事之后
	if MotaSystem.CurrentMap.auto_pick_eat.size() == 0 || self is MonsterEvent:
		MotaSystem.gameForm.RefreshUI() #刷新UI
func player_can_move():
	return !MotaSystem.uiManager.hasRunningUI(Defination.UILayer.Main) && !MotaSystem.uiManager.hasRunningUI(Defination.UILayer.PopUp) && MotaSystem.Player.EventMovingStack.data.is_empty()
# 推入整体事件管理器的同步执行
func startSync():
	MotaSystem.gameEventManager.pushRun(start,self.character)
# 不推入事件管理器的异步执行
func startAsync():
	if !base.AsyncRunningFlag:
		base.AsyncRunningFlag = true
		await start()
		base.AsyncRunningFlag = false

##--------------------------------------------------------------------------
## ● 获取范围是否覆盖某个点(x,y)
##--------------------------------------------------------------------------
func has_point(ver : Vector2i , ix : int , iy : int = -1 , pos : Vector2i = base.tilePosition):  # iy是光环高度，等于-1时是根据距离来算
	if ix == 0:
		return false
	if iy <= 0:
		return abs(pos.x - ver.x) + abs(pos.y - ver.y) <= abs(ix)
	else:
		return absf(pos.x - ver.x) <= ix && abs(pos.y - ver.y) <= iy
# 接触式执行
func touch():
	if trigger == 0: # Touch
		# 穿墙的不会穿传送事件
		if MotaSystem.gameVariables["debugMode"]:
			if Input.is_action_pressed("debug"):
				if !(self is TeleportEvent || self is TeleportTowerEvent):
					return
		# UFO模式同理
		if MotaSystem.Player.allPass:
			if !(self is TeleportEvent || self is TeleportTowerEvent):
				return
		if !MotaSystem.gameEventManager.hasRunningEvent(self.character):
			startSync()
	# 机关门闪烁
	elif base.current_page is RegionBarrierEvent && !base.current_page.checkedPositions.is_empty():
		base.current_page.flash()

func _process(delta: float) -> void:
	if base.isDead:
		return
	if trigger == 3: # Process
		startAsync()
	super(delta)

# 切好的单张图
var cutTexture:
	get:
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = self.texture
		atlasTexture.filter_clip = true
		var width = self.texture.get_width() / 4
		var height = self.texture.get_height() / 4
		atlasTexture.region = Rect2(self.frame % 4 * width, floori(self.frame / 4) * height, width, height)
		return atlasTexture

#--------------------事件通用功能性方法---------------------
# 显示文章
# *需要加await*
#showText(dic:Dictionary)
func showText(dic:Dictionary):
	if MotaSystem.inputManager.nowait:
		return
	await MotaSystem.uiManager.openTillClose(Defination.UIID.TextForm,dic)
	
# 显示文章一键简易版本
# *需要加await*
#showText
func showTextP(text:String):
	if MotaSystem.inputManager.nowait:
		return
	var textDic = {}
	textDic["name"] = ""
	textDic["backGround"] = true
	textDic["textPos"] = "Down"
	textDic["text"] = text
	await MotaSystem.uiManager.openTillClose(Defination.UIID.TextForm,textDic)

# 显示FUKI
# *需要加await*
#showFukiText(dic:Dictionary)
func showFukiText(dic:Dictionary):
	if MotaSystem.inputManager.nowait:
		return
	await MotaSystem.uiManager.openTillClose(Defination.UIID.FukiTextForm,dic)

# 等待
# *需要加await*
#输入一个需要等待的秒数即可
func wait(sec:float):
	if !MotaSystem.inputManager.nowait && is_inside_tree():
		await get_tree().create_timer(sec).timeout
	
# 立刻翻页
func nextPage():
	if base.next_page != null:
		base.current_page = base.next_page
	else:
		printerr("Page outrange!")
# 事件页跳转
#pageTo(targetIndex:int)
#targetIndex为需要跳转到的事件页序号
#注意：序号是从 0 开始数数的！
func pageTo(targetIndex:int):
	if targetIndex < base.pages.size():
		base.current_page = base.pages[targetIndex]
	else:
		printerr("CustomizeNextPage outrange!")

# 事件结束
#一般情况下在编辑器里的onPageFinished = dead的时候，这一页执行完就会直接结束。
#不过你要想手动立即结束事件的话也可以用这个方法
func dead():
	base.dead()

# 场所移动
#transferPlayer(mapKey:String, pos:Vector2i, dir:Defination.direction)
#mapKey为目标地图id
#pos为位置
#dir为传送后朝向
func transferPlayer(mapKey:int, pos:Vector2i, dir:Defination.direction):
	MotaSystem.gameManager.transferPlayer(mapKey,pos,dir)

# 设置事件位置
#setEventPosition(eventId:String,pos:Vector2i,dir:Defination.direction)
#eventId为你想要设置事件的名称（id），pos为你想要设置到的位置，dir为设置后的朝向
func setEventPosition(eventId:String,pos:Vector2i,dir:Defination.direction):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	targetEvent.tilePosition = pos
	targetEvent.position = Utility.tilePos2WorldPos(pos)
	targetEvent.dir = dir

# 设置事件朝向
#setEventDirection(eventId:String,dir:Defination.direction)
#eventId为你想要设置事件的名称（id），dir为设置后的朝向
func setEventDirection(eventId:String,dir:Defination.direction):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	if targetEvent != null:
		targetEvent.dir = dir

# 设置自身朝向
func setSelfEventDirection(dir:Defination.direction):
	character.dir = dir

# 直接设置角色位置（同地图）
func setPlayerPosition(targetPosition:Vector2i,dir:int):
	# 传送！
	MotaSystem.Player.setPosition(targetPosition)
	if dir == 4: # HOLD
		pass
	else:
		MotaSystem.Player.dir = dir

# 设置角色方向
func setPlayerDirection(dir:int):
	MotaSystem.Player.dir = dir

# 设置事件淡入淡出
func setEventFade(eventId:String,target:float,duration:float):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	if targetEvent != null:
		var tween = create_tween()
		tween.tween_property(targetEvent,"modulate",Color(1,1,1,target),duration)

# 触发指定事件
func startEvent(eventId:String):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	targetEvent.current_page.startSync()

# 指定事件跳转事件页
func setEventPage(eventId:String, targetIndex:int):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	targetEvent.current_page = targetEvent.pages[targetIndex]
	
# 指定事件结束
func setEventDead(eventId:String):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	targetEvent.dead()

# 指定地图指定事件结束
func setMapEventDead(mapkey:String,eventId:String):
	if MotaSystem.mapManager.m_Maps.has(int(mapkey)):
		var targetEvent = MotaSystem.mapManager.m_Maps[int(mapkey)].get_node("Events").get_node(eventId)
		targetEvent.dead()
	if MotaSystem.mapManager.mapData.has("mapData") && MotaSystem.mapManager.mapData["mapData"].has(mapkey):
		#print(MotaSystem.gameManager.m_MapManager.mapData["mapData"][mapkey])
		if !MotaSystem.mapManager.mapData["mapData"][mapkey].has("eventdata"):
			MotaSystem.mapManager.mapData["mapData"][mapkey]["eventdata"] = { eventId : {} }
		elif !MotaSystem.mapManager.mapData["mapData"][mapkey]["eventdata"].has(eventId):
			MotaSystem.mapManager.mapData["mapData"][mapkey]["eventdata"][eventId] = {}
		MotaSystem.mapManager.mapData["mapData"][mapkey]["eventdata"][eventId]["die"] = true
	else:
		var eventpage = {}
		eventpage["die"] = true
		var event = {}
		event[eventId] = eventpage
		MotaSystem.mapManager.mapData["mapData"][mapkey] = { "eventdata" : event }

# 设置事件淡入淡出
func setPlayerFade(target:float,duration:float):
	var tween = create_tween()
	tween.tween_property(MotaSystem.Player,"modulate",Color(1,1,1,target),duration)

# 设置主角移动路线
# setPlayerMove(movingArr:Array)
# 你需要输入一个int数组，其中的移动对应如下：
# 下：2
# 左：4
# 右：6
# 上：8
# *需要加await*
func setPlayerMove(movingArr:Array):
	#movingArr.reverse()
	if !MotaSystem.inputManager.nowait:
		MotaSystem.Player.EventMovingStack.data = movingArr
		MotaSystem.Player.setEventMoveIdle(func():
			MotaSystem.Player.player_event_move_end.emit()
		)
		await MotaSystem.Player.player_event_move_end
	else:
		setPlayerPosition(Utility.calMovingArr(MotaSystem.Player.tilePosition,movingArr),movingArr[-1]/2-1)

signal character_move_end
# 设置角色移动路线
# setCharacterMove(eventId:String,movingArr:Array)
# 你需要输入一个int数组，其中的移动对应如下：
# 下：2
# 左：4
# 右：6
# 上：8
# eventId为你想要设置事件的名称（id）
# *需要加await*
func setCharacterMove(eventId:String,movingArr:Array):
	#movingArr.reverse()
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	if !MotaSystem.inputManager.nowait:
		targetEvent.EventMovingStack.data = movingArr
		targetEvent.setEventMoveIdle(func():
			character_move_end.emit()
		)
		await character_move_end
	else:
		setEventPosition(eventId,Utility.calMovingArr(targetEvent.tilePosition,movingArr),movingArr[-1]/2-1)

# 设置主角速度
func setPlayerSpeed(s:float):
	MotaSystem.Player.speed = s

# 设置角色速度
func setCharacterSpeed(eventId:String,s:float):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	targetEvent.speed = s

# 根据配置还原角色速度
func restorePlayerSpeed():
	MotaSystem.Player.speed = MotaSystem.config.getValue("Playerspeed","speed")

# 更改画面色调
#changeMapColor(target:Color, duration:float)
#填入目标的color和渐变时间
func changeMapColor(target:Color, duration:float):
	if !MotaSystem.inputManager.nowait:
		var tween = get_tree().create_tween()
		tween.tween_property(MotaSystem.mapManager,"modulate",target,duration)
	else:
		MotaSystem.mapManager.modulate = target

# 更改白色幕布的色调
func changeWhiteMaskColor(target:Color, duration:float):
	if !MotaSystem.inputManager.nowait:
		var tween = get_tree().create_tween()
		tween.tween_property(MotaSystem.mapManager.whiteMask,"color",target,duration)
	else:
		MotaSystem.mapManager.whiteMask.modulate = target

# 画面震动
func shakeOn(strength:int, shakelength:int):
	#print(strength,shakelength)
	MotaSystem.Player.get_node("Camera2D").shakeOn(strength, shakelength)

# 画面震动停止
func shakeOff():
	MotaSystem.Player.get_node("Camera2D").shakeOff()

# 设置大地图缩放
func setMapScale(scaleNum:float):
	MotaSystem.Player.playerCamera.scaleNum = scaleNum
	MotaSystem.Player.playerCamera.updateCamera()

# 画面卷动开始
func scrollCameraStart():
	# 在切摄像机之前把缩放调为1
	MotaSystem.Player.playerCamera.resetScale()
	# 设置卷动摄像机	
	var camera = MotaSystem.mapManager.camera
	camera.position = MotaSystem.Player.get_node("Camera2D").global_position
	camera.make_current()

#画面卷动
func scrollCamera(offset1:Vector2i,duration:float):
	# 计算坐标
	var pos = MotaSystem.mapManager.camera.global_position
	pos = pos + Vector2(offset1.x * Defination.tilesize, offset1.y * Defination.tilesize)
	if !MotaSystem.inputManager.nowait:
		# 动画
		var tween = get_tree().create_tween()
		tween.tween_property(MotaSystem.mapManager.camera,"position",pos,duration)
	else:
		MotaSystem.mapManager.camera.position = pos

# 结束画面卷动
func scrollCameraEnd():
	MotaSystem.Player.get_node("Camera2D").make_current()

# 设置主角跳跃
# *需要加await*
func setPlayerJump(xplus:int,yplus:int):
	if !MotaSystem.inputManager.nowait:
		MotaSystem.Player.jump(xplus,yplus)
		await MotaSystem.Player.jump_end
	else:
		var result = Utility.calJump(MotaSystem.Player.tilePosition,MotaSystem.Player.dir,xplus,yplus)
		setPlayerPosition(result[0],result[1])

# 设置事件跳跃
# *需要加await*
func setCharacterJump(eventId:String,xplus:int,yplus:int):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	
	if !MotaSystem.inputManager.nowait:
		targetEvent.jump(xplus,yplus)
		await targetEvent.jump_end
	else:
		var result = Utility.calJump(targetEvent.tilePosition,targetEvent.dir,xplus,yplus)
		setEventPosition(eventId,result[0],result[1])

#  更改角色行走图
func setPlayerTexture(player_texture:String):
	var picture_path:String = "res://Resources/Character/"
	if player_texture != null and player_texture != "":
		picture_path += player_texture
		MotaSystem.Player.sprite.texture = MotaSystem.resourceManager.loadFile(picture_path)
				
# 更改事件行走图
func setCharacterTexture(eventId:String,character_texture:String):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	var picture_path:String = "res://Resources/Character/"
	if character_texture != null and character_texture != "":
		picture_path += character_texture
		for i in targetEvent.get_children():
			if i.visible == true and i is Sprite2D:
				i.texture = MotaSystem.resourceManager.loadFile(picture_path)
				break

# 添加跟随
func addFollower(playerID:int):
	MotaSystem.gamePlayerManager.addFollower(playerID)

# 删除跟随
func delFollower(playerID:int):
	MotaSystem.gamePlayerManager.delFollower(playerID)

# 显示动画于事件位置
#showAnim(eventId:String, effectId:int)
#eventId为你想要设置事件的名称（id），effectId为动画在effect表中的id
func showAnim(eventId:String, effectId:int):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	var dr = DatatableManager.Effect.data[effectId]
	# 位置
	var pos = targetEvent.animPosition
	MotaSystem.effectManager.showEffect(dr["path"],pos,Defination.UILayer.Game)

# 显示动画于事件上
#eventId为你想要设置事件的名称（id），effectId为动画在effect表中的id
func showAnimOnNode(eventId:String, effectId:int):
	var targetEvent = MotaSystem.CurrentMap.events.get_node(eventId)
	var dr = DatatableManager.Effect.data[effectId]
	var offsets = Vector2(32, 32)
	# 如果是有轨迹类型的动画，则调用计算记录的算法播放
	if DatatableManager.Effect.data[effectId]["isLocus"] == 1:
		# 坐标差
		var pos_dis = MotaSystem.gameManager.Player.tilePosition - Utility.worldPos2TilePos(targetEvent.position)
		var position_dis:Vector2 = pos_dis * 64
		offsets += position_dis
		MotaSystem.effectManager.showEffectDistanceOnNode(dr["path"],targetEvent,offsets)
	else:
		MotaSystem.effectManager.showEffectOnNode(dr["path"],targetEvent,offsets)

# 在玩家处显示动画
#showPlayerAnim(effectId:int)
#effectId为你想要播的effect在表中的id
func showPlayerAnim(effectId:int):
	var dr = DatatableManager.Effect.data[effectId]
	# 位置
	var pos = (MotaSystem.Player.animPosition)
	MotaSystem.effectManager.showEffect(dr["path"],pos,Defination.UILayer.Game)

# 在玩家处显示会跟随的动画
func showPlayerAnimOnNode(effectId:int):
	var dr = DatatableManager.Effect.data[effectId]
	if effectId == 201:
		MotaSystem.effectManager.showEffectOnNode(dr["path"],MotaSystem.Player,Vector2(Defination.tilesize/2,Defination.tilesize/2),1,effectId)
	else:
		MotaSystem.effectManager.showEffectOnNode(dr["path"],MotaSystem.Player,Vector2(Defination.tilesize/2,Defination.tilesize/2),1)

# 获得道具
func getItem(ID:int, num:int):
	# 获得道具
	MotaSystem.gameData.addItem(ID, num)
	# 
	var nameText:String
	nameText = tr(DatatableManager.Item.data[ID].itemName)
	if num > 1:
		nameText += " * {0}".format([num]) 
	var text = DatatableManager.Item.data[ID].itemNote
	var icon:String
	icon = "res://Resources/Icon/item/"+DatatableManager.Item.data[ID].itemPictrueName
	var popup_dic:Dictionary = {"Icon":icon,"Name":nameText,"Text":text}
	# 获得道具界面
	await MotaSystem.uiManager.openTillClose(Defination.UIID.IconTextForm,popup_dic)

# 获得装备
func getEquip(ID:int, num:int):
	# 获得装备
	MotaSystem.gameData.addEquip_pool(ID, num)
	# 
	var nameText:String
	nameText = DatatableManager.Equip.data[ID].equipName
	if num > 1:
		nameText += " * {0}".format([num]) 
	var text = DatatableManager.Equip.data[ID].equipNote
	var icon:String
	icon = "res://Resources/Icon/equip/"+DatatableManager.Equip.data[ID].equipIcon
	var popup_dic:Dictionary = {"Icon":icon,"Name":nameText,"Text":text}
	# 获得道具界面
	await MotaSystem.uiManager.openTillClose(Defination.UIID.IconTextForm,popup_dic)

# 呼叫对应事件的敌人详情页面
func callEnemyForm(eventId:String):
	var enemyevent = MotaSystem.CurrentMap.events.get_node(eventId)
	await MotaSystem.uiManager.openTillClose(Defination.UIID.EnemyDetailInfoForm,[enemyevent,enemyevent.current_page.fighter,enemyevent.current_page.texture,enemyevent.current_page.frame,null])

# 呼叫存档界面
func callSaveForm():
	await MotaSystem.uiManager.openTillClose(Defination.UIID.SaveForm, true)

# 立刻刷新
func refresh():
	# 刷新
	MotaSystem.gameForm.RefreshUI()

# 返回标题
func returnMainMenu():
	MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainMenu)
