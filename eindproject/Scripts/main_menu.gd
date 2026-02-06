extends Control
@onready var options_panel: Panel = $"Options Panel"
@onready var main_buttons: VBoxContainer = $"Main Buttons"
@onready var title: Label = $Title
@onready var input_settings: Control = $InputSettings


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_panel.hide()
	input_settings.hide()
	Engine.time_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
func _on_options_pressed() -> void:
	options_panel.show()
	main_buttons.hide()
	title.hide()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_close_pressed() -> void:
	options_panel.hide()
	main_buttons.show()
	title.show()
	
	

func _on_change_keybinds_pressed() -> void:
	input_settings.show()



func _on_close_input_pressed() -> void:
	input_settings.hide()
