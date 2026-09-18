extends TitleMenu

class_name OptionsMenu
@export var option_menu_items: Array[GBOptionsMenuItem] = []
func _ready() -> void:
	super._ready()
	if Global.save_data["language"] == "ja":
		var options_menu_item:GBOptionsMenuItem = option_menu_items[0]
		options_menu_item.toggle_sprite.frame = 1
	if Global.save_data["skip_intro"]:
		var options_menu_item:GBOptionsMenuItem = option_menu_items[1]
		options_menu_item.toggle_sprite.frame = 1
	if Global.save_data["volume"]:
		var options_menu_item:GBOptionsMenuItem = option_menu_items[2]
		options_menu_item.toggle_sprite.frame = clampi(int(Global.save_data["volume"]/10.0),0,80)
	

func select_option():
	if selected_id == 0:
		var options_menu_item:GBOptionsMenuItem = menu_items[selected_id]
		options_menu_item.toggle_sprite.frame = wrapi(options_menu_item.toggle_sprite.frame+1, 0, options_menu_item.sprite_frames.get_frame_count("default"))
		if options_menu_item.toggle_sprite.frame == 0:
			TranslationServer.set_locale("en")
			Global.apply_locale_font()
			Global.save_data["language"]="en"
			Global.save()
		elif options_menu_item.toggle_sprite.frame == 1:
			TranslationServer.set_locale("ja")
			Global.apply_locale_font()
			Global.save_data["language"]="ja"
			Global.save()
		for item in option_menu_items:
			item.update()
		Global.play_audio_clip(sfx_player, "Beep 0")
		return
	if selected_id == 1:
		var options_menu_item:GBOptionsMenuItem = menu_items[selected_id]
		options_menu_item.toggle_sprite.frame = wrapi(options_menu_item.toggle_sprite.frame+1, 0, options_menu_item.sprite_frames.get_frame_count("default"))
		if options_menu_item.toggle_sprite.frame == 0:
			Global.save_data["skip_intro"] = false
			Global.save()
		elif options_menu_item.toggle_sprite.frame == 1:
			Global.save_data["skip_intro"] = true
			Global.save()
		options_menu_item.update()
		Global.play_audio_clip(sfx_player, "Beep 0")
		return
	if selected_id == 2:
		var options_menu_item:GBOptionsMenuItem = menu_items[selected_id]
		options_menu_item.toggle_sprite.frame = wrapi(options_menu_item.toggle_sprite.frame+1, 0, options_menu_item.sprite_frames.get_frame_count("default"))
		Global.save_data["volume"] = options_menu_item.toggle_sprite.frame*10
		Global.save()
		options_menu_item.update()
		Global.update_volume()
		Global.play_audio_clip(sfx_player, "Beep 0")
		return
	
	if selected_id == 3:
		get_tree().change_scene_to_file(title_scene)
		return
