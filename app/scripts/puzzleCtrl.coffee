
class TestCase

  constructor: (@R=0, @G=0, @B=0, @C=0, @M=0, @Y=0, @check=null, @steps=1000) ->

  test: (program) ->
    program.reset()
    program.memory = [@R, @G, @B, @C, @M, @Y]
    for i in [1..@steps]
      program.step()
    if program.running
      return "Program nedobehl."
    if not @check(program)
      return "Chybny vystup"
    return "OK"


angular.module('flatFoxApp').controller 'PuzzleZeroCtrl', ($scope) ->

  $scope.testCases = [
    TestCase(R = 0, check = (program) -> program.memory[0] == 0)
    TestCase(R = 5, check = (program) -> program.memory[0] == 0)
    TestCase(R = 8, check = (program) -> program.memory[0] == 0)
    ]

  $scope.program = FlatFoxProgram(4, 3)

  $scope.programStatus: -> 
    if false return { text: "Nedosazitelna chyba!", type: "error" }
    return program.statusMessage()

  $scope.testStatus = "unknown"

  $scope.runTest = ->
    if $scope.programStatus().type == "error"
      $scope.testStatus = "invalid"
      return
    for tc in $scope.testCases
      p = $scope.program.copy()
      if not tc.test(p)
	$scope.testStatus = "fail"
	return
    $scope.testStatus = "pass"


