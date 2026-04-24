extends CharacterBody2D

const DAMAGE_COOLDOWN = 1.0
var speed := randf_range(70.0, 140.0)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ghost_range: Area2D = $Range
@onready var player: CharacterBody2D = $"../Player"
@onready var hurtbox: Area2D = $Hurtbox
@onready var timer: Timer = $Timer

var player_inside := false


func _physics_process(_delta: float) -> void:
	if GlobalVariables.ghostIsHurt:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Detect player in range
	var player_detected := false
	for area in ghost_range.get_overlapping_areas():
		if area.has_method("detect"):
			player_detected = true
			break

	if player_detected:
		animated_sprite.play("fly")
		animated_sprite.flip_h = position.x < player.global_position.x
		var direction := position.direction_to(player.global_position)
		velocity = direction * speed
	else:
		velocity.x = 0
		animated_sprite.play("idle")

	move_and_slide()

	# Deal damage if player is in hurtbox and cooldown is ready
	if player_inside and timer.is_stopped():
		for area in hurtbox.get_overlapping_areas():
			if area.has_method("detect"):
				timer.start(DAMAGE_COOLDOWN)
				break


func _on_timer_timeout() -> void:
	GlobalVariables.playerCurrentHealth -= GlobalVariables.ghostDamage


func _on_hurtbox_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	player_inside = true


func _on_hurtbox_area_shape_exited(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	player_inside = false
	timer.stop()
