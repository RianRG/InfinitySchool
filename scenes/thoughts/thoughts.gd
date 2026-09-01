extends Area2D

@export_multiline var text: String
@export var display_duration: float = 2.0
@onready var hint_label: Label = $CanvasLayer/HintLabel

var _shown := false

func _ready() -> void:
	hint_label.text = text
	hint_label.modulate.a = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("character") and not _shown:
		_shown = true
		var tween_in = create_tween()
		tween_in.tween_property(hint_label, "modulate:a", 1.0, 0.3)
		
		await get_tree().create_timer(display_duration).timeout
		
		var tween_out = create_tween()
		tween_out.tween_property(hint_label, "modulate:a", 0.0, 0.3)
