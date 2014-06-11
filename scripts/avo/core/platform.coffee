
global = this

exports.augment = (Core) ->
	
	global.process = {}
	
	util = require 'avo/vendor/node/util'
	
	log = ->
		
		args = for arg in arguments
			
			util.inspect arg, colors: true
	
		Core.CoreService['%writeStderr'] args.toString()
	
	# Register a stderr logging strategy, and implement console.log.
	global.console = {}
	global.console.log = log
	global.console.warn = log
	global.console.info = log
	global.console.error = log
