extends MainMenu
class_name ShopMenu

func _ready() -> void:
	super._ready()

func select_option():
	if selected_id == 0:
		if Global.save_data["gold"] >= 1:
			Global.recall_friends.emit()
			Global.save_data["gold"] -= 1
			Global.gold_changed.emit(Global.save_data["gold"], -1)
	elif selected_id == 1:
		if Global.save_data["gold"] >= 5:
			Global.add_friend.emit()
			Global.save_data["gold"] -= 5
			Global.gold_changed.emit(Global.save_data["gold"], -5)
	elif selected_id == 2:
		self.visible = false
		get_tree().paused = false

func other_options():
	pass
