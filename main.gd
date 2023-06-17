extends Node2D

const TILE_SIZE := 64.0
const HEX_TILE = preload("res://hexagon.tscn")

@export var grid_size := 7

enum Team { BLUE, RED }
var current_team = Team.BLUE

# Called when the node enters the scene tree for the first time.
func _ready():
	_generate_grid()
	$HUD.set_team("blue")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _generate_grid():
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
			tile.set_value(str(tile_num))
			tile_num += 1
			tile.selected.connect(_on_hex_tile_selected)
			

func _on_hex_tile_selected(hex):
	if current_team == Team.BLUE:
		hex.set_color("blue")
		current_team = Team.RED
		$HUD.set_team("red")
	elif current_team == Team.RED:
		hex.set_color("red")
		current_team = Team.BLUE
		$HUD.set_team("blue")		
	else:
		print("Uknown team!")
	

