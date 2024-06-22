extends Card

static var extra_damage: int = 0

func _on_card_play():
    var temp = GameManager.instance.damage_enemy(5+extra_damage,true,false)
    if temp:
        extra_damage+=1