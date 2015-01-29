_ = require 'lodash'
React = require 'react'
r = React.DOM
lbclient = require 'lbclient'
window.lbclient = lbclient

convert = (obj, select) ->
  if _.isString(select)
    return obj[select]
  else if _.isFunction(select)
    return select(obj)

module.exports = React.createClass

  getDefaultProps: ->
    return {
      idField: '_id'
      selected: []
      displayCheck: false
    }

  importState: (props) ->
    selections = {}
    selectAll = true

    props.records.forEach (record) =>
      # get the ID from the record and determine if it is selected
      id = record[props.idField]
      selected = id in props.selected

      # accumalate the individual state and the selectAll state
      selections[id] = selected
      selectAll = false unless selected

    return {
      selectAll: selectAll
      selections: selections
    }

  getInitialState: ->
    @importState(@props)

  componentWillReceiveProps: (nextProps) ->
    @setState @importState(nextProps)

  selectAllOrNone: ->
    targetState = !@state.selectAll
    selections = _.transform @state.selections,
      (result, sel, id) =>
        result[id] = targetState
        return result
    newState =
      selectAll: targetState
      selections: selections

    @exportState(newState)
    @setState(newState)

  changeSelection: (id) ->
    =>
      # set our new state
      newState =
        selections: _.clone @state.selections
      newState.selections[id] = !@state.selections[id]
      newState.selectAll = _.all newState.selections

      @exportState(newState)
      @setState(newState)

  exportState: (state) ->
    if @props.onSelectionChanged?
      idList = []
      for id, truthy of state.selections
        idList.push(id) if truthy

      @props.onSelectionChanged(idList)

  render: ->
    r.table {
      className: "checklist"
    }, [
      r.thead {}, [
        r.tr {}, [
          if @props.displayCheck
            r.th {}, r.input {
              checked: @state.selectAll
              type: 'checkbox'
              onChange: @selectAllOrNone
            }

          (for name, def of @props.headers
            r.th {className: 'center'}, name
          )
        ]]

      r.tbody {},
        @props.records.map (record) =>
          id = record[@props.idField]
          selected = @state.selections[id]

          r.tr {key: id}, [

            # checkbox
            if @props.displayCheck
              r.td {className: 'center', 'data-title': 'Select'},
                r.input {
                  type: 'checkbox'
                  checked: selected
                  'data-id': id
                  onChange: @changeSelection(id)
                }

            # fields
            for name, def of @props.headers
              r.td {className: 'center', 'data-title': name}, convert(record, def)
          ]]
