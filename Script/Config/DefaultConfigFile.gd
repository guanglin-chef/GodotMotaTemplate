class_name DefaultConfigFile extends ConfigFile

func _init() -> void:
	set_value("Language","language",0)
	set_value("GameScreen","fullscreen",false)
	set_value("GameScreen","screensizetype",1)
	set_value("Audio","volume",60.0)
	set_value("Audio","sound",80.0)
	set_value("Playerspeed","speed",4.5)
	set_value("MapValueDisplay","mapvaluedisplay",true)
	set_value("FloorResourceDisplay","floorresourcedisplay",false)
	set_value("Autopickup","autopickup",false)
	set_value("Autoclearmonster","autoclearmonster",false)
	set_value("Autoswitch","autoswitch",false)
	set_value("Teleportbgm","teleportbgm",false)
	set_value("Blink","blink",false)
	set_value("PlayTime","playtime",0)
	set_value(GameFirstData.gameIdentifier,"AllChapters",GameFirstData.gameChapters)
	for i in range(GameFirstData.gameChapters):
		set_value(GameFirstData.gameIdentifier,"Chapter" + str(i + 1),false)
