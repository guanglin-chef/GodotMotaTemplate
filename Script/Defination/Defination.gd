class_name Defination extends Node

#static var screen_width = 1600
#static var screen_height = 960

static var tilesize = 64

static var shuwei = ["","万","亿","兆","京","垓","秭","穰","沟","涧","正","载","极","阿僧第","那由他","恒河沙","不可思议","无量","大数"];
static var shuwei2 = ["","W","E","Z","J","G","Zi","R","Go","Jn","Zh","Za","Ji","阿僧第","那由他","恒河沙","不可思议","无量","大数"];

static var ENshuwei = ["","kilo","mega","giga","tera","peta","exa","zetta","yotta","ronna","quetta"];
static var ENshuwei2 = ["","K","M","G","T","P","E","Z","Y","R","Q"];

# 最高存档数
static var saveMax = 1000

static var Talent_Display_Name
static var Equip_Type
static var Item_Type
static var Item_CanUse
static var State_Type
static var Skill_Type
static var KeySetting_text

static func p_ready():
	var obj = Node.new()
	
# 平台全局天赋显示名称映射
	Talent_Display_Name = {
		"Player_Atk_Per":  obj.tr("玩家攻击提升"),
		"Player_Def_Per":  obj.tr("玩家防御提升"),
		"Player_Mdef_Per": obj.tr("玩家魔防提升"),
		"Player_Hp_Get_Per":  obj.tr("玩家血瓶收益提升"),
		"Player_Gold_Get_Per": obj.tr("玩家金币收益提升"),
		"Player_No_Map_Damage": obj.tr("玩家是否免疫地图效果"),
		"Player_No_Debuff": obj.tr("玩家是否免疫负面状态"),
		"Enemy_Hp_Per":  obj.tr("敌人血量提升"),
		"Enemy_Atk_Per": obj.tr("敌人攻击提升"),
		"Enemy_Def_Per": obj.tr("敌人防御提升"),
		"Enemy_Skill_Per": obj.tr("敌人部分技能提升"),
	}

	# 装备类别
	Equip_Type = {
		0:obj.tr("兵器"),
		1:obj.tr("护具"),
		2:obj.tr("鞋子"),
		3:obj.tr("宝物"),
		4:obj.tr("功法"),
		}

	# 道具类别
	Item_Type = {
		0:obj.tr("道具类"),
		1:obj.tr("钥匙类"),
		2:obj.tr("消耗类")
		}
		
	#道具可用性
	Item_CanUse = {
		0:obj.tr("永久道具"),
		1:obj.tr("使用道具")
	}

	# 状态类别
	State_Type = {
		0:obj.tr("状态"),
		1:obj.tr("增益"),
		2:obj.tr("减益"),
		3:obj.tr("光环"),
		4:obj.tr("计数")
		}

	# 技能类别
	Skill_Type = {
		0:obj.tr("主动技能"),
		1:obj.tr("被动技能"),
		2:obj.tr("光环技能"),
		3:obj.tr("地图技能"),
		4:obj.tr("支援技能")
		}
		


	# 快捷键名称(需与下方KeySetting_Name的序号一一对应)
	KeySetting_text = {
		0:obj.tr("敌人详情"),
		1:obj.tr("装备与物品"),
		2:obj.tr("楼层传送"),
		3:obj.tr("快捷商店"),
		4:obj.tr("存档界面"),
		5:obj.tr("读档界面"),
		6:obj.tr("撤回"),
		7:obj.tr("系统"),
		8:obj.tr("转身"),
		9:obj.tr("触发面前事件"),
		10:obj.tr("快速剧情"),
	}

# 快捷键设置（可改快捷键的键名）
static var KeySetting_Name = {
	0:"call_handbook",
	1:"call_equip",
	2:"call_minimap",
	3:"call_shop",
	4:"call_save",
	5:"call_load",
	6:"auto_load",
	7:"call_menu",
	8:"turn",
	9:"trigger_face",
	10:"fast_text"
}

