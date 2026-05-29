class_name KeysSettingConfig

# 配置文件路径
var configPath = "user://" + str(GameFirstData.gameIdentifier) + "/KeysSettingConfig.cfg"
# 初始化配置文件对象
var configFile:ConfigFile
# 系统快捷键默认设置
var SystemKeySettingDic:Dictionary
# 快捷键设置配置项
var KeysSettingDic:Dictionary

func _init() -> void:
	configFile = ConfigFile.new()
	var err = configFile.load(configPath)
	if(err==OK):
		pass
	else:
		#读取失败时，创建对应空文本
		var defaultConfigFile = ConfigFile.new()
		defaultConfigFile.set_value("Key","KeysSetting",{})
		defaultConfigFile.save(configPath)
		configFile.load(configPath)
	KeysSettingDic = configFile.get_value("Key","KeysSetting",{})
	getSystemKeySetting()
	FirstLoad()
	
# 获取系统默认设置
func getSystemKeySetting():
	for i in Defination.KeySetting_Name:
		var key_name:String = Defination.KeySetting_Name[i]
		var key_code:String = get_key_name(key_name)
		SystemKeySettingDic[key_name] = key_code
				
# 获取快捷键的键盘按键名称
func get_key_name(action:String):
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			return OS.get_keycode_string(event.keycode)
	return tr("未绑定")
	
#初始化读取
func FirstLoad():
	#合并已读取设置和系统设置，以config为准，已有的按键设置跳过合并
	KeysSettingDic.merge(SystemKeySettingDic,false)
	configFile.set_value("Key","KeysSetting",KeysSettingDic)
	configFile.save(configPath)
	loadKeySettings()
	
#更新快捷键设置
func updateKeySetting(key_name:String,new_key_event:InputEventKey):
	replaceKeyboard(key_name,new_key_event)
	#更新配置项
	KeysSettingDic[key_name] = get_key_name(key_name)
	configFile.set_value("Key","KeysSetting",KeysSettingDic)
	configFile.save(configPath)
	#检测gameform是否存在，存在则刷新
	if MotaSystem.gameForm != null:
		MotaSystem.gameForm.RefreshUI()
	
# 读取config并覆盖按键
func loadKeySettings():
	var key_mapping:Dictionary = KeysSettingDic
	# 替换对应的key
	for action_name in key_mapping:
		var key_char = key_mapping[action_name]
		# 跳过空键或无效的按键
		if not InputMap.has_action(action_name) or key_char == "":
			continue
		# 将字符转为InputEventKey
		var new_key_event = createKeyEventChar(key_char)
		if not new_key_event:
			continue
		# 替换键盘按键
		replaceKeyboard(action_name,new_key_event)

# 将字符转换成inputeventkey
func createKeyEventChar(key_char:String):
	#没检索到长度，有问题，直接返回
	if key_char.length() == 0:
		return null
	var key_event = InputEventKey.new()
	#单字符类按键
	if key_char.length() == 1:
		key_event.keycode = OS.find_keycode_from_string(key_char.to_upper())
		if key_event.keycode == 0:  # OS.find_keycode_from_string失败
			return null
		return key_event
	#特殊字符类按键（tab要转换成KEY_TAB，如此类推）
	var normalized_key = key_char.to_lower()  #统一转小写（确保兼容）
	if Defination.Key_Mappings.has(normalized_key):
		key_event.pressed = true
		key_event.keycode = Defination.Key_Mappings[normalized_key]
		return key_event

# 替换键盘绑定
func replaceKeyboard(action_name:String,new_key_event:InputEventKey) -> void:
	# 获取当前所有绑定事件
	var current_events = InputMap.action_get_events(action_name)
	var non_key_events = []
	# 分离非键盘事件
	for event in current_events:
		if not event is InputEventKey:
			non_key_events.append(event)
	# 添加新键盘事件
	non_key_events.append(new_key_event)
	# InputMap
	InputMap.action_erase_events(action_name)
	for event in non_key_events:
		InputMap.action_add_event(action_name, event)
