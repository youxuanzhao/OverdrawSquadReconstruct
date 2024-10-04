class_name IntentCycle

var cycle_list : Array[Intent] = []

var cycle_count: int = 0


func _init(list: Array[Intent]):
	cycle_list = list

func cycle() -> float:

	cycle_list[cycle_count]._effect()
	cycle_count +=1
	if cycle_count >= cycle_list.size():
		cycle_count = 0
	return cycle_list[cycle_count].intent_wait_time

func skip() -> float:
	cycle_count +=1
	if cycle_count >= cycle_list.size():
		cycle_count = 0
	return cycle_list[cycle_count].intent_wait_time

func get_current_intent() -> Intent:
	return cycle_list[cycle_count]
