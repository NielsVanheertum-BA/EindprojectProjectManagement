extends Control

const INPUT_BUTTON_SCENE = preload("res://Scenes/input_button.tscn")
const INPUT_ACTIONS := {
	"up": "Up",
	"down": "Down",
	"left": "Left",
	"right": "Right",
	"jump": "Jump",
	"attack": "Attack"
}

@onready var action_list: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping := false
var action_to_remap: String = ""
var remapping_button: Control = null


func _ready() -> void:
	_build_action_list()


func _build_action_list() -> void:
	_cancel_remap()
	InputMap.load_from_project_settings()

	for child in action_list.get_children():
		child.queue_free()

	for action in INPUT_ACTIONS:
		var button: Control = INPUT_BUTTON_SCENE.instantiate()
		var label_action := button.find_child("LabelAction") as Label
		var label_input := button.find_child("LabelInput") as Label
		label_action.text = INPUT_ACTIONS[action]
		var events := InputMap.action_get_events(action)
		label_input.text = events[0].as_text().trim_suffix(" (Physical)") if events.size() > 0 else ""
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button: Control, action: String) -> void:
	if is_remapping:
		return
	is_remapping = true
	action_to_remap = action
	remapping_button = button
	(button.find_child("LabelInput") as Label).text = "Press key to bind..."


func _input(event: InputEvent) -> void:
	if not is_remapping:
		return
	if event is InputEventKey:
		if not event.pressed:
			return
	elif event is InputEventMouseButton:
		if not event.pressed or event.double_click:
			return
	else:
		return

	InputMap.action_erase_events(action_to_remap)
	InputMap.action_add_event(action_to_remap, event)
	(remapping_button.find_child("LabelInput") as Label).text = event.as_text().trim_suffix(" (Physical)")
	_cancel_remap()
	accept_event()


func _cancel_remap() -> void:
	is_remapping = false
	action_to_remap = ""
	remapping_button = null


func _on_reset_button_pressed() -> void:
	_build_action_list()
