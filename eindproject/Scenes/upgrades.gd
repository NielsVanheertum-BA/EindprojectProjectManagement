extends Control

@export var tween_intensity: float
@export var tween_duration: float

@onready var upgrade_strenght: Button = $Panel/HBoxContainer/UpgradeStrenght
@onready var upgrade_health: Button = $Panel/HBoxContainer/UpgradeHealth
@onready var upgrade_protection: Button = $Panel/HBoxContainer/UpgradeProtection
@onready var upgrades: Control = $"."

func _process(delta: float) -> void:
	btn_hovered(upgrade_strenght)
	btn_hovered(upgrade_health)
	btn_hovered(upgrade_protection)
	
func start_tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: Button):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)



func _on_upgrade_strenght_pressed() -> void:
	GlobalVariables.sword_damage += 5
	Engine.time_scale = 1
	upgrades.hide()

func _on_upgrade_health_pressed() -> void:
	GlobalVariables.playerMaxHealth += 10
	Engine.time_scale = 1
	upgrades.hide()
	

func _on_upgrade_protection_pressed() -> void:
	GlobalVariables.ghostDamage -= GlobalVariables.ghostDamage/10
	Engine.time_scale = 1
	upgrades.hide()
