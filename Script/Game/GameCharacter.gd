class_name GameCharacter extends Node2D

## MT插件支持
@export var meta_addon_mt_parse_property = true
# 初始帧
var startSpriteFrameIndex:int
# 移动标识
var moving:bool:
	get:
		return moving
	set(value):
		if moving && !value:
			checkIdle()
		moving = value
# 瓦片坐标位置
var m_tilePosition:Vector2i
var tilePosition:Vector2i:
	get:
		return m_tilePosition
	set(v):
		var imoving : bool = false
		if m_tilePosition != v && self is GameEvent && MotaSystem.CurrentMap != null && !MotaSystem.uiManager.hasRunningUI(Defination.UILayer.Main):
			if MotaSystem.CurrentMap.eventgrid.has(m_tilePosition):
				MotaSystem.CurrentMap.eventgrid[m_tilePosition].erase(self)
				if MotaSystem.CurrentMap.eventgrid[m_tilePosition].is_empty():
					MotaSystem.CurrentMap.eventgrid.erase(m_tilePosition)
			if !MotaSystem.CurrentMap.eventgrid.has(v):
				MotaSystem.CurrentMap.eventgrid[v] = []
			MotaSystem.CurrentMap.eventgrid[v].push_front(self)
			imoving = true
		m_tilePosition = v
		if imoving && self.current_page is MonsterEvent:
			MotaSystem.CurrentMap.clear_range_cache()
			MotaSystem.CurrentMap.show_damage_point()
			# 这个仍需优化 需要防止同一刻因为怪物移动和玩家掉血刷新两次显伤
			MotaSystem.enemyReady.refresh()
# 方向
var m_dir:Defination.direction
var dir:Defination.direction:
	get:
		return m_dir
	set(value):
		if sprite != null:
			if !sprite.noDirection:
				sprite.frame = (value * 4) + (startSpriteFrameIndex % 4)
				m_dir = value
# 速度
var speed:float = 7.0
# sprite
var sprite:FrameAnimation:
	set(value):
		sprite = value
		startSpriteFrameIndex = value.frame
		m_dir = floori(startSpriteFrameIndex / 4)
# 移动用变量
var destination:Vector2 = Vector2.ZERO
# 跳跃用变量
var jumpPeak = 0
var jumpCount = 0
# 跳跃平移标定变量
var translationPos:Vector2
# jumping?
var jumping:
	get:
		return jumpCount > 0
signal jump_end
# 事件操控的移动栈
var EventMovingStack = Stack.new()
var moveto:int = 0

var characterEventMoveEndCallbacks:Array[Callable]

# 动画位置
var animPosition:
	get:
		if sprite == null || sprite.texture == null:
			return self.global_position
		var offset = Vector2((sprite.texture.get_width() / sprite.vframes) / 2, (sprite.texture.get_height() / sprite.hframes) / 2)
		var pos = (self.global_position + offset + sprite.offset)
		return pos
#------------------------------------------------------
# player表上的ID
var playerID
# 跟随者
var follower:GameCharacter
# 跟随下一步动作
var followMove
# 允许通行
var allPass:bool = false
# 存档用数据
var characterData:
	get:
		return {
			"playerID": self.playerID,
			"followMove": self.followMove,
			"position": self.tilePosition,
			"direction": self.dir,
		}

func _enter_tree() -> void:
	# 初始化character基本信息
	initCharacter()

# Called when the node enters the scene tree for the first time.
func _ready():
	# 默认拿第一个子节点当做sprite，没有直接报错
	sprite = get_child(0)

func initCharacter():
	# 初始化基本信息
	tilePosition = Utility.worldPos2TilePos(self.position)

func resetpos():
	self.position = Utility.tilePos2WorldPos(tilePosition)
	destination = Vector2.ZERO
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if followMove == null:
		move_update(delta)
	if jumping:
		jump_update(delta)

func move_update(delta):
	if destination.y > 0: #向上
		var distance = [140 * delta * speed, destination.y].min()
		self.position.y -= distance
		destination.y -= distance
	elif destination.y < 0: #向下
		var distance = [140 * delta * speed, - destination.y].min()
		self.position.y += distance
		destination.y += distance
	if destination.x < 0: #向左
		var distance = [140 * delta * speed, - destination.x].min()
		self.position.x -= distance
		destination.x += distance
	elif destination.x > 0: #向右
		var distance = [140 * delta * speed, destination.x].min()
		self.position.x += distance
		destination.x -= distance
	if destination.x == 0 && destination.y == 0 && moving:
		moving = false
	if follower != null:
		follower.speed = speed
		follower.move_update(delta)
	# 事件控制的移动栈
	if !moving:
		if !EventMovingStack.is_empty():
			var d = (EventMovingStack.pop() / 2) - 1
			if d == Defination.direction.up:
				if move_up() == true && moveto > 0:
					EventMovingStack.push((d + 1) * 2)
			if d == Defination.direction.down:
				if move_down() == true && moveto > 0:
					EventMovingStack.push((d + 1) * 2)
			if d == Defination.direction.left:
				if move_left() == true && moveto > 0:
					EventMovingStack.push((d + 1) * 2)
			if d == Defination.direction.right:
				if move_right() == true && moveto > 0:
					EventMovingStack.push((d + 1) * 2)
		else:
			# 移动结束回调
			for callback in characterEventMoveEndCallbacks:
				callback.call()
				characterEventMoveEndCallbacks.clear()

