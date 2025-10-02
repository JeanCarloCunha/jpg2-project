extends Node2D
class_name PlayerControllerComponent

signal interaction

func horizontal_axis() -> float:
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))

func vertical_axis() -> float:
	return int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

func jump() -> float:
	return int(Input.is_action_just_pressed("jump"))

func interact() -> void:
	if Input.is_action_just_pressed('interact'):
		interaction.emit()
