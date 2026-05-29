class_name ProcedureManager

#代码部分来自官方文档

var current_scene = null

var m_tree = null

func _init(tree):
	m_tree = tree
	var root = m_tree.root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_procedure(procedureID:int, param = null):
	var path = DatatableManager.Procedure.data[procedureID]["path"]
	# 如果新的procedure和老的不是同一个则清除bgm等procedure外的东西
	if current_scene.name != DatatableManager.Procedure.data[procedureID]["name"]:
		AudioManager.stopBGM.call_deferred()
	
	goto_scene(path, param)

func goto_scene(path, param = null):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	
	call_deferred("_deferred_goto_scene", path, param)


func _deferred_goto_scene(path, param):
	# It is now safe to remove the current scene
	var ss = 0
	while ss < Utility.cache().size():
		Utility.cache()[ss].free()
		Utility.cache().remove_at(ss)
		
	current_scene.free()
	
	MotaSystem.clear()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()
	
	if current_scene.has_method("initialize"):
		current_scene.ready.connect(func():
			current_scene.initialize(param)
		)

	# Add it to the active scene, as child of root.
	m_tree.root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	m_tree.current_scene = current_scene
