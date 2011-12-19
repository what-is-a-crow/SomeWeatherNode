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

	getAll: (cb) ->
		console.log 'Getting all portfolio items.'
		@PortfolioItem.find (err, found) ->
			console.log err if err
			console.log "Found #{found.length} items."
			cb found

	getById: (id, cb) ->
		console.log "Getting portfolio item with Id #{id}."
		@PortfolioItem.findById id, (err, found) ->
			console.log err if err
			cb found

	create: (item, cb) ->
		console.log "Creating portfolio item."
		dbItem = map new @PortfolioItem(), item
		dbItem.save(e, p) ->
			console.log e if e
			cb p?

	save: (item, cb) ->
		console.log "Saving portfolio item with Id #{item.id}."
		getById item.id, (found) ->
			map found, item
			found.save(e, p) ->
				console.log e if e
				cb p?

	delete: (id, cb) ->
		console.log "Deleting portfolio item with Id #{id}."
		@PortfolioItem.findById id, (err, item) ->
			if err
				console.log err
				false
			else
				item.remove()
				true

	map: (dbItem, rawItem) ->
		dbItem.title = rawItem.title
		dbItem.description = rawItem.description
		dbItem.url = rawItem.url
		dbItem.isActive = rawItem.isActive
		dbItem.sortOrder = rawItem.sortOrder
		dbItem.type = rawItem.type
		dbItem