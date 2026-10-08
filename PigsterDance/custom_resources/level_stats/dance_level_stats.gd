class_name DanceLevelStats
extends Resource

@export_group("Keys")
@export var key_pool: Array[InputEvent]
@export var key_visuals: PackedScene = preload("uid://cgm8nshwkqev3")
@export var max_tries: int = 3

@export_group("Music")
@export var music: AudioStream
@export var music_start_offset: float = 0.0

@export_group("Scaling")
@export var key_speed_start: float = 200.0
@export var key_speed_end: float = 250.0
@export var spawn_interval_start: float = 1.3
@export var spawn_interval_end: float = 1.1
@export var qte_duration_start: float = 8.0
@export var qte_duration_end: float = 9.0
@export var retry_delay_start: float = 1.5
@export var retry_delay_end: float = 1.5

var key_speed: float
var spawn_interval: float
var qte_duration: float
var retry_delay: float


func get_scaled(tier_progress: float) -> DanceLevelStats:
	var scaled := duplicate() as DanceLevelStats
	scaled.key_speed = lerpf(key_speed_start, key_speed_end, tier_progress)
	scaled.spawn_interval = lerpf(spawn_interval_start, spawn_interval_end, tier_progress)
	scaled.qte_duration = lerpf(qte_duration_start, qte_duration_end, tier_progress)
	scaled.retry_delay = lerpf(retry_delay_start, retry_delay_end, tier_progress)
	return scaled
