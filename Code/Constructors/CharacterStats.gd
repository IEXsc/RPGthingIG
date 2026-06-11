extends Resource
class_name Character

@export var name: String = ""
@export var description: String = ""

@export var max_hp: int = 100
@export var max_sp: int = 0
@export var hp: int = 100
@export var sp: int = 0

@export var weapon: Weapon = null
@export var soul: Souls = null: set = set_soul

@export var attack: int = 0
@export var defense: int = 0
@export var crit_chance: int = 0
@export var defense_from_parrying: float = 1
@export var status: String = "Alive"

var special_moves: Array[Move] = []
var affinities: Array[float] = []
var discoveredaffinities: Array[float] = []
@export var animation_frames: SpriteFrames = null

#@export var persona = Charachtergods

func _init(c_name: String = "", c_description: String = "", c_max_hp: int = 0,  c_max_sp: int = 0, c_hp: int = 0,  c_sp: int = 0, c_weapon: Weapon = null, c_soul: Souls = null ,  c_attack: int = 0, c_defense: int = 0,  c_crit_chance: int = 0, c_defense_from_parrying: float = 0, c_status: String = "", c_animation_frames: SpriteFrames = null) -> void:
	name = c_name
	description = c_description
	
	max_hp = c_max_hp
	max_sp = c_max_sp
	hp = c_hp
	sp = c_sp
	
	weapon = c_weapon
	self.soul = c_soul
	
	attack = c_attack
	defense = c_defense
	crit_chance = c_crit_chance
	defense_from_parrying = c_defense_from_parrying
	status = c_status

	animation_frames = c_animation_frames

func set_soul(newsoul: Souls) -> void:
	soul = newsoul
	if(soul!=null):
		special_moves = soul.specialmoves
		affinities = soul.affinities
		discoveredaffinities = soul.discoveredaffinities
	
