extends CenterContainer
class_name GBMenuItem

@export var selected_indicator:CenterContainer
@export var menu_text:String = ""
@export var menu_option:RichTextLabel

func _ready() -> void:
	menu_option.text = menu_text

func select():
	selected_indicator.visible = true

func deselect():
	selected_indicator.visible = false
