
_ = require 'underscore'

module.exports = class Node
  constructor: (@latLng) ->
    @id = _.uniqueId()
