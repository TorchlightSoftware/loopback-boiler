module.exports = a =
  SET_COUNTER: 'SET_COUNTER'
  INCREMENT_COUNTER: 'INCREMENT_COUNTER'
  DECREMENT_COUNTER: 'DECREMENT_COUNTER'

  set: (value) ->
    type: a.SET_COUNTER
    payload: value

  increment: ->
    type: a.INCREMENT_COUNTER

  decrement: ->
    type: a.DECREMENT_COUNTER

  incrementIfOdd: ->
    (dispatch, getState) ->
      {counter} = getState()
      return if (counter % 2 is 0)
      dispatch(a.increment())

  incrementAsync: (delay = 1000) ->
    (dispatch) ->
      setTimeout (-> dispatch a.increment()), delay
