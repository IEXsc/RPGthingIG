extends Node

## https://docs.google.com/spreadsheets/d/1moa-AuzmRn1FMVouLuWMqBgxDgxjbl1clZQZNK0O6sg/edit?gid=0#gid=0
## FOR SKILL TYPES
# TODO: ADD ALIMENTS
# TODO: ADD TECNICALS OR SOMETHING SIMILIAR
# TODO: ADD CHAINLESS MODE ( THINK ABOUT IT TOMORROW )
# TODO: MAKE THE ENEMIES ABLE TO DO A NORMAL ATTACK IF THIER ABILITY FAILS / CANNOT BE DONE
# TODO: MAKE IT RARER FOR THEM TO USE THINGS LIKE BOOSTING MOVES ( ESPECIALLY THINGS LIKE CONCENTRATE )
# TODO: ADD TEACH'S INSTRUCTIONS
# TODO: IF EVERYTHING ELSE HAS BEEN DONE, ADD KEYBINDS TO EVERYTHING SO WE CAN USE THE KEYBOARD TO PLAY ( HARDEST THING PROBS )





var beatrice = preload("res://Things/Characters/Beatrice.tres")
var player = preload("res://Things/Characters/Player.tres")
var minotaur = preload("res://Things/Enemies/Minotaur.tres")

# Core Battle Arrays
var arrayenemies: Array[Character] = []
var arrayalleati: Array[Character] = []
var Items: Array[Item] = []

# Battle State Variables
var targetenemy = 0
var i = 0
var recentaction = 0
var currentenemymove = 0
var currentpartymember = 0
var currentusedskill: int = 0
var currentturn = 0
var alliedtarget: Array[Character] = []
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
	_setting_up_enemies()
	arrayalleati = [player, beatrice]

func _process(delta: float) -> void:
	pass



func _calculate_total_enemies():
	for i in range(arrayenemies.size() - 1, -1, -1):
		var enemy: Character = arrayenemies[i]
		if is_instance_valid(enemy):
			if enemy.hp <= 0:
				if enemy.status != "Downed":
					totalenemiesup = totalenemiesup - 1 
				arrayenemies.remove_at(i) 
	if len(arrayenemies) == 0:
		_winning_the_battle()

func _enemyturn():
	_singleenemyturn()
		
