extends Node2D
class_name InteractableComponent

var interactable_area: Area2D
signal interaction_emitter

func _ready() -> void:
	if get_child_count() < 1:
		push_error("InteractableComponent needs an Area2D")
		return
	if not (get_child(0) is Area2D):
		push_error("InteractableComponent needs an Area2D")
		return
	
	interactable_area = get_child(0)
	interactable_area.body_entered.connect(_on_area_enter)

func _on_area_enter(body: Node2D):
	if body.name == "Player":
		var playerControllerComponent: PlayerControllerComponent
		playerControllerComponent = (body as Player).get_node("PlayerControllerComponent") as PlayerControllerComponent
		if not playerControllerComponent.interaction.is_connected(_interaction_emitter):
			playerControllerComponent.interaction.connect(_interaction_emitter)

func _interaction_emitter():
	interaction_emitter.emit()
