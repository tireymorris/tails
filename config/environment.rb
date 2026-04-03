# frozen_string_literal: true

Encoding.default_external = Encoding::UTF_8

require 'securerandom'

require 'bundler/setup'
require 'dotenv/load'
require 'logger'

ENV['RACK_ENV'] ||= 'development'

$stdout.sync = true
$stderr.sync = true

require 'active_model'
require 'active_model/secure_password'
require 'active_record'
require 'active_support'
require 'active_support/core_ext'
require 'bcrypt'

AppLogger = Logger.new($stdout)
AppLogger.level = ENV['RACK_ENV'] == 'production' ? Logger::INFO : Logger::DEBUG
AppLogger.formatter =
  proc do |severity, datetime, _progname, msg|
    "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
  end

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: "db/#{ENV.fetch('RACK_ENV', nil)}.sqlite3")

SESSION_OPTIONS = {
  secret: ENV.fetch('SESSION_SECRET', SecureRandom.hex(64)),
  key: 'tails.session',
  cookie_options: {
    path: '/',
    httponly: true,
    secure: ENV['RACK_ENV'] == 'production',
    same_site: :lax,
    max_age: 14 * 24 * 60 * 60
  }
}.freeze

require_relative '../app/helpers/current_user'
require_relative '../app/models/user'

require_relative '../app/app'
require_relative 'rack_attack'
