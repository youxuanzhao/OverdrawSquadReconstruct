extends Card

func _on_card_play():
    var temp = GameManager.instance.discard_all() - 1
    for i in range(temp):
     GameManager.instance.damage_enemy(4,true,false)