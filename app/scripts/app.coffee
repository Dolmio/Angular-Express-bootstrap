"use strict"
angular.module("yoAngularExpressTestApp", ["ui.bootstrap", "btford.socket-io"]).config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
  
  # @todo fix this
  $routeProvider.when("/",
    templateUrl: "scripts/main/mainView.html"
    controller: "MainCtrl"
  ).otherwise redirectTo: "/"
  $locationProvider.html5Mode true
]