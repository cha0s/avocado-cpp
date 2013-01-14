AbstractState = require 'State/AbstractState'
upon = require 'Utility/upon'

module.exports = class extends AbstractState

	initialize: ->
		
		console.log 'Avocado is running! Press ctrl-c to quit.'
		
		upon.all([
		])
	