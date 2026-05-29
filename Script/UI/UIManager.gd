class_name UIManager


var UILayers = Dictionary()

var UIRoot:Node

func _init(root:Node):
	# 初始化UI根节点
	UIRoot = root
	# 初始化UI层级
	# 严格按照UI的从低到高顺序排列层级顺序
	init_UILayer(Defination.UILayer.GameFormLayer,1,false)
	init_UILayer(Defination.UILayer.GameFormLayerTop,2,false)
	init_UILayer(Defination.UILayer.GameViewport,3,true)
	init_UILayer(Defination.UILayer.Game,4,false)
	init_UILayer(Defination.UILayer.Main,5,false)
	init_UILayer(Defination.UILayer.PopUp,6,false)
	# 通用挂载音效
	UIRoot.get_tree().node_added.connect(_on_node_added)
	

func init_UILayer(layerName:String,layer:int,followViewport:bool):
	UILayers[layerName] = CanvasLayer.new()
	UILayers[layerName].name = layerName
	UILayers[layerName].layer = layer
	UILayers[layerName].follow_viewport_enabled = followViewport
	UIRoot.add_child(UILayers[layerName])

# 打开界面，如果缓存中有则直接调过来
func open(UIID:Defination.UIID, param = null) -> UIForm:	
	# 数据
	var dr = DatatableManager.UI.data[UIID]
	# 初始化
	var form:Control = MotaSystem.resourceManager.loadFile(dr["path"]).instantiate()
	form.name = dr["name"]
	form.initialize(param)
	# 一些动态坐标调整相关的时机
	form.ready.connect(onReadyFinished.bind(form),Object.CONNECT_ONE_SHOT)
	# 放到对应级中
	UILayers[dr["layer"]].add_child(form)
	return form

func onReadyFinished(form):
	await UIRoot.get_tree().process_frame
	if is_instance_valid(UIRoot):
		await UIRoot.get_tree().process_frame
		if form != null:
			form.onReadyFinished()
func openTillClose(UIID:Defination.UIID, param = null) -> UIForm:
	var form:UIForm = open(UIID,param)
	await form.closeSignal
	return form

func openTillReturn(UIID:Defination.UIID, param = null):
	var result
	var form:UIForm = open(UIID,param)
	await form.closeSignal
	if form.get("result") != null:
		result = form.result
	return result

# 获取指定标识的窗口
func getUIForm(UIID:Defination.UIID) -> Array[Node]:
	var dr = DatatableManager.UI.data[UIID]
	if dr == null:
		printerr("ID为{id}的UI配置信息不存在".format(UIID))
		return []
	var result = UILayers[dr["layer"]].find_children(dr["name"],"",false,false)
	return result

# 移除指定标识的窗口
func remove(UIID:Defination.UIID, isDestroy: bool = true):
	var dr = DatatableManager.UI.data[UIID]
	if dr == null:
		printerr("ID为{id}的UI配置信息不存在".format(UIID))
		return
	var nodes = UILayers[dr["layer"]].find_children(dr["name"],"",false,false)
	if isDestroy:
		for i in nodes:
			i.queue_free()
	else:
		# 有需要了再整
		pass

# 关闭个特定的窗口
func removeByNode(form:UIForm, isDestroy:bool = true):
	if isDestroy:
		form.queue_free()
	else:
		# 有需要了再整
		pass

# 对应层内是否有正在运行的UI
func hasRunningUI(layer:String):
	return UILayers[layer].get_child_count() != 0
	
# 清除指定类型窗口
func clearForLayer(layer:String):
	if UILayers[layer].get_child_count() != 0:
		for i in UILayers[layer].get_children():
			i.queue_free()
	
# 清除所有窗口
func clear(isDestroy: bool = true):
	for layer in UILayers:
		for node in layer.get_children():
			if isDestroy:
				node.queue_free()
			else:
				pass

#-------------------通用挂载相关-----------------------------
func _on_node_added(node:Node):
	if node is Button:
		node.pressed.connect(_on_Button_pressed)
		node.focus_entered.connect(_on_Button_focus)
	if node is TextureButton:
		node.pressed.connect(_on_Button_pressed)
	if node is Slider:
		node.focus_entered.connect(_on_Slider_focus)
		
func _on_Button_pressed():
	AudioManager.playSE("UIcertain.wav")
	
func _on_Button_focus():
	if (Input.is_action_pressed("ui_up")):
		AudioManager.playSE("UImove.wav")
	if (Input.is_action_pressed("ui_down")):
		AudioManager.playSE("UImove.wav")
	if (Input.is_action_pressed("ui_left")):
		AudioManager.playSE("UImove.wav")
	if (Input.is_action_pressed("ui_right")):
		AudioManager.playSE("UImove.wav")
		
func _on_Slider_focus():
	AudioManager.playSE("UImove.wav")
