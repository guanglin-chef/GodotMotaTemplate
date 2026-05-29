class_name GameData

#--------------游戏数据----------------

# 角色名
var m_playerName:String
var playerName:String:
	get:
		return m_playerName
	set(value):
		m_playerName = value

# gdscript的int上限大概在900京，只要实际数字到亿后保持缩位应该就问题不大
# 角色等级
var m_level:int
var level:int:
	get:
		return m_level
	set(value):
		m_level = value

# 角色经验
var m_expe:int
var expe:int:
	get:
		return m_expe
	set(value):
		m_expe = value
		
# 角色生命
var m_hp:int
var hp:int:
	get:
		return m_hp
	set(value):
		m_hp = value

func hpcheck() -> bool:
	if hp <= 0:
		hp = 0
		MotaSystem.gameForm.RefreshUI() #刷新
		MotaSystem.gameEventManager.pushSpecialEvent(Defination.SpecialEventType.GameOverEvent)
		return false
	return true

# 攻击力  
var m_atk:int
var base_atk:int:  
	get:  
		return m_atk
	set(value):  
		m_atk = value
# 实际攻击力
var atk:int:
	get:
		#攻击力基础值
		var result = base_atk
		# 各种加成
		var equip_atk:Array = equips_value["equip_ATK"].duplicate()
		var state_atk:Array = states_value["state_ATK"].duplicate()
		#固定数值加成
		result += equip_atk[0]
		result += state_atk[0]
		#百分比数值加成
		result *= equip_atk[1]
		result *= state_atk[1]
		result = max(result,0)
		return result

# 防御力  
var m_def:int
var base_def:int:  
	get:  
		return m_def  
	set(value):  
		m_def = value
# 实际防御力
var def:int:
	get:
		# 防御力基础值
		var result = base_def
		# 各种加成
		var equip_def:Array = equips_value["equip_DEF"].duplicate()
		var state_def:Array = states_value["state_DEF"].duplicate()
		#固定数值加成
		result += equip_def[0]
		result += state_def[0]
		#百分比数值加成
		result *= equip_def[1]
		result *= state_def[1]
		result = max(result,0)
		return result
  
# 护盾值  
var m_mdef:int
var base_mdef:int:
	get:
		return m_mdef
	set(value):
		m_mdef = value
# 实际护盾
var mdef:int:
	get:
		# 魔抗基础值
		var result = base_mdef
		# 各种加成
		var equip_mdef:Array = equips_value["equip_MDEF"].duplicate()
		var state_mdef:Array = states_value["state_MDEF"].duplicate()
		#固定数值加成
		result += equip_mdef[0]
		result += state_mdef[0]
		#百分比数值加成
		result *= equip_mdef[1]
		result *= state_mdef[1]
		result = max(result,0)
		return result
		
# 玩家全增伤
var m_all_damage_rate:float = 1
var all_damage_rate:float:  
	get:  
		var v = m_all_damage_rate
		var equipvalue:float = equips_value["equip_ALLDAMRAT"]
		var statevalue:float = states_value["state_ALLDAMRAT"]
		v *= 1 + (equipvalue / 100)
		v *= 1 + (statevalue / 100)
		return v
		
# 玩家全傷害减少
var m_all_resistance:float = 1
var all_resistance:float:
	get:
		var v:float = m_all_resistance
		var equipvalue:float = equips_value["equip_ALLDAMRES"]
		var statevalue:float = states_value["state_ALLDAMRES"]
		v *= equipvalue
		v *= statevalue
		return v

# 金币数量  
var m_gold:int  
var gold:int:  
	get:
		return m_gold
	set(value):
		m_gold = value
		
# 玩家血瓶获取收益
var m_hp_get_rate:float = 1
var hp_get_rate:float:  
	get:  
		var v = m_hp_get_rate
		var equipvalue:float = equips_value["equip_HPGETRAT"]
		var statevalue:float = states_value["state_HPGETRAT"]
		v *= equipvalue
		v *= statevalue
		return v
		
# 玩家金币获取收益
var m_gold_get_rate:float = 1
var gold_get_rate:float:  
	get:  
		var v = m_gold_get_rate
		var equipvalue:float = equips_value["equip_GOLDGETRAT"]
		var statevalue:float = states_value["state_GOLDGETRAT"]
		v *= equipvalue
		v *= statevalue
		return v

