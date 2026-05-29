class_name InputManager extends Node

var MovingInputStack:Stack

var nowait = false

# ---------手柄操作用变量---------
var joyLshift = false

var joyRshift = false

func _init() -> void:
	MovingInputStack = Stack.new()

func _process(delta):
	if !DisplayServer.window_is_focused():
		MovingInputStack.data = []
	if Input.get_joy_axis(0,JOY_AXIS_TRIGGER_LEFT) > 0:
		joyLshift = true
	else:
		joyLshift = false
	if Input.get_joy_axis(0,JOY_AXIS_TRIGGER_RIGHT) > 0:
		joyRshift = true
	else:
		joyRshift = false
		

func _input(event: InputEvent) -> void:
	# ------------方向键--------------
	# 按下时压入
	if event.is_action_pressed("move_up"):
		MovingInputStack.push(Defination.direction.up)
	if event.is_action_pressed("move_down"):
		MovingInputStack.push(Defination.direction.down)
	if event.is_action_pressed("move_left"):
		MovingInputStack.push(Defination.direction.left)
	if event.is_action_pressed("move_right"):
		MovingInputStack.push(Defination.direction.right)

	# 松开时弹出
	if event.is_action_released("move_up"):
		MovingInputStack.popInput(Defination.direction.up)
	if event.is_action_released("move_down"):
		MovingInputStack.popInput(Defination.direction.down)
	if event.is_action_released("move_left"):
		MovingInputStack.popInput(Defination.direction.left)
	if event.is_action_released("move_right"):
		MovingInputStack.popInput(Defination.direction.right)

	# 对话加速
	# 这个肯定得弄好
	if event.is_action("fast_text_2"):
		nowait = true
	else:
		nowait = false

	# 只有在无正在运行事件且无main层级UI时，游戏内快捷键才生效
	if !MotaSystem.mapManager.changingMap && !MotaSystem.gameEventManager.hasAnyRunningEvent() && !MotaSystem.uiManager.hasRunningUI(Defination.UILayer.Main) && !MotaSystem.uiManager.hasRunningUI(Defination.UILayer.PopUp):
		# 地图缩放
		if event.is_action_pressed("scale_down"):
			MotaSystem.Player.playerCamera.scaleDown()
		elif event.is_action_pressed("scale_up"):
			MotaSystem.Player.playerCamera.scaleUp()
		#---------角色其他操作-------------
		#转身
		if event.is_action_pressed("turn"):
			MotaSystem.Player.playerTurn()
			if joyRshift:
				if event.is_action_pressed("joy_turn"):
					MotaSystem.Player.playerTurn()
		# 触发面前事件
		if event.is_action_pressed("trigger_face"):
			MotaSystem.Player.triggerEvents(true)
		#---------------小地图---------------
		# 楼传
		if event.is_action_pressed("call_minimap"): 
			MotaSystem.uiManager.open(Defination.UIID.TeleportForm)
		# --------------UI-----------------
		# 各个界面
		if event.is_action_pressed("call_menu"):
			MotaSystem.uiManager.open(Defination.UIID.SystemForm)
		if !MotaSystem.mapManager.preview:
			if event.is_action_pressed("call_save"):
				MotaSystem.uiManager.open(Defination.UIID.SaveForm, true)
		if event.is_action_pressed("call_load"):
			MotaSystem.uiManager.open(Defination.UIID.SaveForm, false)
		if event.is_action_pressed("call_equip"):
			MotaSystem.uiManager.open(Defination.UIID.ItemEquipForm)
		if event.is_action_pressed("call_handbook"):
			MotaSystem.uiManager.open(Defination.UIID.EnemyHandBookForm)
		if event.is_action_pressed("call_shop"):
			if MotaSystem.gameVariables["shopOpen"]:
				MotaSystem.gameEventManager.pushSpecialEvent.call_deferred(Defination.SpecialEventType.ShopEvent)
			else:
				AudioManager.playSE("Negative 10-1.wav")
		# --------------撤回-----------------
		if event.is_action_pressed("auto_load"):
			AudioManager.playSE("RPG3_UI_PositiveAlert01.wav")
			if MotaSystem.saveManager.AutoLoad() == false:
				MotaSystem.hintForm.showHint(tr("没有可用的自动存档！"))
		if joyRshift:
			if event.is_action_pressed("joy_autoload"):
				AudioManager.playSE("RPG3_UI_PositiveAlert01.wav")
				if MotaSystem.saveManager.AutoLoad() == false:
					MotaSystem.hintForm.showHint(tr("没有可用的自动存档！"))	
	

func Initialize():
	self.name = "InputManager"
