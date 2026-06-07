## FINALLY ADD WEAKNESSES
## MAYBE UPDATE THE WAY DAMAGE IS CALCULATED FFS

## https://docs.google.com/spreadsheets/d/1moa-AuzmRn1FMVouLuWMqBgxDgxjbl1clZQZNK0O6sg/edit?gid=0#gid=0
## FOR SKILL TYPES

extends Node2D
@onready var BackButton = $Back
@onready var BattleLog = $Summary

@onready var SelectingEnemyAnim = load("res://SelectingEnemyButton.tres")


@onready var PlayerHpIndicator = $PlayerHpIndicator
@onready var AllyHpIndicator = $AllyHpIndicator

var timer = Timer.new()
### TEXTURES

var EmptyBar = load("res://AlliesorYourself/HPindicators/HPbar(s)/HPBAREMPTY.png")
var FullHPBar = load("res://AlliesorYourself/HPindicators/HPbar(s)/HPBARFULL.png")
var FullSPBar = load("res://AlliesorYourself/HPindicators/HPbar(s)/SPBARFULL.png")

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



##0 Blunt	1Pierce	2Slash |	3Ruin	4Life	5Time	6Space	7Mind	8Chthonic	9Holy	10Arcane	11Healing
var arrayAttackTypesIcons = [BluntTexture, PierceTexture, SlashTexture,RuinTexture, LifeTexture, TimeTexture,SpaceTexture, MindTexture, ChthonicTexture,HolyTexture, ArcaneTexture, HealingTexture]
var arrayenemies = []
var arrayalleati = []
var skillbuttons = []
var itembuttons = []
var battlelogarray = []
var enemytargetbuttons = []
var Items = []

var AlliedHealthBars = []
var AlliedHpIndicator = []
var AlliedManaBars = []
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
var damagethatwillbedone = 0
var ONEMORE = 0

var atleastonecharalive = true
func _ready() -> void:
	
	
	randomize()
	BattleLog.text = "Summary: 
	"
	Items = get_parent().Items
	
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	_setting_up_enemies()
	
	var Player = get_parent().Giocatore
	Player.set_sprite_frames(Player.get_meta("Animation"))
	Player.position = Vector2(830, 260)
	add_child(Player)
	
	var Ally1 = get_parent().Ally
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
				arrayenemies.remove_at(i) # Removes it from the array so it's not checked next time
	if(len(arrayenemies)==0):
		_winning_the_battle()

	
		