func _singleenemyturn():
	for i in range(len(arrayalleati)):
		if arrayalleati[i].hp > 0:
			atleastonecharalive = true
			break
		else:
			atleastonecharalive = false
			
	if atleastonecharalive == true:
		if currentenemymove < len(arrayenemies):
			if arrayenemies[currentenemymove].status == "Downed":
				arrayenemies[currentenemymove].status = "Alive"
				totalenemiesup = totalenemiesup + 1
			enemyaction = randi_range(1, 2) 
			
			if enemyaction == 1:
				alliedtarget = arrayalleati
				targetenemy = rng.randi_range(0, len(arrayalleati)-1) 
				while alliedtarget[targetenemy].hp <= 0:
					targetenemy = rng.randi_range(0, len(arrayalleati)-1) 
				
				damagethatwillbedone = int(round((arrayenemies[currentenemymove].weapon.damage)))
				var attackbonus = 1
				if arrayenemies[currentenemymove].attack > 0:
					attackbonus = 1.5
				if arrayenemies[currentenemymove].attack < 0:
					attackbonus = 0.5
				_calculate_damage(attackbonus, arrayenemies[currentenemymove].weapon.type)
				
			if enemyaction == 2:
				var usableskill = false
				var currentmove = 0
				var movetype = 0
				var attackbonus = 1
				var enemymovetargets = ""
				
				while usableskill == false:
					currentmove = randi_range(0, len(arrayenemies[currentenemymove].soul.specialmoves)-1)
					movetype = arrayenemies[currentenemymove].soul.specialmoves[currentmove].type
					
					if movetype < 12:
						if movetype < 11:   
							alliedtarget = arrayalleati
							targetenemy = rng.randi_range(0, len(alliedtarget)-1)    
							while alliedtarget[targetenemy].hp <= 0:
								targetenemy = rng.randi_range(0, len(alliedtarget)-1)
							
							if arrayenemies[currentenemymove].attack > 0:
								attackbonus = 1.5
							if arrayenemies[currentenemymove].attack < 0:
								attackbonus = 0.5
							usableskill = true  
								
						elif movetype == 11:  
							alliedtarget = arrayenemies
							targetenemy = rng.randi_range(0, len(alliedtarget)-1)    
							while alliedtarget[targetenemy].hp <= 0:   
								targetenemy = rng.randi_range(0, len(alliedtarget)-1)
							
							var anyenemybelow20percenthp = false    
							for i in len(alliedtarget):  
								var currentenemyhealth = float(alliedtarget[targetenemy].hp) 
								currentenemyhealth = currentenemyhealth / alliedtarget[targetenemy].max_hp  
								if currentenemyhealth < 0.20:
									anyenemybelow20percenthp = true
									usableskill = true
									break
							if anyenemybelow20percenthp == false:
								usableskill = false
								
						if usableskill == true:
							enemymovetargets = arrayenemies[currentenemymove].soul.specialmoves[currentmove].targets
							damagethatwillbedone = int(round((arrayenemies[currentenemymove].soul.specialmoves[currentmove].damage)))
							if enemymovetargets == "One" or enemymovetargets == "OneAlly":
								_calculate_damage(attackbonus, movetype)  
							elif enemymovetargets == "AllEnemies" or enemymovetargets == "AllAllies":
								for i in len(alliedtarget):
									targetenemy = i
									_calculate_damage(attackbonus, movetype)
									
					elif movetype == 12 or movetype == 13:
						usableskill = true
						alliedtarget = arrayenemies
						targetenemy = rng.randi_range(0, len(alliedtarget)-1)    
						while alliedtarget[targetenemy].hp <= 0:   
							targetenemy = rng.randi_range(0, len(alliedtarget)-1)
							 
						damagethatwillbedone = arrayenemies[currentenemymove].soul.specialmoves[currentmove].damage
						if enemymovetargets == "One" or enemymovetargets == "OneAlly":
							_calculate_damage(1, movetype)  
						elif enemymovetargets == "AllEnemies" or enemymovetargets == "AllAllies":
							for i in len(alliedtarget):
								targetenemy = i
								_calculate_damage(1, movetype)
								
					elif movetype == 14 or movetype == 15:
						usableskill = true
						alliedtarget = arrayalleati
						targetenemy = rng.randi_range(0, len(alliedtarget)-1)    
						while alliedtarget[targetenemy].hp <= 0:
							targetenemy = rng.randi_range(0, len(alliedtarget)-1)
						
						damagethatwillbedone = arrayenemies[currentenemymove].soul.specialmoves[currentmove].damage
						if enemymovetargets == "One" or enemymovetargets == "OneAlly":
							_calculate_damage(1, movetype)  
						elif enemymovetargets == "AllEnemies" or enemymovetargets == "AllAllies":
							for i in len(alliedtarget):
								targetenemy = i
								_calculate_damage(1, movetype)
			
			if arrayenemies[currentenemymove].attack > 0:   
				arrayenemies[currentenemymove].attack -= 1
			if arrayenemies[currentenemymove].attack > 0:  
				arrayenemies[currentenemymove].defense -= 1
			if arrayenemies[currentenemymove].attack < 0:
				arrayenemies[currentenemymove].defense += 1
			if arrayenemies[currentenemymove].defense < 0:
				arrayenemies[currentenemymove].defense += 1
		else:
			_reset_ally_positions()
			currentusedskill = 0
			currentenemymove = 0
			
	elif atleastonecharalive == false:
		_losing_the_battle()

func _reset_stat_boosts(target):
	if arrayalleati[target].attack > 0:   
		arrayalleati[target].attack -= 1
	if arrayalleati[target].attack < 0:
		arrayalleati[target].attack += 1 
		
	if arrayalleati[target].defense > 0:  
		arrayalleati[target].defense -= 1
	if arrayalleati[target].defense < 0:
		arrayalleati[target].defense += 1
	
	if arrayalleati[target].crit_chance > 0:  
		arrayalleati[target].crit_chance -= 1
	if arrayalleati[target].crit_chance < 0:
		arrayalleati[target].crit_chance += 1

func _reset_ally_positions():
	_reset_stat_boosts(currentpartymember)
	arrayalleati[0].defense_from_parrying = 1
	arrayalleati[0].status = "Alive"

