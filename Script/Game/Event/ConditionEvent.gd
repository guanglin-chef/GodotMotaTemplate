class_name ConditionEvent extends EventPage
# 事件型条件分歧，在满足对应条件后会退出进入下一页
# 同时也是个特殊事件，start没有任何用
# 必须是process，因此会自动调整为process

## MT插件支持
func meta_addon_mt_plain():pass

## 判断的表达式
@export var text = "1+1==2"

#--------
# 条件
var condition:Callable

#--------
func onEnter():
	condition = Utility.string_to_expression(text)
	trigger = 3 # 必须是process

func start():
	# 主要逻辑
	if condition.call():
		pass
	else:
		return
	# 完成后处理
	super()
