process.env.DEBUG = "*"
debug = require('debug') 'tester'
# require 'gogo'
m = require('./index') 'index'
debug 'index=', m
try
  m = require('./index') 'not_exist_module'
catch error
  console.error error

try
  m = require('./index') 'crashed'
catch error
  console.error error
