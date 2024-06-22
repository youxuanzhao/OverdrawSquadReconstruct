class_name EnemyHolder
extends Node3D

static var instance : EnemyHolder

var entity_template_scene : PackedScene = preload("res://scene_files/entity_container.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self

func spawn(src: Entity) -> void:
	var temp: EntityContainer = entity_template_scene.instantiate()
	temp.entity = src
	temp.position = Vector3(0,0.2,-0.6)
	add_child(temp)
	temp.enter_combat()

func kill_current_enemy() -> void:
	get_child(0).kill()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass

