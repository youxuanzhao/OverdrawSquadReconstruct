extends Card

func _on_card_play():
    GameManager.instance.damage_enemy(20,false,true)
    GameManager.instance.recover_health(-10)