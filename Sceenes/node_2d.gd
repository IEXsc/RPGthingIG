extends Node2D

var EmptyBar = load("res://Assets/GFX/AlliesorYourself/HPindicators/HPbar(s)/HPBAREMPTY.png")
var FullHPBar = load("res://Assets/GFX/AlliesorYourself/HPindicators/HPbar(s)/HPBARFULL.png")
var FullSPBar = load("res://Assets/GFX/AlliesorYourself/HPindicators/HPbar(s)/SPBARFULL.png")

var HittingWeaknessTexture = load("res://Assets/GFX/Cutaways/HitAWeaknessGeneric.tres")
var AllOutAttackTexture = load("res://Assets/GFX/Cutaways/AlloutAttackSprite.tres")

var AbsorbsTexture = load("res://Assets/GFX/Enemies/HealthBars/Absorbe.png")
var ResistsTexture = load("res://Assets/GFX/Enemies/HealthBars/Resists.png")
var WeakTexture = load("res://Assets/GFX/Enemies/HealthBars/Weak.png")
var UnknownTexture = load("res://Assets/GFX/Enemies/HealthBars/Unknown.png")

var ATK_DOWNTexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/ATK_DOWN.png")
var ATK_UPTexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/ATK_UP.png")
var ATK_NEUTRALTexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/ATK_NEUTRAL.png")
var DEF_DOWNexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/DEF_DOWN.png")
var DEF_UPTexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/DEF_UP.png")
var DEF_NEUTRALTexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/DEF_NEUTRAL.png")
var CRIT_DOWNexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/CRI_DOWN.png")
var CRIT_UPTexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/CRI_UP.png")
var CRIT_NEUTRALTexture = load("res://Assets/GFX/Enemies/HealthBars/BuffsorDebuffs/CRI_NEUTRAL.png")


##var TypeTextures = [AbsorbsTexture, ResistsTexture, WeakTexture]

var EnemyHPFull = load("res://Assets/GFX/Enemies/HealthBars/EnemyFullHealth.png")
var EnemyHPEmpty = load("res://Assets/GFX/Enemies/HealthBars/EnemyEmptyHealth.png")

var BluntTexture = load("res://Assets/GFX/MoveTypes/Physical/Blunt.png")
var PierceTexture = load("res://Assets/GFX/MoveTypes/Physical/Pierce.png")
var SlashTexture = load("res://Assets/GFX/MoveTypes/Physical/Slash.png")

var RuinTexture = load("res://Assets/GFX/MoveTypes/Magic/Ruin.png")
var LifeTexture = load("res://Assets/GFX/MoveTypes/Magic/Life.png")
var TimeTexture = load("res://Assets/GFX/MoveTypes/Magic/Time.png")
var SpaceTexture = load("res://Assets/GFX/MoveTypes/Magic/Space.png")
var MindTexture = load("res://Assets/GFX/MoveTypes/Magic/Mind.png")
var ChthonicTexture = load("res://Assets/GFX/MoveTypes/Magic/Chthonic.png")
var HolyTexture = load("res://Assets/GFX/MoveTypes/Magic/Holy.png")
var ArcaneTexture = load("res://Assets/GFX/MoveTypes/Magic/Arcane.png")
var HealingTexture = load("res://Assets/GFX/MoveTypes/Magic/Healing.png")

var AttackBonusTexture = load("res://Assets/GFX/MoveTypes/BuffsorDebuffs/AttackBuff.png")
var DefenseBonusTexture = load("res://Assets/GFX/MoveTypes/BuffsorDebuffs/DefenseBonus.png")
var AttackDebuffTexture = load("res://Assets/GFX/MoveTypes/BuffsorDebuffs/AttackDeBuff.png")
var DefenseDebuffTexture = load("res://Assets/GFX/MoveTypes/BuffsorDebuffs/DefenseDebuff.png")
var CritMovesTexture = load("res://Assets/GFX/MoveTypes/BuffsorDebuffs/CritMoves.png")


var arrayAttackTypesIcons = [BluntTexture, PierceTexture, SlashTexture,RuinTexture, LifeTexture, TimeTexture,SpaceTexture, MindTexture, ChthonicTexture,HolyTexture, ArcaneTexture, HealingTexture, AttackBonusTexture, DefenseBonusTexture , AttackDebuffTexture , DefenseDebuffTexture, CritMovesTexture]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func starting_buttons():
	find_child("FlowContainer")._show_buttons()
