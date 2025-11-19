extends ProgressBar

@onready var player_damage_bar = $PlayerDamageBar
@onready var timer = $Timer

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		player_damage_bar.value = health
		
func _init_health(_health):
	health = _health 
	max_value = health
	value = health
	player_damage_bar.max_value = health
	player_damage_bar.value = health

func _on_timer_timeout() -> void:
	player_damage_bar.value = health