func jump_update(delta):
	# 跳跃计数减 1
	jumpCount -= 1
	# 计算新坐标
	translationPos.x = (translationPos.x * jumpCount + tilePosition.x * Defination.tilesize) / (jumpCount + 1)
	translationPos.y = (translationPos.y * jumpCount + tilePosition.y * Defination.tilesize) / (jumpCount + 1)
	
	# 取跳跃计数小的 Y 坐标
	var n
	if jumpCount >= jumpPeak:
		n = jumpCount - jumpPeak
	else:
		n = jumpPeak - jumpCount
		
	self.position = Vector2(translationPos.x, translationPos.y - (jumpPeak * jumpPeak - n * n) )# / 2)
	
	if !jumping:
		jump_end.emit()

func setPosition(pos:Vector2i):
	tilePosition = pos
	self.destination = Vector2.ZERO
	self.position = Utility.tilePos2WorldPos(pos)

func passable(d:Defination.direction) -> bool:
	if allPass || (self is GameEvent && self.eventPassable):
		return true
	var facePos = checkFacePos(d)
	#先看图块通行和事件通行
	var result = MotaSystem.CurrentMap.isMapPassable(facePos) && (MotaSystem.CurrentMap.isEventPassable(facePos,self) || (self is GameEvent && self.current_page is MonsterEvent))
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

func checkFacePos(d,frontPos:Vector2i = Vector2i(tilePosition.x,tilePosition.y)) -> Vector2i:
	if d == Defination.direction.up:
		frontPos.y -= 1
	if d == Defination.direction.down:
		frontPos.y += 1
	if d == Defination.direction.left:
		frontPos.x -= 1
	if d == Defination.direction.right:
		frontPos.x += 1
	return frontPos
	
func checkFaceEvent(d: Defination.direction):
	return MotaSystem.CurrentMap.checkEvent(checkFacePos(d))

func jump(x_plus,y_plus):
	# 增加值不是 (0,0) 的情况下
	if x_plus != 0 or y_plus != 0:
		# 横侧距离长的情况下
		if abs(x_plus) > abs(y_plus):
			# 变更左右方向
			if x_plus < 0:
				dir = Defination.direction.left
			else:
				dir = Defination.direction.right
		# 竖侧距离长的情况下
		else:
			# 变更上下方向
			if y_plus < 0:
				dir = Defination.direction.up
			else:
				dir = Defination.direction.down
	# 计算新的坐标
	tilePosition = Vector2i(tilePosition.x + x_plus,tilePosition.y + y_plus)
	# 
	translationPos = self.position
	# 矫正姿势
	#straighten
	# 距计算距离
	var distance = round(sqrt(x_plus * x_plus + y_plus * y_plus)) 
	# 设置跳跃记数
	jumpPeak = 10 + distance - 5#speed
	jumpCount = jumpPeak * 2

func move_up():
	dir = Defination.direction.up
	if passable(Defination.direction.up):
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

func move_down():
	dir = Defination.direction.down
	if passable(Defination.direction.down):
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

func move_left():
	dir = Defination.direction.left
	if passable(Defination.direction.left):
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
	
func move_right():
	dir = Defination.direction.right
	if passable(Defination.direction.right):
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

func increase_step():
	pass

func checkIdle():
	await get_tree().create_timer(0.1).timeout
	if !moving && !sprite.idleAnim:
		sprite.stop()

func setEventMoveIdle(callback:Callable):
	characterEventMoveEndCallbacks.append(callback)

#玩家转身
func playerTurn():
	if(sprite.frame>=0 && sprite.frame<=3):
		#朝左
		dir = 1
	elif (sprite.frame>=4 && sprite.frame<=7):
		#朝上
		dir = 3
	elif (sprite.frame>=8 && sprite.frame<=11):
		#朝下
		dir = 0
	else:
		#朝右
		dir = 2

#玩家逆向转身
func playerTurnPrev():
	if(sprite.frame>=0 && sprite.frame<=3):
		#朝右
		dir = 2
	elif (sprite.frame>=4 && sprite.frame<=7):
		#朝下
		dir = 0
	elif (sprite.frame>=8 && sprite.frame<=11):
		#朝上
		dir = 3
	else:
		#朝左
		dir = 1

func getDirectionByOtherPos(otherPos:Vector2i):
	var xx = otherPos.x - tilePosition.x
	var yy = otherPos.y - tilePosition.y
	if yy >= xx && yy >= -xx:
		return Defination.direction.down
	elif yy >= xx && yy <= -xx:
		return Defination.direction.left
	elif yy >= -xx && yy <= xx:
		return Defination.direction.right
	elif yy <= xx && yy <= -xx:
		return Defination.direction.up
