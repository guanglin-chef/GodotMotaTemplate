class_name ResourceManager

# 进度条信号
signal load_progress(ratio:float)

# 控制所有资源的缓存
# 必须用变量存否则refcounted在引用归零后会自动释放
var cachedResources:Dictionary
var free_int:int = 0

var mapRes:Dictionary

func _init() -> void:
	cachedResources = {}
	# mapRes  {key: 通向具体地图的路径，value：map的节点资源}
	mapRes = {}

func internalPreload(path:String):
	var pathT = path.trim_suffix(".remap")
	var result = ResourceLoader.load(pathT)
	if result == null:
		return Error.FAILED
	if !cachedResources.has(pathT):
		cachedResources[pathT] = result

func internalLoad(path:String):
	var pathT = path.trim_suffix(".remap")
	var result = ResourceLoader.load(pathT)
	if !cachedResources.has(pathT):
		cachedResources[pathT] = result
	return result
	
func internalGetCache(path:String):
	var pathT = path.trim_suffix(".remap")
	return cachedResources[pathT]

# 预加载
func preloadFile(path: String):
	var pathT = path.trim_suffix(".remap")
	var error = internalPreload(pathT)
	if error:
		printerr(error)
	else:
		pass
		#print("preload resource " + pathT + " succeed!")
		
# 加载，如果没有缓存就用load，有缓存就用load_threaded_get
func loadFile(path: String):
	var pathT = path.trim_suffix(".remap")
	var result
	if cachedResources.has(pathT):
		#有缓存
		result = internalGetCache(pathT)
		#print("get cached resource: " + pathT +" succeed!")
	else:
		#没有缓存
		result = internalLoad(pathT)
		#print("load resource: " + pathT +" succeed!")
	return result

# 预加载整个文件夹
func preloadDir(path: String, listener = null):
	var pathT = path.trim_suffix(".remap")
	if listener is Callable:
		load_progress.connect(listener.call_deferred)
	var list = scan(pathT)
	for index in range(0,list.size()):
		var file = list[index]
		var error = internalPreload(pathT + "/" + file)
		if error:
			printerr(error)
		else:
			#print("preload resource " + pathT + "/" + file + " succeed!")
			load_progress.emit(float(index*1.0/list.size()), file)
	if listener is Callable:
		load_progress.disconnect(listener.call_deferred)
		
# 预加载整个文件夹（递归）
func preloadDirRecur(path: String, listener = null):
	var pathT = path.trim_suffix(".remap")
	if listener is Callable:
		load_progress.connect(listener.call_deferred)
	var list = scan(pathT)
	for index in range(0,list.size()):
		var file = list[index]
		var error = internalPreload(pathT + "/" + file)
		if error:
			printerr(error)
		else:
			#print("preload resource " + pathT + "/" + file + " succeed!")
			load_progress.emit(float(index*1.0/list.size()), file)
	var folders = scanFolder(pathT)
	for index in range(0,folders.size()):
		var folder = folders[index]
		preloadDirRecur(pathT + "/" + folder)
	if listener is Callable:
		load_progress.disconnect(listener.call_deferred)

# 加载文件夹，如果没有缓存就用load，有缓存就用load_threaded_get
func loadDir(path: String):
	var pathT = path.trim_suffix(".remap")
	var result = {}
	var list = scan(pathT)
	for file:String in list:
		var key = file.split(".")[0]
		var pathStr = pathT + "/" + file
		if cachedResources.has(pathStr):
			#有缓存
			result[key] = internalGetCache(pathStr)
			#print("get cached resource: " + pathStr +" succeed!")
		else:
			#没有缓存
			result[key] = internalLoad(pathStr)
			#print("load resource: " + pathStr +" succeed!")
	return result

# 加载单个地图
func loadMap(key:int):
	var pathT = DatatableManager.Map.data[key]["path"]
	if cachedResources.has(pathT):
		#有缓存
		mapRes[key] = internalGetCache(pathT)
		#print("get cached resource: " + pathT +" succeed!")
	else:
		#没有缓存
		var temp = internalLoad(pathT)
		if !mapRes.has(key):
			mapRes[key] = temp
		#print("load resource: " + pathT +" succeed!")

# 扫描一个文件夹内所有文件（非递归）
func scan(path:String) -> Array:
	var result = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if !dir.current_is_dir() && !fileName.ends_with("import"):
				result.append(fileName)
			fileName = dir.get_next()
	else:
		pass
		#print("Failed to open path:" + path)
	return result

# 扫描一个文件夹内所有文件夹（非递归）
func scanFolder(path:String) -> Array:
	var result = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if dir.current_is_dir():
				result.append(fileName)
			fileName = dir.get_next()
	else:
		pass
		#print("Failed to open path:" + path)
	return result
