class_name StatusContainer
extends TextureProgressBar

var status: Status
var is_active: bool
var can_decay: bool

@onready var tooltip: Sprite2D = $Tooltip
@onready var label: Label = $Label
@onready var timer: Timer = $Timer

func initialize():
	timer = $Timer
	label = $Label
	tooltip = $Tooltip
	timer.one_shot = false
	is_active = true
	if status.decay_time != -1:
		can_decay = true
		timer.start(status.decay_time)
	else:
		can_decay = false
	tooltip.texture = status.resource

func _process(delta):
	update_label()
	if can_decay:
		value = (timer.time_left/status.decay_time) * 10
	
	if status.intensity <= 0:
		queue_free()

func update_label():
	label.text = str(status.intensity)


func _on_timer_timeout():
	status._on_decay()
