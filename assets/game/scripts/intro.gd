extends Node2D

var game_scene:String = "res://assets/game/scenes/game.tscn"

func _ready() -> void:
	Global.load_data()

func _process(delta: float) -> void:
	if Global.save_data["skip_intro"]:
		get_tree().change_scene_to_file(game_scene)
		return

func _on_animated_sprite_2d_animation_finished() -> void:
	get_tree().change_scene_to_file(game_scene)
