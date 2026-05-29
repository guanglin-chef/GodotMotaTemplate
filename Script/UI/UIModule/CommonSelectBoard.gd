class_name CommonSelectBoard extends BoxContainer

# 用于选项框，直接管辖一批选项按钮
# 选项按钮必须全部打上CommonSelectButton.gd才能使用

# 支持多级UI情况下的操作锁定

# 开局是否是第一级，不是的话就开局直接block
@export var start_blocked:bool = false

# 是否处于锁定状态
var m_blocked:bool = false
var blocked:bool:
	get:
		return m_blocked
	set(value):
		if value == true:
			for btn in get_children():
				btn.focus_mode = Control.FOCUS_NONE
				btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if value == false:
			for btn in get_children():
				btn.focus_mode = Control.FOCUS_ALL
				btn.mouse_filter = Control.MOUSE_FILTER_STOP
		m_blocked = value

func _ready():
	m_blocked = start_blocked
	for btn in get_children():
		# 全自动给每一个按钮加入
		btn.board = self
