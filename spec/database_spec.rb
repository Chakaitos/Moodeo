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
      expect(sql_db.show_all_users.count).to eq 3

      # show all users
      ids = sql_db.show_all_users.map(&:id)
      names = sql_db.show_all_users.map(&:name)
      usernames = sql_db.show_all_users.map(&:username)
      passwords = sql_db.show_all_users.map(&:password)

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

    it "has persistence for friend_requests" do
      sql_db = Moodeo::DB.new('moodeo.db')
      friend_request1 = sql_db.friend_request(@user1.id, @user2.id, 'pending')
      friend_request2 = sql_db.friend_request(@user3.id, @user2.id, 'pending')
      expect(sql_db.show_all_friend_requests.count).to eq 2

      # show all friend requests
      ids = sql_db.show_all_friend_requests.map(&:id)
      inviter_ids = sql_db.show_all_friend_requests.map(&:inviter_id)
      invitee_ids = sql_db.show_all_friend_requests.map(&:invitee_id)
      statuses = sql_db.show_all_friend_requests.map(&:status)

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
  end
end
