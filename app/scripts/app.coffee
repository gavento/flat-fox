'use strict'

angular.module('flatFoxApp',
    ['ui.bootstrap'])
  .config ($routeProvider) ->
    $routeProvider
      .when '',
        templateUrl: 'views/program.html'
        controller: 'ProgramCtrl'
      .otherwise
        redirectTo: ''
