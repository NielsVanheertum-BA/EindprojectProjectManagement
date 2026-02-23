extends Node2D

const SPEED = 100
var health = 20

var direction = -1
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D


# Beweeging bij
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	position.x += direction * SPEED * delta

func take_damage():
	health = health - GlobalVariables.sword_damage
	if health > 0:
		animated_sprite.play("damage")
	else:
		spawn_hit_effect(collision_shape.global_position)
		queue_free()

func spawn_hit_effect(position: Vector2):
	var effect = Sprite2D.new()
	effect.texture = animated_sprite.sprite_frames.get_frame_texture("damage", 0) 
	effect.global_position = position
	effect.modulate = Color(1, 0, 0, 0.7) 
	effect.scale = Vector2(1, 1)
	get_parent().add_child(effect)
	
	# Fade out en verwijder
	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 0.3)
	tween.tween_property(effect, "scale", Vector2(1.5, 1.5), 0.3)
	tween.tween_callback(effect.queue_free)
	print("Hit effect werkt")
