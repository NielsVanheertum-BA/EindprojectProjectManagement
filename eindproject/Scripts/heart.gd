extends Node2D

const HEAL_AMOUNT = 20

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D


func _ready() -> void:
	animated_sprite.play("idle")
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.has_method("detect"):
		GlobalVariables.playerCurrentHealth = min(
			GlobalVariables.playerCurrentHealth + HEAL_AMOUNT,
			GlobalVariables.playerMaxHealthd
		)
		GlobalVariables.playerPreviousHealth = GlobalVariables.playerCurrentHealth - 1
		queue_free()
