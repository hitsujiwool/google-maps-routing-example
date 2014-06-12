
google = require 'google'
service = new google.maps.DirectionsService()

detectRoute = (from, to, cb) ->
  service.route
    origin: from
    destination: to
    unitSystem: google.maps.UnitSystem.METRIC
    travelMode: google.maps.DirectionsTravelMode.WALKING
  , (result, status) ->
    cb null, result.routes[0]

module.exports =
  snap: (latLng, cb) ->
    detectRoute latLng, latLng, (err, route) ->
      cb err, route.overview_path[0]
      
  route: (from, to, cb) ->
    detectRoute from, to, (err, route) ->
      cb err, route
