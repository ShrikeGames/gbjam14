extends MainMenu

class_name TitleMenu
var story_scene: String = "res://assets/game/scenes/story.tscn"

func _ready() -> void:
	super._ready()

func select_option():
	if selected_id == 0:
		get_tree().change_scene_to_file(story_scene)
		return
	elif selected_id == 1:
		Global.save_data = Global.DEFAULT_SAVE_DATA.duplicate(true)
		get_tree().change_scene_to_file(story_scene)
		return
