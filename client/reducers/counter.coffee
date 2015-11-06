{
  SET_COUNTER
  INCREMENT_COUNTER
  DECREMENT_COUNTER
} = require '../actions/counter'

module.exports = (state = 0, action) ->
  switch (action.type)
    when SET_COUNTER
      action.payload
    when INCREMENT_COUNTER
      state + 1
    when DECREMENT_COUNTER
      state - 1
    else
      state
