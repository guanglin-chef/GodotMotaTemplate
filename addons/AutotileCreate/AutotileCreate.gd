@tool
extends EditorPlugin


var dock
static var format:Array = [11,12,15,8,-1,0,7,4,3]
static var form:Array = [[7],[5,7],[3,5,7],[3,7],[0,1,3,5,7],[3,5,7,8],[3,5,6,7],[1,2,3,5,7],[5,7,8],[1,3,5,6,7,8],[3,5,6,7,8],[3,6,7],[1,7],[1,5,7],[1,3,5,7],[1,3,7],[1,5,7,8],[1,2,3,5,6,7,8],[0,1,3,5,6,7,8],[1,3,6,7],[1,2,5,7,8],[1,2,3,5,6,7],[],[0,1,3,5,6,7],[1],[1,5],[1,3,5],[1,3],[1,2,5,7],[0,1,2,3,5,7,8],[0,1,2,3,5,6,7],[0,1,3,7],[1,2,3,5,7,8],[0,1,2,3,5,6,7,8],[0,1,3,5,7,8],[0,1,3,6,7],[],[5],[3,5],[3],[1,3,5,6,7],[1,2,3,5],[0,1,3,5],[1,3,5,7,8],[1,2,5],[0,1,2,3,5],[0,1,2,3,5,7],[0,1,3]]

func _enter_tree():
	# Initialization of the plugin goes here
	# Load the dock scene and instance it
	dock = preload("res://addons/AutotileCreate/AutotileCreate.tscn").instantiate()
	dock.name="自动原件一键绑定地形插件"
	
	dock.get_child(6).connect("pressed",func():
		var terrain = dock.get_child(4).value
		var tileset = ResourceLoader.load(dock.get_child(7).text.trim_suffix(".remap"))
		var tiledata
		for x in range(0,12):
			for y in range(0,4):
				if x == 10 && y == 1:
					continue
				tiledata = tileset.get_source(dock.get_child(0).value).get_tile_data(Vector2i(x, y), 0)
				
				tiledata.set_terrain_set(0)
				tiledata.terrain = terrain
				for g in form[(y * 12) + x]:
					tiledata.set_terrain_peering_bit(format[g], terrain))

	# Add the loaded scene to the docks
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock

func _exit_tree():
	# Clean-up of the plugin goes here
	# Remove the dock
	remove_control_from_docks(dock)
	 # Erase the control from the memory
	dock.free()
