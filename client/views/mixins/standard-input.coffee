# This is tightly coupled with bootstrap's form group implementation.
# It also relies on LoopbackReact to sync models in props to state
_ = require 'lodash'
async = require 'async'
React = require 'react'
r = React.DOM

{buildObj} = require('lbclient').util

getFieldMeta = (Model, field_name) ->
  Model?.definition?.properties?[field_name] or {}

getInputType = (meta) ->
  if meta.enum
    return {input: r.select}

  switch meta.type
    when String
      {input: r.input}
    when Boolean
      {input: r.input, type: 'checkbox'}
    else
      {input: r.input}

module.exports =
  input: (modelName, props) ->
    {groupStyle, groupClasses, classes} = props
    delete props.groupStyle
    delete props.groupClasses
    delete props.classes

    groupClassName = _.union(groupClasses, ['form-group']).join ' '
    inputClassName = _.union(classes, ['form-control']).join ' '

    Model = @props[modelName].constructor
    meta = getFieldMeta(Model, props.id)
    defaultType = getInputType(meta)

    # defaults, passed, overrides
    props = _.merge defaultType, {
      label: meta.human
      value: @state[modelName][props.id]
      checked: (if (meta.type?.name is 'Boolean') then @state[modelName][props.id])
      onChange: (evt) =>
        if (meta.type?.name is 'Boolean')
          value = evt.target.checked
        else
          value = evt.target.value

        oldValue = @props[modelName][props.id]
        dirty = not (value.toString() is oldValue.toString())
        #console.log {oldValue, value, dirty}

        # grab the existing model and modify the target value
        state = _.pick(@state, modelName)
        state[modelName][props.id] = value
        state.__dirty = @state.__dirty
        state.__dirty[modelName][props.id] = dirty
        #console.log 'meta:', meta
        #console.log 'setting state:', state, 'value:', value
        @setState(state)

    }, props, {className: inputClassName}

    {input, label} = props
    delete props.input
    delete props.label

    if meta.enum
      options = meta.enum.map (opt) -> r.option {value: opt}, opt

    return r.div {style: groupStyle, className: groupClassName},
      r.div {className: 'input-group'}, [
        r.label {for: props.id}, label
        input(props, options)
      ]

  saveModel: (modelName, next) ->
    model = @props[modelName]
    state = @state[modelName]
    model.__data = state
    model.save(next)

  pd: (fn, args...) ->
    (e) ->
      e.preventDefault()
      fn(args...)

  saveAll: (done) ->
    done or= ->
    async.map _.keys(@state.__watching), @saveModel, (err, models) =>
      if err
        @setState {error: err}
      else
        @setState(@getModelState(@props))
      done(err)

  cancelAll: ->
    @setState(@getModelState(@props))

  formControls: (props) ->
    props or= {}

    dirtyCount = @dirtyCount()

    if @state.error
      r.div {className: 'error'}, @state.error

    else if @state.pendingTransition
      r.div {className: 'form-leaving'},
        r.div {}, [
          r.span {}, "#{dirtyCount} fields changed."

          r.button {
            className: 'btn btn-info'
            onClick: @pd @state.pendingTransition.abort
          }, 'Stay Here'

          r.button {
            className: 'btn btn-primary'
            onClick: @pd @saveAll, (err) =>
              if err
                @state.pendingTransition.abort()
              else
                @state.pendingTransition.proceed()
          }, 'Save and Leave'

          r.button {
            className: 'btn btn-danger'
            onClick: @pd @state.pendingTransition.proceed
          }, 'Discard and Leave'
        ]

    else if dirtyCount > 0
      r.div {className: 'form-controls'},
        r.span {}, "#{dirtyCount} fields changed."
        r.button {
          className: 'btn btn-danger'
          onClick: @pd @cancelAll
        }, 'Cancel'
        r.button {
          className: 'btn btn-primary'
          onClick: @pd @saveAll
        }, 'Save'
    else
      r.div()
