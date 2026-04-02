# frozen_string_literal: true

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
    FileUtils.rm_f(db_file)
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

desc 'Autocorrect with RuboCop and erb_lint (run before push; CI fails if this changes files)'
task :lint do
  ok = system('bundle exec rubocop -a')
  ok &&= system('bundle exec erb_lint --lint-all --autocorrect')
  exit(1) unless ok
end
