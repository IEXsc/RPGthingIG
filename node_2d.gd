## FINALLY ADD WEAKNESSES
## MAYBE UPDATE THE WAY DAMAGE IS CALCULATED FFS

## https://docs.google.com/spreadsheets/d/1moa-AuzmRn1FMVouLuWMqBgxDgxjbl1clZQZNK0O6sg/edit?gid=0#gid=0
## FOR SKILL TYPES

extends Node2D
@onready var BackButton = $Back

var SelectingEnemyAnim = load("res://SelectingEnemyButton.tres")
var SelectingAllyAnim = load("res://HoveringTextures/ShiftingAnimTexture.tres")
var AllOutAttackAnim = load("res://Cutaways/AllOutAttackButton/AllOutAttackButton.tres")
@onready var PlayerHpIndicator = $PlayerHpIndicator
@onready var AllyHpIndicator = $AllyHpIndicator

var alloutattackbutton = Button.new()
var timer = Timer.new()
var enemytimer = Timer.new()

### TEXTURES

var EmptyBar = load("res://AlliesorYourself/HPindicators/HPbar(s)/HPBAREMPTY.png")
var FullHPBar = load("res://AlliesorYourself/HPindicators/HPbar(s)/HPBARFULL.png")
var FullSPBar = load("res://AlliesorYourself/HPindicators/HPbar(s)/SPBARFULL.png")

var HittingWeaknessTexture = load("res://Cutaways/HitAWeaknessGeneric.tres")
var AllOutAttackTexture = load("res://Cutaways/AlloutAttackSprite.tres")

var AbsorbsTexture = load("res://Enemies/HealthBars/Absorbe.png")
var ResistsTexture = load("res://Enemies/HealthBars/Resists.png")
var WeakTexture = load("res://Enemies/HealthBars/Weak.png")
var UnknownTexture = load("res://Enemies/HealthBars/Unknown.png")
var ATK_DOWNTexture = load("res://Enemies/HealthBars/BuffsorDebuffs/ATK_DOWN.png")
var ATK_UPTexture = load("res://Enemies/HealthBars/BuffsorDebuffs/ATK_UP.png")
var ATK_NEUTRALTexture = load("res://Enemies/HealthBars/BuffsorDebuffs/ATK_NEUTRAL.png")
var DEF_DOWNexture = load("res://Enemies/HealthBars/BuffsorDebuffs/DEF_DOWN.png")
var DEF_UPTexture = load("res://Enemies/HealthBars/BuffsorDebuffs/DEF_UP.png")
var DEF_NEUTRALTexture = load("res://Enemies/HealthBars/BuffsorDebuffs/DEF_NEUTRAL.png")
var CRIT_DOWNexture = load("res://Enemies/HealthBars/BuffsorDebuffs/CRI_DOWN.png")
var CRIT_UPTexture = load("res://Enemies/HealthBars/BuffsorDebuffs/CRI_UP.png")
var CRIT_NEUTRALTexture = load("res://Enemies/HealthBars/BuffsorDebuffs/CRI_NEUTRAL.png")


##var TypeTextures = [AbsorbsTexture, ResistsTexture, WeakTexture]

var EnemyHPFull = load("res://Enemies/HealthBars/EnemyFullHealth.png")
var EnemyHPEmpty = load("res://Enemies/HealthBars/EnemyEmptyHealth.png")

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
var AttackBonusTexture = load("res://AttackBuff.png")
var DefenseBonusTexture = load("res://DefenseBonus.png")
var AttackDebuffTexture = load("res://AttackDeBuff.png")
var DefenseDebuffTexture = load("res://DefenseDebuff.png")
var CritMovesTexture = load("res://CritMoves.png")
##0 Blunt	1Pierce	2Slash |	3Ruin	4Life	5Time	6Space	7Mind	8Chthonic	9Holy	10Arcane	11Healing	12 Attack Bonus	13 Defense Bonus	14 attack debuff	15 defense debuff
var arrayAttackTypesIcons = [BluntTexture, PierceTexture, SlashTexture,RuinTexture, LifeTexture, TimeTexture,SpaceTexture, MindTexture, ChthonicTexture,HolyTexture, ArcaneTexture, HealingTexture, AttackBonusTexture, DefenseBonusTexture , AttackDebuffTexture , DefenseDebuffTexture, CritMovesTexture]
var arrayenemies = []
var arrayalleati = []
var skillbuttons = []
var itembuttons = []
var enemytargetbuttons = []
var Items = []
var shiftingbuttonsarray = []
var AlliedHealthBars = []
var AlliedHpIndicator = []
var AlliedManaBars = []
var damagelabels = []

