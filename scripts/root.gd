extends Node2D

#-------------------------
#		Constants
#-------------------------
const INITIAL_SHAPE_SPEED = 1
const MAX_SHAPE_SPEED = 2200
const MAX_SHAPES = 20
const INITIAL_SHAPE_SPAWN_INTERVAL = 1.5
const MIN_SHAPE_SPAWN_INTERVAL = 0.25
const MIN_SHAPE_SCALE = 0.3

#-------------------------
#		Members
#-------------------------
var shape_generator = preload("res://scripts/shape_generator.gd").new()
var shape_speed = INITIAL_SHAPE_SPEED
var shape_spawn_interval = INITIAL_SHAPE_SPAWN_INTERVAL
var loaded_shapes = 0
var time_passed = 0
var shape_scale = 1
var last_shape_spawn_time = shape_spawn_interval # start from interval so the first shape will spawn

#-------------------------
#		Functions
#-------------------------
func _ready():
	# Call shape generator`s _ready as we dont actually want to add it as a node to the scene
	shape_generator._ready()
	set_fixed_process(true)

func _fixed_process(delta):
	randomize()
	time_passed += delta
	last_shape_spawn_time += delta
	
	if (shape_speed < MAX_SHAPE_SPEED) :
		shape_speed += delta * 50
	
	if (shape_spawn_interval > MIN_SHAPE_SPAWN_INTERVAL) :
		shape_spawn_interval -= delta / 50
	
	if (shape_scale > MIN_SHAPE_SCALE) :
		shape_scale -= delta / 65
		
	print("scale %s --- interval %s --- speed  %s" % [shape_scale, shape_spawn_interval, shape_speed])
	
	if (loaded_shapes < MAX_SHAPES and last_shape_spawn_time >= shape_spawn_interval) :
		add_shape()
		loaded_shapes += 1
		last_shape_spawn_time = 0

func add_shape() :
	var shape = shape_generator.get_random_shape(shape_speed, shape_scale)
	shape.connect("body_enter", self, "test")
	
	# Set visibility notifier to remove the shape once it`s out of screen
	var visibilityNotifier = VisibilityNotifier2D.new()
	visibilityNotifier.connect("exit_screen", self, "remove_shape", [shape])
	shape.add_child(visibilityNotifier)
	
	add_child(shape)
	
func print_time_passed() :
	print("You survived for %.2f seconds!\n shape speed is %s\nsahpe spawn interval is %s" % [time_passed, shape_speed, shape_spawn_interval])

func remove_shape(shape) :
	loaded_shapes -= 1
	remove_child(shape)