# 按键映射
static var Key_Mappings = {
	# ----- 符号键 -----
	"minus": KEY_MINUS,
	"plus": KEY_PLUS,
	"equal": KEY_EQUAL,
	"bracketleft": KEY_BRACKETLEFT,
	"bracketright": KEY_BRACKETRIGHT,
	"backslash": KEY_BACKSLASH,
	"semicolon": KEY_SEMICOLON,
	"apostrophe": KEY_APOSTROPHE,
	"comma": KEY_COMMA,
	"period": KEY_PERIOD,
	"slash": KEY_SLASH,
	"quoteleft": KEY_QUOTELEFT,
	# ----- 常用功能键 -----
	"space": KEY_SPACE,
	"tab": KEY_TAB,
	"enter": KEY_ENTER,
	"esc": KEY_ESCAPE,
	"escape": KEY_ESCAPE,
	"backspace": KEY_BACKSPACE,
	"delete": KEY_DELETE,
	"del": KEY_DELETE,
	"insert": KEY_INSERT,
	"ins": KEY_INSERT,
	"home": KEY_HOME,
	"end": KEY_END,
	"pageup": KEY_PAGEUP,
	"pagedown": KEY_PAGEDOWN,
	"printscreen": KEY_PRINT,
	"pause": KEY_PAUSE,
	"scrolllock": KEY_SCROLLLOCK,
	# ----- 修饰键 -----
	"shift": KEY_SHIFT,
	"ctrl": KEY_CTRL,
	"control": KEY_CTRL,
	"alt": KEY_ALT,
	# ----- 小键盘键 -----
	"kp 0": KEY_KP_0,
	"kp 1": KEY_KP_1,
	"kp 2": KEY_KP_2,
	"kp 3": KEY_KP_3,
	"kp 4": KEY_KP_4,
	"kp 5": KEY_KP_5,
	"kp 6": KEY_KP_6,
	"kp 7": KEY_KP_7,
	"kp 8": KEY_KP_8,
	"kp 9": KEY_KP_9,
	"kp add": KEY_KP_ADD,
	"kp subtract": KEY_KP_SUBTRACT,
	"kp multiply": KEY_KP_MULTIPLY,
	"kp divide": KEY_KP_DIVIDE,
	"kp decimal": KEY_KP_PERIOD,
	"kp enter": KEY_KP_ENTER,
	# ----- 功能键 F1-F12 -----
	"f1": KEY_F1,
	"f2": KEY_F2,
	"f3": KEY_F3,
	"f4": KEY_F4,
	"f5": KEY_F5,
	"f6": KEY_F6,
	"f7": KEY_F7,
	"f8": KEY_F8,
	"f9": KEY_F9,
	"f10": KEY_F10,
	"f11": KEY_F11,
	"f12": KEY_F12,
	# ----- 其他特殊键 -----
	"capslock": KEY_CAPSLOCK,
	"numlock": KEY_NUMLOCK,
	"clear": KEY_CLEAR,
	"menu": KEY_MENU,
	"help": KEY_HELP,
}

enum ProcedureID {
	# 开头加载阶段
	Preload = 1, 
	# 标题阶段
	MainMenu = 2, 
	# 游戏阶段
	MainGame = 3, 
}

enum UIID {
	# 开头加载界面
	PreloadForm = 1, 
	# 标题主界面
	MainForm = 2, 
	# 游戏主界面
	GameForm = 3,
	# 游戏菜单界面
	EnemyHandBookForm = 4,
	# 显示文章界面
	TextForm = 5,
	# 存读档界面
	SaveForm = 6,
	# 道具装备界面
	ItemEquipForm = 7,
	# 选择项界面
	ChoiceForm = 8,
	# 弹窗界面
	PopUpForm = 9,
	# 弹窗选择界面
	PopUpChooseForm = 10,
	# 三按钮弹窗选择界面
	PopUpTripleChooseForm = 11,
	# 设置界面
	SettingForm = 12,
	# 按键设置界面
	KeySettingForm = 13,
	# 怪物详情界面
	EnemyInfoForm = 14,
	# 怪物右键界面
	EnemyStateFormMap = 15,
	# 怪物右键数据详情界面
	EnemyDetailInfoForm = 16,
	# Fuki对话界面
	FukiTextForm = 17,
	# 道具提示界面
	IconTextForm = 18,
	# 合成界面
	FormulaForm = 19,
	# 商店界面
	ShopForm = 20,
	# 提示界面
	HintForm = 21,
	# 状态详情按钮
	StateInfoForm = 22,
	# 系统界面
	SystemForm = 23,
	# 楼传界面
	TeleportForm = 24,
	# 移动端游戏主界面
	MobileGameForm = 25,
	# 章节选择
	ChapterChoiceForm = 26,
}

class UILayer:
	# GameForm层
	static var GameFormLayer = "GameFormLayer"
	# GameFormTop层，服务于StateInfoForm几个弹框面
	static var GameFormLayerTop = "GameFormLayerTop"
	# 跟随Viewport中摄像机一起滚动的的游戏内层
	static var GameViewport = "GameViewport"
	# 游戏内层
	static var Game = "Game"
	# 主界面层
	static var Main = "Main"
	# 提示窗口层
	static var PopUp = "PopUp"

class SpecialEventType:
	static var GameOverEvent = "GameOverEvent"
	static var ItemUsingEvent = "ItemUsingEvent"
	static var ShopEvent = "ShopEvent"
	static var LevelUpEvent = "LevelUpEvent"
	static var ChapterEndEvent = "ChapterEndEvent"

enum direction{
	up = 3,
	down = 0,
	left = 1,
	right = 2
}
