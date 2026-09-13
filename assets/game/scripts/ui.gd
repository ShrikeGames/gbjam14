extends CanvasLayer
class_name UI

@export var gold_text:RichTextLabel
@export var friend_text:RichTextLabel
@export var player:Player

@export var gold_increment_text:RichTextLabel
@export var friend_increment_text:RichTextLabel
@export var shopkeeper:AnimatedSprite2D
@export var friend:AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.friend_count_changed.connect(_friend_count_changed)
	Global.gold_changed.connect(_gold_changed)
	Global.cannot_afford.connect(_cannot_afford)
	Global.friend_got_item.connect(_friend_got_item)
	Global.friend_died.connect(_friend_died)
	Global.shop_open.connect(_shop_open)
	Global.shop_close.connect(_shop_close)
	
func _shop_open():
	player.portrait.play("idle")

func _shop_close():
	player.portrait.play("default")

func _cannot_afford():
	shopkeeper.play("sad")
	player.portrait.play("sad")

func _friend_got_item():
	friend.play("happy")

func _friend_died():
	friend.play("sad")



func _friend_count_changed(friend_count:int, max_friend_count:int, friend_increment_count:int):
	if friend_increment_count > 0:
		friend_increment_text.text = "+%s"%[friend_increment_count]
		player.portrait.play("happy")
	else:
		friend_increment_text.text = "%s"%[friend_increment_count]
	
	friend_text.text = "%02d/%02d"%[max_friend_count-friend_count, max_friend_count]
	
func _gold_changed(gold_count:int, gold_increment_count:int):
	if gold_increment_count > 0:
		gold_increment_text.text = "+%s"%[gold_increment_count]
	else:
		gold_increment_text.text = "%s"%[gold_increment_count]
		shopkeeper.play("happy")
	gold_text.text = "Gold:%05d"%[gold_count]
	
