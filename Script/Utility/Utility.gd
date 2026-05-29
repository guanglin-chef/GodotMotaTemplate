# 工具类
class_name Utility

static var script_cache : Array = []
static var skill_value_cache : Dictionary
static var viewport_size_cache: Vector2i = Vector2i.ZERO

#世界坐标转地图坐标
static func worldPos2TilePos(worldPos:Vector2) -> Vector2i:
	var ds = 0.001
	var pos = Vector2(floori((worldPos.x+ds) / Defination.tilesize), floori((worldPos.y+ds) / Defination.tilesize))
	return pos

static func cache() -> Array:
	return script_cache
#地图坐标转世界坐标
static func tilePos2WorldPos(tilePos:Vector2i) -> Vector2:
	return tilePos * Defination.tilesize

# 解析坐标字符串
static func parseString2Vector2i(s:String) -> Vector2i:
	var data = s.replace("(","").replace(")","").split(",")
	return Vector2i(int(data[0]),int(data[1]))
	
# 获取游戏基础视口宽高（带缓存）
static func getGameBaseVieportWidthHeight() -> Vector2i:
	if viewport_size_cache == Vector2i.ZERO:
		var gameBaseWidth = ProjectSettings.get_setting("display/window/size/viewport_width")
		var gameBaseHeight = ProjectSettings.get_setting("display/window/size/viewport_height")
		viewport_size_cache = Vector2i(gameBaseWidth, gameBaseHeight)
	return viewport_size_cache

# 判断是否为 PC 端
static func isPcMode() -> bool:
	var size = getGameBaseVieportWidthHeight()
	return size.x > size.y

# 
static func parseDirection(s:String):
	var result = 0
	match s:
		"Up":
			result = Defination.direction.up
		"Down":
			result = Defination.direction.down
		"Left":
			result = Defination.direction.left
		"Right":
			result = Defination.direction.right
	return result

static func calMovingArr(position:Vector2i,movingArr:Array):
	for i in movingArr:
		if i == 2:#下
			position.y += 1
		if i == 4:#左
			position.x -= 1
		if i == 6:#右
			position.x += 1
		if i == 8:#上
			position.y -= 1
	return position

static func calJump(tilePosition:Vector2i,dir:int,x_plus:int,y_plus:int):
	# 增加值不是 (0,0) 的情况下
	if x_plus != 0 or y_plus != 0:
		# 横侧距离长的情况下
		if abs(x_plus) > abs(y_plus):
			# 变更左右方向
			if x_plus < 0:
				dir = Defination.direction.left
			else:
				dir = Defination.direction.right
		# 竖侧距离长的情况下
		else:
			# 变更上下方向
			if y_plus < 0:
				dir = Defination.direction.up
			else:
				dir = Defination.direction.down
	# 计算新的坐标
	var newPos = Vector2i(tilePosition.x + x_plus,tilePosition.y + y_plus)
	return [newPos,dir]

# 在表中选择符合条件的数据行
# where格式：
# func (datarow): -> bool
static func select(from:Dictionary,where:Callable):
	var result = []
	for id in from:
		var datarow = from[id]
		if where.call(datarow):
			result.append(datarow)
	return result

#------------------text词条解析---------------------

static func Reg(param):
	#对话文本字典
	var talk_dictionary:Dictionary={
		"name":"", #对话角色名字
		"eventName":"", #对话事件名称
		"battlersPicture":"", #小图像行走图
		"face":"", #显示头像（路径）
		"waitTime":"", #等待时长
		"textPos":"", #对话框上中下坐标
		"positionType":"", #立绘左右方向
		"font_size":"", #文本字体大小
		"outline_size":"", #文字描边粗细
		"outline_color":"" #文字描边颜色
		}
	
	#正则拆解文本
	var r_text=param
	for kname in talk_dictionary:
		var pa=r"(\[{0}\](.*?)\[\/{0}\]\n?)"
		# prints(kname,pa.format([kname]))
		var pattern = RegEx.create_from_string(pa.format([kname]))
		var result = pattern.search(r_text)
		if result != null:
			talk_dictionary[kname]=result.get_string(2)
			r_text=r_text.replace(result.get_string(1),"")
	
	talk_dictionary["text"] = r_text
	
	return talk_dictionary

