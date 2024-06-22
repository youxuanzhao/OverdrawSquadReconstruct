extends Card

func _on_card_play():
    GameManager.instance.inflict_status("standard","poison",5,"enemy")