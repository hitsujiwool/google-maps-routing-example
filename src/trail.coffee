
google = require 'google'
_ = require('underscore')
EventEmitter = require('events').EventEmitter
directions = require './directions'
Node = require './node'

module.exports = class Trail extends EventEmitter
  constructor: ->
    @nodes = []
    @service = new google.maps.DirectionsService()

  add: (latLng, cb) ->
    if @nodes.length is 0
      directions.snap latLng, (err, snapped) =>
        @startNode = new Node(snapped)
        @nodes.push @startNode
        this.emit 'start', @startNode
      return
    len = @nodes.length
    prevNode = @nodes[len - 1]
    directions.route prevNode.latLng, latLng, (err, route) =>
      node = new Node(route[route.length - 1])
      prevNode.pathToNext = route
      prevNode.next = node
      node.pathToPrev = route.reverse()
      node.prev = prevNode
      @nodes.push node
      this.emit 'add', node

  nodeAt: (latLng) ->
    _.find @nodes, (node) -> node.latLng.equals(latLng)

  replace: (node, latLng) ->
    node.latLng = latLng  
    node.updatePathToPrev =>
      this.emit 'update', node
      if node.next
        node.next.updatePathToPrev =>
          this.emit 'update', node.next

  getNeighborhood: (latLng) ->
