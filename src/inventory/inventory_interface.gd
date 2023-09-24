extends Control

var grabbed_slot_data: SlotData

@onready var cart_inventory = $CartInventory

func set_cart_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	cart_inventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData,
		index: int, button: int) -> void:
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
	
	print(grabbed_slot_data)
