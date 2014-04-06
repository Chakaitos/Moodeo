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
			# @users = {}
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

    def get_user(uid)
      # Pro Tip: Always try SQL statements in the terminal first
      rows = @sqlite.execute("SELECT * FROM users WHERE id = ?", uid)

      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        return nil
      else

      # Create a convenient User object based on the data given to us by SQLite
      user = User.new(data[1], data[2], data[3])
      user.id = data[0]
      user
      # OLD METHOD
      # @users[uid]
    end
    end

    def get_user_by_username(username)
      rows = @sqlite.execute("SELECT * FROM users WHERE username = ?", username)

      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        return nil
      else

        # Create a convenient User object based on the data given to us by SQLite
        user = User.new(data[1], data[2], data[3])
        user.id = data[0]
        user
        # OLD METHOD
        # @users[uid]
      end
    end

    def get_user_by_session(sid)
      rows = @sqlite.execute("SELECT * FROM sessions WHERE id = ?", sid)

      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first

        # Create a convenient User object based on the data given to us by SQLite
        session = Session.new(data[1])
        session.id = data[0]
        session
        # OLD METHOD
        # @users[uid]
    end

    def show_all_users
      result = @sqlite.execute("SELECT * FROM users")

      # Here we convert our array of **data arrays** into an array of convenient User objects.
      # Due to Ruby's implicit returns, the new array gets returned.
      result.map do |row|
        # `row` is an array of data. Example: [1, 'Alice', 'abc123']
        # You can discover the column order by looking at your table schema
        # For example:
        #   $ sqlite3 rps_test.db
        #   sqlite> .schema users
        #
        user = User.new(row[1], row[2], row[3])
        user.id = row[0]
        user
      end
    end

    def clear_all_records
     @sqlite.execute("DELETE FROM users")
     @sqlite.execute("DELETE FROM friendships")
     @sqlite.execute("DELETE FROM sessions")
    end

    def sign_in(username, password)

    end

    #SESSION METHODS
    def create_session(uid)
      session = Session.new(uid)
      @sqlite.execute("INSERT INTO sessions (user_id) VALUES (?);", uid)

      # This is needed so other code can access the id of the user we just created
      session.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      # Return a User object, just like in the old method
      session

      # OLD METHOD
      # session = Session.new(uid)
      # session
    end


	end
end
