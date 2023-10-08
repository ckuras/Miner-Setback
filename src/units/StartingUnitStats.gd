extends Resource

class_name StartingUnitStats

@export_enum("Miner", "Mercenary", "Enemy") var type: String = "Miner"

@export_range(1,3,1,"or_greater", "or_less") var tier: int = 1

@export var texture: AtlasTexture