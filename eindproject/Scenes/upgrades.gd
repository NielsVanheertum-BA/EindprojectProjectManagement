extends Control

@export var tween_intensity := 1.1
@export var tween_duration := 0.15

@onready var upgrade_strength: Button = $Panel/HBoxContainer/UpgradeStrenght
@onready var upgrade_health: Button = $Panel/HBoxContainer/UpgradeHealth
@onready var upgrade_protection: Button = $Panel/HBoxContainer/UpgradeProtection
@onready var game: Node2D = $".."
@onready var player_health_bar: ProgressBar = $"../Player/PlayerHealthBar"

var _tweens: Dictionary = {}


func _ready() -> void:
	await get_tree().process_frame
	for button in [upgrade_strength, upgrade_health, upgrade_protection]:
		button.pivot_offset = button.size / 2


func _process(_delta: float) -> void:
	_btn_hovered(upgrade_strength)
	_btn_hovered(upgrade_health)
	_btn_hovered(upgrade_protection)


func _btn_hovered(button: Button) -> void:
	var target_scale := Vector2.ONE * tween_intensity if button.is_hovered() else Vector2.ONE
	if button.scale == target_scale:
		return
	if _tweens.has(button):
		_tweens[button].kill()
	var tween := create_tween()
	tween.tween_property(button, "scale", target_scale, tween_duration)
	_tweens[button] = tween


func _pick_upgrade() -> void:
	Engine.time_scale = 1
	hide()
	game.finish_upgrade()


func _on_upgrade_strenght_pressed() -> void:
	GlobalVariables.sword_damage += 5
	_pick_upgrade()


func _on_upgrade_health_pressed() -> void:
	GlobalVariables.playerMaxHealth += 10
	GlobalVariables.playerCurrentHealth += 10
	player_health_bar.max_value = GlobalVariables.playerMaxHealth
	_pick_upgrade()


func _on_upgrade_protection_pressed() -> void:
	GlobalVariables.ghostDamage -= int(float(GlobalVariables.ghostDamage) / 10.0)
	GlobalVariables.skeletonDamage -= int(float(GlobalVariables.skeletonDamage) / 10.0)
	GlobalVariables.orcDamage -= int(float(GlobalVariables.orcDamage) / 10.0)
	_pick_upgrade()
