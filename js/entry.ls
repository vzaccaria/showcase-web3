
#Main entry point of the application
application = angular.module('application', [])

controller-init = ($scope, $http) ~>
        $scope.status = 'ok'

# Remember to DI in each controller...
application.controller 'appCtrl', [ "$scope", "$http", controller-init ]

