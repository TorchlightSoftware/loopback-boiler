{bindActionCreators} = require 'redux'
{connect} = require 'react-redux'
Counter = require '../components/Counter'
CounterActions = require '../actions/counter'

mapStateToProps = (state) ->
  counter: state.counter

mapDispatchToProps = (dispatch) ->
  bindActionCreators(CounterActions, dispatch)

module.exports = connect(mapStateToProps, mapDispatchToProps)(Counter)
