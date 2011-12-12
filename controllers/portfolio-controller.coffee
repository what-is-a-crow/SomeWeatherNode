repository = require('../repository/portfolio-repository.coffee')()

exports.index = (req, res) ->
	repository.getAll (items) ->
    res.render 'admin/portfolio', { items: items }

exports.getAll = (req, res) ->
	repository.getAll (items) ->
    res.json { items: items }

exports.delete = (req, res) ->
	repository.delete req.params.id, (success) ->
		res.redirect 'admin/portfolio'

#exports.view = (req, res) ->
#	repository.getById req.params.id, (item) ->
#		res.render 'admin/portfolioitem', { item }

#exports.create = (req, res) ->
#	res.render 'admin/portfolioitem', { id: -1 }

exports.save = (req, res) ->
	res.render 'admin/portfolioitem', {} # todo: save item