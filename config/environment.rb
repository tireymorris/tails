require 'bundler/setup'

ENV['RACK_ENV'] ||= 'development'

require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'active_model'
require 'active_model/secure_password'
require 'jwt'
require 'bcrypt'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/#{ENV['RACK_ENV']}.sqlite3"
)

Dir[File.join(__dir__, '../app/models/**/*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '../app/helpers/**/*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '../lib/**/*.rb')].sort.each { |f| require f }

require_relative '../app/app'
