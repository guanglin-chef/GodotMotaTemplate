class_name MobileGameForm extends UIForm

# 状态Icon预制件
@export var State_Icon_Perfab:PackedScene
# 移动端装备预制件
@export var Mobile_Equip_Perfab:PackedScene
#区域名
@export var area_name:Label
# 地图名
@export var map_name:Label
#等级
@export var player_level:Label
#血量
@export var hp:Label
#攻击
@export var atk:Label
#防御
@export var def:Label
#魔防
@export var mdef:Label
#经验
@export var player_exp:Label
#金币
@export var player_gold:Label
#装备列表
@export var playerEquipsList:VBoxContainer
#黄钥匙
@export var yellow_key:Label
#蓝钥匙
@export var blue_key:Label
#红钥匙
@export var red_key:Label
#绿钥匙
@export var green_key:Label
#破墙镐
@export var pickaxe_num:Label
#中心对称飞行器
@export var plane_num:Label
#状态组
@export var PlayerStatesGrid:HBoxContainer
#游戏模式
@export var gameMode:Label
#怪物手册菜单按钮
@export var EnemyMenuBtn:Button
#道具装备菜单按钮
@export var ItemEquipMenuBtn:Button
#楼传按钮
@export var floorBtn:Button
#快捷商店按钮
@export var shopBtn:Button
#存档菜单按钮
@export var saveMenuBtn:Button
#读档菜单按钮
@export var loadMenuBtn:Button
#撤回菜单按钮
@export var autoLoadBtn:Button
#设置菜单按钮
@export var systemMenuBtn:Button
# 显示飞点按钮
@export var showFlyPointBtn:TextureButton

#--------------------------------------------------------------

# 状态详情场景
var stateinfoform
# 装备详情场景
var equipinfoform

#--------------------------------------------------------------

func _ready() -> void:
	RefreshUI()
	EnemyMenuBtn.pressed.connect(onEnemyMenuClick)
	ItemEquipMenuBtn.pressed.connect(onItemEquipMenuClick)
	saveMenuBtn.pressed.connect(onSaveMenuClick)
	loadMenuBtn.pressed.connect(onLoadMenuClick)
	autoLoadBtn.pressed.connect(onAutoLoadMenuClick)
	systemMenuBtn.pressed.connect(onSystemMenuClick)
	shopBtn.pressed.connect(onShopBtnClick)
	floorBtn.pressed.connect(onFloorClick)
	showFlyPointBtn.pressed.connect(onShowFlyPointClick)
	#创建玩家备槽
	creatEquipUI()
	#游戏模式
	if MotaSystem.gameVariables["gameMode"] == true:
		gameMode.text = tr("标准模式")
	else:
		gameMode.label_settings.font_color = Color(0.1,1,1,1)
		gameMode.text = tr("自定义模式")

func _process(delta: float) -> void:
	pass
	
# 刷新界面
func RefreshUI():
	MotaSystem.gameData.reset_snapshot()
	#刷新捷键
	refreshShortccutKeys()
	#刷新地区地图
	refreshMapName()
	#刷新玩家能力
	refreshPlayerAbility()
	#刷新玩家装备
	refreshEquipUI()
	#刷新玩家道具
	refreshItemUI()
	#创建玩家状态
	createStateButtons()
	if MotaSystem.CurrentMap != null:
		MotaSystem.CurrentMap.cold_refresh.emit()
		MotaSystem.enemyReady.refresh()
	
# 刷新快捷键
func refreshShortccutKeys():
	pass
	
# 刷新地区地图
func refreshMapName():
	pass
	
# 刷新玩家能力
func refreshPlayerAbility():
	player_level.text = tr(DatatableManager.Level.data[MotaSystem.gameData.level].name)
	player_level.label_settings.font_color = Color(DatatableManager.Level.data[MotaSystem.gameData.level]["color"])
	hp.text = Utility.fuck(MotaSystem.gameData.hp)
	atk.text = Utility.fuck(MotaSystem.gameData.atk)
	def.text = Utility.fuck(MotaSystem.gameData.def)
	mdef.text = Utility.fuck(MotaSystem.gameData.mdef)
	# 被状态减少属性显示红色
	if MotaSystem.gameData.getStateNum(2) > 0:
		atk.modulate = Color(1,0.5,0.5)
		def.modulate = Color(1,0.5,0.5)
	else:
		atk.modulate = Color(1,1,1)
		def.modulate = Color(1,1,1)
	if MotaSystem.gameData.getStateNum(4) > 0:
		mdef.modulate = Color(1,0.5,0.5)
	else:
		mdef.modulate = Color(1,1,1)
	
	player_gold.text = Utility.fuck(MotaSystem.gameData.gold)
	player_exp.text = Utility.fuck(DatatableManager.Level.data[MotaSystem.gameData.level].expmax - MotaSystem.gameData.expe)
	
