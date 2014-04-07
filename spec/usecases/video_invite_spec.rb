require './spec/spec_helper.rb'

describe Moodeo::VideoInvite do
  before do 
    @db = Moodeo.db
    @user1 = @db.create_user("j","jay","123")
    @user2 = @db.create_user("k","kay","123")
  end
    
    it "returns error if invitee doesn't exist" do 
    session = @db.create_session(@user1.id)
    result = subject.run(:session_id => session.id, :invitee_id => 300)
    expect(result.error).to eq(:invitee_not_found)
  end

    it "works"  do 
      session = @db.create_session(@user1.id)
      result = subject.run(:session_id => session.id, :invitee_id => @user2.id, :status => "pending")
      expect(result.success?).to eq(true)
    end
end