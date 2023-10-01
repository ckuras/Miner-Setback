extends Area2D

signal toggle_inventory()

@export var inventory_data: InventoryData
@onready var navigation_obstacle = $NavigationObstacle2D
@onready var animation_player = $AnimationPlayer

enum States {IDLE, DROP_OFF, FOLLOW, FIND, MINE}

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()


func _on_body_entered(body):
	if body is Miner:
		var miner: Miner = body
		if miner.state_machine.state.name == "FindCart" and not miner.inventory_data.is_empty():
			miner.state_machine.transition_to("DropOff", { "drop_off_inventory": inventory_data})

			
