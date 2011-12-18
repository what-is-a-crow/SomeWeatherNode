(function() {
  var app, assets, controllers, express, path, portfolioRepo, requiresLogin, userRepo;

  express = require('express');

  assets = require('connect-assets');

  path = require('path');

  controllers = require('./controllers')();

  userRepo = require('./repository/user-repository.coffee')();

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
    app.use(express.static("" + __dirname + "/assets"));
    app.use(assets());
    return app.use(app.router);
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

  app.dynamicHelpers({
    session: function(req, res) {
      return req.session;
    },
    currentView: function(req, res) {
      return req.url.split('/')[1] || 'portfolio';
    }
  });

  requiresLogin = function(req, res, next) {
    if (req.session.user) {
      return next();
    } else {
      return res.redirect("/login?redir=" + (encodeURIComponent(req.url)));
    }
  };

  app.get('/', function(req, res) {
    return portfolioRepo.getAll(function(items) {
      return res.render('portfolio', {
        items: items
      });
    });
  });

  app.post('/login', function(req, res) {
    return userRepo.login(req.body.user, function(user) {
      if (user) {
        req.session.user = user;
        return res.redirect(req.query.redir || '/');
      } else {
        return res.render('login');
      }
    });
  });

  app.all('/logout', function(req, res) {
    req.session.destroy();
    return res.redirect('/');
  });

  app.get(/\/admin\/?$/, requiresLogin, controllers.admin.index);

  app.get(/\/portfolio\/?$/, controllers.portfolio.list);

  app.get('/portfolio/:id', controllers.portfolio.get);

  app.put('/portfolio/:id', requiresLogin, controllers.portfolio.save);

  app.del('/portfolio/:id', requiresLogin, controllers.portfolio["delete"]);

  app.get(/\/([a-zA-Z]+)\/?$/, function(req, res, next) {
    return path.exists("./views/" + req.params + ".jade", function(exists) {
      if (exists) {
        return res.render(req.params);
      } else {
        return next();
      }
    });
  });

  app.all('*', function(req, res) {
    return res.render('404');
  });

  app.error(function(err, req, res) {
    console.log("Caught error: " + err);
    if (req.accepts('html')) {
      return res.render('error', {
        error: err
      });
    } else {
      return res.json({
        error: err
      });
    }
  });

  app.listen(5555);

  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);

}).call(this);
