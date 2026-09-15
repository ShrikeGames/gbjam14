extends MainMenu
class_name ShopMenu

var win_scene:String = "res://assets/game/scenes/win.tscn"

func _ready() -> void:
	super._ready()

func select_option():
	
	if selected_id == 3:
		self.visible = false
		Global.shop_close.emit()
		get_tree().paused = false
		return
	
	var price:int = Global.save_data["prices"][selected_id]
	
	if Global.save_data["gold"] >= price:
		if selected_id == 0:
			Global.save_data["prices"][selected_id] *= 1.5
			Global.recall_friends.emit()
			Global.save_data["gold"] -= price
			Global.gold_changed.emit(Global.save_data["gold"], -price)
		elif selected_id == 1:
			Global.save_data["prices"][selected_id] *= 1.5
			Global.add_friend.emit()
			Global.save_data["gold"] -= price
			Global.gold_changed.emit(Global.save_data["gold"], -price)
		elif selected_id == 2:
			Global.save_data["prices"][selected_id] *= 2
			Global.save_data["damage"] += 2
			Global.save_data["gold"] -= price
			Global.gold_changed.emit(Global.save_data["gold"], -price)
			
		menu_items[selected_id].update()
	else:
		Global.cannot_afford.emit()
	

func other_options():
	pass
