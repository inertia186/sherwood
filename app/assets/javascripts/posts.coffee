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
    $scope.status != 'accepted' && $scope.published == 'true'
  
]).
controller('PostCardCtrl', ['$scope', '$uibModal', ($scope, $uibModal) ->
  $scope.modalPlagiarismResults = (event, post_id, url, checked_at) ->
    event.preventDefault()
    
    modalInstance = $uibModal.open
      # animation: $scope.animationsEnabled,
      templateUrl: 'modal_plagiarism_results.html',
      controller: 'ModalCtrl',
      size: 'lg',
      resolve:
        event: -> event
        post_id: -> post_id
        url: -> url
        checked_at: -> checked_at
]).
controller('ModalCtrl', ['$scope', '$uibModalInstance', '$http', '$sce', 'event', 'post_id', 'url', 'checked_at', ($scope, $uibModalInstance, $http, $sce, event, post_id, url, checked_at) ->
  $scope.title = event.target.text
  $scope.post_id = post_id
  $scope.url = url
  $scope.checked_at = checked_at
  $scope.plagiarism_results = $sce.trustAsHtml '<div class="jumbotron"><div class="center-block spinner-icon" /></div>'
  
  if !!$scope.url
    html = """
      <iframe src="#{$scope.url}" width="800" height="600"></iframe>
      <p><a href="#{$scope.url}" target="post_id_#{post_id}">#{$scope.url}</a></p>
      <p>Checked: <relative_timestamp>#{$scope.checked_at}</relative_timestamp></p>
    """
    $scope.plagiarism_results = $sce.trustAsHtml html
  else
    if confirm("Each plagiarism check costs the server owner 5¢ USD.  Continue?")
      $http.post("/posts/#{post_id}/check_for_plagiarism.json").then (response) ->
        p = response.data
        if !!p['error']
          $scope.plagiarism_results = $sce.trustAsHtml p['error']
        else if !!p['plagiarism_results_url']
          $scope.url = p['plagiarism_results_url']
          $scope.checked_at = p['plagiarism_checked_at']
        else
          $scope.plagiarism_results = $sce.trustAsHtml "No plagiarism result."
          
        if !!$scope.url
          html = """
            <iframe src="#{$scope.url}" width="800" height="600"></iframe>
            <p><a href="#{$scope.url}" target="post_id_#{post_id}">#{$scope.url}</a></p>
            <p>Checked: Just now.</p>
          """
          $scope.plagiarism_results = $sce.trustAsHtml html
    else
      $scope.plagiarism_results = $sce.trustAsHtml 'Skipped.'
  
  $scope.done = -> $uibModalInstance.dismiss('done')
])
