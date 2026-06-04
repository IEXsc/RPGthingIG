## TO DO: MAKE SKILLS A LIST TOO
## GIVE THE ENEMIES COOL MOVES

## https://docs.google.com/spreadsheets/d/1moa-AuzmRn1FMVouLuWMqBgxDgxjbl1clZQZNK0O6sg/edit?gid=0#gid=0
## FOR SKILL TYPES

extends Node2D

@onready var Text = $Label
@onready var Pulsante = $Button
@onready var nem1 = $Nem1
@onready var nem2 = $Nem2
@onready var nem3 = $Nem3
@onready var Giocatore = $Player
@onready var Ally = $Ally
@onready var stats = $Stats
@onready var AttackButton = $Attack
@onready var SkillButton = $Skill
@onready var DefendButton = $Defend
@onready var BackButton = $Back
@onready var ItemsButton = $Items
@onready var PlayerInfo = $PlayerInfo
@onready var BattleLog = $Summary

@onready var SelectingEnemyAnim = load("res://SelectingEnemyButton.tres")
@onready var MessiahAnim = load("res://Messiah.tres")
@onready var ZeusAnim = load("res://Zeus.tres")


var timer = Timer.new()
### TEXTURES
var LightBlindTexture = load("res://MovesSprites/LightBlindAnim.tres")
var ThunderSwordsTexture = load("res://MovesSprites/ThunderSwordsAnim.tres")
var RebirthTexture = load("res://MovesSprites/RebirthAnim.tres")
var OlympusPunchAnim = load("res://MovesSprites/OlympusPunchAnim.tres")


var MessiahTexture1 = load("res://God1.png")
var MessiahTexture2 = load("res://God2.png")

var BluntTexture = load("res://Blunt.png")
var PierceTexture = load("res://Pierce.png")
var SlashTexture = load("res://Slash.png")

var RuinTexture = load("res://Ruin.png")
var LifeTexture = load("res://Life.png")
var TimeTexture = load("res://Time.png")
var SpaceTexture = load("res://Space.png")
var MindTexture = load("res://Mind.png")
var ChthonicTexture = load("res://Chthonic.png")
var HolyTexture = load("res://Holy.png")
var ArcaneTexture = load("res://Arcane.png")
var HealingTexture = load("res://Healing.png")


var PotionTexture = load("res://Potion.png")
var FatPotionTexture = load("res://PotionObese.png")
var WeirdPotionTexture = load("res://PotionWeird.png")
##0 Blunt	1Pierce	2Slash |	3Ruin	4Life	5Time	6Space	7Mind	8Chthonic	9Holy	10Arcane	11Healing
var arrayAttackTypesIcons = [BluntTexture, PierceTexture, SlashTexture,RuinTexture, LifeTexture, TimeTexture,SpaceTexture, MindTexture, ChthonicTexture,HolyTexture, ArcaneTexture, HealingTexture]
var arrayenemies = []
var arrayalleati = []
var skillbuttons = []
var itembuttons = []
var battlelogarray = []
var enemytargetbuttons = []
var Items = []

