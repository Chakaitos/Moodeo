module Moodeo

	def self.db
		@__db_instance ||= DB.new(@app_db_name)
	end

	def self.db_name=(db_name)
		@app_db_name = db_name
	end

	class DB
		attr_accessor :users
		def initialize(db_name)
      raise StandardError.new("Please set Moodeo.db_name") if db_name.nil?

      # This creates a connection to our database file
      @sqlite = SQLite3::Database.new(db_name)
			@users = {}
		end

		# Create methods - CRUD
		def create_user(name, username, password)
			user = User.new(name, username, password)
      @sqlite.execute("INSERT INTO users (name, username, password) VALUES (?,?,?);", name, username, password)

      # This is needed so other code can access the id of the user we just created
      user.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      # Return a User object, just like in the old method
      user

      # OLD METHOD
			# user = User.new(name, password)
			# @users[user.id.to_i] = user
			# user
		end
	end
end