#------------------数位--------------------

# 英文数位函数，小数点前最少2位
static func fuckB(i):
	# 类型检测
	if typeof(i) == Variant.Type.TYPE_STRING:
		return i
	if typeof(i) == Variant.Type.TYPE_FLOAT && i >= 10000:
		i = floori(i)
	# 缩位补偿，默认每一个缩位少4个0，因此英文需要补一个0
	i = int(i * (10**MotaSystem.gameVariables["suowei"]))
	
	if(i==0):
		return "0"
	else:
		var l
		l=var_to_str(abs(i)).length()
		if (l%3==2 && l>3):
			l=max((l-2)/3,0)
			return str(i*10/(10**(l*3))/10.0,Defination.ENshuwei2[l+MotaSystem.gameVariables["suowei"]])
		else:
			l=max((l-2)/3,0)
			return str(i/(10**(l*3)),Defination.ENshuwei2[l+MotaSystem.gameVariables["suowei"]])

# 数位函数，小数点前最少3位
static func fuckA(i):
	# 类型检测
	if typeof(i) == Variant.Type.TYPE_STRING:
		return i
	if typeof(i) == Variant.Type.TYPE_FLOAT && i >= 10000:
		i = floori(i)
	# 0
	if(i==0):
		return "0"
	else:
		var l
		# 用整数部分计算位数，避免浮点精度导致字符串过长引发错误的量级缩位
		l=var_to_str(int(abs(i))).length()
		if (l%4==3 && l>4):
			l=max((l-3)/4,0)
			return str(i*10/(10**(l*4))/10.0,Defination.shuwei2[l+MotaSystem.gameVariables["suowei"]])
		else:
			l=max((l-3)/4,0)
			return str(i/(10**(l*4)),Defination.shuwei2[l+MotaSystem.gameVariables["suowei"]])

# 数位函数，小数点前最少2位
static func fuckA2(i):
	# 类型检测
	if typeof(i) == Variant.Type.TYPE_STRING:
		return i
	if typeof(i) == Variant.Type.TYPE_FLOAT && i >= 10000:
		i = floori(i)
	# 0
	if(i==0):
		return "0"
	else:
		var l
		# 用整数部分计算位数，避免浮点精度导致字符串过长引发错误的量级缩位
		l=var_to_str(int(abs(i))).length()
		if (l%4==2 && l>4):
			l=max((l-2)/4,0)
			return str(i*10/(10**(l*4))/10.0,Defination.shuwei2[l+MotaSystem.gameVariables["suowei"]])
		else:
			l=max((l-2)/4,0)
			return str(i/(10**(l*4)),Defination.shuwei2[l+MotaSystem.gameVariables["suowei"]])

static var A = ["zh"]
static var B = ["en","ja"]

static func fuck(i):
	if A.has(TranslationServer.get_locale()):
		return fuckA(i)
	else:
		return fuckB(i)
		
static func fuck2(i):
	if A.has(TranslationServer.get_locale()):
		return fuckA2(i)
	else:
		return fuckB(i)

static func fuckCustom(i:float, b:int = 4, t:int = 2):
	if(i==0):
		return "0"
	else:
		var l = var_to_str(abs(i)).length()
		var len2 = max((l-b)/4,0)
		if (l % 4 <= t && l > 4):
			return str(snappedf(i/(10**(len2*4)),0.1),Defination.shuwei2[len2])
		else:
			return str(snappedf(i/(10**(len2*4)),1),Defination.shuwei2[len2])

#--------------------------------------

static func skillValue(id:int):
	if !skill_value_cache.has(id):
		skill_value_cache[id] = {}
		var skill = DatatableManager.Enemy.data[id].enemySkill
		for s in skill:
			skill_value_cache[id][s] = skill[s].split_floats('/')
	return skill_value_cache[id]
			
