fs = require 'fs'
path = require 'path'

module.exports.loadModules = (modulesPath, ignore=[], callback=false) ->

  modules = {}
  for fileName in fs.readdirSync modulesPath

    # removes extension from filename to use as base for all contained routes
    extension = path.extname fileName
    name = path.basename fileName, extension

    if /^[a-zA-Z]+$/.test(name) and name not in ignore
      # generate the path for the router file and requires it
      
      loadedModule = require path.join(modulesPath, name)

      modules[name] = if callback then callback(loadedModule) else loadedModule
 
  return modules
    
