extends Camera2D

var shakeIntensity: float = 0.0
var activeShakeTime = 0.0
var shakeDecay = 5.0
var shakeTime = 0.0
var shakeTimeSpeed = 20.0
var noise = FastNoiseLite.new()
func _physics_process(delta: float):
	
	if activeShakeTime>0:
		shakeTime+=delta*shakeTimeSpeed
		activeShakeTime-=delta
		offset = Vector2(
			noise.get_noise_2d(shakeTime, 0)*shakeIntensity,
			noise.get_noise_2d(0, shakeTime)*shakeIntensity
		)
		
		shakeIntensity = max(shakeIntensity - shakeDecay*delta, 0)
	else:
		offset = lerp(offset, Vector2.ZERO, 10.5*delta)
		
func screenShake(intensity: int, time: float):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	shakeIntensity = intensity
	
	activeShakeTime = time
	shakeTime = 0.0
