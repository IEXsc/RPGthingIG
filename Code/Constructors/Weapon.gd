extends Resource
class_name Weapon

@export var name: String = ""
@export var description: String = ""
@export var damage: int = 0 # (e.g. negative for healing)
@export var type: int = 0

func _init(w_name: String = "", w_desc: String = "", w_dmg: int = 0, w_type: int = 0) -> void:
	name = w_name
	description = w_desc
	damage = w_dmg
	type = w_type
