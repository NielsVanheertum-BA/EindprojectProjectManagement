extends Control

@export var tween_intensity := 1.1
@export var tween_duration := 0.15

@onready var upgrade_strength: Button = $Panel/HBoxContainer/UpgradeStrenght
@onready var upgrade_health: Button = $Panel/HBoxContainer/UpgradeHealth
@onready var upgrade_protection: Button = $Panel/HBoxContainer/UpgradeProtection

var _tweens: Dictionary = {}


func _ready() -> void:
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


func _pick_upgrade(callback: Callable) -> void:
	callback.call()
	Engine.time_scale = 1
	hide()


func _on_upgrade_strenght_pressed() -> void:
	_pick_upgrade(func(): GlobalVariables.sword_damage += 5)


func _on_upgrade_health_pressed() -> void:
	_pick_upgrade(func(): GlobalVariables.playerMaxHealth += 10)


func _on_upgrade_protection_pressed() -> void:
	_pick_upgrade(func(): GlobalVariables.ghostDamage -= GlobalVariables.ghostDamage / 10)
	
