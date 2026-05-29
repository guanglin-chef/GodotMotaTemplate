##==============================================================================
## ■ GameBattle
##------------------------------------------------------------------------------
## 战场对象
##==============================================================================
class_name GameBattle
##==============================================================================
## ■ battlResult
##------------------------------------------------------------------------------
## 战斗的结果（胜利，不破防，无敌）
##==============================================================================
enum battlResult
{
	win,           ## 胜利
	dead,          ## 战败
	invincible,    ## 无敌
	Undetectable,  ## 无法侦测
}
##--------------------------------------------------------------------------
## ● 战斗单位参数
##--------------------------------------------------------------------------
var base_id     : int          ## 初始敌人
var buff        : Dictionary   ## 状态Buff
var p_fighter   : GameFighter  ## 我方单位
var e_fighter   : GameFighter  ## 敌方单位
##--------------------------------------------------------------------------
## ● 战斗结果变量
##--------------------------------------------------------------------------
var first     : int = 1      ## 玩家先攻次数
var critical  : float        ## 临界值
var turnCount : int          ## 回合数
var damage    : int          ## 伤害
var result    : battlResult  ## 战斗结果
##--------------------------------------------------------------------------
## ● 初始化对象
##--------------------------------------------------------------------------
func _init(id : int, buf : Dictionary = {}, player : GameFighter = GameFighter.new()):
	base_id   = id
	buff      = buf
	p_fighter = player
	ready()
##--------------------------------------------------------------------------
## ● 载入战斗单位
##--------------------------------------------------------------------------
func load_fighter():
	# 初始化战斗单位
	e_fighter = GameFighter.new(base_id, buff, p_fighter)
##--------------------------------------------------------------------------
## ● 战斗准备
##--------------------------------------------------------------------------
func ready():
	load_fighter()
	get_first()
	battle()
##--------------------------------------------------------------------------
## ● 计算先攻次数
##--------------------------------------------------------------------------
func get_first():
	first -= e_fighter.first
	# 迟缓 每一层该状态会使你在战斗中被敌人先攻2回合
	if MotaSystem.gameData.state.has("3"):
		first -= MotaSystem.gameData.state["3"] * 2
