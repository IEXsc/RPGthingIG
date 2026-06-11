extends Resource
class_name Armor

@export var name: String = ""
@export var description: String = ""
@export var protection: int = 0 
@export var specialdefense: String = "None"

func _init(a_name: String = "", a_desc: String = "", a_protection: int = 0, a_specialdefense: String = "") -> void:
	name = a_name
	description = a_desc
	protection = a_protection
	specialdefense = a_specialdefense
