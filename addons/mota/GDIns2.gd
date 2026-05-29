@tool
extends Node
class_name GDIns2

# 从rust版移植过来的，从gdscript看会有点不自然，懒得重构了

@export var funcs = []
@export var objs = []
@export var types = []
@export var controls = []
@export var call_index = 0

var pure_print: Array = [""]
var dicts: Array[Dictionary] = []


func material_done():
	print("material_done")

func parse_property(
	object: Object,
	type_: int,
	name: String,
	hint_type: int,
	hint_string: String,
	usage_flags: int,
	wide: bool
):
	if object == null:
		return false

	if object.has_method("meta_addon_mt_pages"):
		print("Pages: ", object)
		set_event_pages(object, 0)
		return false
	else:
		var eventp: Object = object.call("get_parent")
		if eventp != null and eventp.has_method("meta_addon_mt_pages"):
			print("Pages: ", eventp)
			var child_count = int(eventp.call("get_child_count"))
			var childi = 0
			while childi < child_count:
				var this_child: Object = eventp.call("get_child", childi)
				if this_child == object:
					break
				childi += 1
			set_event_pages(eventp, childi)
			return false

	resize_arrays(1)
	set_page_label("<not page>")
	call_index = 0

	if object.has_method("meta_addon_mt_text"):
		print("Text: ", object)
		set_text_array_event(object)
		return false

	if object.has_method("meta_addon_mt_plain"):
		print("Plain: ", object)
		set_plain_text_event(object)
		return false

	print("Normal: ", object)
	set_normal_event(object)
	return false


func set_event_pages(eventp: Object, childi: int):
	var child_count = int(eventp.call("get_child_count"))
	print("该页内容数:", child_count)
	if child_count <= childi:
		resize_arrays(1)
		set_page_label(eventp.get("name"))
		call_index = 0

		set_label("<empty page>")
		set_content("空白页")
		set_print("空白页, 无事发生")
		set_callback("pure_print_click")
		return

	resize_arrays(child_count)
	set_page_label(eventp.get("name"))
	for ii in range(child_count):
		call_index = ii
		var child_obj: Object = eventp.call("get_child", ii)
		if child_obj.has_method("meta_addon_mt_text"):
			set_text_array_event(child_obj)
			continue
		if child_obj.has_method("meta_addon_mt_plain"):
			set_plain_text_event(child_obj)
			continue
		set_normal_event(child_obj)

	call_index = childi
	set_page_tab(childi)


func pure_print_click():
	print(pure_print[call_index])


func set_normal_event(eventobj: Object):
	var eventp: Object = eventobj.call("get_parent")
	var scene_file_path = ""
	var parent_name = ""
	if eventp != null:
		scene_file_path = str(eventp.get("scene_file_path"))
		parent_name = str(eventp.get("name"))
	while scene_file_path == "" and eventp != null:
		eventp = eventp.call("get_parent")
		if eventp == null:
			break
		scene_file_path = str(eventp.get("scene_file_path"))

	scene_file_path = scene_file_path.replace("res:/", ".")
	var file = FileAccess.open(scene_file_path, FileAccess.READ)
	if file == null:
		set_label(eventobj.get("name"))
		set_callback("pure_print_click")
		set_print("不是文本数组, 无事发生")
		set_content("疑似命名结构错误, 请保存场景后再查看")
		return
	var content = file.get_as_text()
	var name = str(eventobj.get("name"))

	var pattern = "(\\[node name=\"%s\"[^\\n]+?/%s\"\\][\\s\\S]+?)(\\n\\[|\\n$)" % [name, parent_name]
	var re = RegEx.new()
	if re.compile(pattern) != OK:
		set_label(eventobj.get("name"))
		set_callback("pure_print_click")
		set_print("不是文本数组, 无事发生")
		set_content("疑似命名结构错误, 请保存场景后再查看")
		return

	var results: Array = []
	for m in re.search_all(content):
		results.push_back(m.get_string(1))

	set_label(eventobj.get("name"))
	if results.size() == 1:
		var d1: Dictionary = {}
		d1["scene_file_path"] = scene_file_path
		d1["previous"] = results[0]
		dicts[call_index] = d1
		set_callback("set_normal_event_click")
		set_content(results[0])
		print("编辑前建议先保存场景")
		return

	print(results)
	set_callback("pure_print_click")
	set_print("不是文本数组, 无事发生")
	set_content("疑似命名结构错误, 请保存场景后再查看")


func set_normal_event_click():
	print("click ok")
	var dock_str = get_content()
	var d1: Dictionary = dicts[call_index]
	var scene_file_path = str(d1.get("scene_file_path", ""))
	var previous = str(d1.get("previous", ""))

	var file = FileAccess.open(scene_file_path, FileAccess.READ)
	if file == null:
		return
	var content = file.get_as_text()
	content = content.replace(previous, dock_str)

	var out_file = FileAccess.open(scene_file_path, FileAccess.WRITE)
	if out_file == null:
		return
	out_file.store_string(content)
	print("编辑成功, 需重新加载场景(菜单 场景>重载已保存场景)")


func set_text_array_event(eventobj: Object):
	var name = "text"
	print("send to dock")
	set_label(eventobj.get("name"))
	var text = eventobj.get(name)
	if typeof(text) == TYPE_NIL:
		var a1 = PackedStringArray()
		a1.push_back("")
		eventobj.set(name, a1)

	var a: PackedStringArray = eventobj.get(name)
	var str1 = ""
	if a.size() > 0:
		str1 = a[0]
	for i in range(1, a.size()):
		str1 = "%s\n[===]\n%s" % [str1, a[i]]

	set_content(str1)
	set_callback("set_text_array_event_click")
	objs[call_index] = eventobj
	print("have sent")


func set_text_array_event_click():
	print("click ok")
	var dock_str = get_content()
	var parts = dock_str.split("\n[===]\n")
	var name = "text"
	var eventobj: Object = objs[call_index]
	var a1 = PackedStringArray()
	for si in parts:
		a1.push_back(si)
	eventobj.set(name, a1)
	print("edit done")


func set_plain_text_event(eventobj: Object):
	var name = "text"
	print("send to dock")
	set_label(eventobj.get("name"))
	var text = eventobj.get(name)
	if typeof(text) == TYPE_NIL:
		eventobj.set(name, "")
	text = eventobj.get(name)
	set_content(text)
	set_callback("set_plain_text_event_click")
	objs[call_index] = eventobj
	print("have sent")


func set_plain_text_event_click():
	print("click ok")
	var dock_str = get_content()
	var name = "text"
	var eventobj: Object = objs[call_index]
	eventobj.set(name, dock_str)
	print("edit done")


func set_print(str1):
	pure_print[call_index] = str1


func set_callback(str1: String):
	funcs[0].callv([str1, call_index])


func set_label(str1):
	funcs[1].callv([str1, call_index])


func set_content(str1):
	funcs[2].callv([str1, call_index])


func get_content():
	return str(funcs[3].callv([call_index]))


func set_page_label(str1):
	funcs[4].callv([str1])


func resize_arrays(count: int):
	dicts.resize(count)
	objs.resize(count)
	pure_print.resize(count)
	funcs[5].callv([count])


func set_page_tab(index: int):
	funcs[6].callv([index])


func _get(property: StringName):
	var method_name = String(property)
	if has_method(method_name):
		return Callable(self, method_name)
	return null