
require './underscore_extension'

Trail = require './trail'
Polyline = require './polyline'
Marker = require './marker'
bido = do require './bido'

module.exports = (map) ->
  trail = new Trail(bido)
  new Polyline map, trail
  new Marker map, trail
  google.maps.event.addListener map, 'click', (e) ->
    trail.add e.latLng
  { trail: trail, bido: bido }
