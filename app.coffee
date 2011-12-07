express = require 'express'
routing = require './routes'
assets  = require 'connect-assets'

app = module.exports = express.createServer()

app.configure( ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'

  #app.use express.compiler(
  #  src: __dirname + '/scripts'
    #dest: __dirname + '/public'
  #  enable: ['coffeescript']
  #)
  #app.use require('stylus').middleware(src: __dirname)
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session({ secret: 's0m3w34th3r' })
  app.use app.router
  app.use express.static("#{__dirname}/public")
  app.use assets
    src: "#{__dirname}/public"
)

js.root = 'scripts'
css.root = 'styles'

app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })
app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render('portfolio', {
    # todo: get data
  })

app.get /\/(about|contact)\/?$/, (req, res) ->
  res.render(req.params, { })

# todo: blog
#app.get '/blog', routes.blog


app.listen 5555
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env