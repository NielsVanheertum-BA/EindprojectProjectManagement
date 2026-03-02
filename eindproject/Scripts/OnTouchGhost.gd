extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var health = 20
func _on_body_entered(body: Node2D) -> void:
	GlobalVariables.playerPreviousHealth = GlobalVariables.playerCurrentHealth
	GlobalVariables.playerCurrentHealth -= 25
	print(GlobalVariables.playerCurrentHealth)


func take_damage():
	print("AUUUUUUUU")
	health = health - GlobalVariables.sword_damage
	if health > 0:
		animated_sprite.play("damage")
		await animated_sprite.animation_finished
		spawn_hit_effect(animated_sprite.get_global_transform().origin)
		animated_sprite.play("Fly")
	else:
		get_parent().queue_free()
		GlobalVariables.enemiesLeft -= 1

func spawn_hit_effect(position: Vector2):
	var effect = Sprite2D.new()
	effect.texture = animated_sprite.sprite_frames.get_frame_texture("damage", 0) 
	effect.global_position = position
	effect.modulate = Color(1, 0, 0, 0.7) 
	effect.scale = Vector2(1, 1)
	get_tree().current_scene.add_child(effect)
	
	# Fade out en verwijder
	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 0.2)
	tween.tween_property(effect, "scale", Vector2(1.5, 1.5), 0.3)
	tween.tween_callback(effect.queue_free)
	print("Hit effect werkt")
