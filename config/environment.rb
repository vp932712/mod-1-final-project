require 'bundler'
require_relative './secrets.rb'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
# binding.pry
require_all 'app'
