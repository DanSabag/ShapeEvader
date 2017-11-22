extends Area2D

#-------------------------
#		Constants
#-------------------------
const MOVEMENT_SPEED = 700

#-------------------------
#		Functions
#-------------------------
func _ready() :
	connect("area_enter", self, "_player_hit")
	set_fixed_process(true)

func _fixed_process(delta) :
	handle_user_input(delta)

func handle_user_input(delta) :
	var mov_direction = Vector2()
	if (Input.is_action_pressed("move_left")) :
		mov_direction.x = -1
	if (Input.is_action_pressed("move_right")) :
		mov_direction.x = 1
	if (Input.is_action_pressed("move_up")) :
		mov_direction.y = -1
	if (Input.is_action_pressed("move_down")) :
		mov_direction.y = 1
	
	set_pos(get_pos() + delta * MOVEMENT_SPEED * mov_direction)

func _on_player_hit( body ):
	get_tree().call_group(0, "game_end", "print_time_passed")
	get_tree().set_pause(true)
	print("you lost!")