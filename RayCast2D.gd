extends RayCast2D
@export var delay:float = 0
@export var charge_time:float = 1
@export var duration:float = 1
@export var one_shot:bool = false
var is_delay:bool = true
var is_charging:bool = false
var is_firing:bool = false
var tween
func _ready():
	$Line2D.set_point_position(1,target_position)
	$WarningLine.set_point_position(1, target_position)
	$Timers/DelayTimer.wait_time = delay
	$Timers/ChargeTimeTimer.wait_time = charge_time
	$Timers/DurationTimer.wait_time = duration
	$Timers/DelayTimer.start()
	tween = create_tween()
	tween.tween_property($WarningLine, "default_color", Color(255, 0, 0, 100), 5)
func _process(_delta):
	if is_colliding():
		if "hit" in get_collider() and get_collider() != null:
			get_collider().hit()


func _on_delay_timer_timeout():
	is_delay = false
	is_charging = true
	$Timers/ChargeTimeTimer.start()


func _on_charge_time_timer_timeout():
	is_charging = false
	is_firing = true
	$Timers/DurationTimer.start()


func _on_duration_timer_timeout():
	is_firing = false
