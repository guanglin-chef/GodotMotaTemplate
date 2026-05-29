# Godot Standard Mota Template — 项目架构文档

> **项目名称**: Godot Standard Mota Template  
> **引擎版本**: Godot 4.5.1 (GL Compatibility)  
> **项目类型**: 2D 魔塔 (MOTA / Dungeon Crawler RPG) 完整框架  
> **文档生成日期**: 2026-03-20

---

## 目录

- [一、项目概述](#一项目概述)
- [二、全局入口与架构总览](#二全局入口与架构总览)
- [三、核心模块详解 (8大系统)](#三核心模块详解-8大系统)
  - [1. 流程管理系统 (Procedure)](#1-流程管理系统-procedure)
  - [2. 游戏管理系统 (Game Management)](#2-游戏管理系统-game-management)
  - [3. 地图系统 (Map System)](#3-地图系统-map-system)
  - [4. 角色系统 (Player System)](#4-角色系统-player-system)
  - [5. 战斗系统 (Battle System)](#5-战斗系统-battle-system)
  - [6. 事件系统 (Event System)](#6-事件系统-event-system)
  - [7. UI系统 (UI Management)](#7-ui系统-ui-management)
  - [8. 特效与音频系统 (Effect & Audio)](#8-特效与音频系统-effect--audio)
- [四、支撑模块](#四支撑模块)
  - [存档系统 (Save)](#存档系统-save)
  - [资源管理 (Resource)](#资源管理-resource)
  - [配置系统 (Config)](#配置系统-config)
  - [常量与初始数据 (Defination)](#常量与初始数据-defination)
  - [数据表系统 (Datatable)](#数据表系统-datatable)
  - [工具类 (Utility)](#工具类-utility)
- [五、编辑器插件 (Addons)](#五编辑器插件-addons)
- [六、资源目录 (Resources)](#六资源目录-resources)
- [七、场景目录 (Scene)](#七场景目录-scene)
- [八、国际化 (Locale)](#八国际化-locale)
- [九、原生扩展 (bin)](#九原生扩展-bin)
- [十、完整文件结构速查](#十完整文件结构速查)
- [十一、游戏启动流程](#十一游戏启动流程)
- [十二、设计模式与架构特征](#十二设计模式与架构特征)

---

## 一、项目概述

本项目是一个**完整的 Godot 2D 魔塔游戏模板框架**，涵盖从主菜单、流程控制、地图编辑、战斗计算、事件编排、UI 管理到存档系统的所有核心功能。采用**高度模块化的管理器架构**，通过统一入口 `MotaSystem` 访问全部子系统，代码达到生产级别。

**核心特性**：
- 数据驱动设计 — 所有游戏内容通过 Excel 配表管理
- 可视化事件编辑器 — 基于 Blockly 的 WebView 事件编排
- PC/移动端自适应 — 横竖屏自动切换 UI 布局
- 多语言支持 — 中文/英文/日文 i18n
- 章节系统 — 支持多章节作品分发

---

## 二、全局入口与架构总览

### MotaSystem (`Script/MotaSystem.gd`)

全游戏的**唯一静态入口**，以 `class_name MotaSystem` 定义，所有子系统均通过其静态属性访问：

```
MotaSystem
├── m_ProcedureManager   → ProcedureManager    # 流程（场景）切换
├── m_GameManager        → GameManager          # 游戏核心调度
├── m_UIManager          → UIManager            # UI 管理
├── m_ResourceManager    → ResourceManager      # 资源缓存与加载
├── m_SaveManager        → SaveManager          # 存档系统
├── m_EffectManager      → EffectManager        # 特效系统
├── m_Config             → Config               # 游戏配置
└── m_KeysSettingConfig  → KeysSettingConfig    # 按键配置
```

**快捷访问方式**（通过静态属性 getter）：
```gdscript
MotaSystem.procedureManager
MotaSystem.gameManager
MotaSystem.uiManager
MotaSystem.saveManager
MotaSystem.effectManager
MotaSystem.config
MotaSystem.gamePlayerManager   # 通过 gameManager 中转
```

**初始化职责** (`p_ready`)：
1. 创建 ProcedureManager、ResourceManager、SaveManager、Config、KeysSettingConfig
2. 设置语言 (TranslationServer)
3. 设置窗口分辨率

---

## 三、核心模块详解 (8大系统)

### 1. 流程管理系统 (Procedure)

**目录**: `Script/Procedure/`

| 文件 | 类名 | 说明 |
|------|------|------|
| `ProcedureManager.gd` | `ProcedureManager` | 流程管理器 — 控制场景切换 |
| `ProcedurePreload.gd` | *(extends Node)* | 预加载流程 — Splash 画面 + 资源预加载 |
| `ProcedureMainMenu.gd` | *(extends Node)* | 主菜单流程 — 初始化主菜单 UI |
| `ProcedureMainGame.gd` | *(extends Node)* | 主游戏流程 — 初始化游戏系统 |

**核心方法**：
- `ProcedureManager.goto_procedure(procedureID)` — 根据 ID 切换至目标流程
- `ProcedureManager.goto_scene(path, param)` — 加载指定场景

**流程切换机制**：每次切换 Procedure 会将场景树全部重置（类似场景 reset），确保状态干净。

**对应场景**：
- `Scene/Procedure/Preload.tscn`
- `Scene/Procedure/MainMenu.tscn`
- `Scene/Procedure/MainGame.tscn`

---

### 2. 游戏管理系统 (Game Management)

**目录**: `Script/Game/`

GameManager 是进入正式游戏后的**总调度器**，在 `ProcedureMainGame._ready()` 中创建，负责管理所有游戏子模块：

| 文件 | 类名 | 说明 |
|------|------|------|
| `GameManager.gd` | `GameManager` | 游戏总管理器 — 协调所有子系统 |
| `GameData.gd` | `GameData` | 游戏数据 — 玩家属性（HP/ATK/DEF/经验等） |
| `GameVariables.gd` | `GameVariables` | 全局变量字典 — 开关/标志/商店价格等 |
| `InputManager.gd` | `InputManager` *(extends Node)* | 输入管理 — 键盘/手柄/触屏处理 |
| `MapManager.gd` | `MapManager` *(extends Node2D)* | 地图管理器 |
| `GameEventManager.gd` | `GameEventManager` | 事件管理器 |
| `GamePlayerManager.gd` | `GamePlayerManager` *(extends Node2D)* | 角色管理器 |
| `ThumbnailManager.gd` | `ThumbnailManager` *(extends Node)* | 缩略图/预览管理器 |
| `PlayerCamera.gd` | `PlayerCamera` *(extends Camera2D)* | 玩家相机 — 震屏/缩放 |

**GameManager 初始化创建的子系统**：
```
GameManager
├── m_GameData           → 玩家属性数据
├── m_GameForm           → 游戏主 UI
├── m_GamePlayerManager  → 角色节点管理
├── m_InputManager       → 输入处理
├── m_MapManager         → 地图管理
├── m_GameEventManager   → 事件队列
└── m_HintForm           → 提示 UI
```

**GameData 属性系统**：采用 base + bonus 模式，例如 `atk = base_atk + 装备/buff加成`，通过 getter 自动计算最终值。

**GameVariables**：基于字典的全局变量系统 (`gameVariables`)，存储游戏开关、商店数据、UFO 模式标志等游戏状态。

---

### 3. 地图系统 (Map System)

**核心文件**：
| 文件 | 说明 |
|------|------|
| `Script/Game/MapManager.gd` | 地图管理器 — 多地图缓存/加载/切换 |
| `Script/Game/GameMap.gd` | 单地图实例 — 地图数据与逻辑 |
| `Script/Game/FindMovePath.gd` | A* 寻路算法实现 |

**特性**：
- **网格大小**：64 像素
- **多地图缓存**：已加载的地图保持在内存中
- **地图预加载**：`pre_load_map()` 避免卡顿
- **Z 轴分层规则**：

| Z-Index | 内容 |
|---------|------|
| 0 | 地板 |
| 1 | 一般事件、略高的地板 |
| 2 | 需要 Y-Sort 的事件、玩家、墙壁 |
| 3 | 高于事件的物体 |

**配置表**：`Datatable/DatatableExcel/Map.xlsx`

**地图场景目录**：
- `Scene/Map/EmptyMap.tscn` — 空白地图模板
- `Scene/Map/Template/` — 示例地图 (0_0, 0_1, 0_2, 0_3, 1_0 等)

---

### 4. 角色系统 (Player System)

**核心文件**：
| 文件 | 类名 | 说明 |
|------|------|------|
| `GameCharacter.gd` | `GameCharacter` *(extends Node2D)* | 角色基类 — 移动/朝向/动画 |
| `FrameAnimation.gd` | `FrameAnimation` *(extends Sprite2D)* | 帧动画基类 — 行走图动画 |
| `GamePlayer.gd` | `GamePlayer` *(extends GameCharacter)* | 玩家角色 — 控制/相机跟随 |
| `GamePlayerManager.gd` | `GamePlayerManager` *(extends Node2D)* | 角色管理 — 主角与跟随者 |

**继承链**：
```
Sprite2D → FrameAnimation → EventPage (事件页)
Node2D → GameCharacter → GamePlayer (玩家)
                       → GameEvent (事件)
```

**角色功能**：
- 4 方向移动 (UP / DOWN / LEFT / RIGHT)
- 网格移动 (基于 tilePosition 的整格移动)
- 自动寻路 (A* 算法)
- 跟随角色系统 (主角 → 跟随者1 → 跟随者2 ...)
- 跳跃动画 (jumpPeak / jumpCount)

**行走图格式**：4×4 网格 (Hframes=4, Vframes=4)，frame index 0–15

**预制体**：
- `Scene/Prefab/Player.tscn` — 玩家
- `Scene/Prefab/Character.tscn` — 通用角色
- `Scene/Prefab/PlayerNode.tscn` — 玩家节点

---

### 5. 战斗系统 (Battle System)

**目录**: `Script/Game/Battle/`

| 文件 | 类名 | 说明 |
|------|------|------|
| `GameBattle.gd` | `GameBattle` | 战斗计算核心引擎 |
| `GameFighter.gd` | `GameFighter` | 战斗单位 — 属性/技能/Buff |
| `EnemyData.gd` | `EnemyData` | 敌人数据容器 |
| `EnemyReady.gd` | `EnemyReady` | 地图敌人预处理 — 刷新战斗列表 |
| `AreaManager.gd` | `AreaManager` | 光环/区域效果管理 |

**战斗流程**：
```
MonsterEvent.enter() → GameBattle._init(enemyID, buff)
  → load_fighter() 加载双方属性
  → ready() 预计算
  → get_first() 判定先攻
  → battle() 回合制计算
  → 返回结果 (win/dead/invincible/Undetectable)
```

**伤害计算公式**：
```
玩家伤害 = (ATK - 敌DEF × 防御破坏率) × 伤害倍率 × 额外加成
敌伤害   = (敌ATK - DEF × 破防率) × 伤害倍率 × 加成
战斗回合 = 敌HP ÷ 玩家单次伤害
```

**GameFighter 属性**：
```
enemy_id, name, level, maxhp, hp, atk, def, mdef,
hit, vampire, exp, gold, first, skill, state, buf,
equip, target, total_mdef
```

**支持机制**：
- 状态 Buff 管理 (`load_buff`)
- 吸血效果 (`vampire`)
- 防御破坏
- 暴击计算
- 先攻次数 (`first`)
- 区域光环 (`AreaManager.Map_Area()`)
- 技能系统 (`load_skill`)

**配置表**：`Datatable/DatatableExcel/Enemy.xlsx`、`Skill.xlsx`、`State.xlsx`

---

### 6. 事件系统 (Event System)

**目录**: `Script/Game/Event/`

事件系统是魔塔游戏的核心玩法载体，采用**事件页 (EventPage)** 机制，每个事件由若干页组成，根据条件切换当前页。

#### 6.1 架构

```
GameEventManager           # 事件队列调度器 (AsyncQueue)
  └── GameEvent             # 事件实体 (extends GameCharacter)
        ├── EventPage[0]    # 事件页0
        ├── EventPage[1]    # 事件页1
        └── ...
```

**继承链**：
```
Sprite2D → FrameAnimation → EventPage (事件页基类)
                            ├── MonsterEvent
                            ├── TeleportEvent
                            ├── ItemEvent
                            ├── ConsumableEvent
                            ├── BarrierEvent
                            ├── ConditionEvent
                            ├── TrapEvent
                            ├── EmptyEvent
                            ├── RegionBarrierEvent
                            ├── TeleportTowerEvent
                            ├── MonsterCheckEvent
                            ├── CombinedEvent
                            └── SpecialEvent/
                                ├── GameOverEvent
                                └── ShopEvent
```

#### 6.2 事件类型一览

| 类型 | 文件 | 功能 |
|------|------|------|
| 怪物 | `MonsterEvent.gd` | 触发战斗，含 enemyID/buff/debuff |
| 传送 | `TeleportEvent.gd` | 跨地图传送，指定目标地图 + 坐标 + 朝向 |
| 楼层传送 | `TeleportTowerEvent.gd` | 塔内上下楼层，自动匹配对应出口 |
| 道具 | `ItemEvent.gd` | 获取物品或装备 |
| 消耗品 | `ConsumableEvent.gd` | 拾取后加属性 (HP/ATK/DEF/MDEF/GOLD/ALL/CUSTOM) |
| 障碍物 | `BarrierEvent.gd` | 门/锁 — 检查并消耗钥匙 |
| 区域障碍 | `RegionBarrierEvent.gd` | 区域清怪后开启 |
| 陷阱 | `TrapEvent.gd` | 伤害陷阱 (血网等) |
| 条件 | `ConditionEvent.gd` | 表达式条件判断，满足则翻页 |
| 空事件 | `EmptyEvent.gd` | 占位用空事件 |
| 怪物检查 | `MonsterCheckEvent.gd` | 检查地图残余敌人 |
| 综合事件 | `CombinedEvent.gd` | **可视化编辑器事件** — 支持 Blockly 编辑 |
| 游戏结束 | `SpecialEvent/GameOverEvent.gd` | 死亡处理 |
| 商店 | `SpecialEvent/ShopEvent.gd` | 属性商店 (ATK/DEF/HP升级) |

#### 6.3 触发模式

| 模式 | 说明 |
|------|------|
| `Touch` | 接触触发 (玩家碰到事件) |
| `Autorun` | 自动触发 (进入页面后自动执行) |
| `Parallel` | 并行处理 |
| `Event_Async` | 异步自动触发 |

#### 6.4 页面完成处理 (OnPageFinished)

| 处理方式 | 说明 |
|----------|------|
| `Next` | 翻到下一页 |
| `Hold` | 保持当前页 |
| `Dead` | 结束事件 (销毁) |
| `Customize` | 自定义跳转至 `customizeNextPage` |

#### 6.5 事件执行机制

- 基于 **AsyncQueue** 异步队列
- 支持 `await` 阻塞等待
- 多事件可并行运行
- `GameEventManager.push()` / `run()` / `pushRun()` 控制事件入队与执行

**公共事件**：`Scene/CommonEvent/CommonEvent.tscn`，执行时复制到当前地图。

---

### 7. UI系统 (UI Management)

**核心文件**：
| 文件 | 类名 | 说明 |
|------|------|------|
| `Script/UI/UIManager.gd` | `UIManager` | UI 管理器核心 |
| `Script/UI/UIForm/UIForm.gd` | `UIForm` *(extends Control)* | UI 窗体基类 |

#### 7.1 UI 层级

| Layer | Z-Index | 用途 |
|-------|---------|------|
| GameFormLayer | 1 | 游戏 UI 下层 |
| GameFormLayerTop | 2 | 游戏 UI 上层 |
| GameViewport | 3 | 跟随视口 |
| Game | 4 | 游戏特效层 |
| Main | 5 | 主菜单层 |
| PopUp | 6 | 弹窗层 |

#### 7.2 UI 打开方式

```gdscript
MotaSystem.uiManager.open(UIID, param)                # 打开 UI
await MotaSystem.uiManager.openTillClose(UIID, param)  # 打开并等待关闭
var result = await MotaSystem.uiManager.openTillReturn(UIID, param) # 打开并获取返回值
```

#### 7.3 UI 窗体列表 (22个)

| 窗体 | 脚本 | 说明 |
|------|------|------|
| 游戏界面 (PC) | `GameForm.gd` | 横屏主游戏 UI |
| 游戏界面 (移动) | `MobileGameForm.gd` | 竖屏主游戏 UI |
| 主菜单 | `MainForm.gd` | 标题画面 |
| 章节选择 | `ChapterChoiceForm.gd` | 章节列表 |
| 存档 | `SaveForm.gd` | 存/读档界面 |
| 设置 | `SettingForm.gd` | 游戏设置 |
| 按键设置 | `KeySettingForm.gd` | 自定义键位 |
| 系统菜单 | `SystemForm.gd` | 暂停菜单 |
| 怪物图鉴 | `EnemyInfoForm.gd` | 敌人列表 |
| 怪物详情 | `EnemyDetailInfoForm.gd` | 敌人属性详情 |
| 怪物地图标记 | `EnemyStateFormMap.gd` | 地图上的敌人状态 |
| 传送 | `TeleportForm.gd` | 楼层传送选择 |
| 道具/装备 | `ItemEquipForm.gd` | 物品和装备管理 |
| 文本 | `TextForm.gd` | 文本对话框 |
| 吹出文本 | `FukiTextForm.gd` | 角色头顶气泡对话 |
| 图标文本 | `IconTextForm.gd` | 带图标的文本提示 |
| 全身像 | `FullBodyForm.gd` | 立绘显示 |
| 选择 | `ChoiceForm.gd` | 选项列表 |
| 弹窗 | `PopUpForm.gd` | 通用弹窗 |
| 提示 | `HintForm.gd` | 右上角提示 |
| 预加载 | `PreloadForm.gd` | 加载画面 |

#### 7.4 UI 模块组件 (19个)

可复用的 UI 子组件，用于嵌入各窗体中：

`ChoiceCard` / `CommonSelectBoard` / `CommonSelectButton` / `CommonSelectCheckButton` / `CommonSelectOptionButton` / `EnemyBoardPerfab` / `EnemyHandBookForm` / `EquipPerfab` / `EquipPoolPerfab` / `FloorButton` / `HighRiskTarget` / `ItemPerfab` / `KeySetPerfab` / `MenuButtonPerfab` / `MobileEquipPerfab` / `PcShowEquipPerfab` / `SaveBoard` / `ShowFlyPoint` / `ShowRangePoint` / `SkillContainerPefab` / `StateIconPerfab` / `StateInfoForm` / `TowerButton`

---

### 8. 特效与音频系统 (Effect & Audio)

#### 特效系统

| 文件 | 类名 | 说明 |
|------|------|------|
| `Script/Effect/EffectManager.gd` | `EffectManager` *(extends RefCounted)* | 特效管理器 |
| `Script/Effect/EffectBase.gd` | `EffectBase` | 特效基类 |
| `Script/Effect/AnimationEffect.gd` | `AnimationEffect` | 动画特效 |
| `Script/Effect/AutoPickTweenEffect.gd` | `AutoPickTweenEffect` | 自动拾取动画 |
| `Script/Effect/SelfDamageTextEffect.gd` | `SelfDamageTextEffect` | 伤害数字效果 |
| `Script/Effect/RegionBarrierRect.gd` | `RegionBarrierRect` | 区域障碍视觉效果 |

**核心方法**：
```gdscript
EffectManager.showEffect(effectID, position)         # 在指定位置播放全局特效
EffectManager.showEffectOnNode(effectID, node)        # 跟随节点播放特效
EffectManager.showEffectDistanceOnNode(...)            # 距离相关特效
EffectManager.clearEffect()                            # 清除特效
```

**特效场景** (`Scene/Effect/`)：31 个特效预制体，包括：
- 攻击类：`Attack-Fist.tscn`、`Attack-Sword.tscn`
- 爆炸类：`Explosion.tscn`
- 传送类：`Transfer.tscn`
- 技能类：`SkillBloodMagicLocus.tscn`、`Summonskill.tscn`
- 陷阱类：`Firetrap.tscn`、`IceGenerate.tscn`
- UI 效果：`Mouseclick.tscn`、`AutoPick.tscn`
- 以及对应的 Out-* 反向特效

#### 音频系统

| 文件 | 类名 | 说明 |
|------|------|------|
| `Script/Audio/AudioManager.gd` | `AudioManager` *(extends Node)* | 音频管理器 (单例) |

**核心方法**：
```gdscript
AudioManager.get_instance().playBGM(bgmName)   # 播放背景音乐
AudioManager.get_instance().stopBGM()           # 停止背景音乐
AudioManager.get_instance().playBGS(seName)     # 播放音效
```

**音频资源**：`Resources/Audio/SE/` — 音效文件

---

## 四、支撑模块

### 存档系统 (Save)

**文件**: `Script/Save/SaveManager.gd` — `class_name SaveManager`

| 特性 | 说明 |
|------|------|
| 存档槽位 | 最多 50 个手动存档 |
| 自动存档 | `AutoSave()` / `ClearAutoSave()` |
| 数据持久化 | 基于文件系统存储 |
| 章节存档 | 支持章节初始存档加载 |

**核心方法**：
```gdscript
SaveManager.Save(index)       # 保存到指定槽位
SaveManager.Load(index)       # 从指定槽位加载
SaveManager.AutoSave()        # 自动保存
```

---

### 资源管理 (Resource)

**文件**: `Script/Resource/ResourceManager.gd` — `class_name ResourceManager`

| 特性 | 说明 |
|------|------|
| 资源缓存 | `cachedResources` 字典缓存已加载资源 |
| 预加载 | `preloadFile()` 异步预加载 |
| 线程支持 | 支持后台线程加载 |
| 进度信号 | `load_progress` 信号通知加载进度 |

**核心方法**：
```gdscript
ResourceManager.loadFile(path)        # 加载并缓存
ResourceManager.preloadFile(path)     # 预加载
ResourceManager.internalGetCache(key) # 获取缓存
```

---

### 配置系统 (Config)

| 文件 | 类名 | 说明 |
|------|------|------|
| `Script/Config/Config.gd` | `Config` | 配置读写管理器 |
| `Script/Config/DefaultConfigFile.gd` | `DefaultConfigFile` *(extends ConfigFile)* | 默认配置值 |
| `Script/Config/KeysSettingConfig.gd` | `KeysSettingConfig` | 自定义按键配置 |

**DefaultConfigFile 默认配置项**：
- 音频（BGM/SE 音量）
- 语言选择
- 分辨率
- 游戏玩法选项
- 章节解锁状态

**Config 核心方法**：
```gdscript
Config.getValue(section, key)    # 读取配置
Config.setValue(section, key, v)  # 写入配置
```

---

### 常量与初始数据 (Defination)

| 文件 | 类名 | 说明 |
|------|------|------|
| `Script/Defination/Defination.gd` | `Defination` *(extends Node)* | 全局常量与枚举定义 |
| `Script/Defination/GameFirstData.gd` | `GameFirstData` *(extends Node)* | 游戏初始数据 |

**Defination.gd 核心常量**：
- `tilesize` — 网格大小 (64)
- `Equip_Type` — 装备槽位类型枚举
- `Item_Type` — 物品类型枚举
- `State_Type` — 状态类型枚举
- `Skill_Type` — 技能类型枚举
- `KeySetting_Name` — 可配置按键名称
- `Key_Mappings` — 键位映射
- `UIID` — UI 枚举
- `launcher_*` — 平台配置

**GameFirstData.gd 初始数据**：
- `gameIdentifier` — 魔塔唯一标识符
- `title` / `gameVersion` — 游戏名称/版本
- `playerId` / `startLv` — 初始角色
- `hp` / `atk` / `def` / `mdef` / `gold` / `expe` — 初始属性
- `startMapId` / `startPosition` — 出生地图与坐标
- `equipName` / `startEquip` — 初始装备
- `startFollower` / `partnerId` — 初始跟随者

**数据结构** (`Script/Defination/DataStructure/`)：
- `AsyncQueue.gd` — 异步队列 (事件系统核心数据结构)
- `Stack.gd` — 栈

---

### 数据表系统 (Datatable)

**工作流程**：
```
Datatable/DatatableExcel/*.xlsx   (Excel 原始数据)
        ↓  编辑器菜单 → 项目 → 工具 → ExcelExport
Datatable/Dist/*.gd               (自动生成 GDScript)
        ↓
DatatableManager.XXX.data[ID]     (代码访问)
```

**管理器**: `Datatable/DatatableManager.gd` — `class_name DatatableManager` *(extends Node)*

**配置表清单** (12 张)：

| Excel 文件 | 静态实例 | 功能 |
|-----------|---------|------|
| `Effect.xlsx` | `DatatableManager.Effect` | 特效配置 |
| `Enemy.xlsx` | `DatatableManager.Enemy` | 敌人数据 |
| `Equip.xlsx` | `DatatableManager.Equip` | 装备数据 |
| `Item.xlsx` | `DatatableManager.Item` | 道具数据 |
| `Level.xlsx` | `DatatableManager.Level` | 等级经验表 |
| `Map.xlsx` | `DatatableManager.Map` | 地图配置 |
| `Player.xlsx` | `DatatableManager.Player` | 角色数据 |
| `Procedure.xlsx` | `DatatableManager.Procedure` | 流程配置 |
| `Skill.xlsx` | `DatatableManager.Skill` | 技能数据 |
| `State.xlsx` | `DatatableManager.State` | 状态/Buff 数据 |
| `TempPerfab.xlsx` | `DatatableManager.TempPerfab` | 临时预制体 |
| `UI.xlsx` | `DatatableManager.UI` | UI 界面配置 |

**导出目录**：`Datatable/Dist/` — 包含各表同名子目录

**访问方式**：
```gdscript
DatatableManager.Player.data[playerID]
DatatableManager.Enemy.data[enemyID]
DatatableManager.Map.data[mapID]
```

---

### 工具类 (Utility)

**文件**: `Script/Utility/Utility.gd` — `class_name Utility`

静态工具函数集合：
- `worldPos2TilePos()` — 世界坐标 → 网格坐标
- `tilePos2WorldPos()` — 网格坐标 → 世界坐标
- `parseString2Vector2i()` — 字符串解析为 Vector2i
- `getGameBaseVieportWidthHeight()` — 获取基准视口尺寸
- `parseDirection()` — 方向解析
- `calMovingArr()` — 计算移动路径数组
- `calJump()` — 跳跃计算
- `string_to_expression()` — 字符串转表达式 (ConditionEvent 使用)

---

## 五、编辑器插件 (Addons)

### 1. MOTA 插件 (`addons/mota/`)

| 属性 | 值 |
|------|---|
| 名称 | mota |
| 版本 | 0.6.0 |
| 作者 | zhaouv |
| 说明 | 魔塔事件可视化编辑器 |

**功能**：
- 编辑器右侧添加 **MT dock** 面板
- 基于 **Blockly** 的 WebView 可视化事件编辑器
- 支持自定义属性解析 (`meta_addon_mt_parse_property`)
- 内嵌 HTTP 服务 (`godottpd/`，端口 24862) 与 WebView 通信
- 事件页面分页/文本编辑支持

**子目录**：
- `godottpd/` — HTTP 服务器框架 (server/router/request/response)
- `webview/` — Blockly 编辑器前端 (含 ANTLR 语法定义)

---

### 2. 国际化插件 (`addons/i18nForMota/`)

| 属性 | 值 |
|------|---|
| 名称 | i18nForMota |
| 版本 | 0.1.0 |
| 作者 | zhaouv |
| 说明 | MOTA 专用 i18n 工具 |

**功能**：
- 编辑器 dock 面板，提供一键按钮
- 生成翻译文件数组 (`translations_pot_files.cmd`)
- 提取事件和表格中的文本 (`extract.cmd`)
- 支持 Python 脚本进行文本提取 (`extractEvent.py`, `extractTable.py`, `filterPot.py`)

---

### 3. 自动平铺插件 (`addons/AutotileCreate/`)

| 属性 | 值 |
|------|---|
| 名称 | AutotileCreate |
| 版本 | 1.0.0 |
| 作者 | hambalong |
| 说明 | 自动配置地形图块 |

**功能**：
- 批量为 TileSet 中的图块配置地形集
- 支持 47 种地形模式 (标准 3×3 bitmask)
- 基于 12×4 网格布局自动绑定

---

### 4. Excel 导表插件 (`addons/GDExcelExporter/`)

| 属性 | 值 |
|------|---|
| 名称 | GDExcelExporter |
| 版本 | 2.0 |
| 作者 | kaluluosi |
| 说明 | Excel → GDScript 数据表导出 |

**功能**：
- 编辑器菜单 → 项目 → 工具 → **ExcelExport**
- 读取 `Datatable/DatatableExcel/*.xlsx`
- 自动生成 `Datatable/Dist/*.gd`
- 使用外部 `ee.exe` 执行导出

**配置**：
```ini
[GDExcelExporter]
SettingsDir = "res://Datatable"
cmd_path = "res://addons/GDExcelExporter/ee.exe"
```

---

### 5. GIF 支持 (`addons/godotgif/`)

| 属性 | 值 |
|------|---|
| 类型 | GDExtension |
| 说明 | Godot 4+ GIF 文件支持 |

**功能**：
- 导入 GIF 为 AnimatedTexture 或 SpriteFrames
- 运行时通过 `GifManager` 单例加载
- 方法：`animated_texture_from_file()`、`spriteframes_from_file()`

---

## 六、资源目录 (Resources)

```
Resources/
├── Animation/       # 动画图片资源 (特效序列帧)
├── Audio/
│   └── SE/          # 音效文件
├── Character/       # 角色行走图 (4×4 网格)
├── Font/            # 字体文件
├── Global/          # 全局资源
├── Icon/            # 图标资源
├── Picture/         # 图片资源 (立绘/背景等)
├── Screen/          # 屏幕相关资源
├── Tilesets/        # 图块集 (地图素材)
└── UI/              # UI 界面资源
```

---

## 七、场景目录 (Scene)

```
Scene/
├── CommonEvent/
│   └── CommonEvent.tscn           # 公共事件容器
├── Effect/                         # 31 个特效预制体
│   ├── Attack-Fist.tscn
│   ├── Attack-Sword.tscn
│   ├── Explosion.tscn
│   ├── Transfer.tscn
│   ├── SelfDamageTextEffect.tscn
│   ├── RegionBarrierRect.tscn
│   └── ... (含 Out-* 反向特效)
├── Map/
│   ├── EmptyMap.tscn              # 空白地图模板
│   └── Template/                  # 示例地图 (0_0, 0_1, 0_2, 0_3, 1_0 等)
├── Prefab/
│   ├── Canvas.tscn                # 画布
│   ├── Character.tscn             # 角色预制
│   ├── Map.tscn                   # 地图预制
│   ├── Player.tscn                # 玩家预制
│   ├── PlayerNode.tscn            # 玩家节点
│   ├── ThumbnailPlayer.tscn       # 缩略图玩家
│   ├── MapEventPrefab/
│   │   └── CombinedEventPerfab.tscn  # 综合事件预制
│   ├── TempEventPrefab/
│   │   └── TempFireTrapPrefab.tscn   # 临时火焰陷阱
│   └── ValueLabelPrefab/           # 浮动数值标签
│       ├── CheckItemValue.tscn     # 钥匙检查数值
│       ├── ConsumbleValue.tscn     # 消耗品数值
│       ├── ItemValue.tscn          # 道具数值
│       ├── MonsterDamValue.tscn    # 怪物伤害数值
│       └── TrapValue.tscn          # 陷阱伤害数值
├── Procedure/
│   ├── Preload.tscn               # 预加载场景 (入口)
│   ├── MainMenu.tscn              # 主菜单场景
│   └── MainGame.tscn              # 主游戏场景
└── UI/
    ├── UIForm/                    # 22 个 UI 窗体场景
    └── UIModule/                  # 19 个 UI 模块场景
```

---

## 八、国际化 (Locale)

**目录**: `locale/`

| 文件 | 说明 |
|------|------|
| `message.pot` | 翻译模板 (POT) |
| `zh.po` / `zh.mo` | 中文翻译 |
| `en.po` / `en.mo` | 英文翻译 |

**支持语言**：
- 0 = 中文 (`zh`)
- 1 = 英文 (`en`)
- 2 = 日语 (`jp`)

**切换方式**：通过 `Config` 中的 `Language.language` 配置项，在 `MotaSystem.setLanguage()` 中调用 `TranslationServer.set_locale()`。

---

## 九、原生扩展 (bin)

**目录**: `bin/`

| 文件 | 说明 |
|------|------|
| `mtrust.gdextension` | GDExtension 定义文件 |
| `debug/` | 调试构建二进制 |

用途：原生代码扩展，可能用于信任验证/性能关键逻辑。

---

## 十、完整文件结构速查

```
GodotStandardMotaTemplate/
│
├── Script/                           # 脚本代码
│   ├── MotaSystem.gd                 # 全局入口 (静态单例)
│   │
│   ├── Procedure/                    # 流程管理
│   │   ├── ProcedureManager.gd       #   流程调度器
│   │   ├── ProcedurePreload.gd       #   预加载
│   │   ├── ProcedureMainMenu.gd      #   主菜单
│   │   └── ProcedureMainGame.gd      #   主游戏
│   │
│   ├── Game/                         # 游戏核心
│   │   ├── GameManager.gd            #   游戏管理器
│   │   ├── GameData.gd               #   玩家数据
│   │   ├── GameVariables.gd          #   全局变量
│   │   ├── MapManager.gd             #   地图管理
│   │   ├── GameMap.gd                #   地图实例
│   │   ├── GameEventManager.gd       #   事件调度
│   │   ├── GameEvent.gd              #   事件实体
│   │   ├── GamePlayerManager.gd      #   角色管理
│   │   ├── GamePlayer.gd             #   玩家角色
│   │   ├── GameCharacter.gd          #   角色基类
│   │   ├── FrameAnimation.gd         #   帧动画
│   │   ├── InputManager.gd           #   输入管理
│   │   ├── FindMovePath.gd           #   A* 寻路
│   │   ├── PlayerCamera.gd           #   相机控制
│   │   ├── ThumbnailManager.gd       #   缩略图
│   │   │
│   │   ├── Battle/                   #   战斗系统
│   │   │   ├── GameBattle.gd         #     战斗引擎
│   │   │   ├── GameFighter.gd        #     战斗单位
│   │   │   ├── EnemyData.gd          #     敌人数据
│   │   │   ├── EnemyReady.gd         #     敌人预处理
│   │   │   └── AreaManager.gd        #     光环管理
│   │   │
│   │   └── Event/                    #   事件类型
│   │       ├── EventPage.gd          #     事件页基类
│   │       ├── CombinedEvent.gd      #     综合事件 (可视化)
│   │       ├── MonsterEvent.gd       #     怪物
│   │       ├── TeleportEvent.gd      #     传送
│   │       ├── TeleportTowerEvent.gd #     楼层传送
│   │       ├── ItemEvent.gd          #     道具
│   │       ├── ConsumableEvent.gd    #     消耗品
│   │       ├── BarrierEvent.gd       #     障碍物 (门)
│   │       ├── RegionBarrierEvent.gd #     区域障碍
│   │       ├── ConditionEvent.gd     #     条件判断
│   │       ├── TrapEvent.gd          #     陷阱
│   │       ├── EmptyEvent.gd         #     空事件
│   │       ├── MonsterCheckEvent.gd  #     怪物检查
│   │       └── SpecialEvent/         #     特殊事件
│   │           ├── GameOverEvent.gd  #       游戏结束
│   │           └── ShopEvent.gd      #       商店
│   │
│   ├── UI/                           # UI 系统
│   │   ├── UIManager.gd             #   UI 管理器
│   │   ├── UIForm/                   #   窗体脚本 (22个)
│   │   │   ├── UIForm.gd            #     窗体基类
│   │   │   ├── GameForm.gd          #     游戏界面
│   │   │   ├── MainForm.gd          #     主菜单
│   │   │   ├── SaveForm.gd          #     存档
│   │   │   └── ...
│   │   └── UIModule/                 #   模块组件 (19个)
│   │       ├── EnemyBoardPerfab.gd
│   │       ├── SaveBoard.gd
│   │       └── ...
│   │
│   ├── Effect/                       # 特效系统
│   │   ├── EffectManager.gd
│   │   ├── EffectBase.gd
│   │   ├── AnimationEffect.gd
│   │   └── ...
│   │
│   ├── Audio/                        # 音频系统
│   │   └── AudioManager.gd
│   │
│   ├── Save/                         # 存档系统
│   │   └── SaveManager.gd
│   │
│   ├── Resource/                     # 资源管理
│   │   └── ResourceManager.gd
│   │
│   ├── Config/                       # 配置系统
│   │   ├── Config.gd
│   │   ├── DefaultConfigFile.gd
│   │   └── KeysSettingConfig.gd
│   │
│   ├── Defination/                   # 常量定义
│   │   ├── Defination.gd
│   │   ├── GameFirstData.gd
│   │   └── DataStructure/
│   │       ├── AsyncQueue.gd
│   │       └── Stack.gd
│   │
│   └── Utility/                      # 工具类
│       └── Utility.gd
│
├── Scene/                            # 场景文件
│   ├── Procedure/                    #   流程场景 (3个)
│   ├── Map/                          #   地图场景
│   ├── UI/                           #   UI 场景 (41个)
│   ├── Effect/                       #   特效场景 (31个)
│   ├── Prefab/                       #   预制体
│   └── CommonEvent/                  #   公共事件
│
├── Datatable/                        # 数据表系统
│   ├── DatatableManager.gd           #   数据表管理器
│   ├── DatatableExcel/               #   Excel 源文件 (12张)
│   ├── Dist/                         #   生成脚本
│   └── sample/                       #   示例模板
│
├── Resources/                        # 游戏资源
│   ├── Animation/                    #   动画图片
│   ├── Audio/SE/                     #   音效
│   ├── Character/                    #   行走图
│   ├── Font/                         #   字体
│   ├── Tilesets/                     #   图块集
│   └── UI/                           #   UI 资源
│
├── locale/                           # 国际化
│   ├── message.pot
│   ├── zh.po / zh.mo
│   └── en.po / en.mo
│
├── addons/                           # 编辑器插件 (5个)
│   ├── mota/                         #   事件编辑器
│   ├── i18nForMota/                  #   国际化工具
│   ├── AutotileCreate/               #   自动地形
│   ├── GDExcelExporter/              #   Excel 导表
│   └── godotgif/                     #   GIF 支持
│
├── bin/                              # 原生扩展
│
└── project.godot                     # 项目配置
```

---

## 十一、游戏启动流程

```
游戏启动
  │
  ▼
ProcedurePreload (Scene/Procedure/Preload.tscn)
  │  ├── MotaSystem.p_ready() — 初始化全局管理器
  │  ├── DatatableManager.p_ready() — 加载数据表
  │  ├── Defination.p_ready() — 初始化常量
  │  ├── AudioManager.p_ready() — 初始化音频
  │  ├── Splash 画面显示
  │  └── 资源预加载
  │
  ▼
ProcedureMainMenu (Scene/Procedure/MainMenu.tscn)
  │  ├── 初始化 UIManager
  │  ├── 打开 MainForm (主菜单 UI)
  │  └── 等待玩家操作
  │
  ▼  (玩家点击开始 / 读档)
ProcedureMainGame (Scene/Procedure/MainGame.tscn)
  │  ├── 创建 EffectManager
  │  ├── 创建 UIManager
  │  └── 创建 GameManager
  │       ├── GameData — 初始化玩家数据
  │       ├── GamePlayerManager — 创建玩家角色
  │       ├── MapManager — 加载初始地图
  │       ├── InputManager — 启动输入处理
  │       ├── GameEventManager — 事件队列就绪
  │       └── GameForm / HintForm — 游戏 UI
  │
  ▼
正式游戏循环
  ├── InputManager._process() — 处理输入
  ├── GamePlayer._process() — 角色移动
  ├── GameEventManager — 事件触发与执行
  └── MapManager — 地图切换
```

---

## 十二、设计模式与架构特征

### 采用的设计模式

| 模式 | 应用 |
|------|------|
| **静态单例** | `MotaSystem` — 全局唯一访问入口 |
| **管理器模式** | 每个子系统由独立 Manager 管理 (UI / Map / Event / Save / Resource / Effect) |
| **状态机** | `ProcedureManager` — Preload → MainMenu → MainGame |
| **事件页状态机** | `GameEvent` — 多页状态切换 (Next / Hold / Dead / Customize) |
| **命令模式** | `CombinedEvent` — 将事件动作序列化为 JSON 命令列表 |
| **异步队列** | `AsyncQueue` — 事件按序执行，支持 await |
| **数据驱动** | 所有配置通过 Excel → GDScript 自动生成 |
| **继承层级** | `Sprite2D → FrameAnimation → EventPage → 具体事件` |
| **观察者** | 信号机制 (ResourceManager.load_progress 等) |

### 关键架构特征

1. **强模块化**：8 大核心系统各自独立，通过 MotaSystem 统一协调
2. **数据与逻辑分离**：游戏数据全部由 Datatable 管理，运行时通过 ID 查询
3. **编辑器深度集成**：4 个自定义编辑器插件提升开发效率
4. **事件驱动游戏逻辑**：所有游戏交互通过事件系统实现
5. **跨平台适配**：自动检测横竖屏，PC 与移动端使用不同 UI 布局
6. **网格基础**：所有移动和定位基于 64px 网格系统
