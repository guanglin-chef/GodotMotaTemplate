@tool
extends EditorPlugin

var mtdock2
var plugin
var fname=PackedStringArray([""])
var func0=func():
	print("func0 called")
var func1=func():
	print("func1 called")

class MT_Inspector extends EditorInspectorPlugin:
	var bobj:GDIns2
	var mtdock2
	func _can_handle(_object):
		return true
	func _parse_property(object: Object, type: int, name: String, hint_type: int, hint_string: String, usage_flags: int, wide: bool ):
		if name!='meta_addon_mt_parse_property':
			return false
		if typeof(object)==0:
			return false
		if object.meta_addon_mt_parse_property!=true:
			return false
		EditorInterface.get_editor_main_screen().get_child(0).get_child(4).emit_signal("menu_changed")
		bobj.controls[0]=object
		return bobj.parse_property(object, type, name, hint_type, hint_string, usage_flags, wide)

class ExampleRouter extends HttpRouter:
	var mtdock2
	var bobj
	var parts=''
	func handle_get(request: HttpRequest, response: HttpResponse):
		# response.send(200, mtdock2.get_child(1).get_child(mtdock2.get_child(1).current_tab).text.uri_encode())
		var cid=bobj.controls[0].get_instance_id()
		if !bobj.controls[0].has_method("meta_addon_mt_pages"):
			cid=bobj.controls[0].get_parent().get_instance_id()
		var cindex=bobj.call_index
		var lengcontent=mtdock2.get_child(1).get_child(mtdock2.get_child(1).current_tab).text.uri_encode()
		response.send(200, JSON.stringify({
			len = len(lengcontent),
			content = lengcontent,
			cid = cid,
			cindex = cindex,
			status = 'done',
		}), "application/json")
	func handle_post(request: HttpRequest, response: HttpResponse):
		var ret=JSON.parse_string(request.body)
		var cid=bobj.controls[0].get_instance_id()
		if !bobj.controls[0].has_method("meta_addon_mt_pages"):
			cid=bobj.controls[0].get_parent().get_instance_id()
		var cindex=bobj.call_index
		if ret.status=='fetch':
			var lengcontent=mtdock2.get_child(1).get_child(mtdock2.get_child(1).current_tab).text.uri_encode()
			response.send(200, JSON.stringify({
				len = len(lengcontent),
				content = lengcontent.substr(ret.start,ret.len),
				cid = cid,
				cindex = cindex,
				status = 'done',
			}), "application/json")
			return
		var texti=ret.content
		if ret.status=='start':
			parts=texti
		if ret.status=='part':
			parts=parts+texti
		if ret.status=='done':
			parts=parts+texti
			var dosave=true
			if cid != ret.cid:
				bobj.parse_property(instance_from_id(ret.cid), 0, "", 0, "", 0, false)
				# prints("cid mismatch",cid,ret.cid)
				# dosave=false
			if cindex != ret.cindex:
				bobj.call_index=ret.cindex
				mtdock2.get_child(1).current_tab = ret.cindex
				# prints("cindex mismatch",cindex,ret.cindex)
				# dosave=false
			if dosave:
				mtdock2.get_child(1).get_child(mtdock2.get_child(1).current_tab).text=parts.uri_decode()
				mtdock2.get_child(0).get_child(0).emit_signal("pressed")
				parts=''
			else:
				prints("!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				prints("!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				prints("!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
				prints("已不是弹出编辑器时的事件, 为了避免错误存储已取消保存, 可以从网页的队列中取出提交的事件")
		response.send(200, JSON.stringify({
			# message = "Hello! from POST+",
			# raw_body = request.body,
			# parsed_body = request.get_body_parsed(),
			status = 'done',
		}), "application/json")

class DynamicRouter extends HttpRouter:
	var lists={}
	func get_all_sprite_paths(node: Node, current_path: String):
		var paths = []
		if node is Sprite2D:
			paths.append(current_path + node.name)
		for child in node.get_children():
			var child_path = current_path + node.name + "/" if current_path else node.name + "/"
			paths.append_array(get_all_sprite_paths(child, child_path))
		return paths
	func buildList():
		lists={}
		if FileAccess.file_exists('./Datatable/Dist/Effect/Effect.gd'):
			var script = load("res://Datatable/Dist/Effect/Effect.gd")
			var instance = script.new()
			var data = instance.data
			var pairs = data.keys().map(func(v): return [data[v]["remind"], str(v)])
			lists["EffectId_List_pair"]=pairs
		if FileAccess.file_exists('./Scene/CommonEvent/CommonEvent.tscn'):
			var events = load("res://Scene/CommonEvent/CommonEvent.tscn").instantiate()
			var sprite_paths = get_all_sprite_paths(events, "")
			lists["CommonEventId_List_pair"]=sprite_paths.map(func(v): return [v.substr(7, -1),v.substr(7, -1)])
		# http://127.0.0.1:24862/dynamic
		# decodeURIComponent(document.body.innerText)
	func handle_get(request: HttpRequest, response: HttpResponse):
		buildList()
		response.send(200, JSON.stringify(lists).uri_encode())

class DebugRouter extends HttpRouter:
	var mtdock2
	var bobj
	var fname
	func eval_code(code:String):
		var script = GDScript.new()
		script.source_code += "extends Node\n"
		script.source_code += "func _eval(thisobj):\n\tpass"
		for line in code.split("\n"):
			script.source_code += "\n\t" + line
		script.reload()
		var nscript = script.new()
		script.unreference()
		return nscript._eval(self)
	func handle_get(request: HttpRequest, response: HttpResponse):
		var cid=bobj.controls[0].get_instance_id()
		if !bobj.controls[0].has_method("meta_addon_mt_pages"):
			cid=bobj.controls[0].get_parent().get_instance_id()
		response.send(200, JSON.stringify([fname,cid,bobj.call_index]))
	func handle_post(request: HttpRequest, response: HttpResponse):
		var ret=JSON.parse_string(request.body)
		response.send(200, JSON.stringify({
			# message = "Hello! from POST+",
			# raw_body = request.body,
			# parsed_body = request.get_body_parsed(),
			status = 'done',
		}), "application/json")
		if ret.code!=null:
			eval_code(ret.code)
			# http://127.0.0.1:24862/debug
			# fetch('/debug',{method: "POST", body: JSON.stringify({code:'print(thisobj)'})})
			# fetch('/debug',{method: "POST", body: JSON.stringify({code:'thisobj.bobj.parse_property(instance_from_id(2581191548344), 0, "", 0, "", 0, false)'})})


var server = HttpServer.new()
var router = ExampleRouter.new()
var dynamicRouter = DynamicRouter.new()
var debugRouter = DebugRouter.new()
func setup_server():
	server.register_router("/data", router)
	server.register_router("/dynamic", dynamicRouter)
	server.register_router("/debug", debugRouter)
	server.register_router("/.*", HttpFileRouter.new(".")) # http://127.0.0.1:24862/icon.svg
	add_child(server)	
	# server.enable_cors(["http://localhost:8060"])
	server.start()

func _enter_tree():
	# print(int('123'),123,int(123))
	mtdock2 = preload("res://addons/mota/mt_dock3.tscn").instantiate()
	mtdock2.name="MT"
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, mtdock2)

	plugin = MT_Inspector.new()
	plugin.bobj = GDIns2.new()
	plugin.mtdock2 = mtdock2
	router.mtdock2 = mtdock2
	router.bobj = plugin.bobj
	debugRouter.mtdock2 = mtdock2
	debugRouter.bobj = plugin.bobj
	debugRouter.fname = fname

	var node=plugin.bobj
	node.controls.push_back(0)
	var funcs=plugin.bobj.funcs
	funcs.push_back(
		func(str1,index):
			# 暂时取消编辑tscn的功能
			if str1=='set_normal_event_click':
				str1="pure_print_click"
			fname[index]=str1
	)#0
	funcs.push_back(
		func(str1,index):
			mtdock2.get_child(1).get_child(index).name=str1
	)#1
	funcs.push_back(
		func(str1,index):
			mtdock2.get_child(1).get_child(index).text=str1
	)#2
	funcs.push_back(
		func(index):
			return mtdock2.get_child(1).get_child(index).text
	)#3

	funcs.push_back(
		func(str1):
			mtdock2.get_child(0).get_child(1).text=str1
	)#4
	funcs.push_back(
		func(count):
			var tocount = count
			if tocount==0:
				tocount=1
			fname.resize(count)
			while mtdock2.get_child(1).get_child_count()<tocount:
				mtdock2.get_child(1).add_child(
					mtdock2.get_child(1).get_child(0).duplicate()
				)
			while mtdock2.get_child(1).get_child_count()>tocount:
				mtdock2.get_child(1).remove_child(
					mtdock2.get_child(1).get_child(mtdock2.get_child(1).get_child_count()-1)
				)
			for ii in range(tocount):
				mtdock2.get_child(1).get_child(ii).name = str(ii)
	)#5
	funcs.push_back(
		func(index):
			mtdock2.get_child(1).current_tab = index
	)#6

	var controls=plugin.bobj.controls
	controls.push_back(mtdock2)
	var objs=plugin.bobj.objs

	plugin.bobj.material_done()

	mtdock2.get_child(0).get_child(0).connect("pressed",func():self.func1.call())

	# mtdock2.get_child(0).get_child(2).connect("pressed",func():OS.execute("cmd.exe", ["/c start msedge --app=http://127.0.0.1:24862/icon.svg"]))
	var webview_cmd="/c start msedge --app=\"data:text/html,<html><body><script>window.moveTo(200,100);window.resizeTo(1920,1080);window.location='http://127.0.0.1:24862/addons/mota/webview/build/blockly.html';</script></body></html>\""
	if FileAccess.file_exists('./addons/mota/webview.cmd'):
		# webview_cmd="/c "+FileAccess.open('./addons/mota/webview.cmd', FileAccess.READ).get_as_text()
		webview_cmd="/c addons\\mota\\webview.cmd"
	mtdock2.get_child(0).get_child(2).connect("pressed",func():OS.execute("cmd.exe", [webview_cmd]))
	
	# funcs[5].call(1)
	# funcs[6].call(0)

	###############
	# objs.resize(1)
	# objs[0]=Label.new()
	# objs[0].text="中文.txt"
	# prints(objs,objs[0].text)
	# plugin.bobj.test_read_cn_file()
	############### 

	add_inspector_plugin(plugin)

	func0=func():
		prints('plugin index',plugin.bobj.call_index)
	func1=func():
		node.call_index=mtdock2.get_child(1).current_tab
		if fname[mtdock2.get_child(1).current_tab]=="":
			func0.call()
		else:
			plugin.bobj[fname[mtdock2.get_child(1).current_tab]].call();
	
	setup_server()


func _exit_tree():
	remove_control_from_docks(mtdock2)
	remove_inspector_plugin(plugin)
	mtdock2.free()
	server.stop()
