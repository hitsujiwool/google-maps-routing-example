
google = require 'google'
_ = require 'underscore'
Promise = require('es6-promise').Promise;
service = new google.maps.DirectionsService()

detectRoute = (from, to) ->
  new Promise (resolve, reject) ->
    service.route
      origin: from
      destination: to
      unitSystem: google.maps.UnitSystem.METRIC
      travelMode: google.maps.DirectionsTravelMode.WALKING
    , (result, status) ->
      resolve(result.routes[0])

module.exports =
  snap: (latLng) ->
    detectRoute latLng, latLng
      .then (route) ->
        route.overview_path[0]

  route: (from, to) ->
    detectRoute from, to

  routes: (wayPoints) ->
    promises = []
    _.eachCons wayPoints, (els) ->
      [from, to] = els
      promises.push detectRoute(from, to)
    , 2
    Promise.all promises
