# runs queries and sets state
_ = require 'lodash'
React = require 'react'
r = React.DOM
{displayError, objMapAsync, modelCollection} = require 'helpers/util'

module.exports =

  # INPUT properties (set by concrete class)
  # queries: {[name]: (done) -> Model.find {id}, done}

  # OUTPUT state
  # queries: {[name]: [ModelInstance | ModelCollection]}
  # waitingForQueries: [true | false]

  # METHODS
  # refreshQueries([(err, queries) ->])

  getInitialState: ->
    waitingForQueries: true

  runQuery: (query, next) ->
    query.call(@, next)

  refreshQueries: (done=->) ->
    objMapAsync @queries, @runQuery, (err, queries) =>
      return displayError(err) if err?
      @setState {queries, waitingForQueries: false}
      done(err, queries)

  renderLoadScreen: ->
    r.img {className: 'load-indicator', src: '/media/loading.gif'}

  componentDidMount: ->
    @refreshQueries()
