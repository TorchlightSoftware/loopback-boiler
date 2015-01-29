_ = require 'lodash'
{expect} = require 'chai'
async = require 'async'

boiler 'Sample', ->

  dataInsertTest = (done) ->
    test_data =
      foo: 1
      bar: 2

    @api 'post', '/api/stuff', test_data, (resp, body) =>
      @assertStatus(resp, 200)

      @api 'get', '/api/stuff', (resp, body) =>
        @assertStatus(resp, 200)
        expect(body.length).to.eql 1
        @assertSubsetOf(body, [expected])
        done()

  it 'should insert data', dataInsertTest

  it 'should delete data between tests', dataInsertTest
