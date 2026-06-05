extends Node

var LightBlindTexture = load("res://MovesSprites/LightBlindAnim.tres")
var ThunderSwordsTexture = load("res://MovesSprites/ThunderSwordsAnim.tres")
var RebirthTexture = load("res://MovesSprites/RebirthAnim.tres")
var OlympusPunchAnim = load("res://MovesSprites/OlympusPunchAnim.tres")

var MessiahAnim = load("res://Messiah.tres")
var ZeusAnim = load("res://Zeus.tres")

var TungTungAnim = load("res://Enemies/TungTungAnim.tres")
var AngelTungTungAnim = load("res://Enemies/TripleTAnim.tres")

var PotionTexture = load("res://Potion.png")
var FatPotionTexture = load("res://PotionObese.png")
var WeirdPotionTexture = load("res://PotionWeird.png")

@export var ThunderSwords = Node.new()
@export var LightBlind = Node.new()
@export var Rebirth = Node.new()
@export var OlympusPunch = Node.new()

@export var Potion = Node.new()
@export var BigPotion = Node.new()
@export var WeirdPotion = Node.new()

@export var Messiah = Node.new()
@export var Zeus = Node.new()
@export var movesets = [ [Rebirth, LightBlind] , [ThunderSwords, LightBlind, OlympusPunch] , [OlympusPunch] ]
@export var Items = [BigPotion,BigPotion,BigPotion, WeirdPotion, Potion, Potion, Potion]

@export var TungTung = AnimatedSprite2D.new()
@export var AngelTungTung = AnimatedSprite2D.new()


func _ready() -> void:
	
	ThunderSwords.set_meta("Name", "ThunderSwords")
	ThunderSwords.set_meta("Description", "Small Arcane Damage To One Enemy")
	ThunderSwords.set_meta("Damage", 35)
	ThunderSwords.set_meta("Cost", 12)
	ThunderSwords.set_meta("Type", 10)
	ThunderSwords.set_meta("AnimationTime", 1)
	ThunderSwords.set_meta("Image", ThunderSwordsTexture)
	
	LightBlind.set_meta("Name", "LightBlind")
	LightBlind.set_meta("Description", "Small Holy Damage To One Enemy")
	LightBlind.set_meta("Damage", 35)
	LightBlind.set_meta("Cost", 8)
	LightBlind.set_meta("Type", 9)
	LightBlind.set_meta("AnimationTime", 0.5)
	LightBlind.set_meta("Image", LightBlindTexture)
	
	Rebirth.set_meta("Name", "Rebirth")
	Rebirth.set_meta("Description", "Slightly Heals One Ally")
	Rebirth.set_meta("Damage", -35)
	Rebirth.set_meta("Cost", 7)
	Rebirth.set_meta("Type", 11)
	Rebirth.set_meta("AnimationTime", 0.5)
	Rebirth.set_meta("Image", RebirthTexture)
	
	OlympusPunch.set_meta("Name", "Olympus Punch")
	OlympusPunch.set_meta("Description", "Small Blunt Damage To One Enemy")
	OlympusPunch.set_meta("Damage", 35)
	OlympusPunch.set_meta("Cost", 15)
	OlympusPunch.set_meta("Type", 0)
	OlympusPunch.set_meta("AnimationTime", 0.5)
	OlympusPunch.set_meta("Image", OlympusPunchAnim)
	
	Messiah.set_meta("Name", "Messiah")
	Messiah.set_meta("SpecialMoves", movesets[0])
	Messiah.set_meta("Animation", MessiahAnim)
	
	Zeus.set_meta("Name", "Zeus")
	Zeus.set_meta("SpecialMoves", movesets[1])
	Zeus.set_meta("Animation", ZeusAnim)
	
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
	
	
	TungTung.set_meta("HP", 50)
	TungTung.set_meta("Name", "TTT")
	TungTung.set_meta("Damage", 20)
	TungTung.set_meta("Animation", 20)
	TungTung.set_meta("SpecialMoves", movesets[2])
	TungTung.set_sprite_frames(TungTungAnim)
	
	AngelTungTung.set_meta("HP", 75)
	AngelTungTung.set_meta("Name", "Angel TTT")
	AngelTungTung.set_meta("Damage", 25)
	AngelTungTung.set_meta("SpecialMoves", movesets[2])
	AngelTungTung.set_sprite_frames(AngelTungTungAnim)
	
	$Node2D._setting_up_enemies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
