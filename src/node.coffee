
_ = require 'underscore'
directions = require './directions'

module.exports = class Node
  constructor: (@latLng) ->
    @id = _.uniqueId()

  updatePathToPrev: (cb) ->
    if this.prev
      directions.route this.latLng, this.prev.latLng, (err, route) =>
        this.pathToPrev = route
        cb()
    else
      cb()
      
