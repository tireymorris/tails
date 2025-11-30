require_relative 'config/environment'

namespace :db do
  desc 'Run migrations'
  task :migrate do
    ActiveRecord::MigrationContext.new('db/migrate').migrate
    puts 'Migrations complete'
  end

  desc 'Rollback the last migration'
  task :rollback do
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
  task reset: %i[drop migrate]

  desc 'Seed the database'
  task :seed do
    require_relative 'db/seeds'
    puts 'Database seeded'
  end
end
