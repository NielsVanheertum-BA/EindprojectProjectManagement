extends Area2D

const BASE_HEALTH := 21

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

var health := BASE_HEALTH


func take_damage() -> void:
	GlobalVariables.ghostIsHurt = true
	health -= GlobalVariables.sword_damage

	animated_sprite.play("damage")
	await animated_sprite.animation_finished

	if health <= 0:
		spawn_hit_effect(animated_sprite.global_position)
		get_parent().queue_free()
		GlobalVariables.enemiesLeft -= 1
		GlobalVariables.kill += 1

	GlobalVariables.ghostIsHurt = false


func spawn_hit_effect(pos: Vector2) -> void:
	var effect := Sprite2D.new()
	effect.texture = animated_sprite.sprite_frames.get_frame_texture("hurt", 0)
	effect.global_position = pos
	effect.modulate = Color(1, 0, 0, 0.7)
	get_tree().current_scene.add_child(effect)
	var tween := effect.create_tween()
	tween.set_parallel(true)
	tween.tween_property(effect, "modulate:a", 0.0, 0.3)
	tween.tween_property(effect, "scale", Vector2(1.5, 1.5), 0.3)
	tween.chain().tween_callback(effect.queue_free)
