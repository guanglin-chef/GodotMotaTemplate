##==============================================================================
## ■ MonsterEvent
##------------------------------------------------------------------------------
## 事件中的战斗单位
##==============================================================================
class_name GamePlayer extends GameCharacter
##--------------------------------------------------------------------------
## ● 挂载组件
##--------------------------------------------------------------------------
@onready
var playerCamera:Camera2D = $Camera2D
@onready
var kuang:TextureRect = $TextureRect
##--------------------------------------------------------------------------
## ● 移动栈
##--------------------------------------------------------------------------
signal player_event_move_end                # 移动结束信号
var moveEndCallbacks : Array[Callable]      # 移动结束后的回调
var MovingStack      : Stack = Stack.new()  # 鼠标移动栈
var mouse_target     : Vector2i             # 鼠标移动目标点
##--------------------------------------------------------------------------
## ● 杂项
##--------------------------------------------------------------------------
var wait_event = []     # 一些需要等待执行完的事件
var resetspeed = false  # 在鼠标操作等快速移动后给出恢复机制
##--------------------------------------------------------------------------
## ● 玩家数据
##--------------------------------------------------------------------------
var playerData:Dictionary:
	get:
		var data:Dictionary = {
			"playerID": self.playerID,
			"mapKey": MotaSystem.CurrentMap.key,
			"position": self.tilePosition,
			"direction": self.dir,
			"self_modulate": sprite.self_modulate.to_html()
		}
		if sprite.texture != null:
			data["player_texture"] = sprite.texture.resource_path
			data["player_frame"] = sprite.frame
		return data
##--------------------------------------------------------------------------
## ● 预加载
##--------------------------------------------------------------------------
func _ready():
	super()
	# 初始化移动设置
	sprite.idleAnim = false
	sprite.movingAnim = true
	sprite.noDirection = false
##--------------------------------------------------------------------------
## ● 帧刷新 用于处理移动等
##--------------------------------------------------------------------------
func _process(delta):
	super(delta)
	if !moving && !MotaSystem.gameEventManager.hasAnyRunningEvent() && !MotaSystem.uiManager.hasRunningUI(Defination.UILayer.Main) && !MotaSystem.uiManager.hasRunningUI(Defination.UILayer.PopUp) && EventMovingStack.data.is_empty():
		# 当停止时触发回调
		for callback in moveEndCallbacks:
			#print("callback")
			callback.call()
		moveEndCallbacks.clear()
		# 正在切换地图硬直时则先不检测下一步
		if !MotaSystem.mapManager.changingMap:
			MotaSystem.CurrentMap.AutoPick(tilePosition)
			# 检测输入
			var d
			if !MotaSystem.gameManager.m_InputManager.MovingInputStack.is_empty():
				if resetspeed:
					speed = MotaSystem.config.getValue("Playerspeed","speed")
					resetspeed = false
				MovingStack.data = []
				d = MotaSystem.gameManager.m_InputManager.MovingInputStack.top()
				if d == Defination.direction.up:
					if !MotaSystem.gameManager.m_InputManager.MovingInputStack.has(Defination.direction.down):
						move_up()
				if d == Defination.direction.down:
					if !MotaSystem.gameManager.m_InputManager.MovingInputStack.has(Defination.direction.up):
						move_down()
				if d == Defination.direction.left:
					if !MotaSystem.gameManager.m_InputManager.MovingInputStack.has(Defination.direction.right):
						move_left()
				if d == Defination.direction.right:
					if !MotaSystem.gameManager.m_InputManager.MovingInputStack.has(Defination.direction.left):
						move_right()
			elif !MovingStack.is_empty():
				d = (MovingStack.pop() / 2) - 1
				if d == Defination.direction.up:
					if move_up() && MovingStack.data.size() > 0:
						MovingStack.push((d + 1) * 2)
				if d == Defination.direction.down:
					if move_down() && MovingStack.data.size() > 0:
						MovingStack.push((d + 1) * 2)
				if d == Defination.direction.left:
					if move_left() && MovingStack.data.size() > 0:
						MovingStack.push((d + 1) * 2)
				if d == Defination.direction.right:
					if move_right() && MovingStack.data.size() > 0:
						MovingStack.push((d + 1) * 2)
				if MovingStack.is_empty():
					if resetspeed:
						speed = MotaSystem.config.getValue("Playerspeed","speed")
						resetspeed = false
