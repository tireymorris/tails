require 'bundler/setup'
require 'dotenv/load'
require 'logger'

ENV['RACK_ENV'] ||= 'development'

$stdout.sync = true
$stderr.sync = true

require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'active_model'
require 'active_model/secure_password'
require 'bcrypt'

AppLogger = Logger.new($stdout)
AppLogger.level = ENV['RACK_ENV'] == 'production' ? Logger::INFO : Logger::DEBUG
AppLogger.formatter = proc do |severity, datetime, _progname, msg|
  "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/#{ENV['RACK_ENV']}.sqlite3"
)

Dir[File.join(__dir__, '../app/models/**/*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '../app/helpers/**/*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '../app/services/**/*.rb')].sort.each { |f| require f }
Dir[File.join(__dir__, '../lib/**/*.rb')].sort.each { |f| require f }

require_relative 'rack_attack'
require_relative '../app/app'
