extends Card

func _on_card_play():
    GameManager.instance.damage_enemy(1,true,true)
    GameManager.instance.damage_enemy(1,true,true)
    GameManager.instance.damage_enemy(1,true,true)
    GameManager.instance.damage_enemy(1,true,true)
    GameManager.instance.inflict_status("standard","benumb",1,"enemy")