
google = require 'google'
_ = require 'underscore'

module.exports = class Polyline
  constructor: (@map, @trail, opts = {}) ->
    {@snapped} = opts
    service = new google.maps.DirectionsService()
    route = {}
    line = new google.maps.Polyline
      map: map
      strokeColor: '#FF0000',
      strokeOpacity: 0.3,
      strokeWeight: 5
    trail.on 'add', (node) ->
      route[node.id] = node.pathToPrev.reverse()
      line.setPath _.compose(_.flatten, _.values)(route)

    trail.on 'update', (node) ->
      return unless node.pathToPrev
      route[node.id] = node.pathToPrev.reverse()
      line.setPath _.compose(_.flatten, _.values)(route)
      
