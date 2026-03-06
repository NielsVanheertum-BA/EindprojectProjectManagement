extends Node2D


@onready var pause_menu: Control = $PauseMenu
@onready var waveText: Label = $Wave
@onready var killsText: Label = $Kills

@onready var timer: Timer = $Timer
@onready var spawn_point_1: Node2D = $SpawnPoint1
@onready var spawn_point_2: Node2D = $SpawnPoint2
@onready var spawn_point_3: Node2D = $SpawnPoint3
@onready var spawn_point_4: Node2D = $SpawnPoint4
@onready var spawn_point_5: Node2D = $SpawnPoint5
@onready var spawn_point_6: Node2D = $SpawnPoint6
@onready var spawn_point_7: Node2D = $SpawnPoint7
var spawnPoints: Array[Node2D] = []


const skeleton = preload("res://Scenes/skeleton.tscn")
const ghost = preload("res://Scenes/ghost.tscn")
var paused = false
var waveSpawing = false

func _ready() -> void:
	Engine.time_scale = 1
	pause_menu.hide()
	spawnPoints = [spawn_point_1, spawn_point_2, spawn_point_3, spawn_point_4, spawn_point_5, spawn_point_6, spawn_point_7]
	

func _process(delta: float) -> void:
	#Pause Menu
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
	waveText.text = "Wave "+str(GlobalVariables.wave)
	killsText.text = "Kills : "+str(GlobalVariables.kill)

	
	
	if GlobalVariables.enemiesLeft == 0 and not waveSpawing and timer.is_stopped():
		timer.start()
		waveSpawing = true
		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused


func _on_timer_timeout() -> void:
	GlobalVariables.wave += 1
	GlobalVariables.enemiesLeft = GlobalVariables.wave
	for teller in range(GlobalVariables.wave):
		var spawnLocation = randi() % spawnPoints.size()
		spawn_enemy(spawnLocation)
	waveSpawing = false

func spawn_enemy(spawnLocation: int) -> void:
	var randomEnemy = randi() % 2
	var enemy: Node2D
	if randomEnemy == 0:
		enemy = ghost.instantiate() as Node2D
	else:
		enemy = skeleton.instantiate() as Node2D
		
	add_child(enemy)
	enemy.global_position = spawnPoints[spawnLocation].global_position
