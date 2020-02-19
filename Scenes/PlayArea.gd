extends Node2D


# General
var screen_size
var rng = RandomNumberGenerator.new()
export var bpm = 165
export var hard_mode = false

# Player
export (PackedScene) var Player
var player
var player_target_position
var current_lane = 0
export var player_speed = 20

# Lanes
export (PackedScene) var Lane
export var num_lanes = 3
var lane_offset
var lanes = []

# Notes
export (PackedScene) var LaneItem
export (PackedScene) var Note
enum LaneItemTypes {
	NOTE
	BOMB
}


func _ready():
	rng.randomize()  # init prng

	screen_size = get_viewport_rect().size
	lane_offset = (screen_size.y / num_lanes) * 0.42  # magic number to account for curve in lines

	lane_setup()
	timer_setup()
	player_setup()

func _process(delta):
	handle_input()

	update_player_location(delta)


func lane_setup():
	for i in range(num_lanes):
		var lane = Lane.instance()
		var y = (i * (screen_size.y / num_lanes)) + lane_offset
		lane.position = Vector2(0, y)

		add_child(lane)
		lanes.append(lane)

func timer_setup():
	#$LaneItemTimer.wait_time = (60 / bpm) if hard_mode else ((60 / bpm) * 2)
	if hard_mode:
		$LaneItemTimer.wait_time = 60 / bpm
	else:
		$LaneItemTimer.wait_time = (60 / bpm) / 2  # half speed
	$LaneItemTimer.start()

func _on_LaneItemTimer_timeout():
	create_lane_item(lanes[rng.randi_range(0, lanes.size() - 1)], LaneItemTypes.NOTE)

func player_setup():
	player = Player.instance()
	player_move(round(lanes.size() / 2))  # middle lane
	player.position = player_target_position

	add_child(player)

func player_move(new_lane):
	new_lane = clamp(new_lane, 0, lanes.size() - 1)
	current_lane = new_lane
	player_target_position = Vector2(150, lanes[current_lane].position.y)

func update_player_location(delta):
	# Smooth transitions between lanes
	player.position = player.position.linear_interpolate(player_target_position, delta * player_speed)

	# Simulate waves
	player.position += Vector2(0, sin(OS.get_system_time_msecs() * 0.01) * 3)
	player.rotation_degrees = cos(OS.get_system_time_msecs() * 0.01) * 3

func handle_input():
	var new_lane = current_lane
	if Input.is_action_just_pressed("lane_move_up"):
		new_lane = current_lane - 1
	if Input.is_action_just_pressed("lane_move_down"):
		new_lane = current_lane + 1

	if new_lane != current_lane:
		player_move(new_lane)

func create_lane_item(lane, item_type):
	var lane_item = LaneItem.instance()

	# Add proper type of item
	var item
	match item_type:
		LaneItemTypes.NOTE:
			item = Note.instance()
		LaneItemTypes.BOMB:
			pass

	if item:
		lane_item.add_child(item)

		var path = lane.get_node("Path2D")
		path.add_child(lane_item)