var targetenemy = 0
var i = 0
var recentaction = 0
var currentenemymove = 0
var currentpartymember = 0
var currentusedskill = 0
var currentturn = 0
var alliedtarget = 0
var currentuseditem = 0
var enemyaction = 0
var damagethatwillbedone = 0
var ONEMORE = 0
var totalenemiesup = 0
var atleastonecharalive = true
var cangetalloutattack = false
var rng = RandomNumberGenerator.new()
func _ready() -> void:
	
	
	rng.randomize()
	Items = get_parent().Items
	
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	add_child(enemytimer)
	enemytimer.timeout.connect(_timer_moving_back)
	_setting_up_enemies()
	
	var Player = get_parent().Giocatore
	Player.set_sprite_frames(Player.get_meta("Animation"))
	Player.position = Vector2(830, 260)
	add_child(Player)
	
	var Ally1 = get_parent().Beatrice
	Ally1.set_sprite_frames(Ally1.get_meta("Animation"))
	Ally1.position = Vector2(894, 260)
	add_child(Ally1)
	
	arrayalleati = [Player, Ally1]
	Player.play("waiting")
	Ally1.play("waiting")
	
	
	_create_health_bars()
	_show_button()
	
	BackButton.pressed.connect(_back_button_pressed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass
	
	
		
func _calculate_total_enemies_buttons():
	for i in range(arrayenemies.size() - 1, -1, -1):
		var enemy = arrayenemies[i]
		if is_instance_valid(enemy):
			if enemy.get_meta("HP") <= 0:
				enemy.queue_free()
				if(enemy.get_meta("Status") != "Downed"):
					totalenemiesup = totalenemiesup - 1 # 1 LESS ENEMY NEEDED FOR AN ALL OUT ATTACK
				arrayenemies.remove_at(i) # Removes it from the array so it's not checked next time
	if(len(arrayenemies)==0):
		_winning_the_battle()

	
		
func _target_button_pressed(pulsanteid):
	targetenemy = pulsanteid
	if(recentaction==1):
		alliedtarget = arrayenemies
		damagethatwillbedone = arrayalleati[currentpartymember].get_meta("Weapon").get_meta("Damage")
		var attackbonus = 1
		if(arrayalleati[currentpartymember].get_meta("Attack") > 0):
			attackbonus = 1.5
		elif(arrayalleati[currentpartymember].get_meta("Attack") < 0):
			attackbonus = 0.5
		_calculate_damage(attackbonus, arrayalleati[currentpartymember].get_meta("Weapon").get_meta("DamageType"))
	if(recentaction==4):
		var movetype = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Type")
		var newsp = arrayalleati[currentpartymember].get_meta("SP") - arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Cost")
		var targets = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Targets")
		#elif(targets == "AllEnemies" or targets == "AllAllies"):
		arrayalleati[currentpartymember].set_meta("SP", newsp)
		AlliedManaBars[currentpartymember].set_value(newsp)
		if(targets == "One" or targets == "OneAlly"):
			if(movetype<12):
				var attackbonus = 1
				if(movetype<11):   # damaging moves
					alliedtarget = arrayenemies
					if(arrayalleati[currentpartymember].get_meta("Attack") > 0):
						attackbonus = 1.5
					elif(arrayalleati[currentpartymember].get_meta("Attack") < 0):
						attackbonus = 0.5
						
				elif(movetype==11):  #healing should not be affected by attack boosts
					alliedtarget = arrayalleati
					
				damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
				
				
				_calculate_damage(attackbonus, movetype)
			elif(movetype==12 or movetype == 13):
				alliedtarget = arrayalleati
				damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
				_calculate_damage(1, movetype)
			elif(movetype==14 or movetype == 15):
				alliedtarget = arrayenemies
				damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
				_calculate_damage(1, movetype)
			
			var SkillBeingUsed = AnimatedSprite2D.new()
			add_child(SkillBeingUsed)
			SkillBeingUsed.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y)
			SkillBeingUsed.set_sprite_frames(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Image"))
			SkillBeingUsed.animation_looped.connect(_delete_self.bind(SkillBeingUsed))
			SkillBeingUsed.play("default")
		elif(targets == "AllEnemies" or targets == "AllAllies"):
			var attackbonus = 1
			if(movetype<11):
				alliedtarget = arrayenemies
				if(arrayalleati[currentpartymember].get_meta("Attack") > 0):
					attackbonus = 1.5
				if(arrayalleati[currentpartymember].get_meta("Attack") < 0):
					attackbonus = 0.5
			if(movetype==11):
				alliedtarget = arrayalleati
				
			elif(movetype==12 or movetype == 13):
				alliedtarget = arrayalleati

			elif(movetype==14 or movetype == 15):
				alliedtarget = arrayenemies
				
			for i in range(len(alliedtarget)):
				damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
				targetenemy = i
				var SkillBeingUsed = AnimatedSprite2D.new()
				add_child(SkillBeingUsed)
				SkillBeingUsed.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y)
				SkillBeingUsed.set_sprite_frames(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Image"))
				SkillBeingUsed.animation_looped.connect(_delete_self.bind(SkillBeingUsed))
				SkillBeingUsed.play("default")
				
				
				_calculate_damage(attackbonus, movetype)
		if(targets == "Self"):
			if(movetype==16):
				damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
				alliedtarget = arrayalleati
			
			var SkillBeingUsed = AnimatedSprite2D.new()
			add_child(SkillBeingUsed)
			SkillBeingUsed.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y)
			SkillBeingUsed.set_sprite_frames(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Image"))
			SkillBeingUsed.animation_looped.connect(_delete_self.bind(SkillBeingUsed))
			SkillBeingUsed.play("default")
			_calculate_damage(1, movetype)
	if(recentaction==6):
		if(Items[currentuseditem].get_meta("Type")==0):
			alliedtarget = arrayalleati
			damagethatwillbedone = Items[currentuseditem].get_meta("Damage")
			_calculate_damage(1, 11)
		elif(Items[currentuseditem].get_meta("Type")==1):
			alliedtarget = arrayalleati
			for i in range(len(alliedtarget)):
				targetenemy = i
				damagethatwillbedone = Items[currentuseditem].get_meta("Damage")
				_calculate_damage(1, 11)
	for i in len(enemytargetbuttons):
		enemytargetbuttons[i].queue_free()
	enemytargetbuttons = []
	_start_le_timer()



func _delete_self(Self):
	Self.queue_free()

func _attack_button_pressed():
	if(recentaction==0):
			
		arrayalleati[currentpartymember].position = Vector2(arrayalleati[currentpartymember].position.x, arrayalleati[currentpartymember].position.y - 50)
		recentaction = 1
		timer.wait_time = 0.2
		_create_targeting_buttons()
	
func _defend_button_pressed():
	if(recentaction==0):
		var newdefence = arrayalleati[currentpartymember].get_meta("DefenseFromParrying") + 0.5 
		arrayalleati[currentpartymember].set_meta("DefenseFromParrying", newdefence) 
		arrayalleati[currentpartymember].set_meta("Status", "Defending")
		AlliedHpIndicator[currentpartymember].play("Defending")
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
	if(cangetalloutattack==true):
		cangetalloutattack=false
		_delete_self(alloutattackbutton)
		_show_button()
		recentaction = 0
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
	
	for i in range(len(shiftingbuttonsarray)):
		_delete_self(shiftingbuttonsarray[i])
	shiftingbuttonsarray.clear()
	for i in len(enemytargetbuttons):
		_delete_self(enemytargetbuttons[i])
	enemytargetbuttons.clear()
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
		
			
		if(currentenemymove<len(arrayenemies)):
			if(arrayenemies[currentenemymove].get_meta("Status") == "Downed"):
				arrayenemies[currentenemymove].play("waiting")
				arrayenemies[currentenemymove].set_meta("Status", "Alive")
				totalenemiesup = totalenemiesup + 1
			enemyaction = randi_range(1, 2) 
			if(enemyaction== 1):
				alliedtarget = arrayalleati
				
				targetenemy =  rng.randi_range(0, len(arrayalleati)-1) 
				while(alliedtarget[targetenemy].get_meta("HP")<=0):
					targetenemy =  rng.randi_range(0, len(arrayalleati)-1) 
				
				arrayenemies[currentenemymove].position = Vector2(arrayenemies[currentenemymove].position.x, arrayenemies[currentenemymove].position.y + 50)
				damagethatwillbedone = int(round(( arrayenemies[currentenemymove].get_meta("Damage"))))
				
				var attackbonus = 1
				if(arrayenemies[currentenemymove].get_meta("Attack") > 0):
					attackbonus = 1.5
				if(arrayenemies[currentenemymove].get_meta("Attack") < 0):
					attackbonus = 0.5
				
				_calculate_damage(attackbonus, arrayenemies[currentenemymove].get_meta("DamageType"))
				
			
				enemytimer.wait_time = 0.2
			if(enemyaction==2):
				var usableskill = false
				var currentmove = 0
				var movetype = 0
				var attackbonus = 1
				var enemymovetargets = ""
				while usableskill == false:
					
					currentmove = randi_range(0, len(arrayenemies[currentenemymove].get_meta("SpecialMoves"))-1)
					movetype = arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Type")
					if(movetype<12):
						if(movetype<11):   #damaging moves
							alliedtarget = arrayalleati
							
							targetenemy =  rng.randi_range(0, len(alliedtarget)-1)    # we don't want them to use moves on dead allies
							while(alliedtarget[targetenemy].get_meta("HP")<=0):
								targetenemy =  rng.randi_range(0, len(alliedtarget)-1)
							
							if(arrayenemies[currentenemymove].get_meta("Attack") > 0):
								attackbonus = 1.5
							if(arrayenemies[currentenemymove].get_meta("Attack") < 0):
								attackbonus = 0.5
							usableskill = true  #there is no reason why he can't just attack, duh
								
						elif(movetype==11):  #healing moves
							alliedtarget = arrayenemies
							targetenemy =  rng.randi_range(0, len(alliedtarget)-1)    # we don't want them to use moves on dead enemies ( they might not even exist )
							while(alliedtarget[targetenemy].get_meta("HP")<=0):   # but better be safe than sorry
								targetenemy =  rng.randi_range(0, len(alliedtarget)-1)
							
							var anyenemybelow20percenthp = false    ## ok so to put it bluntly, we don't want to heal enemies who are full cause that's dogshit game design
							for i in len(alliedtarget):  ## nor do we want the healing to just erase the player progress so it's supposed to be close enough
								var currentenemyhealth = float(alliedtarget[targetenemy].get_meta("HP")) ## to an amount the player can simply one shot the enemy
								currentenemyhealth = currentenemyhealth / alliedtarget[targetenemy].get_meta("maxHP")  ## TODO:ADD SOME SORT OF WAY TO TELL IT WHO TO HEAL
								if(currentenemyhealth<0.20):
									anyenemybelow20percenthp = true
									usableskill = true
									break
							if(anyenemybelow20percenthp == false):
								usableskill = false
						if(usableskill==true):
							enemymovetargets = arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Targets")
							damagethatwillbedone = int(round(( arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Damage") )))
							if(enemymovetargets=="One" or enemymovetargets == "OneAlly"):
								_calculate_damage(attackbonus, movetype)  ## This should lead to no problems, hopefully
							elif(enemymovetargets=="AllEnemies" or enemymovetargets == "AllAllies"):
								for i in len(alliedtarget):
									targetenemy = i
									_calculate_damage(attackbonus, movetype)
					elif(movetype==12 or movetype == 13):
						usableskill = true
						alliedtarget = arrayenemies
						
						targetenemy =  rng.randi_range(0, len(alliedtarget)-1)    # we don't want them to use moves on dead enemies ( they might not even exist )
						while(alliedtarget[targetenemy].get_meta("HP")<=0):   # but better be safe than sorry
							targetenemy =  rng.randi_range(0, len(alliedtarget)-1)
							 
						damagethatwillbedone = arrayenemies[currentpartymember].get_meta("SpecialMoves")[currentmove].get_meta("Damage")
						
						if(enemymovetargets=="One" or enemymovetargets == "OneAlly"):
							_calculate_damage(1, movetype)  ## This should lead to no problems, hopefully
						elif(enemymovetargets=="AllEnemies" or enemymovetargets == "AllAllies"):
							for i in len(alliedtarget):
								targetenemy = i
								_calculate_damage(1, movetype)
								
					elif(movetype==14 or movetype == 15):
						usableskill = true
						alliedtarget = arrayalleati
						
						targetenemy =  rng.randi_range(0, len(alliedtarget)-1)    # we don't want them to use moves on dead allies
						while(alliedtarget[targetenemy].get_meta("HP")<=0):
							targetenemy =  rng.randi_range(0, len(alliedtarget)-1)
						
						damagethatwillbedone = arrayenemies[currentpartymember].get_meta("SpecialMoves")[currentmove].get_meta("Damage")
						if(enemymovetargets=="One" or enemymovetargets == "OneAlly"):
							_calculate_damage(1, movetype)  ## This should lead to no problems, hopefully
						elif(enemymovetargets=="AllEnemies" or enemymovetargets == "AllAllies"):
							for i in len(alliedtarget):
								targetenemy = i
								_calculate_damage(1, movetype)
						
						
				if(enemymovetargets=="AllEnemies" or enemymovetargets == "AllAllies"):
					for i in len(alliedtarget):
						var SkillBeingUsed = AnimatedSprite2D.new()
						add_child(SkillBeingUsed)
						SkillBeingUsed.position = Vector2(alliedtarget[i].position.x, alliedtarget[i].position.y)
						SkillBeingUsed.set_sprite_frames(arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Image"))
						SkillBeingUsed.play("default")
						SkillBeingUsed.animation_looped.connect(_deleteweaknesscutaway.bind(SkillBeingUsed))
						
				else:
					var SkillBeingUsed = AnimatedSprite2D.new()
					add_child(SkillBeingUsed)
					SkillBeingUsed.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y)
					SkillBeingUsed.set_sprite_frames(arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Image"))
					SkillBeingUsed.play("default")
					SkillBeingUsed.animation_looped.connect(_deleteweaknesscutaway.bind(SkillBeingUsed))
				enemytimer.wait_time = arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("AnimationTime")
			
			if(arrayenemies[currentenemymove].get_meta("Attack") > 0):   # decreasing when it's a buff
				var boostedattackturnsleft = arrayenemies[currentenemymove].get_meta("Attack") - 1
				arrayenemies[currentenemymove].set_meta("Attack", boostedattackturnsleft)
			if(arrayenemies[currentenemymove].get_meta("Defense") > 0):  #decreasing when it's a buff
				var boosteddefenseturnsleft = arrayenemies[currentenemymove].get_meta("Defense") - 1
				arrayenemies[currentenemymove].set_meta("Defense", boosteddefenseturnsleft)
			
			if(arrayenemies[currentenemymove].get_meta("Attack") < 0):
				var boostedattackturnsleft = arrayenemies[currentenemymove].get_meta("Attack") + 1 #increasing when it's a debuff
				arrayenemies[currentenemymove].set_meta("Attack", boostedattackturnsleft)
			if(arrayenemies[currentenemymove].get_meta("Defense") < 0):
				var boosteddefenseturnsleft = arrayenemies[currentenemymove].get_meta("Defense") + 1 #increasing when it's a debuff
				arrayenemies[currentenemymove].set_meta("Defense", boosteddefenseturnsleft)
			
			enemytimer.start()	
		else:
			_reset_ally_positions()
			currentusedskill = 0
			currentenemymove = 0
	elif(atleastonecharalive==false):
		_losing_the_battle()
		
func _timer_moving_back():
	#for i in len(arrayenemies):
	if(enemyaction==1):
		arrayenemies[currentenemymove].position = Vector2(arrayenemies[currentenemymove].position.x, arrayenemies[currentenemymove].position.y - 50)
	if(ONEMORE == 0):
		currentenemymove = currentenemymove + 1
	else:
		ONEMORE = ONEMORE - 1
	enemytimer.stop()
	_singleenemyturn()

func _reset_stat_boosts(target):
	if(arrayalleati[target].get_meta("Attack") > 0):   # decreasing when it's a buff
		var boostedattackturnsleft = arrayalleati[target].get_meta("Attack") - 1
		arrayalleati[target].set_meta("Attack", boostedattackturnsleft)
		
		if(arrayalleati[target].get_meta("Attack") > 0):
			AlliedHpIndicator[target].get_child(0).set_texture(ATK_UPTexture)
			
	if(arrayalleati[target].get_meta("Attack") < 0):
		var boostedattackturnsleft = arrayalleati[target].get_meta("Attack") + 1 #increasing when it's a debuff
		arrayalleati[target].set_meta("Attack", boostedattackturnsleft)
		if(arrayalleati[target].get_meta("Attack") < 0):
			AlliedHpIndicator[target].get_child(0).set_texture(ATK_DOWNTexture)
	
	if(arrayalleati[target].get_meta("Attack") == 0):
		AlliedHpIndicator[target].get_child(0).set_texture(ATK_NEUTRALTexture)	
		
	## defense
	if(arrayalleati[target].get_meta("Defense") > 0):  #decreasing when it's a buff
		var boosteddefenseturnsleft = arrayalleati[target].get_meta("Defense") - 1
		arrayalleati[target].set_meta("Defense", boosteddefenseturnsleft)
		if(arrayalleati[target].get_meta("Defense") > 0):
			AlliedHpIndicator[target].get_child(1).set_texture(DEF_UPTexture)
	if(arrayalleati[target].get_meta("Defense") < 0):
		var boosteddefenseturnsleft = arrayalleati[target].get_meta("Defense") + 1 #increasing when it's a debuff
		arrayalleati[target].set_meta("Defense", boosteddefenseturnsleft)
		if(arrayalleati[target].get_meta("Defense") < 0):
			AlliedHpIndicator[target].get_child(1).set_texture(DEF_DOWNexture)
	if(arrayalleati[target].get_meta("Defense") == 0):
		AlliedHpIndicator[target].get_child(1).set_texture(DEF_NEUTRALTexture)
	
	## CRIT CHANCE
	if(arrayalleati[target].get_meta("CritChance") > 0):  #decreasing when it's a buff
		var boosteddefenseturnsleft = arrayalleati[target].get_meta("CritChance") - 1
		arrayalleati[target].set_meta("CritChance", boosteddefenseturnsleft)
		if(arrayalleati[target].get_meta("CritChance") > 0):
			AlliedHpIndicator[target].get_child(2).set_texture(CRIT_UPTexture)
			
	if(arrayalleati[target].get_meta("CritChance") < 0):
		var boosteddefenseturnsleft = arrayalleati[target].get_meta("CritChance") + 1 #increasing when it's a debuff
		arrayalleati[target].set_meta("CritChance", boosteddefenseturnsleft)
		if(arrayalleati[target].get_meta("CritChance") < 0):
			AlliedHpIndicator[target].get_child(2).set_texture(CRIT_DOWNexture)
			
	if(arrayalleati[target].get_meta("CritChance") == 0):
		AlliedHpIndicator[target].get_child(2).set_texture(CRIT_NEUTRALTexture)
	
	
func _reset_ally_positions():
	
	_reset_stat_boosts(currentpartymember)
	
	arrayalleati[0].set_meta("DefenseFromParrying", 1)
	arrayalleati[0].play("waiting")
	arrayalleati[0].set_meta("Status", "Alive")
	AlliedHpIndicator[0].play("Alive")
	_show_button()
	
	
	
func _on_timer_timeout():
	
	if(arrayalleati[currentpartymember].get_meta("HP")>0):
		arrayalleati[currentpartymember].play("waiting")
	for i in len(enemytargetbuttons):
		enemytargetbuttons[i].queue_free()
	enemytargetbuttons = []
	if(recentaction==1):
		arrayalleati[currentpartymember].position = Vector2(arrayalleati[currentpartymember].position.x, arrayalleati[currentpartymember].position.y + 50)
		
	if(recentaction==2):
		arrayalleati[currentpartymember].play("Defend")
		
	if(recentaction==4):
		for i in len(skillbuttons):
			skillbuttons[i].queue_free()
		skillbuttons = []
	if(recentaction==6):
		for i in len(itembuttons):
			itembuttons[i].queue_free()
		itembuttons = []
		Items.remove_at(currentuseditem)
	if(recentaction==7):
		_show_button()
		for i in range(len(alliedtarget)):
			targetenemy = i
			_calculate_damage(1, 10)  #ARCANE SO NO ONE RESISTS THEM
	
	_calculate_total_enemies_buttons()
	recentaction = 0
	
	timer.stop()
	
	var next_turn_found = false
	if(ONEMORE == 0):
		while currentturn < len(arrayalleati) - 1:
			currentturn += 1
			currentpartymember = currentturn
			_reset_stat_boosts(currentpartymember)
			
			
			if(cangetalloutattack==true):
				_delete_self(alloutattackbutton)
				cangetalloutattack=false
			if(recentaction!=7):
				for i in range(len(shiftingbuttonsarray)):
					_delete_self(shiftingbuttonsarray[i])
				shiftingbuttonsarray.clear()
			if arrayalleati[currentpartymember].get_meta("HP") > 0:
				next_turn_found = true
				break
				
		if next_turn_found:
			$BoxContainer.AttackButton.set_button_icon(arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("Weapon").get_meta("DamageType")])
			arrayalleati[currentpartymember].play("waiting")
			arrayalleati[currentpartymember].set_meta("Status", "Alive")
			AlliedHpIndicator[currentpartymember].play("Alive")
			arrayalleati[i].set_meta("DefenseFromParrying", 1)
		else:
			# No more living allies have a move this turn, pass to enemies
			currentturn = 0
			currentpartymember = 0
			$BoxContainer.AttackButton.set_button_icon(arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("Weapon").get_meta("DamageType")])
			_enemyturn()
	else:
		ONEMORE = ONEMORE - 1

func _create_targeting_buttons():
	for i in range(len(damagelabels)):
		damagelabels[i].queue_free()
	damagelabels = []
	if(recentaction==4):
		var movetype = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Type")
		var targets = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Targets")
		if(targets == "One" or targets == "AllEnemies"):
			for i in len(arrayenemies):
				_create_target_button_enemies(i, movetype)
		if(targets == "OneAlly" or targets == "AllAllies"):
			for i in len(arrayalleati):
				_create_target_button_allies(i)
		if(targets == "Self"):
			_create_target_button_allies(currentpartymember)
	elif(recentaction==6):
		var itemtype = Items[currentuseditem].get_meta("Type")
		if(itemtype == 0):
			for i in len(arrayalleati):
				_create_target_button_allies(i)
	else:
		var movetype = arrayalleati[currentpartymember].get_meta("Weapon").get_meta("DamageType")
		for i in len(arrayenemies):
			_create_target_button_enemies(i, movetype)

func _create_target_button_allies(i):
	var buttonx = Button.new()
	add_child(buttonx)
	enemytargetbuttons.append(buttonx)
	buttonx.flat = true
	buttonx.position = Vector2(arrayalleati[i].position.x -36, arrayalleati[i].position.y - 36)
	buttonx.set_button_icon(SelectingAllyAnim)
	buttonx.pressed.connect(_target_button_pressed.bind(i))

func _create_target_button_enemies(i, movetype):
	var buttonx = Button.new()
	add_child(buttonx)
	enemytargetbuttons.append(buttonx)
	buttonx.flat = true
	buttonx.position = Vector2(arrayenemies[i].position.x -36, arrayenemies[i].position.y - 36)
	buttonx.set_button_icon(SelectingEnemyAnim)
	buttonx.pressed.connect(_target_button_pressed.bind(i))
	var hbr = TextureProgressBar.new()
	add_child(hbr)
	enemytargetbuttons.append(hbr)
	hbr.position = Vector2(arrayenemies[i].position.x -36, arrayenemies[i].position.y - 36)
	hbr.set_under_texture(EnemyHPEmpty)
	hbr.set_progress_texture(EnemyHPFull) 
	hbr.set_max(arrayenemies[i].get_meta("maxHP"))
	hbr.set_value(arrayenemies[i].get_meta("HP"))
	
	var positioninfo = arrayenemies[i].position.x + 0
	if(arrayenemies[i].get_meta("Attack") != 0):
		var attackstatchange = Sprite2D.new()
		add_child(attackstatchange)
		enemytargetbuttons.append(attackstatchange)
		attackstatchange.position = Vector2(positioninfo - 36, arrayenemies[i].position.y - 16)
		attackstatchange.centered = false
		var lenghtofattackbuffordebuff = arrayenemies[i].get_meta("Attack")
		if(lenghtofattackbuffordebuff > 0):
			attackstatchange.set_texture(ATK_UPTexture)
		elif(lenghtofattackbuffordebuff < 0 ):
			attackstatchange.set_texture(ATK_DOWNTexture)
	if(arrayenemies[i].get_meta("Defense") != 0):
		var defensestatchange = Sprite2D.new()
		add_child(defensestatchange)
		enemytargetbuttons.append(defensestatchange)
		defensestatchange.position = Vector2(positioninfo - 36, arrayenemies[i].position.y )
		defensestatchange.centered = false
		var lenghtofdefensebuffordebuff = arrayenemies[i].get_meta("Defense")
		if(lenghtofdefensebuffordebuff > 0):
			defensestatchange.set_texture(DEF_UPTexture)
		elif(lenghtofdefensebuffordebuff < 0 ):
			defensestatchange.set_texture(DEF_DOWNexture)
	if(movetype<12):
		
		if(arrayenemies[i].get_meta("DiscoveredAffinities")[movetype] == 3 ):
			var weak = Sprite2D.new()
			add_child(weak)
			enemytargetbuttons.append(weak)
			weak.position = Vector2(positioninfo, arrayenemies[i].position.y - 36)
			weak.set_texture(UnknownTexture)
		elif(arrayenemies[i].get_meta("DiscoveredAffinities")[movetype] > 1 ):
			var weak = Sprite2D.new()
			add_child(weak)
			enemytargetbuttons.append(weak)
			weak.position = Vector2(positioninfo, arrayenemies[i].position.y - 36)
			weak.set_texture(WeakTexture)
		elif(arrayenemies[i].get_meta("DiscoveredAffinities")[movetype] < 0 ):
			var weak = Sprite2D.new()
			add_child(weak)
			enemytargetbuttons.append(weak)
			weak.position = Vector2(positioninfo, arrayenemies[i].position.y - 36)
			weak.set_texture(AbsorbsTexture)
		elif(arrayenemies[i].get_meta("DiscoveredAffinities")[movetype] < 1 ):
			var weak = Sprite2D.new()
			add_child(weak)
			enemytargetbuttons.append(weak)
			weak.position = Vector2(positioninfo, arrayenemies[i].position.y - 36)
			weak.set_texture(ResistsTexture)
## DA FARE DOMANI: SKILL BUTTONS THAT DO SOMETHING
## ADD SOME LABELS THAT DESCRIBE SHIT HERE AND THERE

func _hide_button():
	$BoxContainer._hide_buttons()
	BackButton.visible = false
	
	
func _show_button():
	$BoxContainer._show_buttons()
	BackButton.visible = true
	
	
func _start_le_timer():
	
	timer.start()


func _create_shifting_button():
	for i in len(arrayalleati):
		if(i!=currentpartymember):
			if(arrayalleati[i].get_meta("HP") > 0):
				if(arrayalleati[i].get_meta("Status") == "Alive"):
					var ShiftingButton = Button.new()
					add_child(ShiftingButton)
					shiftingbuttonsarray.append(ShiftingButton)
					ShiftingButton.flat = true
					ShiftingButton.position = Vector2(arrayalleati[i].position.x -36, arrayalleati[i].position.y - 36)
					ShiftingButton.set_button_icon(SelectingAllyAnim)
					ShiftingButton.pressed.connect(_shifting_button_pressed.bind(i, ShiftingButton))

func _shifting_button_pressed(index, ShiftingButton):
	if(recentaction==0):
		currentpartymember = index
		if(cangetalloutattack==true):
			cangetalloutattack = false
			_delete_self(alloutattackbutton)
		for i in range(len(shiftingbuttonsarray)):
			_delete_self(shiftingbuttonsarray[i])
		shiftingbuttonsarray.clear()
		_show_button()

func _calculate_damage(attackbonus,attacktype):
	var is_a_crit = false
	var newhp = 0
	const crittreshold = 0.9
	var Labelfordamage = RichTextLabel.new()
	if(attacktype<12):
		
		
		Labelfordamage.bbcode_enabled = true
		Labelfordamage.add_theme_font_size_override("normal_font_size", 16)
		Labelfordamage.custom_minimum_size = Vector2(200, 50)
		Labelfordamage.clip_contents = false
		Labelfordamage.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y - 32)
		Labelfordamage.install_effect(load("res://CustomRichTextLebelEffects/ShakeEffect.tres"))
		Labelfordamage.text = "[pop]"
		
		damagethatwillbedone = damagethatwillbedone * rng.randf_range(0.8, 1.2)
		
		if(alliedtarget == arrayenemies):
			var standarddefence = 1
			if(alliedtarget[targetenemy].get_meta("Defense") > 0):
				standarddefence = 1.5
			elif(alliedtarget[targetenemy].get_meta("Defense") < 0):
				standarddefence = 0.5
			
			damagethatwillbedone = int(round(damagethatwillbedone * attackbonus / standarddefence * alliedtarget[targetenemy].get_meta("Affinities")[attacktype] ) )
			
			if(attacktype<=2):  # you will never use one of the standard 3 attacks on yours = this has to be an ally attacking ( hopefully )
				var standardcritchance = 0
				if(arrayalleati[currentpartymember].get_meta("CritChance") > 0):
					standardcritchance = 0.25
				
				var critchance = rng.randf_range(0, 1)
				if(critchance>crittreshold - standardcritchance):
					is_a_crit = true
					Labelfordamage.position = Vector2(alliedtarget[targetenemy].position.x - 32 , alliedtarget[targetenemy].position.y - 32)
					Labelfordamage.text = Labelfordamage.text + "[color=red]" + "CRIT" +"[/color]"
					damagethatwillbedone = int(round( damagethatwillbedone * 1.5 ) )
					
					
			
			newhp = alliedtarget[targetenemy].get_meta("HP") - damagethatwillbedone
		
		if(alliedtarget == arrayalleati):
			var standarddefence = 1
			if(alliedtarget[targetenemy].get_meta("Defense") > 0):
				standarddefence = 1.5
			elif(alliedtarget[targetenemy].get_meta("Defense") < 0):
				standarddefence = 0.5
			damagethatwillbedone = int(round(damagethatwillbedone * attackbonus / alliedtarget[targetenemy].get_meta("DefenseFromParrying") / standarddefence  * alliedtarget[targetenemy].get_meta("CharacterGod").get_meta("Affinities")[attacktype] ) ) 
			
			if(attacktype<=2):    # you will never use one of the standard 3 attacks on yours = this has to be an enemy attacking ( hopefully )
				var standardcritchance = 0
				if(arrayenemies[currentenemymove].get_meta("CritChance") > 0): ##He tryina ignore it
					standardcritchance = 0.25
				
				var critchance = rng.randf_range(0, 1)
				if(critchance>crittreshold):
					is_a_crit = true
					Labelfordamage.position = Vector2(alliedtarget[targetenemy].position.x - 32 , alliedtarget[targetenemy].position.y - 32)
					Labelfordamage.text = Labelfordamage.text + "[color=red]" + "CRIT" +"[/color]"
					damagethatwillbedone = int(round( damagethatwillbedone * 1.5 ) )
			
			newhp = alliedtarget[targetenemy].get_meta("HP") - damagethatwillbedone
	
	
	
		if(newhp>alliedtarget[targetenemy].get_meta("maxHP")):
			newhp = alliedtarget[targetenemy].get_meta("maxHP")
			alliedtarget[targetenemy].set_meta("HP", newhp)
		
		elif(newhp<=0):          ## WILL ONLY TRIGGER FOR PLAYABLE CHARACTERS
			alliedtarget[targetenemy].set_meta("HP", 0)
			
			if(alliedtarget == arrayalleati):
				AlliedHpIndicator[targetenemy].play("Dead")
				alliedtarget[targetenemy].play("Faint")
		else:
			alliedtarget[targetenemy].set_meta("HP", newhp)
			if(alliedtarget[targetenemy].get_meta("HP")>0 and !alliedtarget[targetenemy].get_meta("Status", "Downed")):
				
				AlliedHpIndicator[targetenemy].play("Alive")
				alliedtarget[targetenemy].play("waiting")
	
		
			
	if(alliedtarget == arrayalleati):         ## ENEMIES ARE ATTACKING  // WE ARE HEALING
		if(attacktype<12):
			AlliedHealthBars[targetenemy].set_value(newhp)
			
			if(alliedtarget[targetenemy].get_meta("CharacterGod").get_meta("Affinities")[attacktype] > 1  or is_a_crit == true):
				
				if (alliedtarget[targetenemy].get_meta("CharacterGod").get_meta("Affinities")[attacktype] > 1):
					Labelfordamage.position = Vector2(alliedtarget[targetenemy].position.x - 32 , alliedtarget[targetenemy].position.y - 32)	
					Labelfordamage.text = Labelfordamage.text + "[color=red]" + "WEAK" +"[/color]"
				
				
				if(alliedtarget[targetenemy].get_meta("Status") != "Downed" and alliedtarget[targetenemy].get_meta("Status") != "Defending"):
					enemytimer.wait_time = enemytimer.wait_time + 1
					ONEMORE = 1 
					alliedtarget[targetenemy].set_meta("Status", "Downed")
					alliedtarget[targetenemy].play("downed")
				
			if(alliedtarget[0].get_meta("HP")<=0):
				_losing_the_battle()
		elif(attacktype==12 or attacktype==14):       # the player buffs his own attack / enemy nerfs player's attack
			
			alliedtarget[targetenemy].set_meta("Attack", alliedtarget[targetenemy].get_meta("Attack")  + damagethatwillbedone)
			
			if(alliedtarget[targetenemy].get_meta("Attack") > 0):   # he can get a buff
				AlliedHpIndicator[targetenemy].get_child(0).set_texture(ATK_UPTexture)
					
			if(alliedtarget[targetenemy].get_meta("Attack") < 0):  # if he's somehow still debuffed ( allows for stacking debuffs for the enemy )
				AlliedHpIndicator[targetenemy].get_child(0).set_texture(ATK_DOWNTexture)
			
			if(alliedtarget[targetenemy].get_meta("Attack") == 0): # if they equal out
				AlliedHpIndicator[targetenemy].get_child(0).set_texture(ATK_NEUTRALTexture)
				
				
		elif(attacktype==13 or attacktype==15):   # the player buffs his own defense / enemy nerfs allied defense
			alliedtarget[targetenemy].set_meta("Defense", alliedtarget[targetenemy].get_meta("Defense")  + damagethatwillbedone)
			if(alliedtarget[targetenemy].get_meta("Defense") > 0):   # he can get a buff
				AlliedHpIndicator[targetenemy].get_child(1).set_texture(DEF_UPTexture)
					
			elif(alliedtarget[targetenemy].get_meta("Defense") < 0):  # if he's somehow still debuffed ( allows for stacking debuffs for the enemy )
				AlliedHpIndicator[targetenemy].get_child(1).set_texture(DEF_DOWNexture)
			
			elif(alliedtarget[targetenemy].get_meta("Defense") == 0): # if they equal out
				AlliedHpIndicator[targetenemy].get_child(1).set_texture(DEF_NEUTRALTexture)
	
		elif(attacktype==16):   # the X buffs his own crit chance
			alliedtarget[targetenemy].set_meta("CritChance", alliedtarget[targetenemy].get_meta("CritChance")  + damagethatwillbedone)
			if(alliedtarget[targetenemy].get_meta("CritChance") > 0):   # he can get a buff
				AlliedHpIndicator[targetenemy].get_child(2).set_texture(CRIT_UPTexture)
					
			elif(alliedtarget[targetenemy].get_meta("CritChance") < 0):  # if he's somehow still debuffed ( allows for stacking debuffs for the enemy )
				AlliedHpIndicator[targetenemy].get_child(2).set_texture(CRIT_DOWNexture)
			
			elif(alliedtarget[targetenemy].get_meta("CritChance") == 0): # if they equal out
				AlliedHpIndicator[targetenemy].get_child(2).set_texture(CRIT_NEUTRALTexture)
		
		
		
	elif(alliedtarget == arrayenemies):      ## WE ARE ATTACKING OR ENEMIES ARE HEALING / APPLYING BUFFS
		
		if(attacktype<12):
			var unusedtype = false
			if(alliedtarget[targetenemy].get_meta("DiscoveredAffinities")[attacktype] !=alliedtarget[targetenemy].get_meta("Affinities")[attacktype]):
				alliedtarget[targetenemy].get_meta("DiscoveredAffinities")[attacktype] = alliedtarget[targetenemy].get_meta("Affinities")[attacktype]
				unusedtype = true
				
			if (alliedtarget[targetenemy].get_meta("Affinities")[attacktype] > 1 or is_a_crit == true):
				alliedtarget[targetenemy].play("downed")
				if (alliedtarget[targetenemy].get_meta("Affinities")[attacktype] > 1):
					Labelfordamage.position = Vector2(alliedtarget[targetenemy].position.x - 32 , alliedtarget[targetenemy].position.y - 32)	
					Labelfordamage.text = Labelfordamage.text + "[color=red]" + "WEAK" +"[/color]"
				if(unusedtype == true):
					_create_weakness_cutaway()
				#DiscoveredAffinities
				if(alliedtarget[targetenemy].get_meta("Status") != "Downed"):  ## ATTACKED A WEAK ENEMY NOT DOWNED
					
					_create_shifting_button()
					
					ONEMORE = 1 
					totalenemiesup = totalenemiesup - 1
					cangetalloutattack = false ## you can't always all out attack, you either take you chance or you dont, retard
					if(totalenemiesup == 0):
						cangetalloutattack = true ## since you've recently killed downed someone, you can allout attack
						_create_all_out_attack_button()
					alliedtarget[targetenemy].set_meta("Status", "Downed")
					
				elif(len(shiftingbuttonsarray)>0 and currentpartymember == currentturn):
					for i in range(len(shiftingbuttonsarray)):
						_delete_self(shiftingbuttonsarray[i])
					shiftingbuttonsarray = []
			elif(alliedtarget[targetenemy].get_meta("Affinities")[attacktype] < 0):
				Labelfordamage.position = Vector2(alliedtarget[targetenemy].position.x - 32 , alliedtarget[targetenemy].position.y - 32)
				Labelfordamage.text = Labelfordamage.text + "[color=green]" + "ABSORBE" +"[/color]"
				damagethatwillbedone = -damagethatwillbedone
				
			elif(alliedtarget[targetenemy].get_meta("Affinities")[attacktype] < 1):
				Labelfordamage.position = Vector2(alliedtarget[targetenemy].position.x - 32 , alliedtarget[targetenemy].position.y - 32)
				Labelfordamage.text = Labelfordamage.text + "[color=orange]" + "RESIST" +"[/color]"
		
		elif(attacktype==12 or attacktype == 14):       # enemy buffs himself ( attack ) or gets lowered
			alliedtarget[targetenemy].set_meta("Attack", alliedtarget[targetenemy].get_meta("Attack")  + damagethatwillbedone)
		elif(attacktype==13 or attacktype == 15):      # enemy buffs himself ( defense ) or gets lowered
			alliedtarget[targetenemy].set_meta("Defense", alliedtarget[targetenemy].get_meta("Defense")  + damagethatwillbedone)
		elif(attacktype==16):      # the x buffs thier own crit chance
			alliedtarget[targetenemy].set_meta("CritChance", alliedtarget[targetenemy].get_meta("CritChance")  + damagethatwillbedone)
	
	add_child(Labelfordamage)
	Labelfordamage.text = Labelfordamage.text + str(damagethatwillbedone) + "[/pop]"
	damagelabels.append(Labelfordamage)

func _create_all_out_attack_button():
	if(cangetalloutattack == true):
		_hide_button()
		BackButton.visible = true
		alloutattackbutton = Button.new()
		add_child(alloutattackbutton)
		alloutattackbutton.flat = true
		alloutattackbutton.position = Vector2(862-64, 160-32)
		alloutattackbutton.set_button_icon(AllOutAttackAnim)
		alloutattackbutton.pressed.connect(_all_out_attack_pressed.bind(alloutattackbutton))
		alloutattackbutton.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _all_out_attack_pressed(buttontodelete):
	if(recentaction==0 and cangetalloutattack == true):
		cangetalloutattack = false
		alliedtarget = arrayenemies
		damagethatwillbedone = 0
		
		for i in range(len(arrayalleati)):
			damagethatwillbedone = damagethatwillbedone + arrayalleati[i].get_meta("Weapon").get_meta("Damage")
		damagethatwillbedone = damagethatwillbedone * len(arrayalleati) * 2
		
		var AllOutAttack = AnimatedSprite2D.new()
		add_child(AllOutAttack)
		AllOutAttack.position = Vector2(862, 160)
		AllOutAttack.set_sprite_frames(AllOutAttackTexture)
		AllOutAttack.play("default")
		enemytargetbuttons.append(AllOutAttack)
		recentaction=7
		buttontodelete.queue_free()
		for i in range(len(shiftingbuttonsarray)):
			_delete_self(shiftingbuttonsarray[i])
		shiftingbuttonsarray.clear()
		timer.wait_time = 2
		_start_le_timer()

func _create_weakness_cutaway():
	var WaeknessCutaway = AnimatedSprite2D.new()
	add_child(WaeknessCutaway)
	WaeknessCutaway.position = Vector2(576, 324)
	WaeknessCutaway.set_sprite_frames(HittingWeaknessTexture)
	WaeknessCutaway.play("default")
	WaeknessCutaway.animation_looped.connect(_deleteweaknesscutaway.bind(WaeknessCutaway))
	timer.wait_time = timer.wait_time + 1

func _deleteweaknesscutaway(WaeknessCutaway):
	WaeknessCutaway.queue_free()

func _setting_up_enemies(): ##CAUSE APPARENTLY CODE IN CHILDREN IS RAN BEFORE THE PARENTS, FUCKING BULLSHIT!!!
	var TungTungEnemy = get_parent().TungTung
	var AngelTungTung = get_parent().AngelTungTung
	var Enemies = [TungTungEnemy,AngelTungTung,AngelTungTung]
	for i in range(len(Enemies)):
		var nemtype = Enemies[i]
		var nem = AnimatedSprite2D.new()
		add_child(nem)
		nem.set_meta("HP", nemtype.get_meta("HP"))
		nem.set_meta("maxHP", nemtype.get_meta("maxHP"))
		nem.set_meta("Name", nemtype.get_meta("Name"))
		nem.set_meta("Damage", nemtype.get_meta("Damage"))
		nem.set_meta("DamageType", nemtype.get_meta("DamageType"))
		nem.set_meta("Defense", nemtype.get_meta("Defense"))
		nem.set_meta("Attack",nemtype.get_meta("Attack"))
		nem.set_meta("CritChance",nemtype.get_meta("CritChance"))
		nem.set_meta("Status", nemtype.get_meta("Status"))
		nem.set_meta("SpecialMoves", nemtype.get_meta("SpecialMoves"))
		nem.set_meta("Affinities", nemtype.get_meta("Affinities") )
		nem.set_meta("DiscoveredAffinities", nemtype.get_meta("DiscoveredAffinities") )
		nem.set_sprite_frames(nemtype.get_sprite_frames())
		nem.position = Vector2( 702 + ( (320 / (Enemies.size() + 1) * (i + 1) )  ) , 150)
		nem.play("waiting")
		arrayenemies.append(nem) 
	totalenemiesup = len(arrayenemies)

func _create_health_bars():
	var PlayerHealthBar = TextureProgressBar.new()
	add_child(PlayerHealthBar)
	PlayerHealthBar.position = Vector2(267, 107)
	PlayerHealthBar.set_under_texture(EmptyBar)
	PlayerHealthBar.set_progress_texture(FullHPBar) 
	
	var PlayerManaBar = TextureProgressBar.new()
	add_child(PlayerManaBar)
	PlayerManaBar.position = Vector2(267, 115)
	PlayerManaBar.set_under_texture(EmptyBar)
	PlayerManaBar.set_progress_texture(FullSPBar) 
	
	var AllyHealthBar = TextureProgressBar.new()
	add_child(AllyHealthBar)
	AllyHealthBar.position = Vector2(PlayerHealthBar.position.x+67, 107)
	AllyHealthBar.set_under_texture(EmptyBar)
	AllyHealthBar.set_progress_texture(FullHPBar) 
	
	var AllyManaBar = TextureProgressBar.new()
	add_child(AllyManaBar)
	AllyManaBar.position = Vector2(PlayerHealthBar.position.x+67, 115)
	AllyManaBar.set_under_texture(EmptyBar)
	AllyManaBar.set_progress_texture(FullSPBar) 

	AlliedManaBars = [PlayerManaBar, AllyManaBar]
	AlliedHealthBars = [PlayerHealthBar, AllyHealthBar]
	AlliedHpIndicator = [PlayerHpIndicator, AllyHpIndicator]
	
	for i in range(len(AlliedHpIndicator)):
		var ATKneutral = Sprite2D.new()
		AlliedHpIndicator[i].add_child(ATKneutral)
		ATKneutral.position = Vector2(-18, -16)
		ATKneutral.set_texture(ATK_NEUTRALTexture)
		ATKneutral.name = "ATKbuff" 
		var DEFneutral = Sprite2D.new()
		AlliedHpIndicator[i].add_child(DEFneutral)
		DEFneutral.position = Vector2(-18, 0)
		DEFneutral.set_texture(DEF_NEUTRALTexture)
		DEFneutral.name = "DEFbuff"
		var CRITneutral = Sprite2D.new()
		AlliedHpIndicator[i].add_child(CRITneutral)
		CRITneutral.position = Vector2(-15, 16)
		CRITneutral.set_texture(CRIT_NEUTRALTexture)
		CRITneutral.name = "DEFbuff"
		
	PlayerHealthBar.set_max(arrayalleati[0].get_meta("maxHP"))
	PlayerHealthBar.set_value(arrayalleati[0].get_meta("HP"))
	
	PlayerManaBar.set_max(arrayalleati[0].get_meta("maxSP"))
	PlayerManaBar.set_value(arrayalleati[0].get_meta("SP"))
	
	AllyHealthBar.set_max(arrayalleati[1].get_meta("maxHP"))
	AllyHealthBar.set_value(arrayalleati[1].get_meta("HP"))
	
	AllyManaBar.set_max(arrayalleati[1].get_meta("maxSP"))
	AllyManaBar.set_value(arrayalleati[1].get_meta("SP"))

func _losing_the_battle():
	var Losing = get_parent().LosingScene.instantiate()
	get_parent().add_child(Losing)
	queue_free()

func _winning_the_battle():
	var Winning = get_parent().WinningScene.instantiate()
	get_parent().add_child(Winning)
	queue_free()
