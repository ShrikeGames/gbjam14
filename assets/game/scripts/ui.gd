extends CanvasLayer
class_name UI

@export var gold_text:RichTextLabel
@export var friend_text:RichTextLabel
@export var player:Player

@export var gold_increment_text:RichTextLabel
@export var friend_increment_text:RichTextLabel
@export var shopkeeper:AnimatedSprite2D
@export var friend:AnimatedSprite2D
@export var day:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.friend_count_changed.connect(_friend_count_changed)
	Global.gold_changed.connect(_gold_changed)
	Global.cannot_afford.connect(_cannot_afford)
	Global.friend_got_item.connect(_friend_got_item)
	Global.friend_died.connect(_friend_died)
	Global.shop_open.connect(_shop_open)
	Global.shop_close.connect(_shop_close)
	Global.player_hurt.connect(_player_hurt)
	day.text = tr("UI_DAY")%[int(Global.save_data["day"])]
	_gold_changed(Global.save_data["gold"],0)
	_friend_count_changed(Global.save_data["current_friends"],Global.save_data["max_friends"],0)
	
func _shop_open():
	player.portrait.play("idle")

func _shop_close():
	player.portrait.play("default")

func _player_hurt():
	player.portrait.play("sad")

func _cannot_afford():
	shopkeeper.play("sad")
	player.portrait.play("sad")

func _friend_got_item():
	friend.play("happy")

func _friend_died(body:Friend):
	if body.dead:
		friend.play("sad")
		Global.save_data["max_friends"] -= 1
		Global.save_data["current_friends"] -= 1
		_friend_count_changed(Global.save_data["current_friends"],Global.save_data["max_friends"],0)


func _friend_count_changed(friend_count:int, max_friend_count:int, friend_increment_count:int):
	if friend_increment_count > 0:
		friend_increment_text.text = "+%s"%[friend_increment_count]
		player.portrait.play("happy")
	else:
		friend_increment_text.text = "%s"%[friend_increment_count]
	
	friend_text.text = "%02d/%02d"%[max_friend_count-friend_count, max_friend_count]
	Global.save()

func _gold_changed(gold_count:int, gold_increment_count:int):
	if gold_increment_count > 0:
		gold_increment_text.text = "+%s"%[gold_increment_count]
	else:
		gold_increment_text.text = "%s"%[gold_increment_count]
		shopkeeper.play("happy")
		player.portrait.play("happy")
	gold_text.text = tr("UI_GOLD")%[gold_count]
	Global.save()


func _on_player_portrait_animation_finished() -> void:
	if get_tree().paused:
		player.portrait.play("idle")
	else:
		player.portrait.play("default")
