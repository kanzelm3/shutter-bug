'use strict'

angular.module 'shutterBugApp'
.config ($stateProvider) ->
  $stateProvider.state 'users',
    url: '/users'
    parent: 'admin'
    resolve:
      users: (User, Auth) ->
        user = Auth.getCurrentUser()
        user.$promise && user.$promise.then ->
          return if Auth.getCurrentAccess() then User.query({entityId: Auth.getCurrentAccess().entity._id}) else User.query()

    views:
      '':
        templateUrl: 'app/admin/users/users.html'
        controller: 'UsersCtrl'
