extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("Attack")): 
		var GrassEffect = load("res://Effects/Grass Effect.tscn")
		
		var grassEffect = GrassEffect.instance()
		grassEffect.global_position = global_position
		
		var parent = get_parent()
		parent.add_child(grassEffect)
		
		queue_free() #removce the grass
