extends CenterContainer
class_name MainMenu

@export var selected_id:int = 0
@export var menu_items:Array[GBMenuItem] = []
@export var sfx_player:AudioStreamPlayer
@export var other_menus:Array[MainMenu]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update()
	var audio_stream_player_stream = preload("res://assets/game/audio/sfx_interactive_stream.tres")
	sfx_player.stream = audio_stream_player_stream
	sfx_player.play()
	
func _update():
	get_tree().paused = self.visible
	menu_items[selected_id].select()
	var id:int = 0
	for menu_item in menu_items:
		if id != selected_id:
			menu_items[id].deselect()
		id += 1
	
func select_option():
	if selected_id == 0:
		self.visible = false
		get_tree().paused = false

func other_options():
	if Input.is_action_just_pressed("START"):
		self.visible = true
		_update()

func _process(_delta: float) -> void:
	if other_menus:
		for other_menu in other_menus:
			if other_menu.visible:
				return
	
	if self.visible:
		if Input.is_action_just_pressed("DOWN"):
			selected_id = wrapi(selected_id+1, 0, len(menu_items))
			Global.play_audio_clip(sfx_player, "Beep 0")
			_update()
		elif Input.is_action_just_pressed("UP"):
			selected_id = wrapi(selected_id-1, 0, len(menu_items))
			Global.play_audio_clip(sfx_player, "Beep 0")
			_update()
		if Input.is_action_just_pressed("B") or Input.is_action_just_pressed("START"):
			select_option()
	else:
		other_options()
