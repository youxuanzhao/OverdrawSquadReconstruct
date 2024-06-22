extends Entity

func _init():
	intent_cycle = IntentCycle.new([AttackIntent.new(2,3.0,0),AttackIntent.new(4,3.0,0),AttackIntent.new(6,3.0,0)]);
	super._init()
