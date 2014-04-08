require './spec/spec_helper.rb'

# describe 'user' do
#   it "initializes a user with a name,username,and password" do

#     user = User.new("jon","123","abc")
#     expect(user.name).to eq('jon')
#   end
describe 'Database' do

  before do
    @db = Moodeo.db
  end

  context "for non persistence testing" do
    before do
      @user1 = @db.create_user("Jose", "joserb9", "123abc")
      @user2 = @db.create_user("Chris", "chrisp12", "12345")
      @user3 = @db.create_user("Drew", "drewv", "abc123")
      @video = @db.create_video("Drew eating BBQ", "Funny", "www.youtube.com/drew-eating-bbq")
    end

    describe "#create_user" do
      it "should create a new user" do
        result = @db.create_user("Wendy", "gwendolly", "abc123")

        expect(result.name).to eq("Wendy")
        expect(result.username).to eq("gwendolly")
        expect(result.password).to eq("abc123")
      end
    end

    describe "#delete_user" do
      it "should delete a user based on its id" do
        result = @db.show_all_users
        expect(result.count).to eq(3)

        @db.delete_user(@user1.id)
        result = @db.show_all_users

        expect(result.count).to eq(2)
      end
    end

    describe "#create_session" do
      it "should create a new session for a user" do
        result = @db.create_session(@user1.id)

        expect(result.id).to eq(@user1.id)
      end
    end

    describe "#delete_session" do
      it "should delete a session based on its id" do
        session1 = @db.create_session(@user1.id)
        session2 = @db.create_session(@user2.id)
        result = @db.show_all_sessions
        
        expect(result.count).to eq(2)

        @db.delete_session(session2.id)
        result = @db.show_all_sessions

        expect(result.count).to eq(1)
      end
    end

    describe "#friend_request" do
      it "should create a new friend request" do
        result = @db.friend_request(@user1.id, @user2.id, "pending")

        expect(result.inviter_id).to eq(@user1.id)
        expect(result.invitee_id).to eq(@user2.id)
        expect(result.status).to eq("pending")
      end
    end

    describe "#delete_friend_request" do
      it "should delete a friend request based on its id" do
        friend_request1 = @db.friend_request(@user1.id, @user2.id, "pending")
        friend_request2 = @db.friend_request(@user3.id, @user2.id, "pending")
        result = @db.show_all_friend_requests

        expect(result.count).to eq(2)

        @db.delete_friend_request(friend_request2.id)
        result = @db.show_all_friend_requests

        expect(result.count).to eq(1)
      end
    end

    describe "#create_friendship" do
      it "should create a new friendship" do
        result = @db.create_friendship(@user1.id, @user2.id)

        expect(result.inviter_id).to eq(@user1.id)
        expect(result.invitee_id).to eq(@user2.id)
      end
    end

    describe "#delete_friendship" do
      it "should delete a friendship based on its id" do
        friendship1 = @db.create_friendship(@user1.id, @user2.id)
        friendship2 = @db.create_friendship(@user3.id, @user2.id)
        result = @db.show_all_friendships

        expect(result.count).to eq(2)

        @db.delete_friendship(friendship2.id)
        result = @db.show_all_friendships

        expect(result.count).to eq(1)
      end
    end

    describe "#create_video" do
      it "should create a new video" do
        expect(@video.name).to eq('Drew eating BBQ')
        expect(@video.genre).to eq('Funny')
        expect(@video.url).to eq('www.youtube.com/drew-eating-bbq')
      end
    end

    describe "#delete_video" do
      it "should delete a video based on its id" do
        video1 = @db.create_video('Drew eating BBQ', 'Funny', 'www.youtube.com/drew-eating-bbq')
        video2 = @db.create_video('Surfing tournament', 'Sports', 'www.youtube.com/hawaii-surfing')
        result = @db.show_all_videos

        expect(result.count).to eq(3)

        @db.delete_video(video1.id)
        result = @db.show_all_videos

        expect(result.count).to eq(2)
      end
    end

    describe "#video_request" do
      it "should create a new video request" do
        result = @db.friend_request(@user1.id, @user2.id, "pending")

        expect(result.inviter_id).to eq(@user1.id)
        expect(result.invitee_id).to eq(@user2.id)
        expect(result.status).to eq("pending")
      end
    end

    describe "#delete_video_request" do
      it "should delete a video request based on its id" do
        video_request1 = @db.video_request(@user1.id, @user2.id, "pending")
        video_request2 = @db.video_request(@user3.id, @user2.id, "pending")
        result = @db.show_all_video_requests

        expect(result.count).to eq(2)

        @db.delete_video_request(video_request2.id)
        result = @db.show_all_video_requests

        expect(result.count).to eq(1)
      end
    end

    describe "#video_session" do
      it "should create a new video session" do
        result = @db.create_video_session(@user1.id, @user2.id, "someopentokid", "sometokenid")

        expect(result.user1_id).to eq(@user1.id)
        expect(result.user2_id).to eq(@user2.id)
        expect(result.opentok_id).to eq("someopentokid")
        expect(result.token).to eq("sometokenid")
      end
    end

    describe "#delete_video_session" do
      it "should delete a video session based on its id" do
        video_session1 = @db.create_video_session(@user1.id, @user2.id, "someopentokid", "sometokenid")
        video_session2 = @db.create_video_session(@user3.id, @user2.id, "someopentokid1", "sometokenid1")
        result = @db.show_all_video_sessions

        expect(result.count).to eq(2)

        @db.delete_video_session(video_session1.id)
        result = @db.show_all_video_sessions

        expect(result.count).to eq(1)
      end
    end
  end

  describe "Persistence" do
    before do
      @user1 = @db.create_user('Jose', 'joser123', '123')
      @user2 = @db.create_user('Drew', 'drewv33', 'abc')
      @user3 = @db.create_user('Chris', 'chrisp27', 'abc123')
    end

    it "has persistence for users" do
      # This should save to the db
      # Here we create a **new** db instance. It should have access
      # to the users we created with the original db instance.
      sql_db = Moodeo::DB.new('moodeo.db')

      # show all users
      ids = sql_db.show_all_users.map(&:id)
      names = sql_db.show_all_users.map(&:name)
      usernames = sql_db.show_all_users.map(&:username)
      passwords = sql_db.show_all_users.map(&:password)

      expect(sql_db.show_all_users.count).to eq 3
      expect(ids).to include(@user1.id, @user2.id)
      expect(names).to include(@user1.name, @user2.name)
      expect(usernames).to include(@user1.username, @user2.username)
      expect(passwords).to include(@user1.password, @user2.password)

      # get individual user
      name = sql_db.get_user(@user1.id).instance_eval(&:name)
      username = sql_db.get_user(@user1.id).instance_eval(&:username)
      password = sql_db.get_user(@user1.id).instance_eval(&:password)

      expect(name).to include(@user1.name)
      expect(username).to include(@user1.username)
      expect(password).to include(@user1.password)

      # get user by username
      # binding.pry
      user_id = sql_db.get_user_by_username(@user1.username).instance_eval(&:id)
      user_name = sql_db.get_user_by_username(@user1.username).instance_eval(&:name)
      user_password = sql_db.get_user_by_username(@user1.username).instance_eval(&:password)

      expect(user_id).to eq(@user1.id)
      expect(user_name).to include(@user1.name)
      expect(user_password).to include(@user1.password)
    end

    it "has persistence for friend requests" do
      sql_db = Moodeo::DB.new('moodeo.db')
      friend_request1 = sql_db.friend_request(@user1.id, @user2.id, 'pending')
      friend_request2 = sql_db.friend_request(@user3.id, @user2.id, 'pending')

      # show all friend requests
      ids = sql_db.show_all_friend_requests.map(&:id)
      inviter_ids = sql_db.show_all_friend_requests.map(&:inviter_id)
      invitee_ids = sql_db.show_all_friend_requests.map(&:invitee_id)
      statuses = sql_db.show_all_friend_requests.map(&:status)

      expect(sql_db.show_all_friend_requests.count).to eq 2
      expect(ids).to include(friend_request1.id, friend_request2.id)
      expect(inviter_ids).to include(friend_request1.inviter_id, friend_request2.inviter_id)
      expect(invitee_ids).to include(friend_request1.invitee_id, friend_request2.invitee_id)
      expect(statuses).to include('pending', 'pending')

      # get individual friend request
      inviter_id = sql_db.get_friend_request(friend_request1.id).instance_eval(&:inviter_id)
      invitee_id = sql_db.get_friend_request(friend_request1.id).instance_eval(&:invitee_id)
      status = sql_db.get_friend_request(friend_request1.id).instance_eval(&:status)

      expect(inviter_id).to eq(friend_request1.inviter_id)
      expect(invitee_id).to eq(friend_request1.invitee_id)
      expect(status).to include(friend_request1.status)
    end

    it "has persistence for sessions" do
      sql_db = Moodeo::DB.new('moodeo.db')
      session1 = sql_db.create_session(@user1.id)
      session2 = sql_db.create_session(@user2.id)

      # show all sessions
      ids = sql_db.show_all_sessions.map(&:id)
      user_ids = sql_db.show_all_sessions.map(&:user_id)

      expect(sql_db.show_all_sessions.count).to eq 2
      expect(ids).to include(session1.id, session2.id)
      expect(user_ids).to include(session1.user_id, session2.user_id)

      # get individual session
      user_id = sql_db.get_session(session1.id).instance_eval(&:user_id)

      expect(user_id).to eq(session1.user_id)
    end

    it "has persistence for friendships" do
      sql_db = Moodeo::DB.new('moodeo.db')
      friendship1 = sql_db.create_friendship(@user1.id, @user2.id)
      friendship2 = sql_db.create_friendship(@user3.id, @user2.id)

      # show all friendships
      ids = sql_db.show_all_friendships.map(&:id)
      user1_ids = sql_db.show_all_friendships.map(&:inviter_id)
      user2_ids = sql_db.show_all_friendships.map(&:invitee_id)

      expect(sql_db.show_all_friendships.count).to eq 2
      expect(ids).to include(friendship1.id, friendship2.id)
      expect(user1_ids).to include(friendship1.inviter_id, friendship2.inviter_id)
      expect(user2_ids).to include(friendship1.invitee_id, friendship2.invitee_id)

      # get individual friendships
      user1_id = sql_db.get_friendship(friendship1.id).instance_eval(&:inviter_id)
      user2_id = sql_db.get_friendship(friendship1.id).instance_eval(&:invitee_id)

      expect(user1_id).to eq(friendship1.inviter_id)
      expect(user2_id).to eq(friendship1.invitee_id)
    end

    it "has persistence for videos" do
      sql_db = Moodeo::DB.new('moodeo.db')
      video1 = sql_db.create_video("Drew eating BBQ", "Funny", "www.youtube.com/drew-eating-bbq")
      video2 = sql_db.create_video("Surfing tournament", "Sports", "www.youtube.com/surfing-tournament")

      # show all videos
      ids = sql_db.show_all_videos.map(&:id)
      names = sql_db.show_all_videos.map(&:name)
      genres = sql_db.show_all_videos.map(&:genre)
      urls = sql_db.show_all_videos.map(&:url)

      expect(sql_db.show_all_videos.count).to eq 2
      expect(ids).to include(video1.id, video2.id)
      expect(names).to include(video1.name, video2.name)
      expect(genres).to include(video1.genre, video2.genre)
      expect(urls).to include(video1.url, video2.url)

      # get individual videos
      name = sql_db.get_video(video1.id).instance_eval(&:name)
      genre = sql_db.get_video(video1.id).instance_eval(&:genre)
      url = sql_db.get_video(video1.id).instance_eval(&:url)

      expect(name).to eq(video1.name)
      expect(genre).to eq(video1.genre)
      expect(url).to include(video1.url)
    end

    it "has persistence for video requests" do
      sql_db = Moodeo::DB.new('moodeo.db')
      video_request1 = sql_db.video_request(@user1.id, @user2.id, 'pending')
      video_request2 = sql_db.video_request(@user3.id, @user2.id, 'pending')

      # show all video requests
      ids = sql_db.show_all_video_requests.map(&:id)
      inviter_ids = sql_db.show_all_video_requests.map(&:inviter_id)
      invitee_ids = sql_db.show_all_video_requests.map(&:invitee_id)
      statuses = sql_db.show_all_video_requests.map(&:status)

      expect(sql_db.show_all_video_requests.count).to eq 2
      expect(ids).to include(video_request1.id, video_request2.id)
      expect(inviter_ids).to include(video_request1.inviter_id, video_request2.inviter_id)
      expect(invitee_ids).to include(video_request1.invitee_id, video_request2.invitee_id)
      expect(statuses).to include('pending', 'pending')

      # get individual video request
      inviter_id = sql_db.get_video_request(video_request1.id).instance_eval(&:inviter_id)
      invitee_id = sql_db.get_video_request(video_request1.id).instance_eval(&:invitee_id)
      status = sql_db.get_video_request(video_request1.id).instance_eval(&:status)

      expect(inviter_id).to eq(video_request1.inviter_id)
      expect(invitee_id).to eq(video_request1.invitee_id)
      expect(status).to include(video_request1.status)
    end

    it "has persistence for video sessions" do
      sql_db = Moodeo::DB.new('moodeo.db')
      # otok_id = "1zKEKDJHF847392JDHF33"
      # token = "3BEKD3487622488FSJDHF33"
      video_session1 = sql_db.create_video_session(@user1.id, @user2.id, "1zKEKDJHF847392JDHF33", "3BEKD3487622488FSJDHF33")
      video_session2 = sql_db.create_video_session(@user3.id, @user2.id, "37372F88FSJDHF33", "55T2D3487622488FSJ")

      # show all video sessions
      ids = sql_db.show_all_video_sessions.map(&:id)
      user1_ids = sql_db.show_all_video_sessions.map(&:user1_id)
      user2_ids = sql_db.show_all_video_sessions.map(&:user2_id)
      opentok_ids = sql_db.show_all_video_sessions.map(&:opentok_id)
      tokens = sql_db.show_all_video_sessions.map(&:token)

      expect(sql_db.show_all_video_sessions.count).to eq 2
      expect(ids).to include(video_session1.id, video_session2.id)
      expect(user1_ids).to include(video_session1.user1_id, video_session2.user1_id)
      expect(user2_ids).to include(video_session1.user2_id, video_session2.user2_id)
      # expect(opentok_ids).to include(video_session1.opentok_id, video_session2.opentok_id)
      # expect(tokens).to include(video_session1.token, video_session2.token)

      # get individual video session
      id = sql_db.get_video_session(video_session1.id).instance_eval(&:id)
      user1_id = sql_db.get_video_session(video_session1.id).instance_eval(&:user1_id)
      user2_id = sql_db.get_video_session(video_session1.id).instance_eval(&:user2_id)
      id_opentok = sql_db.get_video_session(video_session1.id).instance_eval(&:opentok_id)
      token1 = sql_db.get_video_session(video_session1.id).instance_eval(&:token)

      expect(user1_id).to eq(video_session1.user1_id)
      expect(user2_id).to eq(video_session1.user2_id)
      # expect(id_opentok).to include(video_session1.opentok_id)
      # expect(token1).to include(video_session1.token)
    end
  end
end
