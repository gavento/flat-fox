'use strict'

angular.module('flatFoxApp',
    ['ui.bootstrap'])

  .config ($routeProvider, $locationProvider) ->

    $locationProvider
      .html5Mode(false)

    $routeProvider

      .when '',
        templateUrl: 'FLATFOX_BASE_URL/views/plainPPProgram.tmpl'
        controller: 'PPSmallProgramCtrl'

      .when '/Small',
        templateUrl: 'FLATFOX_BASE_URL/views/plainProgram.tmpl'
        controller: 'SmallProgramCtrl'

      .when '/Big',
        templateUrl: 'FLATFOX_BASE_URL/views/plainProgram.tmpl'
        controller: 'BigProgramCtrl'

      .when '/Zero',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzleZero.tmpl'
        controller: 'PuzzleZeroCtrl'

      .when '/ZeroOneLine',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzleZeroOneLine.tmpl'
        controller: 'PuzzleZeroOneLineCtrl'

      .when '/TheAnswer',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzleTheAnswer.tmpl'
        controller: 'PuzzleTheAnswerCtrl'

      .when '/TooBig',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzleTooBig.tmpl'
        controller: 'PuzzleTooBigCtrl'

      .when '/BitRevers',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzleBitRevers.tmpl'
        controller: 'PuzzleBitReversCtrl'

      .when '/Prime',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzlePrime.tmpl'
        controller: 'PuzzlePrimeCtrl'

      .when '/PPSmall',
        templateUrl: 'FLATFOX_BASE_URL/views/plainPPProgram.tmpl'
        controller: 'PPSmallProgramCtrl'

      .when '/PPBig',
        templateUrl: 'FLATFOX_BASE_URL/views/plainPPProgram.tmpl'
        controller: 'PPBigProgramCtrl'

      .when '/PPMultiply',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzlePPMultiply.tmpl'
        controller: 'PPPuzzleMultiplyCtrl'

      .when '/PPDivide',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzlePPDivide.tmpl'
        controller: 'PPPuzzleDivideCtrl'

      .when '/PPNthPrime',
        templateUrl: 'FLATFOX_BASE_URL/views/puzzlePPNthPrime.tmpl'
        controller: 'PPPuzzleNthPrimeCtrl'


      .otherwise
        redirectTo: ''


