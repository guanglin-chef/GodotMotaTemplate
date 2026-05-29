class_name EffectManager extends RefCounted
# 特效管理器，包括各种动画和粒子特效（如果有的话）等效果

var EffectLayers = Dictionary()

var enemy_break : Array = []

var EffectRoot:Node

func _init(root:Node) -> void:
	EffectRoot = root
	# 初始化特效层级
	# 目前所有UI的zindex都为100
	if Utility.isPcMode():
		init_EffectLayer(Defination.UILayer.Game,50,Vector2(320,0))
	else:
		init_EffectLayer(Defination.UILayer.Game,50,Vector2(0,320))
	init_EffectLayer(Defination.UILayer.Main,150)
	

func init_EffectLayer(layerName:String,zindex:int,position:Vector2 = Vector2(0,0)):
	EffectLayers[layerName] = Node2D.new()
	EffectLayers[layerName].name = layerName
	EffectLayers[layerName].z_index = zindex
	EffectLayers[layerName].position = position
	EffectRoot.add_child(EffectLayers[layerName])

# 显示特效，需要给出所在的特效层（目前和UI层一样）和位置
func showEffect(path:String, position:Vector2, layerName:String, param = null):
	var res = MotaSystem.resourceManager.loadFile(path)
	var effect:EffectBase = res.instantiate()
	EffectLayers[layerName].add_child(effect)
	effect.initialize(param)
	effect.position = position
	effect.play()
	await effect.effect_end
	effect.queue_free()

func play(effect):
	effect.play()
	await effect.effect_end
	effect.queue_free()

# 显示挂载到某个节点上的特效，会跟随移动并和主节点层级一致
func showEffectOnNode(path:String, node:Node, offset:Vector2, zindex = 0, param = null):
	var res = MotaSystem.resourceManager.loadFile(path)
	var effect:EffectBase = res.instantiate()
	node.add_child(effect)
	effect.initialize(param)
	effect.position = offset
	# 部分动画需要根据玩家朝向变动方向
	changeEffectRotation(effect,param)
	node.move_child(effect,node.get_child_count())
	effect.z_index = zindex
	effect.play()
	await effect.effect_end
	effect.queue_free()
	
# 有距离相关的情况下，使用的节点上特效，会跟随移动并和主节点层级一致
func showEffectDistanceOnNode(path:String, node:Node, offset:Vector2, zindex = 0 ,param = null):
	var res = MotaSystem.resourceManager.loadFile(path)
	var effect:EffectBase = res.instantiate()
	node.add_child(effect)
	effect.initialize(param)
	effect.position = offset
	node.move_child(effect,node.get_child_count())
	effect.z_index = zindex
	effect.play_locus()
	await effect.effect_end
	effect.position = Vector2.ZERO
	effect.queue_free()

# 清除某层级所有effect
func clearEffect(layerName:String):
	for effect in EffectLayers[layerName].get_children():
		effect.queue_free()
		
# 调整动画方位
func changeEffectRotation(effect:EffectBase,param = null):
	# 有需要根据方位调整动画旋转的再添加在这里
	pass
