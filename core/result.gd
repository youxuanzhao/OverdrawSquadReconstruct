class_name Result

enum ResultTypes {
    Damage,
    Absorb,
}

var result_type: ResultTypes
var is_hit: bool
var is_crit: bool
var damage_amount: int

func _init(type: ResultTypes):
    result_type = type

func serialized(input: Array):
    if result_type == ResultTypes.Damage:
        is_hit = input[0]
        is_crit = input[1]
        damage_amount = input[2]
        print(str(result_type,is_hit,is_crit,damage_amount)) 
