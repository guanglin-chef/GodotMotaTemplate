class_name GameEvent extends GameCharacter
## MT插件支持
func meta_addon_mt_pages():pass

## 初始页在节点分支中的顺序
@export var initialPageIndex = 0

# 结束标识
var isDead:bool
# 运行标识
var AsyncRunningFlag:bool
# 是否为临时事件
var TempEvent:bool = false
var TempEventID

var base_dir
# 初始页
var initial_page:EventPage

var old_position:Vector2i = Vector2i.ZERO
var move:Vector2i = Vector2i.ZERO

var debuff:Dictionary = {}

var start = false
var moveendstart = false
var base_data:Dictionary = {}
var linkevent

# -----状态机-----

# 当前页
var m_current_page : EventPage
var current_page : EventPage:
	get:
		return m_current_page
	set(value):
		if m_current_page != null:
			m_current_page.exit()
		if value != null:
			value.enter()
		m_current_page = value
		MotaSystem.CurrentMap.EventGrid = {}
		MotaSystem.CurrentMap.show_damage_point()
# 下一页
var next_page:
	get:
		var index = pages.find(m_current_page)
		if index + 1 < pages.size():
			return pages[index+1]
		else:
			return null

var currentPageIndex:
	get:
		if m_current_page != null:
			return m_current_page.get_index()
		else:
			return initialPageIndex

var pages: Array[EventPage]


var next_effect : Array[Callable] = []

# 自动拾取用变量
var auto_pick:bool = false

# --------------------
# 能否通行
var eventPassable:bool:
	get:
		if m_current_page:
			return m_current_page.eventPassable
		else:
			return true

# ----------生命周期-----------
func _enter_tree() -> void:
	pass
	
func _exit_tree():
	var father = get_parent()
	if father is GameMap:
		father.EventGrid = {}
	#if MotaSystem.CurrentMap:
	#	MotaSystem.CurrentMap.EventGrid = {}

func _ready():
	# 初始化character基本信息
	initCharacter()
	start = true
	old_position = tilePosition
	setPosition(tilePosition - move)
	# 初始化全部事件页
	for child in get_children():
		if child is EventPage:
			pages.append(child)
			if debuff.has(str(pages.size() - 1)): 
				child.debuff = debuff[str(pages.size() - 1)]
			# 初始化
			child.init(self)
			# 先全部不可见
			child.exit()
	# 设置初始页
	if isDead:
		m_current_page = null
	else:
		initial_page = get_child(initialPageIndex)
		if m_current_page == null:
			if initial_page:
				m_current_page = initial_page
	

func _process(delta):
	if !next_effect.is_empty():
		next_effect.pop_front().call()
	if moveendstart && !moving:
		startEvent()
	else:
		super(delta)

func onEnter():
	# 每次进入地图都会触发
	if m_current_page:
		m_current_page.enter()

# 根据存档内容重新初始化event
func initEvent(data:Dictionary):
	base_data = data
	var temp_dir
	for key in data.keys():
		match key:
			"x":
				move.x = data[key]
			"y":
				move.y = data[key]
			"dir":
				temp_dir = data[key]
			"page":
				m_current_page = get_child(data[key])
			"die":
				if data[key] == true:
					dead()
			"db":
				debuff = data[key]
	if m_current_page == null:
		base_dir = floori(get_child(initialPageIndex).frame / 4)
	else:
		base_dir = floori(m_current_page.frame / 4)
	if temp_dir != null:
		dir = temp_dir

func startEvent():
	if isDead || current_page is EmptyEvent:
		return
	if current_page:
		if MotaSystem.Player.allPass:
			var index = pages.find(current_page)
			while index < pages.size():
				if (pages[index] is TeleportEvent || pages[index] is TeleportTowerEvent) && pages[index].texture == current_page.texture && pages[index].frame == current_page.frame:
					pages[index].touch()
					return
				index += 1
		else:
			current_page.touch()

func dead():
	# 事件死亡标识
	isDead = true
	var light = get_node_or_null("PointLight2D")
	if light != null:
		light.visible = false
	# 不删除节点但使其所有事件页都结束
	if m_current_page != null:
		m_current_page.exit()
		m_current_page = null
		MotaSystem.CurrentMap.EventGrid = {}

# ---------------存读档所需---------------

var eventData:
	get:
		if !start:
			return base_data
		var data = {}
		if !TempEvent:
			if (old_position - tilePosition).x != 0:
				data["x"] = (old_position - tilePosition).x
			if (old_position - tilePosition).y != 0:
				data["y"] = (old_position - tilePosition).y
			# 是否结束
			if isDead:
				data["die"] = true
			if base_dir != dir:
				data["dir"] = dir
		# 页码
		if currentPageIndex != initialPageIndex:
			data["page"] = currentPageIndex
		# debuff和地图伤害
		if pages.size() > 0:
			for page in range(pages.size()):
				if pages[page].debuff.size() > 0:
					if !data.has("db"):
						data["db"] = {}
					data["db"][str(page)] = pages[page].debuff
		else:
			if debuff.size() > 0:
				data["db"] = debuff
		return data
