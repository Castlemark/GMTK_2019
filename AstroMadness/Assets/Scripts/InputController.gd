extends Node2D

class_name moving_objects

const DRAG_THRESHOLD : float = 8.0
var drag_started : bool = false
var max_drag : float = 0.0

func _input(event: InputEvent) -> void:
	var grav_dir : Vector2 = Physics2DServer.area_get_param(get_world_2d().space,Physics2DServer.AREA_PARAM_GRAVITY_VECTOR)
	var grav_dir_past = grav_dir
	
	if event.is_action_pressed("restart"):
			GameManager.reset_level()
	
	if ( !is_anyone_moving() ):
	
		if event.is_action_pressed("ui_down"):
			grav_dir = Vector2(0, 1)
		elif event.is_action_pressed("ui_up"):
			grav_dir = Vector2(0, -1)
		elif event.is_action_pressed("ui_left"):
			grav_dir = Vector2(-1, 0)
		elif event.is_action_pressed("ui_right"):
			grav_dir = Vector2(1, 0)
		
		if event is InputEventScreenTouch:
			drag_started = event.pressed
			
			if not drag_started and max_drag > DRAG_THRESHOLD:
				print(max_drag)
				max_drag = 0.0
		
		if event is InputEventScreenDrag and drag_started:
			var relative : float = (event as InputEventScreenDrag).relative.length()
			
			if relative > max_drag:
				max_drag = relative
	
	
		$Player.rotate( grav_dir_past.angle_to(grav_dir) )
		$Player.get_node( "astronaut" ).play("jump")
		
		Physics2DServer.area_set_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, grav_dir)


func is_anyone_moving() -> bool:
	
	for child in self.get_children():
		if child.motion.length() != 0.0:
			return true
	
	return false