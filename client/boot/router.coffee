React = require 'react'
Router = require 'react-router'
{Route, DefaultRoute} = Router

module.exports = (client) ->

  v = (name) ->
    require 'views/' + name

  routes = Route {name: 'app', path: '/', handler: v('app/nav')}, [
  ]

  target = document.getElementById('content')

  Router.run routes, (Handler) ->
    React.render Handler(), target
