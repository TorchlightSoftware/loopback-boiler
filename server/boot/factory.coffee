async = require 'async'
_ = require 'lodash'

module.exports = (server) ->
  {models, util} = server
  {getModelSummary, log, objMapAsync, getType} = util

  # PRIVATE METHODS
  # call possibly async functions
  callFn = (fn, next) ->
    if fn.length is 0
      next null, fn()
    else
      fn(next)

  # resolve property that is possibly a function
  resolveProperty = (prop, next) ->
    if getType(prop) is 'Function'
      callFn(prop, next)
    else
      next null, prop

  # resolve all properties
  resolveProperties = (props, next) ->
    objMapAsync props, resolveProperty, next

  # PUBLIC Factory API
  server.Factory = Factory =

    __definitions: {}

    define: (name, model, props) ->
      @__definitions[name] =
        {model, props}

    create: (name, props, done) ->
      if (getType(props) is 'Function') and not done?
        done = props
        props = {}

      template = @__definitions[name]
      if getType(template.props) is 'Function'
        tempProps = template.props()
      else
        tempProps = template.props
      finalProps = _.merge {}, tempProps, props

      if getType(template.model) is 'String'
        @create(template.model, finalProps, done)
      else
        #log.yellow 'resolving properties:', finalProps

        # call functions if we got 'em
        resolveProperties finalProps, (err, resolvedProps) ->
          return done(err) if err

          #log.magenta 'creating:', {name, finalProps, resolvedProps}
          template.model.create resolvedProps, done

    createRef: (name, fields, done) ->
      @create name, fields, (err, obj) ->
        #log.cyan "Factory auto-creating '#{name}':", obj
        done err, obj?.id

    assemble: (name, fields) ->
      (cb) => @createRef name, fields, cb

    assembleGroup: (name, records, shared) ->
      records or= [{}]
      if (typeof records) is 'number'
        records = _.times records, (r) -> {}
      records = _.map records, (r) -> _.merge {}, shared, r

      return (cb) =>
        async.map records, @createRef.bind(@, name), cb

    createGroup: (name, records, shared, done) ->
      if arguments.length is 3
        return @createGroup(name, records, null, shared)
      if (typeof records) is 'number'
        records = _.times records, (r) -> {}
      records = _.map records, (r) -> _.merge {}, shared, r

      async.map records, @create.bind(@, name), done

    clearAll: (done) ->

      models = {}
      for n, p of server.models
        models[n] = p

      #log.cyan 'clearing all:\n'
      #log.gray _.keys models

      removeData = (model, next) ->
        model.destroyAll {}, next

      objMapAsync models, removeData, done

  util.require('common/fixtures/factory_data')(server, Factory)
