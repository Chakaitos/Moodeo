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

    #USER METHODS
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
        session.user_id
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

    def get_session(sid)
      # Pro Tip: Always try SQL statements in the terminal first
      rows = @sqlite.execute("SELECT * FROM sessions WHERE id = ?", sid)

      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        return nil
      else
        # Create a convenient User object based on the data given to us by SQLite
        session = Session.new(data[1])
        session.id = data[0]
        session
        # OLD METHOD
        # @users[uid]
      end
    end

    #FRIEND REQUESTS METHODS
    def friend_request(inviter_id, invitee_id, status)
      friend_request = FriendRequest.new(inviter_id, invitee_id, status)
      @sqlite.execute("INSERT INTO friend_requests (source_id, target_id, status) VALUES (?,?,?);", inviter_id, invitee_id, status)

      # This is needed so other code can access the id of the user we just created
      friend_request.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      # Return a FriendRequest object, just like in the old method
      friend_request
    end

    def get_friend_request(invite_id)
      rows = @sqlite.execute("SELECT * FROM friend_requests WHERE id = ?;", invite_id)
      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        return nil
      else
        # Create a convenient User object based on the data given to us by SQLite
        friend_request = FriendRequest.new(data[1], data[2], data[3])
        friend_request.id = data[0]
        friend_request
      end
    end

    #FRIENDSHIP METHODS 
    def create_friendship(user1_id, user2_id)
      friendship = Friendship.new(user1_id, user2_id)
      @sqlite.execute("INSERT INTO friendships (user_source_id, user_target_id) VALUES (?,?);", user1_id, user2_id)
      
      # This is needed so other code can access the id of the user we just created
      friendship.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      # Return a FriendRequest object, just like in the old method
      friendship
    end

    #VIDEO METHODS
    def create_video(name, genre, url)
      video = Video.new(name, genre, url)
      @sqlite.execute("INSERT INTO videos (name, genre, url) VALUES (?,?,?);", name, genre, url)
     
     # This is needed so other code can access the id of the user we just created
      video.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      # Return a FriendRequest object, just like in the old method
      video
    end

    def clear_all_records
     @sqlite.execute("DELETE FROM users")
     @sqlite.execute("DELETE FROM friendships")
     @sqlite.execute("DELETE FROM sessions")
     @sqlite.execute("DELETE FROM friend_requests")
     @sqlite.execute("DELETE FROM videos")
    end

    def video_request(inviter_id,invitee_id,status)
      video_request = InviteRequest.new(inviter_id,invitee_id,status)
      # binding.pry
      @sqlite.execute("INSERT INTO video_requests(source_id, target_id, status) VALUES (?,?,?);", inviter_id, invitee_id, status)


      video_request.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      video_request

    end

    def get_video_request(invite_id)
      rows = @sqlite.execute("SELECT * FROM video_requests WHERE id = ?;", invite_id)
      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        return nil
      else
        # Create a convenient User object based on the data given to us by SQLite
        video_request = InviteRequest.new(data[1], data[2], data[3])
        video_request.id = data[0]
        video_request
      end

    end

    def create_video_session (user1_id, user2_id) #CREATE VideoSession class
      @sqlite.execute("INSERT INTO video_sessions (user_source_id, user_target_id) VALUES (?,?);", user1_id, user2_id)
      data = @sqlite.execute("SELECT last_insert_rowid()")[0][0]
      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      if data == nil
        return nil
      else
        # Create a convenient User object based on the data given to us by SQLite
        # user = User.new(data[1], data[2], data[3])
        # user.id = data[0]
        # user
        # OLD METHOD
        # @users[uid]
        data[0]
      end
    end
	end
end
