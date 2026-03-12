extends CharacterBody2D

var SPEED = randf_range(100.0, 200.0)
@onready var player: CharacterBody2D = $"../Player"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var skeleton_range: Area2D = $Range
@onready var collision_shape: CollisionShape2D = $Hitbox
@onready var timer: Timer = $Timer
@onready var attack_right: Area2D = $AttackRight
@onready var attack_left: Area2D = $AttackLeft

var is_attacking = false
var attackingSdie = ""

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_attacking and is_on_floor():
		return
	
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

func _on_attack_left_area_entered(area: Area2D) -> void:
	if is_attacking:
		return
	timer.start()
	attackingSdie = "left"

func _on_attack_right_area_entered(area: Area2D) -> void:
	if is_attacking:
		return
	timer.start()
	attackingSdie = "right"


func _on_timer_timeout() -> void:
	is_attacking = true
	velocity.x = 0
	var enemies = []
	if attackingSdie == "left":
		enemies = attack_left.get_overlapping_areas()
	elif attackingSdie == "right":
		enemies = attack_right.get_overlapping_areas()

	for body in enemies:
		if body != self and body.has_method("detect"):
			animated_sprite.play("attack")
			await get_tree().create_timer(0.2).timeout
			if attackingSdie == "left":
				enemies = attack_left.get_overlapping_areas()
			elif attackingSdie == "right":
				enemies = attack_right.get_overlapping_areas()
				for body2 in enemies:
					if body2 != self and body.has_method("detect"):
						GlobalVariables.playerCurrentHealth -= 10
				await  animated_sprite.animation_finished
			
	is_attacking = false
