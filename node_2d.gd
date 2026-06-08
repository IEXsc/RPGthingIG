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



##0 Blunt	1Pierce	2Slash |	3Ruin	4Life	5Time	6Space	7Mind	8Chthonic	9Holy	10Arcane	11Healing
var arrayAttackTypesIcons = [BluntTexture, PierceTexture, SlashTexture,RuinTexture, LifeTexture, TimeTexture,SpaceTexture, MindTexture, ChthonicTexture,HolyTexture, ArcaneTexture, HealingTexture]
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
				if(!arrayenemies[i].get_meta("Status", "Downed")):
					totalenemiesup = totalenemiesup - 1 # 1 LESS ENEMY NEEDED FOR AN ALL OUT ATTACK
				arrayenemies.remove_at(i) # Removes it from the array so it's not checked next time
	if(len(arrayenemies)==0):
		_winning_the_battle()

	
		
func _target_button_pressed(pulsanteid):
	targetenemy = pulsanteid
	if(recentaction==1):
		alliedtarget = arrayenemies
		damagethatwillbedone = arrayalleati[currentpartymember].get_meta("Weapon").get_meta("Damage")
		_calculate_damage(arrayalleati[currentpartymember].get_meta("Attack"), arrayalleati[currentpartymember].get_meta("Weapon").get_meta("DamageType"))
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
		add_child(SkillBeingUsed)
		SkillBeingUsed.position = Vector2(alliedtarget[targetenemy].position.x, alliedtarget[targetenemy].position.y)
		SkillBeingUsed.set_sprite_frames(arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Image"))
		SkillBeingUsed.animation_looped.connect(_delete_self.bind(SkillBeingUsed))
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
		var newdefence = arrayalleati[currentpartymember].get_meta("Defense") + 0.5 
		arrayalleati[currentpartymember].set_meta("Defense", newdefence) 
		arrayalleati[currentpartymember].set_meta("Status", "Defending")
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
	for i in range(len(shiftingbuttonsarray)):
		_delete_self(shiftingbuttonsarray[i])
	shiftingbuttonsarray.clear()
	for i in len(enemytargetbuttons):
		_delete_self(enemytargetbuttons[i])
	enemytargetbuttons.clear()
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
		
		targetenemy =  rng.randi_range(0, len(arrayalleati)-1) 
		while(alliedtarget[targetenemy].get_meta("HP")<=0):
			targetenemy =  rng.randi_range(0, len(arrayalleati)-1) 
			
		if(currentenemymove<len(arrayenemies)):
			print("Enemy index ", currentenemymove, " is taking a turn! ONEMORE value is: ", ONEMORE)
			arrayenemies[currentenemymove].play("waiting")
			arrayenemies[currentenemymove].set_meta("Status", "Alive")
			totalenemiesup = totalenemiesup + 1
			enemyaction = randi_range(1, 2) 
			if(enemyaction== 1):
				
				arrayenemies[currentenemymove].position = Vector2(arrayenemies[currentenemymove].position.x, arrayenemies[currentenemymove].position.y + 50)
				damagethatwillbedone = int(round(( arrayenemies[currentenemymove].get_meta("Damage"))))
				_calculate_damage(arrayenemies[currentenemymove].get_meta("Attack"), arrayenemies[currentenemymove].get_meta("DamageType"))
				
			
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
				
				
				
				enemytimer.wait_time = arrayenemies[currentenemymove].get_meta("SpecialMoves")[currentmove].get_meta("AnimationTime")
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
	elif(enemyaction==2):
		currentusedskill.queue_free()
	if(ONEMORE == 0):
		currentenemymove = currentenemymove + 1
	else:
		ONEMORE = ONEMORE - 1
	_singleenemyturn()
	enemytimer.stop()


func _reset_ally_positions():
	for i in len(arrayalleati):
		if(arrayalleati[i].get_meta("HP")>0):
			arrayalleati[i].play("waiting")
		else:
			arrayalleati[i].play("Faint")
		arrayalleati[i].set_meta("Defense", 1)
		arrayalleati[i].set_meta("Attack", 1)
	arrayalleati[0].play("waiting")
	arrayalleati[0].set_meta("Status", "Alive")
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
	
	
	_calculate_total_enemies_buttons()
	recentaction = 0
	
	timer.stop()
	
	var next_turn_found = false
	if(ONEMORE == 0):
		while currentturn < len(arrayalleati) - 1:
			currentturn += 1
			currentpartymember = currentturn
			if(cangetalloutattack==true):
				_delete_self(alloutattackbutton)
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
		else:
			# No more living allies have a move this turn, pass to enemies
			currentturn = 0
			currentpartymember = 0
			$BoxContainer.AttackButton.set_button_icon(arrayAttackTypesIcons[arrayalleati[currentpartymember].get_meta("Weapon").get_meta("DamageType")])
			_enemyturn()
	else:
		ONEMORE = ONEMORE - 1

func _create_targeting_buttons():
	if(recentaction==4):
		var movetype = arrayalleati[currentpartymember].get_meta("CharacterGod").get_meta("SpecialMoves")[currentusedskill].get_meta("Type")
		if(movetype < 11):
			for i in len(arrayenemies):
				_create_target_button_enemies(i, movetype)
		if(movetype == 11):
			for i in len(arrayalleati):
				_create_target_button_allies(i)
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
	if(arrayenemies[i].get_meta("Affinities")[movetype] > 1 ):
		var weak = Sprite2D.new()
		add_child(weak)
		enemytargetbuttons.append(weak)
		weak.position = Vector2(positioninfo, arrayenemies[i].position.y - 36)
		weak.set_texture(WeakTexture)
	elif(arrayenemies[i].get_meta("Affinities")[movetype] < 0 ):
		var weak = Sprite2D.new()
		add_child(weak)
		enemytargetbuttons.append(weak)
		weak.position = Vector2(positioninfo, arrayenemies[i].position.y - 36)
		weak.set_texture(AbsorbsTexture)
	elif(arrayenemies[i].get_meta("Affinities")[movetype] < 1 ):
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
		cangetalloutattack = false
		_delete_self(alloutattackbutton)
		for i in range(len(shiftingbuttonsarray)):
			_delete_self(shiftingbuttonsarray[i])
		shiftingbuttonsarray.clear()
		_show_button()

func _calculate_damage(attackbonus,attacktype):
	var newhp = 0
	damagethatwillbedone = int(damagethatwillbedone * rng.randf_range(0.8, 1.2))
	if(alliedtarget == arrayenemies):
		newhp = alliedtarget[targetenemy].get_meta("HP") - ( damagethatwillbedone / alliedtarget[targetenemy].get_meta("Defense") * attackbonus * alliedtarget[targetenemy].get_meta("Affinities")[attacktype])
	
	if(alliedtarget == arrayalleati):
		newhp = alliedtarget[targetenemy].get_meta("HP") - ( damagethatwillbedone / alliedtarget[targetenemy].get_meta("Defense") * attackbonus * alliedtarget[targetenemy].get_meta("CharacterGod").get_meta("Affinities")[attacktype])
	
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
			
	if(alliedtarget == arrayalleati):         ## ENEMIES ARE ATTACKING
		AlliedHealthBars[targetenemy].set_value(newhp)
		if(alliedtarget[targetenemy].get_meta("CharacterGod").get_meta("Affinities")[attacktype] > 1 ):
			alliedtarget[targetenemy].play("downed")
			if(alliedtarget[targetenemy].get_meta("Status") != "Downed" and alliedtarget[targetenemy].get_meta("Status") != "Defending"):
				enemytimer.wait_time = enemytimer.wait_time + 1
				ONEMORE = 1 
				alliedtarget[targetenemy].set_meta("Status", "Downed")
		if(alliedtarget[0].get_meta("HP")<=0):
			_losing_the_battle()

	
	elif(alliedtarget == arrayenemies):      ## WE ARE ATTACKING
		if (alliedtarget[targetenemy].get_meta("Affinities")[attacktype] > 1 ):
			alliedtarget[targetenemy].play("downed")
			
			if(alliedtarget[targetenemy].get_meta("Status") != "Downed"):  ## ATTACKED A WEAK ENEMY NOT DOWNED
				_create_shifting_button()
				_create_weakness_cutaway()
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
			

func _create_all_out_attack_button():
	if(cangetalloutattack == true):
		alloutattackbutton = Button.new()
		add_child(alloutattackbutton)
		alloutattackbutton.flat = true
		alloutattackbutton.position = Vector2(862-64, 160-32)
		alloutattackbutton.set_button_icon(AllOutAttackAnim)
		alloutattackbutton.pressed.connect(_all_out_attack_pressed.bind(alloutattackbutton))
		alloutattackbutton.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER

func _all_out_attack_pressed(buttontodelete):
	if(recentaction==0 and cangetalloutattack == true):
		alliedtarget = arrayenemies
		for i in range(len(alliedtarget)):
			targetenemy = i
			damagethatwillbedone = 100
			_calculate_damage(1, 10)  #ARCANE SO NO ONE RESISTS THEM
		var AllOutAttack = AnimatedSprite2D.new()
		add_child(AllOutAttack)
		AllOutAttack.position = Vector2(862, 160)
		AllOutAttack.set_sprite_frames(AllOutAttackTexture)
		AllOutAttack.play("default")
		enemytargetbuttons.append(AllOutAttack)
		cangetalloutattack==false
		recentaction=7
		for i in range(len(shiftingbuttonsarray)):
			_delete_self(shiftingbuttonsarray[i])
		shiftingbuttonsarray.clear()
		timer.wait_time = 2
		_start_le_timer()

func _create_weakness_cutaway():
	var WaeknessCutaway = AnimatedSprite2D.new()
	add_child(WaeknessCutaway)
	WaeknessCutaway.position = Vector2(arrayalleati[i].position.x -36, arrayalleati[i].position.y - 36)
	WaeknessCutaway.set_sprite_frames(HittingWeaknessTexture)
	WaeknessCutaway.play("default")
	WaeknessCutaway.animation_looped.connect(_deleteweaknesscutaway.bind(WaeknessCutaway))
	timer.wait_time = timer.wait_time + 1

func _deleteweaknesscutaway(WaeknessCutaway):
	WaeknessCutaway.queue_free()

func _setting_up_enemies(): ##CAUSE APPARENTLY CODE IN CHILDREN IS RAN BEFORE THE PARENTS, FUCKING BULLSHIT!!!
	var TungTungEnemy = get_parent().TungTung
	var AngelTungTung = get_parent().AngelTungTung
	var Enemies = [TungTungEnemy]
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
