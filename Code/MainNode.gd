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



@export var ThunderSwords = Node.new()
@export var Skeledeath = Node.new()
@export var LightBlind = Node.new()
@export var LightFlash = Node.new()

@export var Rebirth = Node.new()
@export var GreenFlower = Node.new()

@export var Mishinobu = Node.new()
@export var Meshinobu = Node.new()
@export var Mevinobu = Node.new()
@export var Mivinobu = Node.new()
@export var CritBoost = Node.new()
@export var OlympusPunch = Node.new()
@export var TestOlympusPunch = Node.new()


@export var Potion = Node.new()
@export var BigPotion = Node.new()
@export var WeirdPotion = Node.new()

@export var Messiah = Node.new()
@export var Zeus = Node.new()

enum MovesetID { MOVESETMESSIAH, MOVESETZEUS, TEST_MOVESET }
var movesets: Dictionary = {
	MovesetID.MOVESETMESSIAH: [LightFlash, LightBlind, CritBoost],
	MovesetID.MOVESETZEUS: [Skeledeath, Rebirth, Mishinobu, Meshinobu, Mevinobu, Mivinobu],
	MovesetID.TEST_MOVESET: [TestOlympusPunch]
}
@export var Items = [BigPotion,BigPotion,BigPotion, WeirdPotion, Potion, Potion, Potion]

@export var TungTung = AnimatedSprite2D.new()
@export var AngelTungTung = AnimatedSprite2D.new()

@export var Giocatore = AnimatedSprite2D.new()
@export var Beatrice = AnimatedSprite2D.new()

@export var ShortSword = Node.new()
@export var Shuriken = Node.new()

var standardLowDamage = 50
var standardAvarageDamage = 100
var standardHighDamage = 150
var standardSevereDamage = 200
var standardColossalDamage = 250
var standardUltimateDamage = 300

var standardTurnBuffLenght = 4

