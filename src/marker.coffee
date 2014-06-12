
directions = require './directions'

module.exports = class Marker
  constructor: (@map, @trail) ->
    @markers = []

    @trail.on 'start', (node) =>
      this.add node
      
    @trail.on 'add', (node) =>
      this.add node    

   add: (node) ->
    marker = new google.maps.Marker
      position: node.latLng
      map: @map
      draggable: true
          
    google.maps.event.addListener marker, 'dragstart', (e) =>
      @draggingNode = @trail.nodeAt(e.latLng)
    google.maps.event.addListener marker, 'dragend', (e) =>
      directions.snap e.latLng, (err, snapped) =>
        marker.setPosition snapped
        @trail.replace @draggingNode, snapped
        @draggingNode = null
