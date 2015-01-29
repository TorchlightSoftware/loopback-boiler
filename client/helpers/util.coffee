_ = require 'lodash'
React = require 'react'
r = React.DOM
numeral = require 'numeral'
{join} = require 'path'

module.exports =
  root: '/'

  rel: (names...) ->
    join(@root, names...)

  log: (args...) ->
    console.log args...

  link: (attrs, children) ->
    newAttrs = _.merge {}, attrs, {href: "##{attrs.href}"}
    r.a newAttrs, children

  displayError: (error) ->
    console.log('Error:', error)

  formatCash: (num) ->
    formatted = numeral(num).format('($0,0.00)')
    if num < 0
      return r.span {className: 'negative'}, formatted
    else
      return formatted

  buildObj: (key, val) ->
    obj = {}
    obj[key] = val
    return obj
