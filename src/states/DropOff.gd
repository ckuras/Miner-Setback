extends State

@export var miner: Miner

@onready var inventory_data: InventoryData = miner.inventory_data

var drop_off_inventory: InventoryData

func enter(_msg = {}):
	if not _msg.drop_off_inventory:
		return
	drop_off_inventory = _msg.drop_off_inventory
	miner.navigation_agent.radius = 2
	await drop_off_resources()
	state_machine.transition_to("Idle")

func exit():
	miner.navigation_agent.radius = 6

func drop_off_resources():
	for index in range(0, inventory_data.slot_datas.size()):
		if inventory_data.slot_datas[index]:
			for i in range(0, inventory_data.slot_datas[index].quantity):
				if inventory_data.slot_datas[index]:
					var slot_data = inventory_data.slot_datas[index].create_single_slot_data()
					drop_off_inventory.pick_up_slot_data(slot_data)
					inventory_data.inventory_updated.emit(inventory_data)
					await get_tree().create_timer(0.1).timeout
			inventory_data.slot_datas[index] = null
			inventory_data.inventory_updated.emit(inventory_data)
