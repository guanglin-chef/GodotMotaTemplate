class_name EnemyHandBookForm extends UIForm

# 怪物图鉴预制件
@export var BoardMonsterPrefab:PackedScene
# 怪物图鉴框体
@export var EnemyHandBookBoard:PanelContainer
# 怪物图鉴grid
@export var BoardMonsterContainer:GridContainer
# 返回按钮
@export var ReturnBtn:Button
# 怪物图鉴标题
@export var EnemyHandBookTitle:Label

#-----------------------------------------------------------

# 当前层怪物数据
var m_Monsters:Array[EnemyData] = []
var temp_Monsters:Array[GameBattle] = []
# 当前层怪物ID数组
var MonsterIds:Array[int]
# 所选中怪物图鉴
var select_handdbook_btn:Button

#------------------------------------------------------------

func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	#调整上下聚焦
	if BoardMonsterContainer.get_child_count() > 0:
		var top = BoardMonsterContainer.get_children()[0].EnemyBoardBtn
		var bottom = BoardMonsterContainer.get_children()[-1].EnemyBoardBtn
		top.focus_neighbor_top =  bottom.get_path()
		bottom.focus_neighbor_bottom = top.get_path()
	self.openAnim(0.2)
	ReturnBtn.pressed.connect(onBtnReturnClick)
	
func onReadyFinished():
	# 如果有怪物对象，则聚焦，否则聚焦返回按钮
	if BoardMonsterContainer.get_child_count() != 0:
		BoardMonsterContainer.get_child(0).EnemyBoardBtn.grab_focus()
	else:
		ReturnBtn.grab_focus()
	
func initialize(param):
	EnemyHandBookTitle.text = tr("怪物手册")
	m_Monsters = MotaSystem.enemyReady.EnemyList.duplicate()
	m_Monsters.sort_custom(func(a,b): 
		if a.battleObj == null:
			var temp = GameBattle.traverse_damage(a.monsterID)
			temp_Monsters.append(temp[0])
			a.battleObj = temp[0]
			a.cache = temp
		if b.battleObj == null:
			var temp = GameBattle.traverse_damage(b.monsterID)
			temp_Monsters.append(temp[0])
			b.battleObj = temp[0]
			b.cache = temp
		if b.battleObj.damage > a.battleObj.damage && a.battleObj.result == GameBattle.battlResult.win:  # 根据伤害排布
			return true
		if ((b.battleObj.result == GameBattle.battlResult.dead || b.battleObj.result == GameBattle.battlResult.invincible) && b.battleObj.result != a.battleObj.result):
			return true  # 即死与无敌置底
		if DatatableManager.Enemy.data[b.monsterID].enemyLevel > DatatableManager.Enemy.data[a.monsterID].enemyLevel:  # 然后根据等级排布
			return true
		)
	if m_Monsters.size() == 1:
		var temp = GameBattle.traverse_damage(m_Monsters[0].monsterID)
		temp_Monsters.append(temp[0])
		m_Monsters[0].battleObj = temp[0]
		m_Monsters[0].cache = temp
	# 建立BoardMonster
	for handBookData in m_Monsters:
		var enemy_board = BoardMonsterPrefab.instantiate()
		#向数组存入ID
		MonsterIds.append(handBookData.monsterID)
		enemy_board.initMonster(handBookData)
		#获取该按钮对象，并更新名称避免重复
		enemy_board.name="怪物编号" + str(handBookData.monsterID)
		enemy_board.EnemyBoardBtn.pressed.connect(onBtnEnemyInfoClick.bind(enemy_board))
		BoardMonsterContainer.add_child(enemy_board)
	# 调整focus
	updatePagePanelPosition(EnemyHandBookBoard)
		
func _exit_tree():
	dispose_book()

func dispose_book():
	for b in temp_Monsters:
		if b != null:
			#b.dispose()
			#b.free()
			pass
	temp_Monsters = []
	
func onBtnReturnClick():
	close()
	
func onBtnEnemyInfoClick(EnemyPerfab):
	var enemy_prefab = EnemyPerfab
	#根据点击按钮的名称作为怪物id
	var monster_id = enemy_prefab.enemy_id
	#临时拼凑用的怪物ID数组
	#[所选怪物id，当前地图全部种类怪物id组，当前地图全部怪物enemydata，该界面本体]
	var temp_monsteridarray:Array=[monster_id,MonsterIds,m_Monsters,self]
	#所选中怪物图鉴
	select_handdbook_btn = enemy_prefab.EnemyBoardBtn
	await openSubForm_2(Defination.UIID.EnemyInfoForm,temp_monsteridarray)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu") or event.is_action_pressed("call_handbook"):
		close()
