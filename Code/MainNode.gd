extends Node

@onready var StartingLabel = $StartingLabel
@onready var StartGame = $StartGame

var BattleScene = preload("res://Sceenes/Battle.tscn")
var LosingScene = preload("res://Sceenes/failure_screen.tscn")
var WinningScene = preload("res://Sceenes/victory_screen.tscn")

var LightBlindTexture = load("res://Assets/GFX/MovesSprites/LightBlindAnim.tres")
var ThunderSwordsTexture = load("res://Assets/GFX/MovesSprites/ThunderSwordsAnim.tres")
var RebirthTexture = load("res://Assets/GFX/MovesSprites/RebirthAnim.tres")
var OlympusPunchAnim = load("res://Assets/GFX/MovesSprites/OlympusPunchAnim.tres")

var PlayerAnim = load("res://Assets/GFX/AlliesorYourself/Sprites/Player/PlayerAnim.tres")
var AllyAnim = load("res://Assets/GFX/AlliesorYourself/Sprites/Ally/AllyAnim.tres")

var MessiahAnim = load("res://Assets/GFX/AlliesorYourself/Gods/Messiah.tres")
var ZeusAnim = load("res://Assets/GFX/AlliesorYourself/Gods/Zeus.tres")

var TungTungAnim = load("res://Assets/GFX/Enemies/TungTungAnim.tres")
var AngelTungTungAnim = load("res://Assets/GFX/Enemies/TripleTAnim.tres")

var PotionTexture = load("res://Assets/GFX/Items/Potion.png")
var FatPotionTexture = load("res://Assets/GFX/Items/PotionObese.png")
var WeirdPotionTexture = load("res://Assets/GFX/Items/PotionWeird.png")


enum MovesetID { MOVESETMESSIAH, MOVESETZEUS, TEST_MOVESET }



@export var TungTung = AnimatedSprite2D.new()
@export var AngelTungTung = AnimatedSprite2D.new()



const standardLowDamage = 50
const standardAvarageDamage = 100
const standardHighDamage = 150
const standardSevereDamage = 200
const standardColossalDamage = 250
const standardUltimateDamage = 300

const standardTurnBuffLenght = 4

var Skeledeath: Move
var ThunderSwords: Move
var LightBlind: Move
var LightFlash: Move
var Rebirth: Move
var GreenFlower: Move
var AtkNerfMulti: Move
var AtkBuffMulti: Move
var DefNerf: Move
var DefBuff: Move
var CritBoost: Move
var OlympusPunch: Move
var TestOlympusPunch: Move

var ShortSword: Weapon
var Shuriken: Weapon

var MonsterFist: Weapon

var Messiah: Souls
var Zeus: Souls
var Minotaur: Souls

var Giocatore: Character
var Beatrice: Character
var MinotaurEnemy: Character

var BigPotion: Item
var WeirdPotion: Item
var Potion: Item

var Items = [BigPotion,BigPotion,BigPotion, WeirdPotion, Potion, Potion, Potion]

var movesets: Dictionary = {
	MovesetID.MOVESETMESSIAH: [LightFlash, LightBlind, CritBoost] as Array[Move],
	MovesetID.MOVESETZEUS: [Skeledeath, Rebirth] as Array[Move],
	MovesetID.TEST_MOVESET: [TestOlympusPunch] as Array[Move]
}