func _calculate_damage(attackbonus, attacktype):
	var is_a_crit = false
	var newhp = 0
	const crittreshold = 0.9
	if attacktype < 12:
		damagethatwillbedone = damagethatwillbedone * rng.randf_range(0.8, 1.2)
		
		if alliedtarget == arrayenemies:
			var standarddefence = 1
			if alliedtarget[targetenemy].defense > 0:
				standarddefence = 1.5
			elif alliedtarget[targetenemy].defense < 0:
				standarddefence = 0.5
			
			damagethatwillbedone = int(round(damagethatwillbedone * attackbonus / standarddefence * alliedtarget[targetenemy].soul.affinities[attacktype]))
			
			if attacktype <= 2:  
				var standardcritchance = 0
				if arrayalleati[currentpartymember].crit_chance > 0:
					standardcritchance = 0.25
				
				var critchance = rng.randf_range(0, 1)
				if critchance > crittreshold - standardcritchance:
					is_a_crit = true
					damagethatwillbedone = int(round(damagethatwillbedone * 1.5))
			
			newhp = alliedtarget[targetenemy].hp - damagethatwillbedone
		
		if alliedtarget == arrayalleati:
			var standarddefence = 1
			if alliedtarget[targetenemy].defense > 0:
				standarddefence = 1.5
			elif alliedtarget[targetenemy].defense < 0:
				standarddefence = 0.5
			damagethatwillbedone = int(round(damagethatwillbedone * attackbonus / alliedtarget[targetenemy].defense_from_parrying / standarddefence * alliedtarget[targetenemy].soul.affinities[attacktype])) 
			
			if attacktype <= 2:    
				var standardcritchance = 0
				var critchance = rng.randf_range(0, 1)
				if critchance > crittreshold:
					is_a_crit = true
					damagethatwillbedone = int(round(damagethatwillbedone * 1.5))
			
			newhp = alliedtarget[targetenemy].hp - damagethatwillbedone

		if newhp > alliedtarget[targetenemy].max_hp:
			alliedtarget[targetenemy].hp = alliedtarget[targetenemy].max_hp
		elif newhp <= 0:          
			alliedtarget[targetenemy].hp = 0
		else:
			alliedtarget[targetenemy].hp = newhp
			
	if alliedtarget == arrayalleati:         
		if attacktype < 12:
			if alliedtarget[targetenemy].soul.affinities[attacktype] > 1 or is_a_crit == true:
				if alliedtarget[targetenemy].status != "Downed" and alliedtarget[targetenemy].status != "Defending":
					ONEMORE = 1 
					alliedtarget[targetenemy].status = "Downed"
				
			if alliedtarget[0].hp <= 0:
				_losing_the_battle()
		elif attacktype == 12 or attacktype == 14:       
			alliedtarget[targetenemy].attack += damagethatwillbedone 
		elif attacktype == 13 or attacktype == 15:   
			alliedtarget[targetenemy].defense += damagethatwillbedone
		elif attacktype == 16:   
			alliedtarget[targetenemy].crit_chance += damagethatwillbedone
		
	elif alliedtarget == arrayenemies:      
		if attacktype < 12:
			var unusedtype = false
			if alliedtarget[targetenemy].soul.discoveredaffinities[attacktype] != alliedtarget[targetenemy].soul.affinities[attacktype]:
				alliedtarget[targetenemy].soul.discoveredaffinities[attacktype] = alliedtarget[targetenemy].soul.affinities[attacktype]
				unusedtype = true
				
			if alliedtarget[targetenemy].soul.affinities[attacktype] > 1 or is_a_crit == true:
				if alliedtarget[targetenemy].status != "Downed":  
					ONEMORE = 1 
					totalenemiesup = totalenemiesup - 1
					cangetalloutattack = false 
					if totalenemiesup == 0:
						cangetalloutattack = true 
						
					alliedtarget[targetenemy].status = "Downed"
		elif attacktype == 12 or attacktype == 14:       
			alliedtarget[targetenemy].attack += damagethatwillbedone
		elif attacktype == 13 or attacktype == 15:      
			alliedtarget[targetenemy].defense += damagethatwillbedone
		elif attacktype == 16:      
			alliedtarget[targetenemy].crit_chance += damagethatwillbedone

func _setting_up_enemies(): 
	var Enemies: Array[Character] = [minotaur]
	for i in range(len(Enemies)):
		var nem1 = Enemies[i].duplicate()
		arrayenemies.append(nem1) 
	totalenemiesup = len(arrayenemies)

func _losing_the_battle():
	var Losing = get_parent().LosingScene.instantiate()
	get_parent().add_child(Losing)
	queue_free()

func _winning_the_battle():
	var Winning = get_parent().WinningScene.instantiate()
	get_parent().add_child(Winning)
	queue_free()
