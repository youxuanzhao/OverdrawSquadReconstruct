extends Card

func _on_card_play():
    GameManager.instance.kill_enemy()