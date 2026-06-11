extends Resource
class_name Item

@export var name: String = ""
@export var description: String = ""
@export var damage: int = 0
@export var type: int = 0
@export var image: Texture2D

func _init(i_name: String = "", i_desc: String = "", i_dmg: int = 0, i_type: int = 0, i_img: Texture2D = null) -> void:
	name = i_name
	description = i_desc
	damage = i_dmg
	type = i_type
	image = i_img