func _target_button_pressed(pulsanteid):
	targetenemy = pulsanteid
	if(recentaction==1):
		alliedtarget = arrayenemies
		damagethatwillbedone = arrayalleati[currentpartymember].get_meta("Damage")
		_calculate_damage(arrayalleati[currentpartymember].get_meta("Attack"), arrayalleati[currentpartymember].get_meta("DamageType"))
	if(recentaction==4):
		var movetype = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Type")
		var newsp = arrayalleati[currentpartymember].get_meta("SP") - arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Cost")
		arrayalleati[currentpartymember].set_meta("SP", newsp)
		AlliedManaBars[currentpartymember].set_value(newsp)
		if(movetype<11):
			alliedtarget = arrayenemies
			damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
			_calculate_damage(arrayalleati[currentpartymember].get_meta("Attack"), movetype)
		elif(movetype==11):
			alliedtarget = arrayalleati
			damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
			_calculate_damage(1, movetype)
		var SkillBeingUsed = AnimatedSprite2D.new()
		skillbuttons.append(SkillBeingUsed)
		add_child(SkillBeingUsed)
		SkillBeingUsed.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y)
		SkillBeingUsed.set_sprite_frames(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Image"))
		SkillBeingUsed.play("default")
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
	alliedtarget = arrayalleati
	for i in range(len(arrayalleati)):
		if(arrayalleati[i].get_meta("HP")>0):
			atleastonecharalive = true
			break
		else:
			atleastonecharalive = false
	if(atleastonecharalive==true):
		targetenemy = randi_range(0, len(arrayalleati)-1) 
		while(alliedtarget[targetenemy].get_meta("HP")<=0):
			targetenemy =  randi_range(0, len(arrayalleati)-1) 
		var enemytimer = Timer.new()
		if(currentenemymove<len(arrayenemies)):
			arrayenemies[currentenemymove].play("waiting")
			arrayenemies[currentenemymove].set_meta("Status", "Alive")
			enemyaction = randi_range(1, 2) 
			if(enemyaction== 1):
				
				arrayenemies[currentenemymove].position = Vector2(arrayenemies[currentenemymove].position.x, arrayenemies[currentenemymove].position.y + 50)
				damagethatwillbedone = int(round(( arrayenemies[currentenemymove].get_meta("Damage"))))
				_calculate_damage(arrayenemies[currentenemymove].get_meta("Attack"), arrayenemies[currentenemymove].get_meta("DamageType"))
				
				battlelogarray.append(arrayenemies[currentenemymove].get_meta("Name") + " Attacked " + alliedtarget[targetenemy].get_meta("Name")  + " (New Hp) " + str(alliedtarget[targetenemy].get_meta("HP")))
				_update_battle_log()
				enemytimer.wait_time = 0.2
			if(enemyaction==2):
				var SkillBeingUsed = AnimatedSprite2D.new()
				currentusedskill = SkillBeingUsed
				add_child(SkillBeingUsed)
				SkillBeingUsed.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y)
				var currentmove = randi_range(0, len(arrayenemies[currentenemymove].get_meta("SpecialMoves"))-1)
				SkillBeingUsed.set_sprite_frames(arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Image"))
				SkillBeingUsed.play("default")
				
				damagethatwillbedone = int(round(( arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Damage") )))
				_calculate_damage(arrayenemies[currentenemymove].get_meta("Attack"), arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Type"))
				
				battlelogarray.append(arrayenemies[currentenemymove].get_meta("Name") + " Casted " + arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Name") + " on " + alliedtarget[targetenemy].get_meta("Name")+ " (New Hp) " + str(alliedtarget[targetenemy].get_meta("HP")))
				_update_battle_log()
				
				enemytimer.wait_time = arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("AnimationTime")
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
	timer.stop()
	
	var next_turn_found = false
	if(ONEMORE == 0):
		while currentpartymember < len(arrayalleati) - 1:
			currentpartymember += 1
			currentturn = currentpartymember
			
			if arrayalleati[currentpartymember].get_meta("HP") > 0:
				next_turn_found = true
				break
				
		if next_turn_found:
			$BoxContainer.AttackButton.set_button_icon(arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("DamageType")])
			# If you need to trigger an animation or update visual UI state for the next ally, do it here
		else:
			# No more living allies have a move this turn, pass to enemies
			currentturn = 0
			currentpartymember = 0
			$BoxContainer.AttackButton.set_button_icon(arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("DamageType")])
			_enemyturn()
	else:
		ONEMORE = ONEMORE - 1
	
	


	



func _create_targeting_buttons():
	if(recentaction==4):
		var movetype = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Type")
		if(movetype < 11):
			for i in len(arrayenemies):
				_create_target_button_enemies(i)
		if(movetype == 11):
			for i in len(arrayalleati):
				_create_target_button_allies(i)
	elif(recentaction==6):
		var itemtype = Items[currentuseditem].get_meta("Type")
		if(itemtype == 0):
			for i in len(arrayalleati):
				_create_target_button_allies(i)
	else:
		for i in len(arrayenemies):
			_create_target_button_enemies(i)

func _create_target_button_allies(i):
	var buttonx = Button.new()
	add_child(buttonx)
	enemytargetbuttons.append(buttonx)
	buttonx.flat = true
	buttonx.position = Vector2(arrayalleati[i].position.x -36, arrayalleati[i].position.y - 36)
	buttonx.set_button_icon(SelectingEnemyAnim)
	buttonx.pressed.connect(_target_button_pressed.bind(i))

func _create_target_button_enemies(i):
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

func _setting_up_enemies(): ##CAUSE APPARENTLY CODE IN CHILDREN IS RAN BEFORE THE PARENTS, FUCKING BULLSHIT!!!
	var TungTungEnemy = get_parent().TungTung
	var AngelTungTung = get_parent().AngelTungTung
	var Enemies = [AngelTungTung,TungTungEnemy]
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
		nem.set_meta("Status", nemtype.get_meta("Status"))
		nem.set_meta("SpecialMoves", nemtype.get_meta("SpecialMoves"))
		nem.set_meta("Affinities", nemtype.get_meta("Affinities") )
		nem.set_sprite_frames(nemtype.get_sprite_frames())
		nem.position = Vector2( 702 + ( (320 / (Enemies.size() + 1) * (i + 1) )  ) , 150)
		nem.play("waiting")
		arrayenemies.append(nem) 





func _calculate_damage(attackbonus,attacktype):
	var newhp = 0

	if(alliedtarget == arrayenemies):
		newhp = alliedtarget[targetenemy].get_meta("HP") - ( damagethatwillbedone / alliedtarget[targetenemy].get_meta("Defense") * attackbonus * alliedtarget[targetenemy].get_meta("Affinities")[attacktype])
	
	if(alliedtarget == arrayalleati):
		newhp = alliedtarget[targetenemy].get_meta("HP") - ( damagethatwillbedone / alliedtarget[targetenemy].get_meta("Defense") * attackbonus * alliedtarget[targetenemy].get_meta("CharacterGod").get_meta("Affinities")[attacktype])
	
	if(newhp>alliedtarget[targetenemy].get_meta("maxHP")):
		newhp = alliedtarget[targetenemy].get_meta("maxHP")
		alliedtarget[targetenemy].set_meta("HP", newhp)
	
	elif(newhp<=0):
		alliedtarget[targetenemy].set_meta("HP", 0)
		
		if(alliedtarget == arrayalleati):
			AlliedHpIndicator[targetenemy].play("Dead")
			alliedtarget[targetenemy].play("Faint")
	else:
		alliedtarget[targetenemy].set_meta("HP", newhp)
		if(alliedtarget[targetenemy].get_meta("HP")>0 and !alliedtarget[targetenemy].get_meta("Status", "Downed")):
			
			AlliedHpIndicator[targetenemy].play("Alive")
			alliedtarget[targetenemy].play("waiting")
			
	if(alliedtarget == arrayalleati):
		AlliedHealthBars[targetenemy].set_value(newhp)
		if(alliedtarget[targetenemy].get_meta("CharacterGod").get_meta("Affinities")[attacktype] > 1 ):
			alliedtarget[targetenemy].play("downed")
			if(alliedtarget[targetenemy].get_meta("Status") != "Downed"):
				ONEMORE = ONEMORE + 1 
			alliedtarget[targetenemy].set_meta("Status", "Downed")
		if(alliedtarget[0].get_meta("HP")<=0):
			_losing_the_battle()
	
	elif(alliedtarget == arrayenemies):
		if (alliedtarget[targetenemy].get_meta("Affinities")[attacktype] > 1 ):
			alliedtarget[targetenemy].play("downed")
			if(alliedtarget[targetenemy].get_meta("Status") != "Downed"):
				ONEMORE = ONEMORE + 1 
			alliedtarget[targetenemy].set_meta("Status", "Downed")






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
