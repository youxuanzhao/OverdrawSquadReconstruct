class_name Card

var type: String
var card_set: String
var card_name: String
var card_display_name: String
var card_display_name_bbcode: String
var card_desc: String
var card_display_desc: String
var card_display_desc_bbcode: String
var card_resource: CompressedTexture2D
var card_data: Dictionary

# Default asset
var card_frame_resource: CompressedTexture2D = preload("res://assets/general/card_frame.png")
var card_back_resource: CompressedTexture2D = preload("res://assets/general/card_back.png")


func _on_card_discard() -> void:
	pass

func _on_card_play() -> void:
	pass

func _set_property() -> void:
	pass

func load_data(data: Dictionary,cardSet: String) -> void:
	card_data = data
	card_set = cardSet
	type = data["type"]
	card_name = data["card_name"]
	card_display_name = data["card_display_name"]
	card_display_name_bbcode = data["card_display_name_bbcode"] 
	card_desc = data["card_desc"]
	card_display_desc = data["card_display_desc"]
	card_display_desc_bbcode = data["card_display_desc_bbcode"]
	card_resource = load(str("res://assets/card/", card_set, "/",data["card_resource"]))

func get_data() -> Dictionary:
	return card_data
