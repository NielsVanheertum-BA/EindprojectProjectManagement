extends CharacterBody2D

const DAMAGE_COOLDOWN = 0.5
var speed := randf_range(70.0, 140.0)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ghost_range: Area2D = $Range
@onready var player: CharacterBody2D = $"../Player"
@onready var hurtbox: Area2D = $Hurtbox
@onready var timer: Timer = $Timer

var player_in_range := false
var player_inside := false
var ghostHurt = false


func _ready() -> void:
	ghost_range.area_entered.connect(_on_range_area_entered)
	ghost_range.area_exited.connect(_on_range_area_exited)


func _physics_process(_delta: float) -> void:
	if ghostHurt:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if player_in_range:
		animated_sprite.play("fly")
		animated_sprite.flip_h = position.x < player.global_position.x
		velocity = position.direction_to(player.global_position) * speed
	else:
		velocity.x = 0
		animated_sprite.play("idle")

	move_and_slide()

	if player_inside and timer.is_stopped():
		timer.start(DAMAGE_COOLDOWN)


func _on_range_area_entered(area: Area2D) -> void:
	if area.has_method("detect"):
		player_in_range = true


func _on_range_area_exited(area: Area2D) -> void:
	if area.has_method("detect"):
		player_in_range = false


func _on_timer_timeout() -> void:
	if player_inside:
		GlobalVariables.playerCurrentHealth -= GlobalVariables.ghostDamage


func _on_hurtbox_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area and area.has_method("detect"):
		player_inside = true


func _on_hurtbox_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area and area.has_method("detect"):
		player_inside = false
		timer.stop()
