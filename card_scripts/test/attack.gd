extends Card

func _on_card_play():
	GameManager.instance.damage_enemy(5,true,true)