# 玩家经验获取收益
var m_exp_get_rate:float = 1
var exp_get_rate:float:  
	get:  
		var v = m_exp_get_rate
		var equipvalue:float = equips_value["equip_EXPGETRAT"]
		var statevalue:float = states_value["state_EXPGETRAT"]
		v *= equipvalue
		v *= statevalue
		return v
		
# 道具列表  
var m_item:Dictionary
var item:Dictionary:
	get:
		var item_optimized_dict = {}
		for key in m_item:
			var value = m_item[key]
			if typeof(value) == TYPE_FLOAT and value == floor(value):
				item_optimized_dict[key] = int(value)
			else:
				item_optimized_dict[key] = value
		return item_optimized_dict
		
# 玩家装备槽位
var m_equip_slot:Array
var equip_slot:Array:
	get:
		return m_equip_slot
# 玩家装备列表  
var m_equip:Dictionary
var equip:Dictionary:  
	get:  
		return m_equip
		
#装备能力值
var equips_snapshot:Dictionary = {}
var equips_value:Dictionary:
	get:
		if !equips_snapshot.is_empty():
			return equips_snapshot
		#装备能力基础参
		#数组形式前为固定值，后为小数点百分比
		#非数组形式没这个限制，具体值根据每项值作参考确定是小数点还是整形
		var v:Dictionary = {
			"equip_ATK" : [0,1] ,
			"equip_DEF" : [0,1] ,
			"equip_MDEF" : [0,1] ,
			"equip_ALLDAMRAT" : 0 ,
			"equip_ALLDAMRES" : 1 ,
			"equip_ATKMAGDAM" : 0 ,
			"equip_HPGETRAT" : 1 ,
			"equip_GOLDGETRAT" : 1 ,
			"equip_EXPGETRAT" : 1 
			}
		#根据装备获取值
		for i in equip:
			if equip[i] != null && equip[i] != "":
				var equip_id:int = equip[i].to_int()
				var equip_data = DatatableManager.Equip.data[equip_id]
				#攻击力固定值
				if equip_data["equipArr"].has("ATK"):
					v["equip_ATK"][0] += equip_data["equipArr"]["ATK"]
				#攻击力百分比
				if equip_data["equipArr"].has("ATKPER"):
					v["equip_ATK"][1] += equip_data["equipArr"]["ATKPER"]
				#防御力固定值
				if equip_data["equipArr"].has("DEF"):
					v["equip_DEF"][0] += equip_data["equipArr"]["DEF"]
				#防御力百分比
				if equip_data["equipArr"].has("DEFPER"):
					v["equip_DEF"][1] += equip_data["equipArr"]["DEFPER"]
				#魔防固定值
				if equip_data["equipArr"].has("MDEF"):
					v["equip_MDEF"][0] += equip_data["equipArr"]["MDEF"]
				#魔防百分比
				if equip_data["equipArr"].has("MDEFPER"):
					v["equip_MDEF"][1] += equip_data["equipArr"]["MDEFPER"]
				#玩家全伤害增伤百分比
				if equip_data["equipArr"].has("ALLDAMRAT"):
					v["equip_ALLDAMRAT"] += equip_data["equipArr"]["ALLDAMRAT"]
				#玩家全伤害减伤百分比
				if equip_data["equipArr"].has("ALLDAMRES"):
					v["equip_ALLDAMRES"] *= (1 - equip_data["equipArr"]["ALLDAMRES"] / 100.0)
				#血瓶获取比率百分比
				if equip_data["equipArr"].has("HPGETRAT"):
					v["equip_HPGETRAT"] += equip_data["equipArr"]["HPGETRAT"]
				#金币获取比率百分比
				if equip_data["equipArr"].has("GOLDGETRAT"):
					v["equip_GOLDGETRAT"] += equip_data["equipArr"]["GOLDGETRAT"]
				#经验获取比率百分比
				if equip_data["equipArr"].has("EXPGETRAT"):
					v["equip_EXPGETRAT"] += equip_data["equipArr"]["EXPGETRAT"]
				#装备额外效果
				match equip[i]:
					"114":  # 预制模板
						v["equip_ATK"][0] += 114
		equips_snapshot = v
		return v

