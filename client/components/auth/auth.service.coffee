'use strict'

angular.module 'shutterBugApp'
.factory 'Auth', ($location, $stateParams, $rootScope, $http, User, $cookieStore, $q) ->
  currentUser = if $cookieStore.get 'token' then User.get() else {}
  currentAccess = {}
  currentUser.$promise && currentUser.$promise.then (user) ->
    currentAccess = if user.accessDefinitions then user.accessDefinitions[0] else {}

  getCurrentAccessLevel = ->
    currentAccess.accessLevel

  ###
  Authenticate user and save token

  @param  {Object}   user     - login info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  login: (user, callback) ->
    deferred = $q.defer()
    $http.post '/auth/local',
      email: user.email
      password: user.password

    .success (data) ->
      $cookieStore.put 'token', data.token
      currentUser = User.get()
      currentUser.$promise && currentUser.$promise.then (user) ->
        currentAccess = if user.accessDefinitions then user.accessDefinitions[0] else {}
      deferred.resolve data
      callback?()

    .error (err) =>
      @logout()
      deferred.reject err
      callback? err

    deferred.promise


  ###
  Delete access token and user info

  @param  {Function}
  ###
  logout: ->
    $cookieStore.remove 'token'
    currentUser = {}
    currentAccess = {}
    return


  ###
  Create a new user

  @param  {Object}   user     - user info
  @param  {Function} callback - optional
  @return {Promise}
  ###
  createUser: (user, callback) ->
    User.save user,
      (data) ->
        $cookieStore.put 'token', data.token
        currentUser = User.get()
        callback? user

      , (err) =>
        @logout()
        callback? err

    .$promise

  completeUserSetup: (user) ->
    deferred = $q.defer()
    $http.post '/api/users/new/' + $stateParams.token, user

    .success (data) ->
      $cookieStore.put 'token', data.token
      currentUser = User.get()
      currentUser.$promise && currentUser.$promise.then (user) ->
        currentAccess = if user.accessDefinitions then user.accessDefinitions[0] else {}
      deferred.resolve data

    .error (err) =>
      @logout()
      deferred.reject err


  ###
  Change password

  @param  {String}   oldPassword
  @param  {String}   newPassword
  @param  {Function} callback    - optional
  @return {Promise}
  ###
  changePassword: (oldPassword, newPassword, callback) ->
    User.changePassword
      id: currentUser._id
    ,
      oldPassword: oldPassword
      newPassword: newPassword

    , (user) ->
      callback? user

    , (err) ->
      callback? err

    .$promise


  ###
  Gets all available info on authenticated user

  @return {Object} user
  ###
  getCurrentUser: ->
    currentUser

  setCurrentAccess: (accessDefinition) ->
    currentAccess = if accessDefinition then accessDefinition else {}

  getCurrentAccess: ->
    currentAccess

  getCurrentEntity: ->
    currentAccess.entity

  getCurrentAccessLevel: getCurrentAccessLevel

  getUserAccess: (user) ->
    if !currentAccess.entity
      return {}
    return _.find user.accessDefinitions, (accessDefinition) ->
      return accessDefinition.entity.name == currentAccess.entity.name

  ###
  Check if a user is logged in synchronously

  @return {Boolean}
  ###
  isLoggedIn: ->
    currentUser.hasOwnProperty 'role'


  ###
  Waits for currentUser to resolve before checking if user is logged in
  ###
  isLoggedInAsync: (callback) ->
    if currentUser.hasOwnProperty '$promise'
      currentUser.$promise.then ->
        callback? true
        return
      .catch ->
        callback? false
        return

    else
      callback? currentUser.hasOwnProperty 'role'

  ###
  Check if a user is an admin

  @return {Boolean}
  ###
  isAdmin: ->
    currentUser.role is 'admin'

  hasAccess: (properties) ->
    hasAccess = false
    if getCurrentAccessLevel()
      if Array.isArray(properties) then properties else [properties]
      properties.forEach (property) ->
        if getCurrentAccessLevel().access[property]
          hasAccess = true
    hasAccess

  ###
  Get auth token
  ###
  getToken: ->
    $cookieStore.get 'token'
