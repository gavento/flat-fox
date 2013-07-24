'use strict'

angular.module('flatFoxApp',
    ['ui.bootstrap'])
  .config ($routeProvider) ->
    $routeProvider
      .when '',
        templateUrl: 'archiv/html/tematka/roc_20/t3/views/program.tmpl'
        controller: 'ProgramCtrl'
      .when 'puzzle/Zero',
        templateUrl: 'archiv/html/tematka/roc_20/t3/views/puzzleZero.tmpl'
        controller: 'PuzzleZeroCtrl'
      .when 'puzzle/ZeroOneLine',
        templateUrl: 'archiv/html/tematka/roc_20/t3/views/puzzleZeroOneLine.tmpl'
        controller: 'PuzzleZeroOneLineCtrl'
      .otherwise
        redirectTo: ''
