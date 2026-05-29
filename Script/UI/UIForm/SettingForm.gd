class_name SettingForm extends UIForm

# 设置框体
@export var SettingFormBoard:PanelContainer
# 语言选项
@export var LanguageBtn:OptionButton
# 全屏按钮
@export var FullScreenBtn:CheckButton
# 具体分辨率选项
@export var ScreenSize:OptionButton
# 音量实际大小
@export var VolumeValue:Label
# 音量设置
@export var VolumeSet:HSlider
# 音效实际大小
@export var SoundValue:Label
# 音效设置
@export var SoundSet:HSlider
# 移速大小
@export var MoveSpeedValue:Label
# 移速设置
@export var MoveSpeedSet:HSlider
# 地图数值显示按钮
@export var FloorResourceDisplay:CheckButton
# 楼层资源显示按钮
@export var MapValueDisplay:CheckButton
# 自动切装按钮
@export var AutoSwitchBtn:CheckButton
# 自动拾取按钮
@export var AutoPickUpBtn:CheckButton
# 自动清怪按钮
@export var AutoClearMonsterBtn:CheckButton
# 楼传切换BGM按钮
@export var TeleportBgmBtn:CheckButton
# 单击瞬移按钮
@export var BlinkBtn:CheckButton
# 取消并返回按钮
@export var ReturnBtn:Button

#------------------参数--------------------
var screen_size_type:int = 0
# 系统界面
var system_form:SystemForm

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	#调整上下聚焦
	ReturnBtn.focus_neighbor_bottom = FullScreenBtn.get_path()
	FullScreenBtn.focus_neighbor_top = ReturnBtn.get_path()
	ReturnBtn.grab_focus.call_deferred()
	self.openAnim(0.15)
	# 正式版不能动态调
	LanguageBtn.get_parent().get_parent().visible = GameFirstData.test
	# 调整语言下拉框的样式
	var language_pop = LanguageBtn.get_popup()
	language_pop.add_theme_font_size_override("font_size", 30)
	language_pop.add_theme_constant_override("v_separation", 20)
	var language_font = load("res://Resources/Font/ChillRoundGothic_Medium.otf")
	language_pop.add_theme_font_override("font",language_font)

func initialize(param):
	if param != null:
		system_form = param
	ReturnBtn.pressed.connect(onBtnReturnClick)
	VolumeSet.value_changed.connect(VolumeValueChange)
	SoundSet.value_changed.connect(SoundValueChange)
	MoveSpeedSet.value_changed.connect(MoveSpeedValueChange)
	FullScreenBtn.button_up.connect(FullScreenChange)
	MapValueDisplay.button_up.connect(MapValueDisPlayChange)
	FloorResourceDisplay.button_up.connect(FloorResourceDisPlayChange)
	AutoPickUpBtn.button_up.connect(AutoPickUpChange)
	AutoClearMonsterBtn.button_up.connect(AutoClearMonsterChange)
	AutoSwitchBtn.button_up.connect(AutoSwitchChange)
	TeleportBgmBtn.button_up.connect(TelportBgmChange)
	BlinkBtn.button_up.connect(BlinkChange)
	ScreenSize.item_selected.connect(ScreenSizeChange)
	LanguageBtn.item_selected.connect(LanguageChange)
	loadSettings()
	VolumeValue.text = str(VolumeSet.value)
	SoundValue.text = str(SoundSet.value)
	MoveSpeedValue.text = str(MoveSpeedSet.value)
	updatePagePanelPosition(SettingFormBoard)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		close()
		if system_form != null:
			system_form.select_system_btn.grab_focus()
			#阻止同时关闭系统设置，阻断esc传播
			get_viewport().set_input_as_handled()
		
# 全屏修改保存
func FullScreenChange():
	saveSettings()		
	# 更新屏幕设置
	setScreen()
	
# 分辨率设置修改
func ScreenSizeChange(select_id:int):
	saveSettings()
	# 更新屏幕设置
	setScreen()

func LanguageChange(select_id:int):
	saveSettings()
	MotaSystem.setLanguage()
	if MotaSystem.gameForm != null:
		MotaSystem.gameForm.RefreshUI()

# 地图数值显示修改
func MapValueDisPlayChange():
	saveSettings()
# 楼层资源显示修改
func FloorResourceDisPlayChange():
	saveSettings()
# 自动拾取修改
func AutoPickUpChange():
	saveSettings()
# 自动清怪修改
func AutoClearMonsterChange():
	saveSettings()
# 自动切装修改
func AutoSwitchChange():
	saveSettings()
# 楼传切换BGM修改
func TelportBgmChange():
	saveSettings()
# 单机瞬移
func BlinkChange():
	saveSettings()
# 音量滑块变动
func VolumeValueChange(value:float):
	VolumeValue.text = str(VolumeSet.value)
	saveSettings()
	
# 音效滑块变动
func SoundValueChange(value:float):
	SoundValue.text = str(SoundSet.value)
	saveSettings()
	