func _ready() -> void:
	## MOVES
	
	Skeledeath = Move.new(
		"Skele Death", #name
		"Small Ruin Damage To One Enemy",#description
		standardLowDamage, #damage
		8, #cost
		3, #type
		"One", #targets
		1, #animation_time
		ThunderSwordsTexture #image
	)
	
	ThunderSwords = Move.new(
		"ThunderSwords", #name
		"Small Arcane Damage To One Enemy",#description
		standardLowDamage, #damage
		12, #cost
		10, #type
		"One", #targets
		1, #animation_time
		ThunderSwordsTexture #image
	)
	
	LightBlind = Move.new(
		"LightBlind", #name
		"Small Holy Damage To One Enemy",#description
		standardLowDamage, #damage
		8, #cost
		9, #type
		"One", #targets
		0.5, #animation_time
		LightBlindTexture #image
	)
	
	LightFlash = Move.new(
		"LightFlash", #name
		"Small Holy Damage To Every Enemy",#description
		standardLowDamage, #damage
		8, #cost
		9, #type
		"AllEnemies", #targets
		0.5, #animation_time
		LightBlindTexture #image
	)
	
	Rebirth = Move.new(
		"Rebirth", #name
		"Slightly Heals One Ally",#description
		-standardLowDamage, #damage
		7, #cost
		11, #type
		"OneAlly", #targets
		0.5, #animation_time
		RebirthTexture #image
	)
	
	GreenFlower = Move.new(
		"Green Flower", #name
		"Slightly Heals Every Ally",#description
		-standardLowDamage, #damage
		7, #cost
		11, #type
		"AllAllies", #targets
		0.5, #animation_time
		RebirthTexture #image
	)
	
	AtkNerfMulti = Move.new(
		"Attack Nerf Multi", #name
		"Decreases's every foe's Attack for 3 Turns",#description
		-standardTurnBuffLenght, #damage
		7, #cost
		14, #type
		"AllEnemies", #targets
		0.5, #animation_time
		RebirthTexture #image
	)
	
	AtkBuffMulti = Move.new(
		"Attack Buff Multi", #name
		"Increase's every ally's Attack for 3 Turns",#description
		standardTurnBuffLenght, #damage
		7, #cost
		12, #type
		"AllAllies", #targets
		0.5, #animation_time
		RebirthTexture #image
	)
	
	DefNerf = Move.new(
		"Defense Buff", #name
		"Decreases's a foe's Defence for 3 Turns",#description
		-standardTurnBuffLenght, #damage
		7, #cost
		15, #type
		"One", #targets
		0.5, #animation_time
		RebirthTexture #image
	)
	
	DefBuff = Move.new(
		"Defense Buff", #name
		"Increase's an ally's Defence for 3 Turns",#description
		standardTurnBuffLenght, #damage
		7, #cost
		13, #type
		"OneAlly", #targets
		0.5, #animation_time
		RebirthTexture #image
	)
	
	CritBoost = Move.new(
		"Critical Boost", #name
		"Increase's self Crit Chance for 7 Turns",#description
		8, #damage
		7, #cost
		16, #type
		"Self", #targets
		0.5, #animation_time
		RebirthTexture #image
	)
	
	OlympusPunch = Move.new(
		"Olympus Punch", #name
		"Small Blunt Damage To One Enemy",#description
		standardLowDamage, #damage
		15, #cost
		0, #type
		"One", #targets
		0.5, #animation_time
		OlympusPunchAnim #image
	)
	
	
	
	
	
	
	## WEAPONS
	
	
	## SOULS
	Messiah = Souls.new(
		"Messiah", #name
		"God whos death freed the souls of everyone on earth",#description
		[1,1,1,1,1,1,1,1,1,1,1,1], #affinities
		[1,1,1,1,1,1,1,1,1,1,1,1], #discovered affinities ( should be equal to the one above for allies )
		movesets[MovesetID.MOVESETMESSIAH], #specialmoves
		MessiahAnim, #animation
	)
	Zeus = Souls.new(
		"Zeus", #name
		"God whom is king of every other god",#description
		[1,1,1,1,1,1,1,1,1,1,1,1], #affinities
		[1,1,1,1,1,1,1,1,1,1,1,1], #discovered affinities ( should be equal to the one above for allies )
		movesets[MovesetID.MOVESETZEUS], #specialmoves
		ZeusAnim, #animation
	)
	
	Minotaur = Souls.new(
		"Minotaur", #name
		"Disgusting Creature Trapped in a labyrinth",#description
		[-1,1,2,1,1,1,1,1,1,1,1,1], #affinities
		[3,3,3,3,3,3,3,3,3,3,3,3], #discovered affinities ( should be equal to the one above for allies )
		movesets[MovesetID.TEST_MOVESET], #specialmoves
		TungTungAnim, #animation
	)
	
	## ALLIES
	
	Giocatore = Character.new(
		"Zisk", #name
		"Fatso useful for nothing, deserves to die",#description
		
		135, #max_hp
		65, #max_sp
		135, #hp
		65, #sp 
		
		ShortSword, #weapon
		Messiah, #soul 
		
		0,  #attack   / ONLY CHANGES DURING BATTLE
		0,	#defense  / ONLY CHANGES DURING BATTLE
		0,	#crit_chance  / ONLY CHANGES DURING BATTLE
		1.0,	#defense_from_parrying / ONLY CHANGES DURING BATTLE
		"Alive", #status  / ONLY CHANGES DURING BATTLE
		PlayerAnim #animation_frames
	)
	
	Beatrice = Character.new(
		"Beatrice", #name
		"Standard girl character n.2123123",#description
		
		100, #max_hp
		80, #max_sp
		100, #hp
		80, #sp 
		
		Shuriken, #weapon
		Zeus, #soul 
		
		0,  #attack   / ONLY CHANGES DURING BATTLE
		0,	#defense  / ONLY CHANGES DURING BATTLE
		0,	#crit_chance  / ONLY CHANGES DURING BATTLE
		1.0,	#defense_from_parrying / ONLY CHANGES DURING BATTLE
		"Alive", #status  / ONLY CHANGES DURING BATTLE
		AllyAnim #animation_frames
	)
	
	
	## ITEMS
	
	Potion = Item.new(
		"Small Potion", #name
		"Slightly Heals One Ally",#description
		-standardLowDamage, #damage
		0, #type
		PotionTexture, #image
	)
	
	BigPotion = Item.new(
		"Big Potion", #name
		"Decently Heals One Ally",#description
		-standardAvarageDamage, #damage
		0, #type
		FatPotionTexture, #image
	)
	
	WeirdPotion = Item.new(
		"Weird Potion", #name
		"Slightly Heals the whole Team",#description
		-standardLowDamage, #damage
		1, #type
		WeirdPotionTexture, #image
	)
	
	
	
	## ENEMIES
	MinotaurEnemy = Character.new(
		"Minotaur", #name
		"Disgusting creature",#description
		
		165, #max_hp
		100, #max_sp
		165, #hp
		100, #sp 
		
		MonsterFist, #weapon
		Minotaur, #soul 
		
		0,  #attack   / ONLY CHANGES DURING BATTLE
		0,	#defense  / ONLY CHANGES DURING BATTLE
		0,	#crit_chance  / ONLY CHANGES DURING BATTLE
		1.0,	#defense_from_parrying / ONLY CHANGES DURING BATTLE
		"Alive", #status  / ONLY CHANGES DURING BATTLE
		TungTungAnim #animation_frames
	)
	
	
	

	

func _on_start_game_pressed() -> void:
	StartGame.queue_free()
	StartingLabel.queue_free()
	var Battle = BattleScene.instantiate()
	add_child(Battle)
