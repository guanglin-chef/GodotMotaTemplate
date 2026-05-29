extends Node

@export var Splash_Picture:Array[TextureRect]

var tween:Tween

var preloadForm:PreloadForm

signal splash_signal

var current_splash:int

# 机器码检测
var code_check:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():

	# move out from autoload
	DatatableManager.p_ready()
	Defination.p_ready()
	get_tree().root.call_deferred("add_child", AudioManager.get_instance())
	AudioManager.p_ready()
	MotaSystem.p_ready(self)
	# 将 SessionTracker 挂到根节点以全程监听 X 关闭事件（PCK 内嵌和独立运行均生效）
	var _tracker := MotaSystem.SessionTracker.new()
	_tracker.name = "GameSessionTracker"
	get_tree().root.call_deferred("add_child", _tracker)
	
	# 创建UI根节点
	var UIRoot = Node.new()
	UIRoot.name = "UIRoot"
	add_child(UIRoot)
	# 游戏内UI管理器
	MotaSystem.m_UIManager = UIManager.new(UIRoot)
	
	if GameFirstData.test:
		for pic in Splash_Picture:
			tween = create_tween()
			tween.tween_property(pic,"modulate", Color(1,1,1,0), 0.5)
			tween.tween_property(pic,"modulate", Color(1,1,1,1), 0.3)
			tween.tween_property(pic,"modulate", Color(1,1,1,1), 1)
			tween.tween_property(pic,"modulate", Color(1,1,1,0), 0.3)
			tween.tween_property(pic,"modulate", Color(1,1,1,0), 0.5)
			tween.play()
			tween.tween_callback(func():
				tween.stop()
				splash_signal.emit()
			)
			#等待tween动画行下一步
			await splash_signal
			current_splash += 1
	
	# 先加载预加载的界面场景
	preloadForm = MotaSystem.uiManager.open(Defination.UIID.PreloadForm)
	WorkerThreadPool.add_task(preLoad)

func _input(event):
	if GameFirstData.test:
		if current_splash < Splash_Picture.size():
			if event.is_pressed():
				tween.kill()
				Splash_Picture[current_splash].modulate = Color(1,1,1,0)
				splash_signal.emit()

func on_error(verbose:String):
	preloadForm.refuselabel.text = verbose

func preLoad():
	# 验证
	if !OS.has_feature("editor"): # 仅在非编辑器开启时检测
		## 做你想做的验证
		pass
	# 开始
	preloadForm.startPreload.call_deferred()
	# 加载各个预制件场景
	#preloadForm.updateLabel.call_deferred(tr("加载预制件场景"))
	MotaSystem.resourceManager.preloadDir("res://Scene/Prefab", progressListener)
	# 加载UI场景
	#preloadForm.updateLabel.call_deferred(tr("加载UI场景"))
	MotaSystem.resourceManager.preloadDir("res://Scene/UI/UIForm", progressListener)
	# 加载行走图
	#preloadForm.updateLabel.call_deferred(tr("加载行走图"))
	#MotaSystem.resourceManager.preloadDirRecur("res://Resources/Character", progressListener)
	# 进入主菜单流程
	MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainMenu)

func progressListener(progress, path):
	preloadForm.updateBar.call_deferred(progress * 100)
	preloadForm.updateLabel.call_deferred(path + tr("加载完毕"))
