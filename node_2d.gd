## FINALLY ADD WEAKNESSES
## MAYBE UPDATE THE WAY DAMAGE IS CALCULATED FFS

## https://docs.google.com/spreadsheets/d/1moa-AuzmRn1FMVouLuWMqBgxDgxjbl1clZQZNK0O6sg/edit?gid=0#gid=0
## FOR SKILL TYPES

extends Node2D
@onready var BackButton = $Back
@onready var PlayerInfo = $PlayerInfo
@onready var BattleLog = $Summary

@onready var SelectingEnemyAnim = load("res://SelectingEnemyButton.tres")

@onready var PlayerProgressBar = $PlayerProgressBar
@onready var AllyProgressBar = $AllyProgressBar
@onready var PlayerHpIndicator = $PlayerHpIndicator
@onready var AllyHpIndicator = $AllyHpIndicator

var timer = Timer.new()
### TEXTURES
var AllyHPIndicatorTexture = load("res://AlliesorYourself/HPindicators/AllyHPIndicator.png")
var AllyHPIndicatorDEADTexture = load("res://AlliesorYourself/HPindicators/AllyHPIndicatorDEAD.png")
var PlayerHPIndicatorTexture = load("res://AlliesorYourself/HPindicators/PlayerHPIndicator.png")
var PlayerHPIndicatorDEADTexture = load("res://AlliesorYourself/HPindicators/PlayerHPIndicatorDEAD.png")

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

var atleastonecharalive = true
func _ready() -> void:
	AlliedHealthBars = [PlayerProgressBar, AllyProgressBar]
	AlliedHpIndicator = [PlayerHpIndicator, AllyHpIndicator]
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
	Ally1.position = Vector2(930, 260)
	add_child(Ally1)
	
	arrayalleati = [Player, Ally1]
	Player.play("waiting")
	Ally1.play("waiting")
	
	PlayerProgressBar.set_max(Player.get_meta("maxHP"))
	PlayerProgressBar.set_value(Player.get_meta("HP"))
	
	AllyProgressBar.set_max(Ally1.get_meta("maxHP"))
	AllyProgressBar.set_value(Ally1.get_meta("HP"))
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
		_calculate_damage()
	if(recentaction==4):
		var movetype = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Type")
		var newsp = arrayalleati[currentpartymember].get_meta("SP") - arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Cost")
		arrayalleati[currentpartymember].set_meta("SP", newsp)
		if(movetype<11):
			alliedtarget = arrayenemies
			damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
			_calculate_damage()
		elif(movetype==11):
			alliedtarget = arrayalleati
			damagethatwillbedone = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Damage")
			_calculate_damage()
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
			_calculate_damage()
		elif(Items[currentuseditem].get_meta("Type")==1):
			alliedtarget = arrayalleati
			for i in range(len(alliedtarget)):
				targetenemy = i
				damagethatwillbedone = Items[currentuseditem].get_meta("Damage")
				_calculate_damage()
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
						
			enemyaction = randi_range(1, 2) 
			if(enemyaction== 1):
				
				arrayenemies[currentenemymove].position = Vector2(arrayenemies[currentenemymove].position.x, arrayenemies[currentenemymove].position.y + 50)
				damagethatwillbedone = int(round(( arrayenemies[currentenemymove].get_meta("Damage") / alliedtarget[targetenemy].get_meta("Defense"))))
				_calculate_damage()
				
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
				
				damagethatwillbedone = int(round(( arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("Damage") / alliedtarget[targetenemy].get_meta("Defense"))))
				_calculate_damage()
				
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
	var Enemies = [AngelTungTung, TungTungEnemy]
	for i in range(len(Enemies)):
		var nemtype = Enemies[i]
		var nem = AnimatedSprite2D.new()
		add_child(nem)
		nem.set_meta("HP", nemtype.get_meta("HP"))
		nem.set_meta("maxHP", nemtype.get_meta("maxHP"))
		nem.set_meta("Name", nemtype.get_meta("Name"))
		nem.set_meta("Damage", nemtype.get_meta("Damage"))
		nem.set_meta("SpecialMoves", nemtype.get_meta("SpecialMoves"))
		nem.set_sprite_frames(nemtype.get_sprite_frames())
		nem.position = Vector2(830+50*i, 150)
		nem.play("waiting")
		arrayenemies.append(nem) 

func _calculate_damage():
	var newhp = alliedtarget[targetenemy].get_meta("HP") - damagethatwillbedone
	if(newhp>alliedtarget[targetenemy].get_meta("maxHP")):
		newhp = alliedtarget[targetenemy].get_meta("maxHP")
		alliedtarget[targetenemy].set_meta("HP", newhp)
	elif(newhp<=0):
		alliedtarget[targetenemy].set_meta("HP", 0)
		alliedtarget[targetenemy].play("Faint")
	else:
		alliedtarget[targetenemy].set_meta("HP", newhp)
		if(alliedtarget[targetenemy].get_meta("HP")>0):
			alliedtarget[targetenemy].play("waiting")
	if(alliedtarget == arrayalleati):
		AlliedHealthBars[targetenemy].set_value(newhp)
		if(alliedtarget[0].get_meta("HP")<=0):
			_losing_the_battle()




func _losing_the_battle():
	var Losing = get_parent().LosingScene.instantiate()
	get_parent().add_child(Losing)
	queue_free()

func _winning_the_battle():
	var Winning = get_parent().WinningScene.instantiate()
	get_parent().add_child(Winning)
	queue_free()
