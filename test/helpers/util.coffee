{assert, expect} = require 'chai'
{inspect} = require 'util'
{resolve} = require 'url'
_ = require 'lodash'
request = require 'request'

module.exports =

  # extend isEqual: skip comparison if an object key doesn't exist in the subset
  isSubsetOf: (set, subset, path=[], options={}) ->
    {ignore} = options
    ignore or= []
    pathString = path.join('.')

    return [] unless subset?
    return [] if (pathString in ignore)
    return [{path: pathString, set, subset}] unless set?

    if (typeof set is 'object') and (typeof subset is 'object')
      return _.flatten (
        for k, v of subset
          @isSubsetOf set[k], v, path.concat(k), options
      )
    else
      if set is subset
        return []
      else
        return [{path: pathString, set, subset}]

  assertSubsetOf: (set, subset, options={}) ->
    mismatches = @isSubsetOf set, subset, null, options
    unless _.isEmpty mismatches
      assert false, "\nSet did not include subset.  Mismatches:\n#{inspect mismatches, null, 4}"

  getType: (obj) ->
    ptype = Object.prototype.toString.call(obj).slice 8, -1
    if ptype is 'Object'
      return obj.constructor.name.toString()
    else
      return ptype

  walk: (data, fn, path=[]) ->
    dataType = @getType(data)
    switch dataType
      when 'Array'
        @walk(d, fn, path.concat(i)) for d, i in data
      when 'Object'
        result = {}
        for k, v of data
          result[k] = @walk(v, fn, path.concat(k))
        result
      else
        fn(data, path)

  getApiClient: (app) ->

    (method, url, body, cb) ->
      if _.isFunction(body) and not cb?
        cb = body
        body = undefined

      opts =
        url: resolve app.settings.url, url
        jar: @jar
        json: true
        body: body
        method: method

      request opts, (err, resp, body) =>
        expect(err).to.not.exist
        cb(resp, body)

  assertStatus: (resp, code) ->
    unless resp.statusCode is code
      @log.yellow resp.body?.error?.stack or resp.body
    expect(resp.statusCode).to.eql code

_.bindAll module.exports, ['walk']
