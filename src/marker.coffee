
directions = require './directions'

module.exports = class Marker
  constructor: (@map, @trail) ->
    @markers = {}

    @trail.on 'start', (node) =>
      this.add node
      
    @trail.on 'add', (node) =>
      this.add node

    @trail.on 'remove', (node) =>
      @markers[node.id].setMap null

    @trail.on 'update', (node) =>
      @markers[node.id].setPosition node.latLng

   add: (node) ->
    marker = new google.maps.Marker
      position: node.latLng
      map: @map
      draggable: true
    @markers[node.id] = marker
          
    google.maps.event.addListener marker, 'dragstart', (e) =>
      @draggingNode = @trail.nodeAt(e.latLng)
    google.maps.event.addListener marker, 'dragend', (e) =>
      directions.snap e.latLng
        .then (latLng) =>
          @trail.replace @draggingNode, latLng
          @draggingNode = null
