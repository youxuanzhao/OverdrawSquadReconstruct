class_name StatusHolder
extends HBoxContainer

var status_template_scene: PackedScene = preload("res://scene_files/status_container.tscn")
static var instance: StatusHolder

func _ready():
	instance = self

func add_status(status:Status):
	var temp: StatusContainer = status_template_scene.instantiate()
	temp.status = status
	add_child(temp)
	temp.initialize()
	temp.status._on_gain_stack()

func check_exist_status(status_name: String) -> bool:
	for i in get_children():
		if i.status.status_name == status_name:
			return true
	
	return false

func add_intensity(intensity: int, status_name: String):
	if check_exist_status(status_name):
		for i in get_children():
			if i.status.status_name == status_name:
				i.status.intensity += intensity
				i.status._on_gain_stack()
				i.update_label()

func _process(delta):
	if get_child_count() > 10:
		pass
