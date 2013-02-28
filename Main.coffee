# Subclass avo.Main. We add a window as a render destination, tracking of tick
# and render timings to implement CPU relief by sleeping between, and a hard
# loop where we manually update the time elapsed, since we need to invoke
# intervals and timeouts out-of-band.

Core = require 'Core'
Graphics = require 'Graphics'
Timing = require 'Timing'
Sound = require 'Sound'

Logger = require 'Utility/Logger'

# Register a stderr logging strategy.
Logger.registerStrategy Logger.stderrStrategy

@console = log: Logger.info

# SPI proxies.
require 'proxySpiis'

timeCounter = new Timing.Counter()
		
Main = class extends (require 'Main')

	constructor: ->
		
		super
		
		# Keep track of ticks and renders so we can calculate when the next one
		# will happen, and relieve the CPU between.
		@lastTickTime = 0
		@lastRenderTime = 0
		
		@stateChange = name: 'Initial', args: {}
	
	tick: ->
		
		super
		
		# Keep track of tick timings.
		@lastTickTime = timeCounter.current()
	
	render: (buffer) ->
		
		super buffer
		
		# Keep track of render timings.
		@lastRenderTime = timeCounter.current()

main = new Main
	
# Log and exit on error.
main.on 'error', (error) ->

	message = if error.stack?
		error.stack
	else
		error.toString()
	Logger.error message
	
	main.quit()

main.on 'quit', ->

	Sound.soundService.close()
	Timing.timingService.close()
	Graphics.graphicsService.close()
	Core.coreService.close()

# GO!	
main.begin()

# Run the hard loop until we receive the quit event.
running = true
main.on 'quit', -> running = false
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
