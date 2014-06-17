_ = require 'underscore'

_.mixin eachCons: (list, iterator, n, context) ->
  throw new Error 'list length must be greater than or equal to ' + n if list.length < n
  for i in [0..list.length - n]
    els = list[i...(i + n)]
    iterator.call(context, els, i, list)

_.mixin zipWith: (lists..., cb) ->
  numIteration = Math.min.apply null, lists.map (item) -> item.length
  [0...numIteration].map (n) ->
    cb.apply null, lists.map (list) -> list[n]
