class_name GameManager
# 根节点
var root:Node
# 游戏数据
var m_GameData:GameData
# 界面
#var m_GameForm:GameForm
var m_GameForm
# 角色管理器，管理角色节点
var m_GamePlayerManager:GamePlayerManager
# 快捷键管理
var m_InputManager:InputManager
# 地图管理器
var m_MapManager:MapManager
# 事件管理器
var m_GameEventManager:GameEventManager
# 提示界面
var m_HintForm:HintForm

func _init(GameRoot:Node):
	root = GameRoot

func Initialize(save):
	print("GameManager Initialize")
	# 创建地图管理系统
	var canvas = MotaSystem.resourceManager.loadFile("res://Scene/Prefab/Canvas.tscn").instantiate()
	root.add_child(canvas)
	if Utility.isPcMode():
		canvas.position = Vector2(320,0)
	else:
		canvas.position = Vector2(0,320)
	var mapRes = MotaSystem.resourceManager.loadFile("res://Scene/Prefab/Map.tscn")
	var map = mapRes.instantiate()
	canvas.get_child(0).add_child(map)
	m_MapManager = map
	# 将需要跟随画布的UI层借调过来
	MotaSystem.uiManager.UILayers[Defination.UILayer.GameViewport].reparent(canvas.get_child(0))
	# 由于canvaslayer不支持保留transform，所以还得再设置一遍位置
	MotaSystem.uiManager.UILayers[Defination.UILayer.GameViewport].offset = Vector2(-320,0)
	# 输入管理节点
	m_InputManager = InputManager.new()
	root.add_child(m_InputManager)
	# -------初始化----------
	# 初始化事件管理器
	m_GameEventManager = GameEventManager.new()
	# 初始化游戏数据
	m_GameData = GameData.new(save)
	# 创建游戏主界面
	#PC端
	if Utility.isPcMode():
		m_GameForm = MotaSystem.uiManager.open(Defination.UIID.GameForm)
	#移动端
	else:
		m_GameForm = MotaSystem.uiManager.open(Defination.UIID.MobileGameForm)
	# 创建提示界面
	m_HintForm = MotaSystem.uiManager.open(Defination.UIID.HintForm)
	# 初始化地图
	m_MapManager.Initialize(save)
	# 快捷键
	m_InputManager.Initialize()
	# 初始化人物管理器
	var playerNode = MotaSystem.resourceManager.loadFile("res://Scene/Prefab/PlayerNode.tscn").instantiate()
	m_MapManager.add_child(playerNode)
	m_GamePlayerManager = playerNode
	m_GamePlayerManager.Initialize(save)

# 场所移动
func transferPlayer(mapKey:int, pos:Vector2i, dir:Defination.direction, fade:bool = true):
	#如果该层有怪物详情没有关闭，则先执行关闭
	if (MotaSystem.CurrentMap.EnemyStateForm != null):
		MotaSystem.CurrentMap.EnemyStateForm.close()
		MotaSystem.CurrentMap.EnemyStateForm = null
	# 清除Game层级的特效
	if MotaSystem.CurrentMap.key != mapKey:
		MotaSystem.effectManager.clearEffect("Game")
	# 关闭飞点可视化
	MotaSystem.gameVariables["showFlyPoint"] = false
	MotaSystem.CurrentMap.ShowFlyPointForMap()
	# 切换地图
	m_MapManager.changeMap(mapKey, fade)
	# 传送！
	MotaSystem.Player.teleport_position(pos)
	
	if dir == 4: # HOLD
		pass
	else:
		MotaSystem.Player.dir = dir

var UFOData
# UFO模式
func startUFO():
	MotaSystem.gameVariables["ufo"] = true
	# 灵魂出窍
	MotaSystem.Player.setUFO(true)
	# 隐藏人体火车
	for i in range(0,MotaSystem.gamePlayerManager.get_children().size()):
		var follower = MotaSystem.gamePlayerManager.get_children()[i]
		if follower.name == "Player":
			continue
		else:
			follower.visible = false
	# 记录进入时的玩家状态
	UFOData = MotaSystem.Player.playerData.duplicate(true)

func endUFO():
	MotaSystem.gameVariables["ufo"] = false
	MotaSystem.Player.setUFO(false)
	# 恢复原先状态
	MotaSystem.mapManager.changeMap(UFOData.mapKey,false)
	MotaSystem.Player.setPosition(UFOData.position)
	MotaSystem.Player.dir = UFOData.direction
	for i in range(0,MotaSystem.gamePlayerManager.get_children().size()):
		var follower = MotaSystem.gamePlayerManager.get_children()[i]
		if follower.name == "Player":
			continue
		else:
			follower.visible = true
