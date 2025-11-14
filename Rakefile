require_relative 'config/environment'
require 'active_record'

namespace :db do
  desc 'Create the database'
  task :create do
    FileUtils.mkdir_p('db')
    puts 'Database directory created'
  end

  desc 'Run migrations'
  task :migrate do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: "db/#{ENV['RACK_ENV'] || 'development'}.sqlite3"
    )
    ActiveRecord::MigrationContext.new('db/migrate').migrate
    puts 'Migrations complete'
  end

  desc 'Rollback the last migration'
  task :rollback do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: "db/#{ENV['RACK_ENV'] || 'development'}.sqlite3"
    )
    ActiveRecord::MigrationContext.new('db/migrate').rollback
    puts 'Rolled back last migration'
  end

  desc 'Drop the database'
  task :drop do
    db_file = "db/#{ENV['RACK_ENV'] || 'development'}.sqlite3"
    File.delete(db_file) if File.exist?(db_file)
    puts 'Database dropped'
  end

  desc 'Reset the database'
  task reset: %i[drop create migrate]

  desc 'Seed the database'
  task :seed do
    require_relative 'db/seeds'
    puts 'Database seeded'
  end

  namespace :schema do
    desc 'Create a db/schema.rb file'
    task :dump do
      require 'active_record/schema_dumper'
      filename = 'db/schema.rb'
      File.open(filename, 'w:utf-8') do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end
