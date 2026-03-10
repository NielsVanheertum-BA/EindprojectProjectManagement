extends Control

func _on_restart_pressed() -> void:
	GlobalVariables.playerAlive = true
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	GlobalVariables.playerAlive = true
	Engine.time_scale = 1
	var tree := get_tree()
	tree.call_deferred("change_scene_to_file", "res://Scenes/MainMenu.tscn")
