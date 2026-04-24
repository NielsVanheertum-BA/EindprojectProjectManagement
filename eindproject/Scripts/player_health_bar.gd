extends ProgressBar

@onready var player_damage_bar: ProgressBar = $PlayerDamageBar
@onready var timer: Timer = $Timer

var health := 0.0: set = _set_health


func _set_health(new_health: float) -> void:
	var prev_health := health
	health = clampf(new_health, 0.0, max_value)
	value = health

	if health < prev_health:
		timer.start()


func _init_health(initial_health: float) -> void:
	max_value = initial_health
	player_damage_bar.max_value = initial_health
	health = initial_health
	player_damage_bar.value = initial_health


func _on_timer_timeout() -> void:
	player_damage_bar.value = health
