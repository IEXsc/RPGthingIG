extends BoxContainer

@onready var AttackButton = $Attack
@onready var SkillButton = $Skill
@onready var DefendButton = $Defend
@onready var ItemsButton = $Items
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AttackButton.pressed.connect(get_parent()._attack_button_pressed)
	SkillButton.pressed.connect(get_parent()._skill_button_pressed)
	DefendButton.pressed.connect(get_parent()._defend_button_pressed)
	ItemsButton.pressed.connect(get_parent()._item_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _hide_buttons():
	AttackButton.visible = false
	SkillButton.visible = false
	ItemsButton.visible = false
	DefendButton.visible = false 
func _show_buttons():
	AttackButton.set_button_icon(get_parent().arrayAttackTypesIcons[get_parent().player.weapon.type])
	AttackButton.visible = true
	SkillButton.visible = true
	DefendButton.visible = true
	ItemsButton.visible = true
