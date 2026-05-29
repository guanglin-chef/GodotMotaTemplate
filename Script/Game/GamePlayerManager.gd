class_name GamePlayerManager extends Node2D

# 角色
var m_Player:GamePlayer

func Initialize(save):
	InitPlayer(save)
	InitFollower(save)

func InitPlayer(save):
	# 读取资源
	var playerRes = MotaSystem.resourceManager.loadFile("res://Scene/Prefab/Player.tscn")
	var player:GamePlayer = playerRes.instantiate()
	
	add_child(player)
	# 初始化角色信息
	if save != null:
		var dr = DatatableManager.Player.data[int(save.playerData.Player.playerID)]
		var spriteRes = MotaSystem.resourceManager.loadFile("res://Resources/Character/" + dr["sprite"] + ".png")
		player.playerID = save.playerData.Player.playerID
		player.sprite.texture = spriteRes
		player.sprite.offset = Vector2((Defination.tilesize - 1.0*spriteRes.get_width() / 4) / 2,(Defination.tilesize - 1.0*spriteRes.get_height() / 4))
		player.speed = MotaSystem.config.getValue("Playerspeed","speed")
		player.position = Utility.tilePos2WorldPos(Utility.parseString2Vector2i(save.playerData.Player.position))
		player.tilePosition = Utility.parseString2Vector2i(save.playerData.Player.position)
		player.dir = save.playerData.Player.direction
		if save.playerData.Player.has("player_texture"):
			player.sprite.texture = load(save.playerData.Player.player_texture)
		if save.playerData.Player.has("player_frame"):
			player.sprite.frame = save.playerData.Player.player_frame
		if save.playerData.Player.has("self_modulate"):
			player.sprite.self_modulate = Color(save.playerData.Player.self_modulate)
		self.m_Player = player
		MotaSystem.CurrentMap.show_damage_point()
	else:
		var dr = DatatableManager.Player.data[GameFirstData.playerId]
		var spriteRes = MotaSystem.resourceManager.loadFile("res://Resources/Character/" + dr["sprite"] + ".png")
		player.playerID = GameFirstData.playerId
		player.sprite.texture = spriteRes
		player.sprite.offset = Vector2((Defination.tilesize - 1.0*spriteRes.get_width() / 4) / 2,(Defination.tilesize - 1.0*spriteRes.get_height() / 4))
		player.speed = MotaSystem.config.getValue("Playerspeed","speed")
		player.position = Utility.tilePos2WorldPos(GameFirstData.startPosition.pos)
		player.tilePosition = GameFirstData.startPosition.pos
		player.dir = GameFirstData.startPosition.dir
		self.m_Player = player
		MotaSystem.CurrentMap.show_damage_point()
	# getIntoMap
	# 跟随式摄像机相关配置
	var camera = player.get_node("Camera2D")
	camera.make_current()
	camera.limit_right =  MotaSystem.CurrentMap.width * Defination.tilesize - 1
	camera.limit_bottom = MotaSystem.CurrentMap.height * Defination.tilesize - 1
	# 地图记录
	var mapKey = MotaSystem.CurrentMap.key
	var towerId = str(DatatableManager.Map.data[mapKey].towerId)
	if !MotaSystem.gameVariables["floorRecord"].has(towerId):
		MotaSystem.gameVariables["floorRecord"][towerId] = []
	if !MotaSystem.gameVariables["floorRecord"][towerId].has(str(mapKey)):
		MotaSystem.gameVariables["floorRecord"][towerId].append(str(mapKey))

func InitFollower(save):
	if save != null:
		for key:String in save.playerData:
			if key == "Player":
				continue
			var id = save.playerData[key].playerID
			var index = int(key.trim_prefix("Follower"))
			var target
			if index == 1:
				target = m_Player
			elif index > 1:
				target = get_node("Follower{0}".format([index-1]))
			InitFollowCharacter(id,target,index,Utility.parseString2Vector2i(save.playerData[key].position),save.playerData[key].direction,save.playerData[key].followMove)
	else:
		# 从GameFirstData里读一下
		for i in GameFirstData.startFollower:
			addFollower(i)

func InitFollowCharacter(playerID:int, followTarget:GameCharacter, followerIndex:int, pos = m_Player.tilePosition,d = Defination.direction.down,followMove = null):
	# 读取资源
	var characterRes = MotaSystem.resourceManager.loadFile("res://Scene/Prefab/Character.tscn")
	var character:GameCharacter = characterRes.instantiate()
	add_child(character)
	#move_child(character,0)

	# 基本信息
	var dr = DatatableManager.Player.data[playerID]
	var spriteRes = ResourceLoader.load("res://Resources/Character/" + dr["sprite"] + ".png")
	character.playerID = playerID
	character.name = "Follower{0}".format([followerIndex])
	character.sprite.texture = spriteRes
	character.sprite.offset = Vector2((Defination.tilesize - 1.0*spriteRes.get_width() / 4) / 2,(Defination.tilesize - 1.0*spriteRes.get_height() / 4))
	character.speed = MotaSystem.config.getValue("Playerspeed","speed")
	character.position = Utility.tilePos2WorldPos(pos)
	character.tilePosition = pos
	character.dir = d
	# 设置跟随
	followTarget.follower = character
	character.followMove = followMove
	character.allPass = true

	return character

func addFollower(playerID:int):
	var followTarget = get_children()[-1]
	InitFollowCharacter(playerID,followTarget,get_children().size())

func delFollower(playerID:int):
	for i in range(0,get_children().size()):
		var follower = get_children()[i]
		if follower.name == "Player":
			continue
		if follower.playerID == playerID:
			var followTarget = get_children()[i-1]
			# 清除掉对应id的队友
			follower.queue_free()
			# 需要把后面跟随的队友往前拉
			if i+1 < get_children().size(): # 先判断再之后还有没有人
				followTarget.follower = get_children()[i+1]
				followTarget.followMove = null
			else:
				followTarget.follower = null
				followTarget.followMove = null
			# 重置位置
			m_Player.setPosition(m_Player.tilePosition)
			
func setFollowerJump(playerID:int,xplus:int,yplus:int):
	for i in range(0,get_children().size()):
		var follower = get_children()[i]
		if follower.name == "Player":
			continue
		if follower.playerID == playerID:
			await follower.jump(xplus,yplus)
			
func setFollowerDir(playerID:int,dir:int):
	for i in range(0,get_children().size()):
		var follower = get_children()[i]
		if follower.name == "Player":
			continue
		if follower.playerID == playerID:
			follower.dir=dir
			
func setAllDir(dir:int):
	for i in range(0,get_children().size()):
		var follower = get_children()[i]
		if follower.name == "Player":
			continue
		else:
			follower.dir=dir
			
func setAllmodulate(r,g,b,a):
	for i in range(0,get_children().size()):
		var follower = get_children()[i]
		if follower.name == "Player":
			continue
		else:
			follower.modulate=Color(r,g,b,a)
			
func setAllSprite2Dmodulate(r,g,b,a):
	for i in range(0,get_children().size()):
		var follower = get_children()[i]
		if follower.name == "Player":
			continue
		else:
			follower.get_node("Sprite2D").modulate=Color(r,g,b,a)
			
func getPlayerData():
	var result = {}
	result["Player"] = m_Player.playerData
	for node in get_children():
		if node.name != "Player":
			result[node.name] = node.characterData
	return result
