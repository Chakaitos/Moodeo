require './spec/spec_helper.rb'

describe Moodeo::SignUp do
   before do
      @db = Moodeo.db
      @user = @db.create_user("Jose", "joserb", "123abc")
   end

   # Error
   it "should not let user sign up if the name is taken" do
      result = subject.run(:name => "jose", :username => "joserb", :password => "abc123")
      expect(result.success?).to eq false
      expect(result.error).to eq(:username_taken)
   end

   it "should not let user sign up if the password is less than 5 characters" do
     result = subject.run(:name => "drew", :username => "joserbdf", :password => "2345")
     expect(result.success?).to eq false
     expect(result.error).to eq(:weak_password)
   end

    # Success
   it "adds a user if the user inputs the correct information" do
      result = subject.run(:name => "Drew", :username => "drewv", :password => "abc123")
      expect(result.success?).to eq true
   end
end
