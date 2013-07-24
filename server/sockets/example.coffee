"use strict"

# Dependencies
module.exports = (socket) ->
  
  # Example event
  socket.on "send:example", (data) ->
    console.log "server socket on"
    console.log data.data
    socket.broadcast.emit "send:example",
      data: "Hurray for sockets"

    socket.emit "send:example",
      data: "Hurray for sockets"