extends Resource
class_name Souls

@export var name: String = ""
@export var description: String = ""
@export var affinities: Array[float] = []
@export var discoveredaffinities: Array[float] = []
@export var specialmoves: Array[Move] = []
@export var animation: SpriteFrames = null

func _init(s_name: String = "", s_description: String = "", s_affinities: Array[float] = [], s_discoveredaffinities: Array[float] = [], s_specialmoves:Array[Move] = [], s_animation:SpriteFrames = null) -> void:
	name = s_name
	description = s_description
	affinities = s_affinities
	discoveredaffinities = s_discoveredaffinities
	specialmoves = s_specialmoves
	animation = s_animation
	
