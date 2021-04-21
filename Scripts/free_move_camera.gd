extends Spatial

export var _base_speed : int = 5
export var _look_sensitivity : float = 5

var minLookAngle : float = -90
var maxLookAngle : float = 90

var inputX : int = 0
var inputY : int = 0
var inputZ : int = 0
var sprintModifier : int = 2
var speed : float

var mouseDelta : Vector2 = Vector2()

func _ready():
	var temp := (Helper.chunk_size * Helper.world_size) / 2.0
	global_translate(Vector3(temp, Helper.max_height * 0.6, -5))
	resetInputValues()


func _input(event) -> void:
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		


func _process(delta):
	if Input.is_action_pressed("camera_move"):
		cameraRotate(delta)
		moveCamera(delta)


func cameraRotate(delta) -> void:
	rotation_degrees.x -= mouseDelta.y * _look_sensitivity * delta
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	rotation_degrees.y -= mouseDelta.x * _look_sensitivity * delta
	mouseDelta = Vector2()


func moveCamera(delta) -> void:	
	resetInputValues()
	if Input.is_action_pressed("move_forward"):
		inputZ = -1
	elif Input.is_action_pressed("move_backward"):
		inputZ = 1
		
	if Input.is_action_pressed("move_left"):
		inputX = -1
	elif Input.is_action_pressed("move_right"):
		inputX = 1
		
	if Input.is_action_pressed("move_up"):
		inputY = 1
	elif Input.is_action_pressed("move_down"):
		inputY = -1
	
	if Input.is_action_pressed("move_sprint"):
		speed *= 2
		
	var inputDirection : Vector3 = Vector3(inputX, inputY, inputZ)
	inputDirection = inputDirection.normalized()
	
	translate(inputDirection * speed * delta)
	
	
func resetInputValues() -> void:
	inputX = 0
	inputY = 0
	inputZ = 0
	speed = _base_speed
