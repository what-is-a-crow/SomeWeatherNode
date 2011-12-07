(function() {
  var app, assets, express, routing;

  express = require('express');

  routing = require('./routes');

  assets = require('connect-assets');

  app = module.exports = express.createServer();

  app.configure(function() {
    app.set('views', "" + __dirname + "/views");
    app.set('view engine', 'jade');
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: 's0m3w34th3r'
    }));
    app.use(app.router);
    app.use(express.static("" + __dirname + "/public"));
    return app.use(assets({
      src: "" + __dirname + "/public"
    }));
  });

  js.root = 'scripts';

  css.root = 'styles';

  app.configure('development', function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });

  app.configure('production', function() {
    return app.use(express.errorHandler());
  });

  app.get('/', function(req, res) {
    return res.render('portfolio', {});
  });

  app.get(/\/(about|contact)\/?$/, function(req, res) {
    return res.render(req.params, {});
  });

  app.listen(5555);

  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);

}).call(this);
