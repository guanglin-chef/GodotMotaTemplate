class_name SaveManager

# 自动存档数量，决定最多能撤回多少步
const AutoSaveMaxNum = 50;
# 存档版本编号：由你所建魔塔的唯一标识符确定
var SaveCode:String = str(GameFirstData.gameIdentifier)
var m_SaveIndex:int = -1

var m_AutoSaveIndex:int
var AutoSaveIndex:int:
	get:
		return m_AutoSaveIndex
	set(value):
		m_AutoSaveIndex = (value + AutoSaveMaxNum) % AutoSaveMaxNum

var key = "Q9W8EY9128EYOIUFIGFTZV89AHBNJEHFHB237"
# 存到文件夹内
var prePath = "user://" + str(GameFirstData.gameIdentifier)

func _init() -> void:
	initAutoSaveIndex()
	DirAccess.make_dir_absolute(prePath)

func initAutoSaveIndex():
	var maxTimestamp = 0
	var maxTimestampIndex = 0
	for i in range(0,AutoSaveMaxNum):
		var save = getAutoSaveFile()
		if save:
			var timestamp = save.time
			if (timestamp > maxTimestamp):
				maxTimestamp = timestamp
				maxTimestampIndex = i
	AutoSaveIndex = maxTimestampIndex

func Save(index:int):
	var save = InternalGenerateSaveData()
	var json = JSON.stringify(save)
	var save_game = FileAccess.open_encrypted_with_pass(prePath + "/motaSave{0}.save".format([index+1]), FileAccess.WRITE, key)

	save_game.store_var(json, true)
	save_game.close()

	m_SaveIndex = index
	MotaSystem.config.setValue("LastSave","Save",index)

func AutoSave():
	AutoSaveIndex += 1
	
	var save = InternalGenerateSaveData()
	var json = JSON.stringify(save)
	var save_game = FileAccess.open_encrypted_with_pass(prePath + "/autoSave{0}.save".format([AutoSaveIndex+1]), FileAccess.WRITE, key)
	save_game.store_var(json, true)
	save_game.close()

func AutoSaveByGeneratedData(json:String):
	AutoSaveIndex += 1
	var save_game = FileAccess.open_encrypted_with_pass(prePath + "/autoSave{0}.save".format([AutoSaveIndex+1]), FileAccess.WRITE, key)
	save_game.store_var(json, true)
	save_game.close()

func ClearAutoSave():
	AutoSaveIndex = 0
	for i in range(0,AutoSaveMaxNum):
		var result = DirAccess.remove_absolute(prePath + "/autoSave{0}.save".format([i+1]))
		print(result)

func Load(index:int):
	var save = getSaveFile(index)
	if save:
		#对存档码进行检测
		if(save.has("saveCode")==true && save["saveCode"] is String && save["saveCode"]==SaveCode):
			if MotaSystem.gameManager != null:
				MotaSystem.mapManager.dispose()
			MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainGame,save)
			m_SaveIndex = index
			print(save)
			return true
			#重开Procedure
		else:
			print("存档码无效，无法读档")
			return true
	else:
		print("No Save File at index ",index)
		return true

func AutoLoad():
	var save = getAutoSaveFile()
	AutoSaveIndex -= 1
	if save:
		#对存档码进行检测
		if(save.has("saveCode")==true && save["saveCode"] is String && save["saveCode"]==SaveCode):
			#重开Procedure
			if MotaSystem.gameManager != null:
				MotaSystem.mapManager.dispose()
			MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainGame,save)
		else:
			print("存档码无效，无法读档")
			return false
	else:
		print("No AutoSave")
		return false
	return true
	
# 读取章节自动存档
func ChapterSaveLoad(chapter_name:String):
	var name:String = chapter_name
	var save = getChapterSaveFile(name)
	if save:
		#对存档码进行检测
		if(save.has("saveCode")==true && save["saveCode"] is String && save["saveCode"]==SaveCode):
			if MotaSystem.gameManager != null:
				MotaSystem.mapManager.dispose()
			MotaSystem.procedureManager.goto_procedure(Defination.ProcedureID.MainGame,save)
			return true
			#重开Procedure
		else:
			print("存档码无效，无法读档")
			return false
	else:
		print("No ChapterSave")
		return false
		return true