#-------------------------召唤类更替----------------------------

# 召唤类技能召唤物名字更替
static func replaceSummonSkillEnemyName(skill_id,monster_skill_values,value):
	var check_skill_id:int = int(skill_id)
	var check_monster_skill_values:Array = monster_skill_values
	var check_value:String = str(value)
	var result:String = ""
	match check_skill_id:
		18:
			if check_monster_skill_values.find(check_value) == 0:
				result = DatatableManager.Enemy.data[int(check_value)]["enemyName"]
	return result

#-------------------------字符串eval----------------------------

static func eval_code(code:String, this: Object):
	var script = GDScript.new()
	script.source_code += "extends Node\n"
	script.source_code += "func _eval(thisobj):\n\tpass"
	for line in code.split("\n"):
		script.source_code += "\n\t" + line
	script.reload()
	var nscript = script.new()
	script.unreference()
	script_cache.append(nscript)
	return await nscript._eval(this)

static func string_to_script(script_code):
	var script = GDScript.new()
	script.source_code += "extends Node\n"
	script.source_code += script_code
	script.reload()
	var nscript = script.new()
	script.unreference()
	script_cache.append(nscript)
	return nscript

static func string_to_callable(code):
	var script = GDScript.new()
	script.source_code += "extends Node\n"
	script.source_code += "func _eval():\n\tpass"
	for line in code.split("\n"):
		script.source_code += "\n\t" + line
	script.reload()
	var nscript = script.new()
	script.unreference()
	script_cache.append(nscript)
	return nscript._eval

static func string_to_expression(code):
	var script = GDScript.new()
	script.source_code += "extends Node\n"
	script.source_code += "func _eval():\n\tpass"
	script.source_code += "\n\treturn " + code
	script.reload()
	var nscript = script.new()
	script.unreference()
	script_cache.append(nscript)
	return nscript._eval
	

#----------------------------------------
	
# 处理音频总线
static func setBusVolume(idx:int, value):
	if value == 0:
		AudioServer.set_bus_mute(idx,true)
	else:
		AudioServer.set_bus_mute(idx,false)
		AudioServer.set_bus_volume_db(idx,(value-100)*0.6)
		
#-----------------------本地化文本大小调节---------------------------------------

# 调整文本字体大小以适配多语言切换
# 原字体尽量是同大小的，比如size都是35之类的
# 原字体不同size的可以分批次放入函数中做处理
static func changeTextForLocalization(change_texts: Array, max_size: int) -> void:
	var max_ratio = 0.0
	
	# 第一遍：找最大比例
	for node in change_texts:
		var ratio = _getTextRatio(node, max_size)
		max_ratio = max(max_ratio, ratio)
	
	# 第二遍：应用最优字体大小
	if max_ratio > 0:
		var optimal_size = int(max_size / max_ratio)
		for node in change_texts:
			_setFontSize(node, optimal_size)

# 计算文本在给定字体大小下的宽高比例
static func _getTextRatio(node: Node, max_size: int) -> float:
	var temp = node.duplicate()
	_setFontSize(temp, max_size)
	temp.visible = false
	node.add_child(temp)
	
	var ratio = 0.0
	var max_x = node.custom_minimum_size.x
	var max_y = node.custom_minimum_size.y
	
	if max_x > 0:
		ratio = maxf(ratio, temp.size.x / max_x)
	if max_y > 0:
		ratio = maxf(ratio, temp.size.y / max_y)
	
	temp.free()
	return ratio

# 统一设置文本节点的字体大小
static func _setFontSize(node: Node, size: int) -> void:
	if node is Label:
		node.label_settings.font_size = size
	elif node is RichTextLabel:
		node.add_theme_font_size_override("normal_font_size", size)
		node.add_theme_font_size_override("bold_font_size", size)
		node.add_theme_font_size_override("bold_italics_font_size", size)
		node.add_theme_font_size_override("italics_font_size", size)
		node.add_theme_font_size_override("mono_font_size", size)
	elif node is Button:
		node.add_theme_font_size_override("font_size", size)
