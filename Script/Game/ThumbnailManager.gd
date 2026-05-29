class_name ThumbnailManager extends Node

var current_map

func init_thumbnail(save):
	# 先清除原先的
	if current_map != null:
		current_map.queue_free()
		remove_child(current_map)
		current_map = null
		# 背景也记得清除
		if $BackgroundCanvasLayer/BackgroundNode.get_child_count() > 0:
			$BackgroundCanvasLayer/BackgroundNode.get_child(0).free()
	for character in $PlayerNode.get_children():
		$PlayerNode.remove_child(character)
		character.queue_free()
	if save != null:
		var key = int(save.playerData.Player.mapKey)
		var map = init_map(key,save)
		
		# 添加非跟随式背景预制
		if DatatableManager.Map.data[key]["backgroundPrefabPath"] != "":
			var bg = MotaSystem.resourceManager.loadFile(DatatableManager.Map.data[key]["backgroundPrefabPath"]).instantiate()
			$BackgroundCanvasLayer/BackgroundNode.add_child(bg)
	
		# 加入场景树
		self.add_child(map)
		current_map = map
		# 完成一些必须完成的onEnter周期内工作
		onEnterThumbnail(map)
		# 加入主角
		InitThumbnailPlayer(save)
		InitThumbnailFollow(save)

func onEnterThumbnail(map):
	# changeTile
	if map.data.has("changetile"):
		var tag = {}
		for change in map.data["changetile"]:
			for k in change:
				map.change_tile(k,Utility.parseString2Vector2i(change[k]),tag)
	# 事件
	for event:GameEvent in map.events.get_children():
		if event.current_page:
			event.current_page.visible = true
			# 然后把所有事件都变成空壳，防止报错
			event.current_page.set_script(null)
			event.set_script(null)
		

func load_map(key:int):
	if !MotaSystem.resourceManager.mapRes.has(key):
		MotaSystem.resourceManager.loadMap(key)
	var map = MotaSystem.resourceManager.mapRes[key].instantiate()
	map.key = key
	return map

func init_map(key:int,save):
	var map = load_map(key)
	#  Init Mapdata
	var keyT = str(key)
	if !save.is_empty():
		if save.mapData.has(keyT):
			map.initMap(save.mapData[keyT])
	return map

func InitThumbnailPlayer(save):
	# 读取资源
	var playerRes = MotaSystem.resourceManager.loadFile("res://Scene/Prefab/ThumbnailPlayer.tscn")
	var player = playerRes.instantiate()
	player.set_script(null)
	
	$PlayerNode.add_child(player)
	# 初始化角色信息
	if save != null:
		var dr = DatatableManager.Player.data[int(save.playerData.Player.playerID)]
		var spriteRes = MotaSystem.resourceManager.loadFile("res://Resources/Character/" + dr["sprite"] + ".png")
		player.get_node("Sprite2D").texture = spriteRes
		player.get_node("Sprite2D").offset = Vector2((Defination.tilesize - 1.0*spriteRes.get_width() / 4) / 2,(Defination.tilesize - 1.0*spriteRes.get_height() / 4))
		player.position = Utility.tilePos2WorldPos(Utility.parseString2Vector2i(save.playerData.Player.position))

		if save.playerData.Player.has("player_texture"):
			player.get_node("Sprite2D").texture = load(save.playerData.Player.player_texture)
		if save.playerData.Player.has("player_frame"):
			player.get_node("Sprite2D").frame = save.playerData.Player.player_frame
		if save.playerData.Player.has("self_modulate"):
			player.get_node("Sprite2D").self_modulate = Color(save.playerData.Player.self_modulate)
	# 跟随式摄像机相关配置
	var camera = player.get_node("Camera2D")
	camera.make_current()
	camera.limit_right =  (current_map.width - 10) * Defination.tilesize - 1
	camera.limit_bottom = current_map.height * Defination.tilesize - 1

func InitThumbnailFollow(save):
	for key:String in save.playerData:
		if key == "Player":
			continue
		var id = int(save.playerData[key].playerID)
		var index = int(key.trim_prefix("Follower"))
		var characterRes = MotaSystem.resourceManager.loadFile("res://Scene/Prefab/Character.tscn")
		var character:GameCharacter = characterRes.instantiate()
		var pos:Vector2i = Utility.parseString2Vector2i(save.playerData[key].position)
		$PlayerNode.add_child(character)
		var dr = DatatableManager.Player.data[id]
		var spriteRes = ResourceLoader.load("res://Resources/Character/" + dr["sprite"] + ".png")
		character.playerID = id
		character.name = "Follower{0}".format([index])
		character.sprite.texture = spriteRes
		character.sprite.offset = Vector2((Defination.tilesize - 1.0*spriteRes.get_width() / 4) / 2,(Defination.tilesize - 1.0*spriteRes.get_height() / 4))
		character.position = Utility.tilePos2WorldPos(pos)
		character.tilePosition = pos
		character.dir = save.playerData[key].direction
