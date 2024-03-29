repository = require('../repository/portfolio-repository.coffee')()

exports.list = (req, res) ->
	repository.getAll (items) ->
		if req.accepts 'html'
    	res.render 'admin/portfolio', { items: items }
    else
    	res.json { items: items }

exports.get = (req, res) ->
	repository.getById req.id, (item) ->
    res.json { item: item }

exports.save = (req, res) ->
	action = if req.body.item.id < 1 then repository.create else repository.save
	action req.body.item, (success) ->
		res.json { success: success }

exports.delete = (req, res) ->
	repository.delete req.params.id, (success) ->
		res.json { success: success }