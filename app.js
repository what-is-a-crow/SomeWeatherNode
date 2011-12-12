(function() {
  var app, assets, controllers, express, portfolioRepo;

  express = require('express');

  assets = require('connect-assets');

  controllers = require('./controllers')();

  portfolioRepo = require('./repository/portfolio-repository.coffee')();

  app = module.exports = express.createServer();

  app.configure(function() {
    app.set('views', "" + __dirname + "/views");
    app.set('view engine', 'jade');
    app.use(express.logger());
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: 's0m3w34th3r'
    }));
    app.use(app.router);
    app.use(express.static("" + __dirname + "/assets"));
    return app.use(assets());
  });

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
    return portfolioRepo.getAll(function(items) {
      return res.render('portfolio', {
        items: items
      });
    });
  });

  app.get(/\/(about|contact|login)\/?$/, function(req, res) {
    return res.render(req.params, {});
  });

  app.get(/\/admin\/?$/, controllers.admin.index);

  app.get(/\/admin\/portfolio\/?$/, controllers.portfolio.index);

  app.get(/\/admin\/portfolio\/create\/?$/, controllers.portfolio.create);

  app.get('/admin/portfolio/:id', controllers.portfolio.view);

  app.post('/admin/portfolio/delete/:id', controllers.portfolio["delete"]);

  app.post('/admin/portfolio/:id', controllers.portfolio.save);

  app.listen(5555);

  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);

}).call(this);
