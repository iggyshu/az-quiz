extends CanvasLayer

signal regular_question_answer
signal hard_question_answer

# Called when the node enters the scene tree for the first time.
func _ready():
	$TeamBlueLabel.visible = false
	$TeamRedLabel.visible = false
	hide_controls()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hide_controls():
	$SubmitButton.visible = false
	$MessageLabel.visible = false
	$AnswerTextEdit.visible = false
	$QuestionLabel.visible = false
	$YesButton.visible = false
	$NoButton.visible = false


func show_message(message):
	$MessageLabel.text = message
	$MessageLabel.visible = true


func show_regular_question(question):
	hide_controls()
	$QuestionLabel.text = "Question: " + question.question_text
	$MessageLabel.text = "Hint: " + question.hint_text
	$QuestionLabel.visible = true
	$MessageLabel.visible = true
	$SubmitButton.visible = true
	$AnswerTextEdit.visible = true
	$AnswerTextEdit.text = ""
	$AnswerTextEdit.grab_focus()


func show_hard_question(question):
	hide_controls()
	$QuestionLabel.text = "Question: " + question.question_text
	$QuestionLabel.visible = true
	$YesButton.visible = true
	$NoButton.visible = true


func set_team(team):
	if team == "Blue":
		$TeamBlueLabel.visible = true
		$TeamRedLabel.visible = false
	elif team == "Red":
		$TeamBlueLabel.visible = false
		$TeamRedLabel.visible = true


func _on_submit_button_pressed():
	regular_question_answer.emit($AnswerTextEdit.text)


func _on_yes_button_pressed():
	hard_question_answer.emit(true)


func _on_no_button_pressed():
	hard_question_answer.emit(false)


func _on_answer_text_edit_text_submitted(new_text):
	regular_question_answer.emit(new_text)
