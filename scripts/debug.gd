extends Node2D

@export var _debug_mode: bool
@onready var player: CharacterBody2D

func _ready() -> void:
	player = get_parent()

func _physics_process(delta: float) -> void:
	if _debug_mode:
		queue_redraw()

func _draw() -> void:
	if _debug_mode:
		draw_line(player.position, Vector2(player.position.x + 100, player.position.y), Color.RED, 4.0)
