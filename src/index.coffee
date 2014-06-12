Trail = require './trail'
Polyline = require './polyline'
Marker = require './marker'

module.exports = (map) ->
  trail = new Trail()
  new Polyline map, trail
  new Marker map, trail      
  google.maps.event.addListener map, 'click', (e) ->
    trail.add e.latLng