# 移速滑块变动
func MoveSpeedValueChange(value:float):
	MoveSpeedValue.text = str(MoveSpeedSet.value)
	saveSettings()

func onBtnReturnClick():
	close()
	if system_form != null:
		system_form.select_system_btn.grab_focus()
	
func saveSettings():
	MotaSystem.m_Config.setValue("Language","language",LanguageBtn.selected)
	MotaSystem.m_Config.setValue("GameScreen","fullscreen",FullScreenBtn.button_pressed)
	MotaSystem.m_Config.setValue("GameScreen","screensizetype",ScreenSize.selected)
	MotaSystem.m_Config.setValue("Audio","volume",VolumeSet.value)
	MotaSystem.m_Config.setValue("Audio","sound",SoundSet.value)
	MotaSystem.m_Config.setValue("Playerspeed","speed",MoveSpeedSet.value)
	MotaSystem.m_Config.setValue("MapValueDisplay","mapvaluedisplay",MapValueDisplay.button_pressed)
	MotaSystem.m_Config.setValue("FloorResourceDisplay","floorresourcedisplay",FloorResourceDisplay.button_pressed)
	MotaSystem.m_Config.setValue("Autopickup","autopickup",AutoPickUpBtn.button_pressed)
	MotaSystem.m_Config.setValue("Autoclearmonster","autoclearmonster",AutoClearMonsterBtn.button_pressed)
	MotaSystem.m_Config.setValue("Autoswitch","autoswitch",AutoSwitchBtn.button_pressed)
	MotaSystem.m_Config.setValue("Teleportbgm","teleportbgm",TeleportBgmBtn.button_pressed)
	MotaSystem.m_Config.setValue("Blink","blink",BlinkBtn.button_pressed)
	#调整实际音乐音效效果，不过我看网上说总线并不是线性加减分贝的，我临时先这么设置了，过-40db基本就听不见了
	AudioServer.set_bus_volume_db(1,(VolumeSet.value-100)*0.4)
	AudioServer.set_bus_volume_db(2,(SoundSet.value-100)*0.4)
	Utility.setBusVolume(1,VolumeSet.value)
	Utility.setBusVolume(2,SoundSet.value)
	# 角色速度效果
	if MotaSystem.m_GameManager != null:
		MotaSystem.Player.speed = MoveSpeedSet.value
		if MotaSystem.enemyReady != null:
			MotaSystem.enemyReady.refresh()

func loadSettings():
	LanguageBtn.selected = MotaSystem.m_Config.getValue("Language","language")
	FullScreenBtn.button_pressed = MotaSystem.m_Config.getValue("GameScreen","fullscreen")
	ScreenSize.selected = MotaSystem.m_Config.getValue("GameScreen","screensizetype")
	VolumeSet.value = MotaSystem.m_Config.getValue("Audio","volume")
	SoundSet.value = MotaSystem.m_Config.getValue("Audio","sound")
	MoveSpeedSet.value = MotaSystem.m_Config.getValue("Playerspeed","speed")
	FloorResourceDisplay.button_pressed = MotaSystem.m_Config.getValue("FloorResourceDisplay","floorresourcedisplay")
	MapValueDisplay.button_pressed = MotaSystem.m_Config.getValue("MapValueDisplay","mapvaluedisplay")
	AutoPickUpBtn.button_pressed = MotaSystem.m_Config.getValue("Autopickup","autopickup")
	AutoClearMonsterBtn.button_pressed = MotaSystem.m_Config.getValue("Autoclearmonster","autoclearmonster")
	AutoSwitchBtn.button_pressed = MotaSystem.m_Config.getValue("Autoswitch","autoswitch")
	TeleportBgmBtn.button_pressed = MotaSystem.m_Config.getValue("Teleportbgm","teleportbgm")
	BlinkBtn.button_pressed = MotaSystem.m_Config.getValue("Blink","blink")
	# 记录初次读取时，分辨率编号
	screen_size_type = MotaSystem.m_Config.getValue("GameScreen","screensizetype")
	
# 调整屏幕分辨率相关设置
func setScreen():
	var window = get_window()
	#保存的同时切换是否全屏
	if FullScreenBtn.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		# 恢复屏幕无边框设置
		window.borderless = false
		#根据当前窗口尺寸设置
		#if screen_size_type != ScreenSize.selected:
		match ScreenSize.selected:
			0:
				get_viewport().size=Vector2(1920,1080)
			1:
				get_viewport().size=Vector2(1600,960)
			2:
				get_viewport().size=Vector2(1200,720)
			3:
				get_viewport().size=Vector2(800,480)
	##将游戏窗口居中
	if !FullScreenBtn.button_pressed:
		var game_screen = get_viewport().size#游戏窗口分辨率
		var windows_screen = DisplayServer.screen_get_size(DisplayServer.get_primary_screen())#系统分辨率
		var center_pos = (windows_screen - game_screen) / 2
		window.position = center_pos
	# 屏幕
	DisplayServer.window_set_current_screen(DisplayServer.get_primary_screen())
