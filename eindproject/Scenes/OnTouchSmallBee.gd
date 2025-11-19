extends Area2D

func _on_body_entered(body: Node2D) -> void:
	GlobalVariables.playerCurrentHealth -= 25
	print(GlobalVariables.playerCurrentHealth)
