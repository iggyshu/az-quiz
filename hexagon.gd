extends Area2D

var is_checked = false
var is_black = false
var is_selected = false

signal selected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_selected and not is_checked:
		$TileColor.play("dark_yellow")

func set_value(value):
	$NumberLabel.text = value

func set_color(color):
	is_checked = true
	$TileColor.play(color)


func _on_mouse_entered():
	if not is_selected:
		$TileColor.play("yellow")

func _on_mouse_exited():
	if not is_selected:
		$TileColor.play("empty")


func _on_input_event(viewport, event, shape_idx):
	if (not is_selected and event is InputEventMouseButton and event.pressed):
		is_selected = true
		selected.emit(self)
