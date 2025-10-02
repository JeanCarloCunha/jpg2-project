extends Node2D

var interactable_component: InteractableComponent

func _ready() -> void:
	interactable_component = get_node("InteractableComponent") as InteractableComponent
	if interactable_component == null:
		push_error("Sign needs a InteractableComponent.")
	
	if not interactable_component.interaction_emitter.is_connected(_interact):
		interactable_component.interaction_emitter.connect(_interact)

func _interact():
	print("Interagiu!")
