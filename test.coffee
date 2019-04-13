process.env.DEBUG = "*"
debug = require('debug') 'tester'
# require 'gogo'
m = require('./index') 'index'
debug 'index=', m
m = require('./index') 'not_exist_module'
