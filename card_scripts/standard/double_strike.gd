extends Card

func _on_card_play():
    GameManager.instance.damage_enemy(2,true,false)
    GameManager.instance.damage_enemy(2,true,false)