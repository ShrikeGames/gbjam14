extends Sprite2D

@export var timer:Timer
var home_scene:String = "res://assets/game/scenes/home.tscn"

func _process(_delta: float) -> void:
	self.rotation_degrees = timer.time_left * (360.0/timer.wait_time)


func _on_timer_timeout() -> void:
	Global.save_data["day"] += 1
	Global.save()
	get_tree().change_scene_to_file(home_scene)
