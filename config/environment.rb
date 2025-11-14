require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'] || 'development')

require 'active_record'
require 'active_support'
require 'active_support/core_ext'
require 'sorcery'
require 'jwt'

ENV['RACK_ENV'] ||= 'development'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/#{ENV['RACK_ENV']}.sqlite3"
)

Dir[File.join(__dir__, '../app/models/**/*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '../app/helpers/**/*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '../lib/**/*.rb')].sort.each { |f| require f }

require_relative '../app/app'
