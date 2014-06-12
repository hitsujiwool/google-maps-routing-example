
_ = require 'underscore'
directions = require './directions'

module.exports = class Node
  constructor: (@latLng) ->
    @id = _.uniqueId()

  updatePathToPrev: (cb) ->
    if this.prev
      directions.route this.prev.latLng, this.latLng, (err, route) =>
        this.routeFromPrev = route
        cb()
    else
      cb()
