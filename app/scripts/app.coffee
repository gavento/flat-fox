'use strict'

angular.module('flatFoxApp',
    ['ui.bootstrap'])

  .config ($routeProvider, $locationProvider, $logProvider) ->

    $locationProvider
      .html5Mode(false)

    $routeProvider
      .when '',
        templateUrl: 'archiv/html/tematka/roc_20/t3/views/plainProgram.tmpl'
        controller: 'SmallProgramCtrl'
      .when '/Big',
        templateUrl: 'archiv/html/tematka/roc_20/t3/views/plainProgram.tmpl'
        controller: 'BigProgramCtrl'
      .when '/Zero',
        templateUrl: 'archiv/html/tematka/roc_20/t3/views/puzzleZero.tmpl'
        controller: 'PuzzleZeroCtrl'
      .when '/ZeroOneLine',
        templateUrl: 'archiv/html/tematka/roc_20/t3/views/puzzleZeroOneLine.tmpl'
        controller: 'PuzzleZeroOneLineCtrl'

      .otherwise
        redirectTo: ''

#    $logProvider.debugEnabled(true)

