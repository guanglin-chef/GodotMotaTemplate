class_name KeySettingForm extends UIForm

# 快捷键预制件
@export var KeySet_Perfab:PackedScene
# 快捷键菜单主框体
@export var KeySettingFormBoard:PanelContainer
# 快捷键组
@export var keySettingGrid:GridContainer
# 返回按钮
@export var ReturnBtn:Button

#------------------参数--------------------
# 系统界面
var system_form:SystemForm

# 所选快捷键按钮名称
var action_name:String
# 所选快捷键按钮
var action_btn:Button
# 是否正在等待按键输入
var is_waiting_for_input = false

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	#调整上下聚焦
	var first_keySetBtn:Button = keySettingGrid.get_child(0).KeyButton
	ReturnBtn.focus_neighbor_bottom = first_keySetBtn.get_path()
	first_keySetBtn.focus_neighbor_top = ReturnBtn.get_path()
	self.openAnim(0.15)
	
func onReadyFinished():
	keySettingGrid.get_child(0).KeyButton.grab_focus.call_deferred()
	#ReturnBtn.grab_focus.call_deferred()
	
func initialize(param):
	if param != null:
		system_form = param
	ReturnBtn.pressed.connect(onBtnReturnClick)
	createKeySettings()
	updatePagePanelPosition(KeySettingFormBoard)
	
func onBtnReturnClick():
	close()	
	if system_form != null:
		system_form.select_system_btn.grab_focus()
	
# 按钮点击事件
func keysetting_pressed(keybtn:Button,keyname:String):
	is_waiting_for_input = true
	action_name = keyname
	action_btn = keybtn
	keybtn.text = tr("按下任意键...")
	
func createKeySettings():
	for i in Defination.KeySetting_Name:
		var key_index:int = i
		var key_name:String = Defination.KeySetting_Name[key_index]
		var key_prefab = KeySet_Perfab.instantiate()
		key_prefab.initialize(key_name)
		key_prefab.KeyButton.pressed.connect(keysetting_pressed.bind(key_prefab.KeyButton,key_name))
		keySettingGrid.add_child(key_prefab)	
		
func updateKeySetting():
	for i in keySettingGrid.get_children():
		i.refresh()
	
# 绑定结果枚举: 提示当前按键设置检查状态
#  - OK: 按键可用
#  - INVALID_KEY: 非法特殊按键（ESC/ENTER等）
#  - ALREADY_BOUND: 已被其他动作占用
enum KeyBindResult { OK, INVALID_KEY, ALREADY_BOUND }

# 检查按键是否已被其他按钮绑定
# key_event: 当前待绑定的按键事件
# exclude_action: 当前正在设置的动作名（避免自身冲突判断）
func is_key_already_bound(key_event:InputEventKey, exclude_action:String) -> bool:
	for action in InputMap.get_actions():
		# 跳过当前正在配置的按钮
		if action == exclude_action:
			continue
		# 跳过 ui 基础动作，避免误判
		if action.begins_with("ui_"):
			continue
		# 跳过调试相关动作
		if action.begins_with("debug"):
			continue
		for event in InputMap.action_get_events(action):
			if event is InputEventKey and _is_same_key_event(event, key_event):
				print("冲突动作: %s" % action)
				return true
	return false

# 对比两个 InputEventKey 是否完全一致（含修饰键）
func _is_same_key_event(a:InputEventKey, b:InputEventKey) -> bool:
	return a.keycode == b.keycode and a.ctrl_pressed == b.ctrl_pressed and a.shift_pressed == b.shift_pressed and a.alt_pressed == b.alt_pressed and a.meta_pressed == b.meta_pressed

# 检查按键是否有效并是否被占用，返回 KeyBindResult
func _check_binding_result(new_key_event:InputEventKey, action_name:String) -> int:
	# 禁用系统保留按键
	if new_key_event.keycode in [KEY_ESCAPE, KEY_ENTER]:
		return KeyBindResult.INVALID_KEY
	if is_key_already_bound(new_key_event, action_name):
		return KeyBindResult.ALREADY_BOUND
	return KeyBindResult.OK

# 显示按键状态提示（当前用按钮文本显示），并恢复焦点
func _show_key_setting_info(msg:String, duration:float = 1.0) -> void:
	if action_btn != null:
		action_btn.text = msg
	await get_tree().create_timer(duration).timeout
	updateKeySetting()
	if action_btn != null:
		action_btn.grab_focus()	
# 将动作绑定到新按键
func rebind_action_to_key(new_key_event:InputEventKey):
	var result = _check_binding_result(new_key_event, action_name)
	match result:
		KeyBindResult.INVALID_KEY:
			_show_key_setting_info(tr("不能绑定系统按键！"))
			return
		KeyBindResult.ALREADY_BOUND:
			_show_key_setting_info(tr("该按键已被使用！"))
			return
		KeyBindResult.OK:
			pass

	# 更新按键设置
	MotaSystem.keysettingconfig.updateKeySetting(action_name, new_key_event)
	_show_key_setting_info(tr("绑定成功！"))
	
func _input(event: InputEvent) -> void:
	if is_waiting_for_input == false and event.is_action_pressed("close_menu"):
		close()
		if system_form != null:
			system_form.select_system_btn.grab_focus()
			#阻止同时关闭系统设置，阻断esc传播
			get_viewport().set_input_as_handled()
	if is_waiting_for_input == true and event is InputEventKey:
		# 避免触发其他输入
		get_viewport().set_input_as_handled()
		if not event.pressed:
			return
		# 重映射按钮
		print(event)
		rebind_action_to_key(event)
		is_waiting_for_input = false
		#updateKeySetting()
