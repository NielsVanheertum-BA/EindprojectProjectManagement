extends Node

var playerMaxHealth = 100
var playerCurrentHealth = playerMaxHealth
var playerPreviousHealth = playerCurrentHealth
var sword_damage = 10

var enemiesLeft = 1
var wave = 1

func _process(delta: float) -> void:
	
	if enemiesLeft == 0:
		wave += 1
		enemiesLeft = wave
		