##--------------------------------------------------------------------------
## ● 坐标图块通行判定
##--------------------------------------------------------------------------
func passable(d:Defination.direction,eventpassable:bool = false) -> bool:
	if MotaSystem.gameVariables["debugMode"]:
		if Input.is_action_pressed("debug"):
			return true
	# 先看是否到边缘
	var facePos = checkFacePos(d)
	if facePos.x < 0 || facePos.y < 0 || facePos.x >= MotaSystem.CurrentMap.width || facePos.y >= MotaSystem.CurrentMap.height:
		return false
	# 看无视通行
	if allPass:
		return true
	# 看图块通行和事件通行
	var result = MotaSystem.CurrentMap.isMapPassable(facePos)
	if !eventpassable:
		result = result && MotaSystem.CurrentMap.isEventPassable(facePos)
	#再看图块四方向通行
	if d == Defination.direction.down:#从上往下
		result = result && MotaSystem.CurrentMap.isMapDownPassable(self.tilePosition) && MotaSystem.CurrentMap.isMapUpPassable(facePos)
	if d == Defination.direction.up:#从下往上
		result = result && MotaSystem.CurrentMap.isMapUpPassable(self.tilePosition) && MotaSystem.CurrentMap.isMapDownPassable(facePos)
	if d == Defination.direction.right:#从左往右
		result = result && MotaSystem.CurrentMap.isMapRightPassable(self.tilePosition) && MotaSystem.CurrentMap.isMapLeftPassable(facePos)
	if d == Defination.direction.left:#从右往左
		result = result && MotaSystem.CurrentMap.isMapLeftPassable(self.tilePosition) && MotaSystem.CurrentMap.isMapRightPassable(facePos)
	return result
##--------------------------------------------------------------------------
## ● 向上移动
##--------------------------------------------------------------------------
func move_up():
	var startevent:bool = false
	dir = Defination.direction.up
	move_save_check()
	startevent = triggerEvents()
	if passable(dir) && wait_event.is_empty():
		moving=true
		destination.y = Defination.tilesize
		sprite.playMoving()
		# 结算
		tilePosition.y -= 1
		increase_step()
		# 跟随
		if follower:
			if follower.followMove != null:
				follower.call(follower.followMove)
			follower.followMove = follower.move_up.get_method()
	else:
		return startevent
	return false
##--------------------------------------------------------------------------
## ● 向下移动
##--------------------------------------------------------------------------
func move_down():
	var startevent:bool = false
	dir = Defination.direction.down
	move_save_check()
	startevent = triggerEvents()
	if passable(dir) && wait_event.is_empty():
		moving=true
		destination.y = -Defination.tilesize
		sprite.playMoving()
		# 结算
		tilePosition.y += 1
		increase_step()
		# 跟随
		if follower:
			if follower.followMove != null:
				follower.call(follower.followMove)
			follower.followMove = follower.move_down.get_method()
	else:
		return startevent
	return false
##--------------------------------------------------------------------------
## ● 往左
##--------------------------------------------------------------------------
func move_left():
	var startevent:bool = false
	dir = Defination.direction.left
	move_save_check()
	startevent = triggerEvents()
	if passable(dir) && wait_event.is_empty():
		moving=true
		destination.x = -Defination.tilesize
		sprite.playMoving()
		# 结算
		tilePosition.x -= 1
		increase_step()
		# 跟随
		if follower:
			if follower.followMove != null:
				follower.call(follower.followMove)
			follower.followMove = follower.move_left.get_method()
	else:
		return startevent
	return false
##--------------------------------------------------------------------------
## ● 往右
##--------------------------------------------------------------------------
func move_right():
	var startevent:bool = false
	dir = Defination.direction.right
	move_save_check()
	startevent = triggerEvents()
	if passable(dir) && wait_event.is_empty():
		moving=true
		destination.x = Defination.tilesize
		sprite.playMoving()
		# 结算
		tilePosition.x += 1
		increase_step()
		# 跟随
		if follower:
			if follower.followMove != null:
				follower.call(follower.followMove)
			follower.followMove = follower.move_right.get_method()
	else:
		return startevent
	return false
