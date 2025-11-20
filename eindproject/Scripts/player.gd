extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var is_dead = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_health_bar: ProgressBar = $PlayerHealthBar


func _ready() -> void:
	player_health_bar._init_health(GlobalVariables.playerCurrentHealth)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("left", "right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func die():
	if is_dead:
		return
	is_dead = true

	Engine.time_scale = 0.5
	set_physics_process(false)
	animated_sprite.play("death")
	await animated_sprite.animation_finished
	GlobalVariables.playerCurrentHealth = GlobalVariables.playerMaxHealth
	Engine.time_scale = 1
	var tree := get_tree()
	tree.call_deferred("change_scene_to_file", "res://Scenes/game.tscn")

func _process(delta: float) -> void:
	if GlobalVariables.playerCurrentHealth != GlobalVariables.playerPreviousHealth :
		GlobalVariables.playerPreviousHealth = GlobalVariables.playerCurrentHealth
		if GlobalVariables.playerCurrentHealth <= 0:
			die()
			player_health_bar.health = 0.0000001
		else: 
			player_health_bar.health = GlobalVariables.playerCurrentHealth
