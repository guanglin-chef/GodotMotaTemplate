class_name GameFirstData extends Node

# 标题文字
static var title = "魔塔样板 v0.1.0"
# 标识符
static var gameIdentifier = "GodotMotaTemplate"
# 版本
static var gameVersion = "0.1.0"
# 总章节数
static var gameChapters = 16
# 内测模式
static var test = true
# ---角色开局配置---
# 开局所用角色id
static var playerId = 1
# 开局等级
static var startLv = 1
# 开局血量
static var hp = 1000
# 开局攻击
static var atk = 5
# 开局防御
static var def = 5
# 开局护盾
static var mdef = 0
# 开局金币
static var gold = 0
# 开局经验
static var expe = 0
# 开局装备池子
# 示例： { "1":5 } 代表1号装备开局有5个
static var equips = {}
# 开局道具
static var items = {}
# 装备孔
static var equipName = ["equip_1","equip_2","equip_3","equip_4","equip_5"]
# 开局佩戴装备
static var startEquip = {
	"equip_1":null,
	"equip_2":null,
	"equip_3":null,
	"equip_4":null,
	"equip_5":null
	}

# 开局人体火车
static var startFollower = []
# 开局队友id
static var partnerId = 0
# 开局地图
static var startMapId = 1
# 开局位置
static var startPosition = {
	dir = 3,
	pos = Vector2i(7,9)
}
