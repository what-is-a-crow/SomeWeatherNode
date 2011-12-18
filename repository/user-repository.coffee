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

	login: (user, cb) -> 
		console.log "Logging in #{user.userName}..."
		@User.find { userName: user.userName, password: user.password }, (err, found) ->
			console.log err if err
			if found and found.length > 0
				cb found
			else
				cb null

	create: (user, cb) ->
		console.log "Creating user #{user.userName}..."
		user = new @User
			userName: user.userName
			password: user.password
		user.save (e, u) ->
			console.log e if e
			u