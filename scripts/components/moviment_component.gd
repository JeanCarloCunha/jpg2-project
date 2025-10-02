extends Node2D
class_name MovimentComponent

@export_enum("Side-Scrolling", "Top-Down") var orientation = 0

@export var _entity: CharacterBody2D

@export var _speed: float = 160
@export var _jump_force: float = 325

var _direction: Vector2
var _gravity_force = ProjectSettings.get_setting("physics/2d/default_gravity")

func moviment_direction(direction: Vector2) -> void:
	_direction = direction

func move(_delta):
	if orientation == 0: # Side-Scrolling
		_side_scrolling_moviment(_delta)
	if orientation == 1: # Top-Down
		_top_down_moviment()
	
	_entity.move_and_slide()

#region Side-Scrolling

func _side_scrolling_moviment(_delta) -> void:
	if not _direction.y == 0 and _entity.is_on_floor():
		_entity.velocity.y = _jump_force * -1
	
	if not _direction.x == 0:
		_entity.velocity.x = _direction.x * _speed
	else:
		_entity.velocity.x = move_toward(_entity.velocity.x, 0, _speed)
	
	if !_entity.is_on_floor():
		_entity.velocity.y += _gravity_force * _delta

#endregion

#region Top-Down

func _top_down_moviment() -> void:
	if _direction != Vector2.ZERO:
		_entity.velocity.x = _direction.x * _speed
		_entity.velocity.y = _direction.y * _speed
	else:
		_entity.velocity.x = move_toward(_entity.velocity.x, 0, _speed)
		_entity.velocity.y = move_toward(_entity.velocity.y, 0, _speed)	

#endregion
