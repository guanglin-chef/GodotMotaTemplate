##==============================================================================
## ■ AreaManager
##------------------------------------------------------------------------------
## 对光环进行操作的静态方法集
##==============================================================================
class_name AreaManager
##--------------------------------------------------------------------------
## ● 加载覆盖全地图的光环
##--------------------------------------------------------------------------
static func Map_Area(eventlist : Array , buff : Dictionary , namelist : Dictionary = {}):
	var data      # 预定义 光环怪物数据的临时变量
	var val       # 预定义 光环怪物技能的临时变量
	for event in eventlist:
		data = DatatableManager.Enemy.data[event.enemyid]
		##------------------------------------------------------------------
		## :[域场]: 增加{2}%的本层实际地图伤害，多个可以线性叠加
		##------------------------------------------------------------------
		if data.enemySkill.has("27"):
			val = data.enemySkill["27"].split_floats("/")
			AddBuff(buff, "map_plus", val[0], namelist, DatatableManager.Skill.data[27].skillName)
		# 特么我看了半天没有那种无条件全地图buff的技能这里就不写了
##--------------------------------------------------------------------------
## ● 加载覆盖某一怪物事件享受到的光环
##--------------------------------------------------------------------------
static func Event_Area(eventlist : Array , buff : Dictionary , target : MonsterEvent , namelist : Dictionary = {}):
	var data      # 预定义 光环怪物数据的临时变量
	var tar_data  # 预定义 目标怪物数据的临时变量
	var val       # 预定义 光环怪物技能的临时变量
	for event in eventlist:
		data = DatatableManager.Enemy.data[event.enemyid]
		tar_data = DatatableManager.Enemy.data[target.enemyid]
		##------------------------------------------------------------------
		## :[鼓舞]: 使地图上自身种类以外且境界低于自身的所有敌人提升{0}%攻防
		##------------------------------------------------------------------
		if data.enemySkill.has("20"):
			# 排除境界低于自己的敌人，这一步能顺手筛掉自身种类，因为自己的等级不可能高于自己
			if data.enemyLevel > tar_data.enemyLevel:
				AddBuff(buff, "atk%", int(data.enemySkill["20"]), namelist, "鼓舞")
				AddBuff(buff, "def%", int(data.enemySkill["20"]), namelist)
		##------------------------------------------------------------------
		## :[攻击光环]: 该敌人周围{0}格范围内其他敌人攻击上升{1}%
		##------------------------------------------------------------------
		if data.enemySkill.has("21"):
			val = data.enemySkill["21"].split_floats("/")
			# 判断目标是否在光环的范围内
			if event.has_point(target.base.tilePosition , val[0] , val[0]):
				AddBuff(buff, "atk%", val[1], namelist, DatatableManager.Skill.data[21].skillName)
		##------------------------------------------------------------------
		## :[防御光环]: 该敌人周围{0}格范围内其他敌人防御上升{1}%
		##------------------------------------------------------------------
		if data.enemySkill.has("22"):
			val = data.enemySkill["22"].split_floats("/")
			# 判断目标是否在光环的范围内
			if event.has_point(target.base.tilePosition , val[0] , val[0]):
				AddBuff(buff, "def%", val[1], namelist, DatatableManager.Skill.data[22].skillName)
		##------------------------------------------------------------------
		## :[生命光环]: 该敌人周围{0}格范围内其他敌人生命上升{1}%
		##------------------------------------------------------------------
		if data.enemySkill.has("23"):
			val = data.enemySkill["23"].split_floats("/")
			# 判断目标是否在光环的范围内
			if event.has_point(target.base.tilePosition , val[0] , val[0]):
				AddBuff(buff, "hp%", val[1], namelist, DatatableManager.Skill.data[23].skillName)
##--------------------------------------------------------------------------
## ● 状态增减
##--------------------------------------------------------------------------
static func AddBuff(buff : Dictionary, key : String, value, namelist : Dictionary = {} , name : String = "" , number : int = 1):
	# 首先需要增减的参数不等于零
	if value != 0:
		# 寻找该buff参数，没有就赋值
		if buff.has(key) == false:
			buff[key] = 0
		buff[key] += value
	if name != "" && number > 0:
		if !namelist.has(name):
			namelist[name] = 0
		namelist[name] += number
##--------------------------------------------------------------------------
## ● 单纯存放需要翻译的词条字符串，没有任何作用，也没有地方会调用这个
##--------------------------------------------------------------------------
func name_tr():
	tr("鼓舞")
