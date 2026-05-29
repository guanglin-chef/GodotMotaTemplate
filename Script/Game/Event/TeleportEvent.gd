class_name TeleportEvent extends EventPage

## 目标地图
@export var targetMapId:int
## 目标位置
@export var targetPosition:Vector2i
## 方向
@export_enum("DOWN","LEFT","RIGHT","UP","HOLD") var targetDirection

func start():
	# 主要逻辑
	MotaSystem.mapManager.changingMap = true
	AudioManager.playSE("Junkomory Transition 08-1.ogg")
	MotaSystem.Player.setIdle(MotaSystem.gameManager.transferPlayer.bind(targetMapId,targetPosition,targetDirection))
	MotaSystem.Player.MovingStack.clear()
	# 完成后处理
	super()
