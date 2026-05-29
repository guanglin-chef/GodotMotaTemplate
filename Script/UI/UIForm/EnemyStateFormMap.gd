class_name EnemyStateFormMap extends UIForm

#怪物详情框体
@export
var enemystateform:ReferenceRect
#关闭窗口按钮
@export
var closebutton:TextureButton
#怪物详情子框
@export
var enemystatechildpanel:Array[PanelContainer]
#怪物范围框
@export
var enemyrangeboard:Panel
#怪物范围对象
@export
var enemyrangePerfab:PackedScene
#怪物详情信息按钮
@export
var enemyDetailInfoBtn:Button
@export
var enemyimg:Sprite2D  # 怪物头像
@export
var enemyName:RichTextLabel # 怪物名称
@export
var enemyLevel:RichTextLabel # 怪物等级、
@export
var enemyHp:Label  # 生命
@export
var enemyAtk:Label  # 攻击
@export
var enemyDef:Label  # 防御
@export
var enemyCritical:Label  # 临界点
@export
var enemyTurn:Label  # 回合数
@export
var enemyDamage:RichTextLabel  # 伤害
@export
var buff_state:RichTextLabel  # 状态

## 需要用作额外本地化处理的对象（名称）
@export var localization_texts_1:Array[Node]
## 需要用作额外本地化处理的对象（等级）
@export var localization_texts_2:Array[Node]
## 需要用作额外本地化处理的对象（属性）
@export var localization_texts_3:Array[Node]
## 需要用作额外本地化处理的对象（按钮）
@export var localization_texts_4:Array[Node]

#怪物事件
var enemyevent
#怪物图像
var enemy_texture
# time
var time:float
# 初始帧
var firstindex:int
# 怪物详情数据
var fighter:GameFighter

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	
	self.openAnim(0.2)
	closebutton.pressed.connect(onBtnCloseClick)
	# 关闭按钮、本窗口覆盖大小与地图大小保持同步
	enemyrangeboard.size = Vector2(MotaSystem.CurrentMap.width * Defination.tilesize,MotaSystem.CurrentMap.height * Defination.tilesize)
	closebutton.size = Vector2(MotaSystem.CurrentMap.width * Defination.tilesize,MotaSystem.CurrentMap.height * Defination.tilesize)
	#怪物信息详情按钮
	enemyDetailInfoBtn.pressed.connect(onBtnEnemyDetailInfoForm)
	#更新文本长度
	Utility.changeTextForLocalization(localization_texts_1,24)
	Utility.changeTextForLocalization(localization_texts_2,24)
	Utility.changeTextForLocalization(localization_texts_3,24)
	Utility.changeTextForLocalization(localization_texts_4,30)
	
func onReadyFinished():
	#头像定位
	enemyimg.position = enemystatechildpanel[0].size / 2 - enemyimg.texture.get_size() / 8
	#基础定位
	enemystateform.position += enemyevent.position
	#buff栏宽度定位
	enemystatechildpanel[2].size.x = enemystatechildpanel[1].size.x
	
	enemystateform.position.y += Defination.tilesize
	#根据怪物全局坐标参数决定实际详情框偏移程度（考虑到手机端的环境下，不再保持1600，改为960）
	var game_screen_x = Utility.getGameBaseVieportWidthHeight().x
	var game_screen_y = Utility.getGameBaseVieportWidthHeight().y
	var xover = enemystatechildpanel[1].global_position.x + enemystatechildpanel[1].size.x - MotaSystem.mapManager.get_viewport().get_camera_2d().get_screen_center_position().x - game_screen_x / 2
	if(xover > 0):
		enemystateform.position.x -= xover
	var ycomponent
	if enemystatechildpanel[2].visible:
		ycomponent = enemystatechildpanel[2]
	else:
		ycomponent = enemystatechildpanel[1]
	var yover = ycomponent.global_position.y + ycomponent.size.y - MotaSystem.mapManager.get_viewport().get_camera_2d().get_screen_center_position().y - game_screen_y / 2
	if(yover > 0):
		enemystateform.position.y -= yover
	#彻底调完位置后，透明度恢复
	enemystateform.modulate=Color(1,1,1,1)
	