func getSaveFile(index:int):
	if not FileAccess.file_exists(prePath + "/motaSave{0}.save".format([index+1])):
		return false
	var save_game = FileAccess.open_encrypted_with_pass(prePath + "/motaSave{0}.save".format([index+1]), FileAccess.READ, key)
	if save_game == null:
		print("Save Encrypted Error")
		return false
	var save_game_string = save_game.get_var(true)
	var json = JSON.new()
	## Check if there is any error while parsing the JSON string, skip in case of failure
	var parse_result = json.parse(save_game_string)
	if parse_result == OK:
		return json.get_data()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_game_string)
		return false

func getAutoSaveFile():
	if not FileAccess.file_exists(prePath + "/autoSave{0}.save".format([AutoSaveIndex+1])):
		return false
	var save_game = FileAccess.open_encrypted_with_pass(prePath + "/autoSave{0}.save".format([AutoSaveIndex+1]), FileAccess.READ, key)
	if save_game == null:
		print("Save Encrypted Error")
		return false
	var save_game_string = save_game.get_var(true)
	var json = JSON.new()
	# Check if there is any error while parsing the JSON string, skip in case of failure
	var parse_result = json.parse(save_game_string)
	if parse_result == OK:
		return json.get_data()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_game_string)
		return false

# 获取章节自动存档
func getChapterSaveFile(challenge_save_name:String):
	var name:String = challenge_save_name
	if not FileAccess.file_exists("res://ChapterSave/" + name + ".save"):
		return false
	var save_game = FileAccess.open_encrypted_with_pass("res://ChapterSave/" + name + ".save", FileAccess.READ, key)
	if save_game == null:
		print("Save Encrypted Error")
		return false
	var save_game_string = save_game.get_var(true)
	var json = JSON.new()
	## Check if there is any error while parsing the JSON string, skip in case of failure
	var parse_result = json.parse(save_game_string)
	if parse_result == OK:
		return json.get_data()
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_game_string)
		return false

func haveSaveFile():
	for i in range(0,Defination.saveMax):
		if FileAccess.file_exists(prePath + "/motaSave{0}.save".format([i+1])):
			return true
	return false

func InternalGenerateSaveData():
	# 遍历地图获取eventData
	var mapData:Dictionary = {}
	var newdata
	var temp_map
	for k in MotaSystem.mapManager.m_Maps:
		var oneMapData:Dictionary = {}
		temp_map = MotaSystem.mapManager.m_Maps[k]
		for event in temp_map.get_node("Events").get_children():
			if event.TempEvent:
				continue
			newdata = event.eventData
			if newdata.size() > 0:
				if !oneMapData.has("eventdata"):
					oneMapData["eventdata"] = {}
				oneMapData["eventdata"][event.name] = newdata
		for evid in temp_map.temp_event:
			var event = temp_map.temp_event[evid]
			if !event["node"].isDead:
				if !oneMapData.has("tempevent"):
					oneMapData["tempevent"] = {}
				newdata = { "id" : event["id"],
							"parameter" : event["node"].eventData
				}
				if event["node"].start:
					newdata["x"] = event["node"].tilePosition.x
					newdata["y"] = event["node"].tilePosition.y
				else:
					newdata["x"] = Utility.worldPos2TilePos(event["node"].position).x
					newdata["y"] = Utility.worldPos2TilePos(event["node"].position).y
				oneMapData["tempevent"][evid] = newdata
		for datakey in temp_map.data:
			if datakey != "eventdata" && datakey != "tempevent":
				oneMapData[datakey] = temp_map.data[datakey]
		if !oneMapData.is_empty():
			mapData[str(k)] = oneMapData
	if MotaSystem.mapManager.mapData.has("mapData"):
		for k in MotaSystem.mapManager.mapData["mapData"].keys():
			if !mapData.has(k):
				mapData[k] = MotaSystem.mapManager.mapData["mapData"][k]
	# gamedata
	var gameData = MotaSystem.gameData.gameData.duplicate()
	# playerdata
	var playerData = MotaSystem.gamePlayerManager.getPlayerData()
	# 地图透明度
	var map_modulate = MotaSystem.mapManager.modulate.to_html()
	# 时间
	var time = Time.get_unix_time_from_system()
	# 完成存储
	var save = {
		"saveCode":SaveCode,
		"gameData":gameData,
		"mapData":mapData,
		"playerData":playerData,
		"map_modulate":map_modulate,
		"time":time
	};
	return save;
