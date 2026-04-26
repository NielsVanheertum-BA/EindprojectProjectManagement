extends Node2D

const HEAL = 20

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D


func _ready() -> void:
	animated_sprite.play("spin")
	area.area_entered.connect(_on_area_entered)


func _on_area_entered(body: Area2D) -> void:
	if not body.has_method("detect"):
		return
	if GlobalVariables.playerCurrentHealth >= GlobalVariables.playerMaxHealth:
		return

	GlobalVariables.playerCurrentHealth = min(
		GlobalVariables.playerCurrentHealth + HEAL,
		GlobalVariables.playerMaxHealth
	)
	GlobalVariables.playerPreviousHealth = GlobalVariables.playerCurrentHealth - 1
	queue_free()