func initialize(param):
	enemyevent = param
	enemy_texture = enemyevent.current_page.texture
	#怪物对象详细数据
	fighter = enemyevent.current_page.fighter
	#避免闪现的情况，先把透明度归零
	enemystateform.modulate = Color(1,1,1,0)
	#怪物选择显示
	var enemyrange_child = enemyrangePerfab.instantiate()
	enemyrange_child.position = Vector2(enemyevent.tilePosition.x * Defination.tilesize,enemyevent.tilePosition.y * Defination.tilesize)
	enemyrangeboard.add_child(enemyrange_child)
	#检索并创建敌人光环/支援类技能显示
	check_enemy_skill_has_area_range(fighter.enemy_id)
	#处理怪物面板数据
	enemyName.text = tr(fighter.name)
	enemyLevel.text = "[color=" +DatatableManager.Level.data[DatatableManager.Enemy.data[fighter.enemy_id]["enemyDisplayedLevel"]].color + "]"+ tr(DatatableManager.Level.data[DatatableManager.Enemy.data[fighter.enemy_id]["enemyDisplayedLevel"]].name) + "[/color]"
	enemyHp.text = Utility.fuck(fighter.maxhp)
	enemyAtk.text = Utility.fuck(fighter.atk)
	enemyDef.text = Utility.fuck(fighter.def)
	enemyCritical.text = enemyevent.current_page.battle.get_critical_text()
	# 根据返回的临界值数字类型判定临界点是直接引用还是fuck缩位
	if enemyevent.current_page.battle.get_critical_text().is_valid_int():
		enemyCritical.text = Utility.fuck(int(enemyevent.current_page.battle.get_critical_text()))
	else:
		enemyCritical.text = enemyevent.current_page.battle.get_critical_text()
	enemyTurn.text = enemyevent.current_page.battle.get_turn_text()
	#判断伤害是否是纯数字，是则是正常伤害
	if enemyevent.current_page.battle.get_text().is_valid_float() == true:
		enemyDamage.text = Utility.fuck(int(enemyevent.current_page.battle.get_text()))
	else:
		enemyDamage.text = enemyevent.current_page.battle.get_text()
		#无法侦测技能处理
	if fighter.skill.keys().has("19"):
		enemyHp.text = "？？？"
		enemyAtk.text = "？？？"
		enemyDef.text = "？？？"
		enemyCritical.text = "？？？"
		enemyTurn.text = "？？？"
		enemyDamage.text = "？？？"
	#怪物头像
	enemyimg.texture = enemy_texture
	firstindex = enemyevent.current_page.frame
	#状态栏对象
	var temp_text_state:String#临时状态文本
	if enemyevent.current_page.area_name.size() > 0:
		for i in enemyevent.current_page.area_name.size():
			var temp_statekey = enemyevent.current_page.area_name.keys()[i]
			if(temp_text_state == ""):
				temp_text_state = tr("当前状态:") + tr(temp_statekey) + "*" + str(enemyevent.current_page.area_name[temp_statekey]) + "\t"
			else:
				temp_text_state += tr(temp_statekey) + "*" + str(enemyevent.current_page.area_name[temp_statekey]) + "\t"
		buff_state.text = temp_text_state
	else:
		enemystatechildpanel[2].visible = false
	updatePagePanelPosition(enemystateform)
	updatePagePanelPosition(enemyrangeboard)
	updatePagePanelPosition(closebutton)

func _process(delta):
	if enemyevent.current_page.idleAnim == true:
		time+=delta
		var index = floori(time/0.3)
		while index >= 4:
			index -= 4
			time -= (4 * 0.3)
		enemyimg.frame = firstindex / 4 * 4 + index
	
# 检索是否具有光环/支援类技能，有则创建范围显示
func check_enemy_skill_has_area_range(enemy_id:int):
	#判定是否有光环/支援类技能，有则创建范围，无则跳过
	for i in DatatableManager.Enemy.data[enemy_id]["enemySkill"]:
		if [2,4].has(DatatableManager.Skill.data[int(i)]["skillType"]):
			match i:
				"21","22","23":
					print(Utility.skillValue(enemy_id))
					area_range(enemyevent.tilePosition.x,enemyevent.tilePosition.y,Utility.skillValue(enemy_id)[i][0],Utility.skillValue(enemy_id)[i][0])
	
# 光环/支援类技能范围生成
func area_range(x:int,y:int,ix:int,iy:int = -1):  # iy是光环高度，等于-1时是根据距离来算
	if iy == -1:
		for i in range(x - ix,x + ix + 1):
			for j in range(y - ix,y + ix + 1):
				if abs(x - i) + abs(y - j) <= abs(ix):
					if Vector2(x,y) != Vector2(i,j):
						var enemyskillrange_child = enemyrangePerfab.instantiate()
						enemyskillrange_child.position = Vector2(i * Defination.tilesize,j * Defination.tilesize)
						enemyrangeboard.add_child(enemyskillrange_child)
	else:
		for i in range(x - ix,x + ix + 1):
			for j in range(y - iy,y + iy + 1):
				if Vector2(x,y) != Vector2(i,j):
					var enemyskillrange_child = enemyrangePerfab.instantiate()
					enemyskillrange_child.position = Vector2(i * Defination.tilesize,j * Defination.tilesize)
					enemyrangeboard.add_child(enemyskillrange_child)
	
func onBtnEnemyDetailInfoForm():
	# 怪物事件、怪物详细数据、怪物图像、怪物当前帧、怪物右键详情界面
	var temp_enemy_param:Array = [enemyevent,enemyevent.current_page.fighter,enemy_texture,firstindex,self]
	await openSubForm_2(Defination.UIID.EnemyDetailInfoForm, temp_enemy_param)
	
func onBtnCloseClick():
	close()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		onBtnCloseClick()