##--------------------------------------------------------------------------
## ● 计算战斗过程
##--------------------------------------------------------------------------
func battle():
	# 首先是怪物无敌则直接跳过战斗过程
	if false:  # 条件自己写
		result = battlResult.invincible
		return
	# 怪物有无法侦测也跳过战斗过程
	if e_fighter.skill.has("19"):
		result = battlResult.Undetectable
		return
	# 先计算护盾
	var temp_damage : float = 0 - p_fighter.total_mdef
	# 计算固伤
	temp_damage += e_fighter.player_damage * p_fighter.damage_rate * e_fighter.damage_plus
	# 玩家每回合能造成的输出
	var player_dam_rate : float = e_fighter.damage_rate * p_fighter.damage_plus
	var self_atk_rate   : float = p_fighter.damage_rate * p_fighter.damage_plus
	var player_dam      : float = [(p_fighter.atk - (e_fighter.def * max(1 - p_fighter.def_break_per, 0))) * player_dam_rate, 0].max()
	# 破不了防就爬
	if player_dam <= 0 && is_equal_approx(e_fighter.vampire, 0):
		result = battlResult.dead
		critical = floori((e_fighter.def * max(1 - p_fighter.def_break_per, 0)) - p_fighter.atk) + 1
		return
	# 计算出怪物攻击伤害
	var enemy_dam : float = [e_fighter.atk - (p_fighter.def * max(1 - e_fighter.def_break_per, 0)), 0].max() * p_fighter.damage_rate * e_fighter.damage_plus
	# 可破防时通过输出与敌人血量计算出战斗回合
	turnCount = ceili(e_fighter.hp / player_dam) - 1
	# 计算临界值
	var modulo : float = fmod(e_fighter.hp,player_dam)
	if turnCount >= 1:
		if modulo == 0:
			modulo = player_dam
		critical = modulo / turnCount
	# 剩余需要结算的回合
	var next_enemy_hit = (turnCount - min(first - 1, 0)) * e_fighter.hit
	var next_atktime   = turnCount + max(first, 1)
	# 根据是否有吸血划分计算公式
	if e_fighter.vampire > 0.00:
		var hp_change   : float = 0
		var no_vam_time : int   = [first, 0].max()
		if first - 1 < 0:  # 此场战斗为敌人先攻1次以上
			# 结算敌人的先攻结果
			e_fighter.hp += [(absi(first - 1) * e_fighter.hit * enemy_dam * p_fighter.damage_rate * e_fighter.damage_plus) + [temp_damage, 0].min(), 0].max() * e_fighter.vampire
			temp_damage += absi(first - 1) * e_fighter.hit * enemy_dam * p_fighter.damage_rate * e_fighter.damage_plus
			next_enemy_hit -= absi(first - 1) * e_fighter.hit
		# 结算第一回合攻击
		e_fighter.hp -= player_dam * max(first, 1)
		if e_fighter.self_atk > 0.00:
			e_fighter.value["10"]["total_damage"] += max(first, 1) * e_fighter.self_atk * max(p_fighter.atk - (p_fighter.def * max(1 - p_fighter.def_break_per, 0)), 0) * self_atk_rate
			temp_damage += max(first, 1) * e_fighter.self_atk * max(p_fighter.atk - (p_fighter.def * max(1 - p_fighter.def_break_per, 0)), 0) * self_atk_rate
		# 将回合优先级从玩家攻击后怪物攻击调整为怪物攻击后玩家攻击
		next_atktime -= max(first, 1)
		# 怪物是否死亡
		if e_fighter.hp <= 0:
			# 被秒，临界归零
			critical = 0
			# 设置伤害下限，不能为负伤
			damage = [temp_damage, 0].max() 
			# 战斗胜利！
			result = battlResult.win
			return
		modulo = e_fighter.hp
		# 由于对吸血进行计算需要将一个 [回合单位] 从 [先玩家后怪物] 的情况调整至 [先怪物后玩家]
		# 所以first为0的情况不需要对结果进行结算
		if turnCount > 0 && e_fighter.first_atk > 1.00:
			# 首先由于怪物并没有在这个阶段死亡，而且先攻，所以必定会有一回合x倍攻击
			e_fighter.hp += [((((e_fighter.first_atk - 1) * e_fighter.atk) - [(p_fighter.def * max(1 - e_fighter.def_break_per, 0)) - e_fighter.atk, 0].max()) * e_fighter.hit * p_fighter.damage_rate * e_fighter.damage_plus * ([(first - 1) * -1, 1].max())) + [temp_damage, 0].min(), 0].max() * e_fighter.vampire
			temp_damage += (((e_fighter.first_atk - 1) * e_fighter.atk) - [(p_fighter.def * max(1 - e_fighter.def_break_per, 0)) - e_fighter.atk, 0].max()) * e_fighter.hit * p_fighter.damage_rate * e_fighter.damage_plus * ([(first - 1) * -1, 1].max())
		# 计算护盾破碎的回合
		var break_time : int = 0
		# 根据剩余护盾情况划分计算阶段
		if temp_damage < 0.00:
			# 首先计算第几回合会护盾破碎
			var break_dam  : float = enemy_dam * e_fighter.hit
			if e_fighter.self_atk > 0.00:
				break_dam += e_fighter.self_atk * max(p_fighter.atk - (p_fighter.def * max(1 - p_fighter.def_break_per, 0)), 0) * self_atk_rate
			break_time = [ceili(absf(temp_damage) / break_dam), turnCount].min()
			# 计算经过这些回合后怪物生命值的波动
			e_fighter.hp -= player_dam * break_time
			hp_change = break_dam * break_time
			if e_fighter.self_atk > 0.00:
				# 用反击破盾需要给吸取的血量减去最后一回合的反击
				hp_change -= e_fighter.self_atk * max(p_fighter.atk - (p_fighter.def * max(1 - p_fighter.def_break_per, 0)), 0) * self_atk_rate
			hp_change = [hp_change + [temp_damage, 0].min(), 0].max() * e_fighter.vampire
			e_fighter.hp += hp_change
			hp_change -= player_dam
		# 护盾回合计算完毕，开始计算是否能够对怪物造成的实质伤害
		if player_dam - (enemy_dam * e_fighter.hit * e_fighter.vampire) > 0.00:
			# 根据怪物已波动的血量值 更新额外存活回合
			var next : int = max(ceili(e_fighter.hp / (player_dam - (enemy_dam * e_fighter.hit * e_fighter.vampire))) - (turnCount - break_time), 0)
			# 运算回合和总回合增加 由于吸血额外存活的回合部分
			next_atktime += next
			next_enemy_hit += next * e_fighter.hit
			turnCount += next
			# 吸血的临界计算
			if e_fighter.hp > 0.00:
				modulo = fmod(e_fighter.hp, (player_dam - (enemy_dam * e_fighter.hit * e_fighter.vampire)))
				if modulo == 0:
					modulo = (player_dam - (enemy_dam * e_fighter.hit * e_fighter.vampire))
			else:
				modulo = fmod(e_fighter.hp - hp_change + player_dam, player_dam)
				if modulo == 0:
					modulo = player_dam
			critical = max(ceili(modulo / turnCount / player_dam_rate), 1)
		elif e_fighter.hp > 0.00:
			if hp_change <= 0:
				modulo += hp_change
			else:
				break_time = [break_time - 1, 0].max()
			modulo -= player_dam * break_time
			no_vam_time += break_time
			if no_vam_time > 1:
				critical = max(min(ceili(modulo / (no_vam_time - 1)), (floori(enemy_dam * e_fighter.hit * e_fighter.vampire) + 1) - player_dam), 1)
			else:
				critical = (floori(enemy_dam * e_fighter.hit * e_fighter.vampire) + 1) - player_dam
				# 根据玩家伤害系数 和 怪物减伤 计算出总临界
				get_total_critical()
				if player_dam <= 0:
					critical += ceili((e_fighter.def * max(1 - p_fighter.def_break_per, 0)) - p_fighter.atk)
			result = battlResult.dead
			return
	else:
		# 计算第一回合x倍攻击
		if turnCount > 0 && e_fighter.first_atk > 1.00:
			temp_damage += (((e_fighter.first_atk - 1) * e_fighter.atk) - [(p_fighter.def * max(1 - e_fighter.def_break_per, 0)) - e_fighter.atk, 0].max()) * e_fighter.hit * p_fighter.damage_rate * e_fighter.damage_plus * ([(first - 1) * -1, 1].max())
	# 根据玩家伤害系数 和 怪物减伤 计算出总临界
	get_total_critical()
	# 计算出总伤害
	temp_damage += next_enemy_hit * enemy_dam
	# 根据玩家攻击回合计算反伤
	if e_fighter.self_atk > 0.00:
		e_fighter.value["10"]["damage"] = e_fighter.self_atk * max(p_fighter.atk - (p_fighter.def * max(1 - p_fighter.def_break_per, 0)), 0) * self_atk_rate
		e_fighter.value["10"]["total_damage"] += next_atktime * e_fighter.self_atk * max(p_fighter.atk - (p_fighter.def * max(1 - p_fighter.def_break_per, 0)), 0) * self_atk_rate
		temp_damage += next_atktime * e_fighter.self_atk * max(p_fighter.atk - (p_fighter.def * max(1 - p_fighter.def_break_per, 0)), 0) * self_atk_rate
	# 设置伤害下限，不能为负伤
	damage = [ceili(temp_damage), 0].max() 
	# 战斗胜利！
	result = battlResult.win
