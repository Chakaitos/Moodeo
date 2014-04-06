require './spec/spec_helper.rb'

describe Moodeo::SignIn do
   before do
      @db = Moodeo.db
      @sql_db = Moodeo::DB.new('moodeo.db')
      @user = @db.create_user("Jose", "JoseJose", "12345")
   end

   # Error
   it "should not sign in and return an error if name is invalid" do
      result = subject.run(:username => "someshit", :password => @user.password)
      expect(result.success?).to eq false
      # expect(result.error).to eq(:invalid_username)
   end

   it "should not sign in and return an error if password is invalid" do
     result = subject.run(:username => @user.username, :password => "xyz")
     expect(result.success?).to eq false
     # expect(result.error).to eq(:invalid_password)
   end

   # Success
   it "should sign the user in with good credentials" do
     result = subject.run(:username => @user.username, :password => @user.password)
     test = @db.get_user_by_session(result.id)
     binding.pry
     expect(result.success?).to eq true
     expect(test).to eq(@user.id)
   end
end
