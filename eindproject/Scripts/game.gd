extends Node2D

const SKELETON = preload("res://Scenes/skeleton.tscn")
const GHOST = preload("res://Scenes/ghost.tscn")
const ORC = preload("res://Scenes/orc.tscn")
const HEART = preload("res://Scenes/heart.tscn")
const MINOTAURUS = preload("res://Scenes/minotaurus.tscn")

const HEART_SPAWN_INTERVAL = 4

@onready var pause_menu: Control = $PauseMenu
@onready var wave_text: Label = $Wave
@onready var kills_text: Label = $Kills
@onready var timer: Timer = $Timer
@onready var upgrades: Control = $Upgrades
@onready var healthdisplay: Label = $Player/PlayerHealthBar/Health

var spawn_points: Array[Node2D] = []
var paused := false
var wave_spawning := false
var upgrading := false
var orcs_spawned_this_wave := 0

var _last_wave := -1
var _last_kills := -1
var _last_health := -1


func _ready() -> void:
	pause_menu.hide()
	upgrades.show()
	Engine.time_scale = 0
	upgrading = true
	spawn_points = [
		$SpawnPoint1, $SpawnPoint2, $SpawnPoint3, $SpawnPoint4,
		$SpawnPoint5, $SpawnPoint6, $SpawnPoint7
	]


func _process(_delta: float) -> void:
	if GlobalVariables.wave != _last_wave:
		_last_wave = GlobalVariables.wave
		wave_text.text = "Wave " + str(GlobalVariables.wave)

	if GlobalVariables.kill != _last_kills:
		_last_kills = GlobalVariables.kill
		kills_text.text = "Kills : " + str(GlobalVariables.kill)

	if GlobalVariables.playerCurrentHealth != _last_health:
		_last_health = GlobalVariables.playerCurrentHealth
		healthdisplay.text = str(GlobalVariables.playerCurrentHealth) + "/" + str(GlobalVariables.playerMaxHealth)

	if Input.is_action_just_pressed("pause"):
		pause_menu.show()
		Engine.time_scale = 0

	if GlobalVariables.enemiesLeft == 0 \
	and not wave_spawning \
	and timer.is_stopped() \
	and not upgrading:
		timer.start(2.0)
		wave_spawning = true


func _on_timer_timeout() -> void:
	GlobalVariables.wave += 1

	if GlobalVariables.wave % 5 == 0 and GlobalVariables.wave % 10 != 0:
		upgrades.show()
		Engine.time_scale = 0
		upgrading = true
		wave_spawning = false
		return

	_start_wave()


func finish_upgrade() -> void:
	upgrades.hide()
	Engine.time_scale = 1
	upgrading = false
	_start_wave()


func _start_wave() -> void:
	wave_spawning = true
	orcs_spawned_this_wave = 0

	if GlobalVariables.wave % HEART_SPAWN_INTERVAL == 0:
		_spawn_heart()

	spawn_wave(GlobalVariables.wave)
	wave_spawning = false


func spawn_wave(amount: int) -> void:
	var is_mino_wave = false
	if GlobalVariables.wave % 10 == 0 and GlobalVariables.wave <= 1:
		is_mino_wave = true
		
	var count: int = 1 if is_mino_wave else amount
	GlobalVariables.enemiesLeft = count

	for i in count:
		spawn_enemy(randi() % spawn_points.size(), is_mino_wave)


func _spawn_heart() -> void:
	var heart = HEART.instantiate()
	heart.global_position = spawn_points[randi() % spawn_points.size()].global_position
	add_child(heart)


func spawn_enemy(spawn_index: int, is_endling_wave: bool) -> void:
	var enemy: Node2D

	if is_endling_wave:
		enemy = MINOTAURUS.instantiate()
	elif GlobalVariables.wave >= 5:
		var random: int = randi() % 3
		if random == 0:
			enemy = GHOST.instantiate()
		elif random == 1:
			enemy = SKELETON.instantiate()
		else:
			if orcs_spawned_this_wave < 4:
				enemy = ORC.instantiate()
				orcs_spawned_this_wave += 1
			else:
				enemy = SKELETON.instantiate()
	else:
		enemy = GHOST.instantiate() if randi() % 2 == 0 else SKELETON.instantiate()

	add_child(enemy)
	enemy.global_position = spawn_points[spawn_index].global_position
