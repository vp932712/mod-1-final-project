require 'bundler'
require_relative './secrets.rb'

Bundler.require
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

require_all 'app'
