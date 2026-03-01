extends Node2D


@onready var pause_menu: Control = $PauseMenu
@onready var waveText: Label = $Wave

var paused = false

func _ready() -> void:
	Engine.time_scale = 1
	pause_menu.hide()


func _process(delta: float) -> void:
	#Pause Menu
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
	waveText.text = "Wave "+str(GlobalVariables.wave)
	

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	paused = !paused
