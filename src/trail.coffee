
google = require 'google'
_ = require('underscore')
EventEmitter = require('events').EventEmitter
directions = require './directions'
Node = require './node'

module.exports = class Trail extends EventEmitter
  constructor: (@bido) ->
    @nodes = []
    @service = new google.maps.DirectionsService()

  add: (latLng) ->
    if @nodes.length is 0
      this.addInitial(latLng)
    else
      this.addFollowing(latLng)

  addInitial: (latLng) ->
    directions.snap latLng
      .then (snapped) =>
        node = new Node(snapped)
        node.isInitial = true
        do @bido =>
          @nodes.push node
          this.emit 'start', node
        , =>
          @nodes = _.without @nodes, node
          this.emit 'remove', node

  addFollowing: (latLng) ->
    len = @nodes.length
    prevNode = @nodes[len - 1]
    directions.route prevNode.latLng, latLng
      .then (route) =>
        path = route.overview_path
        node = new Node(path[path.length - 1])
        node.routeFromPrev = route
        node.prev = prevNode
        prevNode.next = node
        do @bido =>
          @nodes.push node     
          this.emit 'add', node
        , =>
          this.remove node
          this.emit 'remove', node

  remove: (node) ->
    if (prevNode = node.prev)
      prevNode.next = null
    @nodes = _.without @nodes, node
    this

  nodeAt: (latLng) ->
    _.find @nodes, (node) -> node.latLng.equals(latLng)

  replace: (node, latLng) ->
    oldLatLng = new google.maps.LatLng node.latLng.lat(), node.latLng.lng()
    if @nodes.length is 1
      do @bido =>
        node.latLng = latLng
        this.emit 'update', node
      , =>
        node.latLng = oldLatLng
        this.emit 'update', node
      return
    oldRoutes = _.compact _.compact([node, node.next]).map (n) -> n.routeFromPrev
    latLngs = _.compact [node.prev?.latLng, latLng, node.next?.latLng]
    p = directions.routes latLngs
    do @bido =>
      p.then (routes) =>
        node.latLng = latLng
        nodes = if node.isInitial then [node.next] else [node, node.next]
        _.zipWith _.compact(nodes), routes, (n, route) =>
          n.routeFromPrev = route
        (_.compact [node, node.next]).forEach (n) => this.emit 'update', n
      .catch (e) ->
        console.error e
    , =>
      node.latLng = oldLatLng
      nodes = if node.isInitial then [node.next] else [node, node.next]
      _.zipWith _.compact(nodes), oldRoutes, (n, route) =>
        n.routeFromPrev = route
      (_.compact [node, node.next]).forEach (n) => this.emit 'update', n

  calcDistance: ->
    @nodes.slice(1).reduce (sum, node) ->
      route = node.routeFromPrev
      sum + route.legs.reduce(((sum, leg) -> sum + leg.distance.value), 0)
    , 0
