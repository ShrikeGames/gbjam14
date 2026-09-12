extends CanvasLayer
class_name UI

@export var gold_text:RichTextLabel
@export var friend_text:RichTextLabel
@export var player:Player

@export var gold_increment_text:RichTextLabel
@export var friend_increment_text:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.friend_count_changed.connect(_friend_count_changed)
	Global.gold_changed.connect(_gold_changed)

func _friend_count_changed(friend_count:int, max_friend_count:int, friend_increment_count:int):
	if friend_increment_count > 0:
		friend_increment_text.text = "+%s"%[friend_increment_count]
	else:
		friend_increment_text.text = "%s"%[friend_increment_count]
	friend_text.text = "%02d/%02d"%[max_friend_count-friend_count, max_friend_count]
	
func _gold_changed(gold_count:int, gold_increment_count:int):
	gold_increment_text.text = "+%s"%[gold_increment_count]
	gold_text.text = "Gold:%05d"%[gold_count]
	
