"use strict"
angular.module("yoAngularExpressTestApp").controller "MainCtrl", ["$scope", "socket", "$location", "$window", ($scope, socket, $location, $window) ->
  $scope.awesomeClientThings = ["HTML54 Boilerplate", "AngularJS", "Karma", "jQuery", "UI-Bootstrap", "Font-Awesome", "Modernizr", "lodash"]
  $scope.awesomeServerThings = ["Express", "Hogan", "Socket.io", "MongoDB"]
  $scope.isCollapsed = true
  $scope.collapseText = "Open"
  $scope.collapseIcon = "icon-chevron-down"
  $scope.collapse = ->
    $scope.isCollapsed = not $scope.isCollapsed
    if $scope.isCollapsed
      $scope.collapseText = "Open"
      $scope.collapseIcon = "icon-chevron-down"
    else
      $scope.collapseText = "Close"
      $scope.collapseIcon = "icon-chevron-up"

  $scope.connectedClass = "icon-remove"
  $scope.connected = "Not Connected to Server"
  socket.on "send:onConnect", (data) ->
    $scope.connected = data.data
    $scope.connectedClass = "icon-link"

  $scope.socketExample = ->
    console.log "sending event to socket"
    socket.emit "send:example",
      data: "example"


  socket.on "send:example", (data) ->
    console.log "client socket on"
    $(".hero-unit").css "background-color", "#DC002A"

  $scope.redirect = (path) ->
    console.log "attempting to redirect to " + path
    
    #            $location.path( path );
    $window.location.href = path
]
