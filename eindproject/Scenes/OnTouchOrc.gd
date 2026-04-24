extends Area2D

const BASE_HEALTH := 120

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

var health := BASE_HEALTH


func take_damage() -> void:
	GlobalVariables.orcIsHurt = true
	health -= GlobalVariables.sword_damage

	animated_sprite.play("hurt")
	await animated_sprite.animation_finished

	if health <= 0:
		get_parent().queue_free()
		GlobalVariables.enemiesLeft -= 1
		GlobalVariables.kill += 1

	GlobalVariables.orcIsHurt = false
