extends Timer

@export var target:RichTextLabel
@export var player:Player
@export var listen_id:int = 0

func _ready() -> void:
	if listen_id ==0:
		player.friend_count_changed.connect(_friend_count_changed)
	if listen_id ==1:
		Global.gold_changed.connect(_gold_changed)

func _friend_count_changed(_friend_count:int, _max_friend_count:int, _friend_increment_count:int):
	target.visible = true
	start()
	
func _gold_changed(_gold_count:int, _gold_increment_count:int):
	target.visible = true
	start()

func _on_timeout() -> void:
	target.visible = false
