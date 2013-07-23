'use strict'

angular.module('flatFoxApp',
    ['ui.bootstrap'])
  .config ($routeProvider) ->
    $routeProvider
      .when '',
        templateUrl: 'archiv/html/tematka/roc_20/t3/views/program.tmpl'
        controller: 'ProgramCtrl'
      .otherwise
        redirectTo: ''
