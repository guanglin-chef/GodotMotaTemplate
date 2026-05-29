extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# 创建UI根节点
	var UIRoot = Node.new()
	UIRoot.name = "UIRoot"
	add_child(UIRoot)
	# 主界面内UI管理器
	MotaSystem.m_UIManager = UIManager.new(UIRoot)
	MotaSystem.uiManager.open(Defination.UIID.MainForm)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
