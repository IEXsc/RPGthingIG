extends Resource
class_name Move


@export var name: String = ""
@export var description: String = ""
@export var damage: int = 0
@export var cost: int = 0
@export var type: int = 0
@export var targets: String = "One"
@export var animation_time: float = 0.5
@export var image: SpriteFrames

func _init(p_name: String = "", p_desc: String = "", p_dmg: int = 0, p_cost: int = 0, p_type: int = 0, p_targets: String = "One", p_animation_time: float = 0.5, p_img: SpriteFrames = null) -> void:
	name = p_name
	description = p_desc
	damage = p_dmg
	cost = p_cost
	type = p_type
	targets = p_targets
	animation_time = p_animation_time
	image = p_img
