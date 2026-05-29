class_name PreloadForm extends UIForm

@onready
var bar:ProgressBar = $ProgressBar
@onready
var label:Label= $ProgressText

# Called when the node enters the scene tree for the first time.
func _ready():
	#处理不同机型页面齐问题
	updateGameScreen()
	bar.size.x = self.size.x / 960.0 * bar.size.x
	bar.position.x = (self.size.x - bar.size.x) / 2
	#updatePagePanelPosition(bar)
	#updatePagePanelPosition(label)
	
	self.bar.visible = false

# 开始！
func startPreload():
	self.bar.visible = true

# 更新进度条信息
func updateBar(ratio:float):
	self.bar.value = ratio

func updateLabel(t:String):
	label.text = tr(t)
