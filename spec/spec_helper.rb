require 'bundler/setup'
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require_relative '../config/environment'

ActiveRecord::MigrationContext.new('db/migrate').migrate

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
