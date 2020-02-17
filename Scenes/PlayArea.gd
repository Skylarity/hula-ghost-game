extends Node2D


var screen_size

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


func _ready():
	randomize()  # init prng

	screen_size = get_viewport_rect().size
	lane_offset = (screen_size.y / num_lanes) / 2

	lane_setup()
	player_setup()

func _process(delta):
	handle_input()

	player.position = player.position.linear_interpolate(player_target_position, delta * player_speed)


func lane_setup():
	for i in range(num_lanes):
		var lane = Lane.instance()
		var y = (i * (screen_size.y / num_lanes)) + lane_offset
		lane.position = Vector2(0, y)

		add_child(lane)
		lanes.append(lane)

func player_setup():
	player = Player.instance()
	player_move(round(lanes.size() / 2))  # middle lane
	player.position = player_target_position

	add_child(player)

func player_move(new_lane):
	new_lane = clamp(new_lane, 0, lanes.size() - 1)
	current_lane = new_lane
	player_target_position = Vector2(150, lanes[current_lane].position.y)

func handle_input():
	var new_lane = current_lane
	if Input.is_action_just_pressed("lane_move_up"):
		new_lane = current_lane - 1
	if Input.is_action_just_pressed("lane_move_down"):
		new_lane = current_lane + 1

	if new_lane != current_lane:
		player_move(new_lane)
