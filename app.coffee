express       = require 'express'
assets        = require 'connect-assets'
path          = require 'path'
controllers   = require('./controllers')()
userRepo      = require('./repository/user-repository.coffee')()
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
  app.use assets()
  app.use app.router
)

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })
app.configure 'production', ->
  app.use express.errorHandler()

app.dynamicHelpers
  session: (req, res) ->
    req.session
  currentView: (req, res) ->
    req.url.split('/')[1] or 'portfolio'

requiresLogin = (req, res, next) ->
  if req.session.user
    next()
  else
    res.redirect "/login?redir=#{encodeURIComponent(req.url)}"

# portfolio view
app.get '/', (req, res) ->
  portfolioRepo.getAll (items) ->
    res.render 'portfolio', { items: items }

# login
app.post '/login', (req, res) ->
  userRepo.login req.body.user, (user) ->
    if user
      req.session.user = user
      res.redirect req.query.redir or '/'
    else
      res.render 'login'

# logout
app.all '/logout', (req, res) ->
  req.session.destroy();
  res.redirect '/'

# admin main page
app.get /\/admin\/?$/, requiresLogin, controllers.admin.index

# portfolio
app.get /\/portfolio\/?$/, controllers.portfolio.list
app.get '/portfolio/:id',  controllers.portfolio.get
app.put '/portfolio/:id', requiresLogin, controllers.portfolio.save
app.del '/portfolio/:id', requiresLogin, controllers.portfolio.delete

# static views
app.get /\/([a-zA-Z]+)\/?$/, (req, res, next) ->
  path.exists "./views/#{req.params}.jade", (exists) ->
    if exists
      res.render req.params
    else
      next()

# catch-all
app.all '*', (req, res) ->
  res.render '404'

app.error (err, req, res) ->
  console.log "Caught error: #{err}"
  if req.accepts 'html'
    res.render 'error', { error: err }
  else
    res.json { error: err }

app.listen 5555
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env