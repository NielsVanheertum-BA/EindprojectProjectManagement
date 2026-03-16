extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var health = 50

func take_damage():
	GlobalVariables.skeletonIsHurt = true
	print("AUUUUUUUU")
	health -= GlobalVariables.sword_damage

	if health > 0:
		animated_sprite.play("hurt")
		await animated_sprite.animation_finished
	else:
		animated_sprite.play("hurt")
		spawn_hit_effect(animated_sprite.global_position)
		await animated_sprite.animation_finished
		get_parent().queue_free()
		GlobalVariables.enemiesLeft -= 1
		GlobalVariables.kill += 1
	GlobalVariables.skeletonIsHurt = false

func spawn_hit_effect(position: Vector2):
	var effect = Sprite2D.new()
	effect.texture = animated_sprite.sprite_frames.get_frame_texture("hurt", 0)
	effect.global_position = position
	effect.modulate = Color(1, 0, 0, 0.7)
	effect.scale = Vector2(1, 1)
	get_tree().current_scene.add_child(effect)

	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 0.2)
	tween.tween_property(effect, "scale", Vector2(1.5, 1.5), 0.3)
	tween.tween_callback(effect.queue_free)
	print("Hit effect werkt")
