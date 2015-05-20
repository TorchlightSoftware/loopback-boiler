React = require 'react'
Router = require 'react-router'
{Route, DefaultRoute} = Router

module.exports = (client) ->

  v = (name) ->
    require 'views/' + name

  routes = Route {name: 'home', path: '/', handler: v('home')}, [
  ]

  target = document.getElementById('content')

  Router.run routes, (Handler) ->
    React.render Handler(), target
