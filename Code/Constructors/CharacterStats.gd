extends Resource
class_name Character

@export var name: String = ""
@export var description: String = ""

@export var level: int = 1
@export var experience: int = 0: set = check_level


@export var basehp: int = 100
@export var basesp: int = 0
@export var max_hp: int = 100
@export var max_sp: int = 0
@export var hp: int = 100
@export var sp: int = 0

@export var weapon: Weapon = null
@export var armor: Armor = null

@export var soul: Souls = null: set = set_soul

var attack: int = 0
var defense: int = 0
var crit_chance: int = 0
var defense_from_parrying: float = 1
var status: String = "Alive"

var special_moves: Array[Move] = []
var affinities: Array[float] = []
var discoveredaffinities: Array[float] = []
@export var animation_frames: SpriteFrames = null


func _init(c_name: String = "", c_description: String = "", c_level: int = 0, c_experience: int = 0, c_max_hp: int = 0,  c_max_sp: int = 0, c_hp: int = 0,  c_sp: int = 0, c_weapon: Weapon = null, c_armor: Armor = null, c_soul: Souls = null ,  c_attack: int = 0, c_defense: int = 0,  c_crit_chance: int = 0, c_defense_from_parrying: float = 0, c_status: String = "", c_animation_frames: SpriteFrames = null) -> void:
	name = c_name
	description = c_description
	
	level = c_level
	experience = c_experience
	
	max_hp = c_max_hp+(525*(((level-1)/ 98.0 ) ** 1.5 ) )
	max_sp = c_max_sp+(300*(((level-1)/ 98.0 ) ** 1.5 ) )
	hp = c_hp
	sp = c_sp
	
	weapon = c_weapon
	armor = c_armor
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
	
func check_level(newexperience: int) -> void:
	experience = newexperience
	var requiredexpfornextlevel = 100 + 1375000 * ( ( ( level - 1 ) / 98.0 ) ** 2)
	if(experience >= requiredexpfornextlevel and level<99):
		experience = experience - requiredexpfornextlevel
		level = level + 1
		requiredexpfornextlevel = 100 + 1375000 * ( ( ( level - 1 ) / 98.0 ) ** 2)
		max_hp = basehp + (525*(((level-1)/ 98.0 ) ** 1.5 ) )   #UPDATES HP
		max_sp = basesp + (300*(((level-1)/ 98.0 ) ** 1.5 ) )   # UPDATES SP
