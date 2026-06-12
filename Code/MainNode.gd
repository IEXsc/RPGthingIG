extends Node

@onready var StartingLabel = $StartingLabel
@onready var StartGame = $StartGame

var BattleScene = preload("res://Sceenes/BattleLogic.tscn")
var LosingScene = preload("res://Sceenes/failure_screen.tscn")
var WinningScene = preload("res://Sceenes/victory_screen.tscn")

var EnergyDrink = preload("res://Things/Items/EnergyDrink.tres")

var Items: Array[Item] = [EnergyDrink]


func _ready() -> void:
	pass

func _on_start_game_pressed() -> void:
	StartGame.queue_free()
	StartingLabel.queue_free()
	var Battle = BattleScene.instantiate()
	add_child(Battle)
