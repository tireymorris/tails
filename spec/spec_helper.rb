require 'bundler/setup'
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../config/environment'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/test.sqlite3'
)

ActiveRecord::MigrationContext.new('db/migrate').migrate

require_relative '../app/app'

module RSpecMixin
  include Rack::Test::Methods
  def app
    App
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before(:suite) do
    ActiveRecord::Base.connection.execute('DELETE FROM users')
  end

  config.before(:each) do
    ActiveRecord::Base.connection.execute('DELETE FROM users') if User.table_exists?
  end
end
