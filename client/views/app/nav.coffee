_ = require 'lodash'
React = require 'react'
{RouteHandler} = require 'react-router'
r = React.DOM

{link} = require '../../helpers/util'

links = [
    text: 'Foo'
    href: 'foo'
]

module.exports = React.createClass
  getInitialState: ->
    {closed: true}

  renderLink: (l) ->
    className = if l.href is @props.path then 'active'
    r.li {className},
      link {href: l.href}, l.text

  toggle: ->
    @setState {closed: !@state.closed}

  render: ->
    #console.log 'app/nav props:', @props
    closed = if @state.closed then '-closed' else ''
    r.div {}, [
      r.div {className: "app-bar#{closed}"}, [
        r.ul {}, links.map(@renderLink)
      ]
      r.div {className: "app-content#{closed}"}, [
        r.div {className: 'app-title'}, [
          r.span {
            className: 'glyphicon glyphicon-list app-bar-toggle'
            onClick: @toggle
            cursor: 'pointer'
          }
          r.h2 {}, 'Dashboard'
        ]

        r.div {className: "app-content-child"},
          RouteHandler()
      ]
    ]
