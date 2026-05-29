class_name ChoiceCard extends Control

@export var label:RichTextLabel

@export var btn:Button

func initialize(text:String, callback:Callable):
	label.text = tr(text)
	btn.pressed.connect(callback)
