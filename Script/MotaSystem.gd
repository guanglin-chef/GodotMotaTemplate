# 全游戏所有管理器的入口
class_name MotaSystem extends Node

static var m_Config:Config

static var m_KeysSettingConfig:KeysSettingConfig

static var m_ProcedureManager:ProcedureManager

static var m_ResourceManager:ResourceManager

static var m_GameManager:GameManager

static var m_UIManager:UIManager

static var m_SaveManager:SaveManager

static var m_EffectManager:EffectManager

static var StartGameTime:float

static var EndGameTime:float

static func p_ready(node):
	# 记录游戏启动时间戳（Unix 时间戳，差值与时区无关）
	StartGameTime = Time.get_unix_time_from_system()
	# 创建各大模块
	m_ProcedureManager = ProcedureManager.new(node.get_tree())
	m_ResourceManager = ResourceManager.new()
	m_SaveManager = SaveManager.new()
	m_Config = Config.new()
	m_KeysSettingConfig = KeysSettingConfig.new()
	# 语言
	setLanguage()
	# 分辨率
	if Utility.isPcMode():
		setScreen(node)

static func setLanguage():
	var languageID = int(m_Config.getValue("Language","language"))
	match languageID:
		0: # 中文
			TranslationServer.set_locale("zh")
		1: # 英文
			TranslationServer.set_locale("en")
		2: # 日语
			TranslationServer.set_locale("ja")
	# 标题语言切换
	var default_name:String = ProjectSettings.get_setting("application/config/name")
	var name_localized:Dictionary = ProjectSettings.get_setting("application/config/name_localized", {})
	var locale:String = TranslationServer.get_locale()
	var title:String = name_localized.get(locale, "")
	if title.is_empty():
		title = default_name
	DisplayServer.window_set_title(title)

static func setScreen(node):
	var window = node.get_window()
	match m_Config.getValue("GameScreen","screensizetype"):
			0:
				node.get_viewport().size=Vector2(1920,1080)
			1:
				node.get_viewport().size=Vector2(1600,960)
			2:
				node.get_viewport().size=Vector2(1200,720)
			3:
				node.get_viewport().size=Vector2(800,480)
	#游戏窗口分辨率
	var game_screen = node.get_viewport().size
	#系统分辨率
	var windows_screen = DisplayServer.screen_get_size(DisplayServer.get_primary_screen())
	var center_pos = (windows_screen - game_screen) / 2
	window.position = center_pos
	# 屏幕
	DisplayServer.window_set_current_screen(DisplayServer.get_primary_screen())

## 记录游戏结束时间并将本次游戏时长（秒）累加到 config 的 PlayTime/playtime
static func savePlayTime() -> void:
	EndGameTime = Time.get_unix_time_from_system()
	var session_sec: float = EndGameTime - StartGameTime
	if m_Config != null and session_sec > 0:
		var current: float = float(m_Config.getValue("PlayTime", "playtime"))
		m_Config.setValue("PlayTime", "playtime", current + session_sec)

static func clear():
	MotaSystem.m_EffectManager = null
	MotaSystem.m_UIManager = null
	MotaSystem.m_GameManager = null

## 挂载到根节点的会话追踪器，用于拦截 X 关闭窗口事件
class SessionTracker extends Node:
	func _notification(what: int) -> void:
		if what == NOTIFICATION_WM_CLOSE_REQUEST:
			MotaSystem.savePlayTime()

#--------------------------快捷方式------------------------------

static var config:Config:
	get:
		return m_Config
static var keysettingconfig:KeysSettingConfig:
	get:
		return m_KeysSettingConfig
static var procedureManager:ProcedureManager:
	get:
		return m_ProcedureManager
static var resourceManager:ResourceManager:
	get:
		return m_ResourceManager
static var gameManager:GameManager:
	get:
		return m_GameManager
static var uiManager:UIManager:
	get:
		return m_UIManager
static var saveManager:SaveManager:
	get:
		return m_SaveManager
static var effectManager:EffectManager:
	get:
		return m_EffectManager
# 角色管理器，管理角色节点
static var gamePlayerManager:GamePlayerManager:
	get:
		if m_GameManager != null:
			return m_GameManager.m_GamePlayerManager
		return null
# 快捷键管理
static var inputManager:InputManager:
	get:
		if m_GameManager != null:
			return m_GameManager.m_InputManager
		return null
# 地图管理器
static var mapManager:MapManager:
	get:
		if m_GameManager != null:
			return m_GameManager.m_MapManager
		return null
# 事件管理器
static var gameEventManager:GameEventManager:
	get:
		if m_GameManager != null:
			return m_GameManager.m_GameEventManager
		return null

# 游戏数据
static var gameData:GameData:
	get:
		if m_GameManager != null:
			return m_GameManager.m_GameData
		return null
# 游戏变量
static var gameVariables:
	get:
		if m_GameManager != null:
			return m_GameManager.m_GameData.variableManager.gameVariables
		return null

# 游戏中UI
static var gameForm:
	get:
		if m_GameManager != null:
			return m_GameManager.m_GameForm
		return null
# 提示UI
static var hintForm:
	get:
		if m_GameManager != null:
			return m_GameManager.m_HintForm
		return null
# 角色
static var Player:GamePlayer:
	get:
		if m_GameManager != null && m_GameManager.m_GamePlayerManager != null:
			return m_GameManager.m_GamePlayerManager.m_Player
		return null
# 当前地图怪物信息
static var enemyReady:EnemyReady:
	get:
		if m_GameManager != null:
			return m_GameManager.m_MapManager.m_CurrentMap.enemyReady
		return null
# 当前地图
static var CurrentMap:GameMap:
	get:
		if m_GameManager != null:
			if m_GameManager.m_MapManager.m_CurrentMap != null:
				return m_GameManager.m_MapManager.m_CurrentMap
		return null
