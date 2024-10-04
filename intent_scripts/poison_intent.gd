class_name PoisonIntent

extends Intent


func _init(intensity: int, wait_time: float, priority: int):
	tooltip_image = preload("res://assets/intent/poison.png")
	has_number = true
	intent_name = "poison"
	intent_wait_time = wait_time
	intent_number = intensity
	intent_priority = priority

func _effect():
	GameManager.instance.inflict_status("standard","poison",intent_number,"player")