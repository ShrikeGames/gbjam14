extends ColorRect

@export var player: Player
@export var depth_palettes: Array[PackedColorArray]
@export var music_player: AudioStreamPlayer
@export var day_timer:Timer

var current_index: int = 0
var special_palette_active: bool = false

func _ready() -> void:
	update_material(current_index)
	var audio_stream_player_stream = preload("res://assets/game/audio/music_interactive_stream.tres")
	music_player.stream = audio_stream_player_stream
	music_player.play()
	self.visible = true
	material.set_shader_parameter('palette', depth_palettes[current_index])
	
	
	Global.shop_open.connect(_shop_open)
	Global.shop_close.connect(_shop_close)
	
func _shop_open():
	special_palette_active = true
	update_material(5)

func _shop_close():
	special_palette_active = false
	update_material(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if special_palette_active:
		return
	if day_timer and int(day_timer.time_left) % 15 == 0 and day_timer.time_left > day_timer.wait_time * 0.5:
		material.set_shader_parameter('multiplier', 0.5 + (0.5 * (day_timer.time_left/day_timer.wait_time)))
	for i in range(0, len(depth_palettes)):
		if player.global_position.y >= 8 + ((i * 32) * 16) and player.global_position.y < 8 + (((i + 1) * 32) * 16):
			update_material(i)
			break
	
func update_material(index: int):
	if index == current_index:
		return
	current_index = index
	Global.play_audio_clip(music_player, "Music %d" % [index + 1])
	material.set_shader_parameter('palette', depth_palettes[index])
