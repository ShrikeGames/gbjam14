extends MainMenu

class_name TitleMenu
var story_scene: String = "res://assets/game/scenes/story.tscn"
var options_scene: String = "res://assets/game/scenes/options.tscn"
func _ready() -> void:
	super._ready()

func select_option():
	if selected_id == 0:
		get_tree().change_scene_to_file(story_scene)
		Global.play_audio_clip(sfx_player, "Beep 0")
		return
	elif selected_id == 1:
		Global.save_data = Global.DEFAULT_SAVE_DATA.duplicate(true)
		get_tree().change_scene_to_file(story_scene)
		Global.play_audio_clip(sfx_player, "Beep 0")
		return
	elif selected_id == 2:
		get_tree().change_scene_to_file(options_scene)
		Global.play_audio_clip(sfx_player, "Beep 0")
		return
