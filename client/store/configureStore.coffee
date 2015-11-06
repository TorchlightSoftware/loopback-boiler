{createStore, applyMiddleware} = require 'redux'
thunk = require 'redux-thunk'
rootReducer = require '../reducers'

createStoreWithMiddleware = applyMiddleware(thunk)(createStore)

module.exports = (initialState) ->
  store = createStoreWithMiddleware(rootReducer, initialState)

  if (module.hot)
    # Enable Webpack hot module replacement for reducers
    module.hot.accept '../reducers', ->
      store.replaceReducer(require '../reducers')

  return store
