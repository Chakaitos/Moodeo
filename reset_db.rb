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
sqlite.execute %q{DROP TABLE IF EXISTS sessions}
sqlite.execute %q{DROP TABLE IF EXISTS friend_requests}
sqlite.execute %q{DROP TABLE IF EXISTS videos}
sqlite.execute %q{DROP TABLE IF EXISTS video_requests}
sqlite.execute %q{DROP TABLE IF EXISTS video_sessions}

puts "Creating tables..."
sqlite.execute %q{
  CREATE TABLE users (
    id          INTEGER 			PRIMARY KEY,
    name        VARCHAR(30)   NOT NULL,
    username		VARCHAR(20)		NOT NULL,
    password    VARCHAR(50)   NOT NULL
  );
}
sqlite.execute %q{
  CREATE TABLE friendships (
    id          			INTEGER 			PRIMARY KEY,
    user_source_id    INT           NOT NULL,
    user_target_id		INT		        NOT NULL,
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
sqlite.execute %q{
  CREATE TABLE friend_requests (
    id                INTEGER       PRIMARY KEY,
    source_id           INT           NOT NULL,
    target_id           INT           NOT NULL,
    status              TEXT          NOT NULL,
    FOREIGN KEY(source_id) REFERENCES users(id),
    FOREIGN KEY(target_id) REFERENCES users(id)
  );
}
sqlite.execute %q{
  CREATE TABLE videos (
    id          INTEGER       PRIMARY KEY,
    name        TEXT          NOT NULL,
    genre       TEXT          NOT NULL,
    url         TEXT          NOT NULL
  );
}

# Grab videos from youtube
# require ''

sqlite.execute %q{
  CREATE TABLE video_requests (
    id                INTEGER       PRIMARY KEY,
    source_id           INT           NOT NULL,
    target_id           INT           NOT NULL,
    status              TEXT          NOT NULL,
    FOREIGN KEY(source_id) REFERENCES users(id),
    FOREIGN KEY(target_id) REFERENCES users(id)
  );
}

sqlite.execute %q{
  CREATE TABLE video_sessions (
    id                INTEGER       PRIMARY KEY,
    user_source_id    INT           NOT NULL,
    user_target_id    INT           NOT NULL,
    FOREIGN KEY(user_source_id) REFERENCES users(id),
    FOREIGN KEY(user_target_id) REFERENCES users(id)
  );
}

puts "Database Schema:\n\n"
puts `echo .schema | sqlite3 #{db_name}`
