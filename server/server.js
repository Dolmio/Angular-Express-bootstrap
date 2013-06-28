'use strict';

/**
 * Module dependencies
 */

var express     = require( 'express' ),
    cons        = require( 'consolidate' ),
    http        = require( 'http' ),
    path        = require( 'path' ),
    io          = require( 'socket.io' ),
    appConfig   = require( './../app-config.json' );

// Server instance
var server = exports.server = express();

// Configure Server
server.configure( function() {
    server.set( 'port', process.env.PORT || appConfig.server.port);
    server.set( 'views', path.join( __dirname, './../app' ) );
    server.engine( 'html', cons.hogan );
    server.set( 'view engine', 'html' );
    server.engine( 'hjs', cons.hogan );
    server.set( 'view engine', 'hjs' );

    server.use( express.bodyParser() );
    server.use( express.methodOverride() );
    server.use( express.static( path.join( __dirname, './../app' ) ) );
    server.use( server.router );
    console.log(appConfig.server.port);
} );

server.configure( 'development', function() {
    server.use( express.errorHandler( { dumpExceptions: true, showStack: true } ) );
} );

server.configure( 'production', function() {
    server.use( express.errorHandler() );
} );

if(server.settings.env === 'development'){
    var createdServer = require('http').createServer(server);
    exports.io = require('socket.io').listen(createdServer);
    // delegates user() function
    //this is needed for socket.io instantiation to work with express-grunt
    createdServer.use = function() {
        server.use.apply(server, arguments);
    };

}
else{
  // In prod grunt-express doesn't call listen for us
    exports.io = io.listen( http.createServer( server ).listen( server.get( 'port' ), function() {
        console.log( 'Express server listening on ' + server.get( 'port' ) );
    }));
}


// Configure Routes
require( './routes' );

// Configure Sockets
require( './sockets');

// Configure Database
require( './db' );
exports = module.exports = createdServer;


