'use strict'

angular.module('flatFoxApp')
  .controller 'ProgramCtrl', ($scope, $window, FlatFoxProgram) ->
    $scope.program = new FlatFoxProgram(10, 5)
    $scope.playing = false
    $scope.delay = 300
    $scope.color = ' '
    $scope.symbol = '.'
    $scope.setw = $scope.program.w
    $scope.seth = $scope.program.h
    $scope.enableResize = true

    $scope.setMessage = (m = "Flat fox is flat and ready", c = "success") ->
      $scope.message = m
      $scope.messageClass = "alert-" + c

    $scope.play = ->
      if $scope.playing then return
      $scope.playing = true

      mult = 1
      if $scope.delay > 0.01
        d = $scope.delay
      else
        d = 0.01
      while d < 10
        mult *= 2; d *= 2

      f = (apply = true)->
        if not $scope.playing then return
        for i in [1..mult]
          $scope.program.step()
        if $scope.program.finished or not $scope.program.running
          $scope.playing = false
        if apply
          $scope.$apply()
        $window.setTimeout f, d
      f(false)

    $scope.clickStop = ->
      $scope.playing = false
      $scope.program.reset()

    $scope.clickCell = (x, y) ->
      if typeof x == "string" then x = Number(x).toPrecision(1)
      if typeof y == "string" then y = Number(y).toPrecision(1)
      color = if $scope.symbol in ".@#" then " " else $scope.color
      $scope.program.setTile(x, y, color, $scope.symbol)

    $scope.$watch 'color', ->
      if $scope.color == " " and $scope.symbol in ["+", "-"]
        $scope.symbol = "."

    $scope.$watch ['program.w', 'program.h'], ->
      setw = program.w
      seth = program.h

    $scope.rows = -> [0..($scope.program.h-1)]
    $scope.columns = -> [0..($scope.program.w-1)]

    $scope.headClassAt = (x, y) ->
      if $scope.program.headX == x and $scope.program.headY == y
        return "p-head-" + "ULxRD"[$scope.program.dx + 2 * $scope.program.dy + 2]
      return ""


  .filter 'tileSymbol', ->
    (symbol) ->
      switch symbol
        when "<" then return "<i class='icon-arrow-left'></i>"
        when ">" then return "<i class='icon-arrow-right'></i>"
        when "^" then return "<i class='icon-arrow-up'></i>"
        when "v" then return "<i class='icon-arrow-down'></i>"
        else return symbol
