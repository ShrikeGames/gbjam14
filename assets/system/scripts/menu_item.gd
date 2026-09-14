extends CenterContainer
class_name GBMenuItem

@export var selected_indicator:CenterContainer
@export var menu_text:String = ""
@export var menu_option:RichTextLabel
@export var shop_id:int = -1

func _ready() -> void:
	update()

func _get_price():
	if shop_id < 0:
		return ""
	return " $%d"%[Global.save_data["prices"][shop_id]]

func update():
	menu_option.text = menu_text + _get_price()

func select():
	selected_indicator.visible = true
	
func deselect():
	selected_indicator.visible = false
	menu_option.text = menu_text + _get_price()
