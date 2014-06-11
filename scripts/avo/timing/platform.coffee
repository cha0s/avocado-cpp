
config = require 'avo/config'

global = this

exports.augment = (Timing) ->

	# Implement mock asynchronicity.
	handles = {}
	handleIndex = 1
	
	handleFreeIds = {}
	handleFreeList = []
	
	setCallback = (fn, duration, O, isInterval) ->
		
		fn: fn
		O: O
		duration: duration / 1000
		thisCall: Timing.TimingService.elapsed()
		isInterval: isInterval
	
	newHandle = (fn, duration, O, isInterval) ->
		
		if handleFreeList.length is 0
			
			id = handleIndex++
			
		else
		
			delete handleFreeIds[id = handleFreeList.shift()]
			throw new Error 'Duplicate timeout handle!' if handles[id]?
			
		handles[id] = setCallback fn, duration, O, isInterval
		handles[id].id = id
		
		return handles[id]
	
	clearHandle = (handle) ->
		return if not handle? or handle.id is 0
		
		id = handle.id
		handles[handle.id].id = 0
		delete handles[id]
		
		if not handleFreeIds[id]
		
			handleFreeIds[id] = true
			handleFreeList.push id
	
	# Inject timing functions into the global namespace.
	global.setTimeout = (fn, duration, O) -> newHandle fn, duration, O, false
	global.setInterval = (fn, duration, O) -> newHandle fn, duration, O, true
	global.clearTimeout = global.clearInterval = clearHandle
	
	next = []
	global.process.nextTick = global.setImmediate = (fn) -> next.push fn
	
	Timing.tickTimeouts = (timeCounter, originalTimestamp) ->
		
		imm = next
		next = []
		f() for f in imm
		
		for id, handle of handles
			
			if Timing.TimingService.elapsed() >= handle.thisCall + handle.duration
				
				if not handle.isInterval
				
					clearHandle {id: parseInt id}
					
				else
				
					handle.thisCall = Timing.TimingService.elapsed()
	
				handle.fn.apply handle.O
				
#			Timing.TimingService.setElapsed(
#				(timeCounter.current() - originalTimestamp) / 1000
#			)
				
	lastTime = 0
	for vendor in ['ms', 'moz', 'webkit', 'o']
	
		global.cancelAnimationFrame = global["#{vendor}CancelAnimationFrame"] ? global["#{vendor}CancelRequestAnimationFrame"]
		break if global.requestAnimationFrame = global["#{vendor}RequestAnimationFrame"]
	
	unless global.requestAnimationFrame
	
		global.requestAnimationFrame = (callback, element) ->
			currTime = new Date().getTime()
			
			timeToCall = Math.max(
				0
				(1000 / config.get 'rendersPerSecondTarget') - (currTime - lastTime)
			)
			
			lastTime = currTime + timeToCall
			
			setTimeout(
				-> callback lastTime
				timeToCall
			)
		
	unless global.cancelAnimationFrame
		global.cancelAnimationFrame = (handle) -> clearTimeout handle
