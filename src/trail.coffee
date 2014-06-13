
google = require 'google'
_ = require('underscore')
EventEmitter = require('events').EventEmitter
directions = require './directions'
Node = require './node'

module.exports = class Trail extends EventEmitter
  constructor: (@bido) ->
    @nodes = []
    @service = new google.maps.DirectionsService()

  add: (latLng, cb) ->
    if @nodes.length is 0
      directions.snap latLng, (err, snapped) =>
        node = new Node(snapped)
        node.isInitial = true
        do @bido (=>
          @nodes.push node        
          this.emit 'start', node
        ),
        (=>
          @nodes = _.without @nodes, node          
          this.emit 'remove', node
        )
      return
    len = @nodes.length
    prevNode = @nodes[len - 1]
    directions.route prevNode.latLng, latLng, (err, route) =>
      path = route.overview_path
      node = new Node(path[path.length - 1])
      node.routeFromPrev = route
      node.prev = prevNode
      prevNode.next = node
      do @bido (=>
        @nodes.push node     
        this.emit 'add', node
      ),
      (=>
        @nodes = _.without @nodes, node
        this.emit 'remove', node
      )

  nodeAt: (latLng) ->
    _.find @nodes, (node) -> node.latLng.equals(latLng)

  replace: (node, latLng) ->
    node.latLng = latLng        
    node.updatePathToPrev =>
      this.emit 'update', node
      if node.next
        node.next.updatePathToPrev =>
          this.emit 'update', node.next
                    
  calcDistance: ->
    @nodes.slice(1).reduce (sum, node) ->
      route = node.routeFromPrev
      sum + route.legs.reduce(((sum, leg) -> sum + leg.distance.value), 0)
    , 0
