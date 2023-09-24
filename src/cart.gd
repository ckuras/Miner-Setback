extends CharacterBody2D

signal toggle_inventory()

@export var inventory_data: InventoryData

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
