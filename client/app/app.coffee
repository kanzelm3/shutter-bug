'use strict'

angular.module 'shutterBugApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'btford.socket-io',
  'ui.router',
  'ui.bootstrap'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider
  .otherwise '/'

  $locationProvider.html5Mode true
  $httpProvider.interceptors.push 'authInterceptor'

.factory 'authInterceptor', ($rootScope, $timeout, $q, $cookieStore, $location) ->
  # Add authorization token to headers
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = 'Bearer ' + $cookieStore.get 'token' if $cookieStore.get 'token'
    config

  # Intercept 401s and redirect you to login
  responseError: (response) ->
    if response.status is 401
      $timeout ->
        $location.path '/admin/login'
      , 0
      # remove any stale tokens
      $cookieStore.remove 'token'

    $q.reject response

.run ($rootScope, $state, $timeout, $location, Auth, Menu) ->
  getFullUrl = (state, str) ->
    str = str || state.url
    if state.parent
      parent = $state.get state.parent
      str = parent.url + str
      return getFullUrl parent, str
    else
      return str
  shouldAuthenticate = (state) ->
    authenticate = state.authenticate
    if !authenticate and state.parent
      authenticate = shouldAuthenticate $state.get state.parent
    return authenticate

  $rootScope.stateContains = (state) ->
    $state.includes(state)
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$stateChangeStart', (event, next) ->
    Auth.isLoggedInAsync (loggedIn) ->
      if shouldAuthenticate(next) and not loggedIn
        $timeout ->
          $state.go 'admin.login', {url: getFullUrl(next)}
        return
      if !Menu.shouldRenderState(next)
        return $location.path '/admin/dashboard'

  $rootScope.$watch Auth.getCurrentAccess, (newVal, oldVal) ->
    if newVal and !_.isEqual newVal, oldVal
      if !Menu.shouldRenderState($state.current)
        $location.path '/admin/dashboard'

  Menu.addMenuItem 'admin',
    title: 'Dashboard'
    link: '/admin/dashboard'
    hasAccess: ['canViewDashboard']
  Menu.addMenuItem 'admin',
    title: 'Users'
    link: '/admin/users'
    hasAccess: ['canViewUsers']
  Menu.addMenuItem 'event',
    title: 'Take Photos'
    link: '/event/:eventId/take-photos'
#  Menu.addSubMenuItem 'admin', '/admin/user',
#    title: 'Dashboard'
#    link: '/admin/dashboard'
#    hasAccess: ['canViewDashboard']
