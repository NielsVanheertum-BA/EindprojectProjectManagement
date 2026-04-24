extends CharacterBody2D

const SPEED = 240.0
const JUMP_VELOCITY = -450.0
const ATTACK_HIT_DELAY = 0.2
const ATTACK_END_DELAY = 0.2

var is_dead := false
var which_attack := 1
var is_attacking := false
var last_direction := 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_health_bar: ProgressBar = $PlayerHealthBar
@onready var area_right: Area2D = $AreaRight
@onready var area_left: Area2D = $AreaLeft
@onready var area_down: Area2D = $AreaDown
@onready var area_up: Area2D = $AreaUp
@onready var collision_shape: CollisionShape2D = $Hitbox
@onready var game_over: Control = $"../GameOver"


func _ready() -> void:
	game_over.hide()
	player_health_bar._init_health(GlobalVariables.playerCurrentHealth)
	_set_attack_areas(false)


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")

	if direction > 0:
		last_direction = 1
		animated_sprite.flip_h = false
	elif direction < 0:
		last_direction = -1
		animated_sprite.flip_h = true

	if not is_attacking:
		if is_on_floor():
			animated_sprite.play("idle" if direction == 0 else "run")
		else:
			animated_sprite.play("jump")

	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _process(_delta: float) -> void:
	if GlobalVariables.playerCurrentHealth != GlobalVariables.playerPreviousHealth:
		GlobalVariables.playerPreviousHealth = GlobalVariables.playerCurrentHealth
		spawn_hit_effect(collision_shape.global_position)
		if GlobalVariables.playerCurrentHealth <= 0:
			die()
			player_health_bar.health = 0.0000001
		else:
			player_health_bar.health = GlobalVariables.playerCurrentHealth


func die() -> void:
	if is_dead:
		return
	is_dead = true
	GlobalVariables.playerAlive = false
	Engine.time_scale = 0.5
	set_physics_process(false)
	animated_sprite.play("death")
	await animated_sprite.animation_finished

	# Reset global stats
	GlobalVariables.playerMaxHealth = GlobalVariables.playerBaseMaxHealth
	GlobalVariables.ghostDamage = GlobalVariables.ghostBaseDamage
	GlobalVariables.skeletonDamage = GlobalVariables.skeletonBaseDamage
	GlobalVariables.sword_damage = GlobalVariables.sword_base_damage
	GlobalVariables.playerCurrentHealth = GlobalVariables.playerMaxHealth
	GlobalVariables.enemiesLeft = 0

	# Update records
	GlobalVariables.killRecord = maxi(GlobalVariables.killRecord, GlobalVariables.kill)
	GlobalVariables.waveRecord = maxi(GlobalVariables.waveRecord, GlobalVariables.wave)
	GlobalVariables.wave = 0
	GlobalVariables.kill = 0

	game_over.show()
	Engine.time_scale = 0


func attack() -> void:
	is_attacking = true
	_set_attack_areas(true)

	if not is_on_floor():
		animated_sprite.play("attack1")
	elif Input.is_action_pressed("up"):
		animated_sprite.play("attackUp")
	elif Input.is_action_pressed("down"):
		animated_sprite.play("attackDown")
	elif which_attack == 1:
		animated_sprite.play("attack1")
		which_attack = 2
	else:
		animated_sprite.play("attack2")
		which_attack = 1

	await get_tree().create_timer(ATTACK_HIT_DELAY).timeout

	# Determine active attack area
	var enemies: Array
	if Input.is_action_pressed("up"):
		enemies = area_up.get_overlapping_areas()
	elif Input.is_action_pressed("down"):
		enemies = area_down.get_overlapping_areas()
	elif last_direction == 1:
		enemies = area_right.get_overlapping_areas()
	else:
		enemies = area_left.get_overlapping_areas()

	for body in enemies:
		if body != self and body.has_method("take_damage"):
			body.take_damage()

	await get_tree().create_timer(ATTACK_END_DELAY).timeout

	_set_attack_areas(false)
	is_attacking = false


func spawn_hit_effect(pos: Vector2) -> void:
	var effect := Sprite2D.new()
	effect.texture = animated_sprite.sprite_frames.get_frame_texture("idle", 0)
	effect.global_position = pos
	effect.modulate = Color(1, 0, 0, 0.7)
	get_parent().add_child(effect)

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(effect, "modulate:a", 0.0, 0.3)
	tween.tween_property(effect, "scale", Vector2(1.5, 1.5), 0.3)
	tween.chain().tween_callback(effect.queue_free)


func _set_attack_areas(enabled: bool) -> void:
	area_left.monitoring = enabled
	area_right.monitoring = enabled
	area_up.monitoring = enabled
	area_down.monitoring = enabled
