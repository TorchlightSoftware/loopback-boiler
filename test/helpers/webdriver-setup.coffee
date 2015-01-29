webdriver = require 'selenium-webdriver'
_ = require 'lodash'

driver = new webdriver.Builder().
  withCapabilities(webdriver.Capabilities.chrome()).build()

{By} = webdriver

waitFor = {}
for method, impl of By
  do (method, impl) ->
    waitFor[method] = (args...) ->
      driver.wait ->
        result = impl.call(By, args...)
        driver.isElementPresent result

# add some convenience methods on the driver
_.merge driver, {
  By, waitFor
}

module.exports = driver
