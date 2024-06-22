extends Card

func _on_card_play():
    GameManager.instance.damage_enemy(4,true,false)
    GameManager.instance.activate("mainHand")