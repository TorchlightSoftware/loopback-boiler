Express = require 'express'
serveStatic = require "serve-static"
qs = require 'qs'

webpack = require 'webpack'
webpackDevMiddleware = require 'webpack-dev-middleware'
webpackHotMiddleware = require 'webpack-hot-middleware'
webpackConfig = require '../webpack.config'

React = require 'react'
{renderToString} = require 'react-dom/server'
{fetchCounter} = require './api/counter'
configureStore = require './store/configureStore'

Provider = React.createFactory require('react-redux').Provider
App = React.createFactory require './containers/App'

app = new Express()
port = 3001

# Use this middleware to set up hot module reloading via webpack.
compiler = webpack(webpackConfig)

app.use webpackDevMiddleware compiler,
  noInfo: true
  publicPath: webpackConfig.output.publicPath

app.use webpackHotMiddleware(compiler)

# This is fired every time the server side receives a request
app.get '/', (req, res) ->
  # Query our mock API asynchronously
  fetchCounter (apiResult) =>
    # Read the counter from the request, if provided
    params = qs.parse(req.query)
    counter = parseInt(params.counter, 10) || apiResult || 0

    # Create a new Redux store instance
    store = configureStore({counter})

    # Render the component to a string
    html = renderToString Provider {store}, App()

    # Grab the initial state from our Redux store
    finalState = store.getState()

    # Send the rendered page back to the client
    res.send(renderFullPage(html, finalState))

renderFullPage = (html, initialState) ->
  return """
    <html>
      <head>
        <title>Redux Universal Example</title>
      </head>
      <body>
        <div id="app">#{html}</div>
        <script>
          window.__INITIAL_STATE__ = #{JSON.stringify(initialState)}
        </script>
        <script src="/bundle.js"></script>
      </body>
    </html>
    """
# -- Mount static files here--
# All static middleware should be registered at the end, as all requests
# passing the static middleware are hitting the file system
path = require("path")
app.use serveStatic(path.resolve(__dirname, "../public"))

app.listen port, (error) ->
  return console.error(error) if error
  console.info """
  ==> 🌎  Listening on port #{port}.
  Open up http://localhost:#{port}/ in your browser.
  """
