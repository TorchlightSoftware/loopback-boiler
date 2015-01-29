_ = require 'lodash'
e = process.env
{join} = require 'path'

envConfigs =
  development:
    config:
      host: "0.0.0.0"
      port: 3000
      url: "http://localhost:3000/"

  test:
    config:
      host: "0.0.0.0"
      port: 3031
      url: "http://localhost:3031/"

defaultConfig =
  appRootDir: join __dirname, '..'
  restApiRoot: "/api"

  dataSources:
    db:
      name: 'db'
      connector: 'memory'

  config: {}

  modelSources: [
    "common/models"
    "server/models"
  ]

  bootDirs: ['server/boot']

  models:

    # built-in models
    User:
      dataSource: "db"

    AccessToken:
      dataSource: "db"
      public: false

    ACL:
      dataSource: "db"
      public: false

    RoleMapping:
      dataSource: "db"
      public: false

    Role:
      dataSource: "db"
      public: false

    # TODO: project-specific models

module.exports = _.merge {}, defaultConfig, envConfigs[e.NODE_ENV]
