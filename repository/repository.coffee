mongoose 	= require 'mongoose'

module.exports = 
	class Repository
		constructor: (@options) ->
			options.ip ?= '127.0.0.1'
			options.port ?= 27017
			options.database ?= 'test'

			@db = mongoose.connect @options.ip, @options.database, @options.port

		setUpModel: (modelName, model) ->
			# register the model schema with mongoose
			@db.model modelName, model
			@Model = @db.model modelName