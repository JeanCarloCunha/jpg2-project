extends Node

var current_scene = null
func _ready() -> void:
	var root = get_tree().root
	# the -1 sets the current_scene to the first scene of the game
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func _deferred_switch_scene(res_path):
	current_scene.free()
	var scene = load(res_path)
	if scene == null or not (scene is PackedScene):
		push_error("Invalid or scene not found: " + str(res_path))
		return
	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