##--------------------------------------------------------------------------
## ● 获取计算倍率后的真实临界
##--------------------------------------------------------------------------
func get_total_critical():
	critical = max(ceili(critical / e_fighter.damage_rate * p_fighter.damage_plus), 1)
##--------------------------------------------------------------------------
## ● 以字符串的类型返回显示的伤害
##--------------------------------------------------------------------------
func get_text() -> String:
	match result:
		battlResult.dead:
			return "???"
		battlResult.invincible:
			return tr("无敌")
		battlResult.Undetectable:
			return "???"
	return str(damage)
##--------------------------------------------------------------------------
## ● 以字符串的类型返回回合数
##--------------------------------------------------------------------------
func get_turn_text():
	match result:
		battlResult.dead:
			return "???"
		battlResult.invincible:
			return tr("无敌")
		battlResult.Undetectable:
			return "???"
	return str(turnCount + 1)
##--------------------------------------------------------------------------
## ● 以字符串的类型返回回合数
##--------------------------------------------------------------------------
func get_critical_text():
	match result:
		battlResult.dead:
			return str(int(critical))
		battlResult.invincible:
			return tr("无敌")
		battlResult.Undetectable:
			return "???"
	if e_fighter.skill.has("4"):
		return "——"
	elif turnCount <= 0:
		return "——"
	else:
		return str(int(critical))
