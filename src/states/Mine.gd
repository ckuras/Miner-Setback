class_name Mine extends State

@export var miner: Miner

@onready var inventory_data: InventoryData = miner.inventory_data

var resource: MiningResource
var current_miners: int = 0

const AVOIDANCE_RADIUS: int = 6

func enter(_msg := {}) -> void:
    if _msg.has('resource') and _msg.has('current_miners'):
        resource = _msg.resource
        current_miners = _msg.current_miners
        start_mining()

func start_mining():
    if (current_miners > 4):
        get_tree().call_group("miner_units", "set_navigation_avoidance_radius", 4)
    if (current_miners > 8):
        get_tree().call_group("miner_units", "set_navigation_avoidance_radius", 2)
    await get_tree().create_timer(0.2).timeout
    mine_resource()

func mine_resource():
    animation.play("mine")
    var mine_finished = await animation.animation_finished
    if mine_finished == "mine":
        var item = resource.gather_resource(miner)
        if item:
            var slot_instance: SlotData = SlotData.new()
            slot_instance.item_data = item
            if not inventory_data.pick_up_slot_data(slot_instance):
                print('inventory full')
                state_machine.transition_to("Idle")
            else:
                await mine_resource()
        else:
            pass
            state_machine.transition_to("Idle")