class_name AttackIntent

extends Intent



func _init(damage: int, wait_time: float, priority: int):
	tooltip_image = preload("res://assets/intent/attack_intent.png")
	has_number = true
	intent_name = "attack"
	intent_wait_time = wait_time
	intent_number = damage
	intent_priority = priority

func _effect():
	GameManager.instance.damage_player(intent_number,false)
