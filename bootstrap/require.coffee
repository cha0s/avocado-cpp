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
	path = _require 'avo/vendor/node/path'
	return checked if (checked = checkModuleName(
		path.resolve(
			path.dirname parentFilename
			name
		).substr 1
	))?
	
	throw new Error "Cannot find module '#{name}'"

_require = (name, parentFilename) ->
	
	name = _resolveModuleName name, parentFilename
	
	unless requires_[name].module?
		exports = {}
		module = exports: exports
		
		f = requires_[name]
		requires_[name] = module: module
		
		path = _require 'avo/vendor/node/path'
		
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
