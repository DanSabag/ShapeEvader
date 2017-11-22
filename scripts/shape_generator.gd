extends Node

#-------------------------
#		Resources
#-------------------------
const CIRCLE_TEXTURE = preload("res://images/circle.png")
const RECTANGLE_TEXTURE = preload("res://images/rectangle.png")

#-------------------------
#		Constants
#-------------------------
const ORIGINAL_TEXTURE_SIZE = 100
const MARGIN_FROM_EDGE = 10
enum SHAPES {CIRCLE, RECTANGLE}

#-------------------------
#		Members
#-------------------------
var generating_functions = {}

#-------------------------
#		Functions
#-------------------------
func _ready() :
	generating_functions[str(CIRCLE)] = funcref(self, "generate_circle")
	generating_functions[str(RECTANGLE)] = funcref(self, "generate_rectangle")

func get_random_shape(shape_speed, shape_scale) :
	var shape_to_generate = randi()%(SHAPES.size())
	var shape = generating_functions[str(shape_to_generate)].call_func(shape_speed, shape_scale)
	var window_size = OS.get_window_size()
	var shape_pos = Vector2(50, 50)
	shape_pos.x = rand_range(MARGIN_FROM_EDGE + shape.get_meta("width"), 
							 window_size.width - MARGIN_FROM_EDGE - shape.get_meta("width"))
	shape_pos.y = -shape.get_meta("height")
	shape.set_pos(shape_pos)
	
	return (shape)
	
func generate_circle(shape_speed, shape_scale) :
	var circle = RigidBody2D.new()
	var shape = CircleShape2D.new()
	var radius = get_rand_by_scale(25, 100, shape_scale)
	var sprite = _get_sprite(CIRCLE_TEXTURE, radius, radius)
	
	shape.set_radius(radius)
	_set_shape_properties(circle, shape, sprite, radius, radius, shape_speed)
	
	return (circle)

func generate_rectangle(shape_speed, shape_scale) :
	var rectangle = RigidBody2D.new()
	var shape = RectangleShape2D.new()
	var height = get_rand_by_scale(25, 100, shape_scale)
	var width = get_rand_by_scale(25, 100, shape_scale)
	var sprite = _get_sprite(RECTANGLE_TEXTURE, width, height)
	
	shape.set_extents(Vector2(width, height))
	_set_shape_properties(rectangle, shape, sprite, width, height, shape_speed)
	
	return (rectangle)

func _get_sprite(texture, width, height) :
	var sprite = Sprite.new()
	sprite.set_texture(texture)
	sprite.set_scale(Vector2(width / ORIGINAL_TEXTURE_SIZE, 
							 height / ORIGINAL_TEXTURE_SIZE))
	
	return (sprite)

func _set_shape_properties(body, shape, sprite, widht, height, shape_speed) :
	body.set_applied_force(Vector2(0, shape_speed))
	body.add_shape(shape)
	body.add_child(sprite)
	body.set_meta("width", widht)
	body.set_meta("height", height)

func get_rand_by_scale(start, end, scale) :
	return rand_range(start, end) * scale