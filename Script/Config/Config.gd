class_name Config

# 配置文件路径
#var configPath = "res://Config.cfg"
var configPath = "user://" + str(GameFirstData.gameIdentifier) + "/Config.cfg"
# 初始化配置文件对象
var configFile:ConfigFile
# 基础模板
var defaultConfigFile:DefaultConfigFile

func _init() -> void:
	configFile = ConfigFile.new()
	defaultConfigFile = DefaultConfigFile.new()
	var err = configFile.load(configPath)
	if(err==OK):
		pass
	else:
		#读取文本失败时，直接按照默认设置中的数据存储
		defaultConfigFile.save(configPath)
		configFile = defaultConfigFile
	#调整实际音乐音效效果，到-60db就mute
	Utility.setBusVolume(1,getValue("Audio","volume"))
	Utility.setBusVolume(2,getValue("Audio","sound"))

	#与defaultconfigfile作对比，如果有缺失的字段，则覆盖缺失字段
	for i in defaultConfigFile.get_sections():
		for j in defaultConfigFile.get_section_keys(i):
			print("大节点:",i)
			print("小节点:",j)
			if configFile.has_section_key(i,j) == false:
				setValue(i,j,defaultConfigFile.get_value(i,j))
				
	# 更新修正魔塔总章节数
	setValue(GameFirstData.gameIdentifier,"AllChapters",GameFirstData.gameChapters)
	
	# 全屏
	if configFile.has_section_key("GameScreen","fullscreen") == true:
		if getValue("GameScreen","fullscreen") == true:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	# 语言
	if configFile.has_section_key("Language","language") == false:
		setValue("Language","language",0)

func setValue(section:String,key:String,value:Variant):
	configFile.set_value(section,key,value)
	configFile.save(configPath)

func getValue(section:String,key:String):
	if (configFile.has_section_key(section,key)):
		return configFile.get_value(section,key)
	else:
		return 0
