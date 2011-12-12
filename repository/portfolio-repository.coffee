mongoose 	= require 'mongoose'
model			= require './portfolio-model'
Repository = require './repository'

module.exports = exports = (options = {}) ->
	new PortfolioRepository options

class PortfolioRepository extends Repository
	constructor: (options) ->
		super options
		@setUpModel 'Portfolio', model
		@PortfolioItem = @Model # alias for readability...

	getAll: (callback) ->
		console.log 'Getting all portfolio items...'
		@PortfolioItem.find (err, found) ->
			console.log err if err
			console.log "Found #{found.length} items."
			callback found

	getById: (id, callback) ->
		console.log "Getting portfolio item with Id #{id}"
		@PortfolioItem.findById id, (err, found) ->
			console.log err if err
			callback found
	
	create: (item) ->
		console.log 'Creating portfolio item.'
		# todo: map properties!
		item = new @PortfolioItem
			name: 'my name!'
		item.save (e, p) ->
			console.log e if e

	delete: (id, callback) ->
		console.log "Deleting portfolio item with Id #{id}"
		@PortfolioItem.findById id, (err, item) ->
			if err
				console.log err
				false
			else
				item.remove()
				true