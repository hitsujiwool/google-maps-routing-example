
service = new google.maps.DirectionsService()

detectRoute = (from, to, cb) ->
  service.route
    origin: from
    destination: to
    travelMode: google.maps.DirectionsTravelMode.WALKING
  , (result, status) ->
    cb null, result.routes[0].overview_path

module.exports =
  snap: (latLng, cb) ->
    detectRoute latLng, latLng, (err, route) ->
      cb err, route[0]
      
  route: (from, to, cb) ->
    detectRoute from, to, (err, route) ->
      cb err, route
