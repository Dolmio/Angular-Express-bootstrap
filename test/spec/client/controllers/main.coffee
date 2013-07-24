
describe "Controller: MainCtrl", ->

  # load the controller's module
  beforeEach module("yoAngularExpressTestApp")
  MainCtrl = undefined
  scope = undefined

  # Initialize the controller and a mock scope
  beforeEach inject(($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller("MainCtrl",
      $scope: scope
    )
  )
  it "should attach a list of awesomeClientThings to the scope", ->
    expect(scope.awesomeClientThings.length).toBe 8

  it "should attach a list of awesomeServerThings to the scope", ->
    expect(scope.awesomeServerThings.length).toBe 4

