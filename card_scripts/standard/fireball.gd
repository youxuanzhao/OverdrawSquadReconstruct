extends Card

func _on_card_play():
    GameManager.instance.damage_enemy(6,true,true)