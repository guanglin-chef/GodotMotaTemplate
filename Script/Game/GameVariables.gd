class_name GameVariables

# 游戏变量
var gameVariables:Dictionary

func _init(save):
	InitGameVariables(save)

# *****游戏变量在引用类型内的int类型经过存储后会变为float类型!!!*****
# *****因此需要格外注意这一点！*****
	
func InitGameVariables(save = null):
	gameVariables["temp"] = 1
	gameVariables["debugMode"] = true
	gameVariables["ufo"] = false
	gameVariables["teleport"] = false
	gameVariables["gameMode"] = true  # 游戏模式 true为标准模式 false为mod模式
	gameVariables["mapId"] = 0 # 当前地图ID
	gameVariables["towerId"] = 0 # 当前魔塔编号
	gameVariables["chapterId"] = 0 # 当前章节ID
	gameVariables["gameName"] = "" # 游戏名称
	gameVariables["gameProgress"] = 0 # 游戏主线进程
	gameVariables["specialEventParam"] = 0 # 事件用变量
	gameVariables["shopPrice"] = 20 # 商店价格
	gameVariables["shopValue"] = 3 # 商店能力
	gameVariables["shopIncrease"] = 1 #商店涨幅
	gameVariables["shopOpen"] = false #商店开启
	gameVariables["floorRecord"] = {}  # key:"魔塔编号"  value:[地图编号, ....]
	gameVariables["floorBackup"] = {}  # key:"备份ID"  value:[地图编号, ....]
	gameVariables["showFlyPoint"] = false # 是否显示飞点
	gameVariables["suowei"] = 0 # 缩位
	#当传进来存档时，根据存档中存的值覆盖原先已有的变量
	if (save != null):
		for i in gameVariables.keys():
			if (save.gameData.gameVariables.has(i)):
				gameVariables[i]=save.gameData.gameVariables[i]
	# ban掉ctrl
	gameVariables["debugMode"] = OS.has_feature("editor")
