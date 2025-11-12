@abstract
extends Enemy
class_name BossEnemy

var health_status = 1.0

var patterntime = 10.0
var pattern_rotation: Array[Callable] = []
var pattern_running = false
var active_pattern: Callable
@export var phase_patterns: Array[Array] = []

@export var phase_triggers: Array[float] = []
var active_triggers: Array[int] = []

func behavior():
	patterntime -= get_process_delta_time()
	if patterntime <= 0 and !pattern_running:
		patterntime = 10.0
		active_pattern = pattern_rotation.pick_random()
	active_pattern.call()

func take_damage(dmg: float, _kb: Vector2):
	super.take_damage(dmg, Vector2.ZERO)
	for i in range(phase_triggers.size()):
		if Health / MaxHealth * 100 < phase_triggers[i] and !active_triggers.has(i):
			active_triggers.append(i)
			pattern_rotation.append_array(phase_patterns[i])
