class_name Status

var status_name: String
var status_display_name: String
var intensity: int
var is_active: bool = false
var can_stack: bool
var decay_time: float
var resource : CompressedTexture2D
var status_data: Dictionary
var status_set: String
var target: String


func remove_all_stacks() -> void:
	intensity = 0


func _on_effect_trigger():
	pass

func get_name() -> String:
	if status_name != null:
		return status_name
	else:
		return ""

func get_intensity() -> int:
	if intensity == null:
		return 0
	else:
		return intensity

func _on_decay():
	pass

func _on_gain_stack():
	pass

func load_data(data: Dictionary,statusSet: String) -> void:
	status_data = data
	status_set = statusSet
	status_name = data["status_name"]
	status_display_name = data["status_display_name"]
	decay_time = data["decay_time"]
	can_stack = data["can_stack"]
	resource = load(str("res://assets/status/", status_set, "/",data["resource"]))