##--------------------------------------------------------------------------
## ● 判定下一步是否会被捕捉 会被捕捉就自动存档
##--------------------------------------------------------------------------
func move_save_check():
	if !MotaSystem.mapManager.preview && !(MotaSystem.gameVariables["debugMode"] && Input.is_action_pressed("debug")) && passable(dir) && wait_event.is_empty() && !MotaSystem.CurrentMap.isMonsterRange(checkFacePos(dir), ["fight"]):
		MotaSystem.saveManager.AutoSave()
##--------------------------------------------------------------------------
## ● 步数 移动后的处理
##--------------------------------------------------------------------------
func increase_step():
	# 地图伤害
	MotaSystem.enemyReady.step_trigger()
	MotaSystem.CurrentMap.ShowFlyPointForMap()
	MotaSystem.CurrentMap.show_damage_point()
##--------------------------------------------------------------------------
## ● 前方事件判定 是否为障碍 同时触发前方事件
##--------------------------------------------------------------------------
func triggerEvents(space:bool = false) -> bool:
	var through_event  : Array = []  # 可穿过的，低优先级的事件
	var event_passable : bool  = true
	var the_passable   : bool  = true
	var start_event    : bool  = false
	if passable(dir,true) || !MotaSystem.CurrentMap.isMapPassable(checkFacePos(dir)):
		var events = checkFaceEvent(dir)
		if events.size() > 0:
			for event in events:
				if event.current_page != null:
					if passable(dir,true) && MotaSystem.CurrentMap.isMapPassable(checkFacePos(dir)) && (!event.current_page.eventPassable || !space):
						if event.current_page.eventPassable:
							through_event.append(event)
							continue
						if start_event && event.current_page != null:
							event_passable = event.current_page.eventPassable && event_passable
						the_passable       = event.current_page.eventPassable && the_passable
						event.startEvent()
						start_event = true
	if the_passable && !through_event.is_empty():
		for event in through_event:
			event.startEvent()
			start_event = true
	return start_event
##--------------------------------------------------------------------------
## ● 触发坐标点上的事件
##--------------------------------------------------------------------------
func start_pos_event(pos = tilePosition) -> bool:
	var through_event  : Array = []  # 可穿过的，低优先级的事件
	var the_passable   : bool  = true
	var start          : bool  = false
	var events = MotaSystem.CurrentMap.checkEvent(pos)
	if events.size() > 0:
		for event in events:
			if event.current_page != null:
				if event.current_page.eventPassable:
					through_event.append(event)
					continue
				the_passable = event.current_page.eventPassable && the_passable
				event.startEvent()
				start = true
	if the_passable && !through_event.is_empty():
		for event in through_event:
			event.startEvent()
			start = true
	return start
##--------------------------------------------------------------------------
## ● 
##--------------------------------------------------------------------------
func setIdle(callback:Callable):
	moveEndCallbacks.append(callback)
	sprite.stop()
##--------------------------------------------------------------------------
## ● 传送处理（一些机制需要用到传送 但是又需要跟鼠标移动之类的便利传送隔开）
##--------------------------------------------------------------------------
func teleport_position(pos : Vector2i):
	setPosition(pos)
	if !MotaSystem.mapManager.preview:
		if (MotaSystem.gameData.state.has("6") || MotaSystem.gameData.state.has("5")):
			# 解除封印状态
			if MotaSystem.gameData.state.has("6"):
				MotaSystem.gameData.removeState(6)
			# 解除夹击状态 还原被夹击的血量
			if MotaSystem.gameData.state.has("5"):
				MotaSystem.gameData.hp += MotaSystem.gameData.state["5"]
				MotaSystem.gameData.removeState(5)
			MotaSystem.gameForm.RefreshUI()
		MotaSystem.CurrentMap.auto_pick = {}
##--------------------------------------------------------------------------
## ● 设置坐标
##--------------------------------------------------------------------------
func setPosition(pos : Vector2i):
	# 传送
	super(pos)
	# 传送队友
	for node in MotaSystem.gamePlayerManager.get_children():
		if node.name == "Player":
			continue
		node.setPosition(pos)
		node.followMove = null
		node.dir = MotaSystem.Player.dir
	MotaSystem.CurrentMap.ShowFlyPointForMap()
	MotaSystem.CurrentMap.show_damage_point()
##--------------------------------------------------------------------------
## ● 启动UFO模式
##--------------------------------------------------------------------------
func setUFO(on:bool):
	kuang.visible = on
	sprite.visible = !on
	allPass = on
