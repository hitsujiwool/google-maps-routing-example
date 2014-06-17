
stack = do require 'unagi'
require './underscore_extension'

Trail = require './trail'
Polyline = require './polyline'
Marker = require './marker'

module.exports = (map) ->
  trail = new Trail(stack)
  new Polyline map, trail
  new Marker map, trail
  google.maps.event.addListener map, 'click', (e) ->
    trail.add e.latLng
  { trail: trail, stack: stack }
