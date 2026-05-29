@tool
extends EditorPlugin

var i18ndock

var btnList=[
['生成文件数组',func(text1):
	var extract_cmd="/c addons\\i18nForMota\\translations_pot_files.cmd"
	OS.execute("cmd.exe", [extract_cmd])
],
['提取事件和表格',func(text1):
	var extract_cmd="/c addons\\i18nForMota\\extract.cmd"
	OS.execute("cmd.exe", [extract_cmd])
],
]

# 添加自定义类型
func _enter_tree():
	i18ndock = preload("res://addons/i18nForMota/i18n_dock.tscn").instantiate()
	i18ndock.name="i18n"
	add_control_to_dock(DOCK_SLOT_LEFT_BR, i18ndock)

	for item in btnList:
		var button = Button.new()
		button.text = item[0]
		var cb=func():
			# item[1].call(i18ndock.get_child(1).get_child(1).text)
			item[1].call('')
		button.connect("pressed",cb)
		i18ndock.add_child(button)

# 移除自定义类型
func _exit_tree():
	remove_control_from_docks(i18ndock)
