'use strict'

angular.module 'shutterBugApp'
.controller 'TakePhotosCtrl', ($http, $scope, $timeout, $window, $q, socket) ->
  $scope.pictures = []

  video = document.getElementById 'video'

  videoObj =
    video:
      mandatory:
        minWidth: 1280
        maxHeight: 720

  errBack = (error) ->
    if error then console.log 'Video capture error: ', error.code
    return

  if $window.navigator.getUserMedia
    # Standard
    $window.navigator.getUserMedia videoObj, (stream) ->
      video.src = stream
      video.play()
    , errBack
  else if $window.navigator.webkitGetUserMedia
    # WebKit-prefixed
    $window.navigator.webkitGetUserMedia videoObj, (stream) ->
      video.src = $window.webkitURL.createObjectURL(stream)
      video.play()
    , errBack
  else if $window.navigator.mozGetUserMedia
    # Firefox-prefixed
    $window.navigator.mozGetUserMedia videoObj, (stream) ->
      video.src = $window.URL.createObjectURL(stream)
      video.play()
    , errBack

  $http.get('/api/assets').success (pictures) ->
    $scope.pictures = pictures
    socket.syncUpdates 'asset', $scope.pictures

  $scope.selectPicture = (picture) ->
    if picture.selected
      delete picture.selected
      return
    picture.selected = true

  $scope.enlarge = (picture) ->
    $scope.enlargedPicture = picture

  $scope.capturePhoto = ->

    $scope.countdown = 3

    countDown = ->
      if $scope.countdown > 0
        $timeout ->
          $scope.countdown = $scope.countdown - 1
          countDown()
        , 800
      else
        video.pause()
        $scope.captureMessage = 'CAPTURING'
        $http.get('/api/assets/capture/photo')
        .success (photo) ->
          console.log 'Photo: ', photo
          $scope.captureMessage = 'PHOTO CAPTURED'
          $timeout ->
            $scope.countdown = undefined
            video.play()
          , 1000
        .error (err) ->
          $scope.captureMessage = err
          $timeout ->
            $scope.countdown = undefined
            video.play()
          , 1000
    countDown()

  getImage = (dir) ->
    index = $scope.pictures.indexOf $scope.enlargedPicture
    if index != -1
      newIndex == undefined
      if dir == 'prev'
        newIndex = index - 1
        if newIndex == -1
          newIndex = $scope.pictures.length - 1
      if dir == 'next'
        newIndex = index + 1
        if newIndex == $scope.pictures.length
          newIndex = 0
      if newIndex != undefined
        $scope.enlargedPicture = $scope.pictures[newIndex]


  $scope.previousImage = ->
    getImage 'prev'

  $scope.nextImage = ->
    getImage 'next'
