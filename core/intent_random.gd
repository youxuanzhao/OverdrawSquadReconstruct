class_name IntentRandom

var random_list : Array[Intent] = []
var random_chance : Array = []
var total_chance : float = 0

var cycle_count: int = 0


func _init(list: Array[Intent],chance: Array):
    if list.size() != chance.size():
        push_error("Chance list not match")
        return
    else:
	    random_list = list
        random_chance = chance
        for i in random_chance:
            total_chance += i

func random() -> float:
    var temp = randf_range(0,total_chance)
    



	cycle_list[cycle_count]._effect()
	cycle_count +=1
	if cycle_count >= cycle_list.size():
		cycle_count = 0
	return cycle_list[cycle_count].intent_wait_time

func get_current_intent() -> Intent:
	return cycle_list[cycle_count]
