extends Area2D

signal toggle_inventory()

@export var inventory_data: InventoryData
@onready var navigation_obstacle = $NavigationObstacle2D
@onready var animation_player = $AnimationPlayer

enum States {IDLE, DROP_OFF, FOLLOW, FIND, MINE}

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()


func _on_body_entered(body):
	if body is Miner:
		print("in drop off range ", body)
		var miner: Miner = body
		if miner._state == States.DROP_OFF and not miner.inventory_data.is_empty():
			var miner_slots: Array[SlotData] = miner.inventory_data.slot_datas
			for index in range(0, miner_slots.size()):
				if miner_slots[index]:
					inventory_data.pick_up_slot_data(miner_slots[index])
					miner.inventory_data.slot_datas[index] = null
					miner.inventory_data.inventory_updated.emit(miner.inventory_data)
			print('miner slot data', miner.inventory_data.slot_datas)
		miner.change_state(States.IDLE)
