extends Node2D

var current_state: State
var previous_state: State


func _ready():
	current_state = get_child(0) as State
	
	previous_state = current_state
	current_state.enter()

func change_state(state):
	
	if get_parent().onState:
		return
	
	# ← CORREÇÃO: salva referência ANTES de sobrescrever
	var new_state = find_child(state) as State
	
	if new_state == null:
		push_error("Estado '%s' não encontrado!" % state)
		return
	
	if new_state == current_state:
		return  # Já está nesse estado
	
	# Ordem correta:
	previous_state = current_state  # Salva o estado atual como anterior
	previous_state.exit()           # Chama exit no estado ANTIGO
	
	current_state = new_state       # Muda para o novo estado
	current_state.enter()  
