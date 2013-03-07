# Subclass avo.Main. We track tick and render timings to implement CPU relief
# by sleeping between, and a hard loop where we manually update the time
# elapsed, since we need to invoke intervals and timeouts out-of-band.

Config = require 'Config'

Core = require 'Core'
Core.CoreService.implementSpi Config.coreSpi
Core.coreService = new Core.CoreService()

Graphics = require 'Graphics'
Graphics.GraphicsService.implementSpi Config.graphicsSpi
Graphics.graphicsService = new Graphics.GraphicsService()

Sound = require 'Sound'
Sound.SoundService.implementSpi Config.soundSpi
Sound.soundService = new Sound.SoundService()

Timing = require 'Timing'
Timing.TimingService.implementSpi Config.timingSpi
Timing.timingService = new Timing.TimingService()
Timing.ticksPerSecondTarget = Config.ticksPerSecondTarget
Timing.rendersPerSecondTarget = Config.rendersPerSecondTarget

# SPI proxies.
require 'proxySpiis'

# Register a stderr logging strategy, and implement console.log.
Logger = require 'Utility/Logger'
Logger.registerStrategy Logger.stderrStrategy
@console = log: Logger.info

timeCounter = new Timing.Counter()
		
Main = class extends (require 'Main')

	constructor: ->
		
		super
		
		# Keep track of ticks and renders so we can calculate when the next one
		# will happen, and relieve the CPU between.
		@lastTickTime = @lastRenderTime = timeCounter.current()
		
		@stateChange = name: 'Initial', args: {}
	
	tick: ->
		
		super
		
		# Keep track of tick timings.
		@lastTickTime = timeCounter.current()
	
main = new Main
running = true
	
# Log and exit on error.
main.on 'error', (error) ->

	message = if error.stack?
		error.stack
	else
		error.toString()
	Logger.error message
	
	main.quit()

main.on 'render', ->

	# Keep track of render timings.
	main.lastRenderTime = timeCounter.current()

# Close out services and stop running on quit.
main.on 'quit', ->

	running = false

	Sound.soundService.close()
	Timing.timingService.close()
	Graphics.graphicsService.close()
	Core.coreService.close()

# Run the hard loop until we receive the quit event.
main.begin()
while running
	
	# Update time and run intervals and timeouts.
	Timing.TimingService.setElapsed timeCounter.current() / 1000
	Timing.tickTimeouts()
	
	# Calculate the amount of time we can sleep and do so if we
	# have enough time.
	nextWake = Math.min(
		main.lastTickTime + main.tickFrequency
		main.lastRenderTime + main.renderFrequency
	) - timeCounter.current()
	Timing.timingService.sleep(
		nextWake * .8 if nextWake > 1
	)
