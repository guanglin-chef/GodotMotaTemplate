class_name DatatableManager extends Node

# 如果新增表，需要再在这里注册一下

static var Effect
static var Enemy
static var Equip
static var Item
static var Level
static var Chapter
static var Map
static var Tower
static var Player
static var Procedure
static var Skill
static var State
static var TempPerfab
static var UI

static func p_ready():
	Effect = load('res://Datatable/Dist/Effect/Effect.gd').new()
	Enemy = load('res://Datatable/Dist/Enemy/Enemy.gd').new()
	Equip = load('res://Datatable/Dist/Equip/Equip.gd').new()
	Item = load('res://Datatable/Dist/Item/Item.gd').new()
	Level = load('res://Datatable/Dist/Level/Level.gd').new()
	Chapter = load('res://Datatable/Dist/Map/Chapter.gd').new()
	Map = load('res://Datatable/Dist/Map/Map.gd').new()
	Tower = load('res://Datatable/Dist/Map/Tower.gd').new()
	Player = load('res://Datatable/Dist/Player/Player.gd').new()
	Procedure = load('res://Datatable/Dist/Procedure/Procedure.gd').new()
	Skill = load('res://Datatable/Dist/Skill/Skill.gd').new()
	State = load('res://Datatable/Dist/State/State.gd').new()
	TempPerfab = load('res://Datatable/Dist/TempPerfab/TempPerfab.gd').new()
	UI = load('res://Datatable/Dist/UI/UI.gd').new()
