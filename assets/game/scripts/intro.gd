extends Node2D

var story_scene:String = "res://assets/game/scenes/story.tscn"

func _ready() -> void:
	Global.load_data()

func _process(_delta: float) -> void:
	if Global.save_data["skip_intro"]:
		get_tree().change_scene_to_file(story_scene)
		return
	if Input.is_action_just_pressed("A") or Input.is_action_just_pressed("B") or Input.is_action_just_pressed("START"):
		get_tree().change_scene_to_file(story_scene)
		return

func _on_animated_sprite_2d_animation_finished() -> void:
	get_tree().change_scene_to_file(story_scene)
