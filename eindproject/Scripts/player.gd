extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var is_dead = false
var whichAttack = 1
var is_attacking = false
var last_direction = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player_health_bar: ProgressBar = $PlayerHealthBar
@onready var collision_shape: CollisionShape2D = $PlayerHitbox
@onready var area_right: Area2D = $AreaRight
@onready var area_left: Area2D = $AreaLeft



# Ready functies
func _ready() -> void:
	player_health_bar._init_health(GlobalVariables.playerCurrentHealth)
	area_left.monitoring = false
	area_right.monitoring = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# Zwaartekracht
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_attacking:
		return
	
	if Input.is_action_just_pressed("attack") and is_on_floor():
		attack()
		return
		
	# Springe
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
# Richting van speler
	var direction := Input.get_axis("left", "right")

	
	# Draai sprite om
	if direction > 0:
		last_direction = 1
		animated_sprite.flip_h = false
	elif direction < 0:
		last_direction = -1
		animated_sprite.flip_h = true
		
	# Animaties
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	# Beweging
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Doodgaan functie
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
	tree.call_deferred("change_scene_to_file", "res://Scenes/MainMenu.tscn")

func attack():
	is_attacking = true
	if whichAttack == 1:
		animated_sprite.play("attack1")
		whichAttack = 2
	else:
		animated_sprite.play("attack2")
		whichAttack = 1
	await get_tree().create_timer(0.2).timeout
	var enemies = []
	if last_direction == 1:
		enemies = area_left.get_overlapping_bodies()
		
	elif last_direction == 1:
		enemies = area_right.get_overlapping_bodies()
		
	print(enemies)
	
	for body in enemies:
		if body != self and body.has_method("take_damage"):
			body.take_damage()

	await get_tree().create_timer(0.2).timeout
	is_attacking = false

func _process(delta: float) -> void:
	# Check voor damage
	if GlobalVariables.playerCurrentHealth != GlobalVariables.playerPreviousHealth :
		GlobalVariables.playerPreviousHealth = GlobalVariables.playerCurrentHealth
		spawn_hit_effect(collision_shape.global_position)
		if GlobalVariables.playerCurrentHealth <= 0:
			die()
			player_health_bar.health = 0.0000001
		else: 
			player_health_bar.health = GlobalVariables.playerCurrentHealth
			
# Hit effect
func spawn_hit_effect(position: Vector2):
	var effect = Sprite2D.new()
	effect.texture = animated_sprite.sprite_frames.get_frame_texture("idle", 0) 
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
