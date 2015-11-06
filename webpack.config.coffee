{join} = require 'path'
webpack = require 'webpack'

rel = (path...) ->
  join __dirname, path...

module.exports =
  devtool: 'eval'
  entry: [
    'webpack-hot-middleware/client'
    './client/index'
  ]
  output:
    path: rel 'public'
    filename: 'bundle.js'
    publicPath: '/'
  plugins: [
    new webpack.optimize.OccurenceOrderPlugin()
    new webpack.HotModuleReplacementPlugin()
    new webpack.NoErrorsPlugin()
  ]
  module:
    loaders: [
        test: /\.coffee$/
        loaders: ['babel', 'coffee']
        exclude: /node_modules/
        include: __dirname
    ]
  resolve:
    root: __dirname
    extensions: ['', '.coffee', '.js']
