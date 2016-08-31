document.app.
controller('SessionCtrl', ['$scope', ($scope) ->
  $scope.$watch 'email', (newValue, oldValue) -> checkPassword()
  $scope.$watch 'password', (newValue, oldValue) -> checkPassword()
  
  checkPassword = -> $scope.passwordProblem = $scope.email.length > 0 && $scope.password.length < 8
])
