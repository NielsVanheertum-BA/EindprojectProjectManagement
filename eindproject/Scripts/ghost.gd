extends CharacterBody2D

var SPEED = randf_range(70.0, 140.0)
var health = 1
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $Hitbox
@onready var ghost_range: Area2D = $Range
@onready var player: CharacterBody2D = $"../Player"
@onready var hurtbox: Area2D = $Hurtbox
@onready var timer: Timer = $Timer
var playerInside = false

func _process(delta):
	#Player Detecting & movement
	var player_detected = false
	var areas = ghost_range.get_overlapping_areas()
	for body in areas:
		if body != self and body.has_method("detect"):
			player_detected = true
			break
			
	if player_detected:
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
	
	move_and_slide()
	if playerInside:
		if !timer.is_stopped():
			return
		else: 
			var areasHurt = hurtbox.get_overlapping_areas()
			for area in areasHurt:
				if area != self and area.has_method("detect"):
					timer.start()

func _on_timer_timeout() -> void:
	GlobalVariables.playerPreviousHealth = GlobalVariables.playerCurrentHealth
	GlobalVariables.playerCurrentHealth -= GlobalVariables.ghostDamage
	print(GlobalVariables.playerCurrentHealth)


func _on_hurtbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	playerInside = true

func _on_hurtbox_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	playerInside = false
	timer.stop()
