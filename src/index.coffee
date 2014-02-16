db = require 'mysqlp'
util = require './lib/util'
model = require './lib/model'


module.exports.config = (config) ->
  db.config config.databases

  @models = util.loadModules config.modelsPath, [], (loadedModule) ->

    obj = Object.create model(db)
    if typeof loadedModule is 'function'
      loadedModule obj
      return obj

  return @models


