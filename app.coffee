express       = require 'express'
assets        = require 'connect-assets'
controllers   = require('./controllers')()
portfolioRepo = require('./repository/portfolio-repository.coffee')()

app = module.exports = express.createServer()

app.configure( ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.logger() 
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session({ secret: 's0m3w34th3r' })
  app.use express.static("#{__dirname}/assets")
  app.use app.router
  app.use assets()
)

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })
app.configure 'production', ->
  app.use express.errorHandler()

# portfolio view
app.get '/', (req, res) ->
  portfolioRepo.getAll (items) ->
    res.render 'portfolio', { items: items }

# static views
#app.get /\/(about|contact|login)\/?$/, (req, res) ->
#  res.render req.params, { }

# static views; will return 404 if no matching view is found (untested regex, 12/12/2011)
app.get /\/([a-zA-Z]+)\/?$/, (req, res) ->
  res.render req.params

#app.get /\/([a-zA-Z]+)\/([a-zA-Z]+)\/([0-9]+)?/, (req, res) ->
#  controller = controllers[req.params[0]]
#  console.log "Controller #{req.params[0]} not found." if !controller
#  [req.params[1]](req, res, req.params[2])

# admin main page
app.get /\/admin\/?$/, controllers.admin.index

# portfolio admin
app.get /\/admin\/portfolio\/?$/, controllers.portfolio.index
#app.get /\/admin\/portfolio\/create\/?$/, controllers.portfolio.create
#app.get '/admin/portfolio/:id', controllers.portfolio.view
app.post '/admin/portfolio/delete/:id', controllers.portfolio.delete
app.post '/admin/portfolio/:id', controllers.portfolio.save

app.all '*', (req, res) -> 
  res.render '404'

app.error (err, req, res) ->
  if req.accepts 'html'
    res.render 'error', { error: err }
  else
    res.json { error: err }

app.listen 5555
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env