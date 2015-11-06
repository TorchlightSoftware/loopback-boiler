React = require 'react'
{render} = require 'react-dom'
configureStore = require './store/configureStore'

store = configureStore window.__INITIAL_STATE__
rootElement = document.getElementById 'app'

App = React.createFactory require './containers/App'
Provider = React.createFactory require('react-redux').Provider

render(
  Provider({store}, App())
  rootElement
)
