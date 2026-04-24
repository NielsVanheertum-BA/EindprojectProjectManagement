extends Node2D

const SKELETON = preload("res://Scenes/skeleton.tscn")
const GHOST = preload("res://Scenes/ghost.tscn")

@onready var pause_menu: Control = $PauseMenu
@onready var wave_text: Label = $Wave
@onready var kills_text: Label = $Kills
@onready var timer: Timer = $Timer
@onready var upgrades: Control = $Upgrades

var spawn_points: Array[Node2D] = []
var paused := false
var wave_spawning := false
var upgrading := false


func _ready() -> void:
	Engine.time_scale = 1
	pause_menu.hide()
	spawn_points = [
		$SpawnPoint1, $SpawnPoint2, $SpawnPoint3, $SpawnPoint4,
		$SpawnPoint5, $SpawnPoint6, $SpawnPoint7
	]


func _process(_delta: float) -> void:
	wave_text.text = "Wave " + str(GlobalVariables.wave)
	kills_text.text = "Kills : " + str(GlobalVariables.kill)

	if Input.is_action_just_pressed("pause"):
		toggle_pause()

	# Start next wave timer when all enemies are gone
	if GlobalVariables.enemiesLeft == 0 and not wave_spawning and timer.is_stopped():
		if GlobalVariables.wave == 0:
			GlobalVariables.playerCurrentHealth = GlobalVariables.playerMaxHealth
		timer.start()
		wave_spawning = true

	# Upgrades
	if GlobalVariables.playerAlive:
		var is_upgrade_wave = GlobalVariables.wave == 0 or GlobalVariables.wave % 5 == 0
		if is_upgrade_wave and not upgrading:
			upgrades.show()
			upgrading = true
			Engine.time_scale = 0
		elif not is_upgrade_wave:
			upgrading = false


func toggle_pause() -> void:
	paused = !paused
	pause_menu.visible = paused
	Engine.time_scale = 0 if paused else 1


func _on_timer_timeout() -> void:
	GlobalVariables.wave += 1
	GlobalVariables.enemiesLeft = GlobalVariables.wave

	for i in GlobalVariables.wave:
		spawn_enemy(randi() % spawn_points.size())

	wave_spawning = false


func spawn_enemy(spawn_index: int) -> void:
	var enemy: Node2D = GHOST.instantiate() if randi() % 2 == 0 else SKELETON.instantiate()
	add_child(enemy)
	enemy.global_position = spawn_points[spawn_index].global_position
