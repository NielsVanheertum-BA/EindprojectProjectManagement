extends Node2D


@onready var pause_menu: Control = $PauseMenu
@onready var waveText: Label = $Wave
@onready var timer: Timer = $Timer
@onready var spawn_point_1: Node2D = $SpawnPoint1
@onready var spawn_point_2: Node2D = $SpawnPoint2
@onready var spawn_point_3: Node2D = $SpawnPoint3
@onready var spawn_point_4: Node2D = $SpawnPoint4
@onready var spawn_point_5: Node2D = $SpawnPoint5
@onready var spawn_point_6: Node2D = $SpawnPoint6
@onready var spawn_point_7: Node2D = $SpawnPoint7
var spawnPoints = [spawn_point_1, spawn_point_2, spawn_point_3, spawn_point_4, spawn_point_5, spawn_point_6, spawn_point_7] 

const skeleton = preload("res://Scenes/skeleton.tscn")
const ghost = preload("res://Scenes/Ghost.tscn")
var paused = false

func _ready() -> void:
	Engine.time_scale = 1
	pause_menu.hide()


func _process(delta: float) -> void:
	#Pause Menu
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
	waveText.text = "Wave "+str(GlobalVariables.wave)
	
	if GlobalVariables.enemiesLeft == 0:
		timer.start()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused


func _on_timer_timeout() -> void:
	var spawnLocation = 0
	for teller in GlobalVariables.wave:
		spawn_enemy(spawnLocation)
		spawnLocation += 1
		
func spawn_enemy(spawnLocation):
	var randomEnemy = randi_range(0,1)
	
	if randomEnemy == 0:
		var enemy = ghost.instantiate() as Node2D
		add_child(enemy)
		enemy.global_position = Vector2(spawnPoints[spawnLocation].global_postion)
	else: 
		var enemy = skeleton.instantiate() as Node2D
		add_child(enemy)
		enemy.global_position = Vector2(spawnPoints[spawnLocation].global_postion)
	
	
