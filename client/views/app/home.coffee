_ = require 'lodash'
React = require 'react'
{RouteHandler} = require 'react-router'
r = React.DOM

module.exports = React.createClass
  render: ->
    #console.log 'app/nav props:', @props
    r.div {}, [
      r.ul {}, @state.queries.getStuff.map (stuff) ->
        r.li {}, [
          r.span stuff.name
          r.span stuff.location
        ]
    ]
