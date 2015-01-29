_ = require 'lodash'
async = require 'async'
{join} = require 'path'

module.exports =

  root: join __dirname, '..'

  # project relative path
  rel: (names...) ->
    join(@root, names...)

  # project relative require
  require: (names...) ->
    require @rel(names...)

  getType: (obj) ->
    ptype = Object.prototype.toString.call(obj).slice 8, -1
    if ptype is 'Object'
      return obj.constructor.name.toString()
    else
      return ptype

  getModelSummary: (model) ->
    _.pick model.definition, ['properties', 'settings', 'relations', 'indexes']

  # Usage: objMapAsync {a: 1, b: 2}, ((n, next) -> next null, n+1), done
  # => done called with: (null, {a: 2, b: 3})
  objMapAsync: (obj, iter, done) ->
    wrappedIter = (results, key, next) ->
      # take the returned value and add it to the appropriate key
      interpret = (err, result) ->
        results[key] = result
        next(err, results)
      # run the passed iterator with (value, cb, key)
      iter obj[key], interpret, key

    async.reduce Object.keys(obj), {}, wrappedIter, done

_.bindAll(module.exports, ['rel', 'require'])