func _ready() -> void:
	## MOVES
	Skeledeath.set_meta("Name", "ThunderSwords")
	Skeledeath.set_meta("Description", "Small Ruin Damage To One Enemy")
	Skeledeath.set_meta("Damage", standardLowDamage)
	Skeledeath.set_meta("Cost", 8)
	Skeledeath.set_meta("Type", 3)
	Skeledeath.set_meta("Targets", "One")
	Skeledeath.set_meta("AnimationTime", 1)
	Skeledeath.set_meta("Image", ThunderSwordsTexture)
	
	ThunderSwords.set_meta("Name", "ThunderSwords")
	ThunderSwords.set_meta("Description", "Small Arcane Damage To One Enemy")
	ThunderSwords.set_meta("Damage", standardLowDamage)
	ThunderSwords.set_meta("Cost", 12)
	ThunderSwords.set_meta("Type", 10)
	ThunderSwords.set_meta("Targets", "One")
	ThunderSwords.set_meta("AnimationTime", 1)
	ThunderSwords.set_meta("Image", ThunderSwordsTexture)
	
	LightBlind.set_meta("Name", "LightBlind")
	LightBlind.set_meta("Description", "Small Holy Damage To One Enemy")
	LightBlind.set_meta("Damage", standardLowDamage)
	LightBlind.set_meta("Cost", 8)
	LightBlind.set_meta("Type", 9)
	LightBlind.set_meta("Targets", "One")
	LightBlind.set_meta("AnimationTime", 0.5)
	LightBlind.set_meta("Image", LightBlindTexture)
	
	LightFlash.set_meta("Name", "LightFlash")
	LightFlash.set_meta("Description", "Small Holy Damage To Every Enemy")
	LightFlash.set_meta("Damage", standardLowDamage)
	LightFlash.set_meta("Cost", 8)
	LightFlash.set_meta("Type", 9)
	LightFlash.set_meta("Targets", "AllEnemies")
	LightFlash.set_meta("AnimationTime", 0.5)
	LightFlash.set_meta("Image", LightBlindTexture)
	
	Rebirth.set_meta("Name", "Rebirth")
	Rebirth.set_meta("Description", "Slightly Heals One Ally")
	Rebirth.set_meta("Damage", -standardLowDamage)
	Rebirth.set_meta("Cost", 7)
	Rebirth.set_meta("Type", 11)
	Rebirth.set_meta("Targets", "OneAlly")
	Rebirth.set_meta("AnimationTime", 0.5)
	Rebirth.set_meta("Image", RebirthTexture)
	
	GreenFlower.set_meta("Name", "GreenFlower")
	GreenFlower.set_meta("Description", "Slightly Heals Every Ally")
	GreenFlower.set_meta("Damage", -standardLowDamage)
	GreenFlower.set_meta("Cost", 7)
	GreenFlower.set_meta("Type", 11)
	GreenFlower.set_meta("Targets", "AllAllies")
	GreenFlower.set_meta("AnimationTime", 0.5)
	GreenFlower.set_meta("Image", RebirthTexture)
	
	Mivinobu.set_meta("Name", "Mivinobu")
	Mivinobu.set_meta("Description", "Decreases's every foe's Attack for 3 Turns")
	Mivinobu.set_meta("Damage", -standardTurnBuffLenght)
	Mivinobu.set_meta("Cost", 7)
	Mivinobu.set_meta("Type", 14)
	Mivinobu.set_meta("Targets", "AllEnemies")
	Mivinobu.set_meta("AnimationTime", 0.5)
	Mivinobu.set_meta("Image", RebirthTexture)
	
	Mishinobu.set_meta("Name", "Mishinobu")
	Mishinobu.set_meta("Description", "Increase's every ally's ally's Attack for 3 Turns")
	Mishinobu.set_meta("Damage", standardTurnBuffLenght)
	Mishinobu.set_meta("Cost", 7)
	Mishinobu.set_meta("Type", 12)
	Mishinobu.set_meta("Targets", "AllAllies")
	Mishinobu.set_meta("AnimationTime", 0.5)
	Mishinobu.set_meta("Image", RebirthTexture)
	
	Mevinobu.set_meta("Name", "Mevinobu")
	Mevinobu.set_meta("Description", "Decreases's a foe's Defence for 3 Turns")
	Mevinobu.set_meta("Damage", -standardTurnBuffLenght)
	Mevinobu.set_meta("Cost", 7)
	Mevinobu.set_meta("Type", 15)
	Mevinobu.set_meta("Targets", "One")
	Mevinobu.set_meta("AnimationTime", 0.5)
	Mevinobu.set_meta("Image", RebirthTexture)
	
	Meshinobu.set_meta("Name", "Meshinobu")
	Meshinobu.set_meta("Description", "Increase's an ally's Defence for 3 Turns")
	Meshinobu.set_meta("Damage", standardTurnBuffLenght)
	Meshinobu.set_meta("Cost", 7)
	Meshinobu.set_meta("Type", 13)
	Meshinobu.set_meta("Targets", "OneAlly")
	Meshinobu.set_meta("AnimationTime", 0.5)
	Meshinobu.set_meta("Image", RebirthTexture)
	
	CritBoost.set_meta("Name", "CritBoost")
	CritBoost.set_meta("Description", "Increase's self Crit Chance for 7 Turns")
	CritBoost.set_meta("Damage", 8)
	CritBoost.set_meta("Cost", 7)
	CritBoost.set_meta("Type", 16)
	CritBoost.set_meta("Targets", "Self")
	CritBoost.set_meta("AnimationTime", 0.5)
	CritBoost.set_meta("Image", RebirthTexture)
	
	OlympusPunch.set_meta("Name", "Olympus Punch")
	OlympusPunch.set_meta("Description", "Small Blunt Damage To One Enemy")
	OlympusPunch.set_meta("Damage", standardLowDamage)
	OlympusPunch.set_meta("Cost", 15)
	OlympusPunch.set_meta("Type", 0)
	OlympusPunch.set_meta("Targets", "One")
	OlympusPunch.set_meta("AnimationTime", 0.5)
	OlympusPunch.set_meta("Image", OlympusPunchAnim)
	
	TestOlympusPunch.set_meta("Name", "Olympus Punch")  # MADE FOR ENEMIES SO THEY DON'T INSTANTLY RAPE THE PLAYER
	TestOlympusPunch.set_meta("Description", "Small Blunt Damage To One Enemy")
	TestOlympusPunch.set_meta("Damage", 10)
	TestOlympusPunch.set_meta("Cost", 0)
	TestOlympusPunch.set_meta("Type", 0)
	TestOlympusPunch.set_meta("Targets", "One")
	TestOlympusPunch.set_meta("AnimationTime", 0.5)
	TestOlympusPunch.set_meta("Image", OlympusPunchAnim)
	
	## ALLIES
	Giocatore.set_meta("HP", 135)
	Giocatore.set_meta("SP", 65)
	Giocatore.set_meta("maxHP", 135)
	Giocatore.set_meta("maxSP", 65)
	Giocatore.set_meta("Weapon", ShortSword)
	Giocatore.set_meta("DefenseFromParrying", 1.0)
	Giocatore.set_meta("Defense", 0)
	Giocatore.set_meta("Attack", 0)
	Giocatore.set_meta("CritChance", 0)
	Giocatore.set_meta("Status", "Alive")
	Giocatore.set_meta("Name", "Ren")
	Giocatore.set_meta("Animation", PlayerAnim)
	Giocatore.set_meta("CharacterGod", Messiah)
	
	Beatrice.set_meta("HP", 100)
	Beatrice.set_meta("SP", 80)
	Beatrice.set_meta("maxHP", 100)
	Beatrice.set_meta("maxSP", 80)
	Beatrice.set_meta("Weapon", Shuriken)
	Beatrice.set_meta("DefenseFromParrying", 1.0)
	Beatrice.set_meta("Defense", 0)
	Beatrice.set_meta("Attack", 0)
	Beatrice.set_meta("CritChance", 0)
	Beatrice.set_meta("Status", "Alive")
	Beatrice.set_meta("Name", "Loki")
	Beatrice.set_meta("Animation", AllyAnim)
	Beatrice.set_meta("CharacterGod", Zeus)
	
	## WEAPONS
	ShortSword.set_meta("Damage", 10)
	ShortSword.set_meta("DamageType", 2)
	Shuriken.set_meta("Damage", 5)
	Shuriken.set_meta("DamageType", 1)
	
	
	## GODS? I HAVE TO COME UP WITH A NAME DAMN
	Messiah.set_meta("Name", "Messiah")
	Messiah.set_meta("Affinities", [1,1,1,1,1,1,1,1,1,1,1,1] )
	Messiah.set_meta("SpecialMoves", movesets[MovesetID.MOVESETMESSIAH])
	Messiah.set_meta("Animation", MessiahAnim)
	
	Zeus.set_meta("Name", "Zeus")
	Zeus.set_meta("Affinities", [1,1,1,1,1,1,1,1,1,1,1,1] )
	Zeus.set_meta("SpecialMoves", movesets[MovesetID.MOVESETZEUS])
	Zeus.set_meta("Animation", ZeusAnim)
	
	## ITEMS
	
	Potion.set_meta("Name", "Small Potion")
	Potion.set_meta("Description", "Slightly Heals One Ally")
	Potion.set_meta("Damage", -35)
	Potion.set_meta("Type", 0)
	Potion.set_meta("Image", PotionTexture)
	
	BigPotion.set_meta("Name", "Big Potion")
	BigPotion.set_meta("Description", "Decently Heals One Ally")
	BigPotion.set_meta("Damage", -85)
	BigPotion.set_meta("Type", 0)
	BigPotion.set_meta("Image", FatPotionTexture)
	
	WeirdPotion.set_meta("Name", "Weird Potion")
	WeirdPotion.set_meta("Description", "Slightly Heals the whole Team")
	WeirdPotion.set_meta("Damage", -35)
	WeirdPotion.set_meta("Type", 1)
	WeirdPotion.set_meta("Image", WeirdPotionTexture)
	
	## ENEMIES
	
	TungTung.set_meta("HP", 165)
	TungTung.set_meta("maxHP", 165)
	TungTung.set_meta("Name", "TTT")
	TungTung.set_meta("Damage", 5)
	TungTung.set_meta("DamageType", 0)
	TungTung.set_meta("Defense", 0)
	TungTung.set_meta("Attack", 0)
	TungTung.set_meta("CritChance", 0)
	TungTung.set_meta("Status", "Alive")
	TungTung.set_meta("SpecialMoves", movesets[MovesetID.TEST_MOVESET])
	TungTung.set_meta("Affinities", [-1,1,2,1,1,1,1,1,1,1,1,1] )
	TungTung.set_meta("DiscoveredAffinities", [3,3,3,3,3,3,3,3,3,3,3,3] )
	TungTung.set_sprite_frames(TungTungAnim)
	
	AngelTungTung.set_meta("HP", 125)
	AngelTungTung.set_meta("maxHP", 125)
	AngelTungTung.set_meta("Name", "Angel TTT")
	AngelTungTung.set_meta("Damage", 10)
	AngelTungTung.set_meta("DamageType", 0)
	AngelTungTung.set_meta("Defense", 0)
	AngelTungTung.set_meta("Attack", 0)
	AngelTungTung.set_meta("CritChance", 0)
	AngelTungTung.set_meta("Status", "Alive")
	AngelTungTung.set_meta("SpecialMoves", movesets[MovesetID.TEST_MOVESET])
	AngelTungTung.set_meta("Affinities", [1,2,-1,2,1,1,1,1,1,0.5,1,1] )
	AngelTungTung.set_meta("DiscoveredAffinities", [3,3,3,3,3,3,3,3,3,3,3,3] )
	AngelTungTung.set_sprite_frames(AngelTungTungAnim)
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_pressed() -> void:
	StartGame.queue_free()
	StartingLabel.queue_free()
	var Battle = BattleScene.instantiate()
	add_child(Battle)
