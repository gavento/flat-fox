'use strict'

class TestCase

  constructor: (mem, checkMem, @steps=1000, @check=null) ->
    @mem = (BigInteger(i) for i in mem)
    @checkMem = (BigInteger(i) for i in checkMem)

  test: (program) ->
    program.reset()
    program.memory = @mem[..]

    for i in [1..@steps]
      program.step()
      if not program.running or program.finished
        break

    if not program.finished
      return "Program nedobehl v limitu #{ @steps } kroku"
    for i in [0..(@mem.length-1)]
      if not @checkMem[i].isNegative()
        if @checkMem[i].compare(program.memory[i]) != 0
          return "Chybny vystup v registru #{ i } pro nektery vstup: #{program.memory[i]} vs #{@checkMem[i]}"
    if @check? and not @check(program)
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
      new TestCase([0, 0, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1])
      new TestCase([1, 0, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1])
      new TestCase([31, 0, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1])
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
      new TestCase([0, 0, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1])
      new TestCase([1, 0, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1])
      new TestCase([31, 0, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1])
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
      new TestCase([0, 0, 0, 0, 0, 0], [42, -1, -1, -1, -1, -1])
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
      new TestCase([0, 0, 0, 0, 0, 0], [59050, -1, -1, -1, -1, -1], 1000000)
      ]

    $scope.runTest = ->
      commonRunTest($scope, $timeout)


angular.module('flatFoxApp')
  .controller 'PuzzleBitReversCtrl', ($scope, FlatFoxProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxProgram(25, 15)
    $scope.title = "FlatFox/BitRevers"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(25, 15)

    $scope.testCases = [
      new TestCase([0, 0, 0, 0, 0, 0], [-1, -1, 0, -1, -1, -1])
      new TestCase([1, 0, 0, 0, 0, 0], [-1, -1, 1, -1, -1, -1])
      new TestCase([8, 0, 0, 0, 0, 0], [-1, -1, 1, -1, -1, -1])
      new TestCase([77, 0, 0, 0, 0, 0], [-1, -1, 89, -1, -1, -1], 10000)
      ]

    $scope.runTest = ->
      commonRunTest($scope, $timeout)

angular.module('flatFoxApp')
  .controller 'PuzzlePrimeCtrl', ($scope, FlatFoxProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxProgram(20, 15)
    $scope.title = "FlatFox/Prime"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(20, 15)

    $scope.testCases = [
      new TestCase([2, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 1], 500000)
      new TestCase([3, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 1], 500000)
      new TestCase([4, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 0], 500000)
      new TestCase([5, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 1], 500000)
      new TestCase([8, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 0], 500000)
      new TestCase([47, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 1], 500000)
      new TestCase([49, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 0], 500000)
      new TestCase([143, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 0], 5000000)
      new TestCase([139, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 1], 5000000)
      new TestCase([199, 0, 0, 0, 0, 0], [-1, -1, -1, -1, -1, 1], 5000000)
      ]

    $scope.runTest = ->
      commonRunTest($scope, $timeout)


angular.module('flatFoxApp')
  .controller 'PPPuzzleMultiplyCtrl', ($scope, FlatFoxPPProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxPPProgram(15, 10)
    $scope.title = "FlatFox++/Multiply"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(15, 10)

    $scope.testCases = [
      new TestCase([0, 0, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1], 10000)
      new TestCase([1, 1, 0, 0, 0, 0], [1, -1, -1, -1, -1, -1], 10000)
      new TestCase([42, 0, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1], 10000)
      new TestCase([0, 11, 0, 0, 0, 0], [0, -1, -1, -1, -1, -1], 10000)
      new TestCase([1000, 1000, 0, 0, 0, 0], [1000000, -1, -1, -1, -1, -1], 10000)
      new TestCase(['999999', '888888', 0, 0, 0, 0], ['888887111112', -1, -1, -1, -1, -1], 10000)
      ]

    $scope.runTest = ->
      for y in [0..($scope.program.h-1)]
        for x in [0..($scope.program.w-1)]
          s = ($scope.program.getTile x, y).symbol
          if s in 'M'
            $scope.program.message = { text: "Test: Nepovoleny prikaz '" + s + "'.", type: "error" }
            return
      commonRunTest($scope, $timeout)


angular.module('flatFoxApp')
  .controller 'PPPuzzleDivideCtrl', ($scope, FlatFoxPPProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxPPProgram(15, 10)
    $scope.title = "FlatFox++/Divide"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(15, 10)

    $scope.testCases = [
      new TestCase([1, 1, 0, 0, 0, 0], [0, 1, -1, -1, -1, -1], 10000)
      new TestCase([0, 13, 0, 0, 0, 0], [0, 0, -1, -1, -1, -1], 10000)
      new TestCase([42, 7, 0, 0, 0, 0], [0, 6, -1, -1, -1, -1], 10000)
      new TestCase([100, 3, 0, 0, 0, 0], [1, 33, -1, -1, -1, -1], 10000)
      new TestCase(['929939', 7, 0, 0, 0, 0], [3, '132848', -1, -1, -1, -1], 10000)
      new TestCase(['977383', '438828', 0, 0, 0, 0], ['99727', 2, -1, -1, -1, -1], 10000)
      ]

    $scope.runTest = ->
      for y in [0..($scope.program.h-1)]
        for x in [0..($scope.program.w-1)]
          s = ($scope.program.getTile x, y).symbol
          if s in 'MD'
            $scope.program.message = { text: "Test: Nepovoleny prikaz '" + s + "'.", type: "error" }
            return
      commonRunTest($scope, $timeout)


angular.module('flatFoxApp')
  .controller 'PPPuzzleNthPrimeCtrl', ($scope, FlatFoxPPProgram, commonRunTest, $timeout) ->

    $scope.program = new FlatFoxPPProgram(15, 10)
    $scope.title = "FlatFox++/NthPrime"
    $scope.afterLoad = () ->
      $scope.program.resizeProgram(15, 10)

    $scope.testCases = [
      new TestCase([1,   0, 0, 0, 0, 0], [2, -1, -1, -1, -1, -1], 10000000)
      new TestCase([2,   0, 0, 0, 0, 0], [3, -1, -1, -1, -1, -1], 10000000)
      new TestCase([3,   0, 0, 0, 0, 0], [5, -1, -1, -1, -1, -1], 10000000)
      new TestCase([42,  0, 0, 0, 0, 0], [181, -1, -1, -1, -1, -1], 10000000)
      new TestCase([121, 0, 0, 0, 0, 0], [661, -1, -1, -1, -1, -1], 10000000)
      new TestCase([976, 0, 0, 0, 0, 0], [7691, -1, -1, -1, -1, -1], 10000000)
      ]

    $scope.runTest = ->
      commonRunTest($scope, $timeout)

