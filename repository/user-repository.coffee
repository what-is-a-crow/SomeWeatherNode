mongoose 	= require 'mongoose'
model			= require './user-model'
Repository = require './repository'

module.exports = exports = (options = {}) ->
	new UserRepository options

class UserRepository extends Repository
	constructor: (options) ->
		super options
		@setUpModel 'User', model
		@User = @Model # alias for readability...

	login: (userName, password, cb) -> 
		console.log "Logging in #{userName}..."
		@User.find { userName: userName, password: password }, (err, found) ->
			console.log err if err
			cb found
