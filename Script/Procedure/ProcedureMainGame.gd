extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("enter maingame procedure")
	
# 带参数初始化
func initialize(param):
	# 创建特效根节点
	var EffectRoot = Node.new()
	EffectRoot.name = "EffectRoot"
	add_child(EffectRoot)
	# 游戏内特效管理器
	MotaSystem.m_EffectManager = EffectManager.new(EffectRoot)
	# 创建UI根节点
	var UIRoot = Node.new()
	UIRoot.name = "UIRoot"
	add_child(UIRoot)
	# 游戏内UI管理器
	MotaSystem.m_UIManager = UIManager.new(UIRoot)
	# 创建游戏根节点
	var GameRoot = Node.new()
	GameRoot.name = "GameRoot"
	add_child(GameRoot)
	# 创建GameManager
	MotaSystem.m_GameManager = GameManager.new(GameRoot)
	MotaSystem.m_GameManager.Initialize(param)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
