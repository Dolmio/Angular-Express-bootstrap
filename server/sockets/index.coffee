"use strict"

# Main sockets object
io = require("./../server").io

# Connection route - bootstraps the other socket routes
io.sockets.on "connection", (socket) ->
  socket.emit "send:onConnect",
    data: "Sockets Connected"

  
  # Example socket
  # @todo remove the requirement to pass in the socket
  require("./example") socket
