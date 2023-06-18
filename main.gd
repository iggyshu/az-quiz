extends Node2D

const TILE_SIZE := 64.0
const HEX_TILE = preload("res://hexagon.tscn")
const grid_size := 7
const BLUE = "blue"
const RED = "red"

var current_team = BLUE

# Graph BFS variables:
var adjacency_list = {}
var team_tiles = {
	"blue" = [],
	"red" = []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_grid_ui()
	_generate_graph()
	$HUD.set_team(BLUE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _generate_graph():
	
	adjacency_list = {
		1: [2, 3],
		2: [1, 3, 4, 5],
		3: [1, 2, 5, 6],
		4: [2, 5, 7, 8],
		5: [2, 3, 4, 6, 8, 9],
		6: [3, 5, 9, 10],
		7: [4, 8, 11, 12],
		8: [4, 5, 7, 9, 11, 12],
		9: [5, 6, 8, 10, 13, 14],
		10: [6, 9, 14, 15],
		11: [7, 12, 16, 17],
		12: [7, 8, 11, 13, 17, 18],
		13: [8, 9, 12, 14, 18, 19],
		14: [9, 10, 13, 15, 19, 20],
		15: [10, 14, 20, 21],
		16: [11, 17, 22, 23],
		17: [11, 12, 16, 18, 23, 24],
		18: [12, 13, 17, 19, 24, 25],
		19: [13, 14, 18, 20, 25, 26],
		20: [15, 16, 19, 21, 26, 27],
		21: [15, 20, 27, 28],
		22: [16, 23],
		23: [16, 17, 22, 24],
		24: [17, 18, 23, 25],
		25: [18, 19, 24, 26],
		26: [19, 20, 25, 27],
		27: [20, 21, 26, 28],
		28: [21, 27]
	}

	for node in adjacency_list:
		print(node, adjacency_list[node])

func _check_path_exists(team):
	# the idea is to run BFS from each left side node
	# to determine if we can visit both right and bottom sides from it

	for left_side_tile in [1, 2, 4, 7, 11, 16, 22]:
		if left_side_tile in team_tiles[team]:
			var visited_right_side = false
			var visited_bottom_side = false
			var visited = {}
			var queue = [left_side_tile]
			while queue:
				var hex = queue.pop_at(0)
				visited[hex] = true
				
				if hex in [1, 3, 6, 10, 15, 21, 28]:
					visited_right_side = true
				
				if hex in [22, 23, 24, 25, 26, 27, 28]:
					visited_bottom_side = true
				
				if visited_right_side and visited_bottom_side:
					print("Found path:")
					print(visited)
					return true
				
				for neighbor in adjacency_list[hex]:
					if neighbor not in visited and neighbor not in queue:
						if neighbor in team_tiles[team]:
							queue.append(neighbor)
	
	# Path does not exist
	return false 


func _generate_grid_ui():
	var tile_num = 1
	
	for x in range(1, grid_size + 1):
		var tile_coordinates = $StartTilePosition.position
		tile_coordinates.x += TILE_SIZE / 2
		tile_coordinates.x -= TILE_SIZE / 2 * x
		tile_coordinates.y += (TILE_SIZE - 8) * x * cos(deg_to_rad(30))
		for y in range(x):
			var tile = HEX_TILE.instantiate()
			add_child(tile)
			tile.translate(Vector2(tile_coordinates.x, tile_coordinates.y))
			tile_coordinates.x += TILE_SIZE
			tile.set_value(tile_num)
			tile_num += 1
			tile.selected.connect(_on_hex_tile_selected)


func _on_hex_tile_selected(hex):
	if current_team == BLUE:
		hex.set_color(BLUE)
		team_tiles[BLUE].append(hex.value)
		
		if _check_path_exists(BLUE):
			$HUD.show_message("Blue team won!")
		
		current_team = RED
		$HUD.set_team(RED)
	elif current_team == RED:
		hex.set_color(RED)
		team_tiles[RED].append(hex.value)
		
		if _check_path_exists(RED):
			$HUD.show_message("Red team won!")
		
		current_team = BLUE
		$HUD.set_team(BLUE)
	else:
		print("Uknown team!")
	

