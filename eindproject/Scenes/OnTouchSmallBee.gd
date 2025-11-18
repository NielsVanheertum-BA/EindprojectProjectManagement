extends Area2D

@onready  var timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	GlobalVariables.playerHealth -= 25
	print("-10 health")
	print(GlobalVariables.playerHealth)
	if GlobalVariables.playerHealth == 0:
		Engine.time_scale = 0.5
		timer.start()
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
