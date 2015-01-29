_ = require 'lodash'
{buildObj} = require('lbclient').util
Promise = require 'when'

module.exports =

  getModelState: (props) ->
    # pull __data from props into state
    state =
      __watching: {}
      __dirty: {}

    for name, prop of props
      if prop.__data
        state.__watching[name] = null
        state.__dirty[name] = {}
        state[name] = _.clone(prop.__data)
    return state

  getInitialState: ->
    @getModelState(@props)

  # helper comparator
  modelsAreSame: (newState) ->
    newModels = _.keys(newState.__watching)
    oldModels = _.keys(@state.__watching)
    modelsAreSame = _.isEqual(newModels, oldModels)
    idsAreSame = _.all newModels, (m) =>
      newState[m]?.id is @state[m]?.id
    return modelsAreSame and idsAreSame

  componentWillReceiveProps: (newProps) ->
    newState = @getModelState(newProps)
    unless @modelsAreSame(newState)
      @setState(newState)

  dirtyCount: ->
    count = 0
    for m, fields of @state.__dirty
      for f, dirty of fields
        count++ if dirty
    return count

  statics: {
    willTransitionFrom: (transition, component) ->
      return if component.dirtyCount() is 0

      deferred = Promise.defer()
      proceed = deferred.resolve.bind(deferred)
      abort = =>
        transition.abort('User cancelled navigation.')
        component.setState {pendingTransition: null}

      component.setState {
        pendingTransition: {proceed, abort}
      }
      return deferred.promise
  }

  #componentWillMount: ->
    ## listen to change, sync state
    #watching = {}
    #Object.keys(@state.__watching).forEach (name) =>
      #model = @props[name]
      #sync = =>
        #@setState buildObj(name, model.__data)
      #model.on 'change', sync
      #watching[name] = sync

  #componentWillUnmount: ->
    ## cancel listeners
    #for name, sync in @state.__watching
      #@props[name].removeListener(sync)
