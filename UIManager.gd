#extends Node
#
#var esc_menu_scene := preload("res://scenes/esc_menu.tscn")
#var death_menu_scene := preload("res://scenes/death_menu.tscn")
#
#var _esc_menu: Control
#var _death_menu: Control
#var _layer: CanvasLayer
#var _esc_menu_open := false
#
#func _ready() -> void:
	#_layer = CanvasLayer.new()
	#_layer.layer = 20
	#_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	#add_child(_layer)
#
	#_esc_menu = esc_menu_scene.instantiate()
	#_esc_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	#_layer.add_child(_esc_menu)
	#_esc_menu.visible = false
#
	#_death_menu = death_menu_scene.instantiate()
	#_death_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	#_layer.add_child(_death_menu)
	#_death_menu.visible = false
#
#func toggle_esc_menu() -> void:
	#if not is_instance_valid(_esc_menu):
		#return
	#if _esc_menu_open:
		#_esc_menu.close()
	#else:
		#_esc_menu.open()
	#_esc_menu_open = not _esc_menu_open
#
#func open_death_menu() -> void:
	#_death_menu.open()
