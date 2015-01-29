loopback = require 'loopback'
boot = require 'loopback-boot'
_ = require 'lodash'

module.exports = client = loopback()
client.util = _.merge require('../common/util'), require('./helpers/util')
boot(client)
