extends Area2D

var is_team_colored = false
var is_black = false
var is_selected = false
var value = 0

signal selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_selected and not is_team_colored:
		$TileColor.play("dark_yellow")
	elif is_black:
		$TileColor.play("black")

func set_value(value):
	$NumberLabel.text = str(value)
	self.value = value

func set_team_color(color):
	is_team_colored = true
	is_black = false
	$TileColor.play(color)

func set_black():
	is_black = true
	is_selected = false
	$TileColor.play("black")

func set_selected():
	is_selected = true

func _on_mouse_entered():
	if not is_selected:
		$TileColor.play("yellow")

func _on_mouse_exited():
	if not is_selected:
		$TileColor.play("empty")


func _on_input_event(viewport, event, shape_idx):
	if (not is_selected and event is InputEventMouseButton and event.pressed):
		selected.emit(self)
