require './spec/spec_helper'

# describe 'user' do
#   it "initializes a user with a name,username,and password" do

#     user = User.new("jon","123","abc")
#     expect(user.name).to eq('jon')
#   end

  describe "Persistence" do
    before do
      binding.pry
      @user1 = @db.create_user('Jose', 'joser1', '123')
      @user2 = @db.create_user('Drew', 'drewv33', 'abc')
    end

    it "has persistence for users" do
      # This should save to the db
      # Here we create a **new** db instance. It should have access
      # to the users we created with the original db instance.
      sql_db = Moodeo::DB.new('moodeo.db')
      expect(sql_db.show_all_users.count).to eq 2

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
      name = sql_db.get_user(@user1.id).map(&:name)
      username = sql_db.get_user(@user1.id).map(&:username)
      password = sql_db.get_user(@user1.id).map(&:password)

      expect(name).to include(@user1.name)
      expect(username).to include(@user1.username)
      expect(password).to include(@user1.password)

      # get user by username
      user_id = sql_db.get_user_by_username(@user1.username).map(&:id)
      user_name = sql_db.get_user_by_username(@user1.username).map(&:name)
      user_password = sql_db.get_user_by_username(@user1.username).map(&:password)

      expect(user_id).to include(@user1.id)
      expect(user_name).to include(@user1.name)
      expect(user_password).to include(@user1.password)
    end
  end
end
