
_ = require 'underscore'
Promise = require('es6-promise').Promise;
directions = require './directions'

module.exports = class Node
  constructor: (@latLng) ->
    @id = _.uniqueId()

  updateRouteFromPrev: ->
    new Promise (resolve, reject) =>
      if this.prev
        directions.route this.prev.latLng, this.latLng
          .then (route) =>
            this.routeFromPrev = route
            resolve()
      else
        resolve()