# 创建玩家装备槽
func creatEquipUI():	
	for i in playerEquipsList.get_children():
		playerEquipsList.remove_child(i)
		i.queue_free()
	for i in MotaSystem.gameData.equip_slot:
		var equipindex:int = MotaSystem.gameData.equip_slot.find(i)
		var equiplist_child = Mobile_Equip_Perfab.instantiate()
		var temp_param = [equipindex,i]
		equiplist_child.initialize(temp_param)
		equiplist_child.name = i
		playerEquipsList.add_child(equiplist_child)
	
# 刷新玩家装备
func refreshEquipUI():
	for i in playerEquipsList.get_children():
		i.updateEquipSlot()
		i.updateEquipOptions()
	
# 刷新玩家道具
func refreshItemUI():
	#黄钥匙
	yellow_key.text = str(MotaSystem.gameData.getItemNum(1))
	#蓝钥匙
	blue_key.text = str(MotaSystem.gameData.getItemNum(2))
	#红钥匙
	red_key.text = str(MotaSystem.gameData.getItemNum(3))
	#绿钥匙
	green_key.text = str(MotaSystem.gameData.getItemNum(4))
	#红钥匙
	pickaxe_num.text = str(MotaSystem.gameData.getItemNum(5))
	#红钥匙
	plane_num.text = str(MotaSystem.gameData.getItemNum(6))
	
#创建状态组
func createStateButtons():
	#清理状态按钮
	for i in PlayerStatesGrid.get_children():
		PlayerStatesGrid.remove_child(i)
		i.queue_free()
	#创建状态按钮
	#var temp_status=""
	for i in MotaSystem.gameData.state:
		addState(i.to_int())
		
#实例化状态按钮
func addState(state_id):
	var State_child = State_Icon_Perfab.instantiate()
	State_child.initialize(state_id)
	State_child.name = str(DatatableManager.State.data[state_id]["id"])
	State_child.pressed.connect(onStateBtnClick.bind(State_child))
	PlayerStatesGrid.add_child(State_child)
	
func onStateBtnClick(State_button:Node):
	#场景存在时，需要先关闭场景
	if (stateinfoform != null):
		stateinfoform.close()
		stateinfoform = null
	var button_index:int = State_button.name.to_int()
	stateinfoform = MotaSystem.uiManager.open(Defination.UIID.StateInfoForm,button_index)
	
func onEnemyMenuClick():
	await openSubForm_2(Defination.UIID.EnemyHandBookForm, true)
	#EnemyMenuBtn.grab_focus()
func onFloorClick():
	await openSubForm_2(Defination.UIID.TeleportForm)

func onItemEquipMenuClick():
	await openSubForm_2(Defination.UIID.ItemEquipForm, true)
	#ItemEquipMenuBtn.grab_focus()
	
func onSaveMenuClick():
	if !MotaSystem.mapManager.preview:
		await openSubForm_2(Defination.UIID.SaveForm, true)
	
func onLoadMenuClick():
	await openSubForm_2(Defination.UIID.SaveForm, false)
	
func onAutoLoadMenuClick():
	AudioManager.playSE("RPG3_UI_PositiveAlert01.wav")
	if MotaSystem.saveManager.AutoLoad() == false:
		MotaSystem.hintForm.showHint(tr("没有可用的自动存档！"))
	
func onSystemMenuClick():
	await openSubForm_2(Defination.UIID.SystemForm)

func onShopBtnClick():
	if MotaSystem.gameVariables["shopOpen"]:
		MotaSystem.gameEventManager.pushSpecialEvent(Defination.SpecialEventType.ShopEvent)
	else:
		AudioManager.playSE("Negative 10-1.wav")

func onShowFlyPointClick():
	MotaSystem.gameVariables["showFlyPoint"] = true
	MotaSystem.CurrentMap.ShowFlyPointForMap()