var targetenemy = 0
var i = 0
var text = ""
var battlelogtext = ""
var recentaction = 0
var currentenemymove = 0
var currentpartymember = 0
var currentusedskill = 0
var currentturn = 0
var alliedtarget = 0
var currentuseditem = 0
var enemyaction = 0
var atleastonecharalive = true
func _ready() -> void:
	randomize()
	BattleLog.text = "Summary: 
	"
	
	var ThunderSwords = Node.new()
	ThunderSwords.set_meta("Name", "ThunderSwords")
	ThunderSwords.set_meta("Description", "Small Arcane Damage To One Enemy")
	ThunderSwords.set_meta("Damage", 35)
	ThunderSwords.set_meta("Cost", 12)
	ThunderSwords.set_meta("Type", 10)
	ThunderSwords.set_meta("AnimationTime", 1)
	ThunderSwords.set_meta("Image", ThunderSwordsTexture)
	var LightBlind = Node.new()
	LightBlind.set_meta("Name", "LightBlind")
	LightBlind.set_meta("Description", "Small Holy Damage To One Enemy")
	LightBlind.set_meta("Damage", 35)
	LightBlind.set_meta("Cost", 8)
	LightBlind.set_meta("Type", 9)
	LightBlind.set_meta("AnimationTime", 0.5)
	LightBlind.set_meta("Image", LightBlindTexture)
	var Rebirth = Node.new()
	Rebirth.set_meta("Name", "Rebirth")
	Rebirth.set_meta("Description", "Slightly Heals One Ally")
	Rebirth.set_meta("Damage", -35)
	Rebirth.set_meta("Cost", 7)
	Rebirth.set_meta("Type", 11)
	Rebirth.set_meta("AnimationTime", 0.5)
	Rebirth.set_meta("Image", RebirthTexture)
	var OlympusPunch = Node.new()
	OlympusPunch.set_meta("Name", "Olympus Punch")
	OlympusPunch.set_meta("Description", "Small Blunt Damage To One Enemy")
	OlympusPunch.set_meta("Damage", 35)
	OlympusPunch.set_meta("Cost", 15)
	OlympusPunch.set_meta("Type", 0)
	OlympusPunch.set_meta("AnimationTime", 0.5)
	OlympusPunch.set_meta("Image", OlympusPunchAnim)
	
	var movesets = [ [Rebirth, LightBlind] , [ThunderSwords, LightBlind, OlympusPunch] , [OlympusPunch] ]
	
	var Potion = Node.new()
	Potion.set_meta("Name", "Small Potion")
	Potion.set_meta("Description", "Slightly Heals One Ally")
	Potion.set_meta("Damage", -35)
	Potion.set_meta("Type", 0)
	Potion.set_meta("Image", PotionTexture)
	var BigPotion = Node.new()
	BigPotion.set_meta("Name", "Big Potion")
	BigPotion.set_meta("Description", "Decently Heals One Ally")
	BigPotion.set_meta("Damage", -85)
	BigPotion.set_meta("Type", 0)
	BigPotion.set_meta("Image", FatPotionTexture)
	var WeirdPotion = Node.new()
	WeirdPotion.set_meta("Name", "Weird Potion")
	WeirdPotion.set_meta("Description", "Slightly Heals the whole Team")
	WeirdPotion.set_meta("Damage", -35)
	WeirdPotion.set_meta("Type", 1)
	WeirdPotion.set_meta("Image", WeirdPotionTexture)
	Items = [BigPotion,BigPotion,BigPotion, WeirdPotion, Potion, Potion, Potion]
	 
	nem1.play("waiting")
	nem1.set_meta("HP", 50)
	nem1.set_meta("Name", "Marco")
	nem1.set_meta("Damage", 20)
	nem1.set_meta("SpecialMoves", movesets[2])
	
	nem2.play("waiting")
	nem2.set_meta("HP", 75)
	nem2.set_meta("Name", "Aurelio")
	nem2.set_meta("Damage", 25)
	nem2.set_meta("SpecialMoves", movesets[2])
	
	nem3.play("waiting")
	nem3.set_meta("HP", 50)
	nem3.set_meta("Name", "Marco")
	nem3.set_meta("Damage", 20)
	nem3.set_meta("SpecialMoves", movesets[2])
	
	arrayenemies = [nem1, nem2, nem3]
	arrayalleati = [Giocatore, Ally]
	
	var Messiah = Node.new()
	Messiah.set_meta("Name", "Messiah")
	Messiah.set_meta("SpecialMoves", movesets[0])
	Messiah.set_meta("Animation", MessiahAnim)
	
	Giocatore.play("waiting")
	Giocatore.set_meta("HP", 135)
	Giocatore.set_meta("SP", 65)
	Giocatore.set_meta("maxHP", 135)
	Giocatore.set_meta("maxSP", 65)
	Giocatore.set_meta("Damage", 5)
	Giocatore.set_meta("DamageType", 0)
	Giocatore.set_meta("Defense", 1.0)
	Giocatore.set_meta("Attack", 1.0)
	Giocatore.set_meta("Name", "Ren")
	Giocatore.set_meta("CharacterGod", Messiah)
	
	
	var Zeus = Node.new()
	Zeus.set_meta("Name", "Zeus")
	Zeus.set_meta("SpecialMoves", movesets[1])
	Zeus.set_meta("Animation", ZeusAnim)
	
	Ally.play("waiting")
	Ally.set_meta("HP", 100)
	Ally.set_meta("SP", 80)
	Ally.set_meta("maxHP", 100)
	Ally.set_meta("maxSP", 80)
	Ally.set_meta("Damage", 10)
	Ally.set_meta("DamageType", 2)
	Ally.set_meta("Defense", 1.0)
	Ally.set_meta("Attack", 1.0)
	Ally.set_meta("Name", "Loki")
	Ally.set_meta("CharacterGod", Zeus)
		
		
	_show_button()
	AttackButton.pressed.connect(_attack_button_pressed)
	AttackButton.set_button_icon(arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("DamageType")])
	SkillButton.pressed.connect(_skill_button_pressed)
	BackButton.pressed.connect(_back_button_pressed)
	DefendButton.pressed.connect(_defend_button_pressed)
	ItemsButton.pressed.connect(_item_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in len(arrayalleati):
		text = text + arrayalleati[i].get_meta("Name") + "
		"+ str(arrayalleati[i].get_meta("HP")) + " HP remaining" +"
		"+ str(arrayalleati[i].get_meta("SP")) + " SP remaining" +"
		
		"
	PlayerInfo.text = text 
	text = ""
	
		
func _calculate_total_enemies_buttons():
	for i in range(arrayenemies.size() - 1, -1, -1):
		var enemy = arrayenemies[i]
		if is_instance_valid(enemy):
			if enemy.get_meta("HP") <= 0:
				enemy.queue_free()
				arrayenemies.remove_at(i) # Removes it from the array so it's not checked next time

	
		
func _target_button_pressed(pulsanteid):
	targetenemy = pulsanteid
	if(recentaction==1):
		alliedtarget = arrayenemies
		var newhp = alliedtarget[targetenemy].get_meta("HP") - arrayalleati[currentpartymember].get_meta("Damage")
		alliedtarget[targetenemy].set_meta("HP", newhp)
	if(recentaction==4):
		var movetype = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Type")
		var newsp = arrayalleati[currentpartymember].get_meta("SP") - arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Cost")
		arrayalleati[currentpartymember].set_meta("SP", newsp)
		if(movetype<11):
			alliedtarget = arrayenemies
			var newhp = alliedtarget[targetenemy].get_meta("HP") - arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
			alliedtarget[targetenemy].set_meta("HP", newhp)
		elif(movetype==11):
			alliedtarget = arrayalleati
			var newhp = alliedtarget[targetenemy].get_meta("HP") - arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
			if(newhp>alliedtarget[targetenemy].get_meta("maxHP")):
				newhp = alliedtarget[targetenemy].get_meta("maxHP")
				alliedtarget[targetenemy].set_meta("HP", newhp)
			else:
				alliedtarget[targetenemy].set_meta("HP", newhp)
				if(alliedtarget[targetenemy].get_meta("HP")>0):
					alliedtarget[targetenemy].play("waiting")
		var SkillBeingUsed = AnimatedSprite2D.new()
		skillbuttons.append(SkillBeingUsed)
		add_child(SkillBeingUsed)
		SkillBeingUsed.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y)
		SkillBeingUsed.set_sprite_frames(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Image"))
		SkillBeingUsed.play("default")
	if(recentaction==6):
		if(Items[currentuseditem].get_meta("Type")==0):
			alliedtarget = arrayalleati
			var newhp = alliedtarget[targetenemy].get_meta("HP") - Items[currentuseditem].get_meta("Damage")
			if(newhp>alliedtarget[targetenemy].get_meta("maxHP")):
				newhp = alliedtarget[targetenemy].get_meta("maxHP")
				alliedtarget[targetenemy].set_meta("HP", newhp)
			else:
				alliedtarget[targetenemy].set_meta("HP", newhp)	
				if(alliedtarget[targetenemy].get_meta("HP")>0):
					alliedtarget[targetenemy].play("waiting")
		elif(Items[currentuseditem].get_meta("Type")==1):
			alliedtarget = arrayalleati
			for i in range(len(alliedtarget)):
				var newhp = alliedtarget[i].get_meta("HP") - Items[currentuseditem].get_meta("Damage")
				if(newhp>alliedtarget[i].get_meta("maxHP")):
					newhp = alliedtarget[i].get_meta("maxHP")
					alliedtarget[i].set_meta("HP", newhp)
				else:
					alliedtarget[i].set_meta("HP", newhp)	
					if(alliedtarget[i].get_meta("HP")>0):
						alliedtarget[i].play("waiting")
	for i in len(enemytargetbuttons):
		enemytargetbuttons[i].queue_free()
	enemytargetbuttons = []
	_start_le_timer()

func _attack_button_pressed():
	if(recentaction==0):
			
		arrayalleati[currentpartymember].position = Vector2(arrayalleati[currentpartymember].position.x, arrayalleati[currentpartymember].position.y - 50)
		recentaction = 1
		timer.wait_time = 0.2
		_create_targeting_buttons()
	
func _defend_button_pressed():
	if(recentaction==0):
		var newdefence = arrayalleati[currentpartymember].get_meta("Defense") + 0.5 
		arrayalleati[currentpartymember].set_meta("Defense", newdefence) 
		recentaction = 2
		timer.wait_time = 0.2
		_start_le_timer()

func _item_button_pressed():
	if(recentaction==0):
		if(len(Items)!=0):
			var itemList = ItemList.new()
			itembuttons.append(itemList)
			add_child(itemList)
			itemList.custom_minimum_size = Vector2(500, 200)
			itemList.position = Vector2(50, 320+(40*((i+1)*1.5)))
			itemList.item_selected.connect(_on_itemList_item_selected)
			for i in range(len(Items)):
				itemList.add_item(Items[i].get_meta("Name") + "|" + Items[i].get_meta("Description"), Items[i].get_meta("Image"))
			recentaction = 5
		else:
			_back_button_pressed()

func _on_itemList_item_selected(index):
	if(recentaction==5):
		timer.wait_time = 0.1
		currentuseditem = index
		for i in range(itembuttons[0].get_item_count()):
			itembuttons[0].set_item_selectable(i, false)
		if(Items[currentuseditem].get_meta("Type")==0):
			recentaction = 6
			_create_targeting_buttons()
		else:
			recentaction = 6
			_target_button_pressed(0)

func _skill_button_pressed():
	if(recentaction==0):
		var skillList = ItemList.new()
		skillbuttons.append(skillList)
		add_child(skillList)
		skillList.custom_minimum_size = Vector2(500, 200)
		skillList.position = Vector2(50, 320+(40*((i+1)*1.5)))
		skillList.item_selected.connect(_on_skillList_item_selected)
		
		var PERSONA = AnimatedSprite2D.new()
		skillbuttons.append(PERSONA)
		add_child(PERSONA)
		PERSONA.set_sprite_frames(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("Animation"))
		PERSONA.play("waiting")
		arrayalleati[currentpartymember].play("Charging")
		PERSONA.position = Vector2(arrayalleati[currentpartymember].position.x+55, arrayalleati[currentpartymember].position.y+5)
		for i in range(len(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves"))):
			skillList.add_item(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[i].get_meta("Name") + "|" + arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[i].get_meta("Description"), arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[i].get_meta("Type")])
		recentaction = 3

func _on_skillList_item_selected(index):
	if(recentaction==3):
		timer.wait_time = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[index].get_meta("AnimationTime")
		currentusedskill = index
		for i in range(skillbuttons[0].get_item_count()):
			skillbuttons[0].set_item_selectable(i, false)
		if(arrayalleati[currentpartymember].get_meta("SP")>=arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[index].get_meta("Cost")):
			recentaction = 4
			_create_targeting_buttons()
		else:
			_back_button_pressed()

func _back_button_pressed():
	for i in len(enemytargetbuttons):
		enemytargetbuttons[i].queue_free()
	enemytargetbuttons = []
	if(recentaction!=0):
		arrayalleati[currentpartymember].play("waiting")
		if(recentaction==1):
			arrayalleati[currentpartymember].position.y = arrayalleati[currentpartymember].position.y + 50
			recentaction = 0
		if(recentaction==3):
			for i in len(skillbuttons):
				skillbuttons[i].queue_free()
			skillbuttons = []
			recentaction = 0
		if(recentaction==4):
			for i in range(skillbuttons[0].get_item_count()):
				skillbuttons[0].set_item_selectable(i, true)
			skillbuttons[0].deselect_all()
			recentaction = 3
		if(recentaction==5):
			for i in len(itembuttons):
				itembuttons[i].queue_free()
			itembuttons = []
			recentaction = 0
		if(recentaction==6):
			for i in range(itembuttons[0].get_item_count()):
				itembuttons[0].set_item_selectable(i, true)
			itembuttons[0].deselect_all()
			recentaction = 5
	
	

func _enemyturn():
	for i in len(enemytargetbuttons):
		enemytargetbuttons[i].queue_free()
	enemytargetbuttons = []
	_hide_button()
	_singleenemyturn()
		
func _singleenemyturn():
	for i in range(len(arrayalleati)):
		if(arrayalleati[i].get_meta("HP")>0):
			atleastonecharalive = true
			break
		else:
			atleastonecharalive = false
	if(atleastonecharalive==true):
		var choosenattacktarget = arrayalleati.pick_random()
		while(choosenattacktarget.get_meta("HP")<=0):
			choosenattacktarget = arrayalleati.pick_random()
		var enemytimer = Timer.new()
		if(currentenemymove<len(arrayenemies)):
						
			enemyaction = randi_range(1, 2) 
			if(enemyaction== 1):
				arrayenemies[currentenemymove].position = Vector2(arrayenemies[currentenemymove].position.x, arrayenemies[currentenemymove].position.y + 50)
				var newhp = choosenattacktarget.get_meta("HP") - int(round(( arrayenemies[currentenemymove].get_meta("Damage") / choosenattacktarget.get_meta("Defense"))))
				choosenattacktarget.set_meta("HP", newhp)
				battlelogarray.append(arrayenemies[currentenemymove].get_meta("Name") + " Attacked " + choosenattacktarget.get_meta("Name")  + " (New Hp) " + str(choosenattacktarget.get_meta("HP")))
				_update_battle_log()
				if(choosenattacktarget.get_meta("HP")<=0):
					choosenattacktarget.play("Faint")
				enemytimer.wait_time = 0.2
			if(enemyaction==2):
				var SkillBeingUsed = AnimatedSprite2D.new()
				currentusedskill = SkillBeingUsed
				add_child(SkillBeingUsed)
				SkillBeingUsed.position = Vector2(choosenattacktarget.position.x, choosenattacktarget.position.y)
				var currentmove = randi_range(0, len(arrayenemies[currentenemymove].get_meta("SpecialMoves"))-1)
				SkillBeingUsed.set_sprite_frames(arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Image"))
				SkillBeingUsed.play("default")
				battlelogarray.append(arrayenemies[currentenemymove].get_meta("Name") + " Casted " + arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Name") + " on " + choosenattacktarget.get_meta("Name")+ " (New Hp) " + str(choosenattacktarget.get_meta("HP")))
				_update_battle_log()
				enemytimer.wait_time = arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("AnimationTime")
				var newhp = choosenattacktarget.get_meta("HP") - int(round(( arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Damage") / choosenattacktarget.get_meta("Defense"))))
				choosenattacktarget.set_meta("HP", newhp)
				
			add_child(enemytimer)
			enemytimer.timeout.connect(_timer_moving_back.bind(enemytimer))
			enemytimer.start()	
		else:
			battlelogarray.append("-------------------------------------")
			_update_battle_log()
			_reset_ally_positions()
			enemytimer.queue_free()
			currentusedskill = 0
			currentenemymove = 0
	elif(atleastonecharalive==false):
		_losing_the_battle()
		
func _timer_moving_back(timerx):
	#for i in len(arrayenemies):
	if(enemyaction==1):
		arrayenemies[currentenemymove].position = Vector2(arrayenemies[currentenemymove].position.x, arrayenemies[currentenemymove].position.y - 50)
	elif(enemyaction==2):
		currentusedskill.queue_free()
	currentenemymove = currentenemymove + 1
	_singleenemyturn()
	timerx.queue_free()


func _reset_ally_positions():
	for i in len(arrayalleati):
		if(arrayalleati[i].get_meta("HP")>0):
			arrayalleati[i].play("waiting")
		else:
			arrayalleati[i].play("Faint")
		arrayalleati[i].set_meta("Defense", 1)
		arrayalleati[i].set_meta("Attack", 1)
	_show_button()
	
	
	
func _on_timer_timeout():
	if(arrayalleati[currentpartymember].get_meta("HP")>0):
		arrayalleati[currentpartymember].play("waiting")
	for i in len(enemytargetbuttons):
		enemytargetbuttons[i].queue_free()
	enemytargetbuttons = []
	if(recentaction==1):
		arrayalleati[currentpartymember].position = Vector2(arrayalleati[currentpartymember].position.x, arrayalleati[currentpartymember].position.y + 50)
		battlelogarray.append(arrayalleati[currentpartymember].get_meta("Name") + " Attacked " + arrayenemies[targetenemy].get_meta("Name")  + " (New Hp) " + str(arrayenemies[targetenemy].get_meta("HP")))
	if(recentaction==2):
		arrayalleati[currentpartymember].play("Defend")
		battlelogarray.append(arrayalleati[currentpartymember].get_meta("Name") + " is Defending ")
	if(recentaction==4):
		battlelogarray.append(arrayalleati[currentpartymember].get_meta("Name") + " Casted " + arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Name") + " on " + alliedtarget[targetenemy].get_meta("Name")+ " (New Hp) " + str(alliedtarget[targetenemy].get_meta("HP")))
		for i in len(skillbuttons):
			skillbuttons[i].queue_free()
		skillbuttons = []
	if(recentaction==6):
		for i in len(itembuttons):
			itembuttons[i].queue_free()
		itembuttons = []
		if(Items[currentuseditem].get_meta("Type")==0):
			battlelogarray.append(arrayalleati[currentpartymember].get_meta("Name") + " used " + Items[currentuseditem].get_meta("Name") + " on " + alliedtarget[targetenemy].get_meta("Name"))
		elif(Items[currentuseditem].get_meta("Type")==1):
			battlelogarray.append(arrayalleati[currentpartymember].get_meta("Name") + " used " + Items[currentuseditem].get_meta("Name") + " on the whole team")
		Items.remove_at(currentuseditem)
	_calculate_total_enemies_buttons()
	recentaction = 0
	_update_battle_log()
	if(currentturn<len(arrayalleati)-1):
		currentpartymember = currentpartymember + 1
		currentturn = currentpartymember
		if(arrayalleati[currentturn].get_meta("HP")<=0):
			_on_timer_timeout()
		AttackButton.set_button_icon(arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("DamageType")])
	else:
		currentturn = 0
		currentpartymember = 0
		AttackButton.set_button_icon(arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("DamageType")])
		_enemyturn()
	timer.stop()


	



func _create_targeting_buttons():
	if(recentaction==4):
		var movetype = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Type")
		if(movetype < 11):
			for i in len(arrayenemies):
				var buttonx = Button.new()
				add_child(buttonx)
				enemytargetbuttons.append(buttonx)
				buttonx.flat = true
				buttonx.position = Vector2(arrayenemies[i].position.x -36, arrayenemies[i].position.y - 36)
				buttonx.set_button_icon(SelectingEnemyAnim)
				buttonx.pressed.connect(_target_button_pressed.bind(i))
		if(movetype == 11):
			for i in len(arrayalleati):
				var buttonx = Button.new()
				add_child(buttonx)
				enemytargetbuttons.append(buttonx)
				buttonx.flat = true
				buttonx.position = Vector2(arrayalleati[i].position.x -36, arrayalleati[i].position.y - 36)
				buttonx.set_button_icon(SelectingEnemyAnim)
				buttonx.pressed.connect(_target_button_pressed.bind(i))
	elif(recentaction==6):
		var itemtype = Items[currentuseditem].get_meta("Type")
		if(itemtype == 0):
			for i in len(arrayalleati):
				var buttonx = Button.new()
				add_child(buttonx)
				enemytargetbuttons.append(buttonx)
				buttonx.flat = true
				buttonx.position = Vector2(arrayalleati[i].position.x -36, arrayalleati[i].position.y - 36)
				buttonx.set_button_icon(SelectingEnemyAnim)
				buttonx.pressed.connect(_target_button_pressed.bind(i))
	else:
		for i in len(arrayenemies):
			var buttonx = Button.new()
			add_child(buttonx)
			enemytargetbuttons.append(buttonx)
			buttonx.flat = true
			buttonx.position = Vector2(arrayenemies[i].position.x -36, arrayenemies[i].position.y - 36)
			buttonx.set_button_icon(SelectingEnemyAnim)
			buttonx.pressed.connect(_target_button_pressed.bind(i))
## DA FARE DOMANI: SKILL BUTTONS THAT DO SOMETHING
## ADD SOME LABELS THAT DESCRIBE SHIT HERE AND THERE

func _hide_button():
	AttackButton.visible = false
	SkillButton.visible = false
	BackButton.visible = false
	DefendButton.visible = false 
	ItemsButton.visible = false
	
	
func _show_button():
	AttackButton.visible = true
	SkillButton.visible = true
	BackButton.visible = true
	DefendButton.visible = true
	ItemsButton.visible = true
	
func _start_le_timer():
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

func _update_battle_log():
	if(len(battlelogarray)>10):
		battlelogarray.remove_at(0)
	battlelogtext = ""
	for i in len(battlelogarray):
		battlelogtext = battlelogtext + battlelogarray[i]
		battlelogtext = battlelogtext + "
		"
	BattleLog.text = "Summary: 
	" + battlelogtext


func _losing_the_battle():
	_hide_button()
	var youlostdork = Label.new()
	add_child(youlostdork)
	youlostdork.position = Vector2(150, 150)
	youlostdork.text = "you lost dork haha"
