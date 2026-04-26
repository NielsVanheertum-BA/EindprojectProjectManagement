extends Area2D

const BASE_HEALTH := 200

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var orc: CharacterBody2D = $".."

var health := BASE_HEALTH


func take_damage() -> void:
	orc.orcHurt = true
	health -= GlobalVariables.sword_damage
	animated_sprite.play("hurt")
	await animated_sprite.animation_finished

	if health <= 0:
		GlobalVariables.enemiesLeft -= 1
		GlobalVariables.kill += 1
		get_parent().queue_free()
		return

	orc.orcHurt = false
