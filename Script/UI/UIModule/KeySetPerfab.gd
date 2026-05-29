class_name KeySetPerfab extends Control

#按钮
@export var KeyButton:Button
#文本
@export var KeyInfo:Label

var key_name:String

func initialize(keyName:String):
	key_name = keyName
	refresh()
	
func refresh():
	KeyButton.text = get_key_name(key_name)
	var key_index:int = Defination.KeySetting_Name.find_key(key_name)
	KeyInfo.text = Defination.KeySetting_text[key_index]
	
# 获取快捷键的键盘按键名称
func get_key_name(action:String):
	var events = InputMap.action_get_events(action)
	for event in events:
		if event is InputEventKey:
			return OS.get_keycode_string(event.keycode)
	return tr("未绑定")
