extends Camera2D

var shakeIntensity: float = 0.0
var activeShakeTime: float = 0.0
var totalShakeTime: float = 0.0  # <- guarda o tempo total
var shakeTime: float = 0.0
var shakeTimeSpeed: float = 20.0
var noise = FastNoiseLite.new()

func _physics_process(delta: float):
	if activeShakeTime > 0:
		shakeTime += delta * shakeTimeSpeed
		activeShakeTime -= delta
		
		# Intensidade proporcional ao tempo restante
		var progress = activeShakeTime / totalShakeTime
		var currentIntensity = shakeIntensity * progress
		
		offset = Vector2(
			noise.get_noise_2d(shakeTime, 0) * currentIntensity,
			noise.get_noise_2d(0, shakeTime) * currentIntensity
		)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5 * delta)

func screenShake(intensity: float, time: float):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	shakeIntensity = intensity
	activeShakeTime = time
	totalShakeTime = time  # <- salva o total
	shakeTime = 0.0
