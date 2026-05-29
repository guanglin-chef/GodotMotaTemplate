class_name GameEventManager

# 事件队列
var eventQueue:AsyncQueue

#公共事件根节点
var commonEventNode:Node2D

func _init():
	# 初始化事件队列
	eventQueue = AsyncQueue.new()
	# 初始化公共事件所在区域
	commonEventNode = Node2D.new()
	commonEventNode.name = "CommonEventNode"
	commonEventNode.z_index = 1
	MotaSystem.mapManager.add_child(commonEventNode)

# 由EventManager的一个AsyncQueue按顺序一步一步执行，事件中的阻塞（例如等待）会阻塞整个队列的事件，一般的事件都使用push即可
func push(eventStart:Callable,event:GameEvent):
	eventQueue.push(
		func (next: Callable, params: Variant, args: Variant) -> void:
			await eventStart.call()
			next.call()
	,event)

func run():
	if !eventQueue.isProcessing():
		eventQueue.play()

func pushRun(eventStart:Callable,event:GameEvent):
	push(eventStart,event)
	run()

func hasAnyRunningEvent() -> bool:
	return !eventQueue.isEmpty() || eventQueue.isProcessing() || MotaSystem.Player.wait_event.size() > 0

func hasRunningEvent(event:GameEvent) -> bool:
	for data in eventQueue.data: 
		if data.callbackParams == event:
			return true
	if eventQueue.isProcessing(): 
		if eventQueue._runningAsyncTask.callbackParams == event:
			return true
	return false

# 搓一个事件在地图上，并走正常的事件流程
func pushSpecialEvent(type:String):
	var res = MotaSystem.resourceManager.loadFile("res://Scene/Prefab/MapEventPrefab/CombinedEventPerfab.tscn")
	var event:GameEvent = res.instantiate()
	var path = "res://Script/Game/Event/SpecialEvent/{0}.gd".format([type])
	event.get_child(0).set_script(MotaSystem.resourceManager.loadFile(path))
	
	# 挂到特定位置
	commonEventNode.add_child(event)
	
	pushRun(event.initial_page.start,event)
	
# 判断一个主事件是否dead
func MainEventisDead(event_name:String):
	var result:bool = true
	var check_event = MotaSystem.CurrentMap.events.get_node(event_name)
	for i in check_event.get_children():
		if i.visible == true:
			result = false
			break
	print(result)
	return result
	
