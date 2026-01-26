extends Control

@onready var pause_menu: Control = $"."


func _on_resume_pressed() -> void:
	pause_menu.hide()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
