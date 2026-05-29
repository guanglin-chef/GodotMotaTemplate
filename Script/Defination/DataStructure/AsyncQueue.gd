class_name AsyncQueue

# 异步队列
# push进东西后不会立刻执行，而是会先排好然后使用.play 后才会依次执行，每次在前一个执行结束后再执行下一个

class AsyncQueueTask:
	var uuid:int
	var callback:Callable
	var callbackParams
	func _init(uuid:int,callback:Callable,callbackParams:Variant):
		self.uuid = uuid
		self.callback = callback
		self.callbackParams = callbackParams

# 任务task的唯一标识
static var _uuid_count: int = 1

# 正在运行的任务
var _runningAsyncTask: AsyncQueueTask = null

var _data: Array[AsyncQueueTask] = []
# 队列
var data: Array[AsyncQueueTask]:
	get:
		return self._data

# 正在执行的异步任务标识
var _isProcessingTaskUUID: int = 0
var _enable: bool = true

# 是否开启可用
var enable:
	get:
		return self._enable
	set(value):
		pass

# 任务队列完成回调
var complete: Callable

func _init() -> void:
	self._data=[]
	self._isProcessingTaskUUID = 0
	self._runningAsyncTask = null

# 添加一个异步任务到队列中
# 传入的callback函数必须为以下格式：
#func (next: Callable, params: Variant, args: Variant) -> void:
#	pass
#其中next参数入的函数参数为(nextArgs:Variant = null)

# example
	#var queue := AsyncQueue.new()
	#queue.push(
		#func (next: Callable, params: Variant, args: Variant) -> void:
			#MotaSystem.resourceManager.preloadDir("res://Scene/Prefab")
			#next.call()
	#,null)
func push(callback: Callable, callbackParam: Variant) -> int:
	var uuid = AsyncQueue._uuid_count
	AsyncQueue._uuid_count += 1
	self._data.append(
		AsyncQueueTask.new(uuid,callback,callbackParam)
	)
	return uuid

# 移除一个还未执行的异步任务
func remove(uuid: int):
	if (self._runningAsyncTask.uuid == uuid):
		printerr("正在执行的任务不可以移除")
		return
	for index in range(0,self._data.size()):
		if (self._data[index].uuid == uuid):
			self._data.remove_at(index)
			break
# 长度
func size() -> int:
	return self._data.size()

# 是否有正在处理的任务 
func isProcessing() -> bool:
	return self._isProcessingTaskUUID > 0

# 队列是否已停止
func isStop() -> bool:
	if self._data.size() > 0:
		return false
	if isProcessing():
		return false
	return true

func isEmpty():
	return self._data.is_empty()

#清空队列
func clear():
	self._data=[]
	self._isProcessingTaskUUID = 0
	self._runningAsyncTask = null

#跳过当前正在执行的任务
func step():
	if isProcessing():
		self.next(self._isProcessingTaskUUID)

# 开始运行队列
func play(args = null):
	if isProcessing():
		return
	if !_enable:
		return
	var actionData: AsyncQueueTask = self._data.pop_front()
	#print(actionData)
	if actionData != null:
		self._runningAsyncTask = actionData
		var taskUUID:int = actionData.uuid
		self._isProcessingTaskUUID = taskUUID
		var callback:Callable = actionData.callback
		if callback != null:
			var nextFunc: Callable = func (nextArgs = null):
				self.next(taskUUID, nextArgs)
			callback.call(nextFunc, actionData.callbackParams, args)
	else:
		self._isProcessingTaskUUID = 0;
		self._runningAsyncTask = null;
		if complete:
			complete.call(args)


func next(taskUUID: int, args = null):
	if _isProcessingTaskUUID == taskUUID:
		self._isProcessingTaskUUID = 0
		self._runningAsyncTask = null
		play(args);
	else:
		if _runningAsyncTask:
			print(self._runningAsyncTask)
