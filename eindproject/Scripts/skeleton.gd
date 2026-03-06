extends CharacterBody2D

var SPEED = randf_range(100.0, 200.0)
@onready var player: CharacterBody2D = $"../Player"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var skeleton_range: Area2D = $Range
@onready var collision_shape: CollisionShape2D = $Hitbox


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	var player_detected = false
	var areas = skeleton_range.get_overlapping_areas()
	for body in areas:
		if body != self and body.has_method("detect"):
			player_detected = true
			break

	if player_detected:
		# Chase player
		animated_sprite.play("run")
		if position.x > player.global_position.x:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true

		var direction = position.direction_to(player.global_position).normalized()
		velocity.x = direction.x * SPEED
	else:
		# Idle: stop horizontal movement
		velocity.x = 0
		animated_sprite.play("idle")
	
	# Move and slide with floor detection
	move_and_slide()
