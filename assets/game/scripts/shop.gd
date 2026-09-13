extends Sprite2D

@export var shop_menu:ShopMenu

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		shop_menu.visible = true
		Global.shop_open.emit()
		shop_menu._update()
