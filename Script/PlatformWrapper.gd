extends Node
# 在塔内调平台功能
func restart():
	print("此处只是兼容层, 为了让独立造塔时不报错, 实际内容在平台的PlatformWrapper中")
	get_tree().quit()
