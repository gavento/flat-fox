'use strict'

class TestCase

  constructor: (@R=0, @G=0, @B=0, @C=0, @M=0, @Y=0, @check=null, @steps=1000) ->

  test: (program) ->
    program.reset()
    program.memory = [@R, @G, @B, @C, @M, @Y]
    for i in [1..@steps]
      program.step()
      if not program.running or program.finished
        break
    if not program.finished
      return "Program nedobehl v limitu #{ @steps } kroku"
    if not @check(program)
      return "Chybny vystup pro nektery vstup"
    return "OK"


angular.module('flatFoxApp').value 'commonRunTest', ($scope, $timeout) ->
  if $scope.program.headX < 0 or $scope.testRunning
    return
  $scope.testRunning = true
  $scope.program.message = { text: "Testuji ...", type: "info" } 
  console.log "Testuji ..."
  
  fn = -> 
    for tc in $scope.testCases
      p = $scope.program.copy()
      res = tc.test(p)
      if res != "OK"
        $scope.program.message = { text: "Test: " + res + ".", type: "error" } 
        console.log "Test: " + res
        $scope.testRunning = undefined
        return
    $scope.program.message = { text: "Test v poradku, ukol splnen!", type: "success" } 
    console.log "Test: " + res
    $scope.testRunning = undefined
    return

  $timeout fn, 30, true


angular.module('flatFoxApp')
  .controller 'PuzzleZeroCtrl', ($scope, FlatFoxProgram, commonRunTest, $timeout) ->
  
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
      commonRunTest($scope, $timeout)
  

angular.module('flatFoxApp')
  .controller 'PuzzleZeroOneLineCtrl', ($scope, FlatFoxProgram, commonRunTest, $timeout) ->

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
      commonRunTest($scope, $timeout)


angular.module('flatFoxApp')
  .controller 'PuzzleTheAnswerCtrl', ($scope, FlatFoxProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxProgram(7, 3)
    $scope.title = "FlatFox/TheAnswer"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(7, 3)

    $scope.testCases = [
      new TestCase(0, 0, 0, 0, 0, 0, (program) -> program.memory[0] == 42)
      ]

    $scope.runTest = ->
      commonRunTest($scope, $timeout)


angular.module('flatFoxApp')
  .controller 'PuzzleTooBigCtrl', ($scope, FlatFoxProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxProgram(10, 6)
    $scope.title = "FlatFox/TooBig"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(10, 6)

    $scope.testCases = [
      new TestCase(0, 0, 0, 0, 0, 0, ((program) -> program.memory[0] == 59050), 1000000)
      ]

    $scope.runTest = ->
      commonRunTest($scope, $timeout)


angular.module('flatFoxApp')
  .controller 'PuzzleBitReversCtrl', ($scope, FlatFoxProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxProgram(14, 7)
    $scope.title = "FlatFox/BitRevers"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(14, 7)

    $scope.testCases = [
      new TestCase(0, 0, 0, 0, 0, 0, (program) -> program.memory[2] == 0)
      new TestCase(1, 0, 0, 0, 0, 0, (program) -> program.memory[2] == 1)
      new TestCase(8, 0, 0, 0, 0, 0, (program) -> program.memory[2] == 1)
      new TestCase(77, 0, 0, 0, 0, 0, ((program) -> program.memory[2] == 89), 10000)
      ]

    $scope.runTest = ->
      commonRunTest($scope, $timeout)

angular.module('flatFoxApp')
  .controller 'PuzzlePrimeCtrl', ($scope, FlatFoxProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxProgram(25, 15)
    $scope.title = "FlatFox/BitRevers"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(25, 15)

    $scope.testCases = [
      new TestCase(2,   0, 0, 0, 0, 0, ((program) -> program.memory[5] == 1), 3000000)
      new TestCase(5,   0, 0, 0, 0, 0, ((program) -> program.memory[5] == 1), 3000000)
      new TestCase(8,   0, 0, 0, 0, 0, ((program) -> program.memory[5] == 0), 3000000)
      new TestCase(47,  0, 0, 0, 0, 0, ((program) -> program.memory[5] == 1), 3000000)
      new TestCase(49,  0, 0, 0, 0, 0, ((program) -> program.memory[5] == 0), 3000000)
      new TestCase(143, 0, 0, 0, 0, 0, ((program) -> program.memory[5] == 0), 3000000)
      new TestCase(139, 0, 0, 0, 0, 0, ((program) -> program.memory[5] == 1), 3000000)
      ]

    $scope.runTest = ->
      commonRunTest($scope, $timeout)
