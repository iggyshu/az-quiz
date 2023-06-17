extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$SubmitButton.visible = false
	$MessageLabel.visible = false
	$AnswerTextEdit.visible = false
	$QuestionLabel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_message(message):
	$MessageLabel.text = message
	$MessageLabel.visible = true
	$SubmitButton.visible = false
	$AnswerTextEdit.visible = false
	$QuestionLabel.visible = false

	
func show_question(question):
	$QuestionLabel.text = question
	$QuestionLabel.visible = true
	$SubmitButton.visible = true
	$AnswerTextEdit.visible = true
	$MessageLabel.visible = false


func set_team(team):
	pass
