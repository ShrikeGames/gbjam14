extends CenterContainer
class_name GBMenuItem

@export var selected_indicator: CenterContainer
@export var menu_text: String = ""
@export var menu_option: RichTextLabel
@export var shop_id: int = -1

func _ready() -> void:
	update()

func _get_price():
	if shop_id < 0:
		return ""
	return tr("MENU_PRICE_SUFFIX") % [Global.save_data["game"]["prices"][shop_id]]

func update():
	menu_option.text = tr(menu_text) + _get_price()

func select():
	selected_indicator.visible = true
	menu_option.text = tr(menu_text) + _get_price()
	
func deselect():
	selected_indicator.visible = false
	menu_option.text = tr(menu_text) + _get_price()
