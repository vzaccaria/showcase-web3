
#Main entry point of the application
application = angular.module('application', [])

$scope, $http <~ application.controller 'appCtrl' 
$scope.status = 'ok'
