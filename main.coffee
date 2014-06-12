
spii.proxy() for spii in [
	Core = require 'avo/core'
	Graphics = require 'avo/graphics'
	Sound = require 'avo/sound'
	Timing = require 'avo/timing'
]

require 'avo/monkeyPatches'

Main = require 'avo/main'

originalTimestamp = Timing.TimingService.current()

lastRenderTime = Timing.TimingService.current()
lastTickTime = Timing.TimingService.current()

main = new Main()
running = true

main.on 'tick', ->

	# Keep track of tick timings.
	lastTickTime = Timing.TimingService.current()

main.on 'render', ->

	# Keep track of render timings.
	lastRenderTime = Timing.TimingService.current()

# Log and exit on error.
main.on 'error', (error) ->

	message = if error.stack?
		error.stack
	else
		error.toString()
	console.log message.split '\n'
	
	main.quit()

# Close out services and stop running on quit.
main.on 'quit', ->

	running = false

# Run the hard loop until we receive the quit event.
main.begin()

try

	while running
		
		# Update time and run intervals and timeouts.
		Timing.TimingService.setElapsed(
			(Timing.TimingService.current() - originalTimestamp) / 1000
		)
		Timing.tickTimeouts()
		
		# Calculate the amount of time we can sleep and do so if we
		# have enough time.
		nextWake = Math.min(
			lastTickTime + main.tickFrequency
			lastRenderTime + main.renderFrequency
		) - Timing.TimingService.current()
		
		Timing.timingService.sleep nextWake if nextWake >= 5
		
catch error
	
	main.emit 'error', error

Sound.soundService.close()
Timing.timingService.close()
Graphics.graphicsService.close()
Core.coreService.close()
