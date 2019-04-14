debug = require('debug') 'require-ancestor'
# R = require 'ramda'
path = require 'path'
fs = require 'fs'
APP_PATH = null

callStack = (cnt = 1)->
  capture = {}
  Error.captureStackTrace capture
  {stack} = capture
  stacks = stack.toString().split(/\r\n|\n/)
  last = 3 + cnt
  stacks = stacks[3...last]
  # We want our caller's frame. It's index into |stack| depends on the
  # browser and browser version, so we need to search for the second frame:
  toInfo = (line)->
    frameRE = /([^\(]+?([^\\\/]+)):(\d+):(?:\d+)[^\d]*$/
    match = frameRE.exec(line)
    # console.log 'toInfo', match
    return
      filepath: match[1]
      file: match[2]
      line: match[3]
  debug 'stack', stacks
  stack_info = stacks.map toInfo

tryRequire = (full_id)->
  try
    debug 'tryRequire', full_id
    return require full_id
  catch error
    if error.message.includes "Cannot find module"
      return null
    throw error
requireAncestor = (module_id)->
  stack = callStack(1)
  debug 'stack', stack
  {filepath} = stack[0]
  chk_dir = path.dirname filepath

  while true
    mod = tryRequire path.join chk_dir, module_id
    return mod if mod?
    next_dir = path.dirname chk_dir
    if next_dir is chk_dir
      throw new Error "Cannot find module '#{module_id}'"
    chk_dir = next_dir


module.exports = requireAncestor
