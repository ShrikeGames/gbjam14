extends Node2D


@export var target_node:Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_node:
		self.look_at(target_node.global_position)
		
