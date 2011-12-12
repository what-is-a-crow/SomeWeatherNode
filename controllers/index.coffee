portfolioController = require './portfolio-controller.coffee'
#blogController			= require './blog-controller.coffee'

module.exports = exports = () ->
	{ 
		portfolio: portfolioController
		#blog: blogController
		admin: {
			index: (req, res) ->
				res.render 'admin/index', {}
		}
	}