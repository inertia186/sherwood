document.app.
controller('PostLookupCtrl', ['$scope', '$http', '$sce', '$uibModal', ($scope, $http, $sce, $uibModal) ->
  $scope.$watch 'slug', (newValue, oldValue) ->
    return if newValue == oldValue
    
    $scope.slug_warning = ''
    regex = RegExp(".*(@[a-z0-9\-\.]+/.*)");
    if !!(m = newValue.match(regex))
      $scope.slug = m[1] 
      $scope.slug_warning = ''
    else if newValue.length > 5
      $scope.slug_warning = 'Unable to find post from input.'
    
    if newValue.length > 10
      $http.get("/projects/#{$scope.project_id}/posts/#{$scope.slug}/slug_lookup.json").then (response) ->
        return if !(project = response.data)
        $scope.slug_warning = "Post already present: #{project['id']}"
        if !!project
          $scope.slug_warning += " (Project: #{project.name})"

  $scope.publishWarning = () ->
    $scope.status != 'accepted' && !!$scope.published
  
]).
controller('PostCardCtrl', ['$scope', ($scope) ->
])