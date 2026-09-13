extends ColorRect

@export var player:Player
@export var depth_palettes:Array[PackedVector3Array]
@export var music_player:AudioStreamPlayer
var current_index:int = -1

func _ready() -> void:
	update_material(current_index)
	var audio_stream_player_stream = preload("res://assets/game/audio/music_interactive_stream.tres")
	music_player.stream = audio_stream_player_stream
	music_player.play()
	self.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for i in range(0, len(depth_palettes)):
		if player.global_position.y >= 8+((i*32)*16) and player.global_position.y < 8+(((i+1)*32)*16):
			update_material(i)
			break
	
func update_material(index:int):
	if index == current_index:
		return
	current_index = index
	Global.play_audio_clip(music_player, "Music %d"%[index+1])
	material.set_shader_parameter('palette', depth_palettes[index])
