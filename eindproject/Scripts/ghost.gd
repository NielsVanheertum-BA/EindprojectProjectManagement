extends CharacterBody2D

var SPEED = randf_range(70.0, 140.0)
var health = 1
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $Hitbox
@onready var ghost_range: Area2D = $Range
@onready var player: CharacterBody2D = $"../Player"
@onready var hurtbox: Area2D = $Hurtbox

# Beweeging bij

func _process(delta):
	var player_detected = false
	var areas = ghost_range.get_overlapping_areas()
	for body in areas:
		if body != self and body.has_method("detect"):
			player_detected = true
			break
	if player_detected:
		# Chase player
		animated_sprite.play("fly")
		if position.x > player.global_position.x:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true

		var direction = position.direction_to(player.global_position)
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = 0
		animated_sprite.play("idle")
	
	# Move and slide with floor detection
	move_and_slide()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	var areas = hurtbox.get_overlapping_areas()
	for area in areas:
		if area != self and area.has_method("detect"):
			GlobalVariables.playerPreviousHealth = GlobalVariables.playerCurrentHealth
			GlobalVariables.playerCurrentHealth -= 25
			print(GlobalVariables.playerCurrentHealth)
