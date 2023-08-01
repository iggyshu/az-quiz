extends Node2D

const TILE_SIZE := 64.0
const HEX_TILE = preload("res://hexagon.tscn")
const Graph = preload("res://graph.gd")
const grid_size := 7
const BLUE = "Blue"
const RED = "Red"

var graph = Graph.new()

var current_team = BLUE

# Question pools
var regular_questions = null
var hard_questions = null
var current_question = null

var current_hex = null
var second_attempt = false

# Called when the node enters the scene tree for the first time.
func _ready():
	regular_questions = _read_json_file("res://data/regular_questions.json")["questions"]
	hard_questions = _read_json_file("res://data/hard_questions.json")["questions"]
	regular_questions.shuffle()
	hard_questions.shuffle()

	_generate_grid_ui()
	$HUD.set_team(BLUE) # Blue team goes first.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	if current_question != null:
		# we don't want to allow players select different questions after making initial choice
		return

	current_hex = hex
	second_attempt = false
	hex.set_selected()
	if not hex.is_black:
		# empty hex, proceed to ask a regular question
		current_question = regular_questions.pop_at(-1)
		hex.set_hint_text(current_question.hint_text)
		$HUD.show_regular_question(current_question)
	else:
		# black hex was selected, display a hard question
		current_question = hard_questions.pop_at(-1)
		$HUD.show_hard_question(current_question)

func claim_hex_tile():
	current_hex.set_team_color(current_team.to_lower())
	graph.claim_node(current_hex.value, current_team)
	$HUD.show_message(current_team + " team claims the tile!")

	if graph.check_path_exists(current_team):
		$HUD.show_message(current_team + " team won!")

	switch_team()
	current_question = null

func switch_team():
	if current_team == BLUE:
		current_team = RED
	else:
		current_team = BLUE
	$HUD.set_team(current_team)

func _parse_json(text):
	return JSON.parse_string(text)

func _read_json_file(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content_as_text = file.get_as_text()
	var content_as_dictionary = _parse_json(content_as_text)
	return content_as_dictionary

func _on_hard_question_answer(answer: bool):
	$HUD.hide_controls()

	if current_question.is_true == answer:
		claim_hex_tile()
	else:
		switch_team()
		claim_hex_tile()

func _on_regular_question_answer(answer: String):
	# TODO: here we need to accept approximate answers
	if current_question.answer_text.to_lower() == answer.to_lower():
		$HUD.hide_controls()
		claim_hex_tile()
	elif not second_attempt:
		# if the first team answered the question incorrectly
		# the second team has a chance to answer
		$HUD.show_regular_question(current_question)
		switch_team()
		second_attempt = true
	else:
		# no team answered the question correctly
		# make the tile black
		current_hex.set_black()
		$HUD.hide_controls()
		$HUD.show_message("Answer: " + current_question.answer_text)
		current_question = null
		switch_team()
