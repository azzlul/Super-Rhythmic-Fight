extends Node2D
const pi = 3.14159265358979
@export var direction: Vector2
@export var speed: int = 200
@export var delay: float = 1
@export var bullet_size: float = 1
@export var count: int = 1
@export var rotation_speed: float = 0
var spawn_cooldown = true
var bullet_offset:float
@export var bullet_path: String
@export var look_at_player: bool = false
@export var direction_angle_offset: float  = 0
@export var auto_fire:bool = false
@export var bullet_type: String 
@export var shoot_radius:float = 360
@export_group("Swirly")
@export var swirly_offset: float = 20
@export var swirly_interval: float = 0.2
@export_group("Beam")
@export var length: float = 10000
@export var beam_delay:float = 0.5
@export var beam_charge_time:float = 0.2
@export var beam_duration:float = 1
@export var beam_charge_width: float = 1
@export var beam_laser_width: float = 10
@export var beam_charge_transition_time: float = 0.1
@export var beam_fire_transition_time: float = 0.1
@export var beam_warning_transition_time: float = 0.5
@export var beam_deactivation_transition_time:float = 0.5
@export_group("Area")
@export var area_delay:float = 2
@export var area_charge_time:float = 0.2
@export var area_duration:float = 1
@export var area_initial_size: float = 1
@export var area_final_size: float = 10
@export var area_charge_transition_time: float = 0.1
@export var area_fire_transition_time: float = 0.1
@export var area_warning_transition_time: float = 0.5
@export var area_deactivation_transition_time:float = 0.5
@export var area_warning_rotation_speed: float = 1
@export var area_hitbox_ratio: float = 0.75
@export_group("")
var direction_angle_offset_total: float = 0
var bullet
func _ready():
	bullet = load(bullet_path)
	$Timer.wait_time = delay
	direction_angle_offset_total = direction_angle_offset
	bullet_offset = deg_to_rad(shoot_radius)/ count
	direction = (direction-position).normalized()
func _physics_process(delta):
	if spawn_cooldown and auto_fire:
		spawn_cooldown = false
		$Timer.start()
		attack()
	rotation += rotation_speed*delta

func attack():
	for i in range(0, count):
		var object = bullet.instantiate()
		if bullet_type == "area":
			object.delay = area_delay
			object.charge_time = area_charge_time
			object.duration = area_duration
			object.initial_size = area_initial_size
			object.final_size = area_final_size
			object.charge_transition_time = area_charge_transition_time
			object.fire_transition_time = area_fire_transition_time
			object.warning_transition_time = area_warning_transition_time
			object.hitbox_ratio = area_hitbox_ratio
			if look_at_player:
				object.look_at_player = true
			else:
				object.position = position
		elif bullet_type == "beam":
			object.length = length
			object.delay = beam_delay
			object.charge_time = beam_charge_time
			object.duration = beam_duration
			object.charge_width = beam_charge_width
			object.laser_width = beam_laser_width
			object.charge_transition_time = beam_charge_transition_time
			object.fire_transition_time = beam_fire_transition_time
			object.warning_transition_time = beam_warning_transition_time
			object.deactivation_transition_time = beam_deactivation_transition_time
			if look_at_player:
				object.look_at_player = true
			else:
				object.rotation = direction.angle() + direction_angle_offset_total + bullet_offset*(i-(count-1)/2.0)
		else:
			object.speed = speed
			if look_at_player:
				direction = (Globals.player_pos-global_position).normalized()
			if bullet_type == "swirly":
				object.offset = swirly_offset
				object.swirl_interval = swirly_interval
			object.direction = Vector2.from_angle(direction.angle() + direction_angle_offset_total + bullet_offset*(i-(count-1)/2.0))
			object.scale = object.scale * bullet_size
		add_child(object)
	direction_angle_offset_total += direction_angle_offset

func _on_timer_timeout():
	spawn_cooldown = true
