extends Area2D

@onready  var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You died")
	timer.start()
	
func _on_timer_timeout() -> void:
	var tree := get_tree()
	tree.call_deferred("change_scene_to_file", "res://Scenes/game.tscn")
