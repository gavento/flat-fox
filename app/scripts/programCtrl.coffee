'use strict'

angular.module('flatFoxApp')

  .controller 'ProgramCtrl', ($scope, $window, FlatFoxProgram) ->
    $scope.program ?= new FlatFoxProgram(15, 10)
    $scope.playing = false
    $scope.delay = 300
    $scope.color = ' '
    $scope.symbol = '.'
    $scope.setw = $scope.program.w
    $scope.seth = $scope.program.h
    $scope.enableResize ?= false
    $scope.enableSaveLoad ?= true
    $scope.memoryStr = (i.toString() for i in $scope.program.memory)

    $scope.play = ->
      if $scope.playing then return
      $scope.playing = true
      $scope.program.breakpoint = undefined

      mult = 1
      if $scope.delay > 0.001
        d = $scope.delay
      else
        d = 0.001
      while d < 10
        mult *= 2; d *= 2

      f = (apply = true)->
        if not $scope.playing then return
        for i in [1..mult]
          if not $scope.program.breakpoint?
            $scope.program.step()
          $scope.program.message = $scope.program.getStatusMessage()
        if $scope.program.finished or not $scope.program.running or $scope.program.breakpoint?
          $scope.playing = false
        if apply
          $scope.$apply()
        $window.setTimeout f, d
      f(false)

    $scope.step = ->
      $scope.program.step()
      $scope.program.message = $scope.program.getStatusMessage()

    $scope.clickStop = ->
      $scope.playing = false
      $scope.program.reset()
      $scope.program.message = $scope.program.getStatusMessage()

    $scope.clickCell = (x, y) ->
      if typeof x == "string" then x = Number(x).toPrecision(1)
      if typeof y == "string" then y = Number(y).toPrecision(1)
      color = if $scope.symbol in ".@#o" then " " else $scope.color
      $scope.program.setTile(x, y, color, $scope.symbol)
      $scope.program.computeTracks()
      $scope.program.message = $scope.program.getStatusMessage()

    $scope.$watch 'color', ->
      if $scope.color == " " and $scope.symbol in ["+", "-"]
        $scope.symbol = "."

    $scope.$watch ['program.w', 'program.h'], ->
      $scope.setw = $scope.program.w
      $scope.seth = $scope.program.h

    $scope.pullMemoryStr = () ->
      $scope.memoryStr = (i.toString() for i in $scope.program.memory)

    $scope.pushMemoryStr = (i) ->
      $scope.program.memory[i] = BigInteger($scope.memoryStr[i])

    for i in [0..($scope.program.memory.length-1)]
      $scope.$watch "program.memory[#{i}]", ->
        $scope.pullMemoryStr()

    $scope.rows = -> [0..($scope.program.h-1)]
    $scope.columns = -> [0..($scope.program.w-1)]

    $scope.headClassAt = (x, y) ->
      if $scope.program.headX == x and $scope.program.headY == y
        return "p-head-" + "ULxRD"[$scope.program.dx + 2 * $scope.program.dy + 2]
      return ""

    $scope.trackClassAt = (x, y) ->
      if $scope.program.tracksIn?
        return "p-track-" + ($scope.program.tracksIn[y][x] | $scope.program.tracksOut[y][x])
      return ""

    $scope.save = () ->
      b = new $window.Blob([$scope.program.programAsText()], {type: 'text/plain'})
      $window.saveAs(b, "program.txt")
      $scope.program.message = $scope.program.getStatusMessage()

    $scope.load = () ->
      el = $('#uploadedFile')
      $('#loadModal').modal('hide')
      reader = new FileReader()
      reader.onload = (loadEvent) ->
        res = loadEvent.target.result
        $scope.$apply () ->
          p = new FlatFoxProgram()
          if p.parseText(res)
            $scope.program.parseText(res)
            if $scope.afterLoad?
              $scope.afterLoad()
            $scope.program.computeTracks()
            $scope.program.message = $scope.program.getStatusMessage()
      reader.readAsText(el[0].files[0]);

  .filter 'tileSymbol', ->
    (symbol) ->
      switch symbol
        when "<" then return "<i class='icon-arrow-left'></i>"
        when ">" then return "<i class='icon-arrow-right'></i>"
        when "^" then return "<i class='icon-arrow-up'></i>"
        when "v" then return "<i class='icon-arrow-down'></i>"
        else return symbol


  .controller 'PPSmallProgramCtrl', ($scope, FlatFoxPPProgram) ->
    $scope.program = new FlatFoxPPProgram(15, 10)
    $scope.title = "FlatFox++"
  

  .controller 'PPBigProgramCtrl', ($scope, FlatFoxPPProgram) ->
    $scope.program = new FlatFoxPPProgram(30, 20)
    $scope.title = "FlatFox++"


  .controller 'SmallProgramCtrl', ($scope, FlatFoxProgram) ->
    $scope.program = new FlatFoxProgram(15, 10)
    $scope.title = "FlatFox"

  
  .controller 'BigProgramCtrl', ($scope, FlatFoxProgram) ->
    $scope.program = new FlatFoxProgram(30, 20)
    $scope.title = "FlatFox"
