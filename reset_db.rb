# USAGE:
# $ bundle exec ruby reset_db.rb
#
# You can also specify a database:
# $ bundle exec ruby reset_db.rb my-app.db
require "sqlite3"

db_name = ARGV[0] || 'moodeo.db'
sqlite = SQLite3::Database.new(db_name)

puts "Destroying #{db_name}..."
sqlite.execute %q{DROP TABLE IF EXISTS users}
sqlite.execute %q{DROP TABLE IF EXISTS friendships}

puts "Creating tables..."
sqlite.execute %q{
  CREATE TABLE users (
    id          INTEGER 			PRIMARY KEY,
    name        VARCHAR(30)   NOT NULL,
    username		VARCHAR(20)		NOT NULL,
    password    VARCHAR(20)   NOT NULL
  );
}
sqlite.execute %q{
  CREATE TABLE friendships (
    id          			INTEGER 			PRIMARY KEY,
    user_source_id    INT           NOT NULL,
    user_target_id		INT		         NOT NULL,
    FOREIGN KEY(user_source_id) REFERENCES users(id),
    FOREIGN KEY(user_target_id) REFERENCES users(id)
  );
}
sqlite.execute %q{
  CREATE TABLE sessions (
    id                INTEGER       PRIMARY KEY,
    user_id           INT           NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
  );
}

puts "Database Schema:\n\n"
puts `echo .schema | sqlite3 #{db_name}`
