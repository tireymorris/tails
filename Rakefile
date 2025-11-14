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
    ActiveRecord::MigrationContext.new('db/migrate', ActiveRecord::SchemaMigration).migrate
    puts 'Migrations complete'
  end

  desc 'Rollback the last migration'
  task :rollback do
    ActiveRecord::MigrationContext.new('db/migrate', ActiveRecord::SchemaMigration).rollback
    puts 'Rolled back last migration'
  end

  desc 'Drop the database'
  task :drop do
    File.delete('db/development.sqlite3') if File.exist?('db/development.sqlite3')
    puts 'Database dropped'
  end

  desc 'Reset the database'
  task reset: %i[drop create migrate]

  desc 'Seed the database'
  task :seed do
    require_relative 'db/seeds'
    puts 'Database seeded'
  end
end
