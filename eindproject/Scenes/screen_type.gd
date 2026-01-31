extends CheckButton
@onready var screen_type: CheckButton = $"."


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		screen_type.text = "Windowed"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		screen_type.text = "Fullscreen"
