extends Button

@export var tower_name:RichTextLabel
var form:TeleportForm
var towerId

# 选中特效
var selectedTexture:NinePatchRect
var selectedTextureNodepath = "res://Scene/UI/UIModule/CommonSelectButtonFocusStyle.tscn"

# 闪烁动画
var tween:Tween
var duration = 0.75

func initialize(key,form:TeleportForm):
	self.form = form
	self.towerId = int(key)
	# 名称
	tower_name.text = DatatableManager.Tower.data[int(key)].name

func _ready():
	# 全自动加入特效
	selectedTexture = MotaSystem.m_ResourceManager.loadFile(selectedTextureNodepath).instantiate()
	add_child(selectedTexture)
	selectedTexture.size = self.size
	selectedTexture.visible = false
	# 链接
	pressed.connect(onClicked)

# 并非godot的focus，而是当前所在魔塔的focus
func onFocused():
	selectedTexture.size = self.size
	selectedTexture.visible = true
	selectedTexture.modulate = Color(1,1,1,1)
	tween = create_tween()
	tween.tween_property(selectedTexture, "modulate", Color(1,1,1,0), duration)
	tween.tween_property(selectedTexture, "modulate", Color(1,1,1,1), duration)
	tween.set_loops()

func onFocusExit():
	selectedTexture.visible = false
	if tween != null:
		tween.kill()

func onClicked():
	form.towerIndex = self.get_index()
	form.pageStartIndex = 0
	form.mod = 0
	form.refresh()
