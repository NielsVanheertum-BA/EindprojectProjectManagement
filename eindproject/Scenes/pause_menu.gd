extends Control

@onready var game: Node2D = $".."


		
func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_resume_pressed() -> void:
	game.pauseMenu()