##--------------------------------------------------------------------------
## ● 以字符串的类型返回反馈参数
##--------------------------------------------------------------------------
func get_value_string(id = "8", key = "damage"):  # 默认获取净化参数
	if id is int:
		id = str(id)
	if e_fighter.value.has(id) && e_fighter.value[id].has(key):
		return str(e_fighter.value[id][key])
	return "Error"
##--------------------------------------------------------------------------
## ● 返回反馈参数
##--------------------------------------------------------------------------
func get_value(id = "8"):  # 默认获取净化参数
	if id is int:
		id = str(id)
	if e_fighter.value.has(id):
		return e_fighter.value[id]
	return {}
##--------------------------------------------------------------------------
## ● 以字符串的类型返回反馈参数
##--------------------------------------------------------------------------
func get_skill_value(id = "8", key = "damage"):  # 默认获取净化参数
	if id is int:
		id = str(id)
	if e_fighter.value.has(id) && e_fighter.value[id].has(key):
		return e_fighter.value[id][key]
	return 0
static func traverse_damage( id : int, buf : Dictionary = {} ):
	var min_dam_obj  : GameBattle
	var max_mdef_obj : GameBattle
	var temp_battle  : GameBattle
	var index        : int = 0
	var min_dam_i    : int = 0
	var max_mdef_i   : int = 0
	for fighter in MotaSystem.CurrentMap.enemyReady.Fighterlist:
		temp_battle = GameBattle.new(id, buf, fighter)
		if min_dam_obj == null:
			min_dam_obj = temp_battle
			min_dam_i = index
		elif temp_battle.result == battlResult.win:
			if temp_battle.damage < min_dam_obj.damage || min_dam_obj.result != battlResult.win:
				min_dam_obj = temp_battle
				min_dam_i = index
			elif temp_battle.damage == min_dam_obj.damage && (temp_battle.p_fighter.mdef > min_dam_obj.p_fighter.mdef || (temp_battle.p_fighter.mdef == min_dam_obj.p_fighter.mdef && temp_battle.p_fighter.def > min_dam_obj.p_fighter.def) || (temp_battle.p_fighter.mdef == min_dam_obj.p_fighter.mdef && temp_battle.p_fighter.def == min_dam_obj.p_fighter.def && temp_battle.p_fighter.atk > min_dam_obj.p_fighter.atk)):
				min_dam_obj = temp_battle
				min_dam_i = index
		if max_mdef_obj == null || temp_battle.p_fighter.mdef > max_mdef_obj.p_fighter.mdef:
			max_mdef_obj = temp_battle
			max_mdef_i = index
		index += 1
	return [min_dam_obj, max_mdef_obj, min_dam_i, max_mdef_i]
