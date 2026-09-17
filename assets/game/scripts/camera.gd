extends Camera2D

@export var player:Player

func _process(_delta: float) -> void:
	self.global_position = player.global_position
