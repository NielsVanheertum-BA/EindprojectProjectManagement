extends Control

@onready var game: Node2D = $".."

func _on_quit_pressed() -> void:
	GlobalVariables.playerMaxHealth = GlobalVariables.playerBaseMaxHealth
	GlobalVariables.ghostDamage = GlobalVariables.ghostBaseDamage
	GlobalVariables.skeletonDamage = GlobalVariables.skeletonBaseDamage
	GlobalVariables.sword_damage = GlobalVariables.sword_base_damage
	GlobalVariables.wave = 0
	GlobalVariables.enemiesLeft = 0
	GlobalVariables.kill = 0
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_resume_pressed() -> void:
	game.pauseMenu()
