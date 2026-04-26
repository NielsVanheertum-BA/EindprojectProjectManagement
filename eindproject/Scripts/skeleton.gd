extends CharacterBody2D

const ATTACK_HIT_DELAY := 0.2
var speed := randf_range(100.0, 200.0)
var is_attacking := false
var attacking_side := ""

@onready var player: CharacterBody2D = $"../Player"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var skeleton_range: Area2D = $Range
@onready var timer: Timer = $Timer
@onready var attack_right: Area2D = $AttackRight
@onready var attack_left: Area2D = $AttackLeft

var player_in_range := false
var skeletonHurt = false


func _ready() -> void:
	skeleton_range.area_entered.connect(_on_range_area_entered)
	skeleton_range.area_exited.connect(_on_range_area_exited)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if skeletonHurt or (is_attacking and is_on_floor()):
		velocity.x = 0
		move_and_slide()
		return

	if player_in_range:
		animated_sprite.play("run")
		animated_sprite.flip_h = position.x < player.global_position.x
		velocity.x = position.direction_to(player.global_position).x * speed
	else:
		velocity.x = 0
		animated_sprite.play("idle")

	move_and_slide()


func _on_range_area_entered(area: Area2D) -> void:
	if area.has_method("detect"):
		player_in_range = true


func _on_range_area_exited(area: Area2D) -> void:
	if area.has_method("detect"):
		player_in_range = false


func _get_attack_area() -> Area2D:
	return attack_left if attacking_side == "left" else attack_right


func _on_attack_left_area_entered(_area: Area2D) -> void:
	if is_attacking:
		return
	attacking_side = "left"
	timer.start()


func _on_attack_right_area_entered(_area: Area2D) -> void:
	if is_attacking:
		return
	attacking_side = "right"
	timer.start()


func _on_timer_timeout() -> void:
	is_attacking = true
	velocity.x = 0

	var attack_area := _get_attack_area()
	if not attack_area.get_overlapping_areas().any(func(a): return a.has_method("detect")):
		is_attacking = false
		return

	animated_sprite.play("attack")
	await get_tree().create_timer(ATTACK_HIT_DELAY).timeout

	for body in attack_area.get_overlapping_areas():
		if body.has_method("detect"):
			GlobalVariables.playerCurrentHealth -= GlobalVariables.skeletonDamage

	await animated_sprite.animation_finished
	is_attacking = false
