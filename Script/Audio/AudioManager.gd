class_name AudioManager extends Node

static var instance: AudioManager = null

static func get_instance() -> AudioManager:
	if instance == null:
		instance = AudioManager.new()
	return instance

static var BGMAudioNode:AudioStreamPlayer

static func p_ready() -> void:
	# BGM
	BGMAudioNode = AudioStreamPlayer.new()
	BGMAudioNode.bus = "BGM"
	get_instance().add_child(BGMAudioNode)

static var loopOffsetFix = 0.051

static func playBGM(bgmName:String,loopOffset:float = 0):
	loopOffset += loopOffsetFix
	#实例化BGM本体对象
	var res = MotaSystem.resourceManager.loadFile("res://Resources/Audio/BGM/{0}".format([bgmName]))
	#如果有正在fade的bgm直接kill
	if stopBGMtween!=null:
		stopBGMtween.kill()
	BGMAudioNode.volume_db = 0
	if !BGMAudioNode.playing:
		BGMAudioNode.name=bgmName
		BGMAudioNode.stream = res
		BGMAudioNode.stream.loop = true
		BGMAudioNode.stream.loop_offset = loopOffset
		BGMAudioNode.play()
		#print("当前BGM：",BGMAudioNode.bgmName)
	elif(BGMAudioNode.stream!=res):
		#如果BGM正在播放但名字不同则替换BGM
		BGMAudioNode.name=bgmName
		BGMAudioNode.stream = res
		BGMAudioNode.stream.loop = true
		BGMAudioNode.stream.loop_offset = loopOffset
		BGMAudioNode.play()
		#print("当前BGM：",BGMAudioNode.bgmName)


static var stopBGMtween:Tween

static func stopBGM(fade:float = 0):
	if fade == 0:
		BGMAudioNode.stop()
		BGMAudioNode.stream = null
	else:
		stopBGMtween = get_instance().create_tween()
		stopBGMtween.tween_property(BGMAudioNode,"volume_db",-50,fade)
		stopBGMtween.tween_callback(func(): 
			BGMAudioNode.stop()
			BGMAudioNode.stream = null
			BGMAudioNode.volume_db = 0
		)

static func playBGS(bgsName:String,loopOffset:float = 0):
	var audioNode = AudioStreamPlayer.new()
	audioNode.bus = "SE"
	audioNode.finished.connect(func():
		audioNode.queue_free()
	)
	get_instance().add_child(audioNode)
	if !audioNode.playing:
		var res = MotaSystem.resourceManager.loadFile("res://Resources/Audio/BGS/{0}".format([bgsName]))
		audioNode.stream = res
		audioNode.name=bgsName
		audioNode.stream.loop = true
		audioNode.stream.loop_offset = loopOffset
		audioNode.play()

static func playSE(seName:String, pitch_scale = 1):
	var audioNode = AudioStreamPlayer.new()
	audioNode.bus = "SE"
	audioNode.pitch_scale = pitch_scale
	audioNode.finished.connect(func():
		audioNode.queue_free()
	)
	get_instance().add_child(audioNode)
	if !audioNode.playing:
		var res = MotaSystem.resourceManager.loadFile("res://Resources/Audio/SE/{0}".format([seName]))
		audioNode.stream = res
		audioNode.name=seName
		#audioNode.stream.loop = false
		audioNode.play()
