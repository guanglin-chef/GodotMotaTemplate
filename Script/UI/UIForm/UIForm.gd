class_name UIForm extends Control

var params:Variant

signal closeSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 当抽象函数用
func initialize(param):
	pass
	
#调节页面大小适配PC/移动端分辨率
func updateGameScreen():
	var viewport_size = Utility.getGameBaseVieportWidthHeight()
	self.custom_minimum_size = viewport_size
	self.size = viewport_size
	
#调节页面实际对象的position，PC端+320x，移动端+320y
func updatePagePanelPosition(panel_object:Node):
	if Utility.isPcMode():
		panel_object.position.x += 320
	else:
		panel_object.position.y += 320
	
# 抽象函数
func onReadyFinished():
	pass

func close(isDestroy = true):
	closeSignal.emit()
	MotaSystem.uiManager.removeByNode(self,isDestroy)

func openAnim(duration:float):
	self.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, duration)

func openSubForm(UIID:Defination.UIID, param = null):
	self.set_process(false)
	self.set_process_input(false)
	var form = MotaSystem.uiManager.open(UIID, param)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.15)
	await get_tree().create_timer(0.2).timeout
	self.visible = false
	if form != null:
		await form.closeSignal
	self.set_process_input(true)
	self.set_process(true)
	self.modulate = Color.WHITE
	self.visible = true

#无界面关闭+无等待版
func openSubForm_2(UIID:Defination.UIID, param = null):
	self.set_process(false)
	self.set_process_input(false)
	MotaSystem.uiManager.open(UIID, param)
	await get_tree().create_timer(0.2).timeout
	self.visible = false
	self.set_process_input(true)
	self.set_process(true)
	self.modulate = Color.WHITE
	self.visible = true

#无界面关闭+有等待版
func openSubForm_3(UIID:Defination.UIID, param = null):
	self.set_process(false)
	self.set_process_input(false)
	var form = MotaSystem.uiManager.open(UIID, param)
	await get_tree().create_timer(0.2).timeout
	#self.visible = false
	if form != null:
		await form.closeSignal
	self.set_process_input(true)
	self.set_process(true)
	self.modulate = Color.WHITE
	#self.visible = true
