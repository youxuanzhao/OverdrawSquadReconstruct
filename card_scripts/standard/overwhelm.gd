extends Card

func _on_card_play():
    GameManager.instance.damage_enemy(3,true,false)
    GameManager.instance.inflict_status("standard","combo",1,"player")