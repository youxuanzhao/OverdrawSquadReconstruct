extends Entity

func _init():
	intent_cycle = IntentCycle.new([AttackIntent.new(2,5.0,0),AttackIntent.new(4,7.0,0),PoisonIntent.new(4,10.0,0)]);
	super._init()
