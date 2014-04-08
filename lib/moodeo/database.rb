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

    def delete_user(uid)
      @sqlite.execute("DELETE FROM users WHERE id = ?", uid)
    end

    #SESSION METHODS
    def create_session(uid)
      session = Session.new(uid)
      @sqlite.execute("INSERT INTO sessions (user_id) VALUES (?);", uid)

      # This is needed so other code can access the id of the user we just created
      session.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      # Return a Session object, just like in the old method
      session
    end

    def get_session(sid)
      # Pro Tip: Always try SQL statements in the terminal first
      rows = @sqlite.execute("SELECT * FROM sessions WHERE id = ?", sid)

      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        return nil
      else
        # Create a convenient Session object based on the data given to us by SQLite
        session = Session.new(data[1])
        session.id = data[0]
        session
      end
    end

    def show_all_sessions
      result = @sqlite.execute("SELECT * FROM sessions")

      # Here we convert our array of **data arrays** into an array of convenient Session objects.
      # Due to Ruby's implicit returns, the new array gets returned.
      result.map do |row|
        sessions = Session.new(row[1])
        sessions.id = row[0]
        sessions
      end
    end

    def delete_session(sid)
      @sqlite.execute("DELETE FROM sessions WHERE id = ?", sid)
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
        # Create a convenient FriendRequest object based on the data given to us by SQLite
        friend_request = FriendRequest.new(data[1], data[2], data[3])
        friend_request.id = data[0]
        friend_request
      end
    end

    def get_all_friend_requests_by_user_id(user_id)
      rows = @sqlite.execute("SELECT * FROM friend_requests WHERE target_id = ?;", user_id)
      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      if rows == nil
        return []
      else
        hey = rows.map do |row|
          friend_request = FriendRequest.new(row[1], row[2], row[3])
          friend_request.id = row[0]
          friend_request
        end
        hey.to_a
      end
    end

    def show_all_friend_requests
      result = @sqlite.execute("SELECT * FROM friend_requests")

      # Here we convert our array of **data arrays** into an array of convenient FriendRequest objects.
      # Due to Ruby's implicit returns, the new array gets returned.
      result.map do |row|
        friend_request = FriendRequest.new(row[1], row[2], row[3])
        friend_request.id = row[0]
        friend_request
      end
    end

    def delete_friend_request(fr_id)
      @sqlite.execute("DELETE FROM friend_requests WHERE id = ?", fr_id)
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

    def get_friendship(fid)
      rows = @sqlite.execute("SELECT * FROM friendships WHERE id = ?;", fid)
      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        return nil
      else
        # Create a convenient Friendship object based on the data given to us by SQLite
        friendship = Friendship.new(data[1], data[2])
        friendship.id = data[0]
        friendship
      end
    end

    def show_all_friendships
      result = @sqlite.execute("SELECT * FROM friendships")

      # Here we convert our array of **data arrays** into an array of convenient Friendship objects.
      # Due to Ruby's implicit returns, the new array gets returned.
      result.map do |row|
        friendship = Friendship.new(row[1], row[2])
        friendship.id = row[0]
        friendship
      end
    end

    def delete_friendship(fid)
      @sqlite.execute("DELETE FROM friendships WHERE id = ?", fid)
    end

    #VIDEO METHODS
    def create_video(name, genre, url)
      video = Video.new(name, genre, url)
      @sqlite.execute("INSERT INTO videos (name, genre, url) VALUES (?,?,?);", name, genre, url)

     # This is needed so other code can access the id of the user we just created
      video.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      # Return a Video object, just like in the old method
      video
    end

    def get_video(vid)
      rows = @sqlite.execute("SELECT * FROM videos WHERE id = ?;", vid)
      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        return nil
      else
        # Create a convenient Video object based on the data given to us by SQLite
        video = Video.new(data[1], data[2], data[3])
        video.id = data[0]
        video
      end
    end

    def show_all_videos
      result = @sqlite.execute("SELECT * FROM videos")

      # Here we convert our array of **data arrays** into an array of convenient Video objects.
      # Due to Ruby's implicit returns, the new array gets returned.
      result.map do |row|
        video = Video.new(row[1], row[2], row[3])
        video.id = row[0]
        video
      end
    end

    def delete_video(vid)
      @sqlite.execute("DELETE FROM videos WHERE id = ?", vid)
    end

    #VIDEO REQUEST METHODS
    def video_request(inviter_id, invitee_id, status)
      video_request = InviteRequest.new(inviter_id, invitee_id, status)
      # binding.pry
      @sqlite.execute("INSERT INTO video_requests(source_id, target_id, status) VALUES (?,?,?);", inviter_id, invitee_id, status)

      video_request.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      video_request
      # binding.pry
    end

    def get_video_request(vid)
      rows = @sqlite.execute("SELECT * FROM video_requests WHERE id = ?;", vid)
      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        # binding.pry
        return nil
      else
        # Create a convenient VideoRequest object based on the data given to us by SQLite
        video_request = InviteRequest.new(data[1], data[2], data[3])
        video_request.id = data[0]
        video_request
      end
    end

    def show_all_video_requests
      result = @sqlite.execute("SELECT * FROM video_requests")

      # Here we convert our array of **data arrays** into an array of convenient VideoRequests objects.
      # Due to Ruby's implicit returns, the new array gets returned.
      result.map do |row|
        video_request = InviteRequest.new(row[1], row[2], row[3])
        video_request.id = row[0]
        video_request
      end
    end

    def delete_video_request(vr_id)
      @sqlite.execute("DELETE FROM video_requests WHERE id = ?", vr_id)
    end

    #VIDEO SESSION METHODS
    def create_video_session (user1_id, user2_id, opentok_id, token)
      video_session = VideoSession.new(user1_id, user2_id, opentok_id, token)
      # binding.pry
      @sqlite.execute("INSERT INTO video_sessions (user_source_id, user_target_id, opentok_id, tokbox_token) VALUES (?,?,?,?);", user1_id, user2_id, opentok_id, token)
      video_session.id = @sqlite.execute("SELECT last_insert_rowid()")[0][0]

      video_session
    end

    def get_video_session(vs_id)
      rows = @sqlite.execute("SELECT * FROM video_sessions WHERE id = ?;", vs_id)
      # Since we are selecting by id, and ids are UNIQUE, we can assume only ONE row is returned
      data = rows.first
      if data == nil
        # binding.pry
        return nil
      else
        # Create a convenient VideoSession object based on the data given to us by SQLite
        video_session = VideoSession.new(data[1], data[2], data[3], data[4])
        video_session.id = data[0]
        video_session
      end
    end

    def show_all_video_sessions
      result = @sqlite.execute("SELECT * FROM video_sessions")

      # Here we convert our array of **data arrays** into an array of convenient VideoSession objects.
      # Due to Ruby's implicit returns, the new array gets returned.
      result.map do |row|
        video_session = VideoSession.new(row[1], row[2], row[3], row[4])
        video_session.id = row[0]
        video_session
      end
    end

    def delete_video_session(vs_id)
      @sqlite.execute("DELETE FROM video_sessions WHERE id = ?", vs_id)
    end

    def clear_all_records
     @sqlite.execute("DELETE FROM users")
     @sqlite.execute("DELETE FROM friendships")
     @sqlite.execute("DELETE FROM sessions")
     @sqlite.execute("DELETE FROM friend_requests")
     @sqlite.execute("DELETE FROM videos")
     @sqlite.execute("DELETE FROM video_sessions")
     @sqlite.execute("DELETE FROM video_requests")
    end
	end
end


#########################################
#             TO-DO METHODS             #
#########################################

# Update user
# Update video
# ?

