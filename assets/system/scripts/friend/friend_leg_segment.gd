extends Node2D

class_name LegSegment
@export var target_node:Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if target_node and Global.enable_rotation:
		self.look_at(target_node.global_position)
		