# 装备池列表  
var m_equip_pool:Dictionary
var equip_pool:Dictionary:  
	get:  
		return m_equip_pool

# 状态列表 
# 不仅包括毒衰等buff和debuff，也包括全局光环,功法增益等状态，统一在某处显示
var m_state:Dictionary
var state:Dictionary:
	get:
		var state_optimized_dict = {}
		for key in m_state:
			var value = m_state[key]
			if typeof(value) == TYPE_FLOAT and value == floor(value):
				state_optimized_dict[key] = int(value)
			else:
				state_optimized_dict[key] = value
		return state_optimized_dict
		
# 状态和增益效果增幅力值
var states_snapshot:Dictionary = {}
var states_value:Dictionary:
	get:
		if !states_snapshot.is_empty():
			return states_snapshot
		#状态和增益效果增幅能力基础参
		#数组形式前为固定值，后为小数点百分比
		#非数组形式没这个限制，具体值根据每项值作参考确定是小数点还是整形
		var v:Dictionary = {
			"state_ATK" : [0,1] ,
			"state_DEF" : [0,1] ,
			"state_MDEF" : [0,1] ,
			"state_ALLDAMRAT" : 0 ,
			"state_ALLDAMRES" : 1 ,
			"state_HPGETRAT" : 1 ,
			"state_GOLDGETRAT" : 1 ,
			"state_EXPGETRAT" : 1
			}
		#状态
		for i in state:
			match i:
				"1": #中毒
					v["state_ALLDAMRES"] *= (1 + 10 * state[i] / 100.0)
				"2": #衰弱
					v["state_ATK"][1] *= 0.95 ** state[i]
					v["state_DEF"][1] *= 0.95 ** state[i]
				"4": #诅咒
					v["state_MDEF"][1] *= (1 - 10 * state[i] /100.0)
				"6": #封印
					v["state_ALLDAMRES"] *= 2 ** state[i]
		states_snapshot = v
		return v
		
func reset_snapshot():
	equips_snapshot = {}
	states_snapshot = {}

# ------------日用方法--------------

func addItem(ID ,value:int):
	var IDstr = str(int(ID))
	if m_item.has(IDstr):
		m_item[IDstr] += value
	else:  
		m_item[IDstr] = value
	#如果道具数量小于0，则强制等于0
	if m_item[IDstr] < 0:
		m_item[IDstr] = 0

func getItemNum(ID) -> int:
	var IDstr = str(int(ID))
	if m_item.has(IDstr):
		return m_item[IDstr]
	else:
		return 0
		
#添加玩家装备槽位(槽位名称、该槽位初始装备id，默认为0)
func addEquipSlot(slot_name:String,original_equip:int = 0):
	equip_slot.append(slot_name)
	if original_equip != 0:
		var original_equip_id:String = str(original_equip)
		equip[slot_name] = original_equip_id
	else:
		equip[slot_name] = null
	if MotaSystem.gameForm != null:
		MotaSystem.gameForm.creatEquipUI()
		MotaSystem.gameForm.RefreshUI()
		
#更新玩家装备
func updateEquip(equip_location,ID):
	var IDstr = null
	if (ID != null):
		IDstr = str(int(ID))
	m_equip[equip_location] = IDstr

func setEquip(new_equip : Dictionary):
	for key in m_equip:
		if m_equip[key] == null:
			continue
		if new_equip.has(key) && new_equip[key] == m_equip[key]:
			continue
		MotaSystem.gameData.addEquip_pool(m_equip[key],1)
		MotaSystem.gameData.updateEquip(key, null)
	for key in new_equip:
		if new_equip[key] == null:
			continue
		if m_equip.has(key) && new_equip[key] == m_equip[key]:
			continue
		MotaSystem.gameData.addEquip_pool(new_equip[key],-1)
		MotaSystem.gameData.updateEquip(key, new_equip[key])

#增加装备池
func addEquip_pool(ID, value:int):  
	var IDstr = str(int(ID))
	if m_equip_pool.has(IDstr):  
		m_equip_pool[IDstr] += value  
	else:  
		m_equip_pool[IDstr] = value  
	#如果值小于等于0则清空
	if m_equip_pool[IDstr] <= 0:
		m_equip_pool.erase(IDstr)

