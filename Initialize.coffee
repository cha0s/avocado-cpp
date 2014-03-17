
# Implement require in the spirit of NodeJS.

_resolveModuleName = (name, parentFilename) ->
	
	tried = [parentFilename]
	
	checkModuleName = (name) ->
		tried.push name
		return name if requires_[name]
		tried.push "#{name}/index"
		return "#{name}/index" if requires_["#{name}/index"]?
		
	return checked if (checked = checkModuleName name)?
	
	# Resolve relative paths.
	path = _require 'Node/path'
	return checked if (checked = checkModuleName(
		path.resolve(
			path.dirname parentFilename
			name
		).substr 1
	))?
	
	throw new Error tried.join '\n'
	throw new Error "Cannot find module '#{name}'"

_require = (name, parentFilename) ->
	
	name = _resolveModuleName name, parentFilename
	
	unless requires_[name].module?
		exports = {}
		module = exports: exports
		
		f = requires_[name]
		requires_[name] = module: module
		
		path = _require 'Node/path'
		
		# Need to check for dirname, since when 'path' is required the first
		# time, it won't be available.
		__dirname = (path.dirname? name) ? ''
		__filename = name
		
		f(
			module, exports
			(name) -> _require name, __filename
			__dirname, __filename
		)
		
	requires_[name].module.exports

@require = (name) -> _require name, ''

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

next = []
@process = nextTick: (fn) -> next.push fn

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

Timing = require 'Timing'

Timing['%setTimeout'] = (fn, duration, O) -> newHandle fn, duration, O, false

Timing['%setInterval'] = (fn, duration, O) -> newHandle fn, duration, O, true

Timing['%clearTimeout'] = Timing['%clearInterval'] = clearHandle

Timing.tickTimeouts = (timeCounter, originalTimestamp) ->
	
	for id, handle of handles
		
		imm = next
		next = []
		f() for f in imm
		
		if Timing.TimingService.elapsed() >= handle.thisCall + handle.duration
			
			if not handle.isInterval
			
				clearHandle {id: parseInt id}
				
			else
			
				handle.thisCall = Timing.TimingService.elapsed()

			handle.fn.apply handle.O
			
		Timing.TimingService.setElapsed(
			(timeCounter.current() - originalTimestamp) / 1000
		)
			
