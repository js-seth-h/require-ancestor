Module = require 'module'
path = require 'path'

oldResolveFilename = Module._resolveFilename
Module._resolveFilename = (request, parentModule, isMain, options)->
  if request.startsWith '^/'
    dir = path.dirname parentModule.filename
    return getAncestor dir, request, options
  else
    # console.log '_resolveFilename', request, parentModule, isMain, options
    return oldResolveFilename request, parentModule, isMain, options
    # console.log 'ret =', ret
    # return ret

getAncestor = (from_dir, request, options)->
  request_sub = request[2..]
  dir = path.dirname from_dir
  while true
    try
      renamed = path.join dir, request_sub
      return require.resolve renamed, options
    catch error
      dir = getUpDir dir

getUpDir = (dir)->
  up_dir = path.dirname dir
  return up_dir if up_dir isnt dir

  err = new Error "Cannot find module '#{request}'"
  err.code = 'MODULE_NOT_FOUND'
  err.requireStack = []
  throw err
