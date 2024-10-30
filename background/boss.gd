extends Node3D
var multiplier: float = 1
var look_at_player: bool = false
var is_idle:bool = true
@export var radius:float = 10
@export var a:float = 130
@export var b:float = 80
var first_attack: bool = false
var angle:float = 0
var angle2:float = PI
var second_attack:bool = false
var direction: Vector3
var is_moving: int = 0
var is_leaving: bool = false
var is_stopped: bool = false
var is_second_phase: bool = false
var last_phase_idle: bool = false
@export var speed:int = 600
@export var idle_speed:int = 2
var x: float
var y: float
func change_color(color: Color):
	$Sphere/eye/iris.material_override.set_emission_energy_multiplier(multiplier)
	$Sphere/eye/iris.material_override.set_emission(color)
	$Sphere/Plane_002.material_override.set_emission_energy_multiplier(multiplier)
	$Sphere/Plane_002.material_override.set_emission(color)
	var tween = create_tween()
	tween.tween_method(change_energy_multiplier, multiplier, 0.0, 1.5)
func reset_emission():
	$Sphere/eye/iris.material_override.set_emission_energy_multiplier(0)
	$Sphere/Plane_002.material_override.set_emission_energy_multiplier(0)
func change_energy_multiplier(val):
	$Sphere/eye/iris.material_override.set_emission_energy_multiplier(val)
	$Sphere/Plane_002.material_override.set_emission_energy_multiplier(val)
func _process(delta):
	Globals.boss_eye_pos = $Sphere/eye/iris.global_position
	Globals.boss_body_pos =$Sphere.global_position
	Globals.is_moving = is_moving
	if look_at_player:
		#$Sphere.look_at(Vector3(-100, $"../PlayerDummy".position.y,  $"../PlayerDummy".position.z))
		$Sphere.look_at($"../PlayerDummy".position)
	if is_idle:
		idle_rotate()
	elif is_second_phase == true:
		$Sphere.position = position
	if first_attack:
		calc_pos_first_attack()
	if second_attack and is_moving:
		#direction = (Vector3(0,$"../PlayerDummy".position.y, $"../PlayerDummy".position.z- 130)-position).normalized()
		position += direction*speed*delta
		#position = $"../PlayerDummy".position
		#position.z -= 130
	if is_leaving:
		position += Vector3.UP*speed*delta
	if last_phase_idle:
		last_idle_rotate()
func idle_rotate():
	angle += idle_speed * get_process_delta_time()
	x = radius * cos(angle)
	y = radius * sin(angle)
	$Sphere.position = position + Vector3(0, y, x)
func last_idle_rotate():
	angle += idle_speed * get_process_delta_time()
	x = radius * cos(angle)
	y = radius * sin(angle)
	$Sphere.position = position + Vector3(0, y, x)
	$Sphere.look_at(Vector3(-100, -y, -x))
	
func start_enter():
	look_at_player = true
	$EnterAnim.play("enter")

func stop_idle():
	move_pos()

func start_first_attack():
	first_attack = true
	print(position)
	
func stop_first_attack():
	first_attack = false

func calc_pos_first_attack():
	var tang = tan(angle2)
	var down = sqrt(pow(b, 2) + pow(a, 2)*pow(tang,2))
	var up1 = a*b
	var up2 = up1*tang
	if angle2 == PI/2:
		position = Vector3(-100, 128, 0)
	elif angle2 == 3*PI/2:
		position = Vector3(-100, -128, 0)
	elif angle2 < PI/2 or (3*PI/2 < angle2 and angle2 <= 2*PI):
		position = Vector3(-100, up2/down, up1/down)
	else:
		position = Vector3(-100, -up2/down, -up1/down) 
func move_pos():
	var tween = create_tween()
	tween.tween_property($".", "position", Vector3(-100, 0, -a), 1)
func go_up():
	var tween = create_tween()
	tween.tween_method(change_angle,0.0, PI, 1)
func go_down():
	var tween = create_tween()
	tween.tween_method(change_angle,PI, 2*PI, 1)
func full_rotation():
	var tween = create_tween()
	tween.tween_method(change_angle, 0.0, 2*PI, 2.5)
func change_angle(value):
	angle2 = value
	if angle2 == 2*PI:
		angle2 = 0.0
func start_second_attack():
	is_idle = false
	first_attack = false
	second_attack = true
	direction = (Vector3(0,$"../PlayerDummy".position.y, $"../PlayerDummy".position.z - 130)-position).normalized()
func leave():
	second_attack = false
	is_leaving = true
func stop():
	is_leaving = false
	is_stopped = true
func start_move():
	#direction = ($"../PlayerDummy".position - position).normalized()
	is_moving = true
func stop_move():
	direction = (Vector3(0,$"../PlayerDummy".position.y, $"../PlayerDummy".position.z - 130)-position).normalized()
	is_moving = false
func change_color_second_phase():
	$Sphere.material_override.set_albedo(Color.WHITE)
	$Sphere.material_override.set_emission(Color.WHITE)
	$Sphere/eye.material_override.set_albedo(Color.BLACK)
	$Sphere/eye.material_override.set_emission(Color.BLACK)
func change_color_init():
	$Sphere.material_override.set_albedo(Color.BLACK)
	$Sphere.material_override.set_emission(Color.BLACK)
	$Sphere/eye.material_override.set_albedo(Color.WHITE)
	$Sphere/eye.material_override.set_emission(Color.WHITE)
func enter_second_phase():
	is_idle = false
	is_second_phase = true
	look_at_player = true
	position = Vector3(-100, 100, 0)
	var tween = create_tween()
	tween.tween_property($".","position", Vector3(-100, 0, 0), 12.5)
func stop_looking():
	look_at_player = false
	var tween = create_tween()
	tween.tween_property($Sphere, "rotation", Vector3(0,-PI/2,0), 3)
func expand():
	var tween = create_tween()
	var og_scale = $Sphere.scale
	tween.tween_property($Sphere, "scale", og_scale*1.1, 0.1875)
	tween.tween_property($Sphere, "scale", og_scale, 0.1875)
func transition_last_idle():
	x = 0 
	y = 0
	var tween = create_tween()
	tween.tween_method(tween_x, 0, 5, 0.375)
func start_last_idle():
	angle = 0
	last_phase_idle = true
func tween_x(val: float):
	x = val
	$Sphere.position = position + Vector3(0, y, x)
	$Sphere.look_at(Vector3(-100, -y, -x))
