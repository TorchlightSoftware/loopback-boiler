_ = require 'lodash'
{expect} = require 'chai'

expectPageContains = (page, field, value) ->
  expect(page, "Expected page to contain '#{field}': #{value}\n")
    .to.contain(value)

e2eboiler 'App E2E', ->

  # create sample data
  beforeEach (done) ->
    done()

  # load application root
  beforeEach (done) ->
    @timeout 10000
    @wd.getRoot(done)

  it 'should display default page', (done) ->
    {By} = @wd
    @wd.getPageSource().then (page) =>

      # run tests here
      done()
