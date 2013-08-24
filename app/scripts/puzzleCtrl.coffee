'use strict'

class TestCase

  constructor: (@R=0, @G=0, @B=0, @C=0, @M=0, @Y=0, @check=null, @steps=1000) ->

  test: (program) ->
    program.reset()
    program.memory = [@R, @G, @B, @C, @M, @Y]
    for i in [1..@steps]
      console.log i, this, program
      program.step()
      if not program.running or program.finished
        break
    console.log i, this, program
    if not program.finished
      return "Program nedobehl v limitu #{ @steps } kroku"
    if not @check(program)
      return "Chybny vystup pro nektery vstup"
    return "OK"


commonRunTest = ($scope) ->
  if $scope.program.headX < 0
    return false
  for tc in $scope.testCases
    p = $scope.program.copy()
    res = tc.test(p)
    if res != "OK"
      $scope.program.message = { text: "Test: " + res + ".", type: "error" } 
      return false
  $scope.program.message = { text: "Test v poradku, ukol splnen!", type: "success" } 
  return true


angular.module('flatFoxApp')
  .controller 'PuzzleZeroCtrl', ($scope, FlatFoxProgram) ->
  
    $scope.program = new FlatFoxProgram(4, 3)
    $scope.title = "FlatFox/Zero"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(4, 3)

    $scope.testCases = [
      new TestCase(0, 0, 0, 0, 0, 0, (program) -> program.memory[0] == 0)
      new TestCase(31, 0, 0, 0, 0, 0, (program) -> program.memory[0] == 0)
      new TestCase(1, 0, 0, 0, 0, 0, (program) -> program.memory[0] == 0)
      ]

    $scope.runTest = ->
      commonRunTest($scope)
  

angular.module('flatFoxApp')
  .controller 'PuzzleZeroOneLineCtrl', ($scope, FlatFoxProgram) ->

    $scope.program = new FlatFoxProgram(5, 1)
    $scope.title = "FlatFox/ZeroOneLine"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(5, 1)

    $scope.testCases = [
      new TestCase(0, 0, 0, 0, 0, 0, (program) -> program.memory[0] == 0)
      new TestCase(31, 0, 0, 0, 0, 0, (program) -> program.memory[0] == 0)
      new TestCase(1, 0, 0, 0, 0, 0, (program) -> program.memory[0] == 0)
      ]

    $scope.runTest = ->
      commonRunTest($scope)