#获取装备池中的装备
func getEquip_pool_Num(ID) -> int:  
	var IDstr = str(int(ID))
	if m_equip_pool.has(IDstr):  
		return m_equip_pool[IDstr]  
	else:  
		return 0
		
#查找装备区中的装备
func findPlayerEquip(ID) -> bool:
	var IDstr = str(int(ID))
	if equip.values().has(IDstr):
		return true
	else:
		return false
		
func getStateNum(ID) -> int: 
	var IDstr = str(int(ID))
	if m_state.has(IDstr):  
		return m_state[IDstr]  
	else:  
		return 0
		
func addState(ID, value:int):  
	var IDstr = str(int(ID))
	var State_Max:int = DatatableManager.State.data[int(IDstr)]["stateMax"]
	if m_state.has(IDstr):  
		m_state[IDstr] = max(m_state[IDstr] + value,0)
	else:  
		m_state[IDstr] = max(value,0)
	if State_Max > 0:
		m_state[IDstr] = min(m_state[IDstr],State_Max)
	if m_state[IDstr] == 0:
		m_state.erase(IDstr)
		
# 移除状态
# 无视一切的暴力移除，慎用
func removeState(ID):
	var IDstr = str(int(ID))
	if m_state.has(IDstr):
		m_state.erase(IDstr)
		
func getStateInfo(ID):
	var state_info:String = ""
	var IDstr = str(ID)
	var format_SkillValues:Array[String]
	state_info = tr(DatatableManager.State.data[IDstr.to_int()]["stateNote"]).format(format_SkillValues,"{_}")
	return state_info

#---------------------变量---------------------------
# 游戏变量
# 为了防止gamedata长度超标,特将变量相关挪到另一个类里面

var variableManager:GameVariables

# -----------初始化----------

func _init(save):
	if save == null:
		m_level = GameFirstData.startLv
		m_expe = GameFirstData.expe
		m_hp = GameFirstData.hp
		m_atk = GameFirstData.atk
		m_def = GameFirstData.def
		m_mdef = GameFirstData.mdef
		m_gold = GameFirstData.gold
		m_equip_slot = GameFirstData.equipName.duplicate()
		m_equip = GameFirstData.startEquip.duplicate()
		m_equip_pool = GameFirstData.equips.duplicate()
		m_item = GameFirstData.items.duplicate()
		variableManager = GameVariables.new(save)
	else:
		m_level = save.gameData.level
		m_hp = save.gameData.hp
		m_atk = save.gameData.atk
		m_def = save.gameData.def
		m_mdef = save.gameData.mdef
		m_gold = save.gameData.gold
		m_expe = save.gameData.expe
		m_equip_pool = save.gameData.equip_pool
		m_item = save.gameData.item
		m_state = save.gameData.state
		variableManager = GameVariables.new(save)
		m_equip_slot = save.gameData.equip_slot
		m_equip = save.gameData.equip
		
		# 装备槽数先同步GameFirstData,然后从存档里检查，如果存档里有多的就加进来
		m_equip_slot = GameFirstData.equipName.duplicate()
		for i in save.gameData.equip_slot:
			if m_equip_slot.has(i) == false:
				m_equip_slot.append(i)
		# 实际装备配置情况先强制拉取gamefirstdata，再同步存档，保证新增槽位不出问题
		m_equip = GameFirstData.startEquip.duplicate()
		m_equip.merge(save.gameData.equip,true)
		
	# 游戏名称
	variableManager.gameVariables["gameName"] = GameFirstData.title


#-----------------------存档用快照--------------------------
#-----------------------------------------------
# 存档中加进去的Data
# 存档中的各类属性均为基础属性(比如base_atk)，只不过key仍然是原先的(比如atk)
var gameData:Dictionary:
	get:
		return {
			"level":m_level,
			"hp":m_hp,
			"atk":m_atk,
			"def":m_def,
			"mdef":m_mdef,
			"gold":m_gold,
			"expe":m_expe,
			"equip_slot":m_equip_slot,
			"equip":m_equip,
			"equip_pool":m_equip_pool,
			"item":m_item,
			"state":m_state,
			"gameVariables":variableManager.gameVariables
		}
#-------------------------------------------------------
