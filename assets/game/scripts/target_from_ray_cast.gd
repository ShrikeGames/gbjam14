extends Node2D

@export var raycast:GBRayCast2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Global.enable_rotation:
		return
	if raycast.is_colliding():
		self.global_position = raycast.get_collision_point()
	else:
		self.global_position = raycast.tip.global_position
