class_name Equipment

var equipment_data: Dictionary
var equipment_set: String
var equipment_name: String
var equipment_display_name: String
var equipment_display_name_bbcode: String
var equipment_body_part: String
var equipment_display_desc: String
var equipment_display_desc_bbcode: String
var equipment_desc: String
var rarity: String
var resource: CompressedTexture2D

var timer_id: int
var default_countdown : float = 2.0
var cost: float = 5.0


var isPaused: bool = false

signal s_pause_resume()

# Override Funcion Set
func _on_equipment_equip() -> void:
	timer_id = GameManager.instance.request_timer(true,false,default_countdown)
	instance_from_id(timer_id).timeout.connect(_on_timeout)
	
func kill_timer() -> void:
	instance_from_id(timer_id).timeout.disconnect(_on_timeout)
	instance_from_id(timer_id).free()


func _on_equipment_drop() -> void:
	pass

func _on_timeout() -> void:
	pass

func _on_activate() -> void:
	pass

func _set_property() -> void:
	pass
# Feature Function Set
func get_body_part() -> String:
	return equipment_body_part

func pause_resume() -> void:
	isPaused = not isPaused
	s_pause_resume.emit()
	instance_from_id(timer_id).paused = isPaused

func load_data(data: Dictionary, equipSet: String) -> void:
	equipment_data = data
	equipment_set = equipSet
	equipment_name = data["equipment_name"]
	equipment_display_name = data["equipment_display_name"]
	equipment_display_name_bbcode = data["equipment_display_name_bbcode"]
	equipment_body_part = data["equipment_body_part"]
	equipment_desc = data["equipment_desc"]
	equipment_display_desc = data["equipment_display_desc"]
	equipment_display_desc_bbcode = data["equipment_display_desc_bbcode"]
	rarity = data["rarity"]
	cost = data["cost"]
	resource = load(str("res://assets/equipment/", equipment_set, "/",data["equipment_resource"]))

func _init() -> void:
	_set_property()

func _ready() -> void:
	pass



func get_remaining_time() -> float:
	return instance_from_id(timer_id).time_left

func get_total_time() -> float:
	return default_countdown

func _process(delta) -> void:
	pass
