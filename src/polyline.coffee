
google = require 'google'
_ = require 'underscore'

module.exports = class Polyline
  constructor: (@map, @trail, opts = {}) ->
    {@snapped} = opts
    path = {}
    line = new google.maps.Polyline
      map: map
      strokeColor: '#FF0000',
      strokeOpacity: 0.3,
      strokeWeight: 5
    trail.on 'add', (node) ->
      path[node.id] = node.routeFromPrev.overview_path
      line.setPath _.compose(_.flatten, _.values)(path)

    trail.on 'update', (node) ->
      return if node.isInitial
      path[node.id] = node.routeFromPrev.overview_path
      line.setPath _.compose(_.flatten, _.values)(path)

    trail.on 'remove', (node) =>
      return if node.isInitial
      delete path[node.id]
      line.setPath _.compose(_.flatten, _.values)(path)
              
